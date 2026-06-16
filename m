Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E59B35AC3E;
	Tue, 16 Jun 2026 18:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635584; cv=none; b=UIH7DzBU8LaR6Up8Ij3QMqOfrCgxB5+62NKqEF+yokyLaC4lhHLD0r6n7lDPiDK43h8b3x4nVIiJj05kjd+rcHePImWcD981ZYyBczFLagyWlNs7UZe2RnYrEccLDiSlmatO8Cj9adGESWLFPMjEZmkSOH5usYKYFyJjvFpAIr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635584; c=relaxed/simple;
	bh=GAxSJfInHXjS05DJCHz7n+AnwUMx4RzOAM97lF+O96A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pH9oxclUhU2HlC4cFg2f6Ar+Ec6ylIahIJJybaCPvHW1RP8zrJANASEBKYXvLfr3M2o0BkLrYfbENtDwUSAg/Bmq4bJQipX0IjsmHx77+iGDPWAzDZ7RIQoi3Az5obDa/yzPgKnwWXfA+3jbubvCVyhEFZ4nl3ifgDjgyTB1Kuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wr0F8YXZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wr0F8YXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671BB1F00A3A;
	Tue, 16 Jun 2026 18:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635583;
	bh=zQiPn3vdjuJC18IiV4zsJZZE+JpLbwE9dCWi4/q8CfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wr0F8YXZcqWQQqUkX9Au1nZvDMWzULqxnmSPp5VeZ7AeMwBCImNagw3vAedOut6l0
	 94ISLFdzeDW1M03x+XHdRZX6ucMX+yhPC5JM3JoW8HFOEUIqhMvTGgiLASJbvVIoMK
	 l9FBfhpgErMGuQlpsiTJUeNGnrgS2H2cm4pB6j8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Lee Jones <lee@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.10 076/342] HID: wacom: Fix OOB write in wacom_hid_set_device_mode()
Date: Tue, 16 Jun 2026 20:26:12 +0530
Message-ID: <20260616145051.785546335@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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
@@ -346,6 +346,7 @@ static void wacom_feature_mapping(struct
 
 		hid_data->inputmode = field->report->id;
 		hid_data->inputmode_index = usage->usage_index;
+		hid_data->inputmode_field_index = field->index;
 		break;
 
 	case HID_UP_DIGITIZER:
@@ -561,9 +562,14 @@ static int wacom_hid_set_device_mode(str
 
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
@@ -2815,6 +2821,7 @@ static int wacom_probe(struct hid_device
 		return error;
 
 	wacom_wac->hid_data.inputmode = -1;
+	wacom_wac->hid_data.inputmode_field_index = -1;
 	wacom_wac->mode_report = -1;
 
 	if (hid_is_usb(hdev)) {
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -296,6 +296,7 @@ struct wacom_shared {
 struct hid_data {
 	__s16 inputmode;	/* InputMode HID feature, -1 if non-existent */
 	__s16 inputmode_index;	/* InputMode HID feature index in the report */
+	__s16 inputmode_field_index; /* InputMode HID feature field index in the report */
 	bool sense_state;
 	bool inrange_state;
 	bool invert_state;


