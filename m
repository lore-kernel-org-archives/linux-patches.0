Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9CD50AC28;
	Wed, 30 Sep 2026 16:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786006; cv=none; b=B2JI5xFkJReevKdCDEBRsU/u7tePjx6QF2KEBDZJitmlOyGQg+UZUyxFbgFXnmNdZoMSC7Va3sdFvKUxCnTCdVCxYfnMGZm6FoizF0gCii+7XMYuDm7Yc5y3YTiEb1thL/FXmktkUoyzFZAHx0IG8JBYhPscmlavUnE2jQrNfeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786006; c=relaxed/simple;
	bh=6v5s5I966emTi4Hsw8UxPB8AnDZPa0wOn7wC7f/8SWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBJLNzk/51w02yd/WYTQPaRaiEExUDOYezBGSOeQ9ZMtqqu6aF3tS1XgBK0T5MeQfKFSUd/+hFFDRol+TVlQ5WqfM2xQ1mEyLxR5zpvQ/FaRJXuqXWy4ZweBgrcoThyW6wrQkzKpAEA0LZ74Fn4mooWlJFnKzvpLRL1bjBdoWnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEX+H92e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEX+H92e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10041F000FF;
	Wed, 30 Sep 2026 16:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786005;
	bh=onT6eLPf7CTcQ4CF1vSyzLhO1DYvH8JxiXgJPVEcKLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FEX+H92eFMbhcWIt7nvbYed1+icefZ7Pzgs3UmjS2W6O8qXyzTfv8vZHZ5TV2xdsV
	 myVTvzFQjaU22f/l/eh77WYOnXOyTeTSbapEOQdsGAHsVj+CjTwfdYoOMfDHPyxOEa
	 769cSyGWCMXLm4MjPkvz8AZFlbJAzO/da77O6MJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Thibert <nithibert@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 709/982] Bluetooth: btusb: fix NXP IW610 composite device handling
Date: Wed, 30 Sep 2026 17:24:05 +0200
Message-ID: <20260930152431.987135695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
@@ -67,6 +67,15 @@ static struct usb_driver btusb_driver;
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
 
@@ -469,6 +478,14 @@ static const struct usb_device_id blackl
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


