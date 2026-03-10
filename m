Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917E62D978B;
	Tue, 10 Mar 2026 11:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141113; cv=none; b=YwrUBm8C0QdtgoITIhsWJbH6oB+rqil3WiSrkedpVAYyyZdMjL+D7VxXGAlWVpXSqHvxqMcleYXtsegxa42BUAzxacTy5MBMs/ismzfLQ7IkbqOCHp41z7Zzr5cIS0YAJw1OcbtXIP6xouezgJS3RFImIwZlPB4EN2sclwywooM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141113; c=relaxed/simple;
	bh=ltwMG3MNSlwYvM86nE7Mk63Sacz2WKOW5u0H94qkZqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlvM7kY2NYAbIjBxUghoYwK/f35cIvWP3b+qVR23l6g+3ceQBEtFGOFS0jw8keDuACSeDe/260w08FUY1hqah+IqWhu1jytRyLhFLKPRi4/fchkvqRkEIq/Kdm09MBv5goz3jnTc0J/qm8Fo45hjMBpa849mpr22fWXCqrHUbEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2X8doBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2X8doBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF44EC19423;
	Tue, 10 Mar 2026 11:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141113;
	bh=ltwMG3MNSlwYvM86nE7Mk63Sacz2WKOW5u0H94qkZqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2X8doBY6GTNSdtSUPCRly9uj5mefIUcJe4oV/e2ebrjpT78qDj3LQ4nOeHqfz+Zs
	 mKGoIhRGgdu4FEogXlG0TXXL9+rjWPfxspL/OTwcFQx9tniPvqoh3fMV8sJy4rLK4p
	 uIdATgynAPM/+rgKiYGG0A9PFzSRAefUKVNJIPERfpNwG9up+wxEtzhGeA9kVI1P/s
	 B4Z09aX2A+xfKoI2RM3zxg/vM37tjhGsTmrmpD9TGxEq4zyIgwXPUw9vplNiYpk6i8
	 cnCswpI2+GuC9fbVJuSK/mFaCHFtOXNPiliUIa7xKeJERRkEM1jPLbBJx72DljFhiF
	 fQayV1VbBbyJQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Werner Sembach <wse@tuxedocomputers.com>,
	Jiri Kosina <jkosina@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 115/311] HID: multitouch: Keep latency normal on deactivate for reactivation gesture
Date: Tue, 10 Mar 2026 07:02:42 -0400
Message-ID: <49a31e96b633cfd90cf4390beae418e60644f3e1.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Werner Sembach <wse@tuxedocomputers.com>

commit ec3070f01fa30f2c5547d645dbb76174304bf0e4 upstream.

Uniwill devices have a built in gesture in the touchpad to de- and
reactivate it by double taping the upper left corner. This gesture stops
working when latency is set to high, so this patch keeps the latency on
normal.

Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
[jkosina@suse.com: change bit from 24 to 25]
[jkosina@suse.com: update shortlog]
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-multitouch.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 7daa8f6d81870..dde15d131a73e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -77,6 +77,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_ORIENTATION_INVERT	BIT(22)
 #define MT_QUIRK_APPLE_TOUCHBAR		BIT(23)
 #define MT_QUIRK_YOGABOOK9I		BIT(24)
+#define MT_QUIRK_KEEP_LATENCY_ON_CLOSE	BIT(25)
 
 #define MT_INPUTMODE_TOUCHSCREEN	0x02
 #define MT_INPUTMODE_TOUCHPAD		0x03
@@ -214,6 +215,7 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app);
 #define MT_CLS_WIN_8_DISABLE_WAKEUP		0x0016
 #define MT_CLS_WIN_8_NO_STICKY_FINGERS		0x0017
 #define MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU	0x0018
+#define MT_CLS_WIN_8_KEEP_LATENCY_ON_CLOSE	0x0019
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -334,6 +336,15 @@ static const struct mt_class mt_classes[] = {
 			MT_QUIRK_CONTACT_CNT_ACCURATE |
 			MT_QUIRK_WIN8_PTP_BUTTONS,
 		.export_all_inputs = true },
+	{ .name = MT_CLS_WIN_8_KEEP_LATENCY_ON_CLOSE,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_IGNORE_DUPLICATES |
+			MT_QUIRK_HOVERING |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_STICKY_FINGERS |
+			MT_QUIRK_WIN8_PTP_BUTTONS |
+			MT_QUIRK_KEEP_LATENCY_ON_CLOSE,
+		.export_all_inputs = true },
 
 	/*
 	 * vendor specific classes
@@ -849,7 +860,8 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			if ((cls->name == MT_CLS_WIN_8 ||
 			     cls->name == MT_CLS_WIN_8_FORCE_MULTI_INPUT ||
 			     cls->name == MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU ||
-			     cls->name == MT_CLS_WIN_8_DISABLE_WAKEUP) &&
+			     cls->name == MT_CLS_WIN_8_DISABLE_WAKEUP ||
+			     cls->name == MT_CLS_WIN_8_KEEP_LATENCY_ON_CLOSE) &&
 				(field->application == HID_DG_TOUCHPAD ||
 				 field->application == HID_DG_TOUCHSCREEN))
 				app->quirks |= MT_QUIRK_CONFIDENCE;
@@ -1762,7 +1774,8 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	int ret;
 
 	if (td->is_haptic_touchpad && (td->mtclass.name == MT_CLS_WIN_8 ||
-	    td->mtclass.name == MT_CLS_WIN_8_FORCE_MULTI_INPUT)) {
+	    td->mtclass.name == MT_CLS_WIN_8_FORCE_MULTI_INPUT ||
+	    td->mtclass.name == MT_CLS_WIN_8_KEEP_LATENCY_ON_CLOSE)) {
 		if (hid_haptic_input_configured(hdev, td->haptic, hi) == 0)
 			td->is_haptic_touchpad = false;
 	} else {
@@ -2075,7 +2088,12 @@ static void mt_on_hid_hw_open(struct hid_device *hdev)
 
 static void mt_on_hid_hw_close(struct hid_device *hdev)
 {
-	mt_set_modes(hdev, HID_LATENCY_HIGH, TOUCHPAD_REPORT_NONE);
+	struct mt_device *td = hid_get_drvdata(hdev);
+
+	if (td->mtclass.quirks & MT_QUIRK_KEEP_LATENCY_ON_CLOSE)
+		mt_set_modes(hdev, HID_LATENCY_NORMAL, TOUCHPAD_REPORT_NONE);
+	else
+		mt_set_modes(hdev, HID_LATENCY_HIGH, TOUCHPAD_REPORT_NONE);
 }
 
 /*
@@ -2461,6 +2479,14 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_UNITEC,
 			USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19) },
 
+	/* Uniwill touchpads */
+	{ .driver_data = MT_CLS_WIN_8_KEEP_LATENCY_ON_CLOSE,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_PIXART, 0x0255) },
+	{ .driver_data = MT_CLS_WIN_8_KEEP_LATENCY_ON_CLOSE,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_PIXART, 0x0274) },
+
 	/* VTL panels */
 	{ .driver_data = MT_CLS_VTL,
 		MT_USB_DEVICE(USB_VENDOR_ID_VTL,
-- 
2.51.0

