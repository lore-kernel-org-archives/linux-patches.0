Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6647443D4FA;
	Mon, 17 Aug 2026 13:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974334; cv=none; b=UBiMjIWS9BtoquLrXIIftYpeIbZh5XIQ4aNmRXOkxrqJz+88eQSeDM9wKpMPFdjv+0J4FZ3u/6pemNS+3PRpGzApCmcMO4GKxq9xDt1xLscBzk32g7yJiupzFqcgR9ZcYGhxTTPrLfpuamsOFTZqsYKnvVKQaxkGzLNlGMwDSGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974334; c=relaxed/simple;
	bh=FnDOVSoUYSP6zCJ9ofi/87IS6TeydII+itKZqFVzbWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkhYhxWQwmDDfrFLepaQuZL33otooj3gr8V7mZDzHphY03U/lM9XgPls2Y1Ljlh7IguZG2lKuxvu1gyLUVQjovCt896cCA7DwvUaEYu8SJYdEJOBNmz9NNmP0cZErcQZUvqKbVaUxC5qPDtIz5zqSRQfr+KrrG1QY4TWJgyaHY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZ6aMgsS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZ6aMgsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D191F00A3D;
	Mon, 17 Aug 2026 13:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974326;
	bh=h8eEU43llZn2jfnrw0cGuodWS3RPQrW7OXh3BYvimrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZ6aMgsSaCc5+PE5jeMYlBFCEvRaFx3PWj4BG0Y0M5+VKXJqu5bWB8wN15pf9qc3Z
	 CiRl67hq/Gi/z3SJkZqTon7xglc1oQjUHL4DF1H0JzDc4wREuomnxk/6+VLu5ldwk5
	 3OyQxcegC8KTMhRKV5I6tzyyJn5vQ4UNdJKrcu/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Michal Pecio <michal.pecio@gmail.com>,
	stable <stable@kernel.org>,
	Nikhil Solanke <nikhilsolanke5@gmail.com>
Subject: [PATCH 7.1 127/271] usb: core: Add quirk for 255-bytes initial config read
Date: Mon, 17 Aug 2026 15:30:52 +0200
Message-ID: <20260817132542.082464627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil Solanke <nikhilsolanke5@gmail.com>

commit 152f174a13618bec1f842d2deb69245cb2ace51f upstream.

Certain third-party USB game controllers exposing (or spoofing) an Xbox
360-compatible interface (VID:PID 045e:028e) fail to enumerate under Linux.
The device disconnects from the bus without responding to the initial
GET_DESCRIPTOR(CONFIGURATION) request, and the kernel logs 'unable to read
config index 0 descriptor/start: -71'.

The device then falls back to a secondary Android HID mode (with a
different VID:PID), losing XInput functionality including rumble support.
The failure reproduces across multiple machines, host controller types, and
kernel versions including current mainline and LTS. The device enumerates
correctly and remains in XInput mode under Windows. Notably, the device
enumerates correctly in Android mode when the same 9-byte request
is issued for that mode's configuration descriptor, confirming the firmware
bug is specific to the XInput mode.

usbmon traces from Linux and Wireshark/USBPcap traces from Windows are
identical up to the point of failure, with no visible protocol-level
difference explaining the divergence. The root cause was identified when
Michal Pecio discovered via a QEMU bus-level capture that Windows does not
use wLength=9 for the initial config descriptor request; it uses
wLength=255. Alan Stern subsequently confirmed this with a bus
analyzer on a different USB 2.0 device, and Michal verified the behavior
goes back to Windows 95 OSR2.1.

So, add a new quirk flag USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE which causes
usb_get_configuration() to issue a 255 byte sized configuration request
instead of USB_DT_CONFIG_SIZE (9) for the initial
GET_DESCRIPTOR(CONFIGURATION) request, mimicking long-standing Windows
behavior.

This patch intentionally does not add any new VID:PID entries using this
quirk. Some affected Xbox 360-compatible controllers spoof Microsoft's
VID:PID, while genuine Microsoft controllers already enumerate correctly
and do not require this quirk. Other affected clone devices use their own
VID:PID pairs and can be added individually as they are identified.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Suggested-by: Michal Pecio <michal.pecio@gmail.com>
Closes: https://lore.kernel.org/linux-usb/CAFgddh+JWdT4LLwMc5qjM8q_pBu-fRo2qADR5ovAKoGHWMQrRw@mail.gmail.com/
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Nikhil Solanke <nikhilsolanke5@gmail.com>
Link: https://patch.msgid.link/20260728195158.65162-2-nikhilsolanke5@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    5 +++
 drivers/usb/core/config.c                       |   32 ++++++++++++++++++------
 drivers/usb/core/quirks.c                       |    4 +++
 include/linux/usb/quirks.h                      |    3 ++
 4 files changed, 36 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -8158,6 +8158,11 @@ Kernel parameters
 				q = USB_QUIRK_FORCE_ONE_CONFIG (Device
 					claims zero configurations,
 					forcing to 1);
