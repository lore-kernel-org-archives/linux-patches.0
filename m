Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA3247124F;
	Sat, 12 Sep 2026 11:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211988; cv=none; b=V4Gfca7iGoTIXUn3UjH6I10ht0yFPJvBSdFXmSg7XjFBxb1XXL66UlKkh2z3ufHt/naZ057KWcvGhLAVFoycKKqKv4QpkJczUSLuHffQvf+S+GJo2ppAbA+UYlGDDfI2oYmBdopLD2HffBDkSBjd875rRyTTRjOQcOMaa2LLCiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211988; c=relaxed/simple;
	bh=V4zplIkk4Rf5ZIlQuuYNZT3x2B/lPsfPlcHBLrLLetY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nT95r3Hm53aYzZ3uHAH9Z+0V5qGVy2Paiax6kp8ufBooJa5uH0JjSn6DJtMqeJEElCSIUdqd2zZuhJTGBHETSwxlieuvKfbpWC85Z7sVTpIn2BRpblaPITRwkOGbuS6fMF9AY+drTVikdNOSeRlcft+qepnGzXYYj5pP3IbNp3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TurBuNeU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TurBuNeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E7C1F000FF;
	Sat, 12 Sep 2026 11:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211986;
	bh=LVBtq6S+0+pa/tCA69BE06GKVEz8Rw/e+QMY6SFoFIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TurBuNeU88iZknjBKM5bCgSK/zT+3KZQ1UifBP+RdY6eeQif8ptpbM34niORlLCw1
	 l4I8e6OfYB+yfY3uW+DmGup6xgSnkdv8vkAHfqEH/3E64o4X4SZ/3Vvj3u+0YJ0NB4
	 /rc8otmr1vLtlOZ+2VFVmkHslAJKvJ88/Yj+t8AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1345/1518] net/mlx5: Skip disabled vports when setting max TX speed
Date: Sat, 12 Sep 2026 08:58:34 +0200
Message-ID: <20260912065653.955254333@linuxfoundation.org>
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

[ Upstream commit c6df9a65cbb0fe7808a4b2872095f4c849b3196a ]

When setting vports max TX speed during LAG activation or bond state
changes, the code iterates over all eswitch vports. However, some
vports may not be enabled yet.

Skip vports that are not enabled to avoid sending FW commands for
uninitialized vports. Save the LAG aggregated speed in the vport
struct so it can be applied when the vport is enabled later.

Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to vports")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260513063640.334132-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ad0ae7aefa7a ("net/mlx5: E-Switch, preserve max tx speed on vport state modification")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 21 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c |  5 +++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index c38deabcb7b96..bc7ceb4c76e5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -904,6 +904,24 @@ static void esw_vport_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 	esw_vport_cleanup_acl(esw, vport);
 }
 
+static void mlx5_esw_vport_set_max_tx_speed(struct mlx5_eswitch *esw,
+					    struct mlx5_vport *vport)
+{
+	int ret;
+
+	if (!MLX5_CAP_ESW(esw->dev, esw_vport_state_max_tx_speed))
+		return;
+
+	ret = mlx5_modify_vport_max_tx_speed(esw->dev,
+					     MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
+					     vport->vport, true,
+					     vport->agg_max_tx_speed);
+	if (ret)
+		mlx5_core_dbg(esw->dev,
+			      "Failed to set vport %d speed %d, err=%d\n",
+			      vport->vport, vport->agg_max_tx_speed, ret);
+}
+
 int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 			  enum mlx5_eswitch_vport_event enabled_events)
 {
@@ -950,6 +968,9 @@ int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 
 	esw->enabled_vports++;
 	esw_debug(esw->dev, "Enabled VPORT(%d)\n", vport_num);
+
+	if (vport->agg_max_tx_speed)
+		mlx5_esw_vport_set_max_tx_speed(esw, vport);
 done:
 	mutex_unlock(&esw->state_lock);
 	return ret;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index a68af08faeed0..eca24c1929eb4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -246,6 +246,7 @@ struct mlx5_vport {
 	enum mlx5_eswitch_vport_event enabled_events;
 	int index;
 	struct mlx5_devlink_port *dl_port;
+	u32 agg_max_tx_speed;
 };
 
 struct mlx5_esw_indir_table;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 8468e35252fc0..e9ad59f74e46c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1075,6 +1075,11 @@ static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
 		if (vport->vport == MLX5_VPORT_UPLINK)
 			continue;
 
+		vport->agg_max_tx_speed = speed;
+
+		if (!vport->enabled)
+			continue;
+
 		ret = mlx5_modify_vport_max_tx_speed(mdev, op_mod,
 						     vport->vport, true, speed);
 		if (ret)
-- 
2.53.0



