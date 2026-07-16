Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110853BE17B;
	Thu, 16 Jul 2026 13:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209882; cv=none; b=mshevgmtswNwIdxgctZY+IppKjDt5o1QhiS5+miRWFK8G/4lMoLl51Qq+2PmWultFcu6jQrPlv4yJDLXa7bN88i8s2gn7xzetvk4Wv9A5+8Ouj/oJIkWsPe7wW6ZRaj9hXedDqMqMbOykD59UOpJjF+sFKoTT79k+bQnf0ImXcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209882; c=relaxed/simple;
	bh=AzGFnejUI/sgH77LYK6HG8Rx2H0RLmqOldSR2kAmI4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwvOOCf+KVEbeAN4H4y91QrYe4+9+78m4X/Q22ZpYeGFAlwpbUPhTzmzPZqe/TLXwO+hB70fcXDLKYtEF8u9QWLCXqyaPz73up0j7/CJl8OCK0bTolhfppPpKkrhAh6uaXphRiCUGC+iVlztSaiZp7bivZBWzeH797lmjP4lMNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHHX0avT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHHX0avT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A381F000E9;
	Thu, 16 Jul 2026 13:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209881;
	bh=EgFWhPUS/vsvZ9u5xA3ikYuqC+QChjDTeH0I7ouRYT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YHHX0avTuVSVatnnJ2uwndSyXLYUrldTl0FSx7Y2HJWHjiGt+Yw7xp+ICnyYMRNIq
	 K8KKyA51kKtEmq6d/a9n0+7bL9NoxR5oFM+Fbm7PUbONXvmLnJx7O8naEv6p+S1wKK
	 0La3ool42wPZ565SXabqrWXE9aJF2GTMfFTio0Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Erich E. Hoover" <erich.e.hoover@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 7.1 311/518] USB: quirks: add NO_LPM for the Samsung T5 EVO Portable SSD
Date: Thu, 16 Jul 2026 15:29:39 +0200
Message-ID: <20260716133054.626697389@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -296,6 +296,9 @@ static const struct usb_device_id usb_qu
 	/* CarrolTouch 4500U */
 	{ USB_DEVICE(0x04e7, 0x0030), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Samsung T5 EVO Portable SSD */
+	{ USB_DEVICE(0x04e8, 0x6200), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Samsung Android phone modem - ID conflict with SPH-I500 */
 	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


