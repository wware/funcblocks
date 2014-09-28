n = 60;

module jaw_coupling(L, d, h) {
  union() {
    translate([0, 0, -L]) cylinder(h=L-h/2, d=d, $fn=n);
    difference() {
      translate([0, 0, -1.5*h]) cylinder(h=2*h, d=2*d, $fn=n);
      translate([0, 0, 0.001-h/2]) cylinder(h=h+0.002, d=0.5*d, $fn=n);
      translate([0, 0, 0.001-h/2]) cube([d, d, h+0.002]);
      translate([-d, -d, 0.001-h/2]) cube([d, d, h+0.002]);
    }
  }
}

module cubicalFace(L, W, D, R) {
  module quadrant(L, W, D, R) {
    difference() {
      union() {
        translate([0, 0, 0]) cube([L, W, D]);
        translate([L/3, W, 0]) cylinder(r=2*R, h=D, $fn=n);
        translate([2*L/3, W, 0]) cylinder(r=2*R, h=D, $fn=n);
      };
      translate([L/3, W, -0.1]) cylinder(r=R, h=D+0.2, $fn=n);
      translate([2*L/3, W, -0.1]) cylinder(r=R, h=D+0.2, $fn=n);
    };
  }
  quadrant(L, W, D, R);
  translate([0, 0, D]) rotate([0, 180, -90]) quadrant(L, W, D, R);
  translate([L, 0, 0]) rotate([0, 0, 90]) quadrant(L, W, D, R);
  translate([L, L, 0]) rotate([0, 0, 180]) quadrant(L, W, D, R);
}

module cubicalFrame(L, W, D, R) {
  cubicalFace(L, W, D, R);
  translate([0, 0, L-D]) cubicalFace(L, W, D, R);
  translate([0, D, 0]) rotate([90, 0, 0]) cubicalFace(L, W, D, R);
  translate([0, L, 0]) rotate([90, 0, 0]) cubicalFace(L, W, D, R);
  translate([0, 0, L]) rotate([0, 90, 0]) cubicalFace(L, W, D, R);
  translate([L-D, 0, L]) rotate([0, 90, 0]) cubicalFace(L, W, D, R);
}

module rotSupport(L, W, D, diam, couplingHeight) {
  gap = 0.2;   // depends on printer resolution, this in millimeters
  E = 1.5 * couplingHeight;
  difference() {
    union() {
      translate([0, L/2-W/2, 0]) cube([W, W, E+gap+0.01]);
      translate([L-W, L/2-W/2, 0]) cube([W, W, E+gap+0.01]);
      translate([0, L/2-W/2, E+gap]) cube([L, W, D]);
      translate([L/2, L/2, E+gap]) cylinder(d=1.5*W, h=D, $fn=n);
    }
    translate([L/2, L/2, E]) cylinder(d=diam+2*gap, h=D+2*gap, $fn=n);
  }
}

// millimeters
L = 76.2;  // three inch cube
W = 10;  // fit a 4-40 nut
D = 4;
R = 2.83;  // mounting hole radius, 4-40 machine screw
diam = 4;  // shaft diameter
ch = 4;   // coupling height

cubicalFrame(L, W, D, R);

rotSupport(L, W, D, diam, ch);
translate([0, L, L]) rotate([180, 0, 0]) rotSupport(L, W, D, diam, ch);

translate([L/2, L/2, L]) jaw_coupling(L/2+1, diam, ch);
translate([L/2, L/2, 0]) rotate([180, 0, 0]) jaw_coupling(L/2+1, diam, ch);

