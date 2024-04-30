Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DEA12B176;
	Tue, 30 Apr 2024 11:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474882; cv=none; b=N5oHb92McmxbnDP6UdAX867apYN0TCDX5gOsPTiaXrDF6dvJS2julxSLLbM+Rgi+lkqGKTUi/WSn+JOmx1963DA6RnlvSPhJgniE3qTZ3/RdnKkTq6+m+qrcnzXOWP5GrSSC+mXQPOd/gbflNsBYKHCIXnwdbawJ7Fums2kTbu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474882; c=relaxed/simple;
	bh=NEK8bNDOc6QAzLlt818HIJ2CZJ2xMkdixJz0Du1PXyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/701yTw2Bp42zC9uKpERFof/N1NT25xS1W2cqGjPFG2mQfiYX1P0IXLzSRwK7Wu5/IZswY9JEtW3OJRjnr5sTQvwSxuqFjwj9ID+ZUDI/HddJ4xvCYtV/GD3iwu0SPDB68mu+6apSwqxRVlbwC8g/jV0bIdG127/Q+nV6P+e1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pF9SOdvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pF9SOdvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAC0C4AF19;
	Tue, 30 Apr 2024 11:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474882;
	bh=NEK8bNDOc6QAzLlt818HIJ2CZJ2xMkdixJz0Du1PXyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pF9SOdvggBAwC7Qj7GmCmfHnTG2T7HhPgtptdSGR3oaPONtmVxAMp7a+xhiqxG8Us
	 476khBSbaHVM6+xGhyUH8+Qkb7TWA9q24/y0EVZv0czfRBgfS1owrC5e4JcNH3e3vg
	 8EuWpnwNB/DqdYrZH/BFjAHkPUV/HwaqKIJIUvFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 064/138] usb: Disable USB3 LPM at shutdown
Date: Tue, 30 Apr 2024 12:39:09 +0200
Message-ID: <20240430103051.308335660@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit d920a2ed8620be04a3301e1a9c2b7cc1de65f19d upstream.

SanDisks USB3 storage may disapper after system reboot:

usb usb2-port3: link state change
xhci_hcd 0000:00:14.0: clear port3 link state change, portsc: 0x2c0
usb usb2-port3: do warm reset, port only
xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping usb2 port polling
xhci_hcd 0000:00:14.0: Get port status 2-3 read: 0x2b0, return 0x2b0
usb usb2-port3: not warm reset yet, waiting 50ms
xhci_hcd 0000:00:14.0: Get port status 2-3 read: 0x2f0, return 0x2f0
usb usb2-port3: not warm reset yet, waiting 200ms
...
xhci_hcd 0000:00:14.0: Get port status 2-3 read: 0x6802c0, return 0x7002c0
usb usb2-port3: not warm reset yet, waiting 200ms
xhci_hcd 0000:00:14.0: clear port3 reset change, portsc: 0x4802c0
xhci_hcd 0000:00:14.0: clear port3 warm(BH) reset change, portsc: 0x4002c0
xhci_hcd 0000:00:14.0: clear port3 link state change, portsc: 0x2c0
xhci_hcd 0000:00:14.0: Get port status 2-3 read: 0x2c0, return 0x2c0
usb usb2-port3: not enabled, trying warm reset again...

This is due to the USB device still cause port change event after xHCI is
shuted down:

xhci_hcd 0000:38:00.0: // Setting command ring address to 0xffffe001
xhci_hcd 0000:38:00.0: xhci_resume: starting usb3 port polling.
xhci_hcd 0000:38:00.0: xhci_hub_status_data: stopping usb4 port polling
xhci_hcd 0000:38:00.0: xhci_hub_status_data: stopping usb3 port polling
xhci_hcd 0000:38:00.0: hcd_pci_runtime_resume: 0
xhci_hcd 0000:38:00.0: xhci_shutdown: stopping usb3 port polling.
xhci_hcd 0000:38:00.0: // Halt the HC
xhci_hcd 0000:38:00.0: xhci_shutdown completed - status = 1
xhci_hcd 0000:00:14.0: xhci_shutdown: stopping usb1 port polling.
xhci_hcd 0000:00:14.0: // Halt the HC
xhci_hcd 0000:00:14.0: xhci_shutdown completed - status = 1
xhci_hcd 0000:00:14.0: Get port status 2-3 read: 0x1203, return 0x203
xhci_hcd 0000:00:14.0: set port reset, actual port 2-3 status  = 0x1311
xhci_hcd 0000:00:14.0: Get port status 2-3 read: 0x201203, return 0x100203
xhci_hcd 0000:00:14.0: clear port3 reset change, portsc: 0x1203
xhci_hcd 0000:00:14.0: clear port3 warm(BH) reset change, portsc: 0x1203
xhci_hcd 0000:00:14.0: clear port3 link state change, portsc: 0x1203
xhci_hcd 0000:00:14.0: clear port3 connect change, portsc: 0x1203
xhci_hcd 0000:00:14.0: Get port status 2-3 read: 0x1203, return 0x203
usb 2-3: device not accepting address 2, error -108
xhci_hcd 0000:00:14.0: xHCI dying or halted, can't queue_command
xhci_hcd 0000:00:14.0: Set port 2-3 link state, portsc: 0x1203, write 0x11261
xhci_hcd 0000:00:14.0: Get port status 2-3 read: 0x1263, return 0x263
xhci_hcd 0000:00:14.0: set port reset, actual port 2-3 status  = 0x1271
xhci_hcd 0000:00:14.0: Get port status 2-3 read: 0x12b1, return 0x2b1
usb usb2-port3: not reset yet, waiting 60ms
ACPI: PM: Preparing to enter system sleep state S5
xhci_hcd 0000:00:14.0: Get port status 2-3 read: 0x12f1, return 0x2f1
usb usb2-port3: not reset yet, waiting 200ms
reboot: Restarting system

The port change event is caused by LPM transition, so disabling LPM at shutdown
to make sure the device is in U0 for warmboot.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240305065140.66801-1-kai.heng.feng@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/port.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/port.c
+++ b/drivers/usb/core/port.c
@@ -295,8 +295,10 @@ static void usb_port_shutdown(struct dev
 {
 	struct usb_port *port_dev = to_usb_port(dev);
 
-	if (port_dev->child)
+	if (port_dev->child) {
 		usb_disable_usb2_hardware_lpm(port_dev->child);
+		usb_unlocked_disable_lpm(port_dev->child);
+	}
 }
 
 static const struct dev_pm_ops usb_port_pm_ops = {


