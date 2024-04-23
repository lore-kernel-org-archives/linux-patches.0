Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD1714885A;
	Tue, 23 Apr 2024 21:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908810; cv=none; b=XG3cir5yHARxmkX1Xf5C0LOTf77MKoggGzRFw8+1oD/1yYgBtO+pYE4H1LCHnoQbVe2CUxR7WjVLDvD+bwIP8HrzaYdS/kc7PDyOlk8LXtHARjbCNUeuHvUPoZSaWl4ovrbErf2OFreqP5/XJoobEGuYTnMiyydm5/0Bbqwrj10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908810; c=relaxed/simple;
	bh=vq7fsIfQNn4x9er7yC4C7YRA7Jbzbm+wiDl7ME2JlKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRRKtio86zEdGdU+uh/ejzGvh6y0TSGJBlKTCi+Z0z/Uhn8QFI8Iyf8pKO36p8GfjiAbBC9WMw+XPVLGpjM24s6Oq8wim8jD1hKW4JwX07ssDMGZ7FHRx+N7+if48JEiBn0AQ/j2nTT6B5cNUVvITdemCu7X30WTyLwBYZNyFlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xh/kn9A1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xh/kn9A1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFA8C32783;
	Tue, 23 Apr 2024 21:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908810;
	bh=vq7fsIfQNn4x9er7yC4C7YRA7Jbzbm+wiDl7ME2JlKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xh/kn9A1j3J5b9UehqlqK0L7lVVFdh9xGv52Tam79q/RiL7FLitg/rcX5ma1bKlnr
	 eGcF33eFPyQ0nnCUN68+gG49O7WjJCmTeCldLDau1X0T2/lFFreuOUZt0P/qVG9Qrs
	 J/naAi4M0stvNRS5XXrYaM1rhQQfiBB8YR8SGd/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 54/71] usb: Disable USB3 LPM at shutdown
Date: Tue, 23 Apr 2024 14:40:07 -0700
Message-ID: <20240423213846.044156444@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


