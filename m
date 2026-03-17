Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD8C376477;
	Tue, 17 Mar 2026 16:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765591; cv=none; b=YZbbuFdQw9Q9nUarjGifZDRp1EGeCdsRDRhtHP56d/oxYxI4trmSpClWQfURwxTibd8IoiGFIPf96g6o6UfJcMtMV9WvfY4YyrzkyIALRDsbkJPb/TJb5qG0e4kUgqSky0BWYWKJDMpOAiLhNPupnaYSdp+5siU80kl4psnDLlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765591; c=relaxed/simple;
	bh=qbibnJmI0oNT4FYCDH+gSKlqnkYHqEd86wg6no61Z8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSNWGXg5WumGPzNd2E4sb4hjnTX2bGPyseOXjKdy4rfsArLWV+OW6pl9ZFAheERbFgbGZiOUQc7BTZYI6nebKcC2nzV96PbhiLodc8u+ObGfsKKq97wy5fX1jWV76QGlesLDVYvs9sQj0547d0aCFYRgou+G+RGwmKiasNKeCaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARDuJvah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARDuJvah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE42C4CEF7;
	Tue, 17 Mar 2026 16:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765591;
	bh=qbibnJmI0oNT4FYCDH+gSKlqnkYHqEd86wg6no61Z8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARDuJvahfFNsXQNPn8Upg572R18efAuXN0Uc206t6qO8FjbU3JqEP/ZiX8aMWjCe0
	 T8jR3Jv/GZhyicgyPg/Zl2ZF21iQHARohSDXyzF9AYMIqczmC3QAJiYBqZ99XfCiHY
	 UXPL/6iKAYzr9lJHTnqEVIqCNHwOL78IN7rY9fk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 045/378] net/mlx5: Fix peer miss rules host disabled checks
Date: Tue, 17 Mar 2026 17:30:02 +0100
Message-ID: <20260317163008.645255355@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 76324e4041c0efb4808702b05426d7a0a7d8df5b ]

The check on mlx5_esw_host_functions_enabled(esw->dev) for adding VF
peer miss rules is incorrect. These rules match traffic from peer's VFs,
so the local device's host function status is irrelevant. Remove this
check to ensure peer VF traffic is properly handled regardless of local
host configuration.

Also fix the PF peer miss rule deletion to be symmetric with the add
path, so only attempt to delete the rule if it was actually created.

Fixes: 520369ef43a8 ("net/mlx5: Support disabling host PFs")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260305142634.1813208-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 27 +++++++++----------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index c79231b437976..166a88988904e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1241,21 +1241,17 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 		flows[peer_vport->index] = flow;
 	}
 
-	if (mlx5_esw_host_functions_enabled(esw->dev)) {
-		mlx5_esw_for_each_vf_vport(peer_esw, i, peer_vport,
-					   mlx5_core_max_vfs(peer_dev)) {
-			esw_set_peer_miss_rule_source_port(esw, peer_esw,
-							   spec,
-							   peer_vport->vport);
-
-			flow = mlx5_add_flow_rules(mlx5_eswitch_get_slow_fdb(esw),
-						   spec, &flow_act, &dest, 1);
-			if (IS_ERR(flow)) {
-				err = PTR_ERR(flow);
-				goto add_vf_flow_err;
-			}
-			flows[peer_vport->index] = flow;
+	mlx5_esw_for_each_vf_vport(peer_esw, i, peer_vport,
+				   mlx5_core_max_vfs(peer_dev)) {
+		esw_set_peer_miss_rule_source_port(esw, peer_esw, spec,
+						   peer_vport->vport);
+		flow = mlx5_add_flow_rules(mlx5_eswitch_get_slow_fdb(esw),
+					   spec, &flow_act, &dest, 1);
+		if (IS_ERR(flow)) {
+			err = PTR_ERR(flow);
+			goto add_vf_flow_err;
 		}
+		flows[peer_vport->index] = flow;
 	}
 
 	if (mlx5_core_ec_sriov_enabled(peer_dev)) {
@@ -1347,7 +1343,8 @@ static void esw_del_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 		mlx5_del_flow_rules(flows[peer_vport->index]);
 	}
 
-	if (mlx5_core_is_ecpf_esw_manager(peer_dev)) {
+	if (mlx5_core_is_ecpf_esw_manager(peer_dev) &&
+	    mlx5_esw_host_functions_enabled(peer_dev)) {
 		peer_vport = mlx5_eswitch_get_vport(peer_esw, MLX5_VPORT_PF);
 		mlx5_del_flow_rules(flows[peer_vport->index]);
 	}
-- 
2.51.0



