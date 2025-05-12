Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731CB1C173C;
	Mon, 12 May 2025 17:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072101; cv=none; b=sBSawQVq3AeDQWGVkp18gjcBxj0yGZWm9i2OfbDoZFxiqOP1Pwy11BCjl/azfeQCZDAivAcyErJcbnJnTP1WhPK72R1VAXCN0AnejiIAN3Gt1644TMaNL864VXFuQ/qxo5D2QHHTkRV78wl5uH2tu1edPOzRfsDL11RCYbPDzok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072101; c=relaxed/simple;
	bh=2E3pBojb3ubHjxRMs48LVwmAJC4PhqejKccVLpIKpYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbHtbEIVbV0CAkCTU9281/AUAhOM7GkDErSSLw6kq4wkIishRYi+0SMmmF5rzoDs0khpBG9HCRr0EZ1qbw/LLvcnbLvkiAUvo6ZuRUG3kNnNGhdcsRSXF3gbryN/ggVaPYgPOD23SI/LZPY/mZN8Diu1A3MGnzXh4l+o5NJy2F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSHUfHzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSHUfHzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04051C4CEE7;
	Mon, 12 May 2025 17:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072101;
	bh=2E3pBojb3ubHjxRMs48LVwmAJC4PhqejKccVLpIKpYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSHUfHzVvL9vg1o49SrtVDa5+CP8/IZTT9yjB1gMMwQ9CCdoWDIyCPfBfcN3ggs8C
	 45RfGjeURC/dckYOp87CIZJkHbpDMhDynEBp1Sxt1ZPewt2Pe3XjA11/9lw6NKM/5d
	 srpGLfe+Hc6XlfA9QwicDZuklOWzMIDe1pacrgpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
Subject: [PATCH 6.14 141/197] usb: misc: onboard_usb_dev: fix support for Cypress HX3 hubs
Date: Mon, 12 May 2025 19:39:51 +0200
Message-ID: <20250512172050.138647813@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Czechowski <lukasz.czechowski@thaumatec.com>

commit 9f657a92805cfc98e11cf5da9e8f4e02ecff2260 upstream.

The Cypress HX3 USB3.0 hubs use different PID values depending
on the product variant. The comment in compatibles table is
misleading, as the currently used PIDs (0x6504 and 0x6506 for
USB 3.0 and USB 2.0, respectively) are defaults for the CYUSB331x,
while CYUSB330x and CYUSB332x variants use different values.
Based on the datasheet [1], update the compatible usb devices table
to handle different types of the hub.
The change also includes vendor mode PIDs, which are used by the
hub in I2C Master boot mode, if connected EEPROM contains invalid
signature or is blank. This allows to correctly boot the hub even
if the EEPROM will have broken content.
Number of vcc supplies and timing requirements are the same for all
HX variants, so the platform driver's match table does not have to
be extended.

[1] https://www.infineon.com/dgdl/Infineon-HX3_USB_3_0_Hub_Consumer_Industrial-DataSheet-v22_00-EN.pdf?fileId=8ac78c8c7d0d8da4017d0ecb53f644b8
    Table 9. PID Values

Fixes: b43cd82a1a40 ("usb: misc: onboard-hub: add support for Cypress HX3 USB 3.0 family")
Cc: stable <stable@kernel.org>
Signed-off-by: Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
Link: https://lore.kernel.org/r/20250425-onboard_usb_dev-v2-1-4a76a474a010@thaumatec.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/onboard_usb_dev.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/onboard_usb_dev.c
+++ b/drivers/usb/misc/onboard_usb_dev.c
@@ -569,8 +569,14 @@ static void onboard_dev_usbdev_disconnec
 }
 
 static const struct usb_device_id onboard_dev_id_table[] = {
-	{ USB_DEVICE(VENDOR_ID_CYPRESS, 0x6504) }, /* CYUSB33{0,1,2}x/CYUSB230x 3.0 HUB */
-	{ USB_DEVICE(VENDOR_ID_CYPRESS, 0x6506) }, /* CYUSB33{0,1,2}x/CYUSB230x 2.0 HUB */
+	{ USB_DEVICE(VENDOR_ID_CYPRESS, 0x6500) }, /* CYUSB330x 3.0 HUB */
+	{ USB_DEVICE(VENDOR_ID_CYPRESS, 0x6502) }, /* CYUSB330x 2.0 HUB */
+	{ USB_DEVICE(VENDOR_ID_CYPRESS, 0x6503) }, /* CYUSB33{0,1}x 2.0 HUB, Vendor Mode */
+	{ USB_DEVICE(VENDOR_ID_CYPRESS, 0x6504) }, /* CYUSB331x 3.0 HUB */
+	{ USB_DEVICE(VENDOR_ID_CYPRESS, 0x6506) }, /* CYUSB331x 2.0 HUB */
+	{ USB_DEVICE(VENDOR_ID_CYPRESS, 0x6507) }, /* CYUSB332x 2.0 HUB, Vendor Mode */
+	{ USB_DEVICE(VENDOR_ID_CYPRESS, 0x6508) }, /* CYUSB332x 3.0 HUB */
+	{ USB_DEVICE(VENDOR_ID_CYPRESS, 0x650a) }, /* CYUSB332x 2.0 HUB */
 	{ USB_DEVICE(VENDOR_ID_CYPRESS, 0x6570) }, /* CY7C6563x 2.0 HUB */
 	{ USB_DEVICE(VENDOR_ID_GENESYS, 0x0608) }, /* Genesys Logic GL850G USB 2.0 HUB */
 	{ USB_DEVICE(VENDOR_ID_GENESYS, 0x0610) }, /* Genesys Logic GL852G USB 2.0 HUB */


