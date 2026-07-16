Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BBA3161AD;
	Thu, 16 Jul 2026 14:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211063; cv=none; b=pNbjhZA0kC/xqvyBAtgUR8rEVBNMyFyhe+at65ELFC1RhA2Z1tXv9ciSFpdI5d6ppacywmWlAnDHEA0fzLdt+emtU48q6yz9zQNpPvnYE+emOCtFwZRF5Kroh2gg8vL57Jg5U59RQMkA6rO1ow2KjuwC3uEk9PB8J5gGeYiBMdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211063; c=relaxed/simple;
	bh=/JSNMwjImhmyqnJH5SWLBZnj3FEMu13VpcwJ7KQCRVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OfGdZNjt4vEgFBZZpXmAEsrp1YWlbLVM3jEZLZYyGD8lAGpf41mitaqAHUBhQcCd9rmJ/70bUGo9NEORTgVdiKj0RKRR0amgdQxbsQB99NIYx3RFWms3Di2rRlsFAScDWPH5/9D70NTRZvYhxrGHEb1i5XCDe/9ELt9VhEScXkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtWQEZ27; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtWQEZ27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B5B1F000E9;
	Thu, 16 Jul 2026 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211062;
	bh=AWQwVfKZmXINIQz1Qn2tOv9sJMbOTkCc6bgTYR1l/Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtWQEZ27L5aY7EfOxbyQAyKgyMjiO7hTQin5hz+OqwOZnCGfEUsoZN4WfsjcPf114
	 zFd+7Ywns7q2u5vs8szb+86EHJV3TGV1woOMo4zwYsgOTE1rE/iKaNL6137DIBU0bc
	 aLaI9VME74YDkSI2jKjLcpFr2sJofS4gfoMW6ZkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rodrigo=20Lugathe=20da=20Concei=C3=A7=C3=A3o=20Alves?= <lugathe2@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 286/480] USB: core: add USB_QUIRK_NO_LPM for VIA Labs USB 2.0 hub
Date: Thu, 16 Jul 2026 15:30:33 +0200
Message-ID: <20260716133051.012232353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Lugathe da Conceição Alves <lugathe2@gmail.com>

commit bd728c3d9b1cc0bb0fda6a7055c5c8b55d7477b2 upstream.

The VIA Labs, Inc. USB 2.0 hub controller (2109:2817),
found in a KVM switch, fails to enumerate high-power devices during
cold boot and system restart.

Applying the kernel parameter
  usbcore.quirks=2109:2817:k
resolves the issue.

Enumeration failure log:
  usb 1-1.2.3: device descriptor read/64, error -32
  usb 1-1.2.3: Device not responding to setup address.
  usb 1-1.2.3: device not accepting address 11, error -71
  usb 1-1.2-port3: unable to enumerate USB device

Add USB_QUIRK_NO_LPM for this device.

Signed-off-by: Rodrigo Lugathe da Conceição Alves <lugathe2@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260603113626.395612-1-lugathe2@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -577,6 +577,9 @@ static const struct usb_device_id usb_qu
 	/* VLI disk */
 	{ USB_DEVICE(0x2109, 0x0711), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* VIA Labs, Inc. USB2.0 Hub */
+	{ USB_DEVICE(0x2109, 0x2817), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Raydium Touchscreen */
 	{ USB_DEVICE(0x2386, 0x3114), .driver_info = USB_QUIRK_NO_LPM },
 


