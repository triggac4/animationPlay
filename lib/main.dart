import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _raiseFoot;
  late AnimationController _upwardsMovement;

  @override
  void initState() {
    super.initState();
    _raiseFoot =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _upwardsMovement =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    startMovement();
  }

  void startMovement() {
    _raiseFoot.forward().whenComplete(() {
      _upwardsMovement.forward().whenComplete(() {
        if (isLeftFoot) {
          leftFootPosition =
              leftFootPosition + pushLeft;
        } else {
          rightFootPosition =
              rightFootPosition + pushLeft;
        }
        isLeftFoot = !isLeftFoot;
        if(leftFootPosition>=width||rightFootPosition>=width){
          _upwardsMovement.value=0;
          _raiseFoot.value=0;
          leftFootPosition = 0.0;
          rightFootPosition = 50.0;
          isLeftFoot=true;
          startMovement();
        }else {
          _upwardsMovement.value=0;
          _raiseFoot.value=0;
          startMovement();
        }
      });
      _raiseFoot.reverse();
    });
  }

  bool shouldFootGoDown() {
    return (_raiseFoot.value * 10) + (topHeight * _upwardsMovement.value) >= 30;
  }

  @override
  void dispose() {
    _raiseFoot.dispose();
    _upwardsMovement.dispose();
    super.dispose();
  }

  var leftFootPosition = 0.0;
  var rightFootPosition = 50.0;
  var topHeight = 60;
  var pushLeft = 120;
  bool isLeftFoot = true;
 late double width;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.zero,
          height: 300,
          width: width,
          child: Stack(
            children: [
              AnimatedBuilder(
                  animation: _upwardsMovement,
                  builder: (_, transform) => AnimatedBuilder(
                        animation: _raiseFoot,
                        builder: (_, shoe) => Positioned(
                            left: isLeftFoot
                                ? leftFootPosition +
                                    (pushLeft * _upwardsMovement.value)
                                : leftFootPosition,
                            bottom: isLeftFoot
                                ? shouldFootGoDown()
                                    ? (_raiseFoot.value * 10) +
                                        (topHeight -
                                            (topHeight *
                                                _upwardsMovement.value))
                                    : (_raiseFoot.value * 10) +
                                        (topHeight * _upwardsMovement.value)
                                : 0,
                            child: Transform.rotate(
                              angle: isLeftFoot
                                  ? (45 * _raiseFoot.value) * (math.pi / 180)
                                  : 0,
                              child: Shoe(
                                width: 50,
                                height: 50,
                              ),
                            )),
                      )),
              AnimatedBuilder(
                  animation: _upwardsMovement,
                  builder: (_, transform) => AnimatedBuilder(
                        animation: _raiseFoot,
                        builder: (_, shoe) => Positioned(
                            left: isLeftFoot
                                ? rightFootPosition
                                : rightFootPosition +
                                    (pushLeft * _upwardsMovement.value),
                            bottom: isLeftFoot
                                ? 0
                                : shouldFootGoDown()
                                    ? (_raiseFoot.value * 10) +
                                        (topHeight -
                                            (topHeight *
                                                _upwardsMovement.value))
                                    : (_raiseFoot.value * 10) +
                                        (topHeight * _upwardsMovement.value),
                            child: Transform.rotate(
                              angle: isLeftFoot
                                  ? 0
                                  : (45 * _raiseFoot.value) * (math.pi / 180),
                              child: Shoe(
                                width: 50,
                                height: 50,
                              ),
                            )),
                      )),
            ],
          ),
        ),
      ),
    );
  }
}

class Shoe extends StatelessWidget {
  final double height;
  final double width;

  const Shoe({Key? key, required this.height, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Image.network("https://www.pngrepo.com/png/16764/512/shoes.png"),
    );
  }
}
