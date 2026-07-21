Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0D6418A58;
	Tue, 21 Jul 2026 21:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671147; cv=none; b=GAfY3mkJ9EAkuquF0xNFpLh2juYkfcVMTKc5xMe9D2m92WmM9f78qv0io9yttgYfpFR667WzA4LzCxhrB7OSOZFvNtUcrtY1QL+/44H6twQZO9I5i4y6F1HLoF8kt3OSePI0d5o2IARqALZHO4A+FK1fpgoSD9KcdnFxNAmS8Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671147; c=relaxed/simple;
	bh=DdBtGH91K6vuVE3W2HdcEWyj22b3EvPS2xqpQ0wGmWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugYPAg2vRN/KnH0MmHKcaQeQSxNONgeEkkehKYJ9gv5VB8/1atFiU3k2ahzbcrtzDt2OUq4kER896JzRGSiEtpE+rolvtbJnlucsGyzyCH5p8yNt7Htbel9l3crgLXKdcvu/Wv3AwJfP/t6YtASjl0vlXEkLaTMaBfMikfxglLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qUFuRz7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qUFuRz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9501F000E9;
	Tue, 21 Jul 2026 21:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671146;
	bh=Ow2RqIg+tF+KlkwWbnXU6EGAxnIrmSb8mq8LFfRmevg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1qUFuRz71lEitOAbS15O1Nm7iMXy6QAKgiS4YQnDbt+tBwa7QZv+MEMm8pNQOMv3m
	 GAzdFXxg7eDpl+SerVaRTqprsj0KeTYu+fv63MqXxfBxQJyNtkz4tR3CLSjnWBD1jc
	 cd24t24Jf6AxkbU2ysbzzkx9PBUXruIwjTvpFcmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Erich E. Hoover" <erich.e.hoover@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 137/843] USB: quirks: add NO_LPM for the Samsung T5 EVO Portable SSD
Date: Tue, 21 Jul 2026 17:16:12 +0200
Message-ID: <20260721152409.095939428@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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


