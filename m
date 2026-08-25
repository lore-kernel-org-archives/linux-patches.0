Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C31542E01B;
	Tue, 25 Aug 2026 13:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665333; cv=none; b=lqQm8JHCVRLxlj0+O7wAIeCLV3IXJaP87qSpltCL2u8xTzAL5xdXdYT1NYU+bdNaDfmftH/+G0HhufAbzXWZvJCtj8vOTHnIJfjr/JS3d4I9qgxjDuuHFYrwkxXmneYpcpt86lg/oALIY2kck/F1OI1jEUEpgqZ8+VzYY9/6dQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665333; c=relaxed/simple;
	bh=y0oD0Q3LBt68BvsOuzfZ4pTKkVcSJg3Ekq27e1SpJXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHBCYsGyKDByGhu1Az+qZN6Vd1CwOC0CB2RajOj+2m0ZMM7z2EPwHEfqA5ssA+HBFAlAesz3F/qOlkzrrr7UVeYE+y06X0E0tSwi2NifNU51MfbtbLBSEh3uB+ntBemZgNgwnVJ02oSbQeUx+PVp3C8IjlMhABqitYbeP6nLtiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1jXh+vI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1jXh+vI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6221F000E9;
	Tue, 25 Aug 2026 13:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665332;
	bh=gmt+SHgEBap0iqD/3tzTn2FfXfGYKxbQWQtXhezus8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H1jXh+vIqSpuC4vu8YzzzHk4RYrt7+xHWUWof+lgnBOrf6oBm0AUGzr1fhPI/cOs9
	 qSJwPeJICBEPZ9kIsTMUG90UR8JEcg7PaatdpesERsCLG/X4XXZd7i6I3BUHWLJP6X
	 4bVYA9458kYR4VYFHatunXKsszB3CXvWeM6SDW2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 86/94] HID: hyperv: validate initial device info bounds
Date: Tue, 25 Aug 2026 15:26:22 +0200
Message-ID: <20260825132545.175173418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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


