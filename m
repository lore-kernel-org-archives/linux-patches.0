Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47491C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEB1C433EF;
	Wed, 28 Dec 2022 16:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245634;
	bh=yreuj1Pmw8nwCm3ADVtacDriCMOlBPDxspsHT79iAJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvezIWEo9i/d8P687vpQjU8XVZOE/jaeObXTKz0kFwnJLuBOGE2hH0cuJeGdThJcc
	 U8iAImyzYUv4pXSeC0OvpyZ+UeEbVHPtc+PvEM844bCqq4WXISUdqsF7zkmZkO6Uak
	 SqSOGP9l8uxcGCnaB0V9rQSx/przi1yqrwNhzltM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mia Kanashi <chad@redpilled.dev>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0929/1073] HID: input: do not query XP-PEN Deco LW battery
Date: Wed, 28 Dec 2022 15:41:57 +0100
Message-Id: <20221228144353.260902381@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 037c1aaeb96fe5f778026f4c1ef28b26cf600bfa ]

The XP-PEN Deco LW drawing tablet can be connected by USB cable or using
a USB Bluetooth dongle. When it is connected using the dongle, there
might be a small delay until the tablet is paired with the dongle.

Fetching the device battery during this delay results in random battery
percentage values.

Add a quirk to avoid actively querying the battery percentage and wait
for the device to report it on its own.

Reported-by: Mia Kanashi <chad@redpilled.dev>
Tested-by: Mia Kanashi <chad@redpilled.dev>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 859aeb07542e..d728a94c642e 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -340,6 +340,7 @@ static enum power_supply_property hidinput_battery_props[] = {
 #define HID_BATTERY_QUIRK_PERCENT	(1 << 0) /* always reports percent */
 #define HID_BATTERY_QUIRK_FEATURE	(1 << 1) /* ask for feature report */
 #define HID_BATTERY_QUIRK_IGNORE	(1 << 2) /* completely ignore the battery */
+#define HID_BATTERY_QUIRK_AVOID_QUERY	(1 << 3) /* do not query the battery */
 
 static const struct hid_device_id hid_battery_quirks[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
@@ -373,6 +374,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE, USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L),
+	  HID_BATTERY_QUIRK_AVOID_QUERY },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15),
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15T_DR100),
@@ -554,6 +557,9 @@ static int hidinput_setup_battery(struct hid_device *dev, unsigned report_type,
 	dev->battery_avoid_query = report_type == HID_INPUT_REPORT &&
 				   field->physical == HID_DG_STYLUS;
 
+	if (quirks & HID_BATTERY_QUIRK_AVOID_QUERY)
+		dev->battery_avoid_query = true;
+
 	dev->battery = power_supply_register(&dev->dev, psy_desc, &psy_cfg);
 	if (IS_ERR(dev->battery)) {
 		error = PTR_ERR(dev->battery);
-- 
2.35.1



