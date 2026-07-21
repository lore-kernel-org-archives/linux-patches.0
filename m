Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862BA34B1A6;
	Tue, 21 Jul 2026 22:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673281; cv=none; b=g5v2ryxkdruVhsVF/Zk+k3LmDhLej6EU8bxONAOwnQv9hncvgWOqFgLHa+Wro3MDqE3Ygzy+pxXWisz9KPn3kPP5aV6kriF8wigXTbRD3k9MLmJ9RGPWj0RwNm58yqFYZrExorxGTs65XEZemTJCSW+vOdDU22aTvjkOr1k98FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673281; c=relaxed/simple;
	bh=td77a5/5novz/5a+CF9S0otxmJox34Nruck9At82HG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N62D0GyVNr2X2SZh+GV+ax57+I2IQtlciKkZqbhPhJb0unA5NN1qKR/vwqMivh+zkw1hc2EoNO4cIzQS0/JxEwZJqZkCvJksk89R1DAyhYCiQrLfgWb2Q4eDFm55QM2rEVOX44yLTj+4jO7NNG4MGXcof9OtUw4jZFWpEEVFzQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6m8qPGJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6m8qPGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF99C1F00A3A;
	Tue, 21 Jul 2026 22:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673280;
	bh=Wtqm2JawclE1sElx6qM89ujOuvTSB4p+zGRsMOpO67Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6m8qPGJu8h1rdG3kjBy+ZTAiYpYvJXs61Fi8Peb07yP9JXzDMIHVCijpsgTLXM9e
	 CWh8/vEq4uKKaO0ddnQCZPdEJa/U2DblUJWkp+Y0m9LxaCTOc5KmidSbPAKc/OQYlr
	 F57sP4UjxCuuH9bb6lzZxKTTvZinuoXysJX9WqkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Erich E. Hoover" <erich.e.hoover@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 103/699] USB: quirks: add NO_LPM for the Samsung T5 EVO Portable SSD
Date: Tue, 21 Jul 2026 17:17:42 +0200
Message-ID: <20260721152358.024862825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erich E. Hoover <erich.e.hoover@gmail.com>

commit fc591787785b9709a0bb65a7df3ba2537d611c47 upstream.

The Samsung T5 EVO Portable SSD (04e8:6200) exhibit two forms of
link instability when USB Link Power Management is enabled:

  1. The units fail to initialize properly on first detection,
  resulting in a lockup in the drive where it must be power cycled
  or the kernel will not recognize the presence of the device.

  2. If used for sustained operations (small amounts of continuous
  data are transferred to the unit) then the unit will "hiccup"
  after roughly 8 hours of use and will disconnect and reconnect.
  This has a certain probability of triggering the first issue,
  but also causes mount points to become invalid since the device
  gets issued a new letter.

Signed-off-by: Erich E. Hoover <erich.e.hoover@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260602204508.48856-1-erich.e.hoover@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -292,6 +292,9 @@ static const struct usb_device_id usb_qu
 	/* CarrolTouch 4500U */
 	{ USB_DEVICE(0x04e7, 0x0030), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Samsung T5 EVO Portable SSD */
+	{ USB_DEVICE(0x04e8, 0x6200), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Samsung Android phone modem - ID conflict with SPH-I500 */
 	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


