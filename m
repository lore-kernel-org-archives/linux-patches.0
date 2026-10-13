Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125F84F647A;
	Tue, 13 Oct 2026 11:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892691; cv=none; b=jzYyFGhFExYd84nlQr+Fi4XHbCYBpa8tvmiTAYAgOA+BxRIBBXctcyKvysAuD67KAUUoFbJlFmp6OZoPdo4si6oKQ1M/86IZhDHe7424TIXKPkoeyJMtbZddlL+fKseBj6S9rtGRtdxI7FSr6AHx+v0covTJrsSL1z5Qtj6I9qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892691; c=relaxed/simple;
	bh=KqAuMx4X6/wb3Ttf/lPnkm9xXACHbBmCCa7xApY5pd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejcz5AFXYc+gyXoSsJYseHJgCOzEsnkh//No12BDK/ksVK7EypSt/Ky3BeClwoO6AjpoDLkLrW5G/bNsb/iKRqwOZkbijPxSVCj7dFjv/kcweYKKQXTnw1UmVColeNLu7BZpTKs8Tk6zeWu7fdenwc20ZIe6UGTkY6WR/n81w+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pN1KTFcD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pN1KTFcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0998B1F00898;
	Tue, 13 Oct 2026 11:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892689;
	bh=J9cEMHd4CeW//blQwwT7i3mRFn+fos5xdtINQW568XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pN1KTFcDovwXJcIUmNZzeHsZhgXFcdV51LYPLgXQLGI+LjHwsOR2Z+2ArVLTjiAfs
	 GAmnkm1sam2MwTtLnJb2pfUT7h6FE5ABZ2KEYw5l5hIRuuCJKOFUKk51phHR72k6VP
	 NzxiJvMBXL1K5cFiT/Vj0QR8Uq8DlaSKqxsHWUl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 220/281] net/mlx5: Lag, split aggregate speed into oper and max helpers
Date: Tue, 13 Oct 2026 13:38:56 +0200
Message-ID: <20261013112900.498140258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit fe4114221364899ab33c3f9574da6b108d3fa79e ]

mlx5_lag_sum_devices_speed computes the LAG aggregate by summing oper
speeds across all ports. This has two bugs.

First, it relies on the assumption that a port whose carrier is down
will report an oper speed of zero and therefore not contribute to the
sum. This assumption does not always hold: when the link partner
disconnects the port transitions to DOWN state but firmware may still
report a non-zero oper speed, causing the aggregate to include a port
that is not actively carrying traffic.

Second, in active-backup mode only one port transmits at a time, so
the aggregate should reflect a single port speed rather than the sum
of all ports.

Fix this by splitting mlx5_lag_sum_devices_speed into two helpers.
mlx5_lag_get_devices_oper_speed reflects the speed currently available:
it queries the vport state of each port and skips any port that is not
UP, rather than relying on oper speed being zero.
mlx5_lag_get_devices_max_speed is state-independent and returns the
maximum achievable speed used as a fallback when speed is 0; for
active-backup it takes the maximum single-port speed instead of the sum.

The bugs were discovered during integration and reproduced on a
back-to-back ConnectX-8 setup.

The first bug (stale oper speed when link goes down) was observed: after
the link partner disconnected, the aggregate TX speed reported to vports
remained full speed because firmware still returned the last oper speed,
causing vports to be rate-limited to the old aggregate speed.

The second bug (active-backup summing all port speeds instead of the
active port's speed) was also triggered: in active-backup mode the
computed aggregate was double the expected value since both port speeds
were summed even though only one port was active.

Fixes: 28ea6036dad2 ("net/mlx5: Handle port and vport speed change events in MPESW")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260930170406.148548-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 79 +++++++++++++------
 1 file changed, 57 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 3b34bec559e08..4e173b08cb37a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1432,30 +1432,40 @@ static bool mlx5_lag_should_disable_lag(struct mlx5_lag *ldev, bool do_bond)
 }
 
 #ifdef CONFIG_MLX5_ESWITCH
