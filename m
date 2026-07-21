Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D691C3EF672;
	Tue, 21 Jul 2026 17:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653839; cv=none; b=JmDKA4oFqFB6Fh16AStkxxVB3wBboyTkLZ/IjklVUA4OaDyKceVy612tgcqDiyQqonpsforJVNpCQs7TNfY6Lqch5lKHPSa8A+UcPhn8YD1J92xaKjDFmgp1TBV3pkH+nNjxw2pTFdqnyaU8UfnpjbFBpNjYaICFCHp6KHf5zOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653839; c=relaxed/simple;
	bh=jwYkzbnWuL1+Ru/IMJRvETxwkfBwwmztCfYZslK8Fx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyZvHtHnUyXLoQbI2tIR2Q5pGKnVgSTLlb9uA75J0IIE/cKQyGF9SahTRjzYDEmQy4uMOupobsBBewysF3pxlrVMOp8/wbpZhnVL0toqEIoljlHuExaCxUrQpw4BtxGDlUqecEUu3c/RlbTjUtkfQd99YuNTpYKraRCkrYME+Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIbtA9S5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIbtA9S5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459BE1F000E9;
	Tue, 21 Jul 2026 17:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653837;
	bh=6OxKrI3V6H1LZz6B0ZRitE3hTclApQZRz0F8jccLIys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIbtA9S58qKRgFBLvSg3usNzWaNSrpOsub9XDVzeXfW9hyZ6Qo8pHaCou+7HE7zbc
	 OKxx4iDbUnSmE5i458UP4k4SkSxaEkrpA8wjF795d/Fu/zk7/6vpTN3aTdAv3u1owc
	 kY0OSFY703i2IT0/rkIuP+M09PeOkXNBDhYSipFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1435/2077] net/mlx5: LAG, replace peer count check with direct peer lookup
Date: Tue, 21 Jul 2026 17:18:28 +0200
Message-ID: <20260721152626.651945426@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 2ca494dad9676301ecde1c9e214bfbf83d4c6326 ]

Replace mlx5_eswitch_get_npeers() count-based check with a new
mlx5_eswitch_is_peer() function that directly verifies the peer
relationship between two eswitches.

This change prepares for SD LAG support, which is a virtual LAG that
does not have num_lag_ports capability and cannot use the count-based
peer validation.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260531113954.395443-5-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0f0e4ae6975c ("net/mlx5: LAG, Fix off-by-one in single-FDB error rollback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h   | 11 ++---------
 .../mellanox/mlx5/core/eswitch_offloads.c       | 12 ++++++++++++
 .../mellanox/mlx5/core/lag/shared_fdb.c         | 17 +++++++----------
 3 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 0b107c2ddbfa62..f248c66caa8481 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -899,6 +899,8 @@ int mlx5_eswitch_offloads_single_fdb_add_one(struct mlx5_eswitch *master_esw,
 void mlx5_eswitch_offloads_single_fdb_del_one(struct mlx5_eswitch *master_esw,
 					      struct mlx5_eswitch *slave_esw);
 int mlx5_eswitch_reload_ib_reps(struct mlx5_eswitch *esw);
+bool mlx5_eswitch_is_peer(struct mlx5_eswitch *esw,
+			  struct mlx5_eswitch *peer_esw);
 
 bool mlx5_eswitch_block_encap(struct mlx5_core_dev *dev, bool from_fdb);
 void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev);
@@ -914,13 +916,6 @@ static inline int mlx5_eswitch_num_vfs(struct mlx5_eswitch *esw)
 	return 0;
 }
 
-static inline int mlx5_eswitch_get_npeers(struct mlx5_eswitch *esw)
-{
-	if (mlx5_esw_allowed(esw))
-		return esw->num_peers;
-	return 0;
-}
-
 static inline struct mlx5_flow_table *
 mlx5_eswitch_get_slow_fdb(struct mlx5_eswitch *esw)
 {
@@ -996,8 +991,6 @@ static inline void
 mlx5_eswitch_offloads_single_fdb_del_one(struct mlx5_eswitch *master_esw,
 					 struct mlx5_eswitch *slave_esw) {}
 
-static inline int mlx5_eswitch_get_npeers(struct mlx5_eswitch *esw) { return 0; }
-
 static inline int
 mlx5_eswitch_reload_ib_reps(struct mlx5_eswitch *esw)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 41d65f2bf87dd8..fbd59225b8637d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3237,6 +3237,18 @@ static int mlx5_esw_offloads_set_ns_peer(struct mlx5_eswitch *esw,
 	return 0;
 }
 
+bool mlx5_eswitch_is_peer(struct mlx5_eswitch *esw,
+			  struct mlx5_eswitch *peer_esw)
+{
+	u16 peer_esw_i;
+
+	if (!mlx5_esw_allowed(esw) || !mlx5_esw_allowed(peer_esw))
+		return false;
+
+	peer_esw_i = MLX5_CAP_GEN(peer_esw->dev, vhca_id);
+	return !!xa_load(&esw->paired, peer_esw_i);
+}
+
 static int mlx5_esw_offloads_devcom_event(int event,
 					  void *my_data,
 					  void *event_data)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
index e5b8e9f1e6fde2..b5cbe340972036 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
@@ -10,7 +10,7 @@
 
 bool mlx5_lag_shared_fdb_supported(struct mlx5_lag *ldev)
 {
-	struct mlx5_core_dev *dev;
+	struct mlx5_core_dev *dev0, *dev;
 	bool ret = false;
 	int idx;
 	int i;
@@ -19,6 +19,7 @@ bool mlx5_lag_shared_fdb_supported(struct mlx5_lag *ldev)
 	if (idx < 0)
 		return false;
 
+	dev0 = mlx5_lag_pf(ldev, idx)->dev;
 	mlx5_ldev_for_each(i, 0, ldev) {
 		if (i == idx)
 			continue;
@@ -27,19 +28,15 @@ bool mlx5_lag_shared_fdb_supported(struct mlx5_lag *ldev)
 		    mlx5_eswitch_vport_match_metadata_enabled(dev->priv.eswitch) &&
 		    MLX5_CAP_GEN(dev, lag_native_fdb_selection) &&
 		    MLX5_CAP_ESW(dev, root_ft_on_other_esw) &&
-		    mlx5_eswitch_get_npeers(dev->priv.eswitch) ==
-		    MLX5_CAP_GEN(dev, num_lag_ports) - 1)
+		    mlx5_eswitch_is_peer(dev0->priv.eswitch, dev->priv.eswitch))
 			continue;
 		return false;
 	}
 
-	dev = mlx5_lag_pf(ldev, idx)->dev;
-	if (is_mdev_switchdev_mode(dev) &&
-	    mlx5_eswitch_vport_match_metadata_enabled(dev->priv.eswitch) &&
-	    mlx5_esw_offloads_devcom_is_ready(dev->priv.eswitch) &&
-	    MLX5_CAP_ESW(dev, esw_shared_ingress_acl) &&
-	    mlx5_eswitch_get_npeers(dev->priv.eswitch) ==
-	    MLX5_CAP_GEN(dev, num_lag_ports) - 1)
+	if (is_mdev_switchdev_mode(dev0) &&
+	    mlx5_eswitch_vport_match_metadata_enabled(dev0->priv.eswitch) &&
+	    mlx5_esw_offloads_devcom_is_ready(dev0->priv.eswitch) &&
+	    MLX5_CAP_ESW(dev0, esw_shared_ingress_acl))
 		ret = true;
 
 	return ret;
-- 
2.53.0



