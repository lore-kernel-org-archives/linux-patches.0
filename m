Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5172EC09B;
	Sat, 12 Sep 2026 11:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211997; cv=none; b=MQqIT3NQWEtxQPBglg1daAhmPNpKoCT7qidtftRAt7TTgf6fTADAZAvx6rIhDacp8IoBqAEoMg2wVW9P9q9efgI9iAXf/3eKqUPCBokZVkMTpsxr8ueInSW5BKIj5beX9Sih5R5d+bxPNfMnQHK19nFls3BzzYqcaYUz3j4JJG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211997; c=relaxed/simple;
	bh=ZEhDKa9uM/W/7fnPFc5DHEYeWvUQaJIrR1YegL1d3aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgLQFiv+mTGdvtNnwUo+Cj07Sygn8EM2zi2q+YUtqKw+jqnco+FgvDcQKqNAyzd/ZMfSGRXOJAp2npP0Bky8jvfq7nsS53TrEBniKFmdyglrVLcG2N1IF5wkQl9mRCkFaR4YYjuZtFNrjHCdDwLOMi8RcK7pgZJO2U6B6jeKXkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUn2zVMN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUn2zVMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA801F000FF;
	Sat, 12 Sep 2026 11:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211996;
	bh=6DiyVehh79cWYURJafPQyZnCxrEB8GiWBlCAG50X62w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PUn2zVMNgL1RJS+OybBxxQYTcgrNzi5bOkUv7wq0TaFrcTM6lUR0xyMVqg3vec2uP
	 jb/TTvKyeNIWTVZ6FCT6jnXX5S2X0cuV0IKtPYqWCMCENjZKZqo1Ju4xfznyTJCM3J
	 o30ktwIIJFi1lOyrvCZJdI9LnBOepv+v9VyL52no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1347/1518] net/mlx5: E-Switch, preserve max tx speed on vport state modification
Date: Sat, 12 Sep 2026 08:58:36 +0200
Message-ID: <20260912065653.999956401@linuxfoundation.org>
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

[ Upstream commit ad0ae7aefa7a6ede28a549d8dac87456d87ef6d4 ]

When modifying vport state, the firmware interprets a zero in the max tx
speed field as an intentional reset, which can overwrite previously set
values. This patch attempts to fix this by querying the current max tx
speed from firmware before modifying the vport state and passing it back
in the modification command. If the query fails, fall back to the cached
agg_max_tx_speed value to avoid inadvertently resetting the speed.

Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to vports")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260816065015.3280733-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/esw/adj_vport.c        | 20 ++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 24 +++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
index bdd07c1c68242..8eaef73f3d77d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
@@ -11,6 +11,26 @@ int mlx5_esw_adj_vport_modify(struct mlx5_core_dev *dev, u16 vport,
 
 	lockdep_assert_held(&dev->priv.eswitch->state_lock);
 
+	if (MLX5_CAP_ESW(dev, esw_vport_state_max_tx_speed)) {
+		u8 op_mod = MLX5_VPORT_STATE_OP_MOD_ESW_VPORT;
+		struct mlx5_vport *esw_vport;
+		u32 speed = 0;
+		int err;
+
+		err = mlx5_query_vport_max_tx_speed(dev, op_mod, vport,
+						    true, &speed, NULL);
+		if (err) {
+			esw_vport = mlx5_eswitch_get_vport(dev->priv.eswitch,
+							   vport);
+			speed = IS_ERR(esw_vport) ? 0 :
+				esw_vport->agg_max_tx_speed;
+			mlx5_core_dbg(dev,
+				      "Failed to query vport %d max tx speed, err=%d, using cached %u\n",
+				      vport, err, speed);
+		}
+		MLX5_SET(modify_vport_state_in, in, max_tx_speed, speed);
+	}
+
 	MLX5_SET(modify_vport_state_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_VPORT_STATE);
 	MLX5_SET(modify_vport_state_in, in, op_mod,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 2ee914f9ce933..6b90f6c4f2eb6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -93,6 +93,30 @@ int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 	lockdep_assert_held(&mdev->priv.eswitch->state_lock);
 #endif
 
+	if (MLX5_CAP_ESW(mdev, esw_vport_state_max_tx_speed) &&
+	    opmod == MLX5_VPORT_STATE_OP_MOD_ESW_VPORT &&
+	    vport != MLX5_VPORT_UPLINK) {
+		u32 speed = 0;
+		int err;
+
+		err = mlx5_query_vport_max_tx_speed(mdev, opmod, vport,
+						    other_vport, &speed, NULL);
+		if (err) {
+#ifdef CONFIG_MLX5_ESWITCH
+			struct mlx5_vport *esw_vport;
+
+			esw_vport = mlx5_eswitch_get_vport(mdev->priv.eswitch,
+							   vport);
+			speed = IS_ERR(esw_vport) ? 0 :
+				esw_vport->agg_max_tx_speed;
+#endif
+			mlx5_core_dbg(mdev,
+				      "Failed to query vport %d max tx speed, err=%d, using cached %u\n",
+				      vport, err, speed);
+		}
+		MLX5_SET(modify_vport_state_in, in, max_tx_speed, speed);
+	}
+
 	MLX5_SET(modify_vport_state_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_VPORT_STATE);
 	MLX5_SET(modify_vport_state_in, in, op_mod, opmod);
-- 
2.53.0



