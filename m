Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CA7441616;
	Tue, 21 Jul 2026 22:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671246; cv=none; b=M6yLP3JiYaY7b2jY6ta3mHeoc1F/nCWTm0JPqfHQyG10GX47FnwLh7dr1StFSM4WiFrL3GPvlHCwzylYJNZxYflvba9o/lBn3xHVmhmpVQecwAnAgM6evcViJd3PL3Fsr/Fljhw6OnTulRmC9vsc13Vgr8fUUZhZ/Lryt8EBoEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671246; c=relaxed/simple;
	bh=WIdf/utDrpny0EXcfpSFl7C5w+t9fNtsoy0tr9VckNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gqpk0gQO93Z7yFxHkTTuLBfw/3VUDJHckaAdL8YE9Z1/FgSSPQCQSDMaPL8zlWdkxWdpGVZiCmiztUH1fsIMfS/uNFJkHAAucJfjyYvXZJCseYAszKsp6BP9ttdXEZT8Fd2kgH7RiiuHvkY9jFo4bIBPwIwyzC5C95jJzyqd4HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbxuLJGo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbxuLJGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2326A1F000E9;
	Tue, 21 Jul 2026 22:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671244;
	bh=lUt1zVKl9HvPTW+yPzifPKHwDFXma6ZEsCZsnrMRvQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbxuLJGoPmIdkhIeRk+CdP9kI9n7K9WLUvOaRi/n9jT7ZI2EF49EFrqS2Z969rA5l
	 s3wryyXYURtreh2lDXeph+kXMVQvh6iI/jjRSV5STse8Pty1yQE505oZ2Y1HvVc1B7
	 8nUTut/GNIoDRE2VXT9qNlvhbU1A+PGZjyZ4T2PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rodrigo=20Lugathe=20da=20Concei=C3=A7=C3=A3o=20Alves?= <lugathe2@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 130/843] USB: core: add USB_QUIRK_NO_LPM for VIA Labs USB 2.0 hub
Date: Tue, 21 Jul 2026 17:16:05 +0200
Message-ID: <20260721152408.935489908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -560,6 +560,9 @@ static const struct usb_device_id usb_qu
 	/* VLI disk */
 	{ USB_DEVICE(0x2109, 0x0711), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* VIA Labs, Inc. USB2.0 Hub */
+	{ USB_DEVICE(0x2109, 0x2817), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Raydium Touchscreen */
 	{ USB_DEVICE(0x2386, 0x3114), .driver_info = USB_QUIRK_NO_LPM },
 


