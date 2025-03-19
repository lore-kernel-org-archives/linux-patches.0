Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102291CAA60;
	Wed, 19 Mar 2025 14:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395205; cv=none; b=oA95tioLKGyORqfOTgtB3raPGkVNnxyAmXLyRiINu/Ht0mxOw0z/kGH2xUvXSFzNjXOgJi3JuUB3F+NMFf52tPGXxmB0IUf9gMgn1s/DAeqzP3525OCkXi0NcsycrEmcoP8rlZCRQaKNAxvzYA4Yu3PGtH7zSzEUQD82npXEkQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395205; c=relaxed/simple;
	bh=dXvuQ2oRs+87MX+TkTPZBvUM1PhOCjt0mJrR9XpBnYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6hITpeSpOcYx36ZbReRLzTjM5X9Bx97bYRy24M+J1AYnf3s9XEx17Faf07WZZBFv1Cgv/EftWfEd7QxN1PO1LAYZcFkRvA8+pj+0VDX/jM8HjLfOJ32IQ6+rE4ydH0Y7nsEc68/ZxFq9xFFXaZnla0kV73Cu2Fo9CO2fL2OuEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZ07qHAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZ07qHAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEECC4CEE4;
	Wed, 19 Mar 2025 14:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395204;
	bh=dXvuQ2oRs+87MX+TkTPZBvUM1PhOCjt0mJrR9XpBnYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZ07qHALc46ENlZTAncj5V+9HaS6X8rtYbc+jsAFoimaSEDLSAuDCVI25X1W/OJ49
	 RS6atZu2MZSA3VFjaGb42Sp4vBvOPx1EfXFfo4YsdF0sL694E14g1ubEaHYF754dJa
	 LnlIxJs6NtjacKPd5VChiBjjAP+iuygDe+F+uRoQ=
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
Subject: [PATCH 6.6 033/166] net/mlx5: Lag, Check shared fdb before creating MultiPort E-Switch
Date: Wed, 19 Mar 2025 07:30:04 -0700
Message-ID: <20250319143020.887363072@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 18cf756bad8cc..f6b1ac80c0af9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -823,7 +823,7 @@ void mlx5_disable_lag(struct mlx5_lag *ldev)
 				mlx5_eswitch_reload_ib_reps(ldev->pf[i].dev->priv.eswitch);
 }
 
-static bool mlx5_shared_fdb_supported(struct mlx5_lag *ldev)
+bool mlx5_lag_shared_fdb_supported(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev;
 	int i;
@@ -900,7 +900,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 	}
 
 	if (do_bond && !__mlx5_lag_is_active(ldev)) {
-		bool shared_fdb = mlx5_shared_fdb_supported(ldev);
+		bool shared_fdb = mlx5_lag_shared_fdb_supported(ldev);
 
 		roce_lag = mlx5_lag_is_roce_lag(ldev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 481e92f39fe61..b7ccf0e955f56 100644
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
index 6b0413a3987ce..8a07fdf295056 100644
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



