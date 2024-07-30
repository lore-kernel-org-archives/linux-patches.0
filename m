Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519761A6199;
	Tue, 30 Jul 2024 16:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356348; cv=none; b=so8KB7iOYHCuoEiG+hnp0yo0pCbWfKeRon+JjBTVBcN/r/HDYVNmBmmfotsu0LU+BJuG64mqPv7+BS2ykXZII0CT0cCj609VPvzABoIuNHheZWzdfjTYm2RSeympqhHhhULt4fIZ1OmCe406oB627UJsrqZzfDIumf/1cY4xHgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356348; c=relaxed/simple;
	bh=anf5YHf06j6gX/WOi/DYTmaowbREsX+Olm9ROdGYipU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAALJuI4ezVJ31NKxQQXmevOP04K8ZGki+n55Mifu5MfGlYeSfR5FW427HMmD7xBGshaxwwFPhxGaa+z8QKTqFO2pTDwg34ARFGV7SFSDYuKZdYC/CsYvlULPjRBqC2WMemSwIHSune8YkrSre9+Jq2k3EZAvNdpzd442Abk0co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6jU8shT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6jU8shT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB62DC32782;
	Tue, 30 Jul 2024 16:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356348;
	bh=anf5YHf06j6gX/WOi/DYTmaowbREsX+Olm9ROdGYipU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6jU8shT1D30MhuNhVcg9BEu7rE3z61KYjhiyx7PpBkoe0wxVIK2AsaQ1C5V8ycFu
	 m0jGvsaVDLEmTsf1gKBYMGwf1xFCP7ma1eJBx8Z5Ea0D4in+TPcH8VHU3GbgQ4wg7T
	 OQOgK0Sc8zX5BW0MANr3J+4GdbOIWI/2niYQdIZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/568] xfrm: Fix unregister netdevice hang on hardware offload.
Date: Tue, 30 Jul 2024 17:44:07 +0200
Message-ID: <20240730151645.350113072@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 07b87f9eea0c30675084d50c82532d20168da009 ]

When offloading xfrm states to hardware, the offloading
device is attached to the skbs secpath. If a skb is free
is deferred, an unregister netdevice hangs because the
netdevice is still refcounted.

Fix this by removing the netdevice from the xfrm states
when the netdevice is unregistered. To find all xfrm states
that need to be cleared we add another list where skbs
linked to that are unlinked from the lists (deleted)
but not yet freed.

Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h    | 36 +++++++------------------
 net/xfrm/xfrm_state.c | 61 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 69 insertions(+), 28 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index a3fd2cfed5e33..b280e7c460116 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -176,7 +176,10 @@ struct xfrm_state {
 		struct hlist_node	gclist;
 		struct hlist_node	bydst;
 	};
-	struct hlist_node	bysrc;
+	union {
+		struct hlist_node	dev_gclist;
+		struct hlist_node	bysrc;
+	};
 	struct hlist_node	byspi;
 	struct hlist_node	byseq;
 
@@ -1584,7 +1587,7 @@ int xfrm_state_check_expire(struct xfrm_state *x);
 static inline void xfrm_dev_state_update_curlft(struct xfrm_state *x)
 {
 	struct xfrm_dev_offload *xdo = &x->xso;
-	struct net_device *dev = xdo->dev;
+	struct net_device *dev = READ_ONCE(xdo->dev);
 
 	if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
 		return;
@@ -1943,13 +1946,16 @@ int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
 			struct xfrm_user_offload *xuo, u8 dir,
 			struct netlink_ext_ack *extack);
 bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x);
+void xfrm_dev_state_delete(struct xfrm_state *x);
+void xfrm_dev_state_free(struct xfrm_state *x);
 
 static inline void xfrm_dev_state_advance_esn(struct xfrm_state *x)
 {
 	struct xfrm_dev_offload *xso = &x->xso;
+	struct net_device *dev = READ_ONCE(xso->dev);
 
-	if (xso->dev && xso->dev->xfrmdev_ops->xdo_dev_state_advance_esn)
-		xso->dev->xfrmdev_ops->xdo_dev_state_advance_esn(x);
+	if (dev && dev->xfrmdev_ops->xdo_dev_state_advance_esn)
+		dev->xfrmdev_ops->xdo_dev_state_advance_esn(x);
 }
 
 static inline bool xfrm_dst_offload_ok(struct dst_entry *dst)
@@ -1970,28 +1976,6 @@ static inline bool xfrm_dst_offload_ok(struct dst_entry *dst)
 	return false;
 }
 
