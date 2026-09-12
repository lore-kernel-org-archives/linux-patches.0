Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3A823A562;
	Sat, 12 Sep 2026 16:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232354; cv=none; b=bgcgPi49k4L3IUgmM6SuUR3EWTqNyiklULSRENQqId8x8xyUlcSbyYRvu2h6y3+SUw3IC0/2XFOltAaA+DY8Drq5OfyBDMCKtAtyRW24iQT8Pb91qQSM+IYmKCW07yLQH5oT4zW0LczkorUE5UUj1ePAs9Khh3WXjxWDtW5uSVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232354; c=relaxed/simple;
	bh=2yzXyMltqOa1YNyPrwdMccSlkcAeIfCY1pQ/IIWm1Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWv01gv55At/x8VI6yD1+yHNQ0+rNudbl/yqElBfnCN8l2WKUzBFBEGKvT6BC8fn2TJtNwVDzaSTEfBOPb4OXZhufRYKDS2cp0OfPcJKMCjozaqGeJ2PUyeMvcJSxFSabV5T3LDg4av5uAubUtg7Xl7lM+zAykNEm7PKIk+w17c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcByQoRg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcByQoRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682F81F000FF;
	Sat, 12 Sep 2026 16:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232353;
	bh=OveyQuIOLiZWcUWUbJiZYBja3uLtnrpxUx2pu4yy2Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BcByQoRgDJfiPXgpnnRVfbbglq+uTCe01qcg9pFJDnWI0kZ47pv+maeosSkgQQfWc
	 QssAjb/psNhckSyfx8vWIFjrJsK4YZxD/nrurE0zA8gtOPRT/4DpnKHpEtqrX0cSmQ
	 vJYVn98KNHiN5I5x8m3T8/1qoY/Dj+iFRo4yVIy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Lukasz Majewski <lukma@denx.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1184/1191] net: hsr: init prune_proxy_timer sooner
Date: Sat, 12 Sep 2026 09:05:12 +0200
Message-ID: <20260912065614.730069980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3c668cef61adde9ddfb1b79708c9a08d9ac01bae ]

We must initialize prune_proxy_timer before we attempt
a del_timer_sync() on it.

syzbot reported the following splat:

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 1 PID: 11 Comm: kworker/u8:1 Not tainted 6.9.0-rc5-syzkaller-01199-gfc48de77d69d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
  assign_lock_key+0x238/0x270 kernel/locking/lockdep.c:976
  register_lock_class+0x1cf/0x980 kernel/locking/lockdep.c:1289
  __lock_acquire+0xda/0x1fd0 kernel/locking/lockdep.c:5014
  lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
  __timer_delete_sync+0x148/0x310 kernel/time/timer.c:1648
  del_timer_sync include/linux/timer.h:185 [inline]
  hsr_dellink+0x33/0x80 net/hsr/hsr_netlink.c:132
  default_device_exit_batch+0x956/0xa90 net/core/dev.c:11737
  ops_exit_list net/core/net_namespace.c:175 [inline]
  cleanup_net+0x89d/0xcc0 net/core/net_namespace.c:637
  process_one_work kernel/workqueue.c:3254 [inline]
  process_scheduled_works+0xa10/0x17c0 kernel/workqueue.c:3335
  worker_thread+0x86d/0xd70 kernel/workqueue.c:3416
  kthread+0x2f0/0x390 kernel/kthread.c:388
  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
ODEBUG: assert_init not available (active state 0) object: ffff88806d3fcd88 object type: timer_list hint: 0x0
 WARNING: CPU: 1 PID: 11 at lib/debugobjects.c:517 debug_print_object+0x17a/0x1f0 lib/debugobjects.c:514

Fixes: 5055cccfc2d1 ("net: hsr: Provide RedBox support (HSR-SAN)")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Lukasz Majewski <lukma@denx.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240426163355.2613767-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index def81cae14f21..1ab14dc3b7ca5 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -681,6 +681,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 
 	timer_setup(&hsr->announce_timer, hsr_announce, 0);
 	timer_setup(&hsr->prune_timer, hsr_prune_nodes, 0);
+	timer_setup(&hsr->prune_proxy_timer, hsr_prune_proxy_nodes, 0);
 
 	ether_addr_copy(hsr->sup_multicast_addr, def_multicast_addr);
 	hsr->sup_multicast_addr[ETH_ALEN - 1] = multicast_spec;
@@ -724,7 +725,6 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 
 		hsr->redbox = true;
 		ether_addr_copy(hsr->macaddress_redbox, interlink->dev_addr);
-		timer_setup(&hsr->prune_proxy_timer, hsr_prune_proxy_nodes, 0);
 		mod_timer(&hsr->prune_proxy_timer,
 			  jiffies + msecs_to_jiffies(PRUNE_PROXY_PERIOD));
 	}
-- 
2.53.0



