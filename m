Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C0035C690;
	Tue, 21 Jul 2026 21:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668420; cv=none; b=VEq2bGHPr7eh+rD/b01JCtWhYpnsAWCJxkyb8279wXOnr/JyksXAfslxAcfr/JVEeS454S7jePomE1fxBdkjoLUccHIxuWH2X8jb3rUwB5a6XB2Qf7OICwlS+QI+hhE8JD2e7nyQNoMhCbLfdUTof+xTAmhDICVQRBBBCnE3ky8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668420; c=relaxed/simple;
	bh=Pz5Qie8RyGjoZoJ8s9NXSpVR+72UlEixb7qoldxLFs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ifKF+qln1Q2GwN3VnI3kEg4gDVQB6PbP4hdLAvgOh1BdzRBVyYUd4z1T6ysOHVJW9njvjj0c6Z90hXTGeklnCzagWPa7m6nTTZSHZ3aYfkCzfbxmbYZLx0XI7MdoxHdDXJGVewzwyc2zZNILMK74bwzk9SP5QxwOFbU3YVcTbcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIcWCZ5D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIcWCZ5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356231F000E9;
	Tue, 21 Jul 2026 21:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668417;
	bh=JuswF/W8N6jvkhkPTd1wF9V/Q8ELgYgJxKAOHXFd3aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VIcWCZ5DdAam2MXEGbSQ46fRpTyzmuo8bWB6DjtdUR/bhtxkvhd2mlptT82P6QIWm
	 AkUxt6OeSd8dFfozjryM8e4p0wygaeScIJ7gv7kehBPkG5zGRCPoZXs27YUL/2EQ76
	 8JnVaylFceIElxODDy6L2T7xa6O7cGDW0FbtRH50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rodrigo=20Lugathe=20da=20Concei=C3=A7=C3=A3o=20Alves?= <lugathe2@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 0168/1067] USB: core: add USB_QUIRK_NO_LPM for VIA Labs USB 2.0 hub
Date: Tue, 21 Jul 2026 17:12:49 +0200
Message-ID: <20260721152428.349662070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -574,6 +574,9 @@ static const struct usb_device_id usb_qu
 	/* VLI disk */
 	{ USB_DEVICE(0x2109, 0x0711), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* VIA Labs, Inc. USB2.0 Hub */
+	{ USB_DEVICE(0x2109, 0x2817), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Raydium Touchscreen */
 	{ USB_DEVICE(0x2386, 0x3114), .driver_info = USB_QUIRK_NO_LPM },
 


