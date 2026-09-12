Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080DB417BD2;
	Sat, 12 Sep 2026 09:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204725; cv=none; b=Rch22mO5budbSr34jwDr+N/E54gqQ9tVsgTNXbbBLgypSqzEg4UUlEG9VgVB8jJLVoUMZcEmtSekJD2wRbWt5PwUdNfTacFSe15AjqvTmfUpeldRC4elt5zlLayABGQRELT/fOnVn4Em4wKoch78na+Ee7GO2A9W8PVfIZpb5VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204725; c=relaxed/simple;
	bh=ez4h1rHm1iOQW4XLtAd15+fTtBZaAVNV1qJ8x/Cn7L0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bX1Fu4I9gev9qZFAPdmJfLlI8Tz+bQ7uotO52zPvJ/wuZOpN7/MJY1L9wFGETvxMahnmLSAlPYzqh7Q9+OoJuMqCC0zFicNBRurnBaoqY0WyxyoTZifLneG69gHDslMwNBjoDAqdTamIFwvZxtDE5cZCdPGLv4PN9XuPpMJZ+8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHColDnK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHColDnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277AE1F000FF;
	Sat, 12 Sep 2026 09:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204722;
	bh=eUdHTE2Y4gDbco7em0p68+cxn6EDZ2ojU365qQr6H4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHColDnKBJOrTzTmHk5+vre4G33vluE5N+/8jB/eRCUZ8z2LqGr+t7W/kHSDk+Q1M
	 CO9DPYwYZZihOEAwtQt/WtFgghVh8qXexTAcpqdLUNx+McRD0ECRg9InZDSHpRBAyy
	 GZkcrOXFf3wqlOr1WHcjuUFennkvJydJp1iIRutI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1671/1815] net/mlx5: E-Switch, use state lock for vport state changes
Date: Sat, 12 Sep 2026 08:57:01 +0200
Message-ID: <20260912065728.217941756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit ff0f9b7aa1c756e24a8023eaf684e93774c64194 ]

Protect vport admin state modifications and vport iteration with the
eswitch state_lock mutex to ensure proper serialization of concurrent
vport state changes.

Currently, calls to mlx5_modify_vport_admin_state() and loops iterating
over eswitch vports can race with each other, potentially leading to
inconsistent vport state. Fix this by acquiring esw->state_lock

Fixes: 7d0314b11cdd ("net/mlx5e: Modify uplink state on interface up/down")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Or Har-Toov <ohartoov@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260816065015.3280733-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 20 ++++++++++++++-----
 .../mellanox/mlx5/core/esw/adj_vport.c        |  2 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     |  4 ++++
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c |  2 ++
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  8 ++++++++
 5 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index c8b76d301c92c..3d544fe4e6f73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -689,11 +689,13 @@ static int mlx5e_rep_open(struct net_device *dev)
 	if (err)
 		goto unlock;
 
+	mutex_lock(&rep->esw->state_lock);
 	if (!mlx5_modify_vport_admin_state(priv->mdev,
 					   MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 					   rep->vport, 1,
 					   MLX5_VPORT_ADMIN_STATE_UP))
 		netif_carrier_on(dev);
+	mutex_unlock(&rep->esw->state_lock);
 
 unlock:
 	mutex_unlock(&priv->state_lock);
@@ -708,10 +710,12 @@ static int mlx5e_rep_close(struct net_device *dev)
 	int ret;
 
 	mutex_lock(&priv->state_lock);
+	mutex_lock(&rep->esw->state_lock);
 	mlx5_modify_vport_admin_state(priv->mdev,
 				      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 				      rep->vport, 1,
 				      MLX5_VPORT_ADMIN_STATE_DOWN);
+	mutex_unlock(&rep->esw->state_lock);
 	ret = mlx5e_close_locked(dev);
 	mutex_unlock(&priv->state_lock);
 	return ret;
@@ -783,22 +787,25 @@ static int mlx5e_rep_change_carrier(struct net_device *dev, bool new_carrier)
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
-	int err;
+	int err = 0;
 
+	mutex_lock(&rep->esw->state_lock);
 	if (new_carrier) {
 		err = mlx5_modify_vport_admin_state(priv->mdev, MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 						    rep->vport, 1, MLX5_VPORT_ADMIN_STATE_UP);
 		if (err)
-			return err;
+			goto unlock;
 		netif_carrier_on(dev);
 	} else {
 		err = mlx5_modify_vport_admin_state(priv->mdev, MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 						    rep->vport, 1, MLX5_VPORT_ADMIN_STATE_DOWN);
 		if (err)
-			return err;
+			goto unlock;
 		netif_carrier_off(dev);
 	}
