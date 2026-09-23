Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA3052E071;
	Wed, 23 Sep 2026 14:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173538; cv=none; b=b+juzdO2HmgKwda5kU+Ry+UlSKRlTm+03w9f0lSNQDkD3S3IvIwTMSVtt22nI/3fVHK8G53+oH/B5PO385eUrFb8JM+UtncmbAtjyJB7OM+pLpISqunc0gWHN1Opxf8TOC3fca1Tz8qWDG76IgyC/P7V8WJ8m0pNlCvy8ImlMNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173538; c=relaxed/simple;
	bh=xIc6j8WvD9hjHUMHvzh3q4b6Uv85BMtdCah00LG64yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6bdOSFc58tJkKzfAW5oG/TiPcTii093e0STYC8Lu6aWTKT58ldicchuGTAhUwPAhP/nxv64W7FzXUtL7m/1EPUhnK+rg1IcNN+qjRAU0gtFXskU10Akw5cY7QwcgyCWnesnjRM5J1hEjLW3tnAwORXLrYTCCP6+G5JcoINPutE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Se8sX52W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Se8sX52W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E7A1F000FF;
	Wed, 23 Sep 2026 14:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173536;
	bh=GPtxmgIWpsaJG8zTWteCYJRbG4FAnouWqrO+gHAVB3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Se8sX52WQC6n2hM1fN5bzp4Ne44neU8lG91PWFCflUuYNZK3xc5hLMNQKYDODHhLv
	 uJ1Ykwsnst+OH7al6SaSQJIlzKtnEkB2FjDxMPhU1rkwHm2ZiZPdZuZOvQ4jSFzNRW
	 pgswqpd1YFA796rjZSLHGU/X0PSKjew+Cum6XmfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Thibert <nithibert@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 277/438] Bluetooth: btusb: fix NXP IW610 composite device handling
Date: Wed, 23 Sep 2026 16:04:58 +0200
Message-ID: <20260923140651.956875211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Thibert <nithibert@gmail.com>

commit 2b50adefed9808a56d84d1de803cad882cc787fa upstream.

The NXP IW610 module exposes itself as a composite USB device
(0471:0215) with three interfaces: two real Bluetooth HCI interfaces
(class 0xe0) and one vendor-specific WiFi interface (class 0xff) used
by mwifiex-nxp.

The composite device's whole USB descriptor reports class 0xe0/01/01
(Bluetooth), so btusb_table's generic USB_DEVICE_INFO(0xe0, 0x01, 0x01)
entry matches every interface, not just the two real HCI ones -- btusb
ends up binding the WiFi interface too, and mwifiex-nxp never gets it.

Fix:
1. In btusb_table (the table the USB core actually matches against),
   explicitly ignore the WiFi interface via BTUSB_IGNORE, ahead of the
   generic entry.
2. In quirks_table, scope the existing BTUSB_MARVELL entry to the BT
   interface class instead of matching the whole device by VID/PID
   (harmless either way since quirks_table isn't consulted for initial
   binding, but keep it correct).

Not upstream anywhere: checked NXP's own i.MX kernel fork
(nxp-imx/linux-imx), no IW610 references in btusb.c on any branch --
their reference designs wire this chip differently (WiFi over SDIO
per their release notes), so they never hit this.

Signed-off-by: Nicolas Thibert <nithibert@gmail.com>
Cc: stable@vger.kernel.org
Assisted-by: LLM (Claude Sonnet 5, Anthropic)
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -71,6 +71,15 @@ static struct usb_driver btusb_driver;
 #define BTUSB_BROKEN_EXT_SCAN		BIT(29)
 
 static const struct usb_device_id btusb_table[] = {
+	/*
+	 * NXP IW610 (0471:0215): the composite device reports Bluetooth
+	 * class at the whole-device level, so the generic entry below
+	 * would also match this WiFi vendor interface. Ignore it here
+	 * first so mwifiex-nxp can bind it instead.
+	 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0471, 0x0215, 0xff, 0xff, 0xff),
+	  .driver_info = BTUSB_IGNORE },
+
 	/* Generic Bluetooth USB device */
 	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },
 
@@ -475,6 +484,14 @@ static const struct usb_device_id quirks
 	{ USB_DEVICE(0x1286, 0x2046), .driver_info = BTUSB_MARVELL },
 	{ USB_DEVICE(0x1286, 0x204e), .driver_info = BTUSB_MARVELL },
 
+	/*
+	 * NXP IW610 BT interfaces (Marvell-lineage silicon, same quirk as
+	 * the 0x1286 entries above). Scoped to the BT interface class,
+	 * not just VID/PID -- see the btusb_table entry above.
+	 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0471, 0x0215, 0xe0, 0x01, 0x01),
+	  .driver_info = BTUSB_MARVELL },
+
 	/* Intel Bluetooth devices */
 	{ USB_DEVICE(0x8087, 0x0025), .driver_info = BTUSB_INTEL_COMBINED },
 	{ USB_DEVICE(0x8087, 0x0026), .driver_info = BTUSB_INTEL_COMBINED },


