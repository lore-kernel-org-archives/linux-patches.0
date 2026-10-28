Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211331;
	b=xl/DUQHbRhZhkoyKzpKMOA1LgGOxsxF4g6YlbfDynkhHnHIMlPFxZz/Zmi91HZ6s0y5f
	 o29kvN1SFiDpfh8nEhEVbLNSpTO6rSpmFOHlzVu2jc/WX2a3BgAiUngfwCRM3wEUNApzf
	 aFKPMfKd8WRoFHFOo/H+zi5tuBwJwlxSNtWWvNnvWzbM+MhZQaY+j1Q8p6siAe6wl6+NI
	 X9doWsyJSQ8TuJCJI3lbFONbsUfFBYx0YNtSsX8kumKLMYMFx/WAmsyR55Ajdv/AHCLHJ
	 czroSYMCcpYJuaX3iSR3XvL9Pd5z9HyS2/xz9JdabevrIGKi6GbZqY7t6wQBXvhXj+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J/aLgt892kGTycGbAsqYEO+yocMcgeFn64o5K33I/48=;
	b=ulEU9LlSnLbn5mdnysCugWRTLjw/AtIDWn90P1ngQPYLtYz8gKnJ0ZyG2IEWVhZx9D/h
	 lCQP4ibUJAHcwNj5W2qs47ww/12R3bz4S4gja0zENVDSJxRTSJAEdDBBNtgOiAzWyE0oJ
	 UASI3m77ac0UhDWREsTsfbGodDQ6Ur/jjLI0z7p4jx9lH9g/K0+as01GlP1vGhQ9qdYMS
	 96K37FU70QlbJUDV7noRK0izuYSc1HarVqrYN/PV9ga0xc5nyfbNBD1HiP4AJFwbTr6eV
	 bHSHgzrsA8nr3/4FF2I+DWgm+G/28uI0G0OcWAsivA2f2hBjHdTAOVzkX4vAS0uldHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BnKCyKHT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF37606A31D;
	Wed, 28 Oct 2026 18:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BnKCyKHT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366191F01825;
	Wed, 28 Oct 2026 18:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211330;
	bh=J/aLgt892kGTycGbAsqYEO+yocMcgeFn64o5K33I/48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BnKCyKHTsA55rxvoGP+CqlWvSdOIp937O83RpSb4Itse6obmqLY10yDUC7ZxJQH+b
	 5/68Fc8MzDHlwID3WInMIFMY35ZIn+0TFZOwF0fqM2Qt0poOXJBf2D2EfzW2bpviu8
	 n/IF0TKtEOU/sqWtJbr2DUGDI+jTUtt7qJRWv10I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 340/571] HID: core: introduce hid_safe_input_report()
Date: Wed, 28 Oct 2026 17:58:07 +0100
Message-ID: <20261028170016.083986299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
(cherry picked from commit a9527c32cc9d98252dc975d6fcb29f2013d0f63a)
[Lee: Implement hid_safe_input_report() directly and wrap it from
      hid_input_report() as 67eccf151d76 ("HID: add source argument to
      HID low level functions") is not present.  Use int for report type
      and literal 2 in i2c_hid_get_input() as 56fc4f7bc114 and
      1bdbe0dcff2f are not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c             | 26 ++++++++++++++++++++++++--
 drivers/hid/i2c-hid/i2c-hid-core.c |  5 +++--
 drivers/hid/usbhid/hid-core.c      | 11 ++++++-----
 include/linux/hid.h                |  2 ++
 4 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 783f55a259cd8..b94106ae9b1c6 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1873,13 +1873,35 @@ EXPORT_SYMBOL_GPL(hid_report_raw_event);
  * @interrupt: distinguish between interrupt and control transfers
  *
  * This is data entry for lower layers.
+ * Legacy, please use hid_safe_input_report() instead.
  */
 int hid_input_report(struct hid_device *hid, int type, u8 *data, u32 size, int interrupt)
+{
+	return hid_safe_input_report(hid, type, data, size, size, interrupt);
+}
+EXPORT_SYMBOL_GPL(hid_input_report);
+
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
+int hid_safe_input_report(struct hid_device *hid, int type, u8 *data,
+			  size_t bufsize, u32 size, int interrupt)
 {
 	struct hid_report_enum *report_enum;
 	struct hid_driver *hdrv;
 	struct hid_report *report;
-	size_t bufsize = size;
 	int ret = 0;
 
 	if (!hid)
@@ -1924,7 +1946,7 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, u32 size, int i
 	up(&hid->driver_input_lock);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(hid_input_report);
+EXPORT_SYMBOL_GPL(hid_safe_input_report);
 
 bool hid_match_one_id(const struct hid_device *hdev,
 		      const struct hid_device_id *id)
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 6edfbfab55d3f..93f7dfde6d297 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -518,8 +518,9 @@ static void i2c_hid_get_input(struct i2c_hid *ihid)
 	i2c_hid_dbg(ihid, "input: %*ph\n", ret_size, ihid->inbuf);
 
 	if (test_bit(I2C_HID_STARTED, &ihid->flags))
-		hid_input_report(ihid->hid, HID_INPUT_REPORT, ihid->inbuf + 2,
-				ret_size - 2, 1);
+		hid_safe_input_report(ihid->hid, HID_INPUT_REPORT,
+				      ihid->inbuf + 2, ihid->bufsize - 2,
+				      ret_size - 2, 1);
 
 	return;
 }
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index b182b288991a6..114aa5b6d3965 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -281,9 +281,9 @@ static void hid_irq_in(struct urb *urb)
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
@@ -480,9 +480,10 @@ static void hid_ctrl(struct urb *urb)
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
index 3d941d51ccb63..d9eb1f815614e 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -937,6 +937,8 @@ extern void hidinput_disconnect(struct hid_device *);
 
 int hid_set_field(struct hid_field *, unsigned, __s32);
 int hid_input_report(struct hid_device *, int type, u8 *, u32, int);
+int hid_safe_input_report(struct hid_device *hid, int type, u8 *data,
+			  size_t bufsize, u32 size, int interrupt);
 int hidinput_find_field(struct hid_device *hid, unsigned int type, unsigned int code, struct hid_field **field);
 struct hid_field *hidinput_get_led_field(struct hid_device *hid);
 unsigned int hidinput_count_leds(struct hid_device *hid);
-- 
2.53.0



