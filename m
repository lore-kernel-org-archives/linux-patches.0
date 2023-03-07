Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13547BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F9BC433D2;
	Tue,  7 Mar 2023 18:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212973;
	bh=JkcloqCC/Tql+86QrvcEC6ePPKVOvxwt3OC7b3rY9f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ty63PmXT7GpqKyAJYA3f1NpIJJ4D+F0RZZgJi0noEND1xqNyJhFg0xRRyRLHM3jUg
	 JFp8zSF0S4T+8oucMC3JasdCaMqyZZyTdx8LY/ISOSrWjgLDJgeDeM4lsM9VE3O2P3
	 ImZeLi6P+LQWTUb9VoqaFfCXmadoUySj9/1UY0Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Nocera <hadess@hadess.net>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 358/885] HID: logitech-hidpp: Hard-code HID++ 1.0 fast scroll support
Date: Tue,  7 Mar 2023 17:54:52 +0100
Message-Id: <20230307170017.832667916@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bastien Nocera <hadess@hadess.net>

[ Upstream commit 719acb4d3b7accc9cfbaf21c1c2d51dc7384aee2 ]

HID++ 1.0 devices only export whether Fast Scrolling is enabled, not
whether they are capable of it. Reinstate the original quirks for the 3
supported mice so fast scrolling works again on those devices.

Fixes: 908d325e1665 ("HID: logitech-hidpp: Detect hi-res scrolling support")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216903
Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20230116130937.391441-1-hadess@hadess.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 07b8506eecc41..19fce82d03f02 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -77,6 +77,7 @@ MODULE_PARM_DESC(disable_tap_to_click,
 #define HIDPP_QUIRK_HIDPP_WHEELS		BIT(26)
 #define HIDPP_QUIRK_HIDPP_EXTRA_MOUSE_BTNS	BIT(27)
 #define HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS	BIT(28)
+#define HIDPP_QUIRK_HI_RES_SCROLL_1P0		BIT(29)
 
 /* These are just aliases for now */
 #define HIDPP_QUIRK_KBD_SCROLL_WHEEL HIDPP_QUIRK_HIDPP_WHEELS
@@ -3472,14 +3473,8 @@ static int hidpp_initialize_hires_scroll(struct hidpp_device *hidpp)
 			hid_dbg(hidpp->hid_dev, "Detected HID++ 2.0 hi-res scrolling\n");
 		}
 	} else {
-		struct hidpp_report response;
-
-		ret = hidpp_send_rap_command_sync(hidpp,
-						  REPORT_ID_HIDPP_SHORT,
-						  HIDPP_GET_REGISTER,
-						  HIDPP_ENABLE_FAST_SCROLL,
-						  NULL, 0, &response);
-		if (!ret) {
+		/* We cannot detect fast scrolling support on HID++ 1.0 devices */
+		if (hidpp->quirks & HIDPP_QUIRK_HI_RES_SCROLL_1P0) {
 			hidpp->capabilities |= HIDPP_CAPABILITY_HIDPP10_FAST_SCROLL;
 			hid_dbg(hidpp->hid_dev, "Detected HID++ 1.0 fast scroll\n");
 		}
@@ -4297,9 +4292,15 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_T651),
 	  .driver_data = HIDPP_QUIRK_CLASS_WTP },
+	{ /* Mouse Logitech Anywhere MX */
+	  LDJ_DEVICE(0x1017), .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_1P0 },
 	{ /* Mouse logitech M560 */
 	  LDJ_DEVICE(0x402d),
 	  .driver_data = HIDPP_QUIRK_DELAYED_INIT | HIDPP_QUIRK_CLASS_M560 },
+	{ /* Mouse Logitech M705 (firmware RQM17) */
+	  LDJ_DEVICE(0x101b), .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_1P0 },
+	{ /* Mouse Logitech Performance MX */
+	  LDJ_DEVICE(0x101a), .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_1P0 },
 	{ /* Keyboard logitech K400 */
 	  LDJ_DEVICE(0x4024),
 	  .driver_data = HIDPP_QUIRK_CLASS_K400 },
-- 
2.39.2



