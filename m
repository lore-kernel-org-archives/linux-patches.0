Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0AC4BEE32;
	Sat, 12 Sep 2026 11:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211963; cv=none; b=aBkDqGl0RItnx6wlxRBnbb2TUVAOBIgbZ3ZY8Zt0poCZxGApbrzjsMggc5d9QvnQrDJJtPBbuuUZF4mu3d0gkeJbLah7L+cmaCE0ihoZ+tqWedcq8pHjs7ESb4JvFuPDH2GYDRuEW+19VuIpubYiBPpx2hoIztaCJsNWR3xNX9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211963; c=relaxed/simple;
	bh=QiCUHr/c1S/amr0QvfWjfvkO8vpiLycd8YnvUzt2GX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJz9sJqMX65WtbqeH4apVaomHUmlsigrNXx36y40P+9HqeGm8KtlrglDZ7tP0qkHkdA58dL0f2PQxtcr2VNXkuIByz3pwE2zNxvTEB5PQx1uYDRPGvpife46iKzAZtGmJClNGMmiJxoHW7mG6DBo9+rLJM4Ih41bv9ypB4hGvsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Is/qT/ZJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Is/qT/ZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603D71F000FF;
	Sat, 12 Sep 2026 11:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211962;
	bh=x7rs+fDAaTmulto3qhRiM49M90r8hjhYMe6KCQI+WWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Is/qT/ZJ1Cec9U21doUuYBVEwD9sgBz66Qh7ZAG0PyUypwUvtznPp5ZgoJJtu/5vy
	 mU5Di1B1bpKCEShnnS9cFXuaRNeaIZXWiRd8SMO4k8h9YQJSj0MceM+AN705lVR3lW
	 jD+10ILzzyYr0R6Nr0aBgx1EfGDzyVNYz/57Z1yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1340/1518] net/mlx5: Handle port and vport speed change events in MPESW
Date: Sat, 12 Sep 2026 08:58:29 +0200
Message-ID: <20260912065653.840757876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 28ea6036dad268a055b693d9c06a6f3d126096d3 ]

Add port change event handling logic for MPESW LAG mode, ensuring
VFs are updated when the speed of LAG physical ports changes.
This triggers a speed update workflow when relevant port state changes
occur, enabling consistent and accurate reporting of VF bandwidth.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: ad0ae7aefa7a ("net/mlx5: E-Switch, preserve max tx speed on vport state modification")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 38 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  2 +
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   | 39 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/lag/mpesw.h   | 14 +++++++
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 29 ++++++++++++++
 include/linux/mlx5/driver.h                   |  1 +
 include/linux/mlx5/vport.h                    |  2 +
 7 files changed, 121 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 4f0b202fc5bd9..c3c9c3462c978 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -233,14 +233,25 @@ static void mlx5_ldev_free(struct kref *ref)
 {
 	struct mlx5_lag *ldev = container_of(ref, struct mlx5_lag, ref);
 	struct net *net;
+	int i;
 
 	if (ldev->nb.notifier_call) {
 		net = read_pnet(&ldev->net);
 		unregister_netdevice_notifier_net(net, &ldev->nb);
 	}
 
+	mlx5_ldev_for_each(i, 0, ldev) {
+		if (ldev->pf[i].dev &&
+		    ldev->pf[i].port_change_nb.nb.notifier_call) {
+			struct mlx5_nb *nb = &ldev->pf[i].port_change_nb;
+
+			mlx5_eq_notifier_unregister(ldev->pf[i].dev, nb);
+		}
+	}
+
 	mlx5_lag_mp_cleanup(ldev);
 	cancel_delayed_work_sync(&ldev->bond_work);
+	cancel_work_sync(&ldev->speed_update_work);
 	destroy_workqueue(ldev->wq);
 	mutex_destroy(&ldev->lock);
 	kfree(ldev);
@@ -274,6 +285,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 	kref_init(&ldev->ref);
 	mutex_init(&ldev->lock);
 	INIT_DELAYED_WORK(&ldev->bond_work, mlx5_do_bond_work);
+	INIT_WORK(&ldev->speed_update_work, mlx5_mpesw_speed_update_work);
 
 	ldev->nb.notifier_call = mlx5_lag_netdev_event;
 	write_pnet(&ldev->net, mlx5_core_net(dev));
@@ -1033,6 +1045,13 @@ static int mlx5_lag_sum_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
 					  mlx5_port_max_linkspeed);
 }
 
