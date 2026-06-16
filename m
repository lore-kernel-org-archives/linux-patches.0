Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C2D477E57;
	Tue, 16 Jun 2026 16:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628997; cv=none; b=HSqwpvQMYEB2IEFBTwIW2bnL4yXkddW+mcCTva6qw/13+pJ3k3VqIBuD8/H6aFxKsG1B4jUDTBCXGzxHiwbI9NlFZj0pFiSV0CFcRZp/G7SyHCSgcwMduoOea+o2nhzaV8Ol23Vf/iVGmWapmZoIaiF+xPNEfvA/YK+HteOR0Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628997; c=relaxed/simple;
	bh=OhqfCET0gLICBP1wtvDDy6BHyZ+opgjARu/h3LszaJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MffIcagGid2tfdAFlHUF+0+4GezzXxhbs6bPaEu2zQ2s7XdLB3Xipg6paS66eaNI6GNfrVbAdf8VPFISCUFs8tLK93TvuRLLzsS1z37rNcsSb1gb1gtFv29VHyMOEhKEqvp5Qu9JUToCG84wrS1C2mOEofBZGLLooKkKReM/ZE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgFBGOMf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgFBGOMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4E91F000E9;
	Tue, 16 Jun 2026 16:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628996;
	bh=GybYLS7jDQB/LgciKsrtuwPxYglCy8Bu8y239eK93tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgFBGOMfoMGn1HwB0uWUcX/mDvY19cUGK7eAx79wh3vL6phPNz08DaCnk967v26e3
	 xFRPG3wJlvDBtq88sdgtxaId7n3vCyGhgzWO+zUoS0Kl1TEBPlqPtWTboyRAL1ka3f
	 aHoxDBWc1s64nsmcZfsvI8a6N9gG97h6ibeGYRUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 201/452] HID: pass the buffer size to hid_report_raw_event
Date: Tue, 16 Jun 2026 20:27:08 +0530
Message-ID: <20260616145128.381536464@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

commit 2c85c61d1332e1e16f020d76951baf167dcb6f7a upstream.

commit 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing
bogus memset()") enforced the provided data to be at least the size of
the declared buffer in the report descriptor to prevent a buffer
overflow. However, we can try to be smarter by providing both the buffer
size and the data size, meaning that hid_report_raw_event() can make
better decision whether we should plaining reject the buffer (buffer
overflow attempt) or if we can safely memset it to 0 and pass it to the
rest of the stack.

Fixes: 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing bogus memset()")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Acked-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[Lee: Backported to linux-6.12.y and beyond]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/bpf/hid_bpf_dispatch.c |    3 ++-
 drivers/hid/hid-core.c             |   35 +++++++++++++++++++++++++----------
 drivers/hid/hid-gfrm.c             |    4 ++--
 drivers/hid/hid-logitech-hidpp.c   |    2 +-
 drivers/hid/hid-multitouch.c       |    2 +-
 drivers/hid/hid-primax.c           |    2 +-
 drivers/hid/hid-vivaldi-common.c   |    2 +-
 drivers/hid/wacom_sys.c            |    6 +++---
 drivers/staging/greybus/hid.c      |    2 +-
 include/linux/hid.h                |    4 ++--
 include/linux/hid_bpf.h            |    4 ++--
 11 files changed, 41 insertions(+), 25 deletions(-)

--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -47,7 +47,7 @@ __weak noinline int hid_bpf_device_event
 
 u8 *
 dispatch_hid_bpf_device_event(struct hid_device *hdev, enum hid_report_type type, u8 *data,
-			      u32 *size, int interrupt)
+			      size_t *buf_size, u32 *size, int interrupt)
 {
 	struct hid_bpf_ctx_kern ctx_kern = {
 		.ctx = {
@@ -81,6 +81,7 @@ dispatch_hid_bpf_device_event(struct hid
 		*size = ret;
 	}
 
+	*buf_size = ctx_kern.ctx.allocated_size;
 	return ctx_kern.data;
 }
 EXPORT_SYMBOL_GPL(dispatch_hid_bpf_device_event);
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1986,24 +1986,32 @@ out:
 }
 EXPORT_SYMBOL_GPL(__hid_request);
 
-int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *data, u32 size,
-			 int interrupt)
+int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *data,
+			 size_t bufsize, u32 size, int interrupt)
 {
 	struct hid_report_enum *report_enum = hid->report_enum + type;
 	struct hid_report *report;
 	struct hid_driver *hdrv;
 	int max_buffer_size = HID_MAX_BUFFER_SIZE;
 	u32 rsize, csize = size;
+	size_t bsize = bufsize;
 	u8 *cdata = data;
 	int ret = 0;
 
 	report = hid_get_report(report_enum, data);
 	if (!report)
-		goto out;
+		return 0;
+
+	if (unlikely(bsize < csize)) {
+		hid_warn_ratelimited(hid, "Event data for report %d is incorrect (%d vs %ld)\n",
+				     report->id, csize, bsize);
+		return -EINVAL;
+	}
 
 	if (report_enum->numbered) {
 		cdata++;
 		csize--;
+		bsize--;
 	}
 
 	rsize = hid_compute_report_size(report);
@@ -2016,9 +2024,15 @@ int hid_report_raw_event(struct hid_devi
 	else if (rsize > max_buffer_size)
 		rsize = max_buffer_size;
 
+	if (bsize < rsize) {
+		hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %ld)\n",
+				     report->id, rsize, bsize);
+		return -EINVAL;
+	}
+
 	if (csize < rsize) {
 		dbg_hid("report %d is too short, (%d < %d)\n", report->id,
-				csize, rsize);
+			csize, rsize);
 		memset(cdata + csize, 0, rsize - csize);
 	}
 
