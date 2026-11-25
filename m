Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621757;
	b=2d/+UhwCIMOcQfV4NoJj/d8WbIUujd02kGdCUyABqDISHurD815C7z/teW+69OBwMyQ6
	 PcnxAt+NJKEZCaPInI5VUYXp5RN2rotJ8EzjirhH7gXMRHcI6lKijHE/bmqn/5UNNs8Nf
	 Yl3CIV53PMyqhb8MoPLvgQGQpnh0LUBAGSe8i/WgGnMwXNhWUgQoHNdR5uxz5RU0xkl3X
	 ArOuISOllpcK+vpeNmpQQOhg8oPASuc7+KaTuZL184jwxuMNQ2cCB/FI0zeOVUbkoyu61
	 8iOSjWaxDRaSsDdB/5kQl0k1TLk5GWM3hhPMvg9YdOJu3BuuI07zaNDlkALybfJpxug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dHlUmh3pOgQLcq2eu/yguJQexZrSoJFB26XGTReAPrc=;
	b=CjMQYQW5Vc9zjvneHZzTI/nkdVmWM8doNxXWTLGB5lFBVL6fRQ+2o8VS+wpY2Zpw0Qig
	 tT/5UEw5k9BV0lqepGGX6alL7nSG8YD/+PyEP4I/guQqXKhW58aflpDHUNirvju6+xRUu
	 6ZfeSHNY092U6W1q7X/S33z+jipxDDSGOdnDxvBdr4TFTSaJkH51SbaUbeM5yiBCkk+7r
	 9GZuj7t4mcnfzihJP/b2wAlwm+YtNiD8o2kMeUEjcUHbqV40roiLgF7fNzbnHYgrfAjob
	 /YjuNh8QwwaajIHgT1/ezaWXPAfaj9A6VjG89m8ysF5BqK8FmoYB7/ra7WRVo5hFYOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTt1z7sW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72AF606A329;
	Wed, 25 Nov 2026 15:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTt1z7sW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B391F000C0;
	Wed, 25 Nov 2026 15:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621757;
	bh=dHlUmh3pOgQLcq2eu/yguJQexZrSoJFB26XGTReAPrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTt1z7sWhcTIY2apvsy/ArmAmYNN7Afy0XZkhqGaC7tpCbEv03Mw0x785aiU23ZzX
	 l+S3vB5hGjaCts6AfVspDfsK4lGjiIrJdYBxNv82NZNIC9IYq7sUB/Gja0xbBWdER7
	 w4zPCAnbMVwniFhQNlQTkudHccuhj+Ttjfl9K8To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 327/990] net/mlx5e: IPoIB, Fix QPN lookup race
Date: Wed, 25 Nov 2026 15:28:14 +0100
Message-ID: <20261125143829.748059722@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2ab6437a1c49f..944549f8c2f60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
@@ -82,7 +82,7 @@ void mlx5i_pkey_qpn_ht_cleanup(struct net_device *netdev);
 int mlx5i_pkey_add_qpn(struct net_device *netdev, u32 qpn);
 int mlx5i_pkey_del_qpn(struct net_device *netdev, u32 qpn);
 
-/* Get the net-device corresponding to the given underlay QPN */
+/* Get the net-device for a QPN. Caller must hold rcu_read_lock(). */
 struct net_device *mlx5i_pkey_get_netdev(struct net_device *netdev, u32 qpn);
 
 /* Shared ndo functions */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 028a76944d82d..dd42633c52301 100644
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



