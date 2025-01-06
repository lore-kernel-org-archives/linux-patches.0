Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184BB16DEBB;
	Mon,  6 Jan 2025 15:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177529; cv=none; b=VQZi99G4V/rxbAwc0fWBD+INK5g97CsjhhLkNAL2ouYeSiWbpYVod8ooAkXj8oh+1ngTO8vmm5PMFcXLNRIuTy3NkOfctkLyyZjPU+fdemiKgBzYWCGRX87cFdzIrvR6o0I6KDhpoHAawT3aMmcPeATgMvrkihFFB7umijGtBR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177529; c=relaxed/simple;
	bh=DUa6QxOCtMLT0pFMz60PRkv1xvDMJ8lV13DRv6+vi+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPpn9whJ1ceLndhIwsOjBH19Eg8Vv/8rjCinOioUfyyVI8Vdl2EPZNaboLBj0Bd6TqAMeAPdS3IQvXaTa2OTaM19IlVib7rn37Cy8rlxQClbiyLdkX46IDReEaGmMFyvnyqfFT+t9t5TrkcxSy4JlIhludQIxljG3OYMr14J2q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWhqeyvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWhqeyvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E20AC4CEDF;
	Mon,  6 Jan 2025 15:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177527;
	bh=DUa6QxOCtMLT0pFMz60PRkv1xvDMJ8lV13DRv6+vi+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWhqeyvEZLAMbM9YbqJl00JVj8wu8BBbj7QUiza1kraCTkH8RpBozIwneeHgdfIno
	 fRic2n9h5VuHjYDE0VbBb+8uFNMUxzzcqZvLZSZk9fa4ksorfN7iUib1FXbelCyUNn
	 ZnHnQb7Pql/KPDk9YKzsZEn0giMwiaK8WaQEoiHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/222] net/mlx5e: Skip restore TC rules for vport rep without loaded flag
Date: Mon,  6 Jan 2025 16:16:05 +0100
Message-ID: <20250106151156.856331380@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 5a03b368562a7ff5f5f1f63b5adf8309cbdbd5be ]

During driver unload, unregister_netdev is called after unloading
vport rep. So, the mlx5e_rep_priv is already freed while trying to get
rpriv->netdev, or walk rpriv->tc_ht, which results in use-after-free.
So add the checking to make sure access the data of vport rep which is
still loaded.

Fixes: d1569537a837 ("net/mlx5e: Modify and restore TC rules for IPSec TX rules")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241220081505.1286093-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c     | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h          | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
index 13b5916b64e2..eed8fcde2613 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
@@ -150,11 +150,11 @@ void mlx5_esw_ipsec_restore_dest_uplink(struct mlx5_core_dev *mdev)
 	unsigned long i;
 	int err;
 
-	xa_for_each(&esw->offloads.vport_reps, i, rep) {
-		rpriv = rep->rep_data[REP_ETH].priv;
-		if (!rpriv || !rpriv->netdev)
+	mlx5_esw_for_each_rep(esw, i, rep) {
+		if (atomic_read(&rep->rep_data[REP_ETH].state) != REP_LOADED)
 			continue;
 
+		rpriv = rep->rep_data[REP_ETH].priv;
 		rhashtable_walk_enter(&rpriv->tc_ht, &iter);
 		rhashtable_walk_start(&iter);
 		while ((flow = rhashtable_walk_next(&iter)) != NULL) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 9b771b572593..3e58e731b569 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -713,6 +713,9 @@ void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw);
 			  MLX5_CAP_GEN_2((esw->dev), ec_vf_vport_base) +\
 			  (last) - 1)
 
+#define mlx5_esw_for_each_rep(esw, i, rep) \
+	xa_for_each(&((esw)->offloads.vport_reps), i, rep)
+
 struct mlx5_eswitch *__must_check
 mlx5_devlink_eswitch_get(struct devlink *devlink);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 58529d1a98b3..7eba3a5bb97c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -52,9 +52,6 @@
 #include "lag/lag.h"
 #include "en/tc/post_meter.h"
 
-#define mlx5_esw_for_each_rep(esw, i, rep) \
-	xa_for_each(&((esw)->offloads.vport_reps), i, rep)
-
 /* There are two match-all miss flows, one for unicast dst mac and
  * one for multicast.
  */
-- 
2.39.5



