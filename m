Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A381C701E;
	Wed, 19 Feb 2025 09:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955802; cv=none; b=chOcfw17UzCMT7UJgy0z8/CDIYvnWn6flAdIDxWxVmgHtwwV82gjrr7McdphGAWmXGyuo/d28XtdZMIxb3ILiSbmmfGohURxj2b2/7zIaTRUzBncnrll9yvSZ67zblJrBppnqQVnm+2TdkC4lsb9GdyRWhs68K6qoxQln2NsimQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955802; c=relaxed/simple;
	bh=EH0DPQQzNVAKUd6BE6aZ60nSe77MeLMTnSGPRHqgsLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/WprP2kOzZxP0QJdOu9NFSogfqkRnK/ZdrCDBcVlGxSaG4jI/jc59Kj1jgc8qMf46QeIKx3X3BDeA2PCZlNps5Rn3qHCPFxjF8LLfNHaz64amEYVcOnhOEFoXOnIAwufeGMrGuMVf8m9rvW4g4CU90kGvbUUhSSWPIQR8fla+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXFmv1uI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXFmv1uI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1222C4CED1;
	Wed, 19 Feb 2025 09:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955802;
	bh=EH0DPQQzNVAKUd6BE6aZ60nSe77MeLMTnSGPRHqgsLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXFmv1uIQoZ3KIv50W6lTngIgX4dPIqa/YSrKchwCsK7FLlEM9+C+dIJ20d05Fvmo
	 pbHz2RkBo3wk1XsKC+jAaT4qGlAQb9QbpBMCyqvK5TL13wVMqclMk1OyqxrNcBwqMn
	 1eSw7HSNMGODt4dYNU3gaNfGTqGgm0L/sVckBaNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Maisel <mmm-1@posteo.net>,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/152] HID: hid-steam: Add Deck IMU support
Date: Wed, 19 Feb 2025 09:28:51 +0100
Message-ID: <20250219082554.723957704@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Maisel <mmm-1@posteo.net>

[ Upstream commit 3347e1654f24dbbd357ea4e3c0d8dcc12d8586c7 ]

The Deck's controller features an accelerometer and gyroscope which
send their measurement values by default in the main HID input report.
Expose both sensors to userspace through a separate evdev node as it
is done by the hid-nintendo and hid-playstation drivers.

