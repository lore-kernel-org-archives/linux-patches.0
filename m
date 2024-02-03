Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3187828E3C;
	Sat,  3 Feb 2024 04:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933925; cv=none; b=S44oDnF3pVxmbV1lU6658GeN7MAWYt9HeYZ0QG7DXOKyHXw3xruPqeJ+i3lxGM0N+7X6VxOn8bXKdWAl8Nx39VY8t/dKq4WTDBjPk7LT2k9ZFZm/Gt4aD5SaHUdNuUXNtCU5cnDRvh3xbFCdgVCIAas8bgCpSfYpcAgK1I/dd6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933925; c=relaxed/simple;
	bh=NZ214pLdagVQ+lMDh3W/vqkytLCE53hvCUp4mZjb6B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3ZkE/cCNdqJMqDTyTkUw2yggjkld88AqzPdGJ9jCP1Vajq1WtbLusNONXpgGKahhmNOmEoOq984/ocgRQUhF7lwM3Y7H5Is398lXJnSYDFa/eo2lgN37Hxhj+mmsg8eRqbp+MSWFb8V+Bz+ELMS1RJvxq4sOFiEka0/QWSUPgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QcscDk6n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcscDk6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6B4C43390;
	Sat,  3 Feb 2024 04:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933925;
	bh=NZ214pLdagVQ+lMDh3W/vqkytLCE53hvCUp4mZjb6B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QcscDk6nvXOumfq2UMz0MUUVXn2zwgn1e18aVzUSoyRGNqesyqgzaZ7Jt8cs+j3hW
	 W8FdKjmnHbnhnInGdTgwZ1pyB2YvXe3e3HPc9swq3iURbJneU6wCoTmlUWnTDP4daa
	 692lETiPinY+kHfAy+MPSqnDlAzaqXQwcfI7ljWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hardik Gajjar <hgajjar@de.adit-jv.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 256/353] usb: hub: Add quirk to decrease IN-ep poll interval for Microchip USB491x hub
Date: Fri,  2 Feb 2024 20:06:14 -0800
Message-ID: <20240203035411.841859335@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hardik Gajjar <hgajjar@de.adit-jv.com>

[ Upstream commit 855d75cf8311fee156fabb5639bb53757ca83dd4 ]

There is a potential delay in notifying Linux USB drivers of downstream
USB bus activity when connecting a high-speed or superSpeed device via the
Microchip USB491x hub. This delay is due to the fixed bInterval value of
12 in the silicon of the Microchip USB491x hub.

Microchip requested to ignore the device descriptor and decrease that
value to 9 as it was too late to modify that in silicon.

This patch speeds up the USB enummeration process that helps to pass
Apple Carplay certifications and improve the User experience when utilizing
the USB device via Microchip Multihost USB491x Hub.

A new hub quirk HUB_QUIRK_REDUCE_FRAME_INTR_BINTERVAL speeds up
the notification process for Microchip USB491x hub by limiting
the maximum bInterval value to 9.

Signed-off-by: Hardik Gajjar <hgajjar@de.adit-jv.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20231205181829.127353-2-hgajjar@de.adit-jv.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hub.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 7deeba174858..ef8d9bda94ac 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -47,12 +47,18 @@
 #define USB_VENDOR_TEXAS_INSTRUMENTS		0x0451
 #define USB_PRODUCT_TUSB8041_USB3		0x8140
 #define USB_PRODUCT_TUSB8041_USB2		0x8142
+#define USB_VENDOR_MICROCHIP			0x0424
+#define USB_PRODUCT_USB4913			0x4913
+#define USB_PRODUCT_USB4914			0x4914
+#define USB_PRODUCT_USB4915			0x4915
 #define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	BIT(0)
 #define HUB_QUIRK_DISABLE_AUTOSUSPEND		BIT(1)
+#define HUB_QUIRK_REDUCE_FRAME_INTR_BINTERVAL	BIT(2)
 
 #define USB_TP_TRANSMISSION_DELAY	40	/* ns */
 #define USB_TP_TRANSMISSION_DELAY_MAX	65535	/* ns */
 #define USB_PING_RESPONSE_TIME		400	/* ns */
+#define USB_REDUCE_FRAME_INTR_BINTERVAL	9
 
 /* Protect struct usb_device->state and ->children members
  * Note: Both are also protected by ->dev.sem, except that ->state can
@@ -1904,6 +1910,14 @@ static int hub_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		usb_autopm_get_interface_no_resume(intf);
 	}
 
+	if ((id->driver_info & HUB_QUIRK_REDUCE_FRAME_INTR_BINTERVAL) &&
+	    desc->endpoint[0].desc.bInterval > USB_REDUCE_FRAME_INTR_BINTERVAL) {
+		desc->endpoint[0].desc.bInterval =
+			USB_REDUCE_FRAME_INTR_BINTERVAL;
+		/* Tell the HCD about the interrupt ep's new bInterval */
+		usb_set_interface(hdev, 0, 0);
+	}
+
 	if (hub_configure(hub, &desc->endpoint[0].desc) >= 0) {
 		onboard_hub_create_pdevs(hdev, &hub->onboard_hub_devs);
 
@@ -5895,6 +5909,21 @@ static const struct usb_device_id hub_id_table[] = {
       .idVendor = USB_VENDOR_TEXAS_INSTRUMENTS,
       .idProduct = USB_PRODUCT_TUSB8041_USB3,
       .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
+	{ .match_flags = USB_DEVICE_ID_MATCH_VENDOR
+			| USB_DEVICE_ID_MATCH_PRODUCT,
+	  .idVendor = USB_VENDOR_MICROCHIP,
+	  .idProduct = USB_PRODUCT_USB4913,
+	  .driver_info = HUB_QUIRK_REDUCE_FRAME_INTR_BINTERVAL},
+	{ .match_flags = USB_DEVICE_ID_MATCH_VENDOR
+			| USB_DEVICE_ID_MATCH_PRODUCT,
+	  .idVendor = USB_VENDOR_MICROCHIP,
+	  .idProduct = USB_PRODUCT_USB4914,
+	  .driver_info = HUB_QUIRK_REDUCE_FRAME_INTR_BINTERVAL},
+	{ .match_flags = USB_DEVICE_ID_MATCH_VENDOR
+			| USB_DEVICE_ID_MATCH_PRODUCT,
+	  .idVendor = USB_VENDOR_MICROCHIP,
+	  .idProduct = USB_PRODUCT_USB4915,
+	  .driver_info = HUB_QUIRK_REDUCE_FRAME_INTR_BINTERVAL},
     { .match_flags = USB_DEVICE_ID_MATCH_DEV_CLASS,
       .bDeviceClass = USB_CLASS_HUB},
     { .match_flags = USB_DEVICE_ID_MATCH_INT_CLASS,
-- 
2.43.0



