Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945F04DB560;
	Fri, 15 May 2026 16:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862419; cv=none; b=uUiJaiGoS96A65jsomGRKtXbNMklWxqR/kQBCCqX0BImWVPxiCpbtvvPqAqKccldYORu0tA29ai4e31yfUuF2Po+iroWK/ITinasVMN8cisUutPJ+FnsaW+g5tmQXTG1AHoh9Uwt1GrDmTm1LkpHXTQHq+TA/y1s4ifEa3Ca0nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862419; c=relaxed/simple;
	bh=VbkIOVcmvYScE7ICJn1ORb4Mfri+ZbW78nZ0jVvzgPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKmdpAaBoGJJ+sEWsD44G0UJglZ6ZyLmUbcgn61UzFMocbwcOyTMQKfM+a7FbNlKVFVjEndFzxLOFcFPNeROeE3R/9EJzi3hy4+KQQfSjGxsLDvLSq+7831gT1IXZTtPdRWzch1W1EzJl7DBd6FiDv5NIEB6cO+TTcaii0huUck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccOpH7fY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccOpH7fY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE54C2BCB0;
	Fri, 15 May 2026 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862419;
	bh=VbkIOVcmvYScE7ICJn1ORb4Mfri+ZbW78nZ0jVvzgPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccOpH7fYMhy7QP0ezIzQ6HjctKB8Z8zPgrAAVi7ieOx+1fh0z5l3FSEowF0bfo9l/
	 X6Z6sEoGnPjg2Jrt3M/bBG3xBG6sS5hjEB8wPbwgC9EOx48mU11FyzgmSe5VmRmmJc
	 YaTf8J00O0u7AbAlvONQSQtHeZYQDZNwg5MQptNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.0 005/201] HID: core: introduce hid_safe_input_report()
Date: Fri, 15 May 2026 17:47:03 +0200
Message-ID: <20260515154658.657276573@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

commit 206342541fc887ae919774a43942dc883161fece upstream.

hid_input_report() is used in too many places to have a commit that
doesn't cross subsystem borders. Instead of changing the API, introduce
a new one when things matters in the transport layers:
- usbhid
- i2chid

This effectively revert to the old behavior for those two transport
layers.

Fixes: 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing bogus memset()")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c             |   25 +++++++++++++++++++++++++
 drivers/hid/i2c-hid/i2c-hid-core.c |    7 ++++---
 drivers/hid/usbhid/hid-core.c      |   11 ++++++-----
 include/linux/hid.h                |    2 ++
 4 files changed, 37 insertions(+), 8 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2177,6 +2177,7 @@ unlock:
  * @interrupt: distinguish between interrupt and control transfers
  *
  * This is data entry for lower layers.
+ * Legacy, please use hid_safe_input_report() instead.
  */
 int hid_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data, u32 size,
 		     int interrupt)
@@ -2187,6 +2188,30 @@ int hid_input_report(struct hid_device *
 }
 EXPORT_SYMBOL_GPL(hid_input_report);
 
+/**
+ * hid_safe_input_report - report data from lower layer (usb, bt...)
+ *
+ * @hid: hid device
+ * @type: HID report type (HID_*_REPORT)
+ * @data: report contents
+ * @bufsize: allocated size of the data buffer
+ * @size: useful size of data parameter
+ * @interrupt: distinguish between interrupt and control transfers
+ *
+ * This is data entry for lower layers.
+ * Please use this function instead of the non safe version because we provide
+ * here the size of the buffer, allowing hid-core to make smarter decisions
+ * regarding the incoming buffer.
+ */
+int hid_safe_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data,
+			  size_t bufsize, u32 size, int interrupt)
+{
+	return __hid_input_report(hid, type, data, bufsize, size, interrupt, 0,
+				  false, /* from_bpf */
+				  false /* lock_already_taken */);
+}
+EXPORT_SYMBOL_GPL(hid_safe_input_report);
+
 bool hid_match_one_id(const struct hid_device *hdev,
 		      const struct hid_device_id *id)
 {
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -574,9 +574,10 @@ static void i2c_hid_get_input(struct i2c
 		if (ihid->hid->group != HID_GROUP_RMI)
 			pm_wakeup_event(&ihid->client->dev, 0);
 
-		hid_input_report(ihid->hid, HID_INPUT_REPORT,
-				ihid->inbuf + sizeof(__le16),
-				ret_size - sizeof(__le16), 1);
+		hid_safe_input_report(ihid->hid, HID_INPUT_REPORT,
+				      ihid->inbuf + sizeof(__le16),
+				      ihid->bufsize - sizeof(__le16),
+				      ret_size - sizeof(__le16), 1);
 	}
 
 	return;
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -283,9 +283,9 @@ static void hid_irq_in(struct urb *urb)
 			break;
 		usbhid_mark_busy(usbhid);
 		if (!test_bit(HID_RESUME_RUNNING, &usbhid->iofl)) {
-			hid_input_report(urb->context, HID_INPUT_REPORT,
-					 urb->transfer_buffer,
-					 urb->actual_length, 1);
+			hid_safe_input_report(urb->context, HID_INPUT_REPORT,
+					      urb->transfer_buffer, urb->transfer_buffer_length,
+					      urb->actual_length, 1);
 			/*
 			 * autosuspend refused while keys are pressed
 			 * because most keyboards don't wake up when
@@ -482,9 +482,10 @@ static void hid_ctrl(struct urb *urb)
 	switch (status) {
 	case 0:			/* success */
 		if (usbhid->ctrl[usbhid->ctrltail].dir == USB_DIR_IN)
-			hid_input_report(urb->context,
+			hid_safe_input_report(urb->context,
 				usbhid->ctrl[usbhid->ctrltail].report->type,
-				urb->transfer_buffer, urb->actual_length, 0);
+				urb->transfer_buffer, urb->transfer_buffer_length,
+				urb->actual_length, 0);
 		break;
 	case -ESHUTDOWN:	/* unplug */
 		unplug = 1;
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -998,6 +998,8 @@ struct hid_field *hid_find_field(struct
 int hid_set_field(struct hid_field *, unsigned, __s32);
 int hid_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data, u32 size,
 		     int interrupt);
+int hid_safe_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data,
+			  size_t bufsize, u32 size, int interrupt);
 struct hid_field *hidinput_get_led_field(struct hid_device *hid);
 unsigned int hidinput_count_leds(struct hid_device *hid);
 __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code);


