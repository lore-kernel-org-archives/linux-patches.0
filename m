Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705335;
	b=a098NBY+SikHCHJZW4kILIpABIlgKpHRaeBeC7dTBcXxnftNmMeQSuJXuhiPG/2x4lae
	 xzm7etQyBntMx1TIhyG1ufdIajA9Ue9Jy37+kYOYNao01boH3qzvGlYYksNtlxzKttwIk
	 5X7kH2iBEzYf/HSNHFJyxyQdRl+olVKDlU+Rl9E4jwpsrlqFJUQ0rAGW0hE4o1ThUuHLJ
	 vS71JqspAbXc7bEr+jweznrLVMfjVymosiNAtotYPDCOo20VIb1a7GeRDW5gvQ0qgPbnP
	 fBDGp44y1rBgXjolJLuqBm5sqzuB9DYElEsfOkjRZbT8RCYGWyuqvXQozbqyicxh3Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4L9jnopwies3jkYcnJyJgEtG4AQuJgERoEsMPpyMHFg=;
	b=3pzyXgB6p6we8zS6sPnpijnpVmXY/eHYrMQbIWs5gbyxKvbwBYHneQ7wWFVOlHF0ZzpF
	 /0XSK6kGgAT7KcJY+1Ti/cen7dcCRdIMLQZdariMMYXKuttUtiwbG3Kn/baKQ1dPwVnvG
	 icNY1No1kKBw05iBwyQRzoVoL93Z5zZxdhTo5l4XLiBcQqWfyBHisXA6Di1SBwmJ/Xx2z
	 aYS++MrB8Ab11/fa0NBvS7vZRcEVUnaXrzj+q5KruWMCXi7CNFCJHzd4ZBd6rWgwAR3fL
	 GM7Z6MrSIiczGy8rRokFKBfEM4GUAiROU2H5dTU4GDyq/dH0vcuI70PaEiYxAcUnO2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6gTX3Qh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09144606A31E;
	Thu, 26 Nov 2026 15:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6gTX3Qh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07C21F000D3;
	Thu, 26 Nov 2026 15:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705334;
	bh=4L9jnopwies3jkYcnJyJgEtG4AQuJgERoEsMPpyMHFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6gTX3QhkyLSkdsBvT4MT7jXgJstLqLL2wJVTXSPIkrhH5HVKJnwn+txAQhtW8utz
	 6QpR53bVaxknJi0DW5A+n/YWQoEX8cDPbbaz7sjkpMOZxdgMLWQrgL1lfmWhT3b26+
	 m07vVPwHPrXoTJJmvg/195v+lMOUQ7UvVxiu5HbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/319] net/mlx5e: IPoIB, Fix QPN lookup race
Date: Thu, 26 Nov 2026 15:38:14 +0100
Message-ID: <20261126144009.587222769@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

[ Upstream commit 29066b0fc046a2965129a74325b98d9abb4647a9 ]

The parent RX completion path can load a QPN hash entry before
mlx5i_pkey_del_qpn() unlinks and frees it, then dereference freed memory.

Use RCU hlist operations and defer freeing with kfree_rcu(). The existing
RCU read-side section in mlx5e_napi_poll() covers the lookup. Keep ht_lock
for writers and acquire it before looking up the entry to delete.

Fixes: 7e7f4780c340 ("net/mlx5e: IPoIB, Use hash-table to map between QPN to child netdev")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261031225749.14214-1-prathameshdeshpande7@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.h |  2 +-
 .../mellanox/mlx5/core/ipoib/ipoib_vlan.c     | 26 +++++++++++--------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
index 99d46fda9f82f..69a666d91c643 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
@@ -78,7 +78,7 @@ void mlx5i_pkey_qpn_ht_cleanup(struct net_device *netdev);
 int mlx5i_pkey_add_qpn(struct net_device *netdev, u32 qpn);
 int mlx5i_pkey_del_qpn(struct net_device *netdev, u32 qpn);
 