-	return 0;
+unlock:
+	mutex_unlock(&rep->esw->state_lock);
+	return err;
 }
 
 static const struct net_device_ops mlx5e_netdev_ops_rep = {
@@ -1337,9 +1344,12 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 
 	mlx5e_rep_tc_enable(priv);
 
-	if (MLX5_CAP_GEN(mdev, uplink_follow))
+	if (MLX5_CAP_GEN(mdev, uplink_follow)) {
+		mutex_lock(&mdev->priv.eswitch->state_lock);
 		mlx5_modify_vport_admin_state(mdev, MLX5_VPORT_STATE_OP_MOD_UPLINK,
 					      0, 0, MLX5_VPORT_ADMIN_STATE_AUTO);
+		mutex_unlock(&mdev->priv.eswitch->state_lock);
+	}
 	mlx5_lag_add_netdev(mdev, netdev);
 	priv->events_nb.notifier_call = uplink_rep_async_event;
 	mlx5_notifier_register(mdev, &priv->events_nb);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
index ca249b50f830a..3624c680a861a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
@@ -9,6 +9,8 @@ int mlx5_esw_adj_vport_modify(struct mlx5_core_dev *dev, u16 vport,
 {
 	u32 in[MLX5_ST_SZ_DW(modify_vport_state_in)] = {};
 
+	lockdep_assert_held(&dev->priv.eswitch->state_lock);
+
 	MLX5_SET(modify_vport_state_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_VPORT_STATE);
 	MLX5_SET(modify_vport_state_in, in, op_mod,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 247e5d85ec367..d603e294ee0e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2567,6 +2567,7 @@ static void mlx5_esw_fdb_active(struct mlx5_eswitch *esw)
 	mlx5_esw_fdb_drop_destroy(esw);
 	mlx5_mpfs_enable(esw->dev);
 
+	mutex_lock(&esw->state_lock);
 	mlx5_esw_for_each_vf_vport(esw, i, vport, U16_MAX) {
 		if (!vport->adjacent)
 			continue;
@@ -2574,6 +2575,7 @@ static void mlx5_esw_fdb_active(struct mlx5_eswitch *esw)
 			  vport->vport);
 		mlx5_esw_adj_vport_modify(esw->dev, vport->vport, true);
 	}
+	mutex_unlock(&esw->state_lock);
 
 	esw->offloads_inactive = false;
 	esw_warn(esw->dev, "MPFS/FDB active\n");
@@ -2587,6 +2589,7 @@ static void mlx5_esw_fdb_inactive(struct mlx5_eswitch *esw)
 	mlx5_mpfs_disable(esw->dev);
 	mlx5_esw_fdb_drop_create(esw);
 
+	mutex_lock(&esw->state_lock);
 	mlx5_esw_for_each_vf_vport(esw, i, vport, U16_MAX) {
 		if (!vport->adjacent)
 			continue;
@@ -2595,6 +2598,7 @@ static void mlx5_esw_fdb_inactive(struct mlx5_eswitch *esw)
 
 		mlx5_esw_adj_vport_modify(esw->dev, vport->vport, false);
 	}
+	mutex_unlock(&esw->state_lock);
 
 	esw->offloads_inactive = true;
 	esw_warn(esw->dev, "MPFS/FDB inactive\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 28d16fdc3f061..2285c889c215e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1471,6 +1471,7 @@ static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
 	if (!MLX5_CAP_ESW(mdev, esw_vport_state_max_tx_speed))
 		return;
 
+	mutex_lock(&esw->state_lock);
 	mlx5_esw_for_each_vport(esw, i, vport) {
 		if (!vport)
 			continue;
@@ -1490,6 +1491,7 @@ static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
 				      "Failed to set vport %d speed %d, err=%d\n",
 				      vport->vport, speed, ret);
 	}
+	mutex_unlock(&esw->state_lock);
 }
 
 void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 3676e26ac6b09..080f097b7bfa1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -89,6 +89,10 @@ int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 {
 	u32 in[MLX5_ST_SZ_DW(modify_vport_state_in)] = {};
 
+#ifdef CONFIG_MLX5_ESWITCH
+	lockdep_assert_held(&mdev->priv.eswitch->state_lock);
+#endif
+
 	MLX5_SET(modify_vport_state_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_VPORT_STATE);
 	MLX5_SET(modify_vport_state_in, in, op_mod, opmod);
@@ -106,6 +110,10 @@ int mlx5_modify_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 opmod,
 	u8 admin_state;
 	int err;
 
+#ifdef CONFIG_MLX5_ESWITCH
+	lockdep_assert_held(&mdev->priv.eswitch->state_lock);
+#endif
+
 	err = mlx5_query_vport_admin_state(mdev, opmod, vport, other_vport,
 					   &admin_state);
 	if (err)
-- 
2.53.0