+				r = USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE (Device
+					fails during initialization when asked for
+					9-bytes configuration descriptor request.
+					Ask for 255-bytes request instead to mirror
+					Windows' behavior);
 			Example: quirks=0781:5580:bk,0a5c:5834:gij
 
 	usbhid.mousepoll=
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -912,6 +912,18 @@ int usb_get_configuration(struct usb_dev
 	unsigned char *bigbuffer;
 	struct usb_config_descriptor *desc;
 	int result;
+	size_t usb_config_req_size;
+
+	/*
+	 * We usually start by grabbing the first 9-bytes descriptor so we know
+	 * how long the whole configuration is. Some devices with quirky
+	 * firmware will fail enumeration, so if the quirk is set, use 255 instead,
+	 * mirroring the behavior of Windows.
+	 */
+	if (dev->quirks & USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE)
+		usb_config_req_size = 255;
+	else
+		usb_config_req_size = USB_DT_CONFIG_SIZE;
 
 	if (ncfg > USB_MAXCONFIG) {
 		dev_notice(ddev, "too many configurations: %d, "
@@ -938,15 +950,13 @@ int usb_get_configuration(struct usb_dev
 	if (!dev->rawdescriptors)
 		return -ENOMEM;
 
-	desc = kmalloc(USB_DT_CONFIG_SIZE, GFP_KERNEL);
+	desc = kmalloc(usb_config_req_size, GFP_KERNEL);
 	if (!desc)
 		return -ENOMEM;
 
 	for (cfgno = 0; cfgno < ncfg; cfgno++) {
-		/* We grab just the first descriptor so we know how long
-		 * the whole configuration is */
 		result = usb_get_descriptor(dev, USB_DT_CONFIG, cfgno,
-		    desc, USB_DT_CONFIG_SIZE);
+		    desc, usb_config_req_size);
 		if (result < 0) {
 			dev_err(ddev, "unable to read config index %d "
 			    "descriptor/%s: %d\n", cfgno, "start", result);
@@ -956,16 +966,14 @@ int usb_get_configuration(struct usb_dev
 			dev->descriptor.bNumConfigurations = cfgno;
 			break;
 		} else if (result < 4) {
-			dev_err(ddev, "config index %d descriptor too short "
-			    "(expected %i, got %i)\n", cfgno,
-			    USB_DT_CONFIG_SIZE, result);
+			dev_err(ddev, "config index %d descriptor too short (asked for %zu, got %i)\n",
+			    cfgno, usb_config_req_size, result);
 			result = -EINVAL;
 			goto err;
 		}
 		length = max_t(int, le16_to_cpu(desc->wTotalLength),
 		    USB_DT_CONFIG_SIZE);
 
-		/* Now that we know the length, get the whole thing */
 		bigbuffer = kmalloc(length, GFP_KERNEL);
 		if (!bigbuffer) {
 			result = -ENOMEM;
@@ -975,6 +983,13 @@ int usb_get_configuration(struct usb_dev
 		if (dev->quirks & USB_QUIRK_DELAY_INIT)
 			msleep(200);
 
+		/* Skip the second read if we already got everything */
+		if (result >= length) {
+			memcpy(bigbuffer, desc, length);
+			goto store_and_parse;
+		}
+
+		/* Get the whole thing */
 		result = usb_get_descriptor(dev, USB_DT_CONFIG, cfgno,
 		    bigbuffer, length);
 		if (result < 0) {
@@ -989,6 +1004,7 @@ int usb_get_configuration(struct usb_dev
 			length = result;
 		}
 
+store_and_parse:
 		dev->rawdescriptors[cfgno] = bigbuffer;
 
 		result = usb_parse_configuration(dev, cfgno,
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -142,6 +142,10 @@ static int quirks_param_set(const char *
 				break;
 			case 'q':
 				flags |= USB_QUIRK_FORCE_ONE_CONFIG;
+				break;
+			case 'r':
+				flags |= USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE;
+				break;
 			/* Ignore unrecognized flag characters */
 			}
 		}
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -81,4 +81,7 @@
 /* Device claims zero configurations, forcing to 1 */
 #define USB_QUIRK_FORCE_ONE_CONFIG		BIT(18)
 
+/* Use a 255 bytes config descriptor request mirroring windows behavior */
+#define USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE	BIT(19)
+
 #endif /* __LINUX_USB_QUIRKS_H */


