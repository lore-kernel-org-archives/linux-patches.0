Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622693;
	b=BP8xakKFumAmv8vLmAuZdYpNYuoJnK1NnkRhq+xDxpM1d/Cc0z3EIbqKQlplvNv6UMGo
	 sH2xVCCPZKgXHc+TFUA+WN6EKcqnCM2fGaApazUMGLM1X9/4BCkYyRSYknbtnqt9hE267
	 V2HkF0l7pasYzs/wJm/m9QiQ2w41Q3LNnNrO4Kb/fgHdgjS9eMx3qEvXvLT4vJdiG0IJu
	 npy0iwW7TEWXT1uIZfGh+qH5YnfF/tjjHdvPb6BYPXfzUERUOYMNqEXPYCvmJOJQuVRK5
	 clFi4Lz1b0rCL1U2+qIC3kUL+jt5cnzP0iQlRanQLM59v0CokJ8rzBsbutzASyNcowg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fAe+QYXy6Asides97MbwBKI5nIO4TY0+pmnxkon9/rU=;
	b=OLosoRYMwgbENOEkPIDmXfqs+b+LPVdEMHpqYnKAqnL2SgIo7a4Y9iixzubbpJKlQGdk
	 jPZygPu2K0cTRhKTRfzbA9sbK8Ad83axJrwRIakRo4QHhsVPKf4wBP40FSvQgIDY5nKcI
	 Ts0qM0v14Z+j4Rw0r0q9szHtDn6xqpvU11VIuvz58G0IDIn+DMDr82guOvl6Pc4x0fO6y
	 GOuUMRFtj9oYgPpkZkRgrRrRFYFNb1PLZiyL+qE0TnXZgXOOETKNkF5fTnYXkolLi3vxv
	 xT57s/aqcyPxzJuXQ5HnrBuNFNjPDhg43KUkota4nSIIWHVgA7Kvx91tVDINb3im3Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WCDmZX/g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F935606A31E;
	Wed, 25 Nov 2026 16:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WCDmZX/g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F9F1F000C0;
	Wed, 25 Nov 2026 16:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622693;
	bh=fAe+QYXy6Asides97MbwBKI5nIO4TY0+pmnxkon9/rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCDmZX/g9MHSwH6JsVBTW4l7m7AQvPLX37+Gb7eJMttr+NjDyu5N35x0JP/NRRRna
	 VaN/He8ar3tZgNR9KHCyFQHGrOwzjn+lKy8TUxtUOF+F2WtxfGHawW9Vol383R6bkS
	 CpE2Xj21KFopiRFjGUmd0tO3aScomA96vR9L15A4=
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
Subject: [PATCH 6.18 618/990] xsk: freeze deferred pool teardown without blocking unregister
Date: Wed, 25 Nov 2026 15:33:05 +0100
Message-ID: <20261125143836.575455922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced the missing netdev_assert_locked_ops_compat() with this tree's equivalent netdev_ops_assert_locked(), and dropped the old assertion before ndo_bpf() so it isn't duplicated. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h   |  5 ++++
 include/net/xsk_buff_pool.h |  3 +++
 net/xdp/xsk.c               |  5 ++++
 net/xdp/xsk_buff_pool.c     | 46 ++++++++++++++++++++++++++++++-------
 4 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f08d17f1d2e0a..d367760b902f1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2497,6 +2497,11 @@ struct net_device {
 	/* protected by rtnl_lock */
 	struct bpf_xdp_entity	xdp_state[__MAX_XDP_MODE];
 
+#ifdef CONFIG_XDP_SOCKETS
+	/** @xsk_pools: assigned AF_XDP pools, ops protected */
+	struct hlist_head	xsk_pools;
+#endif
+
 	u8 dev_addr_shadow[MAX_ADDR_LEN];
 	netdevice_tracker	linkwatch_dev_tracker;
 	netdevice_tracker	watchdog_dev_tracker;
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index a461bb63761b7..93b60d7294afb 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -48,6 +48,8 @@ struct xsk_buff_pool {
 	struct device *dev;
 	struct net_device *netdev;
 	struct list_head xsk_tx_list;
+	/* Assigned pools, including deferred releases; ops protected. */
+	struct hlist_node dev_node;
 	/* Protects modifications to the xsk_tx_list */
 	spinlock_t xsk_tx_list_lock;
 	refcount_t users;
@@ -124,6 +126,7 @@ bool xp_put_pool(struct xsk_buff_pool *pool);
 void xp_clear_dev(struct xsk_buff_pool *pool);
 void xp_add_xsk(struct xsk_buff_pool *pool, struct xdp_sock *xs);
 void xp_del_xsk(struct xsk_buff_pool *pool, struct xdp_sock *xs);
+void xp_clear_dev_all(struct net_device *dev);
 
 /* AF_XDP, and XDP core. */
 void xp_free(struct xdp_buff_xsk *xskb);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 5d2067777d351..b9008668b3fd8 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -2038,6 +2038,11 @@ static int xsk_notifier(struct notifier_block *this,
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
index 9dc1ff31867a1..f261a8879ea9e 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -182,7 +182,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	u32 frame_size;
 	int err = 0;
 
-	ASSERT_RTNL();
+	netdev_ops_assert_locked(netdev);
 
 	force_zc = flags & XDP_ZEROCOPY;
 	force_copy = flags & XDP_COPY;
@@ -211,6 +211,11 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	pool->cached_need_wakeup = XDP_WAKEUP_TX;
 
 	dev_hold(netdev);
+	/*
+	 * Socket removal precedes the final pool put. Keep the pool visible to
+	 * NETDEV_UNREGISTER even while release work is waiting for process thaw.
+	 */
+	hlist_add_head(&pool->dev_node, &netdev->xsk_pools);
 
 	if (force_copy)
 		/* For copy-mode, we are done. */
@@ -251,7 +256,6 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	bpf.xsk.pool = pool;
 	bpf.xsk.queue_id = queue_id;
 
-	netdev_ops_assert_locked(netdev);
 	err = netdev->netdev_ops->ndo_bpf(netdev, &bpf);
 	if (err)
 		goto err_unreg_pool;
@@ -273,6 +277,8 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	if (err) {
 		pool->umem->flags = umem_flags;
 		xsk_clear_pool_at_qid(netdev, queue_id);
+		hlist_del(&pool->dev_node);
+		pool->netdev = NULL;
 		dev_put(netdev);
 	}
 	return err;
@@ -299,19 +305,39 @@ int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
 	return xp_assign_dev(pool, dev, queue_id, flags);
 }
 
+static void __xp_clear_dev(struct xsk_buff_pool *pool)
+{
+	struct net_device *netdev = pool->netdev;
+
+	netdev_ops_assert_locked(netdev);
+	xp_disable_drv_zc(pool);
+	xsk_clear_pool_at_qid(netdev, pool->queue_id);
+	hlist_del(&pool->dev_node);
+	pool->netdev = NULL;
+	dev_put(netdev);
+}
+
 void xp_clear_dev(struct xsk_buff_pool *pool)
 {
 	struct net_device *netdev = pool->netdev;
 
-	if (!pool->netdev)
+	if (!netdev)
 		return;
 
 	netdev_lock_ops(netdev);
-	xp_disable_drv_zc(pool);
-	xsk_clear_pool_at_qid(pool->netdev, pool->queue_id);
-	pool->netdev = NULL;
+	__xp_clear_dev(pool);
 	netdev_unlock_ops(netdev);
-	dev_put(netdev);
+}
+
+void xp_clear_dev_all(struct net_device *dev)
+{
+	struct xsk_buff_pool *pool;
+	struct hlist_node *next;
+
+	netdev_lock_ops(dev);
+	hlist_for_each_entry_safe(pool, next, &dev->xsk_pools, dev_node)
+		__xp_clear_dev(pool);
+	netdev_unlock_ops(dev);
 }
 
 static void xp_release_deferred(struct work_struct *work)
@@ -349,7 +375,11 @@ bool xp_put_pool(struct xsk_buff_pool *pool)
 
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



