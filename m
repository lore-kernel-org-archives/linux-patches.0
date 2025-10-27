Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAEA329C42;
	Mon, 27 Oct 2025 18:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591541; cv=none; b=ep8Axmc1NNR7T/QlkyNKrN2bGOsLqzTgrWy943Yh0UGFq02MwWg0F8dd+ULkMAAKRBEVQrfS5Nmh/spvUWKOjMgajXZ343YJ3gyzUm+7mYKlBi3qxGZipjg1ZPizkOA6e//F7j6ysTfP6KTd5IntuAJXGR3Qgq5SqQUjF9rJpIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591541; c=relaxed/simple;
	bh=wL2BwfgMs26Ml2xVLMvsRYT8WPD6Ajn127YpEnAG37Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTtk4k32i1NcOr+naC9E3bVypReAlyMZQpemjRs92bScV6RHZh9HzL5rFyC6JEfkqfSAY5ZYw7jRzQWXQRPUscxz2XkEBtJ1RgEC3FuYtLBDvzJOOwwQDGOzTj/Hh3y2sG+KLrJlKXImK3ufGONh3GkpTqJ6Px5B6f91zOy0cpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WErol88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WErol88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB17CC4CEF1;
	Mon, 27 Oct 2025 18:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591541;
	bh=wL2BwfgMs26Ml2xVLMvsRYT8WPD6Ajn127YpEnAG37Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1WErol88JVNchm4dlNxbFXyx3koFvPHI2q7Uq2XzoWxrkJD+eyd23rq0kbrRlbGXM
	 H2/uIUMqzBzJTJUGHENDt9fq/r6CCKmnJyjmn5H0C0O67NOcY54fVi5p2+WUKhM4d8
	 uuK3gsGrM2PtpbX/xQIUbok4sjXdC6eEZu0y5JzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 237/332] HID: multitouch: fix sticky fingers
Date: Mon, 27 Oct 2025 19:34:50 +0100
Message-ID: <20251027183531.083241314@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

commit 46f781e0d151844589dc2125c8cce3300546f92a upstream.

The sticky fingers quirk (MT_QUIRK_STICKY_FINGERS) was only considering
the case when slots were not released during the last report.
This can be problematic if the firmware forgets to release a finger
while others are still present.

This was observed on the Synaptics DLL0945 touchpad found on the Dell
XPS 9310 and the Dell Inspiron 5406.

Fixes: 4f4001bc76fd ("HID: multitouch: fix rare Win 8 cases when the touch up event gets missing")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-multitouch.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -81,9 +81,8 @@ enum latency_mode {
 	HID_LATENCY_HIGH = 1,
 };
 
-#define MT_IO_FLAGS_RUNNING		0
-#define MT_IO_FLAGS_ACTIVE_SLOTS	1
-#define MT_IO_FLAGS_PENDING_SLOTS	2
+#define MT_IO_SLOTS_MASK		GENMASK(7, 0) /* reserve first 8 bits for slot tracking */
+#define MT_IO_FLAGS_RUNNING		32
 
 static const bool mtrue = true;		/* default for true */
 static const bool mfalse;		/* default for false */
@@ -159,7 +158,11 @@ struct mt_device {
 	struct mt_class mtclass;	/* our mt device class */
 	struct timer_list release_timer;	/* to release sticky fingers */
 	struct hid_device *hdev;	/* hid_device we're attached to */
-	unsigned long mt_io_flags;	/* mt flags (MT_IO_FLAGS_*) */
+	unsigned long mt_io_flags;	/* mt flags (MT_IO_FLAGS_RUNNING)
+					 * first 8 bits are reserved for keeping the slot
+					 * states, this is fine because we only support up
+					 * to 250 slots (MT_MAX_MAXCONTACT)
+					 */
 	__u8 inputmode_value;	/* InputMode HID feature value */
 	__u8 maxcontacts;
 	bool is_buttonpad;	/* is this device a button pad? */
@@ -904,6 +907,7 @@ static void mt_release_pending_palms(str
 
 	for_each_set_bit(slotnum, app->pending_palm_slots, td->maxcontacts) {
 		clear_bit(slotnum, app->pending_palm_slots);
+		clear_bit(slotnum, &td->mt_io_flags);
 
 		input_mt_slot(input, slotnum);
 		input_mt_report_slot_inactive(input);
@@ -935,12 +939,6 @@ static void mt_sync_frame(struct mt_devi
 
 	app->num_received = 0;
 	app->left_button_state = 0;
-
-	if (test_bit(MT_IO_FLAGS_ACTIVE_SLOTS, &td->mt_io_flags))
-		set_bit(MT_IO_FLAGS_PENDING_SLOTS, &td->mt_io_flags);
-	else
-		clear_bit(MT_IO_FLAGS_PENDING_SLOTS, &td->mt_io_flags);
-	clear_bit(MT_IO_FLAGS_ACTIVE_SLOTS, &td->mt_io_flags);
 }
 
 static int mt_compute_timestamp(struct mt_application *app, __s32 value)
@@ -1094,7 +1092,9 @@ static int mt_process_slot(struct mt_dev
 		input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
 		input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
 
-		set_bit(MT_IO_FLAGS_ACTIVE_SLOTS, &td->mt_io_flags);
+		set_bit(slotnum, &td->mt_io_flags);
+	} else {
+		clear_bit(slotnum, &td->mt_io_flags);
 	}
 
 	return 0;
@@ -1229,7 +1229,7 @@ static void mt_touch_report(struct hid_d
 	 * defect.
 	 */
 	if (app->quirks & MT_QUIRK_STICKY_FINGERS) {
-		if (test_bit(MT_IO_FLAGS_PENDING_SLOTS, &td->mt_io_flags))
+		if (td->mt_io_flags & MT_IO_SLOTS_MASK)
 			mod_timer(&td->release_timer,
 				  jiffies + msecs_to_jiffies(100));
 		else
@@ -1647,6 +1647,7 @@ static void mt_release_contacts(struct h
 			for (i = 0; i < mt->num_slots; i++) {
 				input_mt_slot(input_dev, i);
 				input_mt_report_slot_inactive(input_dev);
+				clear_bit(i, &td->mt_io_flags);
 			}
 			input_mt_sync_frame(input_dev);
 			input_sync(input_dev);
@@ -1669,7 +1670,7 @@ static void mt_expired_timeout(struct ti
 	 */
 	if (test_and_set_bit_lock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
 		return;
-	if (test_bit(MT_IO_FLAGS_PENDING_SLOTS, &td->mt_io_flags))
+	if (td->mt_io_flags & MT_IO_SLOTS_MASK)
 		mt_release_contacts(hdev);
 	clear_bit_unlock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
 }


