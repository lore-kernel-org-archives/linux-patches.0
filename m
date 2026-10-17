Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772023A542B;
	Sat, 17 Oct 2026 17:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259263; cv=none; b=MvA9auBFss+ktkM8kQtJu6Rx+qPowr2E2S/ONe2iOLyXeppBZOq3wfvlCrZkF0Zam7dUIM/BnaJLPz3nqzHBPP+n8msp++G1GYhSMiFa/1H+pL6X0TMorYB4WAxtrGabNaDVeJLtqESEqwjsSqWBk19ASR0ueNmt8poNikW7Wbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259263; c=relaxed/simple;
	bh=8JLQlCsTt3JgRsFYa/pKfLS0gOlggL6BdKL3LZJJwhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ft1qI2rHhox63ZYk8jTjcUyYwC/yuKVW0H2RCebkRHFTLw18DGn3Ql6+1VltV+oPqkvxNXDbzAojRiFEuO9B67E8N/u5lL8PWuehJdpyr4ch4wKbQO3CECRrDBnI9sy0NfWv2mIyBDj+gzLL8R4Mk2EJzP2bqEWq0g8WXh2tn+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVmKHNwM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVmKHNwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19D71F000C4;
	Sat, 17 Oct 2026 17:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259262;
	bh=UI5c2gfsrvnA+PjYgK0QgluJA02xiojRHCS4MjjEs5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVmKHNwMB8oqm17PEB153R2kocFEKhaM4Pj5TLsq2TDZ/XXr4s91KESPOZkZxzrKu
	 yrK1D6EmL/ABJ5mtaVXB6oa77PIJISFFjvFrRsOWx3cPyzoLCq4NVSVU6YdAopoKwm
	 dsVx337AW0Z/SXvmt70FJoyf9pIocO4A3mZv//2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+381d82bbf0253710b35d@syzkaller.appspotmail.com,
	syzbot+3479efbc2821cb2a79f2@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1156/1674] net: watchdog: fix refcount tracking races
Date: Sat, 17 Oct 2026 17:57:08 +0200
Message-ID: <20261017160500.824277713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8eed5519e496b7a07f441a0f579cb228a33189f7 ]

Blamed commit converted the untracked dev_hold()/dev_put() calls
in the watchdog code to use the tracked dev_hold_track()/dev_put_track()
(which were later renamed/interfaced to netdev_hold() and netdev_put()).

By introducing dev->watchdog_dev_tracker to store the
reference tracking information without adding synchronization
between netdev_watchdog_up() and dev_watchdog(), it enabled the
race condition where this pointer could be overwritten or freed
concurrently, leading to the list corruption crash syzbot reported:

list_del corruption, ffff888114a18c00->next is NULL
 kernel BUG at lib/list_debug.c:52 !
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 91 Comm: kworker/u8:5 Not tainted syzkaller #0 PREEMPT(lazy)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
Workqueue: events_unbound linkwatch_event
 RIP: 0010:__list_del_entry_valid_or_report.cold+0x22/0x2a lib/list_debug.c:52
Call Trace:
 <TASK>
  __list_del_entry_valid include/linux/list.h:132 [inline]
  __list_del_entry include/linux/list.h:246 [inline]
  list_move_tail include/linux/list.h:341 [inline]
  ref_tracker_free+0x1a7/0x6c0 lib/ref_tracker.c:329
  netdev_tracker_free include/linux/netdevice.h:4491 [inline]
  netdev_put include/linux/netdevice.h:4508 [inline]
  netdev_put include/linux/netdevice.h:4504 [inline]
  netdev_watchdog_down net/sched/sch_generic.c:600 [inline]
  dev_deactivate_many+0x28c/0xfe0 net/sched/sch_generic.c:1363
  dev_deactivate+0x109/0x1d0 net/sched/sch_generic.c:1397
  linkwatch_do_dev net/core/link_watch.c:184 [inline]
  linkwatch_do_dev+0xd3/0x120 net/core/link_watch.c:166
  __linkwatch_run_queue+0x3a5/0x810 net/core/link_watch.c:240
  linkwatch_event+0x8f/0xc0 net/core/link_watch.c:314
  process_one_work+0xa0e/0x1980 kernel/workqueue.c:3314
  process_scheduled_works kernel/workqueue.c:3397 [inline]
  worker_thread+0x5ef/0xe50 kernel/workqueue.c:3478
  kthread+0x370/0x450 kernel/kthread.c:436
  ret_from_fork+0x69a/0xc80 arch/x86/kernel/process.c:158
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

This patch has three coordinated parts:

1) Add dev->watchdog_lock and dev->watchdog_ref_held to serialize watchdog operations.

2) Remove netdev_watchdog_up() call from netif_carrier_on():
   This ensures netdev_watchdog_up() is only called from process/BH context
   (via linkwatch workqueue dev_activate()), allowing us to use
   spin_lock_bh() for synchronization.

3) Synchronize watchdog up and watchdog timer:
   Protect netdev_watchdog_up() with tx_global_lock and watchdog_lock.
   Only allocate a new tracker in netdev_watchdog_up() if one is
   not already present.
   In dev_watchdog(), ensure we don't release the tracker if the
   timer was rescheduled either by dev_watchdog() itself or concurrently
   by netdev_watchdog_up().

