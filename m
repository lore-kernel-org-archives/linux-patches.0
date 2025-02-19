Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409801E22FC;
	Wed, 19 Feb 2025 08:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954639; cv=none; b=hXSkifsdqCS9j7OcDm3xc4oelwSlXOZxop7CNA7LXv6lBEfCvp9ZKs7h/kPhI7b/fydhko6Aa4ACEZc1SW+hVdaHnmE+vHo+BJISd4ZhN1BWiutdA+QBMbq8U6qjlVI3lLggteNJKXU2Y0i7Cj+zLNRegKQF0HMgkBLxHLHzoaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954639; c=relaxed/simple;
	bh=KoPj4nlCiUx49EE7Y1FOVItVRkTxo+MrzqRHRCKi1Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTfAGRF2HFVc9CVc/7Z/QOio36u4VwtY7QQWKJdvYLqD+k/ppOQrSmWyl2uqjTzn9QdQSJ0vGpUqInBaNP4IVDPaRJ39VK5KWd8OEosMbqZ0Tz03iqX8/5hK/HJb3lAZBlyozioqQ+MTsfKquMcK95PrdavHdCvI1/8Y6ilUpJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwCb3wEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwCb3wEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25211C4CEE6;
	Wed, 19 Feb 2025 08:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954638;
	bh=KoPj4nlCiUx49EE7Y1FOVItVRkTxo+MrzqRHRCKi1Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwCb3wEcGTmTcfd8LHV+f7y7ITpd+PS2zefWoIvlS/lwDnNn1cyDxAzX8XJjOw5Zx
	 g035bFd02cTz+kVZta5jJCrJzRkJ2TYAcNz9G0O/MnoKddGpOL+89wwkK38IDLlpgR
	 H6JRgRP/X/ufJryi43U/F02UceOt6j8bH/+te86Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+85ff1051228a04613a32@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 266/274] net: destroy dev->lock later in free_netdev()
Date: Wed, 19 Feb 2025 09:28:40 +0100
Message-ID: <20250219082619.997315356@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit bff406bc042408c021e41a439698a346119c2f11 upstream.

syzbot complained that free_netdev() was calling netif_napi_del()
after dev->lock mutex has been destroyed.

This fires a warning for CONFIG_DEBUG_MUTEXES=y builds.

Move mutex_destroy(&dev->lock) near the end of free_netdev().

[1]
DEBUG_LOCKS_WARN_ON(lock->magic != lock)
 WARNING: CPU: 0 PID: 5971 at kernel/locking/mutex.c:564 __mutex_lock_common kernel/locking/mutex.c:564 [inline]
 WARNING: CPU: 0 PID: 5971 at kernel/locking/mutex.c:564 __mutex_lock+0xdac/0xee0 kernel/locking/mutex.c:735
Modules linked in:
CPU: 0 UID: 0 PID: 5971 Comm: syz-executor Not tainted 6.13.0-rc7-syzkaller-01131-g8d20dcda404d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
 RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:564 [inline]
 RIP: 0010:__mutex_lock+0xdac/0xee0 kernel/locking/mutex.c:735
Code: 0f b6 04 38 84 c0 0f 85 1a 01 00 00 83 3d 6f 40 4c 04 00 75 19 90 48 c7 c7 60 84 0a 8c 48 c7 c6 00 85 0a 8c e8 f5 dc 91 f5 90 <0f> 0b 90 90 90 e9 c7 f3 ff ff 90 0f 0b 90 e9 29 f8 ff ff 90 0f 0b
RSP: 0018:ffffc90003317580 EFLAGS: 00010246
RAX: ee0f97edaf7b7d00 RBX: ffff8880299f8cb0 RCX: ffff8880323c9e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003317710 R08: ffffffff81602ac2 R09: 1ffff110170c519a
R10: dffffc0000000000 R11: ffffed10170c519b R12: 0000000000000000
R13: 0000000000000000 R14: 1ffff92000662ec4 R15: dffffc0000000000
FS:  000055557a046500(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd581d46ff8 CR3: 000000006f870000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
  netdev_lock include/linux/netdevice.h:2691 [inline]
  __netif_napi_del include/linux/netdevice.h:2829 [inline]
  netif_napi_del include/linux/netdevice.h:2848 [inline]
  free_netdev+0x2d9/0x610 net/core/dev.c:11621
  netdev_run_todo+0xf21/0x10d0 net/core/dev.c:11189
  nsim_destroy+0x3c3/0x620 drivers/net/netdevsim/netdev.c:1028
  __nsim_dev_port_del+0x14b/0x1b0 drivers/net/netdevsim/dev.c:1428
  nsim_dev_port_del_all drivers/net/netdevsim/dev.c:1440 [inline]
  nsim_dev_reload_destroy+0x28a/0x490 drivers/net/netdevsim/dev.c:1661
  nsim_drv_remove+0x58/0x160 drivers/net/netdevsim/dev.c:1676
  device_remove drivers/base/dd.c:567 [inline]

Fixes: 1b23cdbd2bbc ("net: protect netdev->napi_list with netdev_lock()")
Reported-by: syzbot+85ff1051228a04613a32@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/678add43.050a0220.303755.0016.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250117224626.1427577-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11403,8 +11403,6 @@ void free_netdev(struct net_device *dev)
 		return;
 	}
 
-	mutex_destroy(&dev->lock);
-
 	kfree(dev->ethtool);
 	netif_free_tx_queues(dev);
 	netif_free_rx_queues(dev);
@@ -11431,6 +11429,8 @@ void free_netdev(struct net_device *dev)
 
 	netdev_free_phy_link_topology(dev);
 
+	mutex_destroy(&dev->lock);
+
 	/*  Compatibility with error handling in drivers */
 	if (dev->reg_state == NETREG_UNINITIALIZED ||
 	    dev->reg_state == NETREG_DUMMY) {


