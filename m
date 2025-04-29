Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C53245007;
	Tue, 29 Apr 2025 17:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947347; cv=none; b=pt31Jc+p6xgx93TZSbXcRnIFLjQAHt0BUN8mngVJqTw9YFO/MH6Qo5xotvoVu2Cm3r0vnj5lQkyueUdR1l0Dsng55K3qIUj844BqhDqZX5MEMZXvpWPhPtAWFrK0dsLq27mm/KJ8/BUpMuICgdmGhNTEzBGaqvnYieFjritc4x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947347; c=relaxed/simple;
	bh=NLfVLDY6SPOdb5FaYdl643gB5g1+GlexmhTMfkhtGk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WINvQYdkoSV2OLobUR6IFvJfiIIWYmiohR4GP3Qz4aQwPHxDhrxKHvSbp45+9IzVfuWD0YH7av9aOtMFgzF7ABpKdCmljaNjEYRpVKIi59VTdgj3/dr+yP+xkW/kdPLnV6NbX8DslifmqT7dBR8GHBuFrUHMF98EdxrX15SqvDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGwT1GX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGwT1GX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C671C4CEE3;
	Tue, 29 Apr 2025 17:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947347;
	bh=NLfVLDY6SPOdb5FaYdl643gB5g1+GlexmhTMfkhtGk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGwT1GX+CAAKCGCnzaNNKqiG5rv6TzhkX60U0QDlX4Bf/PWg52aqvYDsJR/AnRggK
	 RT5d3qeRNHbGPOpCPD5CR6s1BrRXYG35H4vtScXPZkDTUBOwqUgY2DlsBcAnmRFLfF
	 Da2OWUP23jvmTxJpDHjAwPEMSde0Vq9zYuahWiXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miao Li <limiao@kylinos.cn>,
	Lei Huang <huanglei@kylinos.cn>
Subject: [PATCH 5.10 251/286] usb: quirks: Add delay init quirk for SanDisk 3.2Gen1 Flash Drive
Date: Tue, 29 Apr 2025 18:42:35 +0200
Message-ID: <20250429161118.248556024@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miao Li <limiao@kylinos.cn>

commit 37ffdbd695c02189dbf23d6e7d2385e0299587ca upstream.

The SanDisk 3.2Gen1 Flash Drive, which VID:PID is in 0781:55a3,
just like Silicon Motion Flash Drive:
https://lore.kernel.org/r/20250401023027.44894-1-limiao870622@163.com
also needs the DELAY_INIT quirk, or it will randomly work incorrectly
(e.g.: lsusb and can't list this device info) when connecting Huawei
hisi platforms and doing thousand of reboot test circles.

Cc: stable <stable@kernel.org>
Signed-off-by: Miao Li <limiao@kylinos.cn>
Signed-off-by: Lei Huang <huanglei@kylinos.cn>
Link: https://lore.kernel.org/r/20250414062935.159024-1-limiao870622@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -366,6 +366,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0781, 0x5583), .driver_info = USB_QUIRK_NO_LPM },
 	{ USB_DEVICE(0x0781, 0x5591), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* SanDisk Corp. SanDisk 3.2Gen1 */
+	{ USB_DEVICE(0x0781, 0x55a3), .driver_info = USB_QUIRK_DELAY_INIT },
+
 	/* Realforce 87U Keyboard */
 	{ USB_DEVICE(0x0853, 0x011b), .driver_info = USB_QUIRK_NO_LPM },
 


