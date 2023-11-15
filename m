Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D3943ACE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LF9qzgXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA273C4E662;
	Wed, 15 Nov 2023 20:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081439;
	bh=nwoCns5u/Vdh294WQTqk4SRERkVj0A2xFQJmjnsmW08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LF9qzgXY/W/O4h66wtAAsK/RfhOvDA/a4VJuqPYqfbgY49hoh2gaXOBCRVSoaXHSB
	 Nml3wIREnaW5UIKM9iySgBCJkLlkjv0NDDXWp5oaHVEIYiD/BUFjK+Be5ioMFqooW6
	 +/5E+qb365JMaR3g/TmwvLdHY8Y9AJvKXwGv8BA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/244] HID: logitech-hidpp: Move get_wireless_feature_index() check to hidpp_connect_event()
Date: Wed, 15 Nov 2023 15:35:46 -0500
Message-ID: <20231115203557.582078901@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit ba9de350509504fb748837b71e23d7e84c83d93c ]

Calling get_wireless_feature_index() from probe() causes
the wireless_feature_index to only get set for unifying devices which
are already connected at probe() time. It does not get set for devices
which connect later.

Fix this by moving get_wireless_feature_index() to hidpp_connect_event(),
this does not make a difference for devices connected at probe() since
probe() will queue the hidpp_connect_event() for those at probe time.

This series has been tested on the following devices:
Logitech Bluetooth Laser Travel Mouse (bluetooth, HID++ 1.0)
Logitech M720 Triathlon (bluetooth, HID++ 4.5)
Logitech M720 Triathlon (unifying, HID++ 4.5)
Logitech K400 Pro (unifying, HID++ 4.1)
Logitech K270 (eQUAD nano Lite, HID++ 2.0)
Logitech M185 (eQUAD nano Lite, HID++ 4.5)
Logitech LX501 keyboard (27 Mhz, HID++ builtin scroll-wheel, HID++ 1.0)
Logitech M-RAZ105 mouse (27 Mhz, HID++ extra mouse buttons, HID++ 1.0)

And by bentiss:
Logitech Touchpad T650 (unifying)
Logitech Touchpad T651 (bluetooth)
Logitech MX Master 3B (BLE)
Logitech G403 (plain USB / Gaming receiver)

Fixes: 0da0a63b7cba ("HID: logitech-hidpp: Support WirelessDeviceStatus connect events")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20231010102029.111003-4-hdegoede@redhat.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index f7d6927f95076..fb287c4cbd5b8 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -1753,15 +1753,14 @@ static int hidpp_battery_get_property(struct power_supply *psy,
 /* -------------------------------------------------------------------------- */
 #define HIDPP_PAGE_WIRELESS_DEVICE_STATUS			0x1d4b
 
-static int hidpp_set_wireless_feature_index(struct hidpp_device *hidpp)
+static int hidpp_get_wireless_feature_index(struct hidpp_device *hidpp, u8 *feature_index)
 {
 	u8 feature_type;
 	int ret;
 
 	ret = hidpp_root_get_feature(hidpp,
 				     HIDPP_PAGE_WIRELESS_DEVICE_STATUS,
-				     &hidpp->wireless_feature_index,
-				     &feature_type);
+				     feature_index, &feature_type);
 
 	return ret;
 }
@@ -3950,6 +3949,13 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
 		}
 	}
 
+	if (hidpp->protocol_major >= 2) {
+		u8 feature_index;
+
+		if (!hidpp_get_wireless_feature_index(hidpp, &feature_index))
+			hidpp->wireless_feature_index = feature_index;
+	}
+
 	if (hidpp->name == hdev->name && hidpp->protocol_major >= 2) {
 		name = hidpp_get_device_name(hidpp);
 		if (name) {
@@ -4188,14 +4194,6 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		hidpp_overwrite_name(hdev);
 	}
 
-	if (connected && hidpp->protocol_major >= 2) {
-		ret = hidpp_set_wireless_feature_index(hidpp);
-		if (ret == -ENOENT)
-			hidpp->wireless_feature_index = 0;
-		else if (ret)
-			goto hid_hw_init_fail;
-	}
-
 	if (connected && (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)) {
 		ret = wtp_get_config(hidpp);
 		if (ret)
-- 
2.42.0



