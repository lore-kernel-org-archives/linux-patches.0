Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD561130E33;
	Tue, 23 Jan 2024 00:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969058; cv=none; b=VHSimDIEN7a+IgnmrBCg/JLuW/LqB8ukv1PtFSobzidvPTqo93ABVZHvWIn6XjWIOco5MFrXEjTXHgaz4QXyTmiSddDxta31BWlBWGHiTggqMTqw0QYOlTeFTM9Xb3rRnySko5irAXR02YasxJribwb9mlc4OHT1Fp9rn5rCAZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969058; c=relaxed/simple;
	bh=b4Oiv4aX6Dy7bMpm7rXw9duaozSTfDRzZzl8iJUfyco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hl1pczOP2O4s7VvyLY1ZF9XpV8iJL/j6QWLytY96MA5A1zf/TOlQuXuG/viw7PUKqmWqBeZJ3/LX0iVy0WF1igesbSzcGeGIcMZl3/n+woWp1YN0HQKmJimyU/BPTOz5TZ2FgIJyZSVn5AoEDMYneTf/Xqzq3bJJrQLcIGbnFeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYzdlXls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYzdlXls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E014C43390;
	Tue, 23 Jan 2024 00:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969057;
	bh=b4Oiv4aX6Dy7bMpm7rXw9duaozSTfDRzZzl8iJUfyco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYzdlXlsD15iTQ4W6gtUR0qgX9lnFAXDHbsLCL6XOcz3mkhbzEQmEPl1kms/nxDs+
	 DnBJ9h9VZLTi05GJxY0b/Z9ZmXhE5Ss1pDOCFd4mO/7FZFU9mcsUR+F0pmtzO4liMm
	 WusvD6PpgbFn0mKw9O4saKsyo0AmjwYbTU7v3u8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.4 162/194] HID: wacom: Correct behavior when processing some confidence == false touches
Date: Mon, 22 Jan 2024 15:58:12 -0800
Message-ID: <20240122235726.138330866@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gerecke <jason.gerecke@wacom.com>

commit 502296030ec6b0329e00f9fb15018e170cc63037 upstream.

There appear to be a few different ways that Wacom devices can deal with
confidence:

  1. If the device looses confidence in a touch, it will first clear
     the tipswitch flag in one report, and then clear the confidence
     flag in a second report. This behavior is used by e.g. DTH-2452.

  2. If the device looses confidence in a touch, it will clear both
     the tipswitch and confidence flags within the same report. This
     behavior is used by some AES devices.

  3. If the device looses confidence in a touch, it will clear *only*
     the confidence bit. The tipswitch bit will remain set so long as
     the touch is tracked. This behavior may be used in future devices.

The driver does not currently handle situation 3 properly. Touches that
loose confidence will remain "in prox" and essentially frozen in place
until the tipswitch bit is finally cleared. Not only does this result
in userspace seeing a stuck touch, but it also prevents pen arbitration
from working properly (the pen won't send events until all touches are
up, but we don't currently process events from non-confident touches).

This commit centralizes the checking of the confidence bit in the
wacom_wac_finger_slot() function and has 'prox' depend on it. In the
case where situation 3 is encountered, the treat the touch as though
it was removed, allowing both userspace and the pen arbitration to
act normally.

Signed-off-by: Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>
Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Fixes: 7fb0413baa7f ("HID: wacom: Use "Confidence" flag to prevent reporting invalid contacts")
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |   32 ++++----------------------------
 1 file changed, 4 insertions(+), 28 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2612,8 +2612,8 @@ static void wacom_wac_finger_slot(struct
 {
 	struct hid_data *hid_data = &wacom_wac->hid_data;
 	bool mt = wacom_wac->features.touch_max > 1;
-	bool prox = hid_data->tipswitch &&
-		    report_touch_events(wacom_wac);
+	bool touch_down = hid_data->tipswitch && hid_data->confidence;
+	bool prox = touch_down && report_touch_events(wacom_wac);
 
 	if (wacom_wac->shared->has_mute_touch_switch &&
 	    !wacom_wac->shared->is_touch_on) {
@@ -2652,24 +2652,6 @@ static void wacom_wac_finger_slot(struct
 	}
 }
 
-static bool wacom_wac_slot_is_active(struct input_dev *dev, int key)
-{
-	struct input_mt *mt = dev->mt;
-	struct input_mt_slot *s;
-
-	if (!mt)
-		return false;
-
-	for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
-		if (s->key == key &&
-			input_mt_get_value(s, ABS_MT_TRACKING_ID) >= 0) {
-			return true;
-		}
-	}
-
-	return false;
-}
-
 static void wacom_wac_finger_event(struct hid_device *hdev,
 		struct hid_field *field, struct hid_usage *usage, __s32 value)
 {
@@ -2717,14 +2699,8 @@ static void wacom_wac_finger_event(struc
 	}
 
 	if (usage->usage_index + 1 == field->report_count) {
-		if (equivalent_usage == wacom_wac->hid_data.last_slot_field) {
-			bool touch_removed = wacom_wac_slot_is_active(wacom_wac->touch_input,
-				wacom_wac->hid_data.id) && !wacom_wac->hid_data.tipswitch;
-
-			if (wacom_wac->hid_data.confidence || touch_removed) {
-				wacom_wac_finger_slot(wacom_wac, wacom_wac->touch_input);
-			}
-		}
+		if (equivalent_usage == wacom_wac->hid_data.last_slot_field)
+			wacom_wac_finger_slot(wacom_wac, wacom_wac->touch_input);
 	}
 }
 


