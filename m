Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFCC1D61B5;
	Wed, 19 Feb 2025 08:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954539; cv=none; b=YtOAgLRkpNzW9jvX5AVlW5bk8uvlUg6eSPyjOOOnbsykr/H9cckF5I/NmUTSyVxTf5A1RzYpbf5B9DfW+OD+XgMapAInoIoaWT3PlYaug1YW5UoDv2FGXX+QdOx1STcvqkOyNO7RZiznamvphl+JZn2uOmXD+76q3x1h8vqfj5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954539; c=relaxed/simple;
	bh=iFvyO7hn/9d/di+32csyAWkw5kxy8VdD9X5GWOpYQsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bt8llWX5FM/24sIpa+aRlvi1k2Bfl4xA4gdaWYfJO1WJntPqFq+s8vvmKkljbgsQ+OJbzzP0nd6fMaCvzu9pT0XKxZNqmkLsNAjUo9lY9mz4pzo1FxzffkLaBNEFUyqs4OdVFLLLk+7xXHIrJ9lP3ePV1yZr9JInCqfOIXA+3EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NT6fVGTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NT6fVGTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBC5C4CED1;
	Wed, 19 Feb 2025 08:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954539;
	bh=iFvyO7hn/9d/di+32csyAWkw5kxy8VdD9X5GWOpYQsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NT6fVGTXFoNLfpKUwUnWulXOh+zG/VrHT6+SAnlukQdp34/r0mkh0gPXT2gvw4FSO
	 BbzfMbUY6NhVaHOQIjaVHZsc7jXJYhD3gGyuU8AK2liXMunAaNVsvXEipZ+OOlj381
	 XKREal8aEAZAHYia4HPFxPfSJgh64AyOCshpl1wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 234/274] net: protect netdev->napi_list with netdev_lock()
Date: Wed, 19 Feb 2025 09:28:08 +0100
Message-ID: <20250219082618.736918558@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1b23cdbd2bbc4b40e21c12ae86c2781e347ff0f8 ]

Hold netdev->lock when NAPIs are getting added or removed.
This will allow safe access to NAPI instances of a net_device
without rtnl_lock.

Create a family of helpers which assume the lock is already taken.
Switch iavf to them, as it makes extensive use of netdev->lock,
already.

Reviewed-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250115035319.559603-6-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 011b03359038 ("Revert "net: skb: introduce and use a single page frag cache"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c |  6 +--
 include/linux/netdevice.h                   | 54 ++++++++++++++++++---
 net/core/dev.c                              | 15 ++++--
 3 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 72314b0a1b25b..4639f55a17be1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1815,8 +1815,8 @@ static int iavf_alloc_q_vectors(struct iavf_adapter *adapter)
 		q_vector->v_idx = q_idx;
 		q_vector->reg_idx = q_idx;
 		cpumask_copy(&q_vector->affinity_mask, cpu_possible_mask);
-		netif_napi_add(adapter->netdev, &q_vector->napi,
-			       iavf_napi_poll);
+		netif_napi_add_locked(adapter->netdev, &q_vector->napi,
+				      iavf_napi_poll);
 	}
 
 	return 0;
