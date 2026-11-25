Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625455;
	b=vaROQ4LUgjDaiTP6mPR0H2AomzOuY/I17u2/YX5ECLvR7iFVZJsOsVsMZJnJSplP0M9s
	 JY+MrQmyb4nL8mzimZr2FvUTbkbBEkzI/UjEdQ1Tv1WQIdACb1vyam23Nhw5zMacDF1gm
	 ydOzjoeNcTzsFU13+HeOrNcqWg9ohTZ6Yp08J8UhywWVo9WYcNv8moa/CVsZfAE/6LZ5P
	 /K4ZK8OZOAwbfVTxPDrpa1R60VuTCd3OYAulkKiad1wfziZdbgIdjMk9orOYOpsigNsWk
	 tCEDIAbZPT37DT9ngG2S/1TzdaIRIOApk2R6W+Cdo+7/YLXV3EYRRb/Qh39n4A1ipYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=e9t2BnKLsXi2UnEuJ55u9XoNIvDTQkB2UDJRaPjbyTM=;
	b=CQUtqqq0rvJYlGQ7ZdN0+ymUydPJr8Rhn3Yz0zayms1keMf6J+HK2TQ95kBnVDs+HZfu
	 F4UIMf1TlCIQ7wG4p3XTQ9pwQP4usxr2VUJs+CNkFg10PXTvgeAIS03nCx4mAXjuK4xkQ
	 r3uYmRNRSdkRrsyJJzs71WQLLLDt516lqDoG9JqtMXiR/HMS5zAQxSnxswAxN1YZXFs1j
	 HT3mm2GfyUO3NPImZxxNeddYIZVwtADc+qiIUk4zkqIkx6jNvnaLdSh2bmqxSg5ajmvVF
	 HGNvHgRhOf3xcSv4jwZ/11GOFzR86dPvdzFlbGAcXHjy91OiBI+slPl8/9UmSk/YDJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OG7hRQ4m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0F1606A31E;
	Wed, 25 Nov 2026 16:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OG7hRQ4m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE041F000CA;
	Wed, 25 Nov 2026 16:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625455;
	bh=e9t2BnKLsXi2UnEuJ55u9XoNIvDTQkB2UDJRaPjbyTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OG7hRQ4m58UtI0IfUGoSDUgDCEiRxdCBK5faLWxCVBuTfiYIgFGgoL61IFZQwX1IK
	 LsWCGpF7WRJQ6YPYDjPyueaa1TFXcWdgHzJtfaeHi8i0a73DD1V3IEXp8l9NibKT+k
	 rLUzVtvtHZlCaeyCIeyJPraRN+RtCmppRdFQyfv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 523/816] xsk: freeze deferred pool teardown without blocking unregister
Date: Wed, 25 Nov 2026 15:34:31 +0100
Message-ID: <20261125143901.292951385@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit fece8420e76fe53ee84f0439f18d026b4c7641da ]

Deferred pool destruction calls ndo_bpf() under RTNL. system_wq is
not frozen during system sleep, so that callback can run after a
device has suspended and gated its clocks. Use system_freezable_wq
so running destruction finishes before device suspend and new work
waits until process thaw.

Keep assigned pools visible to NETDEV_UNREGISTER independently of
the socket list. A released socket has already left that list, but
its final pool put can queue destruction after workqueues freeze.
A resume-time unregister would then wait for a device reference
whose release cannot run until the resume completes.

Track assigned pools per netdev with netdev operations locking and detach
remaining pools after the notifier socket walk, including copy-mode pools.
This also covers leased queues without scanning pools from unrelated
devices or network namespaces. Remove the entry on assignment failure and
normal teardown. The deferred worker still owns the pool and later observes
the cleared device pointer, avoiding a second driver detach or put.

The lifetime problem was identified by code inspection of the deferred
release and system-sleep paths.

