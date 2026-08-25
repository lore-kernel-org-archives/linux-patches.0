Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D3247D471;
	Tue, 25 Aug 2026 14:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666486; cv=none; b=VAYei5AJFOA5AdCKel3G0cdXeQtT5Ao4aMxf70kzmPlON0XNTA134Q5GoAzorng2QNTgVMjN/mOPHn9kZxxAFcLX1stcT4cvkg1hncME+kHar7Yk3v2JbLeHg/R18JDcxFPsZMoc7Ve52OELl/L6K1XjZY/XljFDrvXfJ32YEYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666486; c=relaxed/simple;
	bh=L/1OpER6abIqXdsYqa+Z8lEJ40YTUxGKkNygeCF/j/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oyv33iBuGudaAHWMpUF0vvuMHRUm/94oLaZnYyJxS4YsZGKJu48dqZ+Ltbmmc4bmi7qVh+EPWiiEApsxQkiQlE/8lDgg11rKzisjSukQiF1pIkqh/MrGjjZUwdmzHeteQ0w3RZ8h9UO4apo5+/0MtjSII6QQgQTeTKW8voTElho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJZzJroq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJZzJroq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0ED31F000E9;
	Tue, 25 Aug 2026 14:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666485;
	bh=9+QMXgAQOY9hz6ThzGxx2vd6ifk/b/m5hvR4+3GFzug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJZzJroqHaj2SWC4wEQvc/x6mzmCh76t6LnjwugMY/Tlfrk7mJPAiWdw4FIc1gkGv
	 px8oX1qpYouR30fnj/gmSlWayu/eNgXmAFHG3NtijyWi3Aq+X4lCJ51WttI7kE2CZV
	 ElV0jiZL4suxAFNWJS8OYDohvEbASuGi7y+s+7Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 57/57] HID: hyperv: validate initial device info bounds
Date: Tue, 25 Aug 2026 15:27:19 +0200
Message-ID: <20260825132543.570945766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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
@@ -179,18 +179,32 @@ static void mousevsc_free_device(struct
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
@@ -205,6 +219,10 @@ static void mousevsc_on_receive_device_i
 		input_device->dev_info_status = -EINVAL;
 		goto cleanup;
 	}
+	if (input_device->report_desc_size > desc_size - desc->bLength) {
+		input_device->dev_info_status = -EINVAL;
+		goto cleanup;
+	}
 
 	/* The pointer is not NULL when we resume from hibernation */
 	kfree(input_device->report_desc);
@@ -285,14 +303,17 @@ static void mousevsc_on_receive(struct h
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


