Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838A2569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBE7C433D2;
	Sun, 28 May 2023 19:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301979;
	bh=vx1wOdMEXB9hUy5JPSwyNsaFEGp3RdgeF8ZYrvSuwHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcSYepoh1su9mZLUd5b0qpCX8x1B7lVNW4soqqR5dJZoozicN63aRIxgN2GHj3Jji
	 meGaSHniz6FYANH6GYRrAwwApSqA0V7SK9tLwiGL6fwFbox+tOV6cmlCDoS2qg6Gq/
	 xeidm6cPX+r6GWGXgj4TIdri8cxBvvy4P8Vwahuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Ping Cheng <pinglinux@gmail.com>
Subject: [PATCH 5.4 113/161] HID: wacom: Force pen out of prox if no events have been received in a while
Date: Sun, 28 May 2023 20:10:37 +0100
Message-Id: <20230528190840.664975256@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Gerecke <killertofu@gmail.com>

commit 94b179052f95c294d83e9c9c34f7833cf3cd4305 upstream.

Prox-out events may not be reliably sent by some AES firmware. This can
cause problems for users, particularly due to arbitration logic disabling
touch input while the pen is in prox.

This commit adds a timer which is reset every time a new prox event is
received. When the timer expires we check to see if the pen is still in
prox and force it out if necessary. This is patterend off of the same
solution used by 'hid-letsketch' driver which has a similar problem.

Link: https://github.com/linuxwacom/input-wacom/issues/310
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Ping Cheng <pinglinux@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom.h     |    3 +++
 drivers/hid/wacom_sys.c |    2 ++
 drivers/hid/wacom_wac.c |   39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+)

--- a/drivers/hid/wacom.h
+++ b/drivers/hid/wacom.h
@@ -91,6 +91,7 @@
 #include <linux/leds.h>
 #include <linux/usb/input.h>
 #include <linux/power_supply.h>
+#include <linux/timer.h>
 #include <asm/unaligned.h>
 
 /*
@@ -167,6 +168,7 @@ struct wacom {
 	struct delayed_work init_work;
 	struct wacom_remote *remote;
 	struct work_struct mode_change_work;
+	struct timer_list idleprox_timer;
 	bool generic_has_leds;
 	struct wacom_leds {
 		struct wacom_group_leds *groups;
@@ -239,4 +241,5 @@ struct wacom_led *wacom_led_find(struct
 struct wacom_led *wacom_led_next(struct wacom *wacom, struct wacom_led *cur);
 int wacom_equivalent_usage(int usage);
 int wacom_initialize_leds(struct wacom *wacom);
+void wacom_idleprox_timeout(struct timer_list *list);
 #endif
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2781,6 +2781,7 @@ static int wacom_probe(struct hid_device
 	INIT_WORK(&wacom->battery_work, wacom_battery_work);
 	INIT_WORK(&wacom->remote_work, wacom_remote_work);
 	INIT_WORK(&wacom->mode_change_work, wacom_mode_change_work);
+	timer_setup(&wacom->idleprox_timer, &wacom_idleprox_timeout, TIMER_DEFERRABLE);
 
 	/* ask for the report descriptor to be loaded by HID */
 	error = hid_parse(hdev);
@@ -2825,6 +2826,7 @@ static void wacom_remove(struct hid_devi
 	cancel_work_sync(&wacom->battery_work);
 	cancel_work_sync(&wacom->remote_work);
 	cancel_work_sync(&wacom->mode_change_work);
+	del_timer_sync(&wacom->idleprox_timer);
 	if (hdev->bus == BUS_BLUETOOTH)
 		device_remove_file(&hdev->dev, &dev_attr_speed);
 
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -11,6 +11,7 @@
 #include "wacom_wac.h"
 #include "wacom.h"
 #include <linux/input/mt.h>
+#include <linux/jiffies.h>
 
 /* resolution for penabled devices */
 #define WACOM_PL_RES		20
@@ -41,6 +42,43 @@ static int wacom_numbered_button_to_key(
 
 static void wacom_update_led(struct wacom *wacom, int button_count, int mask,
 			     int group);
+
+static void wacom_force_proxout(struct wacom_wac *wacom_wac)
+{
+	struct input_dev *input = wacom_wac->pen_input;
+
+	wacom_wac->shared->stylus_in_proximity = 0;
+
+	input_report_key(input, BTN_TOUCH, 0);
+	input_report_key(input, BTN_STYLUS, 0);
+	input_report_key(input, BTN_STYLUS2, 0);
+	input_report_key(input, BTN_STYLUS3, 0);
+	input_report_key(input, wacom_wac->tool[0], 0);
+	if (wacom_wac->serial[0]) {
+		input_report_abs(input, ABS_MISC, 0);
+	}
+	input_report_abs(input, ABS_PRESSURE, 0);
+
+	wacom_wac->tool[0] = 0;
+	wacom_wac->id[0] = 0;
+	wacom_wac->serial[0] = 0;
+
+	input_sync(input);
+}
+
+void wacom_idleprox_timeout(struct timer_list *list)
+{
+	struct wacom *wacom = from_timer(wacom, list, idleprox_timer);
+	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
+
+	if (!wacom_wac->hid_data.sense_state) {
+		return;
+	}
+
+	hid_warn(wacom->hdev, "%s: tool appears to be hung in-prox. forcing it out.\n", __func__);
+	wacom_force_proxout(wacom_wac);
+}
+
 /*
  * Percent of battery capacity for Graphire.
  * 8th value means AC online and show 100% capacity.
@@ -2328,6 +2366,7 @@ static void wacom_wac_pen_event(struct h
 		value = field->logical_maximum - value;
 		break;
 	case HID_DG_INRANGE:
+		mod_timer(&wacom->idleprox_timer, jiffies + msecs_to_jiffies(100));
 		wacom_wac->hid_data.inrange_state = value;
 		if (!(features->quirks & WACOM_QUIRK_SENSE))
 			wacom_wac->hid_data.sense_state = value;