-static int
-mlx5_lag_sum_devices_speed(struct mlx5_lag *ldev, u32 *sum_speed,
-			   int (*get_speed)(struct mlx5_core_dev *, u32 *))
+static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
+					   u32 *sum_speed)
 {
-	struct mlx5_core_dev *pf_mdev;
-	struct lag_func *pf;
 	int pf_idx;
-	u32 speed;
-	int ret;
 
 	*sum_speed = 0;
 	mlx5_ldev_for_each(pf_idx, 0, ldev) {
+		u8 opmod = MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT;
+		struct mlx5_core_dev *pf_mdev;
+		struct lag_func *pf;
+		u32 speed;
+		u8 state;
+		int ret;
+
 		pf = mlx5_lag_pf(ldev, pf_idx);
 		if (!pf)
 			continue;
 		pf_mdev = pf->dev;
 		if (!pf_mdev)
 			continue;
+		ret = mlx5_query_vport_max_tx_speed(pf_mdev, opmod, 0, 0,
+						    &speed, &state);
+		if (ret) {
+			mlx5_core_dbg(pf_mdev, "State query failed (err=%d)\n",
+				      ret);
+			return ret;
+		}
+		if (state != VPORT_STATE_UP)
+			continue;
 
-		ret = get_speed(pf_mdev, &speed);
+		ret = mlx5_port_oper_linkspeed(pf_mdev, &speed);
 		if (ret) {
 			mlx5_core_dbg(pf_mdev,
-				      "Failed to get device speed using %ps. Device %s speed is not available (err=%d)\n",
-				      get_speed, dev_name(pf_mdev->device),
+				      "Failed to get oper speed (err=%d)\n",
 				      ret);
 			return ret;
 		}
@@ -1466,17 +1476,42 @@ mlx5_lag_sum_devices_speed(struct mlx5_lag *ldev, u32 *sum_speed,
 	return 0;
 }
 
-static int mlx5_lag_sum_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
+static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
 {
-	return mlx5_lag_sum_devices_speed(ldev, max_speed,
-					  mlx5_port_max_linkspeed);
-}
+	bool take_max;
+	int pf_idx;
 
-static int mlx5_lag_sum_devices_oper_speed(struct mlx5_lag *ldev,
-					   u32 *oper_speed)
-{
-	return mlx5_lag_sum_devices_speed(ldev, oper_speed,
-					  mlx5_port_oper_linkspeed);
+	take_max = ldev->tracker.tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP;
+	if (ldev->mode == MLX5_LAG_MODE_MPESW)
+		take_max = false;
+
+	*max_speed = 0;
+	mlx5_ldev_for_each(pf_idx, 0, ldev) {
+		struct mlx5_core_dev *pf_mdev;
+		struct lag_func *pf;
+		u32 speed;
+		int ret;
+
+		pf = mlx5_lag_pf(ldev, pf_idx);
+		if (!pf)
+			continue;
+		pf_mdev = pf->dev;
+		if (!pf_mdev)
+			continue;
+
+		ret = mlx5_port_max_linkspeed(pf_mdev, &speed);
+		if (ret) {
+			mlx5_core_dbg(pf_mdev,
+				      "Failed to get max speed (err=%d)\n",
+				      ret);
+			return ret;
+		}
+
+		*max_speed = take_max ?
+			max(*max_speed, speed) : *max_speed + speed;
+	}
+
+	return 0;
 }
 
 static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
@@ -1525,7 +1560,7 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
 	int pf_idx;
 
 	if (ldev->mode == MLX5_LAG_MODE_MPESW) {
-		if (mlx5_lag_sum_devices_oper_speed(ldev, &speed))
+		if (mlx5_lag_get_devices_oper_speed(ldev, &speed))
 			return;
 	} else {
 		speed = ldev->tracker.bond_speed_mbps;
@@ -1533,8 +1568,8 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
 			return;
 	}
 
-	/* If speed is not set, use the sum of max speeds of all PFs */
-	if (!speed && mlx5_lag_sum_devices_max_speed(ldev, &speed))
+	/* If speed is not set, fall back to the max achievable speed */
+	if (!speed && mlx5_lag_get_devices_max_speed(ldev, &speed))
 		return;
 
 	speed = speed / MLX5_MAX_TX_SPEED_UNIT;
-- 
2.53.0



