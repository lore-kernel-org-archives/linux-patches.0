Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBC337EFFE;
	Wed, 30 Sep 2026 18:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791841; cv=none; b=eTXwRb9rU3kfbNSYpYj8gIfOxE5cGKTUkffbGdwKGL0pEPlcN7T9SZNZ/7oQQWqenBdxs2Mt2y2RpTHGqkV0W8x1DtDToHN56dIzM0EN6ttCX3NcR8i6q7iSEYtguagdBLA63TYnyqdHvJIOE5GN4PTNWxaXTyFSP2PNyTh0b48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791841; c=relaxed/simple;
	bh=fsWf3xpjwlU7aYkZaB40u+G4Go00sUrEyprRGM0pxlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3R2yYuWv+APGds+PzcBtSid3tlPBaohrFSkxzLir9cKNAyfSZskPPe0UIK7oQSa1fkzm8Q2cOTuwmhCv+DneI6M1bZp+qlufH2ttSYeVUNzJBUsz2Noqbgpp7or9OiY6auy1kDeTyK+3j/ckCeqtZfEWqhhTCeLw2kPVtKLii4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMWEK1YH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMWEK1YH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5262B1F000FF;
	Wed, 30 Sep 2026 18:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791839;
	bh=21vHF1Gz4zLFdwECG7Y44g4TeUu6dQ02eDhYFhRjRR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMWEK1YHJ4Lycexe6pzEObDFPrZGaCZwrUABT+rlZyCgrcVCmJnOekUxFH4oJxtxy
	 L/90sBzjyHQaUb/JYjiLl2Q5hbs1CzUoeNe0TA3xJxVCjgxXyLvgchTbW0Ldx5Viwn
	 zSo37ypjl7+TMhjYIINO9m1SljgmvgeA2qU4PwvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Liu Jian <liujian56@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 443/752] xfrm: add missing rcu_read_lock(), skb_dst_force() and dev_hold() for xfrm_trans_reinject()
Date: Wed, 30 Sep 2026 17:25:13 +0200
Message-ID: <20260930152407.868965546@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d2f5082f9e84653fa1a9e8aebaaff23e688f5e19 ]

syzbot reported a suspicious RCU usage warning in ip6_pkt_drop():

  WARNING: suspicious RCU usage in ip6_pkt_drop
  include/net/addrconf.h:389 suspicious rcu_dereference_check() usage!

  Call Trace:
   __in6_dev_get_safely include/net/addrconf.h:389 [inline]
   ip6_pkt_drop+0x596/0x610 net/ipv6/route.c:4620
   ip6_pkt_discard+0x1c/0x30 net/ipv6/route.c:4651
   xfrm_trans_reinject+0x324/0x630 net/xfrm/xfrm_input.c:806
   process_one_work kernel/workqueue.c:3322 [inline]
   process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
   worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486

When commit 4f4920669d21 ("xfrm: Reinject transport-mode packets through
workqueue") converted xfrm_trans_reinject from a tasklet to a workqueue,
the reinjection loop ceased running in softirq context. Workqueue workers
run in process context where local_bh_disable() does not enter an RCU
read-side critical section under CONFIG_PREEMPT_RCU.

Because finish callbacks (such as ip6_rcv_finish) expect to run under an
RCU read lock (performing route lookups, l3mdev lookups, and accessing
RCU-protected data structures), invoking them in workqueue context without
rcu_read_lock() triggers RCU lockdep warnings.

Furthermore, packets queued to the workqueue via xfrm_trans_queue_net()
may carry non-refcounted (noref) dst entries (e.g. from ip_route_input_noref).
Additionally, on netdevice unregistration, dst_dev_put() replaces dst->dev
with blackhole_netdev, so dst entries do not keep skb->dev alive while
queued in the workqueue.

Fix these issues by:
1. Calling skb_dst_force(skb) in xfrm_trans_queue_net() while still in the
   caller's RCU section to ensure dst is reference-counted before queuing.
2. Holding a reference on skb->dev via dev_hold()/dev_put() across workqueue
   deferral so skb->dev remains valid during finish() callback processing.
3. Acquiring rcu_read_lock() around the finish callback invocation loop in
   xfrm_trans_reinject().

Fixes: 4f4920669d21 ("xfrm: Reinject transport-mode packets through workqueue")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Liu Jian <liujian56@huawei.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_input.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 6ab0b2166a595..6dd9752407851 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -781,12 +781,17 @@ static void xfrm_trans_reinject(struct work_struct *work)
 	spin_unlock_bh(&trans->queue_lock);
 
 	local_bh_disable();
+	rcu_read_lock();
 	while ((skb = __skb_dequeue(&queue))) {
 		struct net *net = XFRM_TRANS_SKB_CB(skb)->net;
+		struct net_device *dev = skb->dev;
 
 		XFRM_TRANS_SKB_CB(skb)->finish(net, NULL, skb);
+		if (dev)
+			dev_put(dev);
 		put_net(net);
 	}
+	rcu_read_unlock();
 	local_bh_enable();
 }
 
@@ -802,12 +807,18 @@ int xfrm_trans_queue_net(struct net *net, struct sk_buff *skb,
 	if (skb_queue_len(&trans->queue) >= READ_ONCE(netdev_max_backlog))
 		return -ENOBUFS;
 
+	if (skb_dst(skb) && !skb_dst_force(skb))
+		return -EHOSTUNREACH;
+
 	BUILD_BUG_ON(sizeof(struct xfrm_trans_cb) > sizeof(skb->cb));
 
 	hold_net = maybe_get_net(net);
 	if (!hold_net)
 		return -ENODEV;
 
+	if (skb->dev)
+		dev_hold(skb->dev);
+
 	XFRM_TRANS_SKB_CB(skb)->finish = finish;
 	XFRM_TRANS_SKB_CB(skb)->net = hold_net;
 	spin_lock_bh(&trans->queue_lock);
-- 
2.53.0



