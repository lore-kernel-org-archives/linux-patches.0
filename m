Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C7C46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16615C433F1;
	Mon, 16 Jan 2023 16:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886480;
	bh=+XUpq7tjXmgq1/QAbNfwAYqbHUhuREjj+arXjvvXF1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJa/Ks0EuelGzdrY9i2cTs5gdmXbO3pvd+yPu03bgbuDM4z95ZD88ahvYkOUDN7hJ
	 TSaeaWMLkaxyvWqSOR/nr2j2ni3G6EsjNDDPKV+sohkglCeiec4VytXgergY/aVsxP
	 kIBn+0Yt7loA2D7hf8zDR1D34cyB913eib2F0Fa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>,
	Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.4 445/658] HID: wacom: Ensure bootloader PID is usable in hidraw mode
Date: Mon, 16 Jan 2023 16:48:53 +0100
Message-Id: <20230116154929.876570396@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Gerecke <killertofu@gmail.com>

commit 1db1f392591aff13fd643f0ec7c1d5e27391d700 upstream.

Some Wacom devices have a special "bootloader" mode that is used for
firmware flashing. When operating in this mode, the device cannot be
used for input, and the HID descriptor is not able to be processed by
the driver. The driver generates an "Unknown device_type" warning and
then returns an error code from wacom_probe(). This is a problem because
userspace still needs to be able to interact with the device via hidraw
to perform the firmware flash.

This commit adds a non-generic device definition for 056a:0094 which
is used when devices are in "bootloader" mode. It marks the devices
with a special BOOTLOADER type that is recognized by wacom_probe() and
wacom_raw_event(). When we see this type we ensure a hidraw device is
created and otherwise keep our hands off so that userspace is in full
control.

Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Tested-by: Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    8 ++++++++
 drivers/hid/wacom_wac.c |    4 ++++
 drivers/hid/wacom_wac.h |    1 +
 3 files changed, 13 insertions(+)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -160,6 +160,9 @@ static int wacom_raw_event(struct hid_de
 {
 	struct wacom *wacom = hid_get_drvdata(hdev);
 
+	if (wacom->wacom_wac.features.type == BOOTLOADER)
+		return 0;
+
 	if (size > WACOM_PKGLEN_MAX)
 		return 1;
 
@@ -2786,6 +2789,11 @@ static int wacom_probe(struct hid_device
 		return error;
 	}
 
+	if (features->type == BOOTLOADER) {
+		hid_warn(hdev, "Using device in hidraw-only mode");
+		return hid_hw_start(hdev, HID_CONNECT_HIDRAW);
+	}
+
 	error = wacom_parse_and_register(wacom, false);
 	if (error)
 		return error;
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -4782,6 +4782,9 @@ static const struct wacom_features wacom
 static const struct wacom_features wacom_features_HID_ANY_ID =
 	{ "Wacom HID", .type = HID_GENERIC, .oVid = HID_ANY_ID, .oPid = HID_ANY_ID };
 
+static const struct wacom_features wacom_features_0x94 =
+	{ "Wacom Bootloader", .type = BOOTLOADER };
+
 #define USB_DEVICE_WACOM(prod)						\
 	HID_DEVICE(BUS_USB, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
 	.driver_data = (kernel_ulong_t)&wacom_features_##prod
@@ -4855,6 +4858,7 @@ const struct hid_device_id wacom_ids[] =
 	{ USB_DEVICE_WACOM(0x84) },
 	{ USB_DEVICE_WACOM(0x90) },
 	{ USB_DEVICE_WACOM(0x93) },
+	{ USB_DEVICE_WACOM(0x94) },
 	{ USB_DEVICE_WACOM(0x97) },
 	{ USB_DEVICE_WACOM(0x9A) },
 	{ USB_DEVICE_WACOM(0x9F) },
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -242,6 +242,7 @@ enum {
 	MTTPC,
 	MTTPC_B,
 	HID_GENERIC,
+	BOOTLOADER,
 	MAX_TYPE
 };
 