-static inline void xfrm_dev_state_delete(struct xfrm_state *x)
-{
-	struct xfrm_dev_offload *xso = &x->xso;
-
-	if (xso->dev)
-		xso->dev->xfrmdev_ops->xdo_dev_state_delete(x);
-}
-
-static inline void xfrm_dev_state_free(struct xfrm_state *x)
-{
-	struct xfrm_dev_offload *xso = &x->xso;
-	struct net_device *dev = xso->dev;
-
-	if (dev && dev->xfrmdev_ops) {
-		if (dev->xfrmdev_ops->xdo_dev_state_free)
-			dev->xfrmdev_ops->xdo_dev_state_free(x);
-		xso->dev = NULL;
-		xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
-		netdev_put(dev, &xso->dev_tracker);
-	}
-}
-
 static inline void xfrm_dev_policy_delete(struct xfrm_policy *x)
 {
 	struct xfrm_dev_offload *xdo = &x->xdo;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index bda5327bf34df..e5308bb75eea2 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -49,6 +49,7 @@ static struct kmem_cache *xfrm_state_cache __ro_after_init;
 
 static DECLARE_WORK(xfrm_state_gc_work, xfrm_state_gc_task);
 static HLIST_HEAD(xfrm_state_gc_list);
+static HLIST_HEAD(xfrm_state_dev_gc_list);
 
 static inline bool xfrm_state_hold_rcu(struct xfrm_state __rcu *x)
 {
@@ -214,6 +215,7 @@ static DEFINE_SPINLOCK(xfrm_state_afinfo_lock);
 static struct xfrm_state_afinfo __rcu *xfrm_state_afinfo[NPROTO];
 
 static DEFINE_SPINLOCK(xfrm_state_gc_lock);
+static DEFINE_SPINLOCK(xfrm_state_dev_gc_lock);
 
 int __xfrm_state_delete(struct xfrm_state *x);
 
@@ -683,6 +685,40 @@ struct xfrm_state *xfrm_state_alloc(struct net *net)
 }
 EXPORT_SYMBOL(xfrm_state_alloc);
 
+#ifdef CONFIG_XFRM_OFFLOAD
+void xfrm_dev_state_delete(struct xfrm_state *x)
+{
+	struct xfrm_dev_offload *xso = &x->xso;
+	struct net_device *dev = READ_ONCE(xso->dev);
+
+	if (dev) {
+		dev->xfrmdev_ops->xdo_dev_state_delete(x);
+		spin_lock_bh(&xfrm_state_dev_gc_lock);
+		hlist_add_head(&x->dev_gclist, &xfrm_state_dev_gc_list);
+		spin_unlock_bh(&xfrm_state_dev_gc_lock);
+	}
+}
+
+void xfrm_dev_state_free(struct xfrm_state *x)
+{
+	struct xfrm_dev_offload *xso = &x->xso;
+	struct net_device *dev = READ_ONCE(xso->dev);
+
+	if (dev && dev->xfrmdev_ops) {
+		spin_lock_bh(&xfrm_state_dev_gc_lock);
+		if (!hlist_unhashed(&x->dev_gclist))
+			hlist_del(&x->dev_gclist);
+		spin_unlock_bh(&xfrm_state_dev_gc_lock);
+
+		if (dev->xfrmdev_ops->xdo_dev_state_free)
+			dev->xfrmdev_ops->xdo_dev_state_free(x);
+		WRITE_ONCE(xso->dev, NULL);
+		xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
+		netdev_put(dev, &xso->dev_tracker);
+	}
+}
+#endif
+
 void __xfrm_state_destroy(struct xfrm_state *x, bool sync)
 {
 	WARN_ON(x->km.state != XFRM_STATE_DEAD);
@@ -848,6 +884,9 @@ EXPORT_SYMBOL(xfrm_state_flush);
 
 int xfrm_dev_state_flush(struct net *net, struct net_device *dev, bool task_valid)
 {
+	struct xfrm_state *x;
+	struct hlist_node *tmp;
+	struct xfrm_dev_offload *xso;
 	int i, err = 0, cnt = 0;
 
 	spin_lock_bh(&net->xfrm.xfrm_state_lock);
@@ -857,8 +896,6 @@ int xfrm_dev_state_flush(struct net *net, struct net_device *dev, bool task_vali
 
 	err = -ESRCH;
 	for (i = 0; i <= net->xfrm.state_hmask; i++) {
-		struct xfrm_state *x;
-		struct xfrm_dev_offload *xso;
 restart:
 		hlist_for_each_entry(x, net->xfrm.state_bydst+i, bydst) {
 			xso = &x->xso;
@@ -868,6 +905,8 @@ int xfrm_dev_state_flush(struct net *net, struct net_device *dev, bool task_vali
 				spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 
 				err = xfrm_state_delete(x);
+				xfrm_dev_state_free(x);
+
 				xfrm_audit_state_delete(x, err ? 0 : 1,
 							task_valid);
 				xfrm_state_put(x);
@@ -884,6 +923,24 @@ int xfrm_dev_state_flush(struct net *net, struct net_device *dev, bool task_vali
 
 out:
 	spin_unlock_bh(&net->xfrm.xfrm_state_lock);
+
+	spin_lock_bh(&xfrm_state_dev_gc_lock);
+restart_gc:
+	hlist_for_each_entry_safe(x, tmp, &xfrm_state_dev_gc_list, dev_gclist) {
+		xso = &x->xso;
+
+		if (xso->dev == dev) {
+			spin_unlock_bh(&xfrm_state_dev_gc_lock);
+			xfrm_dev_state_free(x);
+			spin_lock_bh(&xfrm_state_dev_gc_lock);
+			goto restart_gc;
+		}
+
+	}
+	spin_unlock_bh(&xfrm_state_dev_gc_lock);
+
+	xfrm_flush_gc();
+
 	return err;
 }
 EXPORT_SYMBOL(xfrm_dev_state_flush);
-- 
2.43.0



