Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26773134AC;
	Mon, 12 Aug 2024 16:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479997; cv=none; b=VT/5PVDiM4TB2q2mGcVdMjB64QuiCMFasW4HvoeNt9yB56rSDSl7/5/iUZ1sk00FUoqDntZ+NNtWPapTHLcaI2vtNkAPmh2ntFHMfCbEG+BHJ6N6JT7yIUyeka4CpnuFaXpdsq3yYhMmN9CyKQA8sMsm7jOwcggRdPUoCtkHWtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479997; c=relaxed/simple;
	bh=3xdm+LS2lVbLxu7Cr3y3i/Dh3/Z0gbOZZk1w+TH4oJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quodTVxRGZJeinWWUW3uOF0Aun6MILo5Itlx4itt4D8AGCpLjKlNkLHeXhGkoLT1E/ufp5ueUwe6nzfkF92h6CaV71JTcREzAx2eNx7qKKL4NeFWFOHGK+nnpl1Mdx4d1O29sRjWj2FyXjDmT7h61ts/VgUcFBbNaQRogU2L6OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7YvzyjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7YvzyjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C527C32782;
	Mon, 12 Aug 2024 16:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479997;
	bh=3xdm+LS2lVbLxu7Cr3y3i/Dh3/Z0gbOZZk1w+TH4oJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y7YvzyjP8LHNCLrUcdZ7uIDaaRaVGAgOjf8I+vxlNInJJ/OseLXbY0xXay9rvln3+
	 A88DpNvQ0BnI0sjXbFSbsTxgh4QIW+L64WWk2Dd//n2iW8o3+d9K9L3p1sNrY11uEe
	 E73dxBvsCIseGrOKmYwVn5uysSSjH14TcX8uvkX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shichao Lai <shichaorai@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 065/263] wifi: rtlwifi: handle return value of usb init TX/RX
Date: Mon, 12 Aug 2024 18:01:06 +0200
Message-ID: <20240812160149.032637164@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 9c4fde42cce05719120cf892a44b76ff61d908c7 ]

Handle error code to cause failed to USB probe result from unexpected
USB EP number, otherwise when USB disconnect skb_dequeue() an uninitialized
skb list and cause warnings below.

usb 2-1: USB disconnect, device number 76
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 PID: 54060 Comm: kworker/0:1 Not tainted 6.9.0-rc7 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
Workqueue: usb_hub_wq hub_event
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x116/0x1b0 lib/dump_stack.c:114
 assign_lock_key kernel/locking/lockdep.c:976 [inline]
 register_lock_class+0xc18/0xfa0 kernel/locking/lockdep.c:1289
 __lock_acquire+0x108/0x3bc0 kernel/locking/lockdep.c:5014
 lock_acquire kernel/locking/lockdep.c:5754 [inline]
 lock_acquire+0x1b0/0x550 kernel/locking/lockdep.c:5719
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
 skb_dequeue+0x20/0x180 net/core/skbuff.c:3846
 rtl_usb_cleanup drivers/net/wireless/realtek/rtlwifi/usb.c:706 [inline]
 rtl_usb_deinit drivers/net/wireless/realtek/rtlwifi/usb.c:721 [inline]
 rtl_usb_disconnect+0x4a4/0x850 drivers/net/wireless/realtek/rtlwifi/usb.c:1051
 usb_unbind_interface+0x1e8/0x980 drivers/usb/core/driver.c:461
 device_remove drivers/base/dd.c:568 [inline]
 device_remove+0x122/0x170 drivers/base/dd.c:560
 __device_release_driver drivers/base/dd.c:1270 [inline]
 device_release_driver_internal+0x443/0x620 drivers/base/dd.c:1293
 bus_remove_device+0x22f/0x420 drivers/base/bus.c:574
 device_del+0x395/0x9f0 drivers/base/core.c:3909
 usb_disable_device+0x360/0x7b0 drivers/usb/core/message.c:1418
 usb_disconnect+0x2db/0x930 drivers/usb/core/hub.c:2305
 hub_port_connect drivers/usb/core/hub.c:5362 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5662 [inline]
 port_event drivers/usb/core/hub.c:5822 [inline]
 hub_event+0x1e39/0x4ce0 drivers/usb/core/hub.c:5904
 process_one_work+0x97b/0x1a90 kernel/workqueue.c:3267
 process_scheduled_works kernel/workqueue.c:3348 [inline]
 worker_thread+0x680/0xf00 kernel/workqueue.c:3429
 kthread+0x2c7/0x3b0 kernel/kthread.c:388
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Reported-by: Shichao Lai <shichaorai@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/CAEk6kZuuezkH1dVRJf3EAVZK-83=OpTz62qCugkpTkswj8JF6w@mail.gmail.com/T/#u
Tested-by: Shichao Lai <shichaorai@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/20240524003248.5952-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 34 +++++++++++++++++-----
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 2ea72d9e39577..4d2931e544278 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -23,6 +23,8 @@ MODULE_DESCRIPTION("USB basic driver for rtlwifi");
 
 #define MAX_USBCTRL_VENDORREQ_TIMES		10
 
