Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C19D3BAD80;
	Mon, 23 Mar 2026 16:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282567; cv=none; b=WUNpXcE/VLtnQxII5zd0PZUODuT03k+YnQrBrqVl6yFG+7XVutlkd7zMUCmAMGI4gE19/l3dl/rHaCTUgBw9PWqNfJ5Fx50KLQVavRCsPNu6yrLTq8iuZAo00RSE4IsOFEdOrdkIdHyQHJysX4FcJs6tmLVnw2EQ7fWED95X/bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282567; c=relaxed/simple;
	bh=P/7IQ6vuON5dfNuhkCvEUueGefzrKOT3ADtMi/DzD7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQwoZwimNmNZZ9b28g8QztWpTKY4jlnwC69wn3UPp6GF/Z2hP+JfjVDeXAEALAndQDyoxMZ+4EoGbGz59jRJ6W3/hFjn9vvlWszKUrFBBa8r3QTdKwQraJAx56g+MNNMjAz9tvHTwpYsvIfkQzzx21y9LYL2b18GXSjWrWuQjso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8rVSNK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8rVSNK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0A5C2BC9E;
	Mon, 23 Mar 2026 16:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282566;
	bh=P/7IQ6vuON5dfNuhkCvEUueGefzrKOT3ADtMi/DzD7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8rVSNK96RAC4RhFN36+FbMLaos3eHj0JSvd835G3076tjsI4mstsTL9uARH5TEQO
	 FDL70sReXir9TkC2yPcSrk9CXboYD65PJvtesJdNFfTxuoxRTiTBEG70bqlEzQRUq+
	 YnWcF5xrRnTL1BJYIemjn5O0Gx607goFJ/Ssi/ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	A1RM4X <dev@a1rm4x.com>
Subject: [PATCH 6.1 204/481] USB: add QUIRK_NO_BOS for video capture several devices
Date: Mon, 23 Mar 2026 14:43:06 +0100
Message-ID: <20260323134530.145281696@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: A1RM4X <dev@a1rm4x.com>

commit 93cd0d664661f58f7e7bed7373714ab2ace41734 upstream.

Several USB capture devices also need the USB_QUIRK_NO_BOS set for them
to work properly, odds are they are all the same chip inside, just
different vendor/product ids.

This fixes up:
  - ASUS TUF 4K PRO
  - Avermedia Live Gamer Ultra 2.1 (GC553G2)
  - UGREEN 35871
to now run at full speed (10 Gbps/4K 60 fps mode.)

Link: https://lore.kernel.org/r/CACy+XB-f-51xGpNQFCSm5pE_momTQLu=BaZggHYU1DiDmFX=ug@mail.gmail.com
Cc: stable <stable@kernel.org>
Signed-off-by: A1RM4X <dev@a1rm4x.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -377,6 +377,9 @@ static const struct usb_device_id usb_qu
 	/* SanDisk Extreme 55AE */
 	{ USB_DEVICE(0x0781, 0x55ae), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Avermedia Live Gamer Ultra 2.1 (GC553G2) - BOS descriptor fetch hangs at SuperSpeed Plus */
+	{ USB_DEVICE(0x07ca, 0x2553), .driver_info = USB_QUIRK_NO_BOS },
+
 	/* Realforce 87U Keyboard */
 	{ USB_DEVICE(0x0853, 0x011b), .driver_info = USB_QUIRK_NO_LPM },
 
@@ -434,6 +437,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0b05, 0x17e0), .driver_info =
 			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
 
+	/* ASUS TUF 4K PRO - BOS descriptor fetch hangs at SuperSpeed Plus */
+	{ USB_DEVICE(0x0b05, 0x1ab9), .driver_info = USB_QUIRK_NO_BOS },
+
 	/* Realtek Semiconductor Corp. Mass Storage Device (Multicard Reader)*/
 	{ USB_DEVICE(0x0bda, 0x0151), .driver_info = USB_QUIRK_CONFIG_INTF_STRINGS },
 
@@ -562,6 +568,9 @@ static const struct usb_device_id usb_qu
 
 	{ USB_DEVICE(0x2386, 0x350e), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* UGREEN 35871 - BOS descriptor fetch hangs at SuperSpeed Plus */
+	{ USB_DEVICE(0x2b89, 0x5871), .driver_info = USB_QUIRK_NO_BOS },
+
 	/* APTIV AUTOMOTIVE HUB */
 	{ USB_DEVICE(0x2c48, 0x0132), .driver_info =
 			USB_QUIRK_SHORT_SET_ADDRESS_REQ_TIMEOUT },


