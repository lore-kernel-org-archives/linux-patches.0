Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B4F20E7
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E62C433D2;
	Wed, 28 Dec 2022 16:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246616;
	bh=d9fuQAjAFaMjoypRMr5nO64/gU6ZQTz7JNAp7h7Qmhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+uwupL4bSHQR/mvwuHOcPQQNxPXlOREPqAqcxdYagJIC0W0u1eYxz++CA0+TbZkk
	 NtJwLCb1Qr8wNPiGDt/byD6/s0C3a900B6zXKd/QaYeaR73pg5ozRQeYL9x4E2okud
	 5q52reVLvbJKOPMTvmLJ+gsSh1pXQJUAdYWRt8DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Bastien Nocera <hadess@hadess.net>
Subject: [PATCH 6.1 1102/1146] HID: logitech-hidpp: Guard FF init code against non-USB devices
Date: Wed, 28 Dec 2022 15:44:01 +0100
Message-Id: <20221228144400.092702807@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

commit 0e13e7b448005612972eae36c0f698c21d1e2f8a upstream.

The Force Feedback code assumes that all the devices passed to it will
be USB devices, but that might not be the case for emulated devices.
Guard against a crash by checking the device type before poking at USB
properties.

Cc: stable@vger.kernel.org # v5.16+
Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20221215154416.111704-1-hadess@hadess.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-logitech-hidpp.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -2548,12 +2548,17 @@ static int hidpp_ff_init(struct hidpp_de
 	struct hid_device *hid = hidpp->hid_dev;
 	struct hid_input *hidinput;
 	struct input_dev *dev;
-	const struct usb_device_descriptor *udesc = &(hid_to_usb_dev(hid)->descriptor);
-	const u16 bcdDevice = le16_to_cpu(udesc->bcdDevice);
+	struct usb_device_descriptor *udesc;
+	u16 bcdDevice;
 	struct ff_device *ff;
 	int error, j, num_slots = data->num_effects;
 	u8 version;
 
+	if (!hid_is_usb(hid)) {
+		hid_err(hid, "device is not USB\n");
+		return -ENODEV;
+	}
+
 	if (list_empty(&hid->inputs)) {
 		hid_err(hid, "no inputs found\n");
 		return -ENODEV;
@@ -2567,6 +2572,8 @@ static int hidpp_ff_init(struct hidpp_de
 	}
 
 	/* Get firmware release */
+	udesc = &(hid_to_usb_dev(hid)->descriptor);
+	bcdDevice = le16_to_cpu(udesc->bcdDevice);
 	version = bcdDevice & 255;
 
 	/* Set supported force feedback capabilities */


