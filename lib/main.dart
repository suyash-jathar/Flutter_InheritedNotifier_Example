import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "Flutter Demo",
    theme: ThemeData(primarySwatch: Colors.blue),
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class SliderData extends ChangeNotifier {
  double _value = 0.0;
  double get value => _value;
  set value(double newValue) {
    if (newValue != value) {
      _value = newValue;
      // IMp
      notifyListeners();
    }
  }
}

// Defining it Globally
final sliderdata = SliderData();

// Created an instance of inherited notifier .It gonna rebuild child whenever it calls notifylistener
// ChangeNotifier hold on to the state - Stays on Top
// Inherited-Notifier -> 
//                      - rebuilds the child 
//                      - Stays at bottom 
//                      - listens to change ChangeNotifier and build child 
class SliderInheritedNotifier extends InheritedNotifier<SliderData> {
  const SliderInheritedNotifier({
    Key? key,
    required SliderData sliderData,
    required Widget child,
  }) : super(
          key:key,
          notifier: sliderData,
          child: child,
        );


        // It gonna return BuildContext 
        // 1. Frst Grab the SliderNotifier 
        //    if it is present then check for notifyListener() and grab it  
        //    if it is present then check for value and grab it . 
      static double of(BuildContext context) =>
        context.
                dependOnInheritedWidgetOfExactType<SliderInheritedNotifier>()
                ?.notifier
                ?.value
                ?? 0.0;

}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: SliderInheritedNotifier(
        sliderData: sliderdata,
        // Builder -> It is used to allow the fresh part of context - 
        //            It consist of all Build-context present in main.dart  
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                Slider(
                  value:  SliderInheritedNotifier.of(context), 
                  onChanged: (value) {
                    sliderdata.value=value;
                  }
                  ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        color: Colors.yellow,
                        height: 200,
                      ),
                    ),
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        color: Colors.blue,
                        height: 200,
                      ),
                    ),
                  ].expandEqually().toList(),
                )
              ],
            );
          }
        ),
      ),
    );
  }
}

extension ExpandEqually on Iterable<Widget> {
  Iterable<Widget> expandEqually() => map((e) {
        return Expanded(
          child: e,
        );
      });
}