Fixes: f12bf6f3f942 ("net: watchdog: add net device refcount tracker")
Reported-by: syzbot+381d82bbf0253710b35d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a26b751.c25708ab.1b19ef.0013.GAE@google.com/T/#u
Tested-by: syzbot+3479efbc2821cb2a79f2@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260611152737.2580480-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |  4 ++++
 net/core/dev.c            |  3 ++-
 net/sched/sch_generic.c   | 45 ++++++++++++++++++++++++++++-----------
 3 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3510177cd1ba6..f733b7de0fe0c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1977,6 +1977,8 @@ enum netdev_reg_state {
  *	@qdisc_hash:		qdisc hash table
  *	@watchdog_timeo:	Represents the timeout that is used by
  *				the watchdog (see dev_watchdog())
+ *	@watchdog_lock:		protect watchdog_ref_held
+ *	@watchdog_ref_held:	True if the watchdog device ref is taken.
  *	@watchdog_timer:	List of timers
  *
  *	@proto_down_reason:	reason a netdev interface is held down
@@ -2320,6 +2322,8 @@ struct net_device {
 	/* These may be needed for future network-power-down code. */
 	struct timer_list	watchdog_timer;
 	int			watchdog_timeo;
+	spinlock_t		watchdog_lock;
+	bool			watchdog_ref_held;
 
 	u32                     proto_down_reason;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 045b815516010..a389e9e3762fa 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10202,7 +10202,8 @@ static int netif_alloc_netdev_queues(struct net_device *dev)
 
 	netdev_for_each_tx_queue(dev, netdev_init_one_queue, NULL);
 	spin_lock_init(&dev->tx_global_lock);
-
+	spin_lock_init(&dev->watchdog_lock);
+	dev->watchdog_ref_held = false;
 	return 0;
 }
 
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 3d695ed25d322..4c82aef3386ff 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -541,28 +541,43 @@ static void dev_watchdog(struct timer_list *t)
 				dev->netdev_ops->ndo_tx_timeout(dev, i);
 				netif_unfreeze_queues(dev);
 			}
-			if (!mod_timer(&dev->watchdog_timer,
-				       round_jiffies(oldest_start +
-						     dev->watchdog_timeo)))
-				release = false;
+			spin_lock(&dev->watchdog_lock);
+			mod_timer(&dev->watchdog_timer,
+				  round_jiffies(oldest_start +
+						dev->watchdog_timeo));
+			release = false;
+			spin_unlock(&dev->watchdog_lock);
 		}
 	}
 	spin_unlock(&dev->tx_global_lock);
 
-	if (release)
+	spin_lock(&dev->watchdog_lock);
+	if (timer_pending(&dev->watchdog_timer))
+		release = false;
+	if (release && dev->watchdog_ref_held) {
 		netdev_put(dev, &dev->watchdog_dev_tracker);
+		dev->watchdog_ref_held = false;
+	}
+	spin_unlock(&dev->watchdog_lock);
 }
 
 void __netdev_watchdog_up(struct net_device *dev)
 {
-	if (dev->netdev_ops->ndo_tx_timeout) {
-		if (dev->watchdog_timeo <= 0)
-			dev->watchdog_timeo = 5*HZ;
-		if (!mod_timer(&dev->watchdog_timer,
-			       round_jiffies(jiffies + dev->watchdog_timeo)))
+	if (!dev->netdev_ops->ndo_tx_timeout)
+		return;
+	if (dev->watchdog_timeo <= 0)
+		dev->watchdog_timeo = 5*HZ;
+
+	spin_lock_bh(&dev->watchdog_lock);
+	if (!mod_timer(&dev->watchdog_timer,
+		       round_jiffies(jiffies + dev->watchdog_timeo))) {
+		if (!dev->watchdog_ref_held) {
 			netdev_hold(dev, &dev->watchdog_dev_tracker,
 				    GFP_ATOMIC);
+			dev->watchdog_ref_held = true;
+		}
 	}
+	spin_unlock_bh(&dev->watchdog_lock);
 }
 EXPORT_SYMBOL_GPL(__netdev_watchdog_up);
 
@@ -574,8 +589,14 @@ static void dev_watchdog_up(struct net_device *dev)
 static void dev_watchdog_down(struct net_device *dev)
 {
 	netif_tx_lock_bh(dev);
-	if (del_timer(&dev->watchdog_timer))
+
+	spin_lock(&dev->watchdog_lock);
+	if (timer_delete(&dev->watchdog_timer)) {
 		netdev_put(dev, &dev->watchdog_dev_tracker);
+		dev->watchdog_ref_held = false;
+	}
+	spin_unlock(&dev->watchdog_lock);
+
 	netif_tx_unlock_bh(dev);
 }
 
@@ -592,8 +613,6 @@ void netif_carrier_on(struct net_device *dev)
 			return;
 		atomic_inc(&dev->carrier_up_count);
 		linkwatch_fire_event(dev);
-		if (netif_running(dev))
-			__netdev_watchdog_up(dev);
 	}
 }
 EXPORT_SYMBOL(netif_carrier_on);
-- 
2.53.0



