Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446BA257AC7;
	Thu, 17 Apr 2025 18:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913105; cv=none; b=msa1cVzUKerqsGO742jhsAahvowmvqz8LYUJ4GpNwTeRhJILYrE0QJMW9bmS6rSxqkp287oPVd4opiyZzHbj64MeTA+svA7duJLSr6s/TdyGGv58N5sga8gFpx+TZgmxJs8DDlzA9g2UeW5EAsM2kzmgZsHrbtJzAvVu3ReHgMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913105; c=relaxed/simple;
	bh=J+zR8xP29UDz6ODz04N26M2Nz2foeqI6D/X+JGibwWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l02DJ6S0g3oYQwSWck7qp8aSR6UMEvo1c528fzl5qUyOvnOo1wcRDFDz4ndQ3rtUm7FHJyKYjw43mNpxjAcotIW8IuILlsi+CZry7j3xhYWBNT5i8M+DGbLha5ruprS7OEVDrFNs66mVIXfdPAfuajJOB15Ai4qsGDTfdfCZVVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0wprApU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0wprApU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50326C4CEE4;
	Thu, 17 Apr 2025 18:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913104;
	bh=J+zR8xP29UDz6ODz04N26M2Nz2foeqI6D/X+JGibwWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0wprApUQHIelXsqyAxaWY8Ur0LUAUGRDsEvFmf/jmBO8v88KSVKUcBx8Sr0nKEc1
	 GPmDCBEOnVtcVBbJYIY34KmZtDPm2TKByVwLZHq6AoMJ6JOQwIJZ5PZ4bhuw1jpj+D
	 lczoX9eAo3t/y3GbZFJ4zUwndKI1wQUy6mNlkuiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Makarenko Oleg <oleg@makarenk.ooo>,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	=?UTF-8?q?Crist=C3=B3ferson=20Bueno?= <cbueno81@gmail.com>,
	Pablo Cisneros <patchkez@protonmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 198/449] HID: pidff: Completely rework and fix pidff_reset function
Date: Thu, 17 Apr 2025 19:48:06 +0200
Message-ID: <20250417175125.943779263@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit cb3fd788e3fa5358602a49809c4eb4911539c9d0 ]

Previously, it was assumed that DEVICE_CONTROL usage is always an array
but a lot of devices implements it as a bitmask variable. This led to
the pidff_reset function not working and causing errors in such cases.

Selectors can come in three types. One selection of a set, N selections
and Any selection in form of bitmask as from USB Hid Usage Tables v1.5,
subsection 3.4.2.1

Added pidff_send_device_control which handles usage flag check which
decides whether DEVICE_CONTROL should be handled as "One selection of a
set" or "Any selection of a set".

Reset was triggered once, on device initialization. Now, it's triggered
every time when uploading an effect to an empty device (no currently
stored effects), tracked by pidff->effect_count variable.

Co-developed-by: Makarenko Oleg <oleg@makarenk.ooo>
Signed-off-by: Makarenko Oleg <oleg@makarenk.ooo>
Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Michał Kopeć <michal@nozomi.space>
Reviewed-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Cristóferson Bueno <cbueno81@gmail.com>
Tested-by: Pablo Cisneros <patchkez@protonmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 138 +++++++++++++++++++++------------
 1 file changed, 89 insertions(+), 49 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 635596a57c75d..99b5d3deb40d0 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -109,9 +109,10 @@ static const u8 pidff_pool[] = { 0x80, 0x83, 0xa9 };
 /* Special field key tables used to put special field keys into arrays */
 
 #define PID_ENABLE_ACTUATORS	0
-#define PID_STOP_ALL_EFFECTS	1
-#define PID_RESET		2
-static const u8 pidff_device_control[] = { 0x97, 0x99, 0x9a };
+#define PID_DISABLE_ACTUATORS	1
+#define PID_STOP_ALL_EFFECTS	2
+#define PID_RESET		3
+static const u8 pidff_device_control[] = { 0x97, 0x98, 0x99, 0x9a };
 
 #define PID_CONSTANT	0
 #define PID_RAMP	1
