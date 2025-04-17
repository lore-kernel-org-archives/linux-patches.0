Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB68A25D1E1;
	Thu, 17 Apr 2025 18:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912807; cv=none; b=iUyanbURBhBsHDP2cBImT4lZsnM62UEVGA+SYD3+9BRZ4HySgi4Wpo9wwv+NNAgtLd4YIGuXN/5Xu9atzOkUCk5S8lyeusH33ekA8vxavsifAr0l72O0HYaCsypndnpgvusjn0Qq+EB4UUH0tcZeDZHTjwf3zFLWQRbPerlbf50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912807; c=relaxed/simple;
	bh=grSKvHN4mY7YxjRTMNJjJrhkzVK1MBhHWigwZ4rmiTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktZsEEIZkSdF0qrJh4jE9E7cNs19PGc/HnfzIg7AbTcsOoS9oD70HmoryJw3oyl1JzI1etp+vwOlmHzVblfKQ5KNaVM/bfRUn+2R/nHmkUaZNq3kwY1t1vYqg7IImIHsf54jbbmgxmL0+gVLnUF3g5rrG1VDfNtHWe0iYoL8uoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lTjF2jkP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lTjF2jkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D7BC4CEE4;
	Thu, 17 Apr 2025 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912806;
	bh=grSKvHN4mY7YxjRTMNJjJrhkzVK1MBhHWigwZ4rmiTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lTjF2jkPlqxaeu7lK+DKENUnpMwpvIruWDnxr7IecpbmtWySIq33E6rKG8bBRh5bH
	 eyVdUEA8eN0bTdJmlhlmPXchFBT3IpZ8UCIHpBTDHWnRxR/A1xjbS1VyfAiCyfeykS
	 ESDtdlxj7i+ZfWJ/JMEj2bF1cnFYydYcyIXidvLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Schuermann <leon@is.currently.online>,
	Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org ("open list:NETWORKING DRIVERS"),
	Philipp Hahn <phahn-oss@avm.de>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 6.14 129/449] cdc_ether|r8152: ThinkPad Hybrid USB-C/A Dock quirk
Date: Thu, 17 Apr 2025 19:46:57 +0200
Message-ID: <20250417175123.160026689@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Philipp Hahn <phahn-oss@avm.de>

[ Upstream commit a07f23ad9baf716cbf7746e452c92960536ceae6 ]

Lenovo ThinkPad Hybrid USB-C with USB-A Dock (17ef:a359) is affected by
the same problem as the Lenovo Powered USB-C Travel Hub (17ef:721e):
Both are based on the Realtek RTL8153B chip used to use the cdc_ether
driver. However, using this driver, with the system suspended the device
constantly sends pause-frames as soon as the receive buffer fills up.
This causes issues with other devices, where some Ethernet switches stop
forwarding packets altogether.

Using the Realtek driver (r8152) fixes this issue. Pause frames are no
longer sent while the host system is suspended.

Cc: Leon Schuermann <leon@is.currently.online>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Oliver Neukum <oliver@neukum.org> (maintainer:USB CDC ETHERNET DRIVER)
Cc: netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Link: https://git.kernel.org/netdev/net/c/cb82a54904a9
Link: https://git.kernel.org/netdev/net/c/2284bbd0cf39
Link: https://www.lenovo.com/de/de/p/accessories-and-software/docking/docking-usb-docks/40af0135eu
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/484336aad52d14ccf061b535bc19ef6396ef5120.1741601523.git.p.hahn@avm.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ether.c | 7 +++++++
 drivers/net/usb/r8152.c     | 6 ++++++
 drivers/net/usb/r8153_ecm.c | 6 ++++++
 3 files changed, 19 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index a6469235d904e..a032c1ded4063 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -783,6 +783,13 @@ static const struct usb_device_id	products[] = {
 	.driver_info = 0,
 },
 
+/* Lenovo ThinkPad Hybrid USB-C with USB-A Dock (40af0135eu, based on Realtek RTL8153) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0xa359, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /* Aquantia AQtion USB to 5GbE Controller (based on AQC111U) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(AQUANTIA_VENDOR_ID, 0xc101,
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 468c739740463..96fa3857d8e25 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -785,6 +785,7 @@ enum rtl8152_flags {
 #define DEVICE_ID_THINKPAD_USB_C_DONGLE			0x720c
 #define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387
 #define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3		0x3062
+#define DEVICE_ID_THINKPAD_HYBRID_USB_C_DOCK		0xa359
 
 struct tally_counter {
 	__le64	tx_packets;
@@ -9787,6 +9788,7 @@ static bool rtl8152_supports_lenovo_macpassthru(struct usb_device *udev)
 		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
 		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3:
 		case DEVICE_ID_THINKPAD_USB_C_DONGLE:
+		case DEVICE_ID_THINKPAD_HYBRID_USB_C_DOCK:
 			return 1;
 		}
 	} else if (vendor_id == VENDOR_ID_REALTEK && parent_vendor_id == VENDOR_ID_LENOVO) {
@@ -10064,6 +10066,8 @@ static const struct usb_device_id rtl8152_table[] = {
 	{ USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927) },
 	{ USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0c5e) },
 	{ USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101) },
+
+	/* Lenovo */
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x304f) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3054) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3062) },
@@ -10074,7 +10078,9 @@ static const struct usb_device_id rtl8152_table[] = {
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x720c) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x7214) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x721e) },
+	{ USB_DEVICE(VENDOR_ID_LENOVO,  0xa359) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0xa387) },
+
 	{ USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041) },
 	{ USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff) },
 	{ USB_DEVICE(VENDOR_ID_TPLINK,  0x0601) },
diff --git a/drivers/net/usb/r8153_ecm.c b/drivers/net/usb/r8153_ecm.c
index 20b2df8d74ae1..8d860dacdf49b 100644
--- a/drivers/net/usb/r8153_ecm.c
+++ b/drivers/net/usb/r8153_ecm.c
@@ -135,6 +135,12 @@ static const struct usb_device_id products[] = {
 				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&r8153_info,
 },
+/* Lenovo ThinkPad Hybrid USB-C with USB-A Dock (40af0135eu, based on Realtek RTL8153) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(VENDOR_ID_LENOVO, 0xa359, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = (unsigned long)&r8153_info,
+},
 
 	{ },		/* END */
 };
-- 
2.39.5