Fixes: 1c1efc2af158 ("xsk: Create and free buffer pool independently from umem")
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20261014-xsk-suspend-teardown-v4-1-27795582e4a3@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ sashal: Dropped netdev ops locking calls (netdev_lock_ops and friends) since they don't exist here, relying on RTNL with ASSERT_RTNL() instead, and adjusted the comments to say RTNL protected. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h   |  5 +++++
 include/net/xsk_buff_pool.h |  3 +++
 net/xdp/xsk.c               |  5 +++++
 net/xdp/xsk_buff_pool.c     | 43 +++++++++++++++++++++++++++++++------
 4 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4d1e0b91402d1..8dc5666795841 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2390,6 +2390,11 @@ struct net_device {
 	/* protected by rtnl_lock */
 	struct bpf_xdp_entity	xdp_state[__MAX_XDP_MODE];
 
+#ifdef CONFIG_XDP_SOCKETS
+	/** @xsk_pools: assigned AF_XDP pools, RTNL protected */
+	struct hlist_head	xsk_pools;
+#endif
+
 	u8 dev_addr_shadow[MAX_ADDR_LEN];
 	netdevice_tracker	linkwatch_dev_tracker;
 	netdevice_tracker	watchdog_dev_tracker;
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 4fce4bd826b9c..c58795a6d8c20 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -48,6 +48,8 @@ struct xsk_buff_pool {
 	struct device *dev;
 	struct net_device *netdev;
 	struct list_head xsk_tx_list;
+	/* Assigned pools, including deferred releases; RTNL protected. */
+	struct hlist_node dev_node;
 	/* Protects modifications to the xsk_tx_list */
 	spinlock_t xsk_tx_list_lock;
 	refcount_t users;
@@ -118,6 +120,7 @@ bool xp_put_pool(struct xsk_buff_pool *pool);
 void xp_clear_dev(struct xsk_buff_pool *pool);
 void xp_add_xsk(struct xsk_buff_pool *pool, struct xdp_sock *xs);
 void xp_del_xsk(struct xsk_buff_pool *pool, struct xdp_sock *xs);
+void xp_clear_dev_all(struct net_device *dev);
 
 /* AF_XDP, and XDP core. */
 void xp_free(struct xdp_buff_xsk *xskb);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 8dd43f06d6ed1..1bc966669ec96 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1890,6 +1890,11 @@ static int xsk_notifier(struct notifier_block *this,
 			mutex_unlock(&xs->mutex);
 		}
 		mutex_unlock(&net->xdp.lock);
+		/*
+		 * A released socket is no longer on xdp.list. Its pool can still
+		 * hold a device reference on the frozen release workqueue.
+		 */
+		xp_clear_dev_all(dev);
 		break;
 	}
 	return NOTIFY_DONE;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 13fc16e361e04..03bafa4aa3aba 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -207,6 +207,11 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	pool->cached_need_wakeup = XDP_WAKEUP_TX;
 
 	dev_hold(netdev);
+	/*
+	 * Socket removal precedes the final pool put. Keep the pool visible to
+	 * NETDEV_UNREGISTER even while release work is waiting for process thaw.
+	 */
+	hlist_add_head(&pool->dev_node, &netdev->xsk_pools);
 
 	if (force_copy)
 		/* For copy-mode, we are done. */
@@ -267,6 +272,8 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	if (err) {
 		pool->umem->flags = umem_flags;
 		xsk_clear_pool_at_qid(netdev, queue_id);
+		hlist_del(&pool->dev_node);
+		pool->netdev = NULL;
 		dev_put(netdev);
 	}
 	return err;
@@ -293,15 +300,35 @@ int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
 	return xp_assign_dev(pool, dev, queue_id, flags);
 }
 
-void xp_clear_dev(struct xsk_buff_pool *pool)
+static void __xp_clear_dev(struct xsk_buff_pool *pool)
 {
-	if (!pool->netdev)
-		return;
+	struct net_device *netdev = pool->netdev;
 
+	ASSERT_RTNL();
 	xp_disable_drv_zc(pool);
-	xsk_clear_pool_at_qid(pool->netdev, pool->queue_id);
-	dev_put(pool->netdev);
+	xsk_clear_pool_at_qid(netdev, pool->queue_id);
+	hlist_del(&pool->dev_node);
 	pool->netdev = NULL;
+	dev_put(netdev);
+}
+
+void xp_clear_dev(struct xsk_buff_pool *pool)
+{
+	struct net_device *netdev = pool->netdev;
+
+	if (!netdev)
+		return;
+
+	__xp_clear_dev(pool);
+}
+
+void xp_clear_dev_all(struct net_device *dev)
+{
+	struct xsk_buff_pool *pool;
+	struct hlist_node *next;
+
+	hlist_for_each_entry_safe(pool, next, &dev->xsk_pools, dev_node)
+		__xp_clear_dev(pool);
 }
 
 static void xp_release_deferred(struct work_struct *work)
@@ -339,7 +366,11 @@ bool xp_put_pool(struct xsk_buff_pool *pool)
 
 	if (refcount_dec_and_test(&pool->users)) {
 		INIT_WORK(&pool->work, xp_release_deferred);
-		schedule_work(&pool->work);
+		/*
+		 * Teardown calls ndo_bpf(), which may need powered hardware.
+		 * RTNL alone does not exclude the device's system PM callbacks.
+		 */
+		queue_work(system_freezable_wq, &pool->work);
 		return true;
 	}
 
-- 
2.53.0



