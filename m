Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFF1435A96;
	Tue, 21 Jul 2026 20:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665256; cv=none; b=nFBwaIc76vjpdWGe9jyRiQGiELORCseY47a7O/qO8AYBlXsp85j0pBb2e0Z9Q6FjwEQvHSX9AgXbNUwQUeIxZPD9L9wrfQjxps5xcZYnRi6YzrIbGp1rMXu/DWYdtCer2r4D7+on8g4gZnFtFjju9GL2+a3GjQxP9h/wjrxvmIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665256; c=relaxed/simple;
	bh=3DxlP4VJ7P8078UwcQ4cKA19fAfoPfAnUNTe5y4I0dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phya+FT6ecSCc1CW8TSynOH+Vt26GCB1eMqGt14P/MYsFxBPAUK5v3NTfuSWuc+0u10UY6AdG8LolNQdTfMatkQN2WkDygfx6lpqPHjwNmakMUpE6ngOF8CbjorE/+ib/gyKMk7f4QS2WII/X++lN5XSF2Wc3KgRgiCCuLni08w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyXcZHjH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyXcZHjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0131F000E9;
	Tue, 21 Jul 2026 20:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665254;
	bh=abQxHuvwrXcf0jX+63Q+i+OKxZ1khqLrdAvTBfCpYuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DyXcZHjHq8eOmt89zTClMTEIkrV5kGuwa9Km7+jO/mvVBCwXF5bh4nrBLAD89Xj2K
	 21fzgvp5gRa04df6Eirvq4aTV1rJLaq9gAKoaA8tTJj6U2Ge37DhD5WHfM+BWmiabt
	 iJ9u8YdmbwEla1Kv8Mq9NvDcjyXveVqGByboJL4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Erich E. Hoover" <erich.e.hoover@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 0236/1266] USB: quirks: add NO_LPM for the Samsung T5 EVO Portable SSD
Date: Tue, 21 Jul 2026 17:11:13 +0200
Message-ID: <20260721152447.101445317@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -297,6 +297,9 @@ static const struct usb_device_id usb_qu
 	/* CarrolTouch 4500U */
 	{ USB_DEVICE(0x04e7, 0x0030), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Samsung T5 EVO Portable SSD */
+	{ USB_DEVICE(0x04e8, 0x6200), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Samsung Android phone modem - ID conflict with SPH-I500 */
 	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


