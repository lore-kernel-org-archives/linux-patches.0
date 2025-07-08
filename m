Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735012DEA94;
	Tue,  8 Jul 2025 16:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993478; cv=none; b=hMdYEQMx4F6D1GOuvftYyB+Nqo/k1cJiG6i59BWMDrUAeWExncL1VGHws5zAR+9ZDov9PasEYthRom56FDok/+M5FbjNM+EuoQ3BrtcAJPWausl24CG9g6BrlZ1GKxg6gXcEZE9FBIYZxhtZFVKwp5lof8yRVkj7G1vIQ/hl/fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993478; c=relaxed/simple;
	bh=khkP0v3psbZuK9HilpyslOTlsLH+Cfk5xXplF8ewg9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJIpL3oUgBY217meDNmtUJSFZSJOgA60EjAf0k4glipQOovDU/rK8fJGqv7+u+kh9Wbnwl0hmbu1j9pnKTExB5WqA36eFNVR7ocWg1Hq1DSBhaHXWt56svtVQW4BYeVXJhs8ebcaPxHI+fF98B5PBr8f5GuLAJ5FgDTa7fVdBU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbwFobst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbwFobst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C33C4CEED;
	Tue,  8 Jul 2025 16:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993478;
	bh=khkP0v3psbZuK9HilpyslOTlsLH+Cfk5xXplF8ewg9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbwFobstdPEnTghTdcKGotpNA3BPNjm8kNXhJSFhlRvyPU4BWabWSWCExSLM1BuOE
	 h4TWSiI9RIeL4sTrAsDDNCGXGEB/F2a1IWl7pAL9SPsa7HB6jpQ2xOcVnYn1gGV7HK
	 B3/phqTleGXR1IE7o+skY10PhjIm5sWoLHEDFwUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 088/178] net: usb: lan78xx: fix WARN in __netif_napi_del_locked on disconnect
Date: Tue,  8 Jul 2025 18:22:05 +0200
Message-ID: <20250708162238.972351382@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 6c7ffc9af7186ed79403a3ffee9a1e5199fc7450 ]

Remove redundant netif_napi_del() call from disconnect path.

A WARN may be triggered in __netif_napi_del_locked() during USB device
disconnect:

  WARNING: CPU: 0 PID: 11 at net/core/dev.c:7417 __netif_napi_del_locked+0x2b4/0x350

This happens because netif_napi_del() is called in the disconnect path while
NAPI is still enabled. However, it is not necessary to call netif_napi_del()
explicitly, since unregister_netdev() will handle NAPI teardown automatically
and safely. Removing the redundant call avoids triggering the warning.

Full trace:
 lan78xx 1-1:1.0 enu1: Failed to read register index 0x000000c4. ret = -ENODEV
 lan78xx 1-1:1.0 enu1: Failed to set MAC down with error -ENODEV
 lan78xx 1-1:1.0 enu1: Link is Down
 lan78xx 1-1:1.0 enu1: Failed to read register index 0x00000120. ret = -ENODEV
 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 11 at net/core/dev.c:7417 __netif_napi_del_locked+0x2b4/0x350
 Modules linked in: flexcan can_dev fuse
 CPU: 0 UID: 0 PID: 11 Comm: kworker/0:1 Not tainted 6.16.0-rc2-00624-ge926949dab03 #9 PREEMPT
 Hardware name: SKOV IMX8MP CPU revC - bd500 (DT)
 Workqueue: usb_hub_wq hub_event
 pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : __netif_napi_del_locked+0x2b4/0x350
 lr : __netif_napi_del_locked+0x7c/0x350
 sp : ffffffc085b673c0
 x29: ffffffc085b673c0 x28: ffffff800b7f2000 x27: ffffff800b7f20d8
 x26: ffffff80110bcf58 x25: ffffff80110bd978 x24: 1ffffff0022179eb
 x23: ffffff80110bc000 x22: ffffff800b7f5000 x21: ffffff80110bc000
 x20: ffffff80110bcf38 x19: ffffff80110bcf28 x18: dfffffc000000000
 x17: ffffffc081578940 x16: ffffffc08284cee0 x15: 0000000000000028
 x14: 0000000000000006 x13: 0000000000040000 x12: ffffffb0022179e8
 x11: 1ffffff0022179e7 x10: ffffffb0022179e7 x9 : dfffffc000000000
 x8 : 0000004ffdde8619 x7 : ffffff80110bcf3f x6 : 0000000000000001
 x5 : ffffff80110bcf38 x4 : ffffff80110bcf38 x3 : 0000000000000000
 x2 : 0000000000000000 x1 : 1ffffff0022179e7 x0 : 0000000000000000
 Call trace:
  __netif_napi_del_locked+0x2b4/0x350 (P)
  lan78xx_disconnect+0xf4/0x360
  usb_unbind_interface+0x158/0x718
  device_remove+0x100/0x150
  device_release_driver_internal+0x308/0x478
  device_release_driver+0x1c/0x30
  bus_remove_device+0x1a8/0x368
  device_del+0x2e0/0x7b0
  usb_disable_device+0x244/0x540
  usb_disconnect+0x220/0x758
  hub_event+0x105c/0x35e0
  process_one_work+0x760/0x17b0
  worker_thread+0x768/0xce8
  kthread+0x3bc/0x690
  ret_from_fork+0x10/0x20
 irq event stamp: 211604
 hardirqs last  enabled at (211603): [<ffffffc0828cc9ec>] _raw_spin_unlock_irqrestore+0x84/0x98
 hardirqs last disabled at (211604): [<ffffffc0828a9a84>] el1_dbg+0x24/0x80
 softirqs last  enabled at (211296): [<ffffffc080095f10>] handle_softirqs+0x820/0xbc8
 softirqs last disabled at (210993): [<ffffffc080010288>] __do_softirq+0x18/0x20
 ---[ end trace 0000000000000000 ]---
 lan78xx 1-1:1.0 enu1: failed to kill vid 0081/0

Fixes: ec4c7e12396b ("lan78xx: Introduce NAPI polling support")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20250627051346.276029-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index e4f1663b62047..5f014b8626853 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -4344,8 +4344,6 @@ static void lan78xx_disconnect(struct usb_interface *intf)
 	if (!dev)
 		return;
 
-	netif_napi_del(&dev->napi);
-
 	udev = interface_to_usbdev(intf);
 	net = dev->net;
 
-- 
2.39.5



