Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211FB3D2FF0;
	Thu, 16 Jul 2026 13:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209806; cv=none; b=YP0C00Gxa0Bxa4KtOKzFbG9frqsHed2nTt0xsGtrEOhCjSznu/4kqCvsCiYd694lxOgPRp4+tzdtpmwV+VT/cNB/S6a4+5F2tI/msrCA/2aArv5ioa1yr1oMBV9Pi3BrqTP7N4xGzxU/SJChag/fD5aIrzBIABOi5uWtxWTpeUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209806; c=relaxed/simple;
	bh=GQ351JHYiHiLJHRqPj48UVcDuKfJrxEbeGmPZAi1STo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+R3dToxwsJtikOAEKhRSgY8kAMpW8hDr1Nl8JvA/epH7LEt++sFfQE85xssmmO3DMOgixEmzu8tLSpOAyI5xZjw08Zzq232DJIXBq9NPvY1zz2A0u1LWhc0dd4lsujwLYjbLvx1xS4dXekrfvhvqVCfSTRTwlo07yifCIDJMy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adDRmBbL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adDRmBbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8031F000E9;
	Thu, 16 Jul 2026 13:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209804;
	bh=ICQfL467Fnr/zd4qsgwHsomu1mO4f2+VEa9c0WT+djI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adDRmBbLDW7Y0e3aF8pchnbLll85OeRpOq76sjaNhwV8/v04TQiBuSrirxQ8v/2Xo
	 rua0KPlPP8mkCCjQPAf/cdd8IYgATyFmef6hSj5qzg2syfo6olyZa8cRriYvEh4qPT
	 dgK5JU/tr5qXGlHjLP7+xo23mzvl11gJpU8FKkks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yichong Chen <chenyichong@uniontech.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 7.1 325/518] usbip: tools: support SuperSpeedPlus devices
Date: Thu, 16 Jul 2026 15:29:53 +0200
Message-ID: <20260716133054.927921187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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


