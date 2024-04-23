Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A66A143882;
	Tue, 23 Apr 2024 21:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908737; cv=none; b=gwawvfr4qxTztTYjGdQMMf5eAUVmFeDTXlIY/b8kJV9M9o2d5xKF7SNKpwOFxXU1NA20nZpLztcCcuTRkEvDaXR6+xFMT39LUsdum09f27b7IW0NfuBJmPJO2SaYmqtc5SsWgNqAtPF0RKmcI+t+/J+OcVR9ITW3384yy52VdnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908737; c=relaxed/simple;
	bh=Y1FZyTDuY2qYbw6E/xhFlpNzzW5pDCq7tLoxfZaQPWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEZN7hekf/BjM2pUvV3qhD+vuDWSxSRC5ZNEjenM2hK1dMl0Nbz+B3713k9Q0xk9b/88W1I1pDUI2QG10TQrfHxXNV1gf3H29OnRJvrSxq9Naq3Xck+JSOa9jj18wPvquVAXRO+erWRUtwXb5v/DTmlKoEbIMtDmoYEPfu6jBVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMMEf2qv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMMEf2qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70182C3277B;
	Tue, 23 Apr 2024 21:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908737;
	bh=Y1FZyTDuY2qYbw6E/xhFlpNzzW5pDCq7tLoxfZaQPWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMMEf2qvA4Un+tmqRvGHsuxRfAYgvXPUBsonT9sxY/xX2d5JS3VRhP44sX5Ls7E60
	 kyvsQCuzy9/Uz5hsbChK1tv8JnX/l1jLVp6cit2h8ZSzkFnUnHIcGCCBMsx1lKCAWT
	 44mSDqwx0k7Z6up0Lf1xVETg0buOTTYtHeWMpaZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hardik Gajjar <hgajjar@de.adit-jv.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/141] usb: new quirk to reduce the SET_ADDRESS request timeout
Date: Tue, 23 Apr 2024 14:39:10 -0700
Message-ID: <20240423213855.836309484@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

From: Hardik Gajjar <hgajjar@de.adit-jv.com>

[ Upstream commit 5a1ccf0c72cf917ff3ccc131d1bb8d19338ffe52 ]

This patch introduces a new USB quirk,
USB_QUIRK_SHORT_SET_ADDRESS_REQ_TIMEOUT, which modifies the timeout value
for the SET_ADDRESS request. The standard timeout for USB request/command
is 5000 ms, as recommended in the USB 3.2 specification (section 9.2.6.1).

However, certain scenarios, such as connecting devices through an APTIV
hub, can lead to timeout errors when the device enumerates as full speed
initially and later switches to high speed during chirp negotiation.

In such cases, USB analyzer logs reveal that the bus suspends for
5 seconds due to incorrect chirp parsing and resumes only after two
consecutive timeout errors trigger a hub driver reset.

Packet(54) Dir(?) Full Speed J(997.100 us) Idle(  2.850 us)
_______| Time Stamp(28 . 105 910 682)
_______|_____________________________________________________________Ch0
Packet(55) Dir(?) Full Speed J(997.118 us) Idle(  2.850 us)
_______| Time Stamp(28 . 106 910 632)
_______|_____________________________________________________________Ch0
Packet(56) Dir(?) Full Speed J(399.650 us) Idle(222.582 us)
_______| Time Stamp(28 . 107 910 600)
_______|_____________________________________________________________Ch0
Packet(57) Dir Chirp J( 23.955 ms) Idle(115.169 ms)
_______| Time Stamp(28 . 108 532 832)
_______|_____________________________________________________________Ch0
Packet(58) Dir(?) Full Speed J (Suspend)( 5.347 sec) Idle(  5.366 us)
_______| Time Stamp(28 . 247 657 600)
_______|_____________________________________________________________Ch0

This 5-second delay in device enumeration is undesirable, particularly
in automotive applications where quick enumeration is crucial
(ideally within 3 seconds).

The newly introduced quirks provide the flexibility to align with a
3-second time limit, as required in specific contexts like automotive
applications.

By reducing the SET_ADDRESS request timeout to 500 ms, the
system can respond more swiftly to errors, initiate rapid recovery, and
ensure efficient device enumeration. This change is vital for scenarios
where rapid smartphone enumeration and screen projection are essential.

To use the quirk, please write "vendor_id:product_id:p" to
/sys/bus/usb/drivers/hub/module/parameter/quirks

For example,
echo "0x2c48:0x0132:p" > /sys/bus/usb/drivers/hub/module/parameters/quirks"

