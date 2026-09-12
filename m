Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5343F23BE;
	Sat, 12 Sep 2026 09:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204736; cv=none; b=OhHviOlYDxLEPXAYLxGVRCNBjwSY5LnV0G29pFki325R+2sDhGLzyZ9/4kowxwrGXrSSLB9W6zNXZlHQOIrBF5LF3VQoGsyo5EzA3kzBKjAGOEHHBCa7z2B8Dq/9zxFqWBgLALkMilqEWf2naeFNzsdoE4mya4KB9pjNDUKTmBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204736; c=relaxed/simple;
	bh=e+qO6TG5WUMUgh7JS6ODhbj8gwZDpC0p1lYqNFgUzqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfGFwQdwsUOWC9kqhJNOwCFIRxnMfQQZpp6MlD5RfZ/3QYj8UIAYy/wvvEsUPgJ4P4c2lqYeLN15+MdJPCuYcnePVq8tQaFegwwuardLMxS/NT/cAUTLD1xsCLmUlplpmb5FpZOptYSV7r6EZEYzBmiOxSGiok441fbRHQhMXWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjl/A1S6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjl/A1S6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E4D1F00893;
	Sat, 12 Sep 2026 09:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204731;
	bh=xHi44Un1hoA9e4Lpmt9GHhlSw+2xghYIZbq3ltX/Th4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjl/A1S6HIQW+MK/9oiZDYh7TgylUJXsLRrhUbwrC33ZF9dQ6hf3/6J8ONu2Cp5Af
	 gYynrJ026ybPHXrkAjxNDL5IHz0wUhAYb8oVrf4OQ/I/sIMexm8YLehaB26AMRzxOy
	 LQQoT23kXILrZ1UUxYHlCK2xtw5koMauKvfyT/NQ=
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
Subject: [PATCH 7.2 1673/1815] net/mlx5: E-Switch, preserve max tx speed on vport state modification
Date: Sat, 12 Sep 2026 08:57:03 +0200
Message-ID: <20260912065728.262951205@linuxfoundation.org>
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
index 3624c680a861a..7950b82d8b8ae 100644
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
index edac2d694e0f0..8aa94ec87a0e3 100644
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



