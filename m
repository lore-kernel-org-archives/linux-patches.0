Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFD237B40C;
	Tue, 21 Jul 2026 17:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653812; cv=none; b=gXz9y3bswotwpFCp/zrMBo0biudhTjDnm0dv//7H02zncLDc9H9Y013GDysF3ftfuUtrIyn/H61cbdfvHXFv8VXfxKxHMFve0Fk4j7KEjAe8JgsujCaZryjPXbA55bTzkKEN0dXhxJkPhfINPKqsZm9qwcu+T6XHBhb657qzN6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653812; c=relaxed/simple;
	bh=d0jpuvn9Cd7wkkjn5NZ1pgpasY41XoKm52krhyEww58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/FsDJ0GMZI/ZkVlliHaWTJBU7CrK8f09SXZC2gGMzGemkPvP8a/Z+rdcnq6lNfBfYcJzAagEub1OUgzWRJX4qAHAiSBQ+L6/rK4Z1/Xla2NMUGtCxHgmy+U/oL5kMg1u8hxLF8bYuakOtrPw3+DmjU6dG5tI7/SEqFYz6sT5Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UvDuncvO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UvDuncvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FB81F000E9;
	Tue, 21 Jul 2026 17:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653811;
	bh=0TJExOVrXo9P/E4z/OcAjyuZ0f5ntXWxICHVqOnhjIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UvDuncvO2rvRd2sW+yBS2imK14jFuBVUFXUUa13Ppqxe7Ya+DKc1aynyKf5dKzzrG
	 VDzJpQINVh39Km45oSTkf9xwdUqESzpv0zrzhDeTBOjgGQoxGfOX/A6yhtdhlgEpI1
	 MNUOICEjSOswwroM4uFUoW6tJuzXwDwaXHFwLbDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1431/2077] net/mlx5: Lag: refactor representor reload handling
Date: Tue, 21 Jul 2026 17:18:24 +0200
Message-ID: <20260721152626.560288193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit b501400fa66d9b8045f282ae8de80ceb6e02fe85 ]

Representor reload during LAG/MPESW transitions has to be repeated in
several flows, and each open-coded loop was easy to get out of sync
when adding new flags or tweaking error handling. Move the sequencing
into a single helper so that all call sites share the same ordering
and checks.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260503202726.266415-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0f0e4ae6975c ("net/mlx5: LAG, Fix off-by-one in single-FDB error rollback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 45 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  2 +
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   | 12 ++---
 3 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index f8e70ac5a85b74..6c6eba67bab735 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1093,6 +1093,27 @@ void mlx5_lag_remove_devices(struct mlx5_lag *ldev)
 	}
 }
 
