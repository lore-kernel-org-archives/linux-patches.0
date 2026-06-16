Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C538838F930;
	Tue, 16 Jun 2026 17:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630756; cv=none; b=MqWVDAWdxkvyGPdVDR+5teGrElaqT2YkXcMvMVVIPdZzEqkkK+WT+3lAuJ+qf5w0u8iCdpoZ7WqlAYM+nklMeDD5e/HrJ9hGY9BF73HraSvEXXWas5rhqiN7O9vcwIMvUCoBiumIhaZOHxdFPSsNvY8rPMb94qyeiiqXfPYrdi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630756; c=relaxed/simple;
	bh=AKmUy2yeCSlkyQZIAgYRkX+DOg4s3J+MmmiSZfpjCgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqP7EOWJYQyNIkBUh0h5DhrcQuLje9NjTqizMmK8eRPzBFgDYmtq4IVgHDs8KceA0nBX8RrMeRTJbI67X0pcMZkRosFN6ELDE0N1a3H0WXqvGAf8iUIG1enbXivwl/wfCTCiji9FWW96eVHT4mgBqZz/kfkdc1qTGfvah+9LeE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eASON7WB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eASON7WB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5451F000E9;
	Tue, 16 Jun 2026 17:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630755;
	bh=31l7LMrid9ePS4d5SqUwFecBskp6ocTfyg/ZsNdQ7vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eASON7WBf52o9yVR+76zpBiD4eYh4uPuEC58cXXB+dWMnY617NeJf9zYCxxTE40dp
	 KRlRlSpt2c4NZv2xbPOOzTMQqsenWLnrO6jqv06xViii/oOa28Yw91jOYfK0yJ7U7o
	 PKh7KfDWOCuxECx2WxoBwRlWvtvO/qlTKxe0Lh3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hlleng <a909204013@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.1 090/522] HID: quirks: Add ALWAYS_POLL quirk for SIGMACHIP USB mouse
Date: Tue, 16 Jun 2026 20:23:57 +0530
Message-ID: <20260616145130.087596452@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hlleng <a909204013@gmail.com>

commit 07466fc91c55532edcfb5c6a7ccd2ea52728d6bd upstream.

The SIGMACHIP USB mouse with VID/PID 1c4f:0034 can disconnect and
re-enumerate repeatedly after it has been enumerated if its interrupt
endpoint is not continuously polled.

This was observed with the device reporting itself as "SIGMACHIP Usb
Mouse". Keeping the input event device open avoids the disconnects.

Add HID_QUIRK_ALWAYS_POLL for this device so the HID core keeps polling
it even when there is no userspace input consumer.

Cc: stable@vger.kernel.org
Signed-off-by: hlleng <a909204013@gmail.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h    |    1 +
 drivers/hid/hid-quirks.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1167,6 +1167,7 @@
 
 #define USB_VENDOR_ID_SIGMA_MICRO	0x1c4f
 #define USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD	0x0002
+#define USB_DEVICE_ID_SIGMA_MICRO_USB_MOUSE	0x0034
 #define USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD2	0x0059
 
 #define USB_VENDOR_ID_SIGMATEL		0x066F
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -175,6 +175,7 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SENNHEISER, USB_DEVICE_ID_SENNHEISER_BTD500USB), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD), HID_QUIRK_NO_INIT_REPORTS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_USB_MOUSE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SIGMATEL, USB_DEVICE_ID_SIGMATEL_STMP3780), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SIS_TOUCH, USB_DEVICE_ID_SIS1030_TOUCH), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SIS_TOUCH, USB_DEVICE_ID_SIS817_TOUCH), HID_QUIRK_NOGET },


