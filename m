Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75232EC574;
	Mon, 13 Oct 2025 15:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369393; cv=none; b=c9iMrHe6tMWYfzOVWbheVJgcr789cnKZ3jPUOnqt1fH1GWkEo8L5PAnSxBrtRMG0usalNHxvOjH63mM2ZM1oHpGCsD1eZJEPPZJ4OEmujezjMDbeqmR0UFNjF8q0rokibXDgSpoiNWxP/E9nJZ4RLPI3/WgGK2BjvkL+NVGUm0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369393; c=relaxed/simple;
	bh=Ga1v5v7/2xxpS+9Iwojb2Atue+Aa7SiWmUk77z5LzlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Os+5LtDElc8IAAWHHx80uMVkXHVx0HlcACuDHvn8T3+3eQRmvLJweAxhQauuRcxvXg6+iiFKWzYduSJUdOFT3jWuXfHhnbuVdZYXKMXx+QzTqpAoJVbDLT3Jix2gu6jdeGVbdQ10N59DDczaReLgx/6/bc66KzsvFH6prmlCOQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBPjRefK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBPjRefK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DACC4CEE7;
	Mon, 13 Oct 2025 15:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369393;
	bh=Ga1v5v7/2xxpS+9Iwojb2Atue+Aa7SiWmUk77z5LzlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBPjRefKrvNxxCBKX/7SppX2okniyg4sakJxpnMwT7ydYTYH5ZFEQDY0xoze3ouEH
	 r2thzLMWrGgMqnO4OaGWdzjrjxVL+pttYuIcM3hhP0zG1kQZy2sROvECAopeIDoCfI
	 /NXINMn62Vea+Oyr3bShQrzbrW05rvq0l+u0EniQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 229/563] HID: steelseries: refactor probe() and remove()
Date: Mon, 13 Oct 2025 16:41:30 +0200
Message-ID: <20251013144419.576816312@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

[ Upstream commit a84eeacbf9325fd7f604b80f246aaba157730cd5 ]

steelseries_srws1_probe() still does not use devm_kzalloc() and
devm_led_classdev_register(), so there is a lot of code to safely manage
heap, which reduces readability and may cause memory leaks due to minor
patch mistakes in the future.

Therefore, it should be changed to use devm_kzalloc() and
devm_led_classdev_register() to easily and safely manage heap.

Also, the current steelseries driver mainly checks sd->quriks to determine
which product a specific HID device is, which is not the correct way.

remove(), unlike probe(), does not receive struct hid_device_id as an
argument, so it must check hdev unconditionally to know which product
it is.

However, since struct steelseries_device and struct steelseries_srws1_data
have different structures, if SRWS1 is removed in remove(), converts
hdev->dev, which is initialized to struct steelseries_srws1_data,
to struct steelseries_device and uses it. This causes various
memory-related bugs as completely unexpected values exist in member
variables of the structure.

Therefore, in order to modify probe() and remove() to work properly,
Arctis 1, 9 should be added to HID_USB_DEVICE and some functions should be
modified to check hdev->product when determining HID device product.

Fixes: a0c76896c3fb ("HID: steelseries: Add support for Arctis 1 XBox")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h         |   2 +
 drivers/hid/hid-quirks.c      |   2 +
 drivers/hid/hid-steelseries.c | 109 ++++++++++++----------------------
 3 files changed, 43 insertions(+), 70 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 149798754570d..ded5348d190c5 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1296,6 +1296,8 @@
 
 #define USB_VENDOR_ID_STEELSERIES	0x1038
 #define USB_DEVICE_ID_STEELSERIES_SRWS1	0x1410
