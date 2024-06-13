Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4441C145B01;
	Thu, 13 Jun 2024 12:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280980; cv=none; b=HDx5vxZhWf02LkcEaspsT021XMDD4rz3VekErbGZ+P4rXkN4zjn14v+SApMesEyskOfXU9YwiTtFNkuDBQ8s50T8VhjorL9fkhMd1b+/vy2JzDmiX+2sISEyzk1hPjPVGYgFK/qr5li3LWaO4g/kfdaWHGMAcCfA4mhhyK3vbVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280980; c=relaxed/simple;
	bh=vHNFy+izGaVRypZOaLYiFe1bwmTwRDZEGDMtRp2/dmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+ybNlH/aBVXT2DDi48w0MqqfNgGQ9w9vCIGNPFMpMhNBeAg1r0/HeZmxftVKjX1j5Hlx1d8GnNnHPnlRhBy9ewL2At3RxDDZfbBBqnvARVby/3I05jycDqbDbB4pIFLgooLtOXegSWyudBiqSFijrnWcUG2yFYp0Kq7A9stiAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpsXuq7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpsXuq7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3241C2BBFC;
	Thu, 13 Jun 2024 12:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280980;
	bh=vHNFy+izGaVRypZOaLYiFe1bwmTwRDZEGDMtRp2/dmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpsXuq7/PFR2UFTsdFNmjtrGkFejwKN+Rin6LvkBgjBktRZKdcKZqKu5Qt1tgyyw0
	 YvWHhzI1rCG3OCVrrb3NdFQ0sAz2k2Z2Up/fNa73w6zfIjPPhtGUV8+NMMdIC1gmWe
	 Uck/jNnBm6thB//pL0H5g0vuDkRMLpyr9CCvNAIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com
Subject: [PATCH 5.10 068/317] wifi: ar5523: enable proper endpoint verification
Date: Thu, 13 Jun 2024 13:31:26 +0200
Message-ID: <20240613113250.180737316@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit e120b6388d7d88635d67dcae6483f39c37111850 ]

Syzkaller reports [1] hitting a warning about an endpoint in use
not having an expected type to it.

Fix the issue by checking for the existence of all proper
endpoints with their according types intact.

Sadly, this patch has not been tested on real hardware.

[1] Syzkaller report:
------------[ cut here ]------------
usb 1-1: BOGUS urb xfer, pipe 3 != type 1
WARNING: CPU: 0 PID: 3643 at drivers/usb/core/urb.c:504 usb_submit_urb+0xed6/0x1880 drivers/usb/core/urb.c:504
...
Call Trace:
 <TASK>
 ar5523_cmd+0x41b/0x780 drivers/net/wireless/ath/ar5523/ar5523.c:275
 ar5523_cmd_read drivers/net/wireless/ath/ar5523/ar5523.c:302 [inline]
 ar5523_host_available drivers/net/wireless/ath/ar5523/ar5523.c:1376 [inline]
 ar5523_probe+0x14b0/0x1d10 drivers/net/wireless/ath/ar5523/ar5523.c:1655
 usb_probe_interface+0x30f/0x7f0 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:560 [inline]
 really_probe+0x249/0xb90 drivers/base/dd.c:639
 __driver_probe_device+0x1df/0x4d0 drivers/base/dd.c:778
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:808
 __device_attach_driver+0x1d4/0x2e0 drivers/base/dd.c:936
 bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:427
 __device_attach+0x1e4/0x530 drivers/base/dd.c:1008
 bus_probe_device+0x1e8/0x2a0 drivers/base/bus.c:487
 device_add+0xbd9/0x1e90 drivers/base/core.c:3517
 usb_set_configuration+0x101d/0x1900 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0xbe/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd8/0x2c0 drivers/usb/core/driver.c:293
 call_driver_probe drivers/base/dd.c:560 [inline]
 really_probe+0x249/0xb90 drivers/base/dd.c:639
 __driver_probe_device+0x1df/0x4d0 drivers/base/dd.c:778
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:808
 __device_attach_driver+0x1d4/0x2e0 drivers/base/dd.c:936
 bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:427
 __device_attach+0x1e4/0x530 drivers/base/dd.c:1008
 bus_probe_device+0x1e8/0x2a0 drivers/base/bus.c:487
 device_add+0xbd9/0x1e90 drivers/base/core.c:3517
 usb_new_device.cold+0x685/0x10ad drivers/usb/core/hub.c:2573
 hub_port_connect drivers/usb/core/hub.c:5353 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5497 [inline]
 port_event drivers/usb/core/hub.c:5653 [inline]
 hub_event+0x26cb/0x45d0 drivers/usb/core/hub.c:5735
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

Reported-and-tested-by: syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com
Fixes: b7d572e1871d ("ar5523: Add new driver")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240408121425.29392-1-n.zhandarovich@fintech.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index efe38b2c1df73..71c2bf8817dc2 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1590,6 +1590,20 @@ static int ar5523_probe(struct usb_interface *intf,
 	struct ar5523 *ar;
 	int error = -ENOMEM;
 
+	static const u8 bulk_ep_addr[] = {
+		AR5523_CMD_TX_PIPE | USB_DIR_OUT,
+		AR5523_DATA_TX_PIPE | USB_DIR_OUT,
+		AR5523_CMD_RX_PIPE | USB_DIR_IN,
+		AR5523_DATA_RX_PIPE | USB_DIR_IN,
+		0};
+
+	if (!usb_check_bulk_endpoints(intf, bulk_ep_addr)) {
+		dev_err(&dev->dev,
+			"Could not find all expected endpoints\n");
+		error = -ENODEV;
+		goto out;
+	}
+
 	/*
 	 * Load firmware if the device requires it.  This will return
 	 * -ENXIO on success and we'll get called back afer the usb
-- 
2.43.0



