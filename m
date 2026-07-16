Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92603195EF;
	Thu, 16 Jul 2026 14:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211128; cv=none; b=IZMiD3q9ZYtR5S24qhQicyCxbdvHJ3NgibP3H6l/noSVfSRlShXCjJMsVbZ6ULJxAxzQqxgKwY32a7DIXBPbG2NbR6v0Jg0gyuDZPGmHAr5SM7mCpqDR35tQTa651HLT4wix7i2905EQc/1YM4zckWK6b628dtp38VQeI0oTV/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211128; c=relaxed/simple;
	bh=glmPlX/nB0Aj+USaq1ApTevVsFlk6Pt8iNm/68QDW80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvIbKPQP8KRF3sB4f8kco0YUupsMP5URNG/P9QX0V/G4qR/uCBo2XAiLzX/CH71ESTyUt1fPTMzY6s2Tir/DdDmKXRjl379NX3RIU0JfQY4WXR379lYCjZeySjU6Ga6xlDl8NYkJoXYf9SV2QiP7i52L0BUeAVdd6WNPl7BY8kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIUQaubm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIUQaubm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B11B1F000E9;
	Thu, 16 Jul 2026 14:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211127;
	bh=WdMA6yVO8jNzcaJQCijO8ikM/YPvEF2u4o+J7j89JFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iIUQaubmuDIlvVrteOlLj0ur25/HeB26HivaTYS48EOMbzcBPJ6WHBixr0kaDLe8U
	 TyAIgvMhnDywHEKLMv/Du67IBWMrPjtU936lNzzn+fJAnx7WHxiwKFmu+QiUVxir6j
	 E/4bozuA7pDy04BQp2/mLLOUGI+8Z0X0gCpcKcrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yichong Chen <chenyichong@uniontech.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.18 309/480] usbip: tools: support SuperSpeedPlus devices
Date: Thu, 16 Jul 2026 15:30:56 +0200
Message-ID: <20260716133051.504877749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


