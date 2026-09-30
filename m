Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827573DDAFC;
	Wed, 30 Sep 2026 19:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796421; cv=none; b=ADjM0OwritTsgFr4vf11ezxd3gPGTkWehFQDvbbA74wRBIRr1ijEZ6ETg/Qk3w/2QV1dL9FOVJD0MEmXFBfulVzqhGffYKclbBm3c0fnmUz/jx3sQGiNPufXZW5PKGwEWB4nI0BlNOXe2/DweuVPZpUVgMiA8f+4uyx0RbO6VP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796421; c=relaxed/simple;
	bh=Hr/cKic/L7HvlF5quL57Nb+zLeBmYOBQUPBwHMWyVIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTW4RiIdPac2ep5ylJXnTBsBbtYsJ/UrTas/5Nuy+r2dIJaelWwGdKAb7JlSGnaAv1Aobz2Wq0Zvm8IHi8uce2QpjsOFJYy9tDyXSzGSK7EGHZhncHf78T1YH7ThrEgj9AtGSMOvb990AJ/gGRvmWBFAv1thqzi9qwSJ2zI1sjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mn05C4Sy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mn05C4Sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B5C1F000FF;
	Wed, 30 Sep 2026 19:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796420;
	bh=CysxX27/TWNBMlUrcXH/10kgeE0qGpIt2HO1j28YzqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mn05C4Sy0Vv8RclRKA35A4919FWAV5gPPiQ7NOrCgS2VaJydb8TCEFW1TumKUf5sY
	 bWPJpgXOJoBzOHwlELwAU4Sa8SuYe5IKIugB1yQ15rGvz3M8VRv6U1/fJjC4YVDiWi
	 6PvfX9FPE4Vb3Zxe4fTkGv80Ssxqa3ilSS+nD0bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Thibert <nithibert@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0852/1193] Bluetooth: btusb: fix NXP IW610 composite device handling
Date: Wed, 30 Sep 2026 17:25:36 +0200
Message-ID: <20260930152453.165140113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -68,6 +68,15 @@ static struct usb_driver btusb_driver;
 #define BTUSB_BARROT			BIT(28)
 
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
 
@@ -470,6 +479,14 @@ static const struct usb_device_id quirks
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


