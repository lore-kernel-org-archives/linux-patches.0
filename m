Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8639F3D4134;
	Wed,  8 Apr 2026 18:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673279; cv=none; b=pBFv32AJ6dNuSmRtGFQVhmBStw7wDBkqtXHbFw7na5WDtMtQdxaOKpl6pbBhtjy6WjvJx8i2IM9luJAU/5CoCHq0qSx3HfU6fv2EJp8Z/HaaYBOVV2pyR6aX5i0/H36waop8PY6GO9eoLtaUXYD4X38QVw01zDy6DyvnAa5js7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673279; c=relaxed/simple;
	bh=ZytMJ/vuxKqY0rU33cIylcGhvkVeRQzi7g0KKQTYhhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvcM9dD3+h//m/pYDbM+gAuLklMe53Ay8SL24SLxdQtrXz2yK5Mf3+AtmfaOIjptNJK4MDhWeZFcZ167d+YB/ciZj4JCfil1cuDtQvTRRvr80J6xNbJbCz4baBBgjGMrTQnTBWkSD8XYhXjJYoUuzrr6RW5KKkVyIoXxMYIYvcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umDgPigN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umDgPigN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C96FC19421;
	Wed,  8 Apr 2026 18:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673279;
	bh=ZytMJ/vuxKqY0rU33cIylcGhvkVeRQzi7g0KKQTYhhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umDgPigNYL1LYcg70zs+MawkyyDbBp6YBXqJnWOF+TzICiyvx8zEXrXwmcVX6ZyBS
	 N7hrdqDUwlXaZaPtRROBFxzEZabGa1N+XGiSboDekOTYqhcvQmj9lWKZTfTLjP2V/1
	 FJ3EsLgRXGtzwDTUQcoWDLD3gTNDW0xfifO7Yiko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	JP Hein <jp@jphein.com>
Subject: [PATCH 6.18 170/277] USB: core: add NO_LPM quirk for Razer Kiyo Pro webcam
Date: Wed,  8 Apr 2026 20:02:35 +0200
Message-ID: <20260408175940.214786280@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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
@@ -493,6 +493,8 @@ static const struct usb_device_id usb_qu
 	/* Razer - Razer Blade Keyboard */
 	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
 			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
+	/* Razer - Razer Kiyo Pro Webcam */
+	{ USB_DEVICE(0x1532, 0x0e05), .driver_info = USB_QUIRK_NO_LPM },
 
 	/* Lenovo ThinkPad OneLink+ Dock twin hub controllers (VIA Labs VL812) */
 	{ USB_DEVICE(0x17ef, 0x1018), .driver_info = USB_QUIRK_RESET_RESUME },


