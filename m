Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5412473451;
	Wed,  7 May 2025 18:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643561; cv=none; b=MDI6riv3evg+mrylS1MYhlXK5dF6BtvJjnKezY2qi6Rif0+ZktO5BikIfJ/fkgd5ezLE0uRmPW2McRorLcb0OrPgaQdxZdV8Vocc4jneMSmpro29XLk/gquzOduDcCghaQMYATp5TmN/poXo/oAjNMcTedTxldC4kkUXTm3DXAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643561; c=relaxed/simple;
	bh=gDUhcn0fZg6iyEU1HsJL9TLwp+n1o3kjle1amVtkUZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5iuXXQBGgSAztuyy0G8U6sBtVCDhPM5OwgBDDxEfueOvrgVeWXfv5aWK6ozgk/ORIxJnDwnZ/hqmE/o1r712yXNKzT+RBz6doVEmcsE7vCj3tAAHPP1ENety+UI8uzKzT+RtnqM9R0oOsuEZhsb4B6MobpPwyYurEVg61Oa77U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5hp2DsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5hp2DsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D75C4CEE2;
	Wed,  7 May 2025 18:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643560;
	bh=gDUhcn0fZg6iyEU1HsJL9TLwp+n1o3kjle1amVtkUZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5hp2DsK8IvUay6nxDQP/omsJnIyoodeRCmlam8RAqp5zqcR5Z3RHszi3yqdCY2TR
	 yyV0hqdNQ5BOHxY7Tr18A4dl3IS94uX1N2NZ+aRdTN7cWt/ktrcrs6QhGph1lLypoi
	 1k6qz8kwLQ84dJqnZw6TUinaBK4u66+c9LRu28pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7d4f142f6c288de8abfe@syzkaller.appspotmail.com,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 42/97] wifi: plfxlc: Remove erroneous assert in plfxlc_mac_release
Date: Wed,  7 May 2025 20:39:17 +0200
Message-ID: <20250507183808.684358089@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit 0fb15ae3b0a9221be01715dac0335647c79f3362 ]

plfxlc_mac_release() asserts that mac->lock is held. This assertion is
incorrect, because even if it was possible, it would not be the valid
behaviour. The function is used when probe fails or after the device is
disconnected. In both cases mac->lock can not be held as the driver is
not working with the device at the moment. All functions that use mac->lock
unlock it just after it was held. There is also no need to hold mac->lock
for plfxlc_mac_release() itself, as mac data is not affected, except for
mac->flags, which is modified atomically.

This bug leads to the following warning:
================================================================
WARNING: CPU: 0 PID: 127 at drivers/net/wireless/purelifi/plfxlc/mac.c:106 plfxlc_mac_release+0x7d/0xa0
Modules linked in:
CPU: 0 PID: 127 Comm: kworker/0:2 Not tainted 6.1.124-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: usb_hub_wq hub_event
RIP: 0010:plfxlc_mac_release+0x7d/0xa0 drivers/net/wireless/purelifi/plfxlc/mac.c:106
Call Trace:
 <TASK>
 probe+0x941/0xbd0 drivers/net/wireless/purelifi/plfxlc/usb.c:694
 usb_probe_interface+0x5c0/0xaf0 drivers/usb/core/driver.c:396
 really_probe+0x2ab/0xcb0 drivers/base/dd.c:639
 __driver_probe_device+0x1a2/0x3d0 drivers/base/dd.c:785
 driver_probe_device+0x50/0x420 drivers/base/dd.c:815
 __device_attach_driver+0x2cf/0x510 drivers/base/dd.c:943
 bus_for_each_drv+0x183/0x200 drivers/base/bus.c:429
 __device_attach+0x359/0x570 drivers/base/dd.c:1015
 bus_probe_device+0xba/0x1e0 drivers/base/bus.c:489
 device_add+0xb48/0xfd0 drivers/base/core.c:3696
 usb_set_configuration+0x19dd/0x2020 drivers/usb/core/message.c:2165
 usb_generic_driver_probe+0x84/0x140 drivers/usb/core/generic.c:238
 usb_probe_device+0x130/0x260 drivers/usb/core/driver.c:293
 really_probe+0x2ab/0xcb0 drivers/base/dd.c:639
 __driver_probe_device+0x1a2/0x3d0 drivers/base/dd.c:785
 driver_probe_device+0x50/0x420 drivers/base/dd.c:815
 __device_attach_driver+0x2cf/0x510 drivers/base/dd.c:943
 bus_for_each_drv+0x183/0x200 drivers/base/bus.c:429
 __device_attach+0x359/0x570 drivers/base/dd.c:1015
 bus_probe_device+0xba/0x1e0 drivers/base/bus.c:489
 device_add+0xb48/0xfd0 drivers/base/core.c:3696
 usb_new_device+0xbdd/0x18f0 drivers/usb/core/hub.c:2620
 hub_port_connect drivers/usb/core/hub.c:5477 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5617 [inline]
 port_event drivers/usb/core/hub.c:5773 [inline]
 hub_event+0x2efe/0x5730 drivers/usb/core/hub.c:5855
 process_one_work+0x8a9/0x11d0 kernel/workqueue.c:2292
 worker_thread+0xa47/0x1200 kernel/workqueue.c:2439
 kthread+0x28d/0x320 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
================================================================

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 68d57a07bfe5 ("wireless: add plfxlc driver for pureLiFi X, XL, XC devices")
Reported-by: syzbot+7d4f142f6c288de8abfe@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7d4f142f6c288de8abfe
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Link: https://patch.msgid.link/20250321185226.71-2-m.masimov@mt-integration.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/purelifi/plfxlc/mac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/purelifi/plfxlc/mac.c b/drivers/net/wireless/purelifi/plfxlc/mac.c
index 87a4ff888ddd4..70d6f5244e5e4 100644
--- a/drivers/net/wireless/purelifi/plfxlc/mac.c
+++ b/drivers/net/wireless/purelifi/plfxlc/mac.c
@@ -103,7 +103,6 @@ int plfxlc_mac_init_hw(struct ieee80211_hw *hw)
 void plfxlc_mac_release(struct plfxlc_mac *mac)
 {
 	plfxlc_chip_release(&mac->chip);
-	lockdep_assert_held(&mac->lock);
 }
 
 int plfxlc_op_start(struct ieee80211_hw *hw)
-- 
2.39.5