@@ -190,6 +191,7 @@ struct pidff_device {
 	int pid_id[PID_EFFECTS_MAX];
 
 	u32 quirks;
+	u8 effect_count;
 };
 
 /*
@@ -490,9 +492,83 @@ static int pidff_needs_set_ramp(struct ff_effect *effect, struct ff_effect *old)
 	       effect->u.ramp.end_level != old->u.ramp.end_level;
 }
 
+/*
+ * Clear device control report
+ */
+static void pidff_send_device_control(struct pidff_device *pidff, int field)
+{
+	int i, tmp;
+	int field_index = pidff->control_id[field];
+
+	/* Detect if the field is a bitmask variable or an array */
+	if (pidff->device_control->flags & HID_MAIN_ITEM_VARIABLE) {
+		hid_dbg(pidff->hid, "DEVICE_CONTROL is a bitmask\n");
+		/* Clear current bitmask */
+		for(i = 0; i < sizeof(pidff_device_control); i++) {
+			tmp = pidff->control_id[i];
+			pidff->device_control->value[tmp] = 0;
+		}
+		pidff->device_control->value[field_index - 1] = 1;
+	} else {
+		hid_dbg(pidff->hid, "DEVICE_CONTROL is an array\n");
+		pidff->device_control->value[0] = field_index;
+	}
+
+	hid_hw_request(pidff->hid, pidff->reports[PID_DEVICE_CONTROL], HID_REQ_SET_REPORT);
+	hid_hw_wait(pidff->hid);
+}
+
+/*
+ * Modify actuators state
+ */
+static void pidff_modify_actuators_state(struct pidff_device *pidff, bool enable)
+{
+	hid_dbg(pidff->hid, "%s actuators\n", enable ? "Enable" : "Disable");
+	pidff_send_device_control(pidff,
+		enable ? PID_ENABLE_ACTUATORS : PID_DISABLE_ACTUATORS);
+}
+
+/*
+ * Reset the device, stop all effects, enable actuators
+ * Refetch pool report
+ */
+static void pidff_reset(struct pidff_device *pidff)
+{
+	int i = 0;
+
+	/* We reset twice as sometimes hid_wait_io isn't waiting long enough */
+	pidff_send_device_control(pidff, PID_RESET);
+	pidff_send_device_control(pidff, PID_RESET);
+	pidff->effect_count = 0;
+
+	pidff_send_device_control(pidff, PID_STOP_ALL_EFFECTS);
+	pidff_modify_actuators_state(pidff, 1);
+
+	/* pool report is sometimes messed up, refetch it */
+	hid_hw_request(pidff->hid, pidff->reports[PID_POOL], HID_REQ_GET_REPORT);
+	hid_hw_wait(pidff->hid);
+
+	if (pidff->pool[PID_SIMULTANEOUS_MAX].value) {
+		while (pidff->pool[PID_SIMULTANEOUS_MAX].value[0] < 2) {
+			if (i++ > 20) {
+				hid_warn(pidff->hid,
+					 "device reports %d simultaneous effects\n",
+					 pidff->pool[PID_SIMULTANEOUS_MAX].value[0]);
+				break;
+			}
+			hid_dbg(pidff->hid, "pid_pool requested again\n");
+			hid_hw_request(pidff->hid, pidff->reports[PID_POOL],
+					  HID_REQ_GET_REPORT);
+			hid_hw_wait(pidff->hid);
+		}
+	}
+}
+
 /*
  * Send a request for effect upload to the device
  *
+ * Reset and enable actuators if no effects were present on the device
+ *
  * Returns 0 if device reported success, -ENOSPC if the device reported memory
  * is full. Upon unknown response the function will retry for 60 times, if
  * still unsuccessful -EIO is returned.
@@ -501,6 +577,9 @@ static int pidff_request_effect_upload(struct pidff_device *pidff, int efnum)
 {
 	int j;
 
+	if (!pidff->effect_count)
+		pidff_reset(pidff);
+
 	pidff->create_new_effect_type->value[0] = efnum;
 	hid_hw_request(pidff->hid, pidff->reports[PID_CREATE_NEW_EFFECT],
 			HID_REQ_SET_REPORT);
@@ -520,6 +599,8 @@ static int pidff_request_effect_upload(struct pidff_device *pidff, int efnum)
 			hid_dbg(pidff->hid, "device reported free memory: %d bytes\n",
 				 pidff->block_load[PID_RAM_POOL_AVAILABLE].value ?
 				 pidff->block_load[PID_RAM_POOL_AVAILABLE].value[0] : -1);
+
+			pidff->effect_count++;
 			return 0;
 		}
 		if (pidff->block_load_status->value[0] ==
@@ -568,12 +649,16 @@ static int pidff_playback(struct input_dev *dev, int effect_id, int value)
 
 /*
  * Erase effect with PID id
+ * Decrease the device effect counter
  */
 static void pidff_erase_pid(struct pidff_device *pidff, int pid_id)
 {
 	pidff->block_free[PID_EFFECT_BLOCK_INDEX].value[0] = pid_id;
 	hid_hw_request(pidff->hid, pidff->reports[PID_BLOCK_FREE],
 			HID_REQ_SET_REPORT);
+
+	if (pidff->effect_count > 0)
+		pidff->effect_count--;
 }
 
 /*
@@ -1221,50 +1306,6 @@ static int pidff_init_fields(struct pidff_device *pidff, struct input_dev *dev)
 	return 0;
 }
 
-/*
- * Reset the device
- */
-static void pidff_reset(struct pidff_device *pidff)
-{
-	struct hid_device *hid = pidff->hid;
-	int i = 0;
-
-	pidff->device_control->value[0] = pidff->control_id[PID_RESET];
-	/* We reset twice as sometimes hid_wait_io isn't waiting long enough */
-	hid_hw_request(hid, pidff->reports[PID_DEVICE_CONTROL], HID_REQ_SET_REPORT);
-	hid_hw_wait(hid);
-	hid_hw_request(hid, pidff->reports[PID_DEVICE_CONTROL], HID_REQ_SET_REPORT);
-	hid_hw_wait(hid);
-
-	pidff->device_control->value[0] = pidff->control_id[PID_STOP_ALL_EFFECTS];
-	hid_hw_request(hid, pidff->reports[PID_DEVICE_CONTROL], HID_REQ_SET_REPORT);
-	hid_hw_wait(hid);
-
-	pidff->device_control->value[0] =
-		pidff->control_id[PID_ENABLE_ACTUATORS];
-	hid_hw_request(hid, pidff->reports[PID_DEVICE_CONTROL], HID_REQ_SET_REPORT);
-	hid_hw_wait(hid);
-
-	/* pool report is sometimes messed up, refetch it */
-	hid_hw_request(hid, pidff->reports[PID_POOL], HID_REQ_GET_REPORT);
-	hid_hw_wait(hid);
-
-	if (pidff->pool[PID_SIMULTANEOUS_MAX].value) {
-		while (pidff->pool[PID_SIMULTANEOUS_MAX].value[0] < 2) {
-			if (i++ > 20) {
-				hid_warn(pidff->hid,
-					 "device reports %d simultaneous effects\n",
-					 pidff->pool[PID_SIMULTANEOUS_MAX].value[0]);
-				break;
-			}
-			hid_dbg(pidff->hid, "pid_pool requested again\n");
-			hid_hw_request(hid, pidff->reports[PID_POOL],
-					  HID_REQ_GET_REPORT);
-			hid_hw_wait(hid);
-		}
-	}
-}
-
 /*
  * Test if autocenter modification is using the supported method
  */
@@ -1330,6 +1371,7 @@ int hid_pidff_init_with_quirks(struct hid_device *hid, __u32 initial_quirks)
 
 	pidff->hid = hid;
 	pidff->quirks = initial_quirks;
+	pidff->effect_count = 0;
 
 	hid_device_io_start(hid);
 
@@ -1346,8 +1388,6 @@ int hid_pidff_init_with_quirks(struct hid_device *hid, __u32 initial_quirks)
 	if (error)
 		goto fail;
 
-	pidff_reset(pidff);
-
 	if (test_bit(FF_GAIN, dev->ffbit)) {
 		pidff_set(&pidff->device_gain[PID_DEVICE_GAIN_FIELD], 0xffff);
 		hid_hw_request(hid, pidff->reports[PID_DEVICE_GAIN],
-- 
2.39.5



