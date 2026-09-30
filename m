Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C58151598A;
	Wed, 30 Sep 2026 16:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786991; cv=none; b=Ha9AM7a7Var7M7LlxSKw+u/QoQfLyFw0xkU9KpmPeUZVx48QtAuN/Y2IOfjvp6SSAEllUsHGN5NxCCGEMfjo3J5d83zdvOD2POgWxGSIiaDgnLNrkpxOIaop6zGC7/A7QHkjWu3F7hfbDkvEPENbNWoMFKabtkKdtoRl8qXMVHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786991; c=relaxed/simple;
	bh=SkTXZkhj22zT6yE8EN4AxfpZ8Csi4wAqR4+gIpYrOuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxfbvBFw1djzjgFPeRhf1qJ7ghYeeenHJn5DndbMq4jUw3LvlR1FZ3xsCX8RAKT1tvKDV8qWiuiTy+27qvG1pbLvqUXdGCBOuiJ2rPeFLJCJVr9weKoSCdwKOKp168VMVfOkSO5FIrKDfI190uZGfpRRdHzeonYzy5xGHyRuOgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHeOkq81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHeOkq81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C01B1F000FF;
	Wed, 30 Sep 2026 16:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786989;
	bh=Meav4Kr2P2ls280sRR0WLn4RqOaRlhBO72FqRqggg7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uHeOkq81hjcnAolU009uhq9gaFXAhp/MondktGslIe2Z3xts3gcBSbe+O/a4XBACR
	 7bRXj7gliwsyFraHeU2qUNj+BHfP7T6QA4o7VpwkGVeVmNnCAjvK4S5po/LZHFz/UU
	 mUowZpn76OxcfipM1NkJmj8Bi6tzLmcU5YsjT+S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 074/457] net/mlx5: LAG, reload IB reps of LAG master before the rest
Date: Wed, 30 Sep 2026 17:22:59 +0200
Message-ID: <20260930152347.645700277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit bae23d1ae62092c7f0ec6d5f7e1be5d164822638 ]

In a shared-FDB LAG the master device creates the bond IB device; the
other LAG members do not create their own, they populate a port inside
the master's IB device. mlx5_lag_reload_ib_reps_unlocked() reloaded the
members' IB reps in iteration order, with no guarantee the master is
reloaded first. When a non-master member is reloaded before the master,
it tries to populate its port in an IB device that has not been
recreated yet.

Hence, reload the master's IB reps first, then every other member.

Fixes: 2b204cdb1206 ("net/mlx5: LAG, use xa_alloc to manage LAG device indices")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260915113459.3934760-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 44 ++++++++++++++-----
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index c655f6e32e9b0..dd14cdc378de0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1266,25 +1266,45 @@ void mlx5_lag_remove_devices(struct mlx5_lag *ldev)
 	mlx5_lag_remove_devices_filter(ldev, MLX5_LAG_FILTER_PORTS);
 }
 
+static int mlx5_lag_reload_ib_reps_idx(struct mlx5_lag *ldev, int idx,
+				       u32 flags)
+{
+	struct lag_func *pf = mlx5_lag_pf(ldev, idx);
+	struct mlx5_eswitch *esw;
+	int ret;
+
+	if (pf->dev->priv.flags & flags)
+		return 0;
+
+	esw = pf->dev->priv.eswitch;
+	mlx5_esw_reps_block(esw);
+	ret = mlx5_eswitch_reload_ib_reps(esw);
+	mlx5_esw_reps_unblock(esw);
+
+	return ret;
+}
+
 static int mlx5_lag_reload_ib_reps_unlocked(struct mlx5_lag *ldev, u32 flags,
 					    u32 filter, bool cont_on_fail)
 {
-	struct lag_func *pf;
+	int master_idx = mlx5_lag_get_dev_index_by_seq_filter(ldev, MLX5_LAG_P1,
+							     filter);
 	int ret;
 	int i;
 
+	if (master_idx < 0)
+		return -EINVAL;
+
+	ret = mlx5_lag_reload_ib_reps_idx(ldev, master_idx, flags);
+	if (ret && !cont_on_fail)
+		return ret;
+
 	mlx5_lag_for_each(i, 0, ldev, filter) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (!(pf->dev->priv.flags & flags)) {
-			struct mlx5_eswitch *esw;
-
-			esw = pf->dev->priv.eswitch;
-			mlx5_esw_reps_block(esw);
-			ret = mlx5_eswitch_reload_ib_reps(esw);
-			mlx5_esw_reps_unblock(esw);
-			if (ret && !cont_on_fail)
-				return ret;
-		}
+		if (i == master_idx)
+			continue;
+		ret = mlx5_lag_reload_ib_reps_idx(ldev, i, flags);
+		if (ret && !cont_on_fail)
+			return ret;
 	}
 
 	return 0;
-- 
2.53.0