Signed-off-by: Hardik Gajjar <hgajjar@de.adit-jv.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20231027152029.104363-2-hgajjar@de.adit-jv.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  3 +++
 drivers/usb/core/hub.c                          | 15 +++++++++++++--
 drivers/usb/core/quirks.c                       |  7 +++++++
 include/linux/usb/quirks.h                      |  3 +++
 4 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index aebbe2981241a..e6f0570cf4900 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6603,6 +6603,9 @@
 					pause after every control message);
 				o = USB_QUIRK_HUB_SLOW_RESET (Hub needs extra
 					delay after resetting its port);
+				p = USB_QUIRK_SHORT_SET_ADDRESS_REQ_TIMEOUT
+					(Reduce timeout of the SET_ADDRESS
+					request from 5000 ms to 500 ms);
 			Example: quirks=0781:5580:bk,0a5c:5834:gij
 
 	usbhid.mousepoll=
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index a661f6ac1ad14..dea110241ee71 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -60,6 +60,12 @@
 #define USB_PING_RESPONSE_TIME		400	/* ns */
 #define USB_REDUCE_FRAME_INTR_BINTERVAL	9
 
+/*
+ * The SET_ADDRESS request timeout will be 500 ms when
+ * USB_QUIRK_SHORT_SET_ADDRESS_REQ_TIMEOUT quirk flag is set.
+ */
+#define USB_SHORT_SET_ADDRESS_REQ_TIMEOUT	500  /* ms */
+
 /* Protect struct usb_device->state and ->children members
  * Note: Both are also protected by ->dev.sem, except that ->state can
  * change to USB_STATE_NOTATTACHED even when the semaphore isn't held. */
@@ -4648,7 +4654,12 @@ EXPORT_SYMBOL_GPL(usb_ep0_reinit);
 static int hub_set_address(struct usb_device *udev, int devnum)
 {
 	int retval;
+	unsigned int timeout_ms = USB_CTRL_SET_TIMEOUT;
 	struct usb_hcd *hcd = bus_to_hcd(udev->bus);
+	struct usb_hub *hub = usb_hub_to_struct_hub(udev->parent);
+
+	if (hub->hdev->quirks & USB_QUIRK_SHORT_SET_ADDRESS_REQ_TIMEOUT)
+		timeout_ms = USB_SHORT_SET_ADDRESS_REQ_TIMEOUT;
 
 	/*
 	 * The host controller will choose the device address,
@@ -4661,11 +4672,11 @@ static int hub_set_address(struct usb_device *udev, int devnum)
 	if (udev->state != USB_STATE_DEFAULT)
 		return -EINVAL;
 	if (hcd->driver->address_device)
-		retval = hcd->driver->address_device(hcd, udev, USB_CTRL_SET_TIMEOUT);
+		retval = hcd->driver->address_device(hcd, udev, timeout_ms);
 	else
 		retval = usb_control_msg(udev, usb_sndaddr0pipe(),
 				USB_REQ_SET_ADDRESS, 0, devnum, 0,
-				NULL, 0, USB_CTRL_SET_TIMEOUT);
+				NULL, 0, timeout_ms);
 	if (retval == 0) {
 		update_devnum(udev, devnum);
 		/* Device now using proper address. */
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 15e9bd180a1d2..b4783574b8e66 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -138,6 +138,9 @@ static int quirks_param_set(const char *value, const struct kernel_param *kp)
 			case 'o':
 				flags |= USB_QUIRK_HUB_SLOW_RESET;
 				break;
+			case 'p':
+				flags |= USB_QUIRK_SHORT_SET_ADDRESS_REQ_TIMEOUT;
+				break;
 			/* Ignore unrecognized flag characters */
 			}
 		}
@@ -527,6 +530,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 
 	{ USB_DEVICE(0x2386, 0x350e), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* APTIV AUTOMOTIVE HUB */
+	{ USB_DEVICE(0x2c48, 0x0132), .driver_info =
+			USB_QUIRK_SHORT_SET_ADDRESS_REQ_TIMEOUT },
+
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
diff --git a/include/linux/usb/quirks.h b/include/linux/usb/quirks.h
index eeb7c2157c72f..59409c1fc3dee 100644
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -72,4 +72,7 @@
 /* device has endpoints that should be ignored */
 #define USB_QUIRK_ENDPOINT_IGNORE		BIT(15)
 
+/* short SET_ADDRESS request timeout */
+#define USB_QUIRK_SHORT_SET_ADDRESS_REQ_TIMEOUT	BIT(16)
+
 #endif /* __LINUX_USB_QUIRKS_H */
-- 
2.43.0