Signed-off-by: Max Maisel <mmm-1@posteo.net>
Reviewed-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 79504249d7e2 ("HID: hid-steam: Move hidraw input (un)registering to work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 155 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 147 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 59b46163bc526..29a0e1f395339 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -66,6 +66,14 @@ static LIST_HEAD(steam_devices);
 #define STEAM_DECK_TRIGGER_RESOLUTION 5461
 /* Joystick runs are about 5 mm and 32768 units */
 #define STEAM_DECK_JOYSTICK_RESOLUTION 6553
+/* Accelerometer has 16 bit resolution and a range of +/- 2g */
+#define STEAM_DECK_ACCEL_RES_PER_G 16384
+#define STEAM_DECK_ACCEL_RANGE 32768
+#define STEAM_DECK_ACCEL_FUZZ 32
+/* Gyroscope has 16 bit resolution and a range of +/- 2000 dps */
+#define STEAM_DECK_GYRO_RES_PER_DPS 16
+#define STEAM_DECK_GYRO_RANGE 32768
+#define STEAM_DECK_GYRO_FUZZ 1
 
 #define STEAM_PAD_FUZZ 256
 
@@ -288,6 +296,7 @@ struct steam_device {
 	struct mutex report_mutex;
 	bool client_opened;
 	struct input_dev __rcu *input;
+	struct input_dev __rcu *sensors;
 	unsigned long quirks;
 	struct work_struct work_connect;
 	bool connected;
@@ -302,6 +311,7 @@ struct steam_device {
 	struct work_struct rumble_work;
 	u16 rumble_left;
 	u16 rumble_right;
+	unsigned int sensor_timestamp_us;
 };
 
 static int steam_recv_report(struct steam_device *steam,
@@ -824,6 +834,74 @@ static int steam_input_register(struct steam_device *steam)
 	return ret;
 }
 
+static int steam_sensors_register(struct steam_device *steam)
+{
+	struct hid_device *hdev = steam->hdev;
+	struct input_dev *sensors;
+	int ret;
+
+	if (!(steam->quirks & STEAM_QUIRK_DECK))
+		return 0;
+
+	rcu_read_lock();
+	sensors = rcu_dereference(steam->sensors);
+	rcu_read_unlock();
+	if (sensors) {
+		dbg_hid("%s: already connected\n", __func__);
+		return 0;
+	}
+
+	sensors = input_allocate_device();
+	if (!sensors)
+		return -ENOMEM;
+
+	input_set_drvdata(sensors, steam);
+	sensors->dev.parent = &hdev->dev;
+
+	sensors->name = "Steam Deck Motion Sensors";
+	sensors->phys = hdev->phys;
+	sensors->uniq = steam->serial_no;
+	sensors->id.bustype = hdev->bus;
+	sensors->id.vendor = hdev->vendor;
+	sensors->id.product = hdev->product;
+	sensors->id.version = hdev->version;
+
+	__set_bit(INPUT_PROP_ACCELEROMETER, sensors->propbit);
+	__set_bit(EV_MSC, sensors->evbit);
+	__set_bit(MSC_TIMESTAMP, sensors->mscbit);
+
+	input_set_abs_params(sensors, ABS_X, -STEAM_DECK_ACCEL_RANGE,
+			STEAM_DECK_ACCEL_RANGE, STEAM_DECK_ACCEL_FUZZ, 0);
+	input_set_abs_params(sensors, ABS_Y, -STEAM_DECK_ACCEL_RANGE,
+			STEAM_DECK_ACCEL_RANGE, STEAM_DECK_ACCEL_FUZZ, 0);
+	input_set_abs_params(sensors, ABS_Z, -STEAM_DECK_ACCEL_RANGE,
+			STEAM_DECK_ACCEL_RANGE, STEAM_DECK_ACCEL_FUZZ, 0);
+	input_abs_set_res(sensors, ABS_X, STEAM_DECK_ACCEL_RES_PER_G);
+	input_abs_set_res(sensors, ABS_Y, STEAM_DECK_ACCEL_RES_PER_G);
+	input_abs_set_res(sensors, ABS_Z, STEAM_DECK_ACCEL_RES_PER_G);
+
+	input_set_abs_params(sensors, ABS_RX, -STEAM_DECK_GYRO_RANGE,
+			STEAM_DECK_GYRO_RANGE, STEAM_DECK_GYRO_FUZZ, 0);
+	input_set_abs_params(sensors, ABS_RY, -STEAM_DECK_GYRO_RANGE,
+			STEAM_DECK_GYRO_RANGE, STEAM_DECK_GYRO_FUZZ, 0);
+	input_set_abs_params(sensors, ABS_RZ, -STEAM_DECK_GYRO_RANGE,
+			STEAM_DECK_GYRO_RANGE, STEAM_DECK_GYRO_FUZZ, 0);
+	input_abs_set_res(sensors, ABS_RX, STEAM_DECK_GYRO_RES_PER_DPS);
+	input_abs_set_res(sensors, ABS_RY, STEAM_DECK_GYRO_RES_PER_DPS);
+	input_abs_set_res(sensors, ABS_RZ, STEAM_DECK_GYRO_RES_PER_DPS);
+
+	ret = input_register_device(sensors);
+	if (ret)
+		goto sensors_register_fail;
+
+	rcu_assign_pointer(steam->sensors, sensors);
+	return 0;
+
+sensors_register_fail:
+	input_free_device(sensors);
+	return ret;
+}
+
 static void steam_input_unregister(struct steam_device *steam)
 {
 	struct input_dev *input;
@@ -837,6 +915,24 @@ static void steam_input_unregister(struct steam_device *steam)
 	input_unregister_device(input);
 }
 
+static void steam_sensors_unregister(struct steam_device *steam)
+{
+	struct input_dev *sensors;
+
+	if (!(steam->quirks & STEAM_QUIRK_DECK))
+		return;
+
+	rcu_read_lock();
+	sensors = rcu_dereference(steam->sensors);
+	rcu_read_unlock();
+
+	if (!sensors)
+		return;
+	RCU_INIT_POINTER(steam->sensors, NULL);
+	synchronize_rcu();
+	input_unregister_device(sensors);
+}
+
 static void steam_battery_unregister(struct steam_device *steam)
 {
 	struct power_supply *battery;
@@ -889,18 +985,28 @@ static int steam_register(struct steam_device *steam)
 	spin_lock_irqsave(&steam->lock, flags);
 	client_opened = steam->client_opened;
 	spin_unlock_irqrestore(&steam->lock, flags);
+
 	if (!client_opened) {
 		steam_set_lizard_mode(steam, lizard_mode);
 		ret = steam_input_register(steam);
-	} else
-		ret = 0;
+		if (ret != 0)
+			goto steam_register_input_fail;
+		ret = steam_sensors_register(steam);
+		if (ret != 0)
+			goto steam_register_sensors_fail;
+	}
+	return 0;
 
+steam_register_sensors_fail:
+	steam_input_unregister(steam);
+steam_register_input_fail:
 	return ret;
 }
 
 static void steam_unregister(struct steam_device *steam)
 {
 	steam_battery_unregister(steam);
+	steam_sensors_unregister(steam);
 	steam_input_unregister(steam);
 	if (steam->serial_no[0]) {
 		hid_info(steam->hdev, "Steam Controller '%s' disconnected",
@@ -1009,6 +1115,7 @@ static int steam_client_ll_open(struct hid_device *hdev)
 	steam->client_opened = true;
 	spin_unlock_irqrestore(&steam->lock, flags);
 
+	steam_sensors_unregister(steam);
 	steam_input_unregister(steam);
 
 	return 0;
@@ -1029,6 +1136,7 @@ static void steam_client_ll_close(struct hid_device *hdev)
 	if (connected) {
 		steam_set_lizard_mode(steam, lizard_mode);
 		steam_input_register(steam);
+		steam_sensors_register(steam);
 	}
 }
 
@@ -1120,6 +1228,7 @@ static int steam_probe(struct hid_device *hdev,
 	INIT_DELAYED_WORK(&steam->mode_switch, steam_mode_switch_cb);
 	INIT_LIST_HEAD(&steam->list);
 	INIT_WORK(&steam->rumble_work, steam_haptic_rumble_cb);
+	steam->sensor_timestamp_us = 0;
 
 	/*
 	 * With the real steam controller interface, do not connect hidraw.
@@ -1379,12 +1488,12 @@ static void steam_do_input_event(struct steam_device *steam,
  *  18-19 | s16   | ABS_HAT0Y | left-pad Y value
  *  20-21 | s16   | ABS_HAT1X | right-pad X value
  *  22-23 | s16   | ABS_HAT1Y | right-pad Y value
- *  24-25 | s16   | --        | accelerometer X value
- *  26-27 | s16   | --        | accelerometer Y value
- *  28-29 | s16   | --        | accelerometer Z value
- *  30-31 | s16   | --        | gyro X value
- *  32-33 | s16   | --        | gyro Y value
- *  34-35 | s16   | --        | gyro Z value
+ *  24-25 | s16   | IMU ABS_X | accelerometer X value
+ *  26-27 | s16   | IMU ABS_Z | accelerometer Y value
+ *  28-29 | s16   | IMU ABS_Y | accelerometer Z value
+ *  30-31 | s16   | IMU ABS_RX | gyro X value
+ *  32-33 | s16   | IMU ABS_RZ | gyro Y value
+ *  34-35 | s16   | IMU ABS_RY | gyro Z value
  *  36-37 | s16   | --        | quaternion W value
  *  38-39 | s16   | --        | quaternion X value
  *  40-41 | s16   | --        | quaternion Y value
@@ -1545,6 +1654,32 @@ static void steam_do_deck_input_event(struct steam_device *steam,
 	input_sync(input);
 }
 
+static void steam_do_deck_sensors_event(struct steam_device *steam,
+		struct input_dev *sensors, u8 *data)
+{
+	/*
+	 * The deck input report is received every 4 ms on average,
+	 * with a jitter of +/- 4 ms even though the USB descriptor claims
+	 * that it uses 1 kHz.
+	 * Since the HID report does not include a sensor timestamp,
+	 * use a fixed increment here.
+	 */
+	steam->sensor_timestamp_us += 4000;
+
+	if (!steam->gamepad_mode)
+		return;
+
+	input_event(sensors, EV_MSC, MSC_TIMESTAMP, steam->sensor_timestamp_us);
+	input_report_abs(sensors, ABS_X, steam_le16(data + 24));
+	input_report_abs(sensors, ABS_Z, -steam_le16(data + 26));
+	input_report_abs(sensors, ABS_Y, steam_le16(data + 28));
+	input_report_abs(sensors, ABS_RX, steam_le16(data + 30));
+	input_report_abs(sensors, ABS_RZ, -steam_le16(data + 32));
+	input_report_abs(sensors, ABS_RY, steam_le16(data + 34));
+
+	input_sync(sensors);
+}
+
 /*
  * The size for this message payload is 11.
  * The known values are:
@@ -1582,6 +1717,7 @@ static int steam_raw_event(struct hid_device *hdev,
 {
 	struct steam_device *steam = hid_get_drvdata(hdev);
 	struct input_dev *input;
+	struct input_dev *sensors;
 	struct power_supply *battery;
 
 	if (!steam)
@@ -1627,6 +1763,9 @@ static int steam_raw_event(struct hid_device *hdev,
 		input = rcu_dereference(steam->input);
 		if (likely(input))
 			steam_do_deck_input_event(steam, input, data);
+		sensors = rcu_dereference(steam->sensors);
+		if (likely(sensors))
+			steam_do_deck_sensors_event(steam, sensors, data);
 		rcu_read_unlock();
 		break;
 	case ID_CONTROLLER_WIRELESS:
-- 
2.39.5



