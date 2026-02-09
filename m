Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6071E1DE8AD;
	Mon,  9 Feb 2026 14:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647560; cv=none; b=Ncwwzn4Be3lhuy1/xjW/fIbFD5xFwPsjCVl01584sxbacJ4gUTML7a5TMg8Ydtwt4YTXOMxGTHz70mlM6S563KkVT70ZRwE8QKH30x2fd9I8iT+KkS2a/mmLiMZjiHHtJRVgrShhmo5LKgyvnBsw35ledUs3fK8BnbVGi5qgRqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647560; c=relaxed/simple;
	bh=i1DhAwhKNbK+GqI6aVPUprt3yirxYtM2xitYHNw5sn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLIbZhbrwgRUcvdXXyy0eQVH9Ll56NDpbAbgyY2Egz/uNxNHb+DbGOG1HgPoTZHbuj8iU/g0TrHj3w1N7ExrCbRqqSAwz3vO2v+UDkL+BOgSRMFe75itYt/R6wIFkoC6AbwvU8EO8ro7Tbo/39lbD6XbEFWZ+d2SD8e+xMFyP/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVdPKsXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVdPKsXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3117C116C6;
	Mon,  9 Feb 2026 14:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647560;
	bh=i1DhAwhKNbK+GqI6aVPUprt3yirxYtM2xitYHNw5sn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVdPKsXpFWxZIWUB3fUwTBKtxzB7CVwxQ1VDUQSc4fBwINzVvJz5mSqD/7ucUdBW5
	 MEI32QhOYDDTZ0QDUVmeJMMxSm34a/MQ/GXqhpVc8TxKuOraDU4dINsm+s113oOnN/
	 Xmp+VFVBMkujge3Byla6IQry85dGtuj9TvhZzLx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1ec2f6a450f0b54af8c8@syzkaller.appspotmail.com,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 137/175] linkwatch: use __dev_put() in callers to prevent UAF
Date: Mon,  9 Feb 2026 15:23:30 +0100
Message-ID: <20260209142325.437673074@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 83b67cc9be9223183caf91826d9c194d7fb128fa ]

After linkwatch_do_dev() calls __dev_put() to release the linkwatch
reference, the device refcount may drop to 1. At this point,
netdev_run_todo() can proceed (since linkwatch_sync_dev() sees an
empty list and returns without blocking), wait for the refcount to
become 1 via netdev_wait_allrefs_any(), and then free the device
via kobject_put().

This creates a use-after-free when __linkwatch_run_queue() tries to
call netdev_unlock_ops() on the already-freed device.

Note that adding netdev_lock_ops()/netdev_unlock_ops() pair in
netdev_run_todo() before kobject_put() would not work, because
netdev_lock_ops() is conditional - it only locks when
netdev_need_ops_lock() returns true. If the device doesn't require
ops_lock, linkwatch won't hold any lock, and netdev_run_todo()
acquiring the lock won't provide synchronization.

Fix this by moving __dev_put() from linkwatch_do_dev() to its
callers. The device reference logically pairs with de-listing the
device, so it's reasonable for the caller that did the de-listing
to release it. This allows placing __dev_put() after all device
accesses are complete, preventing UAF.

The bug can be reproduced by adding mdelay(2000) after
linkwatch_do_dev() in __linkwatch_run_queue(), then running:

  ip tuntap add mode tun name tun_test
  ip link set tun_test up
  ip link set tun_test carrier off
  ip link set tun_test carrier on
  sleep 0.5
  ip tuntap del mode tun name tun_test

KASAN report:

 ==================================================================
 BUG: KASAN: use-after-free in netdev_need_ops_lock include/net/netdev_lock.h:33 [inline]
 BUG: KASAN: use-after-free in netdev_unlock_ops include/net/netdev_lock.h:47 [inline]
 BUG: KASAN: use-after-free in __linkwatch_run_queue+0x865/0x8a0 net/core/link_watch.c:245
 Read of size 8 at addr ffff88804de5c008 by task kworker/u32:10/8123

 CPU: 0 UID: 0 PID: 8123 Comm: kworker/u32:10 Not tainted syzkaller #0 PREEMPT(full)
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 Workqueue: events_unbound linkwatch_event
 Call Trace:
  <TASK>
  __dump_stack lib/dump_stack.c:94 [inline]
  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
  print_address_description mm/kasan/report.c:378 [inline]
  print_report+0x156/0x4c9 mm/kasan/report.c:482
  kasan_report+0xdf/0x1a0 mm/kasan/report.c:595
  netdev_need_ops_lock include/net/netdev_lock.h:33 [inline]
  netdev_unlock_ops include/net/netdev_lock.h:47 [inline]
  __linkwatch_run_queue+0x865/0x8a0 net/core/link_watch.c:245
  linkwatch_event+0x8f/0xc0 net/core/link_watch.c:304
  process_one_work+0x9c2/0x1840 kernel/workqueue.c:3257
  process_scheduled_works kernel/workqueue.c:3340 [inline]
  worker_thread+0x5da/0xe40 kernel/workqueue.c:3421
  kthread+0x3b3/0x730 kernel/kthread.c:463
  ret_from_fork+0x754/0xaf0 arch/x86/kernel/process.c:158
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
  </TASK>
 ==================================================================

Fixes: 04efcee6ef8d ("net: hold instance lock during NETDEV_CHANGE")
Reported-by: syzbot+1ec2f6a450f0b54af8c8@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6824d064.a70a0220.3e9d8.001a.GAE@google.com/T/
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260201135915.393451-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/link_watch.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 212cde35affa7..25c455c10a01c 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -185,10 +185,6 @@ static void linkwatch_do_dev(struct net_device *dev)
 
 		netif_state_change(dev);
 	}
-	/* Note: our callers are responsible for calling netdev_tracker_free().
-	 * This is the reason we use __dev_put() instead of dev_put().
-	 */
-	__dev_put(dev);
 }
 
 static void __linkwatch_run_queue(int urgent_only)
@@ -243,6 +239,11 @@ static void __linkwatch_run_queue(int urgent_only)
 		netdev_lock_ops(dev);
 		linkwatch_do_dev(dev);
 		netdev_unlock_ops(dev);
+		/* Use __dev_put() because netdev_tracker_free() was already
+		 * called above. Must be after netdev_unlock_ops() to prevent
+		 * netdev_run_todo() from freeing the device while still in use.
+		 */
+		__dev_put(dev);
 		do_dev--;
 		spin_lock_irq(&lweventlist_lock);
 	}
@@ -278,8 +279,13 @@ void __linkwatch_sync_dev(struct net_device *dev)
 {
 	netdev_ops_assert_locked(dev);
 
-	if (linkwatch_clean_dev(dev))
+	if (linkwatch_clean_dev(dev)) {
 		linkwatch_do_dev(dev);
+		/* Use __dev_put() because netdev_tracker_free() was already
+		 * called inside linkwatch_clean_dev().
+		 */
+		__dev_put(dev);
+	}
 }
 
 void linkwatch_sync_dev(struct net_device *dev)
@@ -288,6 +294,10 @@ void linkwatch_sync_dev(struct net_device *dev)
 		netdev_lock_ops(dev);
 		linkwatch_do_dev(dev);
 		netdev_unlock_ops(dev);
+		/* Use __dev_put() because netdev_tracker_free() was already
+		 * called inside linkwatch_clean_dev().
+		 */
+		__dev_put(dev);
 	}
 }
 
-- 
2.51.0