+int mlx5_lag_reload_ib_reps(struct mlx5_lag *ldev, u32 flags, bool cont_on_fail)
+{
+	struct lag_func *pf;
+	int ret;
+	int i;
+
+	mlx5_ldev_for_each(i, 0, ldev) {
+		pf = mlx5_lag_pf(ldev, i);
+		if (!(pf->dev->priv.flags & flags)) {
+			struct mlx5_eswitch *esw;
+
+			esw = pf->dev->priv.eswitch;
+			ret = mlx5_eswitch_reload_ib_reps(esw);
+			if (ret && !cont_on_fail)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
 void mlx5_disable_lag(struct mlx5_lag *ldev)
 {
 	bool shared_fdb = test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &ldev->mode_flags);
@@ -1130,9 +1151,8 @@ void mlx5_disable_lag(struct mlx5_lag *ldev)
 		mlx5_lag_add_devices(ldev);
 
 	if (shared_fdb)
-		mlx5_ldev_for_each(i, 0, ldev)
-			if (!(mlx5_lag_pf(ldev, i)->dev->priv.flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV))
-				mlx5_eswitch_reload_ib_reps(mlx5_lag_pf(ldev, i)->dev->priv.eswitch);
+		mlx5_lag_reload_ib_reps(ldev, MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV,
+					true);
 }
 
 bool mlx5_lag_shared_fdb_supported(struct mlx5_lag *ldev)
@@ -1393,10 +1413,8 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 		if (err) {
 			if (shared_fdb || roce_lag)
 				mlx5_lag_add_devices(ldev);
-			if (shared_fdb) {
-				mlx5_ldev_for_each(i, 0, ldev)
-					mlx5_eswitch_reload_ib_reps(mlx5_lag_pf(ldev, i)->dev->priv.eswitch);
-			}
+			if (shared_fdb)
+				mlx5_lag_reload_ib_reps(ldev, 0, true);
 
 			return;
 		}
@@ -1414,24 +1432,15 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 					mlx5_nic_vport_enable_roce(dev);
 			}
 		} else if (shared_fdb) {
-			int i;
-
 			dev0->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 			mlx5_rescan_drivers_locked(dev0);
-
-			mlx5_ldev_for_each(i, 0, ldev) {
-				err = mlx5_eswitch_reload_ib_reps(mlx5_lag_pf(ldev, i)->dev->priv.eswitch);
-				if (err)
-					break;
-			}
-
+			err = mlx5_lag_reload_ib_reps(ldev, 0, false);
 			if (err) {
 				dev0->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 				mlx5_rescan_drivers_locked(dev0);
 				mlx5_deactivate_lag(ldev);
 				mlx5_lag_add_devices(ldev);
-				mlx5_ldev_for_each(i, 0, ldev)
-					mlx5_eswitch_reload_ib_reps(mlx5_lag_pf(ldev, i)->dev->priv.eswitch);
+				mlx5_lag_reload_ib_reps(ldev, 0, true);
 				mlx5_core_err(dev0, "Failed to enable lag\n");
 				return;
 			}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 6c911374f409ba..daca8ebd525673 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -199,4 +199,6 @@ int mlx5_get_next_ldev_func(struct mlx5_lag *ldev, int start_idx);
 int mlx5_lag_get_dev_index_by_seq(struct mlx5_lag *ldev, int seq);
 int mlx5_lag_num_devs(struct mlx5_lag *ldev);
 int mlx5_lag_num_netdevs(struct mlx5_lag *ldev);
+int mlx5_lag_reload_ib_reps(struct mlx5_lag *ldev, u32 flags,
+			    bool cont_on_fail);
 #endif /* __MLX5_LAG_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 5eea12a6887ac0..edcd06f3be7a74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -70,7 +70,6 @@ static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 	int idx = mlx5_lag_get_dev_index_by_seq(ldev, MLX5_LAG_P1);
 	struct mlx5_core_dev *dev0;
 	int err;
-	int i;
 
 	if (ldev->mode == MLX5_LAG_MODE_MPESW)
 		return 0;
@@ -103,11 +102,9 @@ static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 
 	dev0->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 	mlx5_rescan_drivers_locked(dev0);
-	mlx5_ldev_for_each(i, 0, ldev) {
-		err = mlx5_eswitch_reload_ib_reps(mlx5_lag_pf(ldev, i)->dev->priv.eswitch);
-		if (err)
-			goto err_rescan_drivers;
-	}
+	err = mlx5_lag_reload_ib_reps(ldev, 0, false);
+	if (err)
+		goto err_rescan_drivers;
 
 	mlx5_lag_set_vports_agg_speed(ldev);
 
@@ -119,8 +116,7 @@ static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 	mlx5_deactivate_lag(ldev);
 err_add_devices:
 	mlx5_lag_add_devices(ldev);
-	mlx5_ldev_for_each(i, 0, ldev)
-		mlx5_eswitch_reload_ib_reps(mlx5_lag_pf(ldev, i)->dev->priv.eswitch);
+	mlx5_lag_reload_ib_reps(ldev, 0, true);
 	mlx5_mpesw_metadata_cleanup(ldev);
 	return err;
 }
-- 
2.53.0



