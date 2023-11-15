Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0A743ACE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cj9B4z1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B02C4E663;
	Wed, 15 Nov 2023 20:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081438;
	bh=i1aPZbys+JVrjJyHuQ/kqoqGqbS8p76yaHIoKYrdjMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cj9B4z1hSV2ZVeJSbOjo1x6jT4nb+nX19+E0LfjdmZG7qfoaQipoXC+g2wEXkzm6Y
	 GmKMlOetFIm39lIUnxIblB1jH+nUXCDRsoY/J/fMjprlNIMMNamOrAFdh38ltlQiNw
	 Wkaq1ECzi1jLchtzuC6DBE02g6mG1QQj0ImluSaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/244] HID: logitech-hidpp: Revert "Dont restart communication if not necessary"
Date: Wed, 15 Nov 2023 15:35:45 -0500
Message-ID: <20231115203557.520863583@linuxfoundation.org>
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

[ Upstream commit 55bf70362ffc4ddd7c8745e2fe880edac00e4aff ]

Commit 91cf9a98ae41 ("HID: logitech-hidpp: make .probe usbhid capable")
makes hidpp_probe() first call hid_hw_start(hdev, 0) to allow IO
without connecting any hid subdrivers (hid-input, hidraw).

This is done to allow to retrieve the device's name and serial number
and store these in hdev->name and hdev->uniq.

Then later on IO was stopped and started again with hid_hw_start(hdev,
HID_CONNECT_DEFAULT) connecting hid-input and hidraw after the name
and serial number have been setup.

Commit 498ba2069035 ("HID: logitech-hidpp: Don't restart communication
if not necessary") changed the probe() code to only do the start with
a 0 connect-mask + restart later for unifying devices.

But for non unifying devices hdev->name and hdev->uniq are updated too.
So this change re-introduces the problem for which the start with
a 0 connect-mask + restart later behavior was introduced.

The previous patch in this series changes the unifying path to instead of
restarting IO only call hid_connect() later. This avoids possible issues
with restarting IO seen on non unifying devices.

Revert the change to limit the restart behavior to unifying devices to
fix hdev->name changing after userspace facing devices have already been
registered.

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

Fixes: 498ba2069035 ("HID: logitech-hidpp: Don't restart communication if not necessary")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20231010102029.111003-3-hdegoede@redhat.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 907f45dfef4c1..f7d6927f95076 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4089,7 +4089,6 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	bool connected;
 	unsigned int connect_mask = HID_CONNECT_DEFAULT;
 	struct hidpp_ff_private_data data;
-	bool will_restart = false;
 
 	/* report_fixup needs drvdata to be set before we call hid_parse */
 	hidpp = devm_kzalloc(&hdev->dev, sizeof(*hidpp), GFP_KERNEL);
@@ -4140,10 +4139,6 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			return ret;
 	}
 
-	if (hidpp->quirks & HIDPP_QUIRK_DELAYED_INIT ||
-	    hidpp->quirks & HIDPP_QUIRK_UNIFYING)
-		will_restart = true;
-
 	INIT_WORK(&hidpp->work, delayed_work_cb);
 	mutex_init(&hidpp->send_mutex);
 	init_waitqueue_head(&hidpp->wait);
@@ -4160,7 +4155,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	 * name and serial number and store these in hdev->name and hdev->uniq,
 	 * before the hid-input and hidraw drivers expose these to userspace.
 	 */
-	ret = hid_hw_start(hdev, will_restart ? 0 : connect_mask);
+	ret = hid_hw_start(hdev, 0);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
 		goto hid_hw_start_fail;
@@ -4199,7 +4194,6 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			hidpp->wireless_feature_index = 0;
 		else if (ret)
 			goto hid_hw_init_fail;
-		ret = 0;
 	}
 
 	if (connected && (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)) {
@@ -4215,16 +4209,14 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	schedule_work(&hidpp->work);
 	flush_work(&hidpp->work);
 
-	if (will_restart) {
-		if (hidpp->quirks & HIDPP_QUIRK_DELAYED_INIT)
-			connect_mask &= ~HID_CONNECT_HIDINPUT;
+	if (hidpp->quirks & HIDPP_QUIRK_DELAYED_INIT)
+		connect_mask &= ~HID_CONNECT_HIDINPUT;
 
-		/* Now export the actual inputs and hidraw nodes to the world */
-		ret = hid_connect(hdev, connect_mask);
-		if (ret) {
-			hid_err(hdev, "%s:hid_connect returned error %d\n", __func__, ret);
-			goto hid_hw_init_fail;
-		}
+	/* Now export the actual inputs and hidraw nodes to the world */
+	ret = hid_connect(hdev, connect_mask);
+	if (ret) {
+		hid_err(hdev, "%s:hid_connect returned error %d\n", __func__, ret);
+		goto hid_hw_init_fail;
 	}
 
 	if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920) {
-- 
2.42.0



