Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1727A1A9B48;
	Tue, 17 Jun 2025 16:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176489; cv=none; b=VvtODh3WPXELnZJyfBC/KLE6QHghmwoYORStmg3prSgA7O7XvMDjhU7gAg28q/gG4eqjHVM1nup5Dmi2y/Dj0BTHHvcOjPAKulSWjyzg4btGPFvLsNJ4P70JPMV/4ou3UNMDVRxQhHno9sDXoajutCffF8AUreitS8BCA2rHtic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176489; c=relaxed/simple;
	bh=gdPiSNv4ssWZ8AEE4KoC365of7PLTryrDoJu2WqEyBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+SCZ6TDiOTKufkte1ji84pab7mnbCPTa+e+/7Z3nIQnVXUHYFzRBUOC9qIFKSVfVojhDNYvaX18AboJLepVISrudYzcVsP/oWTqWvCD+1QRekh0fBMshaqFRmm44uOSc6TrbARYxZ+UIbCBdgsajMQtADSF6gcIhbvyo65DNg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBnKnAFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBnKnAFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A7FC4CEE3;
	Tue, 17 Jun 2025 16:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176489;
	bh=gdPiSNv4ssWZ8AEE4KoC365of7PLTryrDoJu2WqEyBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBnKnAFXieVkwNQSuVBZxT2Q8pySWiZazIaSpg2hxsLrQwSDUaiVAD3EH1CcrGFY2
	 qIS3mGQxFFadrA32S33k9FWE92CRzlHMGPDsgcK5B9J/xzGE4tXbkMMg60HmIOHGOy
	 i0P6Ti40wrpKSPV4b0/1FdBvWjMboJaIGJ3HKg5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 194/780] net/mlx5: Avoid using xso.real_dev unnecessarily
Date: Tue, 17 Jun 2025 17:18:22 +0200
Message-ID: <20250617152459.376198767@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit d79444e8c3d40b11f5e155e5591d53bd1e512e1f ]

xso.real_dev is the active device of an offloaded xfrm state and is
managed by bonding. As such, it's subject to change when states are
migrated to a new device. Using it in places other than
offloading/unoffloading the states is risky.

This commit saves the device into the driver-specific struct
mlx5e_ipsec_sa_entry and switches mlx5e_ipsec_init_macs() and
mlx5e_ipsec_netevent_event() to make use of it.

Additionally, mlx5e_xfrm_update_stats() used xso.real_dev to validate
that correct net locks are held. But in a bonding config, the net of the
master device is the same as the underlying devices, and the net is
already a local var, so use that instead.

The only remaining references to xso.real_dev are now in the
.xdo_dev_state_add() / .xdo_dev_state_delete() path.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: fd4e41ebf66c ("bonding: Mark active offloaded xfrm_states")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 16 +++++-----------
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h |  1 +
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 2dd842aac6fc4..626e525c0f0d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -259,8 +259,7 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 				  struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
-	struct xfrm_state *x = sa_entry->x;
-	struct net_device *netdev;
+	struct net_device *netdev = sa_entry->dev;
 	struct neighbour *n;
 	u8 addr[ETH_ALEN];
 	const void *pkey;
@@ -270,8 +269,6 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	    attrs->type != XFRM_DEV_OFFLOAD_PACKET)
 		return;
 
-	netdev = x->xso.real_dev;
-
 	mlx5_query_mac_address(mdev, addr);
 	switch (attrs->dir) {
 	case XFRM_DEV_OFFLOAD_IN:
@@ -713,6 +710,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 		return -ENOMEM;
 
 	sa_entry->x = x;
+	sa_entry->dev = netdev;
 	sa_entry->ipsec = ipsec;
 	/* Check if this SA is originated from acquire flow temporary SA */
 	if (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ)
@@ -855,8 +853,6 @@ static int mlx5e_ipsec_netevent_event(struct notifier_block *nb,
 	struct mlx5e_ipsec_sa_entry *sa_entry;
 	struct mlx5e_ipsec *ipsec;
 	struct neighbour *n = ptr;
-	struct net_device *netdev;
-	struct xfrm_state *x;
 	unsigned long idx;
 
 	if (event != NETEVENT_NEIGH_UPDATE || !(n->nud_state & NUD_VALID))
@@ -876,11 +872,9 @@ static int mlx5e_ipsec_netevent_event(struct notifier_block *nb,
 				continue;
 		}
 
-		x = sa_entry->x;
-		netdev = x->xso.real_dev;
 		data = sa_entry->work->data;
 
-		neigh_ha_snapshot(data->addr, n, netdev);
+		neigh_ha_snapshot(data->addr, n, sa_entry->dev);
 		queue_work(ipsec->wq, &sa_entry->work->work);
 	}
 
@@ -996,8 +990,8 @@ static void mlx5e_xfrm_update_stats(struct xfrm_state *x)
 	size_t headers;
 
 	lockdep_assert(lockdep_is_held(&x->lock) ||
-		       lockdep_is_held(&dev_net(x->xso.real_dev)->xfrm.xfrm_cfg_mutex) ||
-		       lockdep_is_held(&dev_net(x->xso.real_dev)->xfrm.xfrm_state_lock));
+		       lockdep_is_held(&net->xfrm.xfrm_cfg_mutex) ||
+		       lockdep_is_held(&net->xfrm.xfrm_state_lock));
 
 	if (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ)
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index a63c2289f8af9..ffcd0cdeb7754 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -274,6 +274,7 @@ struct mlx5e_ipsec_limits {
 struct mlx5e_ipsec_sa_entry {
 	struct mlx5e_ipsec_esn_state esn_state;
 	struct xfrm_state *x;
+	struct net_device *dev;
 	struct mlx5e_ipsec *ipsec;
 	struct mlx5_accel_esp_xfrm_attrs attrs;
 	void (*set_iv_op)(struct sk_buff *skb, struct xfrm_state *x,
-- 
2.39.5