@@ -1842,7 +1842,7 @@ static void iavf_free_q_vectors(struct iavf_adapter *adapter)
 	for (q_idx = 0; q_idx < num_q_vectors; q_idx++) {
 		struct iavf_q_vector *q_vector = &adapter->q_vectors[q_idx];
 
-		netif_napi_del(&q_vector->napi);
+		netif_napi_del_locked(&q_vector->napi);
 	}
 	kfree(adapter->q_vectors);
 	adapter->q_vectors = NULL;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 64013fd389f28..7966a3d0e5bbc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2454,7 +2454,7 @@ struct net_device {
 	 * Drivers are free to use it for other protection.
 	 *
 	 * Protects:
-	 *	@net_shaper_hierarchy, @reg_state
+	 *	@napi_list, @net_shaper_hierarchy, @reg_state
 	 *
 	 * Partially protects (writers must hold both @lock and rtnl_lock):
 	 *	@up
@@ -2714,8 +2714,19 @@ static inline void netif_napi_set_irq(struct napi_struct *napi, int irq)
  */
 #define NAPI_POLL_WEIGHT 64
 
-void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
-			   int (*poll)(struct napi_struct *, int), int weight);
+void netif_napi_add_weight_locked(struct net_device *dev,
+				  struct napi_struct *napi,
+				  int (*poll)(struct napi_struct *, int),
+				  int weight);
+
+static inline void
+netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
+		      int (*poll)(struct napi_struct *, int), int weight)
+{
+	netdev_lock(dev);
+	netif_napi_add_weight_locked(dev, napi, poll, weight);
+	netdev_unlock(dev);
+}
 
 /**
  * netif_napi_add() - initialize a NAPI context
@@ -2733,6 +2744,13 @@ netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 	netif_napi_add_weight(dev, napi, poll, NAPI_POLL_WEIGHT);
 }
 
+static inline void
+netif_napi_add_locked(struct net_device *dev, struct napi_struct *napi,
+		      int (*poll)(struct napi_struct *, int))
+{
+	netif_napi_add_weight_locked(dev, napi, poll, NAPI_POLL_WEIGHT);
+}
+
 static inline void
 netif_napi_add_tx_weight(struct net_device *dev,
 			 struct napi_struct *napi,
@@ -2743,6 +2761,15 @@ netif_napi_add_tx_weight(struct net_device *dev,
 	netif_napi_add_weight(dev, napi, poll, weight);
 }
 
+static inline void
+netif_napi_add_config_locked(struct net_device *dev, struct napi_struct *napi,
+			     int (*poll)(struct napi_struct *, int), int index)
+{
+	napi->index = index;
+	napi->config = &dev->napi_config[index];
+	netif_napi_add_weight_locked(dev, napi, poll, NAPI_POLL_WEIGHT);
+}
+
 /**
  * netif_napi_add_config - initialize a NAPI context with persistent config
  * @dev: network device
@@ -2754,9 +2781,9 @@ static inline void
 netif_napi_add_config(struct net_device *dev, struct napi_struct *napi,
 		      int (*poll)(struct napi_struct *, int), int index)
 {
-	napi->index = index;
-	napi->config = &dev->napi_config[index];
-	netif_napi_add_weight(dev, napi, poll, NAPI_POLL_WEIGHT);
+	netdev_lock(dev);
+	netif_napi_add_config_locked(dev, napi, poll, index);
+	netdev_unlock(dev);
 }
 
 /**
@@ -2776,6 +2803,8 @@ static inline void netif_napi_add_tx(struct net_device *dev,
 	netif_napi_add_tx_weight(dev, napi, poll, NAPI_POLL_WEIGHT);
 }
 
+void __netif_napi_del_locked(struct napi_struct *napi);
+
 /**
  *  __netif_napi_del - remove a NAPI context
  *  @napi: NAPI context
@@ -2784,7 +2813,18 @@ static inline void netif_napi_add_tx(struct net_device *dev,
  * containing @napi. Drivers might want to call this helper to combine
  * all the needed RCU grace periods into a single one.
  */
-void __netif_napi_del(struct napi_struct *napi);
+static inline void __netif_napi_del(struct napi_struct *napi)
+{
+	netdev_lock(napi->dev);
+	__netif_napi_del_locked(napi);
+	netdev_unlock(napi->dev);
+}
+
+static inline void netif_napi_del_locked(struct napi_struct *napi)
+{
+	__netif_napi_del_locked(napi);
+	synchronize_net();
+}
 
 /**
  *  netif_napi_del - remove a NAPI context
diff --git a/net/core/dev.c b/net/core/dev.c
index 67f2bb84db543..26cce0504f105 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6783,9 +6783,12 @@ netif_napi_dev_list_add(struct net_device *dev, struct napi_struct *napi)
 	list_add_rcu(&napi->dev_list, higher); /* adds after higher */
 }
 
-void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
-			   int (*poll)(struct napi_struct *, int), int weight)
+void netif_napi_add_weight_locked(struct net_device *dev,
+				  struct napi_struct *napi,
+				  int (*poll)(struct napi_struct *, int),
+				  int weight)
 {
+	netdev_assert_locked(dev);
 	if (WARN_ON(test_and_set_bit(NAPI_STATE_LISTED, &napi->state)))
 		return;
 
@@ -6826,7 +6829,7 @@ void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 		dev->threaded = false;
 	netif_napi_set_irq(napi, -1);
 }
-EXPORT_SYMBOL(netif_napi_add_weight);
+EXPORT_SYMBOL(netif_napi_add_weight_locked);
 
 void napi_disable(struct napi_struct *n)
 {
@@ -6897,8 +6900,10 @@ static void flush_gro_hash(struct napi_struct *napi)
 }
 
 /* Must be called in process context */
-void __netif_napi_del(struct napi_struct *napi)
+void __netif_napi_del_locked(struct napi_struct *napi)
 {
+	netdev_assert_locked(napi->dev);
+
 	if (!test_and_clear_bit(NAPI_STATE_LISTED, &napi->state))
 		return;
 
@@ -6918,7 +6923,7 @@ void __netif_napi_del(struct napi_struct *napi)
 		napi->thread = NULL;
 	}
 }
-EXPORT_SYMBOL(__netif_napi_del);
+EXPORT_SYMBOL(__netif_napi_del_locked);
 
 static int __napi_poll(struct napi_struct *n, bool *repoll)
 {
-- 
2.39.5



