Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16B21519AA;
	Wed,  5 Feb 2025 14:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764913; cv=none; b=BQTQ8ZJu0jPEwZc2BaA7CeOHEKNijJ/Q97CAJIySYW2KVi/6TeIYfqT6Yg+Ax8ud5OENlNClOSZhQvAKyYGzYFB3UxnW4/B9mTCgIlFD3zg/m1LoH2jZpMIQ5d/k2sUL2VuvyzsCN4W4tEKiX8RAe1yYJSR9Zqxm550t6ueli7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764913; c=relaxed/simple;
	bh=OEeoRljiX6vTSXn+2bUjKSXWoK+/Of+R72MyZMydQgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4zsy9QG3qvyFDQuEhRdwryNWkf4SG8KuwNCGfATGq3JrmlIdJhCiDN60ky5xBuLLTVk+o8xYXWW86xtZyENuOMtyQV1EzZNIROdM8tMx9hbXadtQ4lpRuDT8VrSsxJ2feNi6zVQCM1kNzbet2h2K3wPRRDoNWQP7HlKDgCYuig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMFzyIwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMFzyIwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69337C4CED1;
	Wed,  5 Feb 2025 14:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764912;
	bh=OEeoRljiX6vTSXn+2bUjKSXWoK+/Of+R72MyZMydQgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMFzyIwWc4TqOjc6j82tt15Ju7PRFMDz7Npr1M8ZzOtxA+sZB3YEFPd5pf7BxK06N
	 b9QpFydGBJCQR6v8MeR3HIf7yBZWFi97Da9xclkboTd60EeF8xb86d0rCvd6em6dbd
	 JA4fk8zwz9nmmOXj1DFkR6OihAr/xhd9qBEW6AgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f56a5c5eac2b28439810@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 124/623] ptr_ring: do not block hard interrupts in ptr_ring_resize_multiple()
Date: Wed,  5 Feb 2025 14:37:46 +0100
Message-ID: <20250205134500.966404663@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

[ Upstream commit a126061c80d5efb4baef4bcf346094139cd81df6 ]

Jakub added a lockdep_assert_no_hardirq() check in __page_pool_put_page()
to increase test coverage.

syzbot found a splat caused by hard irq blocking in
ptr_ring_resize_multiple() [1]

As current users of ptr_ring_resize_multiple() do not require
hard irqs being masked, replace it to only block BH.

Rename helpers to better reflect they are safe against BH only.

- ptr_ring_resize_multiple() to ptr_ring_resize_multiple_bh()
- skb_array_resize_multiple() to skb_array_resize_multiple_bh()

[1]