+static int mlx5_lag_sum_devices_oper_speed(struct mlx5_lag *ldev,
+					   u32 *oper_speed)
+{
+	return mlx5_lag_sum_devices_speed(ldev, oper_speed,
+					  mlx5_port_oper_linkspeed);
+}
+
 static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
 						u32 speed)
 {
@@ -1072,10 +1091,14 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
 	u32 speed;
 	int pf_idx;
 
-	speed = ldev->tracker.bond_speed_mbps;
-
-	if (speed == SPEED_UNKNOWN)
-		return;
+	if (ldev->mode == MLX5_LAG_MODE_MPESW) {
+		if (mlx5_lag_sum_devices_oper_speed(ldev, &speed))
+			return;
+	} else {
+		speed = ldev->tracker.bond_speed_mbps;
+		if (speed == SPEED_UNKNOWN)
+			return;
+	}
 
 	/* If speed is not set, use the sum of max speeds of all PFs */
 	if (!speed && mlx5_lag_sum_devices_max_speed(ldev, &speed))
@@ -1522,6 +1545,10 @@ static void mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
 
 	ldev->pf[fn].dev = dev;
 	dev->priv.lag = ldev;
+
+	MLX5_NB_INIT(&ldev->pf[fn].port_change_nb,
+		     mlx5_lag_mpesw_port_change_event, PORT_CHANGE);
+	mlx5_eq_notifier_register(dev, &ldev->pf[fn].port_change_nb);
 }
 
 static void mlx5_ldev_remove_mdev(struct mlx5_lag *ldev,
@@ -1533,6 +1560,9 @@ static void mlx5_ldev_remove_mdev(struct mlx5_lag *ldev,
 	if (ldev->pf[fn].dev != dev)
 		return;
 
+	if (ldev->pf[fn].port_change_nb.nb.notifier_call)
+		mlx5_eq_notifier_unregister(dev, &ldev->pf[fn].port_change_nb);
+
 	ldev->pf[fn].dev = NULL;
 	dev->priv.lag = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 8de5640a01617..be1afece5fdc1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -39,6 +39,7 @@ struct lag_func {
 	struct mlx5_core_dev *dev;
 	struct net_device    *netdev;
 	bool has_drop;
+	struct mlx5_nb port_change_nb;
 };
 
 /* Used for collection of netdev event info. */
@@ -67,6 +68,7 @@ struct mlx5_lag {
 	struct lag_tracker        tracker;
 	struct workqueue_struct   *wq;
 	struct delayed_work       bond_work;
+	struct work_struct        speed_update_work;
 	struct notifier_block     nb;
 	possible_net_t net;
 	struct lag_mp             lag_mp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index fc914ee259869..567e51f0e5dad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -110,6 +110,8 @@ static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 			goto err_rescan_drivers;
 	}
 
+	mlx5_lag_set_vports_agg_speed(ldev);
+
 	return 0;
 
 err_rescan_drivers:
@@ -226,3 +228,40 @@ bool mlx5_lag_is_mpesw(struct mlx5_core_dev *dev)
 	return ldev && ldev->mode == MLX5_LAG_MODE_MPESW;
 }
 EXPORT_SYMBOL(mlx5_lag_is_mpesw);
+
+void mlx5_mpesw_speed_update_work(struct work_struct *work)
+{
+	struct mlx5_lag *ldev = container_of(work, struct mlx5_lag,
+					     speed_update_work);
+
+	mutex_lock(&ldev->lock);
+	if (ldev->mode == MLX5_LAG_MODE_MPESW) {
+		if (ldev->mode_changes_in_progress)
+			queue_work(ldev->wq, &ldev->speed_update_work);
+		else
+			mlx5_lag_set_vports_agg_speed(ldev);
+	}
+
+	mutex_unlock(&ldev->lock);
+}
+
+int mlx5_lag_mpesw_port_change_event(struct notifier_block *nb,
+				     unsigned long event, void *data)
+{
+	struct mlx5_nb *mlx5_nb = container_of(nb, struct mlx5_nb, nb);
+	struct lag_func *lag_func = container_of(mlx5_nb,
+						 struct lag_func,
+						 port_change_nb);
+	struct mlx5_core_dev *dev = lag_func->dev;
+	struct mlx5_lag *ldev = dev->priv.lag;
+	struct mlx5_eqe *eqe = data;
+
+	if (!ldev)
+		return NOTIFY_DONE;
+
+	if (eqe->sub_type == MLX5_PORT_CHANGE_SUBTYPE_DOWN ||
+	    eqe->sub_type == MLX5_PORT_CHANGE_SUBTYPE_ACTIVE)
+		queue_work(ldev->wq, &ldev->speed_update_work);
+
+	return NOTIFY_OK;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
index 46de93ed790de..b767dbb4f4571 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
@@ -37,4 +37,18 @@ void mlx5_lag_disable_mpesw(struct mlx5_lag *ldev);
 static inline void mlx5_lag_disable_mpesw(struct mlx5_lag *ldev) {}
 #endif /* CONFIG_MLX5_ESWITCH */
 
+#ifdef CONFIG_MLX5_ESWITCH
+void mlx5_mpesw_speed_update_work(struct work_struct *work);
+int mlx5_lag_mpesw_port_change_event(struct notifier_block *nb,
+				     unsigned long event, void *data);
+#else
+static inline void mlx5_mpesw_speed_update_work(struct work_struct *work) {}
+static inline int mlx5_lag_mpesw_port_change_event(struct notifier_block *nb,
+						   unsigned long event,
+						   void *data)
+{
+	return NOTIFY_DONE;
+}
+#endif /* CONFIG_MLX5_ESWITCH */
+
 #endif /* __MLX5_LAG_MPESW_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index a4162cdc0b838..93bd19b9c6f9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -130,6 +130,35 @@ int mlx5_modify_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 opmod,
 	return mlx5_cmd_exec_in(mdev, modify_vport_state, in);
 }
 
+int mlx5_query_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 op_mod,
+				  u16 vport, u8 other_vport, u32 *max_tx_speed)
+{
+	u32 out[MLX5_ST_SZ_DW(query_vport_state_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_vport_state_in)] = {};
+	u32 state;
+	int err;
+
+	MLX5_SET(query_vport_state_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_VPORT_STATE);
+	MLX5_SET(query_vport_state_in, in, op_mod, op_mod);
+	MLX5_SET(query_vport_state_in, in, vport_number, vport);
+	MLX5_SET(query_vport_state_in, in, other_vport, other_vport);
+
+	err = mlx5_cmd_exec_inout(mdev, query_vport_state, in, out);
+	if (err)
+		return err;
+
+	state = MLX5_GET(query_vport_state_out, out, state);
+	if (state == VPORT_STATE_DOWN) {
+		*max_tx_speed = 0;
+		return 0;
+	}
+
+	*max_tx_speed = MLX5_GET(query_vport_state_out, out, max_tx_speed);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx5_query_vport_max_tx_speed);
+
 static int mlx5_query_nic_vport_context(struct mlx5_core_dev *mdev, u16 vport,
 					u32 *out)
 {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 85c2b3d358ec1..eac1a76c59d73 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1142,6 +1142,7 @@ int mlx5_cmd_destroy_vport_lag(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_roce(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_sriov(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_active(struct mlx5_core_dev *dev);
+int mlx5_lag_query_bond_speed(struct net_device *bond_dev, u32 *speed);
 bool mlx5_lag_mode_is_hash(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_master(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_shared_fdb(struct mlx5_core_dev *dev);
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 8a55fee483127..69c5f22c2d621 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -60,6 +60,8 @@ enum {
 u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport);
 int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 				  u16 vport, u8 other_vport, u8 state);
+int mlx5_query_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 op_mod,
+				  u16 vport, u8 other_vport, u32 *max_tx_speed);
 int mlx5_modify_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 opmod,
 				   u16 vport, u8 other_vport, u16 max_tx_speed);
 int mlx5_query_nic_vport_mac_address(struct mlx5_core_dev *mdev,
-- 
2.53.0



