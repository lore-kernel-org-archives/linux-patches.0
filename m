Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B3D1C93A0;
	Tue, 27 Aug 2024 15:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772645; cv=none; b=Ra9jnv0t//+hguvuDMAakBW4UVq+m70BbVQIXt/033osEk4iiByi3ollj4ADRRGbV1Z0J4VgBHcTb/3nXfjlKyKSsTwKQFiz+nKkIaVEXLnDTtU59uIyHvgRlLOyIdvx6PlsT2tRbMPYnoggkYgneWf0Y4vYlxjG6bKJAPV2gFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772645; c=relaxed/simple;
	bh=RAgQa6MzCWFDY8dNSAQ7FU9lvlYBk8yUOaeSKbadiFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xe0ZtufPws+CcxiyDxFajjZN4lpXEnWYgGR6uLtcQZmIxjHJS3zjKatncJhttfAbynhXUslxAMfpw/mPoberMYgvE8K7tbggt7Rbzc6TmArUPmSdlY0iJluVECujeI2npI2bN+iU9KpdN0jWwmQ6svu0MVgtfNkes+SWiCWDveo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnNaW+nY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnNaW+nY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C81C4DDE3;
	Tue, 27 Aug 2024 15:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772644;
	bh=RAgQa6MzCWFDY8dNSAQ7FU9lvlYBk8yUOaeSKbadiFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnNaW+nYIeTVXNLiHk1ttELjRiqmhOwkhioUHqEB/nPzlBADm3kYA1C4V5m8mtEt4
	 7V4JuJFCQiF1bs6jgR9tVVXRp5hUfvmAne+1ZdE9m5Rt6a2nYJownCDfeOP8BKqWXX
	 ygiE9pDesufXlKK+HaQDWzFrW131aFgVEmrI1vOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Nocera <hadess@hadess.net>,
	Siarhei Vishniakou <svv@google.com>,
	Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 6.1 269/321] HID: microsoft: Add rumble support to latest xbox controllers
Date: Tue, 27 Aug 2024 16:39:37 +0200
Message-ID: <20240827143848.491960136@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Siarhei Vishniakou <svv@google.com>

commit f5554725f30475b05b5178b998366f11ecb50c7f upstream.

Currently, rumble is only supported via bluetooth on a single xbox
controller, called 'model 1708'. On the back of the device, it's named
'wireless controller for xbox one'. However, in 2021, Microsoft released
a firmware update for this controller. As part of this update, the HID
descriptor of the device changed. The product ID was also changed from
0x02fd to 0x0b20. On this controller, rumble was supported via
hid-microsoft, which matched against the old product id (0x02fd). As a
result, the firmware update broke rumble support on this controller.

See:
https://news.xbox.com/en-us/2021/09/08/xbox-controller-firmware-update-rolling-out-to-insiders-starting-today/

The hid-microsoft driver actually supports rumble on the new firmware,
as well. So simply adding new product id is sufficient to bring back
this support.

After discussing further with the xbox team, it was pointed out that
another xbox controller, xbox elite series 2, can be supported in a
similar way.

Add rumble support for all of these devices in this patch. Two of the
devices have received firmware updates that caused their product id's to
change. Both old and new firmware versions of these devices were tested.

The tested controllers are:

1. 'wireless controller for xbox one', model 1708
2. 'xbox wireless controller', model 1914. This is also sometimes
   referred to as 'xbox series S|X'.
3. 'elite series 2', model 1797.

The tested configurations are:
1. model 1708, pid 0x02fd (old firmware)
2. model 1708, pid 0x0b20 (new firmware)
3. model 1914, pid 0x0b13
4. model 1797, pid 0x0b05 (old firmware)
5. model 1797, pid 0x0b22 (new firmware)

I verified rumble support on both bluetooth and usb.

Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Siarhei Vishniakou <svv@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h       |   10 +++++++++-
 drivers/hid/hid-microsoft.c |   11 ++++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -924,7 +924,15 @@
 #define USB_DEVICE_ID_MS_TYPE_COVER_2    0x07a9
 #define USB_DEVICE_ID_MS_POWER_COVER     0x07da
 #define USB_DEVICE_ID_MS_SURFACE3_COVER		0x07de
-#define USB_DEVICE_ID_MS_XBOX_ONE_S_CONTROLLER	0x02fd
+/*
+ * For a description of the Xbox controller models, refer to:
+ * https://en.wikipedia.org/wiki/Xbox_Wireless_Controller#Summary
+ */
+#define USB_DEVICE_ID_MS_XBOX_CONTROLLER_MODEL_1708	0x02fd
+#define USB_DEVICE_ID_MS_XBOX_CONTROLLER_MODEL_1708_BLE	0x0b20
+#define USB_DEVICE_ID_MS_XBOX_CONTROLLER_MODEL_1914	0x0b13
+#define USB_DEVICE_ID_MS_XBOX_CONTROLLER_MODEL_1797	0x0b05
+#define USB_DEVICE_ID_MS_XBOX_CONTROLLER_MODEL_1797_BLE	0x0b22
 #define USB_DEVICE_ID_MS_PIXART_MOUSE    0x00cb
 #define USB_DEVICE_ID_8BITDO_SN30_PRO_PLUS      0x02e0
 #define USB_DEVICE_ID_MS_MOUSE_0783      0x0783
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -446,7 +446,16 @@ static const struct hid_device_id ms_dev
 		.driver_data = MS_PRESENTER },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, 0x091B),
 		.driver_data = MS_SURFACE_DIAL },
-	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_XBOX_ONE_S_CONTROLLER),
+
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_XBOX_CONTROLLER_MODEL_1708),
+		.driver_data = MS_QUIRK_FF },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_XBOX_CONTROLLER_MODEL_1708_BLE),
+		.driver_data = MS_QUIRK_FF },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_XBOX_CONTROLLER_MODEL_1914),
+		.driver_data = MS_QUIRK_FF },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_XBOX_CONTROLLER_MODEL_1797),
+		.driver_data = MS_QUIRK_FF },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_XBOX_CONTROLLER_MODEL_1797_BLE),
 		.driver_data = MS_QUIRK_FF },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_8BITDO_SN30_PRO_PLUS),
 		.driver_data = MS_QUIRK_FF },