@@ -2027,7 +2041,7 @@ int hid_report_raw_event(struct hid_devi
 	if (hid->claimed & HID_CLAIMED_HIDRAW) {
 		ret = hidraw_report_event(hid, data, size);
 		if (ret)
-			goto out;
+			return ret;
 	}
 
 	if (hid->claimed != HID_CLAIMED_HIDRAW && report->maxfield) {
@@ -2039,7 +2053,7 @@ int hid_report_raw_event(struct hid_devi
 
 	if (hid->claimed & HID_CLAIMED_INPUT)
 		hidinput_report_event(hid, report);
-out:
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(hid_report_raw_event);
@@ -2055,12 +2069,13 @@ EXPORT_SYMBOL_GPL(hid_report_raw_event);
  *
  * This is data entry for lower layers.
  */
-int hid_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data, u32 size,
-		     int interrupt)
+int hid_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data,
+		     u32 size, int interrupt)
 {
 	struct hid_report_enum *report_enum;
 	struct hid_driver *hdrv;
 	struct hid_report *report;
+	size_t bufsize = size;
 	int ret = 0;
 
 	if (!hid)
@@ -2076,7 +2091,7 @@ int hid_input_report(struct hid_device *
 	report_enum = hid->report_enum + type;
 	hdrv = hid->driver;
 
-	data = dispatch_hid_bpf_device_event(hid, type, data, &size, interrupt);
+	data = dispatch_hid_bpf_device_event(hid, type, data, &bufsize, &size, interrupt);
 	if (IS_ERR(data)) {
 		ret = PTR_ERR(data);
 		goto unlock;
@@ -2105,7 +2120,7 @@ int hid_input_report(struct hid_device *
 			goto unlock;
 	}
 
-	ret = hid_report_raw_event(hid, type, data, size, interrupt);
+	ret = hid_report_raw_event(hid, type, data, bufsize, size, interrupt);
 
 unlock:
 	up(&hid->driver_input_lock);
--- a/drivers/hid/hid-gfrm.c
+++ b/drivers/hid/hid-gfrm.c
@@ -66,7 +66,7 @@ static int gfrm_raw_event(struct hid_dev
 	switch (data[1]) {
 	case GFRM100_SEARCH_KEY_DOWN:
 		ret = hid_report_raw_event(hdev, HID_INPUT_REPORT, search_key_dn,
-					   sizeof(search_key_dn), 1);
+					   sizeof(search_key_dn), sizeof(search_key_dn), 1);
 		break;
 
 	case GFRM100_SEARCH_KEY_AUDIO_DATA:
@@ -74,7 +74,7 @@ static int gfrm_raw_event(struct hid_dev
 
 	case GFRM100_SEARCH_KEY_UP:
 		ret = hid_report_raw_event(hdev, HID_INPUT_REPORT, search_key_up,
-					   sizeof(search_key_up), 1);
+					   sizeof(search_key_up), sizeof(search_key_up), 1);
 		break;
 
 	default:
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3692,7 +3692,7 @@ static int hidpp10_consumer_keys_raw_eve
 	memcpy(&consumer_report[1], &data[3], 4);
 	/* We are called from atomic context */
 	hid_report_raw_event(hidpp->hid_dev, HID_INPUT_REPORT,
-			     consumer_report, 5, 1);
+			     consumer_report, sizeof(consumer_report), 5, 1);
 
 	return 1;
 }
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -479,7 +479,7 @@ static void mt_get_feature(struct hid_de
 		}
 
 		ret = hid_report_raw_event(hdev, HID_FEATURE_REPORT, buf,
-					   size, 0);
+					   size, size, 0);
 		if (ret)
 			dev_warn(&hdev->dev, "failed to report feature\n");
 	}
--- a/drivers/hid/hid-primax.c
+++ b/drivers/hid/hid-primax.c
@@ -44,7 +44,7 @@ static int px_raw_event(struct hid_devic
 			data[0] |= (1 << (data[idx] - 0xE0));
 			data[idx] = 0;
 		}
-		hid_report_raw_event(hid, HID_INPUT_REPORT, data, size, 0);
+		hid_report_raw_event(hid, HID_INPUT_REPORT, data, size, size, 0);
 		return 1;
 
 	default:	/* unknown report */
--- a/drivers/hid/hid-vivaldi-common.c
+++ b/drivers/hid/hid-vivaldi-common.c
@@ -85,7 +85,7 @@ void vivaldi_feature_mapping(struct hid_
 	}
 
 	ret = hid_report_raw_event(hdev, HID_FEATURE_REPORT, report_data,
-				   report_len, 0);
+				   report_len, report_len, 0);
 	if (ret) {
 		dev_warn(&hdev->dev, "failed to report feature %d\n",
 			 field->report->id);
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -74,7 +74,7 @@ static void wacom_wac_queue_flush(struct
 		int err;
 
 		size = kfifo_out(fifo, buf, sizeof(buf));
-		err = hid_report_raw_event(hdev, HID_INPUT_REPORT, buf, size, false);
+		err = hid_report_raw_event(hdev, HID_INPUT_REPORT, buf, size, size, false);
 		if (err) {
 			hid_warn(hdev, "%s: unable to flush event due to error %d\n",
 				 __func__, err);
@@ -319,7 +319,7 @@ static void wacom_feature_mapping(struct
 					       data, n, WAC_CMD_RETRIES);
 			if (ret == n && features->type == HID_GENERIC) {
 				ret = hid_report_raw_event(hdev,
-					HID_FEATURE_REPORT, data, n, 0);
+					HID_FEATURE_REPORT, data, n, n, 0);
 			} else if (ret == 2 && features->type != HID_GENERIC) {
 				features->touch_max = data[1];
 			} else {
@@ -381,7 +381,7 @@ static void wacom_feature_mapping(struct
 					data, n, WAC_CMD_RETRIES);
 		if (ret == n) {
 			ret = hid_report_raw_event(hdev, HID_FEATURE_REPORT,
-						   data, n, 0);
+						   data, n, n, 0);
 		} else {
 			hid_warn(hdev, "%s: could not retrieve sensor offsets\n",
 				 __func__);
--- a/drivers/staging/greybus/hid.c
+++ b/drivers/staging/greybus/hid.c
@@ -201,7 +201,7 @@ static void gb_hid_init_report(struct gb
 	 * we just need to setup the input fields, so using
 	 * hid_report_raw_event is safe.
 	 */
-	hid_report_raw_event(ghid->hid, report->type, ghid->inbuf, size, 1);
+	hid_report_raw_event(ghid->hid, report->type, ghid->inbuf, ghid->bufsize, size, 1);
 }
 
 static void gb_hid_init_reports(struct gb_hid *ghid)
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1205,8 +1205,8 @@ static inline u32 hid_report_len(struct
 	return DIV_ROUND_UP(report->size, 8) + (report->id > 0);
 }
 
-int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *data, u32 size,
-			 int interrupt);
+int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *data,
+			 size_t bufsize, u32 size, int interrupt);
 
 /* HID quirks API */
 unsigned long hid_lookup_quirk(const struct hid_device *hdev);
--- a/include/linux/hid_bpf.h
+++ b/include/linux/hid_bpf.h
@@ -147,7 +147,7 @@ struct hid_bpf_link {
 
 #ifdef CONFIG_HID_BPF
 u8 *dispatch_hid_bpf_device_event(struct hid_device *hid, enum hid_report_type type, u8 *data,
-				  u32 *size, int interrupt);
+				  size_t *buf_size, u32 *size, int interrupt);
 int hid_bpf_connect_device(struct hid_device *hdev);
 void hid_bpf_disconnect_device(struct hid_device *hdev);
 void hid_bpf_destroy_device(struct hid_device *hid);
@@ -155,7 +155,7 @@ void hid_bpf_device_init(struct hid_devi
 u8 *call_hid_bpf_rdesc_fixup(struct hid_device *hdev, u8 *rdesc, unsigned int *size);
 #else /* CONFIG_HID_BPF */
 static inline u8 *dispatch_hid_bpf_device_event(struct hid_device *hid, enum hid_report_type type,
-						u8 *data, u32 *size, int interrupt) { return data; }
+						u8 *data, size_t *buf_size, u32 *size, int interrupt) { return data; }
 static inline int hid_bpf_connect_device(struct hid_device *hdev) { return 0; }
 static inline void hid_bpf_disconnect_device(struct hid_device *hdev) {}
 static inline void hid_bpf_destroy_device(struct hid_device *hid) {}


