Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E823480320;
	Tue, 25 Aug 2026 13:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664750; cv=none; b=e5ZEtrjMNOzNxDwu2RTrS4z7622OyVsJMsSTxcB6FRuDXRTyN2t3FLEDiCWhoOFH4z7NVQ3c1AYZdQ8GzwHZV68VtkZsI3SfdPwrjhiaqYYO6rgfntO5SjK6xcx6ov7/XWa9SxKRtmEWAiUlwAEPNT0R9etjrN9h6ethE855pd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664750; c=relaxed/simple;
	bh=Bin5nAOm88RZY5c9R2e4YSyn5ENGdMmjE+GD7zcBnm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNujrqKZYQNYBDsOvHy1hG+/zPClr+YNjIxIQqk0xs0FZYaa9jAbwgCxEta8Xdl6CEXK4eUp8I5LKCWXxCJ8kVPbXUbvEKm9lsxgzQ5yuG68FAjPjYUgng8KeBYTVfIvGATofeEoTAZ1xr9yNhUQWPUWhLGlV7+Q/fmudfXSbns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnD8jbH8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnD8jbH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED591F000E9;
	Tue, 25 Aug 2026 13:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664749;
	bh=WtMquueCnu3JGsVp95hpTLXZBeT2s4a9aHbeUD0QOmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnD8jbH8hCQKWL6I0lp3hsYWins7eqOZcsRpoOR3z/1PCFjriLNtPdiwuWW1svyts
	 siMPaF/MgNUhTJE0UjvYMuwVH0Xwc6jx3Iv4rXD3SLvFgXyoYTo7z/RhUackXFo4Ox
	 wdpJ8CxyQQnFo9WcssDgiO63YAUPCkgGgg7I6tG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 73/82] HID: hyperv: validate initial device info bounds
Date: Tue, 25 Aug 2026 15:26:00 +0200
Message-ID: <20260825132544.352141939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 934b7778aa7b7c8f6bb073d2a73ba3674885bae0 upstream.

The Hyper-V synthetic HID host supplies SYNTH_HID_INITIAL_DEVICE_INFO
messages that contain a HID descriptor followed by the report descriptor
bytes. mousevsc_on_receive_device_info() trusts bLength and
wDescriptorLength without checking that the received packet contains both
byte ranges.

A malformed host or backend message can therefore make the guest read
past the received VMBus packet while copying the report descriptor. Pass
the received initial-device-info size into the parser and reject
descriptor lengths that exceed the packet.

Impact: A malicious Hyper-V host or backend can crash a guest by sending
a short initial device-info message with an oversized HID report
descriptor length.

Fixes: b95f5bcb811e ("HID: Move the hid-hyperv driver out of staging")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5-5-xhigh
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-hyperv.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -171,18 +171,32 @@ static void mousevsc_free_device(struct
 }
 
 static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
-				struct synthhid_device_info *device_info)
+					    struct synthhid_device_info *device_info,
+					    u32 device_info_size)
 {
 	int ret = 0;
 	struct hid_descriptor *desc;
 	struct mousevsc_prt_msg ack;
+	size_t desc_offset;
+	size_t desc_size;
 
 	input_device->dev_info_status = -ENOMEM;
 
+	if (device_info_size < sizeof(*device_info)) {
+		input_device->dev_info_status = -EINVAL;
+		goto cleanup;
+	}
+
 	input_device->hid_dev_info = device_info->hid_dev_info;
 	desc = &device_info->hid_descriptor;
+	desc_offset = offsetof(struct synthhid_device_info, hid_descriptor);
+	desc_size = device_info_size - desc_offset;
 	if (desc->bLength == 0)
 		goto cleanup;
+	if (desc->bLength < sizeof(*desc) || desc->bLength > desc_size) {
+		input_device->dev_info_status = -EINVAL;
+		goto cleanup;
+	}
 
 	/* The pointer is not NULL when we resume from hibernation */
 	kfree(input_device->hid_desc);
@@ -197,6 +211,10 @@ static void mousevsc_on_receive_device_i
 		input_device->dev_info_status = -EINVAL;
 		goto cleanup;
 	}
+	if (input_device->report_desc_size > desc_size - desc->bLength) {
+		input_device->dev_info_status = -EINVAL;
+		goto cleanup;
+	}
 
 	/* The pointer is not NULL when we resume from hibernation */
 	kfree(input_device->report_desc);
@@ -273,14 +291,17 @@ static void mousevsc_on_receive(struct h
 		break;
 
 	case SYNTH_HID_INITIAL_DEVICE_INFO:
-		WARN_ON(pipe_msg->size < sizeof(struct hv_input_dev_info));
+		if (WARN_ON_ONCE(pipe_msg->size <
+				 sizeof(struct synthhid_device_info)))
+			break;
 
 		/*
 		 * Parse out the device info into device attr,
 		 * hid desc and report desc
 		 */
 		mousevsc_on_receive_device_info(input_dev,
-			(struct synthhid_device_info *)pipe_msg->data);
+						(struct synthhid_device_info *)pipe_msg->data,
+						pipe_msg->size);
 		break;
 	case SYNTH_HID_INPUT_REPORT:
 		input_report =


