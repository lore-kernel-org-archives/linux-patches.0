Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17495265CDD;
	Tue, 21 Oct 2025 20:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077282; cv=none; b=Ei7B0eYIst3wXAxHlmuekaJWxaIqsNPEWK3Th6IPBTAGZ5gB+LsgFUmZ0ZrZ/xbRXXpvY83apoQDaTRgIvNLGPcvezj46eLtLpiej9tqYo40Naf9GtOs94LH0+rCPq9ZugcTJo3phRgCFtHKu+a3JyaxFvq9jfPzI93fBtk/b50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077282; c=relaxed/simple;
	bh=aSsbQLatBIKL3r2Bog28U9wn9AR9lMfbYKCKTfKWIyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAGcPYgjJTT47LUvHNhrUgxYGMR+fT4KoQ5sQvtyxE4tnQDWx0FJ/GVV4+v0YK1VFk5OuYf/psufX1V2OrzwvZ2305kQ718nLDkSj/Sy++DXoZ1oK3Me1q3D6kIX2OudUitfebnQUDTOVVMR4DemeNXgoGYpMf1H3vTXD+AApjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3ESUHSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3ESUHSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB28C4CEF1;
	Tue, 21 Oct 2025 20:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077282;
	bh=aSsbQLatBIKL3r2Bog28U9wn9AR9lMfbYKCKTfKWIyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3ESUHSqQJlbfLaivK9O9nnhXgUDmfcSJRFihsBAW0uDShtbz4pT2SaX3Vycrr+3X
	 tBh5cYODpqCNt82stwg3w6GdK58eUIog3LIL1u6GE7QdKxkO9nW76rkR7UXz0lneRZ
	 lqv68CUG8Do0l2BKyHwLGlurg+qOnm6yWfTl+7NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.17 057/159] HID: multitouch: fix sticky fingers
Date: Tue, 21 Oct 2025 21:50:34 +0200
Message-ID: <20251021195044.587404982@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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
@@ -92,9 +92,8 @@ enum report_mode {
 	TOUCHPAD_REPORT_ALL = TOUCHPAD_REPORT_BUTTONS | TOUCHPAD_REPORT_CONTACTS,
 };
 
-#define MT_IO_FLAGS_RUNNING		0
-#define MT_IO_FLAGS_ACTIVE_SLOTS	1
-#define MT_IO_FLAGS_PENDING_SLOTS	2
+#define MT_IO_SLOTS_MASK		GENMASK(7, 0) /* reserve first 8 bits for slot tracking */
+#define MT_IO_FLAGS_RUNNING		32
 
 static const bool mtrue = true;		/* default for true */
 static const bool mfalse;		/* default for false */
@@ -169,7 +168,11 @@ struct mt_device {
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
@@ -977,6 +980,7 @@ static void mt_release_pending_palms(str
 
 	for_each_set_bit(slotnum, app->pending_palm_slots, td->maxcontacts) {
 		clear_bit(slotnum, app->pending_palm_slots);
+		clear_bit(slotnum, &td->mt_io_flags);
 
 		input_mt_slot(input, slotnum);
 		input_mt_report_slot_inactive(input);
@@ -1008,12 +1012,6 @@ static void mt_sync_frame(struct mt_devi
 
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
@@ -1188,7 +1186,9 @@ static int mt_process_slot(struct mt_dev
 		input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
 		input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
 
-		set_bit(MT_IO_FLAGS_ACTIVE_SLOTS, &td->mt_io_flags);
+		set_bit(slotnum, &td->mt_io_flags);
+	} else {
+		clear_bit(slotnum, &td->mt_io_flags);
 	}
 
 	return 0;
@@ -1323,7 +1323,7 @@ static void mt_touch_report(struct hid_d
 	 * defect.
 	 */
 	if (app->quirks & MT_QUIRK_STICKY_FINGERS) {
-		if (test_bit(MT_IO_FLAGS_PENDING_SLOTS, &td->mt_io_flags))
+		if (td->mt_io_flags & MT_IO_SLOTS_MASK)
 			mod_timer(&td->release_timer,
 				  jiffies + msecs_to_jiffies(100));
 		else
@@ -1782,6 +1782,7 @@ static void mt_release_contacts(struct h
 			for (i = 0; i < mt->num_slots; i++) {
 				input_mt_slot(input_dev, i);
 				input_mt_report_slot_inactive(input_dev);
+				clear_bit(i, &td->mt_io_flags);
 			}
 			input_mt_sync_frame(input_dev);
 			input_sync(input_dev);
@@ -1804,7 +1805,7 @@ static void mt_expired_timeout(struct ti
 	 */
 	if (test_and_set_bit_lock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
 		return;
-	if (test_bit(MT_IO_FLAGS_PENDING_SLOTS, &td->mt_io_flags))
+	if (td->mt_io_flags & MT_IO_SLOTS_MASK)
 		mt_release_contacts(hdev);
 	clear_bit_unlock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
 }


