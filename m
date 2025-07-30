Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47052226D17;
	Wed, 30 Jul 2025 09:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869242; cv=none; b=Im9hJ5KcTBF9GDpBxR9/0OvkJTlxFCkYletAYlmlBn6x90/n2a8z1IVPqsIku9lTWOhpbwsJxs9Ag8arVJVlfel9PC3KWv2J2eGsOUt6KLn0N0NIp0JTLBlk+LTsWJWI+C9Ov+2WLrMan6L0A6h+Qrb7m6oErYOGu3cdJMNDH0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869242; c=relaxed/simple;
	bh=DBRQY2NM7kKiPdFiguhiIhViRemLQQFU6/648JAY9uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N87UYWHK++9qkCjdgW/54ISYOtT7rOgYQ8wQn8hNZlzyW3j3Iapwy9Ipdnk5iSAnY8AqLvW73KXMQpJpVB+X8Roz/Z1ZxA0irrSzV1opMx5EwdeEZoVourl/3K95jQCFMw32axbaGYWVuetWma3E3q+2QbjTBVvRfk0oiISTLec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjczXnLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjczXnLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C45C4CEF5;
	Wed, 30 Jul 2025 09:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869241;
	bh=DBRQY2NM7kKiPdFiguhiIhViRemLQQFU6/648JAY9uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjczXnLUQW6L/4++SuD/FcmDdyuH1Vsx0HJ2ee3vgEVl/lhxTb2uRO0WiLAd8ytO/
	 lW78oqOJ9zWGH67U2GEWxGjX9wDLFmG7fWJtZjJUWHYfi++rYUkwzY4OkcDN9jAVFg
	 T9j+vtDar4nHiGNkBSHM+whkxcY/zB/Tgficu9LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 29/92] net/mlx5: E-Switch, Fix peer miss rules to use peer eswitch
Date: Wed, 30 Jul 2025 11:35:37 +0200
Message-ID: <20250730093231.883832570@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit 5b4c56ad4da0aa00b258ab50b1f5775b7d3108c7 ]

In the original design, it is assumed local and peer eswitches have the
same number of vfs. However, in new firmware, local and peer eswitches
can have different number of vfs configured by mlxconfig.  In such
configuration, it is incorrect to derive the number of vfs from the
local device's eswitch.

Fix this by updating the peer miss rules add and delete functions to use
the peer device's eswitch and vf count instead of the local device's
information, ensuring correct behavior regardless of vf configuration
differences.

