Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC0E3290B0;
	Thu, 28 May 2026 20:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998882; cv=none; b=gotukP1s2It/BfkYCldLTpO/ezmhL4Get70Abt4GhvGrkCqJsH+C3J/zKHPBqYgkxMrYyWbE7gNAu7Q33fZ2Tri4WTCVZri1VMdYAdb1OFOHVEx7mhxY1dw7r1eDbP+TSfICES42hi3A7zbZkL5Zn8b7AgXvdusoASyQAle6qI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998882; c=relaxed/simple;
	bh=YS8uCvQeZX1lKnWcT+krphTwpqmfsgS+xrqU9JiHwAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtEv0YZ19pbWJ4n5nCVUcNTMqr2HGAW7iU44q1zYKr1FPzf8lb6gmpebKKuw/4yHY2yAX2zDJ+Z5n9cL14dl/oyeixBUj0c5+HHnS3Infy9ngtszFs9CTpoKoWkXoE4pgfbpb7a669/bl/ePNrrFWJwxqX0o+Qp5F13Iv5WyroQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGQCURXu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGQCURXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29581F00A3E;
	Thu, 28 May 2026 20:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998881;
	bh=cZwGYDvTilNYtpI9A0OhNu3X7TolSak3KZJmnoVsK6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zGQCURXumcFgnGFRD8mByduRJEhblX9zmFpPE6srSxrRdrlP/NRahxrOd74/LqhkH
	 3N0lOLmg0B0YLbFgVipr1zCDc4SMD9AbH+Ywd1N8as6cOT6SCASpKIJ5GhGFuf5C2z
	 HolI0hscmrUZOBjUzBIcWxsXSynibcLW972Pdce8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 331/461] net/mlx5: Skip disabled vports when setting max TX speed
Date: Thu, 28 May 2026 21:47:40 +0200
Message-ID: <20260528194656.928491889@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 21 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c |  5 +++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 123c96716a544..7c8311f412323 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -908,6 +908,24 @@ static void esw_vport_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
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
@@ -948,6 +966,9 @@ int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 
 	esw->enabled_vports++;
 	esw_debug(esw->dev, "Enabled VPORT(%d)\n", vport_num);
+
+	if (vport->agg_max_tx_speed)
+		mlx5_esw_vport_set_max_tx_speed(esw, vport);
 done:
 	mutex_unlock(&esw->state_lock);
 	return ret;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index c2563bee74dfe..29cce1bbce941 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -247,6 +247,7 @@ struct mlx5_vport {
 	enum mlx5_eswitch_vport_event enabled_events;
 	int index;
 	struct mlx5_devlink_port *dl_port;
+	u32 agg_max_tx_speed;
 };
 
 struct mlx5_esw_indir_table;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 044adfdf9aa26..82e884e70168c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1074,6 +1074,11 @@ static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
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



