Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB7042A145;
	Thu, 16 Jul 2026 13:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209752; cv=none; b=cViVubaUniN5OzA0/OkmDyYkHf1BZTvfQ7PMqaBszAuXWVzUBeyOoLjDLnYiNZ8K9uNUSYbUWo6DB+Rc9IfiZGKXsbwQsbrn6YUEOQ7F0aI4EyHkZLKFG6eLv49cFvatMUYLM/owFlCHKsO8BZt4XdjnTaAtH2WPvSK/+IVg4UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209752; c=relaxed/simple;
	bh=3idRBA5mnnC8o5UvAW3IuJbIoPiVaMjwXzpWtk2LCuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LE8ZC9TuXI+38aF+yY9NJMK15z5CiWYYuwUi67NZMg63U8fs6kYs1iZ/tUwg+ijevJfq5kN++9hgW2esMDbzCtw0+KAkZ17zaYuLKo3PwIQmnsBMfWTu8o21q+I0XyNu4jC9ciPSInwaJhlk5j1LvVlzRSsFH6wlD8Ceu2K125M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4MUOD47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4MUOD47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29A01F000E9;
	Thu, 16 Jul 2026 13:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209744;
	bh=FlRq9JHbgu8zY4mW5gHOU9URLmIr22FMdaNfmyejQH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R4MUOD47hKvd3uIWzSI09zbN6bt9E0U3FsXDMay53NiLPaC9m7NEwyFlE8JzWWkDl
	 QlpviTyQ0fEFLu6pdqnsSKSBsHBMGAqNBpzA6c9u+ttzHpaEzU/WL21oFGYV3y/FFd
	 f/79ZSzRxLjvLSIrNhGB9jEE2XrA/SAO2Te4TkbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rodrigo=20Lugathe=20da=20Concei=C3=A7=C3=A3o=20Alves?= <lugathe2@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 7.1 300/518] USB: core: add USB_QUIRK_NO_LPM for VIA Labs USB 2.0 hub
Date: Thu, 16 Jul 2026 15:29:28 +0200
Message-ID: <20260716133054.381136674@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -576,6 +576,9 @@ static const struct usb_device_id usb_qu
 	/* VLI disk */
 	{ USB_DEVICE(0x2109, 0x0711), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* VIA Labs, Inc. USB2.0 Hub */
+	{ USB_DEVICE(0x2109, 0x2817), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Raydium Touchscreen */
 	{ USB_DEVICE(0x2386, 0x3114), .driver_info = USB_QUIRK_NO_LPM },
 


