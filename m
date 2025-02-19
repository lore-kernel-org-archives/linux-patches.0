Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3B11E51F8;
	Wed, 19 Feb 2025 09:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955789; cv=none; b=Sbwwzl9oaTmuXtDFbnLF32VCnHwWiG9IGEuaBakFYXaHsOnmpg9HsjS4M30XQLIdQbGrUlUzQ8InRbNJo7SRWs7kignXLZpE7FacM2NzWV7oXfMgYRKZ2gowKFdbD7vjp3cLVx9AQW2nbzLQvV39EuFMsCKStzPxORm6GxdbRic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955789; c=relaxed/simple;
	bh=/C+CJePoFVSl4oEXPQ1hQvSKX6QJ7J+ylswQw8z+IqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPl2r+YGNz/k6K4R1C7iMOf4xRtKvp00ODSA2wDYz4QOaHaf2l7bfApRn/w7uxwAS+wIybZzQ2XxEVvSTUbzKNzS/MqwhvIiy/sFZH2WJaNIrp59hzWjC9vauYJrCY9f5E7NVNz5WRM/fh4UG1hQprS9f5V1In7DZyzL3Tr6NY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9MUEU0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9MUEU0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E427C4CED1;
	Wed, 19 Feb 2025 09:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955789;
	bh=/C+CJePoFVSl4oEXPQ1hQvSKX6QJ7J+ylswQw8z+IqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9MUEU0TDCD6ymEg4jFd5qPtt1OFazlAycSQHm4oWKsXLAzSsAczd2VJmrmT8RSDc
	 K11BOo+315D+ThvpSjgnD1Ji8WU41jjN+YZ4qCkDB9E5xrPXY80ap6t1vJnWkkUFgw
	 9VCTTQCW/h2Wn2uTZvxhiy7IHbGKx8q4BUX25Jhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/152] HID: hid-steam: Add gamepad-only mode switched to by holding options
Date: Wed, 19 Feb 2025 09:28:48 +0100
Message-ID: <20250219082554.606788496@linuxfoundation.org>
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

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit cd438e57dd05b077f4e87c1567beafb2377b6d6b ]

This commit adds a hotkey to switch between "gamepad" mode (mouse and keyboard
disabled) and "desktop" mode (gamepad disabled) by holding down the options
button (mapped here as the start button). This mirrors the behavior of the
official Steam client.

This also adds and uses a function for generating haptic pulses, as Steam also
does when engaging this hotkey.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 79504249d7e2 ("HID: hid-steam: Move hidraw input (un)registering to work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 113 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 103 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 991db5acf5ddb..2f87026f01de1 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -273,6 +273,11 @@ enum {
 	TRACKPAD_GESTURE_KEYBOARD,
 };
 
+/* Pad identifiers for the deck */
+#define STEAM_PAD_LEFT 0
+#define STEAM_PAD_RIGHT 1
+#define STEAM_PAD_BOTH 2
+
 /* Other random constants */
 #define STEAM_SERIAL_LEN 10
 
@@ -291,6 +296,9 @@ struct steam_device {
 	struct power_supply __rcu *battery;
 	u8 battery_charge;
 	u16 voltage;
+	struct delayed_work mode_switch;
+	bool did_mode_switch;
+	bool gamepad_mode;
 	struct work_struct rumble_work;
 	u16 rumble_left;
 	u16 rumble_right;
@@ -459,6 +467,37 @@ static inline int steam_request_conn_status(struct steam_device *steam)
 	return ret;
 }
 
+/*
+ * Send a haptic pulse to the trackpads
+ * Duration and interval are measured in microseconds, count is the number
+ * of pulses to send for duration time with interval microseconds between them
+ * and gain is measured in decibels, ranging from -24 to +6
+ */
+static inline int steam_haptic_pulse(struct steam_device *steam, u8 pad,
+				u16 duration, u16 interval, u16 count, u8 gain)
+{
+	int ret;
+	u8 report[10] = {ID_TRIGGER_HAPTIC_PULSE, 8};
+
+	/* Left and right are swapped on this report for legacy reasons */
+	if (pad < STEAM_PAD_BOTH)
+		pad ^= 1;
+
+	report[2] = pad;
+	report[3] = duration & 0xFF;
+	report[4] = duration >> 8;
+	report[5] = interval & 0xFF;
+	report[6] = interval >> 8;
+	report[7] = count & 0xFF;
+	report[8] = count >> 8;
+	report[9] = gain;
+
+	mutex_lock(&steam->report_mutex);
+	ret = steam_send_report(steam, report, sizeof(report));
+	mutex_unlock(&steam->report_mutex);
+	return ret;
+}
+
 static inline int steam_haptic_rumble(struct steam_device *steam,
 				u16 intensity, u16 left_speed, u16 right_speed,
 				u8 left_gain, u8 right_gain)
