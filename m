Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D30408035;
	Fri,  4 Sep 2026 05:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500769; cv=none; b=NnQkFAYTrmoHBnn8b0RSqNCs2cSnRE4Djupd7QNKfdniV8YghLtDlOB/QciVr8FrK21umQJDPtVT7KKDWTcS+T+esJJ9XkMQ2UJDZR5aX+C7zc5UdkqIkSZdI8oq8wMmn4tS9ptV8aLtKWpcb0Ef9iCOiOH7EKMAoNKYffAm2Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500769; c=relaxed/simple;
	bh=Yf34zX7P5uz4hpI6sKsYuF/Zo4pbqSF8UCybWbMymvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0m/PyRWfNTrs4SFTfcbXIeaIia+NMKsTR0a7FbYy4O/s5BTAOk64eAIYdflvwbD4POmU0uhDLrxHCd7+5oUyN31O3Gws2t0JNpka7OqEWSNKDGFLQyfuOoatjceTrxaPD3DlgB7QtrjuD6GIKciAPlppnZzfdO0gC5R65RmT4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBWNB3nI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBWNB3nI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732981F00A3D;
	Fri,  4 Sep 2026 05:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500768;
	bh=lNXRkoM+8TZmCQG4WXcgLK/w7Cls9rgGZNGFKBkzwzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qBWNB3nIZfyme+t1aTHjxdgKssOSB9+RurqdiQU+CXHo7T85GUgDCQAZz+hiIls2H
	 CoVMmQSyCe0kQLC7Pwo4yVBbX65t27FFGOLAG5yReZwZSCACniAooXSBah2r/qffT7
	 W6IzSGGmviOtFf33trFE/S7fcvw6YZ9sVh5tZOgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Eikmeyer <dev@deq.rocks>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 174/552] HID: apple: preserve keyboard backlight across T2 resume
Date: Fri,  4 Sep 2026 06:55:31 +0200
Message-ID: <20260904045752.967307430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Eikmeyer <dev@deq.rocks>

commit 2b5d1495bd101f3d9c13caf3923754f48ee7371a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-apple.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -91,6 +91,9 @@ struct apple_sc_backlight {
 	struct hid_device *hdev;
 };
 
+/* T2 VHCI re-enumerates the internal keyboard across system resume. */
+static int apple_backlight_resume_brightness = -1;
+
 struct apple_backlight_config_report {
 	u8 report_id;
 	u8 version;
@@ -823,6 +826,7 @@ static int apple_backlight_led_set(struc
 static int apple_backlight_init(struct hid_device *hdev)
 {
 	int ret;
+	int brightness;
 	struct apple_sc *asc = hid_get_drvdata(hdev);
 	struct apple_backlight_config_report *rep;
 
@@ -858,13 +862,20 @@ static int apple_backlight_init(struct h
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
 
@@ -997,6 +1008,9 @@ static void apple_remove(struct hid_devi
 
 	if (asc->quirks & APPLE_RDESC_BATTERY)
 		timer_delete_sync(&asc->battery_timer);
+	if (asc->backlight)
+		WRITE_ONCE(apple_backlight_resume_brightness,
+			   asc->backlight->cdev.brightness);
 
 	hid_hw_stop(hdev);
 }


