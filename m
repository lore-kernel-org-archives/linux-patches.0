Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E7D22F1B
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g53KUr+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48790C433C7;
	Mon,  6 Nov 2023 13:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277162;
	bh=CsOgxSurSfocJM1Yyn5fNW6S7VOxvKb/Bqraa7ANh9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g53KUr+z2FBqUkjeukZbma1np/L1H6Fgj2oHexRXdIhHQRTI7DBYnMGpuywtdJYXU
	 GRd3cYu927oUNgpkbKiNXqTfn0DWidSJpyh8tv9fLhN65pVzqNy869YazWVSFtgxUg
	 gdBqoWgXhCbfQFm8tkx0U6dDJec6fWQscjuu0E90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+c74c24b43c9ae534f0e0@syzkaller.appspotmail.com,
	syzbot+2c97a98a5ba9ea9c23bd@syzkaller.appspotmail.com
Subject: [PATCH 5.15 030/128] net: usb: smsc95xx: Fix uninit-value access in smsc95xx_read_reg
Date: Mon,  6 Nov 2023 14:03:10 +0100
Message-ID: <20231106130310.484105314@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 51a32e828109b4a209efde44505baa356b37a4ce ]

syzbot reported the following uninit-value access issue [1]:

smsc95xx 1-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x00000030: -32
smsc95xx 1-1:0.0 (unnamed net_device) (uninitialized): Error reading E2P_CMD
=====================================================
BUG: KMSAN: uninit-value in smsc95xx_reset+0x409/0x25f0 drivers/net/usb/smsc95xx.c:896
 smsc95xx_reset+0x409/0x25f0 drivers/net/usb/smsc95xx.c:896
 smsc95xx_bind+0x9bc/0x22e0 drivers/net/usb/smsc95xx.c:1131
 usbnet_probe+0x100b/0x4060 drivers/net/usb/usbnet.c:1750
 usb_probe_interface+0xc75/0x1210 drivers/usb/core/driver.c:396
 really_probe+0x506/0xf40 drivers/base/dd.c:658
 __driver_probe_device+0x2a7/0x5d0 drivers/base/dd.c:800
 driver_probe_device+0x72/0x7b0 drivers/base/dd.c:830
 __device_attach_driver+0x55a/0x8f0 drivers/base/dd.c:958
 bus_for_each_drv+0x3ff/0x620 drivers/base/bus.c:457
 __device_attach+0x3bd/0x640 drivers/base/dd.c:1030
 device_initial_probe+0x32/0x40 drivers/base/dd.c:1079
 bus_probe_device+0x3d8/0x5a0 drivers/base/bus.c:532
 device_add+0x16ae/0x1f20 drivers/base/core.c:3622
 usb_set_configuration+0x31c9/0x38c0 drivers/usb/core/message.c:2207
 usb_generic_driver_probe+0x109/0x2a0 drivers/usb/core/generic.c:238
 usb_probe_device+0x290/0x4a0 drivers/usb/core/driver.c:293
 really_probe+0x506/0xf40 drivers/base/dd.c:658
 __driver_probe_device+0x2a7/0x5d0 drivers/base/dd.c:800
 driver_probe_device+0x72/0x7b0 drivers/base/dd.c:830
 __device_attach_driver+0x55a/0x8f0 drivers/base/dd.c:958
 bus_for_each_drv+0x3ff/0x620 drivers/base/bus.c:457
 __device_attach+0x3bd/0x640 drivers/base/dd.c:1030
 device_initial_probe+0x32/0x40 drivers/base/dd.c:1079
 bus_probe_device+0x3d8/0x5a0 drivers/base/bus.c:532
 device_add+0x16ae/0x1f20 drivers/base/core.c:3622
 usb_new_device+0x15f6/0x22f0 drivers/usb/core/hub.c:2589
 hub_port_connect drivers/usb/core/hub.c:5440 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5580 [inline]
 port_event drivers/usb/core/hub.c:5740 [inline]
 hub_event+0x53bc/0x7290 drivers/usb/core/hub.c:5822
 process_one_work kernel/workqueue.c:2630 [inline]
 process_scheduled_works+0x104e/0x1e70 kernel/workqueue.c:2703
 worker_thread+0xf45/0x1490 kernel/workqueue.c:2784
 kthread+0x3e8/0x540 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

Local variable buf.i225 created at:
 smsc95xx_read_reg drivers/net/usb/smsc95xx.c:90 [inline]
 smsc95xx_reset+0x203/0x25f0 drivers/net/usb/smsc95xx.c:892
 smsc95xx_bind+0x9bc/0x22e0 drivers/net/usb/smsc95xx.c:1131

CPU: 1 PID: 773 Comm: kworker/1:2 Not tainted 6.6.0-rc1-syzkaller-00125-ge42bebf6db29 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/04/2023
Workqueue: usb_hub_wq hub_event
=====================================================

Similar to e9c65989920f ("net: usb: smsc75xx: Fix uninit-value access in
__smsc75xx_read_reg"), this issue is caused because usbnet_read_cmd() reads
less bytes than requested (zero byte in the reproducer). In this case,
'buf' is not properly filled.

This patch fixes the issue by returning -ENODATA if usbnet_read_cmd() reads
less bytes than requested.

sysbot reported similar uninit-value access issue [2]. The root cause is
the same as mentioned above, and this patch addresses it as well.

Fixes: 2f7ca802bdae ("net: Add SMSC LAN9500 USB2.0 10/100 ethernet adapter driver")
Reported-and-tested-by: syzbot+c74c24b43c9ae534f0e0@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+2c97a98a5ba9ea9c23bd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c74c24b43c9ae534f0e0 [1]
Closes: https://syzkaller.appspot.com/bug?extid=2c97a98a5ba9ea9c23bd [2]
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc95xx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 16a6cdf025151..5f962f58ff496 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -84,7 +84,9 @@ static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
 	ret = fn(dev, USB_VENDOR_REQUEST_READ_REGISTER, USB_DIR_IN
 		 | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		 0, index, &buf, 4);
-	if (ret < 0) {
+	if (ret < 4) {
+		ret = ret < 0 ? ret : -ENODATA;
+
 		if (ret != -ENODEV)
 			netdev_warn(dev->net, "Failed to read reg index 0x%08x: %d\n",
 				    index, ret);
-- 
2.42.0



