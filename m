Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FE026B971;
	Mon, 13 Apr 2026 16:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098256; cv=none; b=UuNtUMNIVmjiNT05guPhYUIbXeRipbZoHKZ0i7DiLKECsRehNioRCESbpREkdwkwFPnFVto6uu1FB7D6dO1alyQAET4qCT0IWLbYLrbFCBzPMLgd2I0mjwWpnLFTMYV7LXhuIDPKKDo8WkMcBSx+MGdHKJ1T3i1d1bB/G8ywXZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098256; c=relaxed/simple;
	bh=4ebsYMOhy0cNRlK2XsZeyevxQGZ3hDIePKsQtARORYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tn0GHbWQeM2yxYgbRMpGC9hZ73fhNg3ZGSXnGE51f2H+KmSSfDBtKhTyY2Pp/+KMQ15Pc2u1Yq5d8OnJrmIhX6tbwsgq8/fjqWSrGtmuBhU0kSmP8ryemEcDheoIRU0aTNGY8SS9YnqiO9/+6p+KekXtUVBK7R31ArT8FH4BxWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnQ5XHeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnQ5XHeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D790C2BCAF;
	Mon, 13 Apr 2026 16:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098256;
	bh=4ebsYMOhy0cNRlK2XsZeyevxQGZ3hDIePKsQtARORYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnQ5XHeq9ziaJM4+Nm8ndOUMEmlSh8l7dfUixgK9N13x8hFuq6INPktwfXQLSrDPB
	 L5xV8sWQYvNsGyEsI7icRhrgBkGQkQeLveSYQa61pQ2gBJi9WUPfyZNO/B7UsO5Goz
	 usc8rH+wSOv2hpDhc4wbDCVjhiPi9t0N0dlFQysI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	JP Hein <jp@jphein.com>
Subject: [PATCH 5.15 455/570] USB: core: add NO_LPM quirk for Razer Kiyo Pro webcam
Date: Mon, 13 Apr 2026 17:59:46 +0200
Message-ID: <20260413155847.513669553@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: JP Hein <jp@jphein.com>

commit 8b7a42ecdcdeb55580d9345412f7f8fc5aca3f6c upstream.

The Razer Kiyo Pro (1532:0e05) is a USB 3.0 UVC webcam whose firmware
does not handle USB Link Power Management transitions reliably. When LPM
is active, the device can enter a state where it fails to respond to
control transfers, producing EPIPE (-32) errors on UVC probe control
SET_CUR requests. In the worst case, the stalled endpoint triggers an
xHCI stop-endpoint command that times out, causing the host controller
to be declared dead and every USB device on the bus to be disconnected.

This has been reported as Ubuntu Launchpad Bug #2061177. The failure
mode is:

  1. UVC probe control SET_CUR returns -32 (EPIPE)
  2. xHCI host not responding to stop endpoint command
  3. xHCI host controller not responding, assume dead
  4. All USB devices on the affected xHCI controller disconnect

Disabling LPM prevents the firmware from entering the problematic low-
power states that precede the stall. This is the same approach used for
other webcams with similar firmware issues (e.g., Logitech HD Webcam C270).

Cc: stable <stable@kernel.org>
Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2061177
Signed-off-by: JP Hein <jp@jphein.com>
Link: https://patch.msgid.link/20260331003806.212565-2-jp@jphein.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -476,6 +476,8 @@ static const struct usb_device_id usb_qu
 	/* Razer - Razer Blade Keyboard */
 	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
 			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
+	/* Razer - Razer Kiyo Pro Webcam */
+	{ USB_DEVICE(0x1532, 0x0e05), .driver_info = USB_QUIRK_NO_LPM },
 
 	/* Lenovo ThinkPad OneLink+ Dock twin hub controllers (VIA Labs VL812) */
 	{ USB_DEVICE(0x17ef, 0x1018), .driver_info = USB_QUIRK_RESET_RESUME },


