Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F3A34B1A6;
	Tue, 21 Jul 2026 22:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673313; cv=none; b=JHdYlVyR1whhomc0D3PWV/hrvkH51hpyFaMqYBbNRbyFH0QEsFDIBRauACPemNuSwiiHEMbAg1ulT07tQs2spD/qspon4AFIKusqMV/T2ACffUsG9hgBq963NBxohiqXTagKusk59YI3mlRhsH9WlRwUZtD0Qc7Mly2AeTvMZXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673313; c=relaxed/simple;
	bh=i/akaA0MR9HyvyjefezNriH82Xsc/Radq8CgoRPU7VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xgd4kItDszqXUJw6zOjoLr2dQf6gRfFkKkxV25OFpp2dYS8toRYbtDeyl44+5g9XPPLMDHGcmHRrla50s6zy6zqhwB/KhvXn80FAZ5sXGoIrXRCNsmwuSQhZJR4Stu0SCchi3o0D5QPI8ewwSiquXOD+UoQ3J0E/JZE+QsL6Rzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtChTxKq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtChTxKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936B91F000E9;
	Tue, 21 Jul 2026 22:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673312;
	bh=Xdp9RK0YWjtVD2EjtZ8TnkI96r4y0xUGMeUk0bRQbX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtChTxKqRuLXM7Jlp5+2lhFkhW6YDTZsU9CullXdh3cf8EDJbOVNPRvK15NOffBiC
	 8ZyWEqjX4p1O4dmdiymXJcNc5VfoDNzTOvfUQ+r5oSVF7m4YOgiF65GG2WNBLXinl5
	 fBJYTd1b1gB1kz+22zzG00D1F5j88etxG3/Kb8iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yichong Chen <chenyichong@uniontech.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.10 114/699] usbip: tools: support SuperSpeedPlus devices
Date: Tue, 21 Jul 2026 17:17:53 +0200
Message-ID: <20260721152358.277113585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