+static void _rtl_usb_cleanup_tx(struct ieee80211_hw *hw);
+
 static void _usbctrl_vendorreq_sync(struct usb_device *udev, u8 reqtype,
 				   u16 value, void *pdata, u16 len)
 {
@@ -285,9 +287,23 @@ static int _rtl_usb_init(struct ieee80211_hw *hw)
 	}
 	/* usb endpoint mapping */
 	err = rtlpriv->cfg->usb_interface_cfg->usb_endpoint_mapping(hw);
-	rtlusb->usb_mq_to_hwq =  rtlpriv->cfg->usb_interface_cfg->usb_mq_to_hwq;
-	_rtl_usb_init_tx(hw);
-	_rtl_usb_init_rx(hw);
+	if (err)
+		return err;
+
+	rtlusb->usb_mq_to_hwq = rtlpriv->cfg->usb_interface_cfg->usb_mq_to_hwq;
+
+	err = _rtl_usb_init_tx(hw);
+	if (err)
+		return err;
+
+	err = _rtl_usb_init_rx(hw);
+	if (err)
+		goto err_out;
+
+	return 0;
+
+err_out:
+	_rtl_usb_cleanup_tx(hw);
 	return err;
 }
 
@@ -691,17 +707,13 @@ static int rtl_usb_start(struct ieee80211_hw *hw)
 }
 
 /*=======================  tx =========================================*/
-static void rtl_usb_cleanup(struct ieee80211_hw *hw)
+static void _rtl_usb_cleanup_tx(struct ieee80211_hw *hw)
 {
 	u32 i;
 	struct sk_buff *_skb;
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 	struct ieee80211_tx_info *txinfo;
 
-	/* clean up rx stuff. */
-	_rtl_usb_cleanup_rx(hw);
-
-	/* clean up tx stuff */
 	for (i = 0; i < RTL_USB_MAX_EP_NUM; i++) {
 		while ((_skb = skb_dequeue(&rtlusb->tx_skb_queue[i]))) {
 			rtlusb->usb_tx_cleanup(hw, _skb);
@@ -715,6 +727,12 @@ static void rtl_usb_cleanup(struct ieee80211_hw *hw)
 	usb_kill_anchored_urbs(&rtlusb->tx_submitted);
 }
 
+static void rtl_usb_cleanup(struct ieee80211_hw *hw)
+{
+	_rtl_usb_cleanup_rx(hw);
+	_rtl_usb_cleanup_tx(hw);
+}
+
 /* We may add some struct into struct rtl_usb later. Do deinit here.  */
 static void rtl_usb_deinit(struct ieee80211_hw *hw)
 {
-- 
2.43.0



