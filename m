Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F1744330F;
	Tue, 21 Jul 2026 21:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671184; cv=none; b=TuHrfyCHlFvprK4Qivt7u8H8QObi5f7ukAa1VWVXChaKI19W+L56f67aNZ6IfD2wce0uLZvFohUys7edB5WunkeGG8qW42H/IegRtx3qSeRiR52SkbRuiEcoutmFUtTUVMTNOsDRyykVgSSPGpTDHP2dukH7X2kJ62DZiZ2hTl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671184; c=relaxed/simple;
	bh=79XhcBGWYkfHrCH7kuYGlAcm7CDAWI4keUZW+rq+bxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7kTaIdyXOrSE9igZvowGTz6Mf6PXoR6NFOzZJB1gE6GnGVuRtbxfI5YQ5wBrH+IpGJ7bxcU8FAGClbajtAoEoCjTolu7oQYk5/k7vwDMod8PPsfI8t37XMwDalvcn16YxqafLy64eF9QfEhIi8ovK6ggHzcfrfURnydIhBIQZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeM/xvZ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeM/xvZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE341F000E9;
	Tue, 21 Jul 2026 21:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671183;
	bh=BM3fYVuHZM9rVjUXxRafAv6ACi8HX3+ZcAy5HU9KK4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LeM/xvZ5kWsDanLLvhi3ZkR6A7+LRF8PIezWTrsprD/Fa0/Gg5KpgEDGWVYus+BdV
	 thIEHaHFRlmuJNSf6xrKO4/X024wSWV0NlUjGKFAmsrQWu2IBhaV2NDkVma1MS9dLu
	 KGesuBbuB1Lp23op0NmqROFQ2hv4UU5U+3DnHVqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yichong Chen <chenyichong@uniontech.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.15 150/843] usbip: tools: support SuperSpeedPlus devices
Date: Tue, 21 Jul 2026 17:16:25 +0200
Message-ID: <20260721152409.386284438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