@@ -504,6 +543,9 @@ static int steam_play_effect(struct input_dev *dev, void *data,
 
 static void steam_set_lizard_mode(struct steam_device *steam, bool enable)
 {
+	if (steam->gamepad_mode)
+		enable = false;
+
 	if (enable) {
 		mutex_lock(&steam->report_mutex);
 		/* enable esc, enter, cursors */
@@ -541,11 +583,18 @@ static int steam_input_open(struct input_dev *dev)
 	unsigned long flags;
 	bool set_lizard_mode;
 
-	spin_lock_irqsave(&steam->lock, flags);
-	set_lizard_mode = !steam->client_opened && lizard_mode;
-	spin_unlock_irqrestore(&steam->lock, flags);
-	if (set_lizard_mode)
-		steam_set_lizard_mode(steam, false);
+	/*
+	 * Disabling lizard mode automatically is only done on the Steam
+	 * Controller. On the Steam Deck, this is toggled manually by holding
+	 * the options button instead, handled by steam_mode_switch_cb.
+	 */
+	if (!(steam->quirks & STEAM_QUIRK_DECK)) {
+		spin_lock_irqsave(&steam->lock, flags);
+		set_lizard_mode = !steam->client_opened && lizard_mode;
+		spin_unlock_irqrestore(&steam->lock, flags);
+		if (set_lizard_mode)
+			steam_set_lizard_mode(steam, false);
+	}
 
 	return 0;
 }
@@ -556,11 +605,13 @@ static void steam_input_close(struct input_dev *dev)
 	unsigned long flags;
 	bool set_lizard_mode;
 
-	spin_lock_irqsave(&steam->lock, flags);
-	set_lizard_mode = !steam->client_opened && lizard_mode;
-	spin_unlock_irqrestore(&steam->lock, flags);
-	if (set_lizard_mode)
-		steam_set_lizard_mode(steam, true);
+	if (!(steam->quirks & STEAM_QUIRK_DECK)) {
+		spin_lock_irqsave(&steam->lock, flags);
+		set_lizard_mode = !steam->client_opened && lizard_mode;
+		spin_unlock_irqrestore(&steam->lock, flags);
+		if (set_lizard_mode)
+			steam_set_lizard_mode(steam, true);
+	}
 }
 
 static enum power_supply_property steam_battery_props[] = {
@@ -885,6 +936,34 @@ static void steam_work_connect_cb(struct work_struct *work)
 	}
 }
 
+static void steam_mode_switch_cb(struct work_struct *work)
+{
+	struct steam_device *steam = container_of(to_delayed_work(work),
+							struct steam_device, mode_switch);
+	unsigned long flags;
+	bool client_opened;
+	steam->gamepad_mode = !steam->gamepad_mode;
+	if (!lizard_mode)
+		return;
+
+	if (steam->gamepad_mode)
+		steam_set_lizard_mode(steam, false);
+	else {
+		spin_lock_irqsave(&steam->lock, flags);
+		client_opened = steam->client_opened;
+		spin_unlock_irqrestore(&steam->lock, flags);
+		if (!client_opened)
+			steam_set_lizard_mode(steam, lizard_mode);
+	}
+
+	steam_haptic_pulse(steam, STEAM_PAD_RIGHT, 0x190, 0, 1, 0);
+	if (steam->gamepad_mode) {
+		steam_haptic_pulse(steam, STEAM_PAD_LEFT, 0x14D, 0x14D, 0x2D, 0);
+	} else {
+		steam_haptic_pulse(steam, STEAM_PAD_LEFT, 0x1F4, 0x1F4, 0x1E, 0);
+	}
+}
+
 static bool steam_is_valve_interface(struct hid_device *hdev)
 {
 	struct hid_report_enum *rep_enum;
@@ -1039,6 +1118,7 @@ static int steam_probe(struct hid_device *hdev,
 	mutex_init(&steam->report_mutex);
 	steam->quirks = id->driver_data;
 	INIT_WORK(&steam->work_connect, steam_work_connect_cb);
+	INIT_DELAYED_WORK(&steam->mode_switch, steam_mode_switch_cb);
 	INIT_LIST_HEAD(&steam->list);
 	INIT_WORK(&steam->rumble_work, steam_haptic_rumble_cb);
 
@@ -1096,6 +1176,7 @@ static int steam_probe(struct hid_device *hdev,
 hid_hw_open_fail:
 hid_hw_start_fail:
 	cancel_work_sync(&steam->work_connect);
+	cancel_delayed_work_sync(&steam->mode_switch);
 	cancel_work_sync(&steam->rumble_work);
 steam_alloc_fail:
 	hid_err(hdev, "%s: failed with error %d\n",
@@ -1112,6 +1193,7 @@ static void steam_remove(struct hid_device *hdev)
 		return;
 	}
 
+	cancel_delayed_work_sync(&steam->mode_switch);
 	cancel_work_sync(&steam->work_connect);
 	hid_destroy_device(steam->client_hdev);
 	steam->client_hdev = NULL;
@@ -1397,6 +1479,17 @@ static void steam_do_deck_input_event(struct steam_device *steam,
 	b13 = data[13];
 	b14 = data[14];
 
+	if (!(b9 & BIT(6)) && steam->did_mode_switch) {
+		steam->did_mode_switch = false;
+		cancel_delayed_work_sync(&steam->mode_switch);
+	} else if (!steam->client_opened && (b9 & BIT(6)) && !steam->did_mode_switch) {
+		steam->did_mode_switch = true;
+		schedule_delayed_work(&steam->mode_switch, 45 * HZ / 100);
+	}
+
+	if (!steam->gamepad_mode)
+		return;
+
 	lpad_touched = b10 & BIT(3);
 	rpad_touched = b10 & BIT(4);
 
-- 
2.39.5



