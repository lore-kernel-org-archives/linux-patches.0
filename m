Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFE7257855;
	Sun,  7 Jun 2026 10:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828863; cv=none; b=AqOuKGu/b2paZEsslYod6i3mmELZ4SMfQMxb/jMwaxZQ/khewKz7Pwx+gY/OP8jI2uFgDuQfnJlZZdQjo05IO9yvraa6S+Zpku2nIEBlEFgJ3rB6QHsS93aE9S7KORveYhNPmzZjERJyfybjQI2RWkfLjvvdqdpxY4AJ5vufWJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828863; c=relaxed/simple;
	bh=KWmSYggZwNqmrUd0oORzJoz8usVhf4rlPKv3WklfJNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tg1kmH/IoS37/O+oL6Ze0BQt3RdCjpHyl573gtujUFlANY9hml7vpdN6NHWZSptJpdse5ZGr1NLbrYuj3lqRqcxSWXzUSPLWtGawugMvPntzts6pMNkIYN3vnEC8AQJ2XUITIz+AOmbIY2MbKSBU3Pvas8Ach/AOZ9Fd3+aOCsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Le2SwKKn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Le2SwKKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1E11F00893;
	Sun,  7 Jun 2026 10:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828862;
	bh=yZQdIH0laiEOmwB9tpQUwLQvPYlq8U/Lcp2vXWK1IUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Le2SwKKnT5Zi1USNkd8nsvqoVwvr49Gi+cZE7d3xzdWsuJhX0p9/0acC3zivitPFn
	 1eCw2/YM1JGOApaIPzMpxOgOcfMMSa6Y1IH2QHLwr98y6x0In/mNsZ54RtDUuoTORv
	 0/2pZjo2u5xt7RrDXz7gkJolmiT3fhv+SLwVzahc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Lee Jones <lee@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.18 197/315] HID: wacom: Fix OOB write in wacom_hid_set_device_mode()
Date: Sun,  7 Jun 2026 11:59:44 +0200
Message-ID: <20260607095734.806347423@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Lee Jones <lee@kernel.org>

commit c0a8899e02ddebd51e2589835182c239c2e224ae upstream.

wacom_hid_set_device_mode() currently assumes that the HID_DG_INPUTMODE
usage is always located in the first field (field[0]) of the feature report.
However, a device can specify HID_DG_INPUTMODE in a different field.

If HID_DG_INPUTMODE is in a field other than the first one and the first
field has a report_count smaller than the usage_index of HID_DG_INPUTMODE,
this leads to an out-of-bounds write to r->field[0]->value.

Fix this by storing the field index of HID_DG_INPUTMODE in 'struct
hid_data' during feature mapping.  In wacom_hid_set_device_mode(), use
this stored field index to access the correct field and add bounds
checks to ensure both the field index and the value index are within
valid ranges before writing.

Cc: stable@vger.kernel.org
Fixes: 5ae6e89f7409 ("HID: wacom: implement the finger part of the HID generic handling")
Tested-by: Ping Cheng <ping.cheng@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |   13 ++++++++++---
 drivers/hid/wacom_wac.h |    1 +
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -356,6 +356,7 @@ static void wacom_feature_mapping(struct
 
 		hid_data->inputmode = field->report->id;
 		hid_data->inputmode_index = usage->usage_index;
+		hid_data->inputmode_field_index = field->index;
 		break;
 
 	case HID_UP_DIGITIZER:
@@ -571,9 +572,14 @@ static int wacom_hid_set_device_mode(str
 
 	re = &(hdev->report_enum[HID_FEATURE_REPORT]);
 	r = re->report_id_hash[hid_data->inputmode];
-	if (r) {
-		r->field[0]->value[hid_data->inputmode_index] = 2;
-		hid_hw_request(hdev, r, HID_REQ_SET_REPORT);
+	if (r && hid_data->inputmode_field_index >= 0 &&
+	    hid_data->inputmode_field_index < r->maxfield) {
+		struct hid_field *field = r->field[hid_data->inputmode_field_index];
+
+		if (field && hid_data->inputmode_index < field->report_count) {
+			field->value[hid_data->inputmode_index] = 2;
+			hid_hw_request(hdev, r, HID_REQ_SET_REPORT);
+		}
 	}
 	return 0;
 }
@@ -2846,6 +2852,7 @@ static int wacom_probe(struct hid_device
 		return -ENODEV;
 
 	wacom_wac->hid_data.inputmode = -1;
+	wacom_wac->hid_data.inputmode_field_index = -1;
 	wacom_wac->mode_report = -1;
 
 	if (hid_is_usb(hdev)) {
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -295,6 +295,7 @@ struct wacom_shared {
 struct hid_data {
 	__s16 inputmode;	/* InputMode HID feature, -1 if non-existent */
 	__s16 inputmode_index;	/* InputMode HID feature index in the report */
+	__s16 inputmode_field_index; /* InputMode HID feature field index in the report */
 	bool sense_state;
 	bool inrange_state;
 	bool eraser;


