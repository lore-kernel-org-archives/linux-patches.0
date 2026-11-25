Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618850;
	b=XBHNkV2O+RWVMB1/wfVB52TktDFvoWz78n8hJhpItL3vHnONe6kEIt5TbJPNaByhCVNj
	 SO16d3xH1j/CI4hDlrAiY44uFs+fJ5/8yQtfAv8GnwI7u9fyaFslZ14Y7Jf1+FPD93nrf
	 8hFKW/kJEKq4QQd6xqrdVDi3LaUm77O+HyMjg9JJyCmmtdPSx5QP+K7gmzZm+ljDwkX/p
	 v6qWSUH1bBDU3gl5nl3c240rg/Iqa+Pf8D4vCrRcvs0BaNttmf9f8TalLUS1yG8cO4tNm
	 +K82Y2kmaRIyOlvt1u+i7JA+0IRhwOlyCSZAXvsXFiNILfePbF4/vqp8xi/duGjDJQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fXwLxiyzj+mtFzKqiCdssW5E490G8ZB38dLKiVW5i+E=;
	b=HTYn905q06nWH3Ut19jj14HauDz2cI53Ix07IwlqPVv+lIEARTHRbketIARIU101eoQg
	 uAWVz6tCe8GQ/4jILTviydNL4LOKkW/+mR6zbQBjHVG1szN5bv1E7cHKP83vwcVSKagVD
	 M/5T2u+oDVCsnuGQ36V04rji4GNwtbxHVHGz+1D+u81/NyIyoeaO/yRuIS/vhlLwT7I7H
	 dbjV6XkGnmDkv7ew0cZZfdD3ZMGjuDJAs+5FI3MSnvBW6xWV/C2mpGBIh40JQttpdHKQs
	 P1LjY49ACHa1vB0y/hEaARCPAxIPHTAxLzw8ZpNWNujvt831JV7AcNhOS18yK4Yb10Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2eSq93XB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21D6606A326;
	Wed, 25 Nov 2026 15:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2eSq93XB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F8C1F000C4;
	Wed, 25 Nov 2026 15:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618849;
	bh=fXwLxiyzj+mtFzKqiCdssW5E490G8ZB38dLKiVW5i+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2eSq93XBaBY9hqG4MD9IyvUTSG/OwcNo37N11nwAAcpj+oVYzTpBOeVlOB6HX3kWa
	 mZVkiLMHnhWTmJ8qrrtEFYJtdA5DW2pbJuW+Ary2gWI1YjNNAa4pRxZFqibg509Tws
	 2N7vfvTYR2RgAdlArgeSAq1BTtyQDE6LTHbyoiBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0363/1005] net/mlx5e: IPoIB, Fix QPN lookup race
Date: Wed, 25 Nov 2026 15:28:21 +0100
Message-ID: <20261125143830.235921743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d67d5a72bb419..8c0039c5425e2 100644
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
index 4120afd097c36..5edc392475251 100644
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



