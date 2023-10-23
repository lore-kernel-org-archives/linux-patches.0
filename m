Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EC715493
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flVjRF1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8F9C43391;
	Mon, 23 Oct 2023 11:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060267;
	bh=xu3rHB4Wao+xb73wd/oM03QPow3vlSi1ZPfLGJGflWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flVjRF1+YQ7RQ3y6/0rxdgpGxDj9SpKLgRD6bQTqrFO4xChq0Ukz5uvlfEbp2iDCb
	 Av81oMS1Zvbh+H738Udkq1aMRvqgqoYnGg7mH+7Ayq4s9xtKMBqA8CeU/u2HCwT9U/
	 i3h3h6JfpFDURjt8xB9Ui89Sd5sr2x6b2TdkdmDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Matthias Kaehlcke <mka@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/196] usb: misc: onboard_usb_hub: add Genesys Logic GL850G hub support
Date: Mon, 23 Oct 2023 12:55:43 +0200
Message-ID: <20231023104830.754735961@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit 9bae996ffa28ac03b6d95382a2a082eb219e745a ]

Genesys Logic GL850G is a 4-port USB 2.0 STT hub that has a reset pin to
toggle and a 3.3V core supply exported (although an integrated LDO is
available for powering it with 5V).

Add the support for this hub, for controlling the reset pin and the core
power supply.

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Acked-by: Matthias Kaehlcke <mka@chromium.org>
Link: https://lore.kernel.org/r/20221206055228.306074-4-uwu@icenowy.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e59e38158c61 ("usb: misc: onboard_hub: add support for Microchip USB2412 USB 2.0 hub")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/onboard_usb_hub.c | 2 ++
 drivers/usb/misc/onboard_usb_hub.h | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/misc/onboard_usb_hub.c b/drivers/usb/misc/onboard_usb_hub.c
index 832d3ba9368ff..87df27425ec5f 100644
--- a/drivers/usb/misc/onboard_usb_hub.c
+++ b/drivers/usb/misc/onboard_usb_hub.c
@@ -329,6 +329,7 @@ static struct platform_driver onboard_hub_driver = {
 
 /************************** USB driver **************************/
 
+#define VENDOR_ID_GENESYS	0x05e3
 #define VENDOR_ID_MICROCHIP	0x0424
 #define VENDOR_ID_REALTEK	0x0bda
 #define VENDOR_ID_TI		0x0451
@@ -405,6 +406,7 @@ static void onboard_hub_usbdev_disconnect(struct usb_device *udev)
 }
 
 static const struct usb_device_id onboard_hub_id_table[] = {
+	{ USB_DEVICE(VENDOR_ID_GENESYS, 0x0608) }, /* Genesys Logic GL850G USB 2.0 */
 	{ USB_DEVICE(VENDOR_ID_MICROCHIP, 0x2514) }, /* USB2514B USB 2.0 */
 	{ USB_DEVICE(VENDOR_ID_MICROCHIP, 0x2517) }, /* USB2517 USB 2.0 */
 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x0411) }, /* RTS5411 USB 3.1 */
diff --git a/drivers/usb/misc/onboard_usb_hub.h b/drivers/usb/misc/onboard_usb_hub.h
index 2cde54b69eede..a97b0594773fa 100644
--- a/drivers/usb/misc/onboard_usb_hub.h
+++ b/drivers/usb/misc/onboard_usb_hub.h
@@ -22,11 +22,16 @@ static const struct onboard_hub_pdata ti_tusb8041_data = {
 	.reset_us = 3000,
 };
 
+static const struct onboard_hub_pdata genesys_gl850g_data = {
+	.reset_us = 3,
+};
+
 static const struct of_device_id onboard_hub_match[] = {
 	{ .compatible = "usb424,2514", .data = &microchip_usb424_data, },
 	{ .compatible = "usb424,2517", .data = &microchip_usb424_data, },
 	{ .compatible = "usb451,8140", .data = &ti_tusb8041_data, },
 	{ .compatible = "usb451,8142", .data = &ti_tusb8041_data, },
+	{ .compatible = "usb5e3,608", .data = &genesys_gl850g_data, },
 	{ .compatible = "usbbda,411", .data = &realtek_rts5411_data, },
 	{ .compatible = "usbbda,5411", .data = &realtek_rts5411_data, },
 	{ .compatible = "usbbda,414", .data = &realtek_rts5411_data, },
-- 
2.40.1



