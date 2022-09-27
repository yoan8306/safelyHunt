//
//  TestMonitoringServices.swift
//  SafelyHuntTests
//
//  Created by Yoan on 26/09/2022.
//

import XCTest
@testable import SafelyHunt
import CoreLocation

final class TestMonitoringServices: XCTestCase {
    var monitoringServices = MonitoringServicesMock(monitoring: Monitoring(area: Area()), startMonitoring: false)

    override func setUp() {
        super.setUp()
        monitoringServices = MonitoringServicesMock(monitoring: Monitoring(area: Area()), startMonitoring: false)
    }

    // TestcheckUserIsInRadiusAlert
    func testGivenHuntersIsInRadiusAlertWhenDetectHuntersThenCallBackIsSuccess() {
        // date = 2022-09-14 09:56:23 -> timeStamp = 1663142183
        let dateTimeStampe = 1663142183
        var hunters: [Hunter] = []
        let hunterOne = Hunter()
        hunterOne.displayName = "yoan83"
        hunterOne.longitude = -122.02957434
        hunterOne.latitude = 37.33070248
        hunterOne.date = dateTimeStampe

        let hunterTwo = Hunter()
        hunterTwo.displayName = "yoan8306"
        hunterTwo.longitude = -122.0312186
        hunterTwo.latitude = 37.33233141
        hunterTwo.date = dateTimeStampe

        let hunterThree = Hunter()
        hunterThree.displayName = "yoyo"
        hunterThree.latitude = 37.33233141
        hunterThree.longitude = -122.0312186
        hunterThree.date = dateTimeStampe

        hunters.append(hunterOne)
        hunters.append(hunterTwo)
        hunters.append(hunterThree)

        monitoringServices.fakeData?.hunters = hunters

        // My position
        monitoringServices.monitoring.hunter?.longitude = -122.0312186
        monitoringServices.monitoring.hunter?.latitude = 37.33233141

        monitoringServices.checkUserIsInRadiusAlert { result in
            switch result {
            case .success(let huntersIsInMyRadius):
                XCTAssertTrue(hunters.count == huntersIsInMyRadius.count)
            case .failure(_):
                fatalError()
            }
        }
    }

    /// Test distance travelled
    func testGivenPostionsWhengetCurrenttravelThenReturnDistanceInDouble() {
        let location1 = CLLocation(latitude: 37.33123666, longitude: 122.03076342)
        let location2 = CLLocation(latitude: 37.33115792, longitude: 122.03076154)
        var distance = monitoringServices.monitoring.measureDistanceTravelled(locations: [location1])
       distance = monitoringServices.monitoring.measureDistanceTravelled(locations: [location2])

        XCTAssertTrue(distance * 1000 == monitoringServices.monitoring.currentDistance)
    }

}