+#define USB_DEVICE_ID_STEELSERIES_ARCTIS_1  0x12b6
+#define USB_DEVICE_ID_STEELSERIES_ARCTIS_9  0x12c2
 
 #define USB_VENDOR_ID_SUN		0x0430
 #define USB_DEVICE_ID_RARITAN_KVM_DONGLE	0xcdab
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index f619ed10535d7..ffd034566e2e1 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -695,6 +695,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 #endif
 #if IS_ENABLED(CONFIG_HID_STEELSERIES)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_STEELSERIES, USB_DEVICE_ID_STEELSERIES_SRWS1) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_STEELSERIES, USB_DEVICE_ID_STEELSERIES_ARCTIS_1) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_STEELSERIES, USB_DEVICE_ID_STEELSERIES_ARCTIS_9) },
 #endif
 #if IS_ENABLED(CONFIG_HID_SUNPLUS)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
diff --git a/drivers/hid/hid-steelseries.c b/drivers/hid/hid-steelseries.c
index d4bd7848b8c66..8af98d67959e0 100644
--- a/drivers/hid/hid-steelseries.c
+++ b/drivers/hid/hid-steelseries.c
@@ -249,11 +249,11 @@ static int steelseries_srws1_probe(struct hid_device *hdev,
 {
 	int ret, i;
 	struct led_classdev *led;
+	struct steelseries_srws1_data *drv_data;
 	size_t name_sz;
 	char *name;
 
-	struct steelseries_srws1_data *drv_data = kzalloc(sizeof(*drv_data), GFP_KERNEL);
-
+	drv_data = devm_kzalloc(&hdev->dev, sizeof(*drv_data), GFP_KERNEL);
 	if (drv_data == NULL) {
 		hid_err(hdev, "can't alloc SRW-S1 memory\n");
 		return -ENOMEM;
@@ -264,18 +264,18 @@ static int steelseries_srws1_probe(struct hid_device *hdev,
 	ret = hid_parse(hdev);
 	if (ret) {
 		hid_err(hdev, "parse failed\n");
-		goto err_free;
+		goto err;
 	}
 
 	if (!hid_validate_values(hdev, HID_OUTPUT_REPORT, 0, 0, 16)) {
 		ret = -ENODEV;
-		goto err_free;
+		goto err;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
-		goto err_free;
+		goto err;
 	}
 
 	/* register led subsystem */
@@ -288,10 +288,10 @@ static int steelseries_srws1_probe(struct hid_device *hdev,
 	name_sz = strlen(hdev->uniq) + 16;
 
 	/* 'ALL', for setting all LEDs simultaneously */
-	led = kzalloc(sizeof(struct led_classdev)+name_sz, GFP_KERNEL);
+	led = devm_kzalloc(&hdev->dev, sizeof(struct led_classdev)+name_sz, GFP_KERNEL);
 	if (!led) {
 		hid_err(hdev, "can't allocate memory for LED ALL\n");
-		goto err_led;
+		goto out;
 	}
 
 	name = (void *)(&led[1]);
@@ -303,16 +303,18 @@ static int steelseries_srws1_probe(struct hid_device *hdev,
 	led->brightness_set = steelseries_srws1_led_all_set_brightness;
 
 	drv_data->led[SRWS1_NUMBER_LEDS] = led;
-	ret = led_classdev_register(&hdev->dev, led);
-	if (ret)
-		goto err_led;
+	ret = devm_led_classdev_register(&hdev->dev, led);
+	if (ret) {
+		hid_err(hdev, "failed to register LED %d. Aborting.\n", SRWS1_NUMBER_LEDS);
+		goto out; /* let the driver continue without LEDs */
+	}
 
 	/* Each individual LED */
 	for (i = 0; i < SRWS1_NUMBER_LEDS; i++) {
-		led = kzalloc(sizeof(struct led_classdev)+name_sz, GFP_KERNEL);
+		led = devm_kzalloc(&hdev->dev, sizeof(struct led_classdev)+name_sz, GFP_KERNEL);
 		if (!led) {
 			hid_err(hdev, "can't allocate memory for LED %d\n", i);
-			goto err_led;
+			break;
 		}
 
 		name = (void *)(&led[1]);
@@ -324,53 +326,18 @@ static int steelseries_srws1_probe(struct hid_device *hdev,
 		led->brightness_set = steelseries_srws1_led_set_brightness;
 
 		drv_data->led[i] = led;
-		ret = led_classdev_register(&hdev->dev, led);
+		ret = devm_led_classdev_register(&hdev->dev, led);
 
 		if (ret) {
 			hid_err(hdev, "failed to register LED %d. Aborting.\n", i);
-err_led:
-			/* Deregister all LEDs (if any) */
-			for (i = 0; i < SRWS1_NUMBER_LEDS + 1; i++) {
-				led = drv_data->led[i];
-				drv_data->led[i] = NULL;
-				if (!led)
-					continue;
-				led_classdev_unregister(led);
-				kfree(led);
-			}
-			goto out;	/* but let the driver continue without LEDs */
+			break;	/* but let the driver continue without LEDs */
 		}
 	}
 out:
 	return 0;
-err_free:
-	kfree(drv_data);
+err:
 	return ret;
 }
-
-static void steelseries_srws1_remove(struct hid_device *hdev)
-{
-	int i;
-	struct led_classdev *led;
-
-	struct steelseries_srws1_data *drv_data = hid_get_drvdata(hdev);
-
-	if (drv_data) {
-		/* Deregister LEDs (if any) */
-		for (i = 0; i < SRWS1_NUMBER_LEDS + 1; i++) {
-			led = drv_data->led[i];
-			drv_data->led[i] = NULL;
-			if (!led)
-				continue;
-			led_classdev_unregister(led);
-			kfree(led);
-		}
-
-	}
-
-	hid_hw_stop(hdev);
-	kfree(drv_data);
-}
 #endif
 
 #define STEELSERIES_HEADSET_BATTERY_TIMEOUT_MS	3000
@@ -405,13 +372,12 @@ static int steelseries_headset_request_battery(struct hid_device *hdev,
 
 static void steelseries_headset_fetch_battery(struct hid_device *hdev)
 {
-	struct steelseries_device *sd = hid_get_drvdata(hdev);
 	int ret = 0;
 
-	if (sd->quirks & STEELSERIES_ARCTIS_1)
+	if (hdev->product == USB_DEVICE_ID_STEELSERIES_ARCTIS_1)
 		ret = steelseries_headset_request_battery(hdev,
 			arctis_1_battery_request, sizeof(arctis_1_battery_request));
-	else if (sd->quirks & STEELSERIES_ARCTIS_9)
+	else if (hdev->product == USB_DEVICE_ID_STEELSERIES_ARCTIS_9)
 		ret = steelseries_headset_request_battery(hdev,
 			arctis_9_battery_request, sizeof(arctis_9_battery_request));
 
@@ -567,14 +533,7 @@ static int steelseries_probe(struct hid_device *hdev, const struct hid_device_id
 	struct steelseries_device *sd;
 	int ret;
 
-	sd = devm_kzalloc(&hdev->dev, sizeof(*sd), GFP_KERNEL);
-	if (!sd)
-		return -ENOMEM;
-	hid_set_drvdata(hdev, sd);
-	sd->hdev = hdev;
-	sd->quirks = id->driver_data;
-
-	if (sd->quirks & STEELSERIES_SRWS1) {
+	if (hdev->product == USB_DEVICE_ID_STEELSERIES_SRWS1) {
 #if IS_BUILTIN(CONFIG_LEDS_CLASS) || \
     (IS_MODULE(CONFIG_LEDS_CLASS) && IS_MODULE(CONFIG_HID_STEELSERIES))
 		return steelseries_srws1_probe(hdev, id);
@@ -583,6 +542,13 @@ static int steelseries_probe(struct hid_device *hdev, const struct hid_device_id
 #endif
 	}
 
+	sd = devm_kzalloc(&hdev->dev, sizeof(*sd), GFP_KERNEL);
+	if (!sd)
+		return -ENOMEM;
+	hid_set_drvdata(hdev, sd);
+	sd->hdev = hdev;
+	sd->quirks = id->driver_data;
+
 	ret = hid_parse(hdev);
 	if (ret)
 		return ret;
@@ -610,17 +576,19 @@ static int steelseries_probe(struct hid_device *hdev, const struct hid_device_id
 
 static void steelseries_remove(struct hid_device *hdev)
 {
-	struct steelseries_device *sd = hid_get_drvdata(hdev);
+	struct steelseries_device *sd;
 	unsigned long flags;
 
-	if (sd->quirks & STEELSERIES_SRWS1) {
+	if (hdev->product == USB_DEVICE_ID_STEELSERIES_SRWS1) {
 #if IS_BUILTIN(CONFIG_LEDS_CLASS) || \
     (IS_MODULE(CONFIG_LEDS_CLASS) && IS_MODULE(CONFIG_HID_STEELSERIES))
-		steelseries_srws1_remove(hdev);
+		goto srws1_remove;
 #endif
 		return;
 	}
 
+	sd = hid_get_drvdata(hdev);
+
 	spin_lock_irqsave(&sd->lock, flags);
 	sd->removed = true;
 	spin_unlock_irqrestore(&sd->lock, flags);
@@ -628,6 +596,7 @@ static void steelseries_remove(struct hid_device *hdev)
 	cancel_delayed_work_sync(&sd->battery_work);
 
 	hid_hw_close(hdev);
+srws1_remove:
 	hid_hw_stop(hdev);
 }
 
@@ -667,10 +636,10 @@ static int steelseries_headset_raw_event(struct hid_device *hdev,
 	unsigned long flags;
 
 	/* Not a headset */
-	if (sd->quirks & STEELSERIES_SRWS1)
+	if (hdev->product == USB_DEVICE_ID_STEELSERIES_SRWS1)
 		return 0;
 
-	if (sd->quirks & STEELSERIES_ARCTIS_1) {
+	if (hdev->product == USB_DEVICE_ID_STEELSERIES_ARCTIS_1) {
 		hid_dbg(sd->hdev,
 			"Parsing raw event for Arctis 1 headset (%*ph)\n", size, read_buf);
 		if (size < ARCTIS_1_BATTERY_RESPONSE_LEN ||
@@ -688,7 +657,7 @@ static int steelseries_headset_raw_event(struct hid_device *hdev,
 		}
 	}
 
-	if (sd->quirks & STEELSERIES_ARCTIS_9) {
+	if (hdev->product == USB_DEVICE_ID_STEELSERIES_ARCTIS_9) {
 		hid_dbg(sd->hdev,
 			"Parsing raw event for Arctis 9 headset (%*ph)\n", size, read_buf);
 		if (size < ARCTIS_9_BATTERY_RESPONSE_LEN) {
@@ -757,11 +726,11 @@ static const struct hid_device_id steelseries_devices[] = {
 	  .driver_data = STEELSERIES_SRWS1 },
 
 	{ /* SteelSeries Arctis 1 Wireless for XBox */
-	  HID_USB_DEVICE(USB_VENDOR_ID_STEELSERIES, 0x12b6),
-	.driver_data = STEELSERIES_ARCTIS_1 },
+	  HID_USB_DEVICE(USB_VENDOR_ID_STEELSERIES, USB_DEVICE_ID_STEELSERIES_ARCTIS_1),
+	  .driver_data = STEELSERIES_ARCTIS_1 },
 
 	{ /* SteelSeries Arctis 9 Wireless for XBox */
-	  HID_USB_DEVICE(USB_VENDOR_ID_STEELSERIES, 0x12c2),
+	  HID_USB_DEVICE(USB_VENDOR_ID_STEELSERIES, USB_DEVICE_ID_STEELSERIES_ARCTIS_9),
 	  .driver_data = STEELSERIES_ARCTIS_9 },
 
 	{ }
-- 
2.51.0



