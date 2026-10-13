Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A954FD270;
	Tue, 13 Oct 2026 11:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892682; cv=none; b=nK3lcj7UEIBtKmfJzrXKs8FaMQsmnXSeZw7tw3Zwpkuid3+WCJpvJhK7IsXmJ3JdKL5UUqj5vL06T3rtwPbcbZVI5YaApEU1XkPrORqplhMTP1W2u7NhFCsL5gM5zlSrIPdI1GGvCbEhwCaDhMy47ViNc65UvaeKEDnfQ4psi+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892682; c=relaxed/simple;
	bh=sLSh3ABY2pmfJBGxGPcnYuNbP0ARV7c00M9OlNY4/MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tM74lcMG6pclHAEXFzRgNEJhE1niT+mgQiyWZwj8HFhNq9IgZLdYs+ZHB0S346NDiSEUEX4QGwx86Z1H5bvlOTGJOhuRtfPapYXN3QPYz2iOGTRLNdoZvmsrXhA3vIfh3iK+e80FKeWylc+dtSEnXFLWcdqiPy01VX5dIK0bjng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nw/sSKWz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nw/sSKWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3AF1F00893;
	Tue, 13 Oct 2026 11:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892680;
	bh=H0BUtU5zi0zG6F/Os4fVEZIVMg5rW/kVznJPVLQgcH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nw/sSKWzTtysIpU3LfC6f6pv8F3+wsQ7wmUtgjQuOTJxm2Ri417aP4FcLURma8VNN
	 xaV03bN5/wB8fcmhg5HT2+dyr+9lbvuv87c99C7VzE1RBJfCKlcDAWCeQzHVwhGMxS
	 pMDELr8Grl5F5Ikbp9j/NCatBSCwvAZzeT53COQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 253/281] Revert "net/mlx5: E-Switch, preserve max tx speed on vport state modification"
Date: Tue, 13 Oct 2026 13:39:29 +0200
Message-ID: <20261013112901.282149553@linuxfoundation.org>
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

[ Upstream commit 86b785b18f8f4a6b4a7392d1e2b29d6bb095011a ]

This reverts commit ad0ae7aefa7a ("net/mlx5: E-Switch, preserve max tx
speed on vport state modification").

mlx5_modify_vport_admin_state() and mlx5_esw_adj_vport_modify() query
the vport's current max_tx_speed before modifying its state, and
write that value back, to avoid resetting it to 0 as a side effect
of an unrelated admin-state change.

That's unnecessary: max_tx_speed is optional in MODIFY_VPORT_STATE -
FW skips writing it whenever it's 0, treating that as "not provided"
rather than "reset to zero". Leaving it unset already preserves FW's
current value, with no query needed.

Fixes: ad0ae7aefa7a ("net/mlx5: E-Switch, preserve max tx speed on vport state modification")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261004083531.216988-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/esw/adj_vport.c        | 20 ----------------
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 24 -------------------
 2 files changed, 44 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
index 7950b82d8b8ae..3624c680a861a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
@@ -11,26 +11,6 @@ int mlx5_esw_adj_vport_modify(struct mlx5_core_dev *dev, u16 vport,
 
 	lockdep_assert_held(&dev->priv.eswitch->state_lock);
 
-	if (MLX5_CAP_ESW(dev, esw_vport_state_max_tx_speed)) {
-		u8 op_mod = MLX5_VPORT_STATE_OP_MOD_ESW_VPORT;
-		struct mlx5_vport *esw_vport;
-		u32 speed = 0;
-		int err;
-
-		err = mlx5_query_vport_max_tx_speed(dev, op_mod, vport,
-						    true, &speed, NULL);
-		if (err) {
-			esw_vport = mlx5_eswitch_get_vport(dev->priv.eswitch,
-							   vport);
-			speed = IS_ERR(esw_vport) ? 0 :
-				esw_vport->agg_max_tx_speed;
-			mlx5_core_dbg(dev,
-				      "Failed to query vport %d max tx speed, err=%d, using cached %u\n",
-				      vport, err, speed);
-		}
-		MLX5_SET(modify_vport_state_in, in, max_tx_speed, speed);
-	}
-
 	MLX5_SET(modify_vport_state_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_VPORT_STATE);
 	MLX5_SET(modify_vport_state_in, in, op_mod,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 8aa94ec87a0e3..edac2d694e0f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -93,30 +93,6 @@ int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 	lockdep_assert_held(&mdev->priv.eswitch->state_lock);
 #endif
 
-	if (MLX5_CAP_ESW(mdev, esw_vport_state_max_tx_speed) &&
-	    opmod == MLX5_VPORT_STATE_OP_MOD_ESW_VPORT &&
-	    vport != MLX5_VPORT_UPLINK) {
-		u32 speed = 0;
-		int err;
-
-		err = mlx5_query_vport_max_tx_speed(mdev, opmod, vport,
-						    other_vport, &speed, NULL);
-		if (err) {
-#ifdef CONFIG_MLX5_ESWITCH
-			struct mlx5_vport *esw_vport;
-
-			esw_vport = mlx5_eswitch_get_vport(mdev->priv.eswitch,
-							   vport);
-			speed = IS_ERR(esw_vport) ? 0 :
-				esw_vport->agg_max_tx_speed;
-#endif
-			mlx5_core_dbg(mdev,
-				      "Failed to query vport %d max tx speed, err=%d, using cached %u\n",
-				      vport, err, speed);
-		}
-		MLX5_SET(modify_vport_state_in, in, max_tx_speed, speed);
-	}
-
 	MLX5_SET(modify_vport_state_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_VPORT_STATE);
 	MLX5_SET(modify_vport_state_in, in, op_mod, opmod);
-- 
2.53.0



