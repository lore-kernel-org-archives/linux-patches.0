Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983591F4CB8;
	Sat,  7 Jun 2025 10:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290963; cv=none; b=OLIjsFhzN+UnUKXnt0u3U/GpbWa1uft7VOkfvHn1pUafyDZx9CAhB/fquO/8KHLstiYP3dwIhXKPN/qsFD7Aqo6SF2I6AwidB/X5OHQ9ZeV7uRNllNl9MM5YwuPZ5xe2+kXOiJfwGYsMqehvXX/ETV7otmD2mZI4oKzCiK8HQC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290963; c=relaxed/simple;
	bh=YYgm1fp8WzVI0oMvNVwN+VDXie05nppzFZ5HfuREAy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxY0G+rwg1avpUCjvmy+Pc0XtcXEnrKitrHW2uiwHg3r3WojZZzoGUckk2Q3SiJ09177BIBvJ7zhe/mkGPOK71LOYzU7dt/mOiI5E1GiPkLKw82MFRKYRgblHyt2KNplQwn7XwMU04Do8cPeKZ5cZ0JY0TPk9ET1g8kU6GGc930=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYsWdtHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYsWdtHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B04EC4CEE4;
	Sat,  7 Jun 2025 10:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290963;
	bh=YYgm1fp8WzVI0oMvNVwN+VDXie05nppzFZ5HfuREAy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYsWdtHOUi6UsntkCyevLiKTdpTiw6/f4TDkVmzEGpWD6wEXwte/Y6ppNKqMMZJXR
	 uYg1AnLouCDHsatGx/0w62Frva4snMQQtThfatJ26s9oVtXZqyV8mqaDpMU3kuDrcX
	 wmwaSuBoiFlBtRa7c+BhEGAIQQor8BJ+GSAOsV1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.14 10/24] usb: quirks: Add NO_LPM quirk for SanDisk Extreme 55AE
Date: Sat,  7 Jun 2025 12:07:50 +0200
Message-ID: <20250607100718.110802674@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
References: <20250607100717.706871523@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayi Li <lijiayi@kylinos.cn>

commit 19f795591947596b5b9efa86fd4b9058e45786e9 upstream.

This device exhibits I/O errors during file transfers due to unstable
link power management (LPM) behavior. The kernel logs show repeated
warm resets and eventual disconnection when LPM is enabled:

[ 3467.810740] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0020
[ 3467.810740] usb usb2-port5: do warm reset
[ 3467.866444] usb usb2-port5: not warm reset yet, waiting 50ms
[ 3467.907407] sd 0:0:0:0: [sda] tag#12 sense submit err -19
[ 3467.994423] usb usb2-port5: status 02c0, change 0001, 10.0 Gb/s
[ 3467.994453] usb 2-5: USB disconnect, device number 4

The error -19 (ENODEV) occurs when the device disappears during write
operations. Adding USB_QUIRK_NO_LPM disables link power management
for this specific device, resolving the stability issues.

Signed-off-by: Jiayi Li <lijiayi@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250508055947.764538-1-lijiayi@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -372,6 +372,9 @@ static const struct usb_device_id usb_qu
 	/* SanDisk Corp. SanDisk 3.2Gen1 */
 	{ USB_DEVICE(0x0781, 0x55a3), .driver_info = USB_QUIRK_DELAY_INIT },
 
+	/* SanDisk Extreme 55AE */
+	{ USB_DEVICE(0x0781, 0x55ae), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Realforce 87U Keyboard */
 	{ USB_DEVICE(0x0853, 0x011b), .driver_info = USB_QUIRK_NO_LPM },
 