-/* Get the net-device corresponding to the given underlay QPN */
+/* Get the net-device for a QPN. Caller must hold rcu_read_lock(). */
 struct net_device *mlx5i_pkey_get_netdev(struct net_device *netdev, u32 qpn);
 
 /* Shared ndo functions */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 5308f23702bca..f0df52aa26a77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/hash.h>
+#include <linux/rculist.h>
 #include "ipoib.h"
 
 #define MLX5I_MAX_LOG_PKEY_SUP 7
@@ -39,11 +40,12 @@ struct qpn_to_netdev {
 	struct net_device *netdev;
 	struct hlist_node hlist;
 	u32 underlay_qpn;
+	struct rcu_head rcu;
 };
 
 struct mlx5i_pkey_qpn_ht {
 	struct hlist_head buckets[1 << MLX5I_MAX_LOG_PKEY_SUP];
-	spinlock_t ht_lock; /* Synchronise with NAPI */
+	spinlock_t ht_lock; /* Serialize hash table updates */
 };
 
 int mlx5i_pkey_qpn_ht_init(struct net_device *netdev)
@@ -68,13 +70,14 @@ void mlx5i_pkey_qpn_ht_cleanup(struct net_device *netdev)
 	kfree(ipriv->qpn_htbl);
 }
 
-static struct qpn_to_netdev *mlx5i_find_qpn_to_netdev_node(struct hlist_head *buckets,
-							   u32 qpn)
+static struct qpn_to_netdev *
+mlx5i_find_qpn_to_netdev_node(struct mlx5i_pkey_qpn_ht *ht, u32 qpn)
 {
-	struct hlist_head *h = &buckets[hash_32(qpn, MLX5I_MAX_LOG_PKEY_SUP)];
+	struct hlist_head *h = &ht->buckets[hash_32(qpn, MLX5I_MAX_LOG_PKEY_SUP)];
 	struct qpn_to_netdev *node;
 
-	hlist_for_each_entry(node, h, hlist) {
+	hlist_for_each_entry_rcu(node, h, hlist,
+				 lockdep_is_held(&ht->ht_lock)) {
 		if (node->underlay_qpn == qpn)
 			return node;
 	}
@@ -96,7 +99,7 @@ int mlx5i_pkey_add_qpn(struct net_device *netdev, u32 qpn)
 	new_node->netdev = netdev;
 	new_node->underlay_qpn = qpn;
 	spin_lock_bh(&ht->ht_lock);
-	hlist_add_head(&new_node->hlist, &ht->buckets[key]);
+	hlist_add_head_rcu(&new_node->hlist, &ht->buckets[key]);
 	spin_unlock_bh(&ht->ht_lock);
 
 	return 0;
@@ -109,16 +112,17 @@ int mlx5i_pkey_del_qpn(struct net_device *netdev, u32 qpn)
 	struct mlx5i_pkey_qpn_ht *ht = ipriv->qpn_htbl;
 	struct qpn_to_netdev *node;
 
-	node = mlx5i_find_qpn_to_netdev_node(ht->buckets, qpn);
+	spin_lock_bh(&ht->ht_lock);
+	node = mlx5i_find_qpn_to_netdev_node(ht, qpn);
 	if (!node) {
+		spin_unlock_bh(&ht->ht_lock);
 		mlx5_core_warn(epriv->mdev, "QPN to netdev delete from HT failed\n");
 		return -EINVAL;
 	}
 
-	spin_lock_bh(&ht->ht_lock);
-	hlist_del_init(&node->hlist);
+	hlist_del_rcu(&node->hlist);
 	spin_unlock_bh(&ht->ht_lock);
-	kfree(node);
+	kfree_rcu(node, rcu);
 
 	return 0;
 }
@@ -128,7 +132,7 @@ struct net_device *mlx5i_pkey_get_netdev(struct net_device *netdev, u32 qpn)
 	struct mlx5i_priv *ipriv = netdev_priv(netdev);
 	struct qpn_to_netdev *node;
 
-	node = mlx5i_find_qpn_to_netdev_node(ipriv->qpn_htbl->buckets, qpn);
+	node = mlx5i_find_qpn_to_netdev_node(ipriv->qpn_htbl, qpn);
 	if (!node)
 		return NULL;
 
-- 
2.53.0



