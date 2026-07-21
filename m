Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2188D47254C;
	Tue, 21 Jul 2026 20:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665293; cv=none; b=mF6vd2IEYYBTWSFjH4u/o/XBxtKocx+WlRcjLeY/yndENBhOuyLw5JqytW++M7cJzZ4BhrN+hSUZwrjKZsIDkhA5guk/dArFKZ9U5JEy1JjCMQWi/fgQCB2qFDCjFmELdIOM0uTclBY4NQdwREJU5LMXs0FsoK2ybvaDwzBX3/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665293; c=relaxed/simple;
	bh=wLyTMexfsIb05TKWeL8b8G9nTSc+W5atM5qwhB4EPpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNB5oDMO43mB5jSq3iGgDP9ogXuQCYjI/TyjpwW3e9szHljGoqrRyNTFOPo5gLnyrishKs9KLHKDgcjVBv89a+VGosxreE7b5nCCWY9wSuie1CqS5EI56iatHTa31fmF+8mI/ECNM5m6L1YkdyeyM1hOQLU8oHPbkcehBFoMkBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OG3xTJca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OG3xTJca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731EF1F00A3A;
	Tue, 21 Jul 2026 20:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665291;
	bh=Mqv9/z98U2VnwLtaLGaanz9vbhL02A+O8yDq9IMQJvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OG3xTJcaABcFq1TkD0sWRQmRWcChPqA5GLZJSc4hksIWvopAWPLcZrkJjIUdeTR6Q
	 si0NH8HezU0J3Gk6hwC1F378b0DRNHrx1UqFCixR883MF47vduoz7hZdqZ4uqIL4ph
	 rh6QJABl7bl03R1YHnQcLYrYOQ8hN7j/4nL85pyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yichong Chen <chenyichong@uniontech.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.6 0249/1266] usbip: tools: support SuperSpeedPlus devices
Date: Tue, 21 Jul 2026 17:11:26 +0200
Message-ID: <20260721152447.385441864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

commit 195e667c8719480c320cd48ac0fbf1cb81d6ffe0 upstream.

USB devices running at SuperSpeedPlus report "10000" or "20000" in
their sysfs speed attribute. usbip currently maps only "5000" to
USB_SPEED_SUPER, so a SuperSpeedPlus device is imported as
USB_SPEED_UNKNOWN.

The attach request is then rejected by vhci_hcd:

  vhci_hcd: Failed attach request for unsupported USB speed: UNKNOWN

Map the SuperSpeedPlus sysfs speed values to USB_SPEED_SUPER_PLUS, use
the SuperSpeed VHCI hub for SuperSpeedPlus devices, and recognize the
gadget current_speed string used by the kernel.

Fixes: b2316645ca5e ("usb: show speed "10000" in sysfs for USB 3.1 SuperSpeedPlus devices")
Cc: stable <stable@kernel.org>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://patch.msgid.link/00C828F338E43447+20260617020613.199086-1-chenyichong@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/usb/usbip/libsrc/usbip_common.c        |    2 ++
 tools/usb/usbip/libsrc/usbip_device_driver.c |    4 ++++
 tools/usb/usbip/libsrc/vhci_driver.c         |    1 +
 3 files changed, 7 insertions(+)

--- a/tools/usb/usbip/libsrc/usbip_common.c
+++ b/tools/usb/usbip/libsrc/usbip_common.c
@@ -29,6 +29,8 @@ static const struct speed_string speed_s
 	{ USB_SPEED_HIGH, "480", "High Speed(480Mbps)" },
 	{ USB_SPEED_WIRELESS, "53.3-480", "Wireless"},
 	{ USB_SPEED_SUPER, "5000", "Super Speed(5000Mbps)" },
+	{ USB_SPEED_SUPER_PLUS, "10000", "Super Speed Plus(10000Mbps)" },
+	{ USB_SPEED_SUPER_PLUS, "20000", "Super Speed Plus(20000Mbps)" },
 	{ 0, NULL, NULL }
 };
 
--- a/tools/usb/usbip/libsrc/usbip_device_driver.c
+++ b/tools/usb/usbip/libsrc/usbip_device_driver.c
@@ -57,6 +57,10 @@ static struct {
 		.speed = USB_SPEED_SUPER,
 		.name = "super-speed",
 	},
+	{
+		.speed = USB_SPEED_SUPER_PLUS,
+		.name = "super-speed-plus",
+	},
 };
 
 static
--- a/tools/usb/usbip/libsrc/vhci_driver.c
+++ b/tools/usb/usbip/libsrc/vhci_driver.c
@@ -338,6 +338,7 @@ int usbip_vhci_get_free_port(uint32_t sp
 
 		switch (speed) {
 		case	USB_SPEED_SUPER:
+		case	USB_SPEED_SUPER_PLUS:
 			if (vhci_driver->idev[i].hub != HUB_SPEED_SUPER)
 				continue;
 		break;


