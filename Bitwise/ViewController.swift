//
//  ViewController.swift
//  Bitwise
//
//  Created by Steve Sparks on 8/30/19.
//  Copyright © 2019 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ByteCell: UITableViewCell {
    @IBOutlet var byteView: ByteView?
    @IBOutlet var valueLabel: UILabel?
}

class MyTableViewController: UITableViewController {
    var showValues = true

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "byte") as! ByteCell
        cell.byteView?.value = UInt8(indexPath.row)
        cell.byteView?.showValues = showValues
        cell.valueLabel?.text = "\(indexPath.row)"
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 256
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        showValues = !showValues
        let val = showValues
        for cell in tableView.visibleCells {
            if let cell = cell as? ByteCell, let view = cell.byteView {
                view.showValues = val
                view.setNeedsLayout()
            }
        }
        tableView.reloadData()
        return false
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42.0
    }
}


class BitView: UIView {
    var showValue = true {
        didSet {
            updateDisplay()
        }
    }
    var value: Bool = false {
        didSet {
            updateDisplay()
        }
    }
    var bitIndex: UInt8? {
        didSet {
            updateDisplay()
        }
    }

    var bitLabel: UILabel?

    var sideLength: CGFloat = 40.0 {
        didSet {
            widthConstraint?.constant = sideLength
            heightConstraint?.constant = sideLength
        }
    }

    var onColor = UIColor.blue {
        didSet { updateDisplay() }
    }

    var offColor = UIColor.black {
        didSet { updateDisplay() }
    }

    func updateDisplay() {
        backgroundColor = value ? onColor : offColor
        if let idx = bitIndex, showValue {
            bitLabel?.text = "\(UInt8(1<<idx))"
        } else {
            bitLabel?.text = (value ? "1" : "0")
        }
    }

    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?

    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        widthConstraint = widthAnchor.constraint(equalToConstant: sideLength)
        heightConstraint = heightAnchor.constraint(equalToConstant: sideLength)
        addConstraints([
            widthConstraint!,
            heightConstraint!
            ])
        if bitLabel == nil {
            let bitLabel = UILabel()
            bitLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(bitLabel)
            addConstraint(bitLabel.centerXAnchor.constraint(equalTo: centerXAnchor))
            addConstraint(bitLabel.centerYAnchor.constraint(equalTo: centerYAnchor))
            bitLabel.textColor = .white
            self.bitLabel = bitLabel
        }
    }

    override func layoutSubviews() {
        if widthConstraint == nil {
            setup()
        }
        updateDisplay()
        super.layoutSubviews()
    }
}


class ByteView: UIStackView {
    var showValues = true {
        didSet {
            updateDisplay()
        }
    }

    var orderedViews = [BitView]()
    var value: UInt8 = 0 {
        didSet {
            updateDisplay()
        }
    }

    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        spacing = 2
        self.alignment = .fill
        self.axis = .horizontal
        for idx in 0...7 {
            let ov = BitView()
            ov.bitIndex = UInt8(7 - idx)
            ov.onColor = UIColor(hue: 0.5 + CGFloat(idx) * 0.015, saturation: 1.0, brightness: 0.5, alpha: 1.0)
            addArrangedSubview(ov)
            orderedViews.append(ov)
        }
    }

    override func layoutSubviews() {
        updateDisplay()
        super.layoutSubviews()
    }

    func updateDisplay() {
        if orderedViews.count == 0 {
            setup()
        }
        let val = showValues
        for idx in 0 ... 7 {
            let bitIndex = 7 - idx
            let mask = UInt8(1 << bitIndex)
            let test = (value & mask) == mask
            orderedViews[idx].value = test
            orderedViews[idx].showValue = val
        }
    }

}
