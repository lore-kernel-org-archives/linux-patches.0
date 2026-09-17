Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588A449D5B9;
	Thu, 17 Sep 2026 17:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665772; cv=none; b=F5rlV1p+oj/JlgYeRcqzp62e0Ce5RuJ82GFS2ZYPkf7rYEAEbqlmLRHx6QjWh7RS0Xt7sPb7rUrNUD3ihdXOhGVNIVF2yzPo3vpZfNMzziWq06pFOXGatQdbdK/EyJtLga0ZFK4o2QOokHYoWQLEdOvwPFVLm44uZw/zwkeABqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665772; c=relaxed/simple;
	bh=JKM/cHP2wC192TLOrYwFN/WcVYYCjq2R28Rylb9vThc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sN85WMRPIN3i1WgIEcsnh7bnC+xl37GDdwTavsSRh0tRP7ynr7/hqWEltpnyV4G6ZUnJ9LH62okm5HzJTfu10agVUcSQTwDPKxQxf7EtGKWvUIEhop2r6fKH8+WOK/9QTB84M7zwq5m2Tap8ey86zYWK5l4FOfgvBWUXfgET8rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1eJYM2m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1eJYM2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FE11F000FF;
	Thu, 17 Sep 2026 17:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665771;
	bh=OSK7SkGK3VHCyn79TjtelakfRJTa7RNlWlwd3HJuZYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y1eJYM2mXx5DwxqyDjGswdw2yV5mo2j0vuCVgSEBxKmtVHaEFVrzqCYz/Y8oMxjrN
	 Uybfy18i2Emb2sWihDqS/CPEvElaiOvP76qkgiXoHIdXX7qqinxAjfMAEQdstS/dGV
	 Zx6rmql4dvbcV+CBHwqgkDid0Rp+j5pMrFvyvEGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0813/1250] net/mlx5: LAG, use local tracker to update active ports
Date: Thu, 17 Sep 2026 16:10:08 +0100
Message-ID: <20260917151613.961703780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Akiva Goldberger <agoldberger@nvidia.com>

[ Upstream commit b3c79dee5038c5e8460c59d7d01cb1450bdf5ecb ]

The CREATE_LAG command is handled asynchronously by queuing a work,
which stores a local copy of ldev->tracker. When the work is processed,
it is possible that the values of the local copy and ldev->tracker have
diverged.

A single CREATE_LAG command programs two related fields into the
firmware: the v2p (virtual-to-physical) map, which selects the physical
egress port for each hash bucket, and the active_port bitmask, which
tells the firmware which physical ports are currently up so it can
redirect QP/TIS away from inactive ports. For the firmware to steer
traffic correctly, both must be derived from the same view of the ports'
link state.

The v2p map is computed by mlx5_infer_tx_affinity_mapping() from the
local tracker snapshot, but lag_active_port_bits() called
mlx5_infer_tx_enabled() on the live ldev->tracker instead. If
ldev->tracker changed between the snapshot and command execution, the
two fields reflect different port states: the v2p map may steer a bucket
to a port that the active_port mask marks as inactive (or vice versa).
The firmware then receives a self-contradictory configuration and can
redirect or drop traffic on a port the mapping still points at, until a
later event happens to reconcile the state.

Update lag_active_port_bits so that it receives the local version of the
tracker from when the work was queued, effectively closing the window
for injecting an inconsistency.

Fixes: c5c13b456cb8 ("net/mlx5: Lag, set active ports if support bypass port select flow table")
Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260902192740.3665435-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index e9ad59f74e46c..d20f9d3e30c79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -62,14 +62,15 @@ static int get_port_sel_mode(enum mlx5_lag_mode mode, unsigned long flags)
 	return MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY;
 }
 
-static u8 lag_active_port_bits(struct mlx5_lag *ldev)
+static u8 lag_active_port_bits(struct mlx5_lag *ldev,
+			       struct lag_tracker *tracker)
 {
 	u8 enabled_ports[MLX5_MAX_PORTS] = {};
 	u8 active_port = 0;
 	int num_enabled;
 	int idx;
 
-	mlx5_infer_tx_enabled(&ldev->tracker, ldev, enabled_ports,
+	mlx5_infer_tx_enabled(tracker, ldev, enabled_ports,
 			      &num_enabled);
 	for (idx = 0; idx < num_enabled; idx++)
 		active_port |= BIT_MASK(enabled_ports[idx]);
@@ -78,7 +79,8 @@ static u8 lag_active_port_bits(struct mlx5_lag *ldev)
 }
 
 static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, struct mlx5_lag *ldev,
-			       int mode, unsigned long flags)
+			       struct lag_tracker *tracker, int mode,
+			       unsigned long flags)
 {
 	bool fdb_sel_mode = test_bit(MLX5_LAG_MODE_FLAG_FDB_SEL_MODE_NATIVE,
 				     &flags);
@@ -107,7 +109,7 @@ static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, struct mlx5_lag *ldev,
 			break;
 
 		MLX5_SET(lagc, lag_ctx, active_port,
-			 lag_active_port_bits(mlx5_lag_dev(dev)));
+			 lag_active_port_bits(ldev, tracker));
 		break;
 	default:
 		break;
@@ -494,7 +496,8 @@ static int mlx5_cmd_modify_active_port(struct mlx5_core_dev *dev, u8 ports)
 	return mlx5_cmd_exec_in(dev, modify_lag, in);
 }
 
-static int _mlx5_modify_lag(struct mlx5_lag *ldev, u8 *ports)
+static int _mlx5_modify_lag(struct mlx5_lag *ldev,
+			    struct lag_tracker *tracker, u8 *ports)
 {
 	int idx = mlx5_lag_get_dev_index_by_seq(ldev, MLX5_LAG_P1);
 	struct mlx5_core_dev *dev0;
@@ -511,7 +514,7 @@ static int _mlx5_modify_lag(struct mlx5_lag *ldev, u8 *ports)
 		    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table_bypass))
 			return ret;
 
-		active_ports = lag_active_port_bits(ldev);
+		active_ports = lag_active_port_bits(ldev, tracker);
 
 		return mlx5_cmd_modify_active_port(dev0, active_ports);
 	}
@@ -571,7 +574,7 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 			idx = i * ldev->buckets + j;
 			if (ports[idx] == ldev->v2p_map[idx])
 				continue;
-			err = _mlx5_modify_lag(ldev, ports);
+			err = _mlx5_modify_lag(ldev, tracker, ports);
 			if (err) {
 				mlx5_core_err(dev0,
 					      "Failed to modify LAG (%d)\n",
@@ -708,7 +711,7 @@ static int mlx5_create_lag(struct mlx5_lag *ldev,
 	mlx5_core_info(dev0, "shared_fdb:%d mode:%s\n",
 		       shared_fdb, mlx5_get_str_port_sel_mode(mode, flags));
 
-	err = mlx5_cmd_create_lag(dev0, ldev, mode, flags);
+	err = mlx5_cmd_create_lag(dev0, ldev, tracker, mode, flags);
 	if (err) {
 		mlx5_core_err(dev0,
 			      "Failed to create LAG (%d)\n",
-- 
2.53.0



