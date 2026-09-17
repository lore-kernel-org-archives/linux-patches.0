Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EED33A9D90;
	Thu, 17 Sep 2026 19:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671634; cv=none; b=oJLQmqFws/fJe9AjGtDQsRCJoDKYMSS3kdJE2N77zCfWm2ULhVqB56lIqf7prhWnTbWI+Hl4aAJBcaU4uOS3ykxySJJRrzo0RxuVhcs0o2R2Rp1d49AXKs18AkGdy+Lc4uoOoIzjYwJs/cnfXRXHsiq3vzR90fDty5n6++kMvkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671634; c=relaxed/simple;
	bh=yKOIJPxNA2QZHaPqJcgwz9mgW1eeabQL14GEubneqj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVHM0pbkyyRiYByEMcRioCFMCNveRg5xDZodxjSvBvJ2Np2qpNFSFXZvw0J0cpELUt6AyG1uV33p7JSQcYuMu15HcR+4nKeLMwfB7+Bf6v120oy6UWvJYOkltIjR76rjzz47NiQcSYAkGoAPuDcWvXC/T2C4mu6pDwp9J2w8ZVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlD7luQ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlD7luQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B911F000FF;
	Thu, 17 Sep 2026 19:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671633;
	bh=Y3R535s33YTIzjbx0dMN6mZk9EncPNCllEuQL6vy/8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MlD7luQ6qm2+47EzzWJtCu1M/EjLztszyZGRkLXbg79YJkScWJj89DBLbj77TpBT0
	 /Q22orwmHZF/9pXnrtFYhShG6Gbrwr7DKMOGI+vzUCXk7Xc8mx22cW1S5FYwAFKyxg
	 StPzw5AHe7ajLDkpcfFtoXupaSG29J0H6Fx4P99A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Eikmeyer <dev@deq.rocks>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1039/1102] HID: apple: preserve keyboard backlight across T2 resume
Date: Thu, 17 Sep 2026 16:16:22 +0100
Message-ID: <20260917151606.871413734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Eikmeyer <dev@deq.rocks>

[ Upstream commit 2b5d1495bd101f3d9c13caf3923754f48ee7371a ]

The T2 virtual USB host controller re-enumerates the internal keyboard
after system resume. The butterfly keyboard backlight currently uses
LED_CORE_SUSPENDRESUME, so the LED core sends a blocking request to the
old HID device while it is disappearing. That request fails with -ENODEV
and the newly probed device starts with its backlight off.

To fix this, we cache the requested brightness when the old HID device is
removed and restore it when the replacement is probed. We let
re-enumeration handle restoration instead of issuing a request through the
stale device.

Fixes: 1f95a6cd5ad7 ("HID: apple: ensure the keyboard backlight is off if suspending")
Cc: stable@vger.kernel.org
Signed-off-by: Andre Eikmeyer <dev@deq.rocks>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[ preserved 6.12 structure placement and del_timer_sync() API while adding the upstream cached-brightness state and logic. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-apple.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -89,6 +89,9 @@ struct apple_sc_backlight {
 	struct hid_device *hdev;
 };
 
+/* T2 VHCI re-enumerates the internal keyboard across system resume. */
+static int apple_backlight_resume_brightness = -1;
+
 struct apple_magic_backlight {
 	struct led_classdev cdev;
 	struct hid_report *brightness;
@@ -797,6 +800,7 @@ static int apple_backlight_led_set(struc
 static int apple_backlight_init(struct hid_device *hdev)
 {
 	int ret;
+	int brightness;
 	struct apple_sc *asc = hid_get_drvdata(hdev);
 	struct apple_backlight_config_report *rep;
 
@@ -832,13 +836,20 @@ static int apple_backlight_init(struct h
 	asc->backlight->cdev.name = "apple::kbd_backlight";
 	asc->backlight->cdev.max_brightness = rep->backlight_on_max;
 	asc->backlight->cdev.brightness_set_blocking = apple_backlight_led_set;
-	asc->backlight->cdev.flags = LED_CORE_SUSPENDRESUME;
+	/* VHCI re-enumeration restores the cached brightness in the next probe. */
+
+	brightness = READ_ONCE(apple_backlight_resume_brightness);
+	if (brightness < 0)
+		brightness = LED_OFF;
+	else
+		brightness = min_t(int, brightness, rep->backlight_on_max);
 
-	ret = apple_backlight_set(hdev, 0, 0);
+	ret = apple_backlight_set(hdev, brightness, 0);
 	if (ret < 0) {
 		hid_err(hdev, "backlight set request failed: %d\n", ret);
 		goto cleanup_and_exit;
 	}
+	asc->backlight->cdev.brightness = brightness;
 
 	ret = devm_led_classdev_register(&hdev->dev, &asc->backlight->cdev);
 
@@ -971,6 +982,9 @@ static void apple_remove(struct hid_devi
 
 	if (asc->quirks & APPLE_RDESC_BATTERY)
 		del_timer_sync(&asc->battery_timer);
+	if (asc->backlight)
+		WRITE_ONCE(apple_backlight_resume_brightness,
+			   asc->backlight->cdev.brightness);
 
 	hid_hw_stop(hdev);
 }


