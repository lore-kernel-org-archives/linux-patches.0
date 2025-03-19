Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839FC1D5142;
	Wed, 19 Mar 2025 14:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395032; cv=none; b=Sitb8Evmrqa4vP758iLEsLMJU8CDI1DJFvciw/uFifm3aTVYfh9GxkksiXEhK3r00kL/RaZ96EHJ7dM32b9rXz65dzqh2Kf8PRdXK0vRv6QaBsXs3IS/xqeIBLrfiPjk34NWFKY2IIaHsBMYU+j39oMLwHL0pjh+eTVCHyoeW7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395032; c=relaxed/simple;
	bh=JmuGfy0rT4b4Td6c5Rk96avvY+R1UN9dPiJR4WYWq9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCMsQrvlxUDXyPyxCM6yNXbwRqGC26WekjM7jXkTA9X+Wa5wqL2YmSWfH4dTbRrcFMdHiHiiXxDBWQwkEop420Tx7slO8Rqt5Sb4S1evNUtpKAmhfpidCXdEJRNp7wPdTFw65fBC/raNRtL2xIcvQi9ApRoJDDGTSAhf0ceIBCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFIDCavG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFIDCavG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5937CC4CEE4;
	Wed, 19 Mar 2025 14:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395032;
	bh=JmuGfy0rT4b4Td6c5Rk96avvY+R1UN9dPiJR4WYWq9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFIDCavGnjYegpzF3XfgO+5PvCPAVlzXG9/0dbNEmxuJ9490tKLPrOrwnx0TUda8m
	 w20CF1ib5SwUx2voOsSGUYL0Pn5BqKVSI2T21RiX4gGvIbV+PMGVVHDz3P9lALkALz
	 m8IE05uR061p4z5++DFzISNjqynTkQ/vFLU7gPJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/231] net/mlx5: Lag, Check shared fdb before creating MultiPort E-Switch
Date: Wed, 19 Mar 2025 07:29:06 -0700
Message-ID: <20250319143028.134975205@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 32966984bee1defd9f5a8f9be274d7c32f911ba1 ]

Currently, MultiPort E-Switch is requesting to create a LAG with shared
FDB without checking the LAG is supporting shared FDB.
Add the check.

Fixes: a32327a3a02c ("net/mlx5: Lag, Control MultiPort E-Switch single FDB mode")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/1741644104-97767-5-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c   | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h   | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 7f68468c2e759..4b3da7ebd6310 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -859,7 +859,7 @@ void mlx5_disable_lag(struct mlx5_lag *ldev)
 				mlx5_eswitch_reload_ib_reps(ldev->pf[i].dev->priv.eswitch);
 }
 
-static bool mlx5_shared_fdb_supported(struct mlx5_lag *ldev)
+bool mlx5_lag_shared_fdb_supported(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev;
 	int i;
@@ -937,7 +937,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 	}
 
 	if (do_bond && !__mlx5_lag_is_active(ldev)) {
-		bool shared_fdb = mlx5_shared_fdb_supported(ldev);
+		bool shared_fdb = mlx5_lag_shared_fdb_supported(ldev);
 
 		roce_lag = mlx5_lag_is_roce_lag(ldev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 50fcb1eee5748..48a5f3e7b91a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -92,6 +92,7 @@ mlx5_lag_is_ready(struct mlx5_lag *ldev)
 	return test_bit(MLX5_LAG_FLAG_NDEVS_READY, &ldev->state_flags);
 }
 
+bool mlx5_lag_shared_fdb_supported(struct mlx5_lag *ldev);
 bool mlx5_lag_check_prereq(struct mlx5_lag *ldev);
 void mlx5_modify_lag(struct mlx5_lag *ldev,
 		     struct lag_tracker *tracker);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 571ea26edd0ca..2381a0eec1900 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -81,7 +81,8 @@ static int enable_mpesw(struct mlx5_lag *ldev)
 	if (mlx5_eswitch_mode(dev0) != MLX5_ESWITCH_OFFLOADS ||
 	    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table) ||
 	    !MLX5_CAP_GEN(dev0, create_lag_when_not_master_up) ||
-	    !mlx5_lag_check_prereq(ldev))
+	    !mlx5_lag_check_prereq(ldev) ||
+	    !mlx5_lag_shared_fdb_supported(ldev))
 		return -EOPNOTSUPP;
 
 	err = mlx5_mpesw_metadata_set(ldev);
-- 
2.39.5