WARNING: CPU: 1 PID: 9150 at net/core/page_pool.c:709 __page_pool_put_page net/core/page_pool.c:709 [inline]
WARNING: CPU: 1 PID: 9150 at net/core/page_pool.c:709 page_pool_put_unrefed_netmem+0x157/0xa40 net/core/page_pool.c:780
Modules linked in:
CPU: 1 UID: 0 PID: 9150 Comm: syz.1.1052 Not tainted 6.11.0-rc3-syzkaller-00202-gf8669d7b5f5d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:__page_pool_put_page net/core/page_pool.c:709 [inline]
RIP: 0010:page_pool_put_unrefed_netmem+0x157/0xa40 net/core/page_pool.c:780
Code: 74 0e e8 7c aa fb f7 eb 43 e8 75 aa fb f7 eb 3c 65 8b 1d 38 a8 6a 76 31 ff 89 de e8 a3 ae fb f7 85 db 74 0b e8 5a aa fb f7 90 <0f> 0b 90 eb 1d 65 8b 1d 15 a8 6a 76 31 ff 89 de e8 84 ae fb f7 85
RSP: 0018:ffffc9000bda6b58 EFLAGS: 00010083
RAX: ffffffff8997e523 RBX: 0000000000000000 RCX: 0000000000040000
RDX: ffffc9000fbd0000 RSI: 0000000000001842 RDI: 0000000000001843
RBP: 0000000000000000 R08: ffffffff8997df2c R09: 1ffffd40003a000d
R10: dffffc0000000000 R11: fffff940003a000e R12: ffffea0001d00040
R13: ffff88802e8a4000 R14: dffffc0000000000 R15: 00000000ffffffff
FS:  00007fb7aaf716c0(0000) GS:ffff8880b9300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa15a0d4b72 CR3: 00000000561b0000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tun_ptr_free drivers/net/tun.c:617 [inline]
 __ptr_ring_swap_queue include/linux/ptr_ring.h:571 [inline]
 ptr_ring_resize_multiple_noprof include/linux/ptr_ring.h:643 [inline]
 tun_queue_resize drivers/net/tun.c:3694 [inline]
 tun_device_event+0xaaf/0x1080 drivers/net/tun.c:3714
 notifier_call_chain+0x19f/0x3e0 kernel/notifier.c:93
 call_netdevice_notifiers_extack net/core/dev.c:2032 [inline]
 call_netdevice_notifiers net/core/dev.c:2046 [inline]
 dev_change_tx_queue_len+0x158/0x2a0 net/core/dev.c:9024
 do_setlink+0xff6/0x41f0 net/core/rtnetlink.c:2923
 rtnl_setlink+0x40d/0x5a0 net/core/rtnetlink.c:3201
 rtnetlink_rcv_msg+0x73f/0xcf0 net/core/rtnetlink.c:6647
 netlink_rcv_skb+0x1e3/0x430 net/netlink/af_netlink.c:2550

Fixes: ff4e538c8c3e ("page_pool: add a lockdep check for recycling in hardirq")
Reported-by: syzbot+f56a5c5eac2b28439810@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/671e10df.050a0220.2b8c0f.01cf.GAE@google.com/T/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20241217135121.326370-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c         |  6 +++---
 drivers/net/tun.c         |  6 +++---
 include/linux/ptr_ring.h  | 21 ++++++++++-----------
 include/linux/skb_array.h | 17 +++++++++--------
 net/sched/sch_generic.c   |  4 ++--
 5 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 5aa41d5f7765a..5ca6ecf0ce5fb 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1329,9 +1329,9 @@ int tap_queue_resize(struct tap_dev *tap)
 	list_for_each_entry(q, &tap->queue_list, next)
 		rings[i++] = &q->ring;
 
-	ret = ptr_ring_resize_multiple(rings, n,
-				       dev->tx_queue_len, GFP_KERNEL,
-				       __skb_array_destroy_skb);
+	ret = ptr_ring_resize_multiple_bh(rings, n,
+					  dev->tx_queue_len, GFP_KERNEL,
+					  __skb_array_destroy_skb);
 
 	kfree(rings);
 	return ret;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index e816aaba8e5f2..148c7bc66c0af 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3697,9 +3697,9 @@ static int tun_queue_resize(struct tun_struct *tun)
 	list_for_each_entry(tfile, &tun->disabled, next)
 		rings[i++] = &tfile->tx_ring;
 
-	ret = ptr_ring_resize_multiple(rings, n,
-				       dev->tx_queue_len, GFP_KERNEL,
-				       tun_ptr_free);
+	ret = ptr_ring_resize_multiple_bh(rings, n,
+					  dev->tx_queue_len, GFP_KERNEL,
+					  tun_ptr_free);
 
 	kfree(rings);
 	return ret;
diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
index fd037c127bb07..551329220e4f3 100644
--- a/include/linux/ptr_ring.h
+++ b/include/linux/ptr_ring.h
@@ -615,15 +615,14 @@ static inline int ptr_ring_resize_noprof(struct ptr_ring *r, int size, gfp_t gfp
 /*
  * Note: producer lock is nested within consumer lock, so if you
  * resize you must make sure all uses nest correctly.
- * In particular if you consume ring in interrupt or BH context, you must
- * disable interrupts/BH when doing so.
+ * In particular if you consume ring in BH context, you must
+ * disable BH when doing so.
  */
-static inline int ptr_ring_resize_multiple_noprof(struct ptr_ring **rings,
-						  unsigned int nrings,
-						  int size,
-						  gfp_t gfp, void (*destroy)(void *))
+static inline int ptr_ring_resize_multiple_bh_noprof(struct ptr_ring **rings,
+						     unsigned int nrings,
+						     int size, gfp_t gfp,
+						     void (*destroy)(void *))
 {
-	unsigned long flags;
 	void ***queues;
 	int i;
 
@@ -638,12 +637,12 @@ static inline int ptr_ring_resize_multiple_noprof(struct ptr_ring **rings,
 	}
 
 	for (i = 0; i < nrings; ++i) {
-		spin_lock_irqsave(&(rings[i])->consumer_lock, flags);
+		spin_lock_bh(&(rings[i])->consumer_lock);
 		spin_lock(&(rings[i])->producer_lock);
 		queues[i] = __ptr_ring_swap_queue(rings[i], queues[i],
 						  size, gfp, destroy);
 		spin_unlock(&(rings[i])->producer_lock);
-		spin_unlock_irqrestore(&(rings[i])->consumer_lock, flags);
+		spin_unlock_bh(&(rings[i])->consumer_lock);
 	}
 
 	for (i = 0; i < nrings; ++i)
@@ -662,8 +661,8 @@ static inline int ptr_ring_resize_multiple_noprof(struct ptr_ring **rings,
 noqueues:
 	return -ENOMEM;
 }
-#define ptr_ring_resize_multiple(...) \
-		alloc_hooks(ptr_ring_resize_multiple_noprof(__VA_ARGS__))
+#define ptr_ring_resize_multiple_bh(...) \
+		alloc_hooks(ptr_ring_resize_multiple_bh_noprof(__VA_ARGS__))
 
 static inline void ptr_ring_cleanup(struct ptr_ring *r, void (*destroy)(void *))
 {
diff --git a/include/linux/skb_array.h b/include/linux/skb_array.h
index 926496c9cc9c3..bf178238a3083 100644
--- a/include/linux/skb_array.h
+++ b/include/linux/skb_array.h
@@ -199,17 +199,18 @@ static inline int skb_array_resize(struct skb_array *a, int size, gfp_t gfp)
 	return ptr_ring_resize(&a->ring, size, gfp, __skb_array_destroy_skb);
 }
 
-static inline int skb_array_resize_multiple_noprof(struct skb_array **rings,
-						   int nrings, unsigned int size,
-						   gfp_t gfp)
+static inline int skb_array_resize_multiple_bh_noprof(struct skb_array **rings,
+						      int nrings,
+						      unsigned int size,
+						      gfp_t gfp)
 {
 	BUILD_BUG_ON(offsetof(struct skb_array, ring));
-	return ptr_ring_resize_multiple_noprof((struct ptr_ring **)rings,
-					       nrings, size, gfp,
-					       __skb_array_destroy_skb);
+	return ptr_ring_resize_multiple_bh_noprof((struct ptr_ring **)rings,
+					          nrings, size, gfp,
+					          __skb_array_destroy_skb);
 }
-#define skb_array_resize_multiple(...)	\
-		alloc_hooks(skb_array_resize_multiple_noprof(__VA_ARGS__))
+#define skb_array_resize_multiple_bh(...)	\
+		alloc_hooks(skb_array_resize_multiple_bh_noprof(__VA_ARGS__))
 
 static inline void skb_array_cleanup(struct skb_array *a)
 {
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 38ec18f73de43..8874ae6680952 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -911,8 +911,8 @@ static int pfifo_fast_change_tx_queue_len(struct Qdisc *sch,
 		bands[prio] = q;
 	}
 
-	return skb_array_resize_multiple(bands, PFIFO_FAST_BANDS, new_len,
-					 GFP_KERNEL);
+	return skb_array_resize_multiple_bh(bands, PFIFO_FAST_BANDS, new_len,
+					    GFP_KERNEL);
 }
 
 struct Qdisc_ops pfifo_fast_ops __read_mostly = {
-- 
2.39.5