Fixes: ac004b832128 ("net/mlx5e: E-Switch, Add peer miss rules")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1752753970-261832-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 108 +++++++++---------
 1 file changed, 54 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 0e3a977d53329..bee906661282a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1182,19 +1182,19 @@ static void esw_set_peer_miss_rule_source_port(struct mlx5_eswitch *esw,
 static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 				       struct mlx5_core_dev *peer_dev)
 {
+	struct mlx5_eswitch *peer_esw = peer_dev->priv.eswitch;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act flow_act = {0};
 	struct mlx5_flow_handle **flows;
-	/* total vports is the same for both e-switches */
-	int nvports = esw->total_vports;
 	struct mlx5_flow_handle *flow;
+	struct mlx5_vport *peer_vport;
 	struct mlx5_flow_spec *spec;
-	struct mlx5_vport *vport;
 	int err, pfindex;
 	unsigned long i;
 	void *misc;
 
-	if (!MLX5_VPORT_MANAGER(esw->dev) && !mlx5_core_is_ecpf_esw_manager(esw->dev))
+	if (!MLX5_VPORT_MANAGER(peer_dev) &&
+	    !mlx5_core_is_ecpf_esw_manager(peer_dev))
 		return 0;
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
@@ -1203,7 +1203,7 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 
 	peer_miss_rules_setup(esw, peer_dev, spec, &dest);
 
-	flows = kvcalloc(nvports, sizeof(*flows), GFP_KERNEL);
+	flows = kvcalloc(peer_esw->total_vports, sizeof(*flows), GFP_KERNEL);
 	if (!flows) {
 		err = -ENOMEM;
 		goto alloc_flows_err;
@@ -1213,10 +1213,10 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 	misc = MLX5_ADDR_OF(fte_match_param, spec->match_value,
 			    misc_parameters);
 
-	if (mlx5_core_is_ecpf_esw_manager(esw->dev)) {
-		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
-		esw_set_peer_miss_rule_source_port(esw, peer_dev->priv.eswitch,
-						   spec, MLX5_VPORT_PF);
+	if (mlx5_core_is_ecpf_esw_manager(peer_dev)) {
+		peer_vport = mlx5_eswitch_get_vport(peer_esw, MLX5_VPORT_PF);
+		esw_set_peer_miss_rule_source_port(esw, peer_esw, spec,
+						   MLX5_VPORT_PF);
 
 		flow = mlx5_add_flow_rules(mlx5_eswitch_get_slow_fdb(esw),
 					   spec, &flow_act, &dest, 1);
@@ -1224,11 +1224,11 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 			err = PTR_ERR(flow);
 			goto add_pf_flow_err;
 		}
-		flows[vport->index] = flow;
+		flows[peer_vport->index] = flow;
 	}
 
-	if (mlx5_ecpf_vport_exists(esw->dev)) {
-		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
+	if (mlx5_ecpf_vport_exists(peer_dev)) {
+		peer_vport = mlx5_eswitch_get_vport(peer_esw, MLX5_VPORT_ECPF);
 		MLX5_SET(fte_match_set_misc, misc, source_port, MLX5_VPORT_ECPF);
 		flow = mlx5_add_flow_rules(mlx5_eswitch_get_slow_fdb(esw),
 					   spec, &flow_act, &dest, 1);
@@ -1236,13 +1236,14 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 			err = PTR_ERR(flow);
 			goto add_ecpf_flow_err;
 		}
-		flows[vport->index] = flow;
+		flows[peer_vport->index] = flow;
 	}
 
-	mlx5_esw_for_each_vf_vport(esw, i, vport, mlx5_core_max_vfs(esw->dev)) {
+	mlx5_esw_for_each_vf_vport(peer_esw, i, peer_vport,
+				   mlx5_core_max_vfs(peer_dev)) {
 		esw_set_peer_miss_rule_source_port(esw,
-						   peer_dev->priv.eswitch,
-						   spec, vport->vport);
+						   peer_esw,
+						   spec, peer_vport->vport);
 
 		flow = mlx5_add_flow_rules(mlx5_eswitch_get_slow_fdb(esw),
 					   spec, &flow_act, &dest, 1);
@@ -1250,22 +1251,22 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 			err = PTR_ERR(flow);
 			goto add_vf_flow_err;
 		}
-		flows[vport->index] = flow;
+		flows[peer_vport->index] = flow;
 	}
 
-	if (mlx5_core_ec_sriov_enabled(esw->dev)) {
-		mlx5_esw_for_each_ec_vf_vport(esw, i, vport, mlx5_core_max_ec_vfs(esw->dev)) {
-			if (i >= mlx5_core_max_ec_vfs(peer_dev))
-				break;
-			esw_set_peer_miss_rule_source_port(esw, peer_dev->priv.eswitch,
-							   spec, vport->vport);
+	if (mlx5_core_ec_sriov_enabled(peer_dev)) {
+		mlx5_esw_for_each_ec_vf_vport(peer_esw, i, peer_vport,
+					      mlx5_core_max_ec_vfs(peer_dev)) {
+			esw_set_peer_miss_rule_source_port(esw, peer_esw,
+							   spec,
+							   peer_vport->vport);
 			flow = mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
 						   spec, &flow_act, &dest, 1);
 			if (IS_ERR(flow)) {
 				err = PTR_ERR(flow);
 				goto add_ec_vf_flow_err;
 			}
-			flows[vport->index] = flow;
+			flows[peer_vport->index] = flow;
 		}
 	}
 
@@ -1282,25 +1283,27 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 	return 0;
 
 add_ec_vf_flow_err:
-	mlx5_esw_for_each_ec_vf_vport(esw, i, vport, mlx5_core_max_ec_vfs(esw->dev)) {
-		if (!flows[vport->index])
+	mlx5_esw_for_each_ec_vf_vport(peer_esw, i, peer_vport,
+				      mlx5_core_max_ec_vfs(peer_dev)) {
+		if (!flows[peer_vport->index])
 			continue;
-		mlx5_del_flow_rules(flows[vport->index]);
+		mlx5_del_flow_rules(flows[peer_vport->index]);
 	}
 add_vf_flow_err:
-	mlx5_esw_for_each_vf_vport(esw, i, vport, mlx5_core_max_vfs(esw->dev)) {
-		if (!flows[vport->index])
+	mlx5_esw_for_each_vf_vport(peer_esw, i, peer_vport,
+				   mlx5_core_max_vfs(peer_dev)) {
+		if (!flows[peer_vport->index])
 			continue;
-		mlx5_del_flow_rules(flows[vport->index]);
+		mlx5_del_flow_rules(flows[peer_vport->index]);
 	}
-	if (mlx5_ecpf_vport_exists(esw->dev)) {
-		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
-		mlx5_del_flow_rules(flows[vport->index]);
+	if (mlx5_ecpf_vport_exists(peer_dev)) {
+		peer_vport = mlx5_eswitch_get_vport(peer_esw, MLX5_VPORT_ECPF);
+		mlx5_del_flow_rules(flows[peer_vport->index]);
 	}
 add_ecpf_flow_err:
-	if (mlx5_core_is_ecpf_esw_manager(esw->dev)) {
-		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
-		mlx5_del_flow_rules(flows[vport->index]);
+	if (mlx5_core_is_ecpf_esw_manager(peer_dev)) {
+		peer_vport = mlx5_eswitch_get_vport(peer_esw, MLX5_VPORT_PF);
+		mlx5_del_flow_rules(flows[peer_vport->index]);
 	}
 add_pf_flow_err:
 	esw_warn(esw->dev, "FDB: Failed to add peer miss flow rule err %d\n", err);
@@ -1313,37 +1316,34 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 static void esw_del_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 					struct mlx5_core_dev *peer_dev)
 {
+	struct mlx5_eswitch *peer_esw = peer_dev->priv.eswitch;
 	u16 peer_index = mlx5_get_dev_index(peer_dev);
 	struct mlx5_flow_handle **flows;
-	struct mlx5_vport *vport;
+	struct mlx5_vport *peer_vport;
 	unsigned long i;
 
 	flows = esw->fdb_table.offloads.peer_miss_rules[peer_index];
 	if (!flows)
 		return;
 
-	if (mlx5_core_ec_sriov_enabled(esw->dev)) {
-		mlx5_esw_for_each_ec_vf_vport(esw, i, vport, mlx5_core_max_ec_vfs(esw->dev)) {
-			/* The flow for a particular vport could be NULL if the other ECPF
-			 * has fewer or no VFs enabled
-			 */
-			if (!flows[vport->index])
-				continue;
-			mlx5_del_flow_rules(flows[vport->index]);
-		}
+	if (mlx5_core_ec_sriov_enabled(peer_dev)) {
+		mlx5_esw_for_each_ec_vf_vport(peer_esw, i, peer_vport,
+					      mlx5_core_max_ec_vfs(peer_dev))
+			mlx5_del_flow_rules(flows[peer_vport->index]);
 	}
 
-	mlx5_esw_for_each_vf_vport(esw, i, vport, mlx5_core_max_vfs(esw->dev))
-		mlx5_del_flow_rules(flows[vport->index]);
+	mlx5_esw_for_each_vf_vport(peer_esw, i, peer_vport,
+				   mlx5_core_max_vfs(peer_dev))
+		mlx5_del_flow_rules(flows[peer_vport->index]);
 
-	if (mlx5_ecpf_vport_exists(esw->dev)) {
-		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
-		mlx5_del_flow_rules(flows[vport->index]);
+	if (mlx5_ecpf_vport_exists(peer_dev)) {
+		peer_vport = mlx5_eswitch_get_vport(peer_esw, MLX5_VPORT_ECPF);
+		mlx5_del_flow_rules(flows[peer_vport->index]);
 	}
 
-	if (mlx5_core_is_ecpf_esw_manager(esw->dev)) {
-		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
-		mlx5_del_flow_rules(flows[vport->index]);
+	if (mlx5_core_is_ecpf_esw_manager(peer_dev)) {
+		peer_vport = mlx5_eswitch_get_vport(peer_esw, MLX5_VPORT_PF);
+		mlx5_del_flow_rules(flows[peer_vport->index]);
 	}
 
 	kvfree(flows);
-- 
2.39.5



