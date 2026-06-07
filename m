Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5839231F983;
	Sun,  7 Jun 2026 11:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830318; cv=none; b=MH/U4Hxyp72/CgBxu4jblItbDUf6NHSQHOIkZmZ9mKsjErsMPD3tuqcWH3d9sZiv6blpp4B5yXhWefMyXUyP5sO+hSOD6/5J2bwfWWmjG+pglNN0aS6ANfYWUHYWQ1fsM9GbnnMWedYmsc7xZB4H8hGmPIDNq4xtpjQsY68FtoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830318; c=relaxed/simple;
	bh=tGN9jErpyu4eqrZVRHVVwSCKf3e1r75yZWitWRsyA08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oItviSW2ChHLTdJ2bsQFt8kkj4HdFYEegt1RX9/YZq737q7dAyekVB4wG3BTbW6qxdH2tB27qCjBtv4+NhS0z3cHrrLWW9VyZYz0MtsEmP2ED3q/a2VhzCPQZoke8rYF8Yx9sCvizUf6B19IC0BZ1AhrZNrlH8PqKJdr0VEJQOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPkax0N6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPkax0N6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962A51F00893;
	Sun,  7 Jun 2026 11:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830317;
	bh=J/bl6mj8MhbolVih/VymREDsRZSAQDRFhrd6bkuKPRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPkax0N6tat4xHLWrK/X0WAtUGLZD3Vl2EQLl4ofBjEkIBfrOGty6b4iIuc/f2TFd
	 ne6sYDbQA9HMriRJgTBYrXgZAln6L6ObBkgNj7WLbunp/MZS55k8nRV5aO3h7YrLph
	 gLyATm7i0QhzFo9LERK5aHkqJPBZ2TMcNMP8epBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/307] HID: core: introduce hid_safe_input_report()
Date: Sun,  7 Jun 2026 11:58:33 +0200
Message-ID: <20260607095732.028333248@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Benjamin Tissoires <bentiss@kernel.org>

[ Upstream commit 206342541fc887ae919774a43942dc883161fece ]

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
(cherry picked from commit 301338b8edadc67a42b1c86add975091e66768d9)
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c             | 25 +++++++++++++++++++++++++
 drivers/hid/i2c-hid/i2c-hid-core.c |  7 ++++---
 drivers/hid/usbhid/hid-core.c      | 11 ++++++-----
 include/linux/hid.h                |  2 ++
 4 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index ceff91722c3c83..d9ea99cdb68e06 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2146,6 +2146,7 @@ static int __hid_input_report(struct hid_device *hid, enum hid_report_type type,
  * @interrupt: distinguish between interrupt and control transfers
  *
  * This is data entry for lower layers.
+ * Legacy, please use hid_safe_input_report() instead.
  */
 int hid_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data, u32 size,
 		     int interrupt)
@@ -2156,6 +2157,30 @@ int hid_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data
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
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index cf8ae0df0cda95..8ce0535fc42d60 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -568,9 +568,10 @@ static void i2c_hid_get_input(struct i2c_hid *ihid)
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
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index f14b46ce00cb67..336ad7cf3d484e 100644
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
diff --git a/include/linux/hid.h b/include/linux/hid.h
index fdd401e4ebde3d..7d05b1edacd80c 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -949,6 +949,8 @@ struct hid_field *hid_find_field(struct hid_device *hdev, unsigned int report_ty
 int hid_set_field(struct hid_field *, unsigned, __s32);
 int hid_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data, u32 size,
 		     int interrupt);
+int hid_safe_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data,
+			  size_t bufsize, u32 size, int interrupt);
 struct hid_field *hidinput_get_led_field(struct hid_device *hid);
 unsigned int hidinput_count_leds(struct hid_device *hid);
 __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code);
-- 
2.53.0



pu, ZCR_EL2, p->regval);
 
-	vq = SYS_FIELD_GET(ZCR_ELx, LEN, p->regval) + 1;
-	vq = min(vq, vcpu_sve_max_vq(vcpu));
-	__vcpu_assign_sys_reg(vcpu, ZCR_EL2, vq - 1);
 	return true;
 }
 


