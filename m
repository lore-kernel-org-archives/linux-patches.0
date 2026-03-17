Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620E63F880C;
	Tue, 17 Mar 2026 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767375; cv=none; b=QpD5n1KWcs3JVPFlpRWcel9mAgGSxNAHqCOtXHcDh6NEUD+AZkrp9pFY6T0BfegunRp8ttkNN3cs9pTWXlD74L/LUbhGcqCSbbM7gOhRXCsWAqo+jPa8ODhwhKM7CLM9ufpHrax5oRBA7GdcTSkJizQyK3vPANVugWVnKsg55jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767375; c=relaxed/simple;
	bh=rWUOMPSKBbuk1cI9rH1VDf8DwTJbehsv0JBcO8Uiisg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKmh+KHlH3FRYvmxGQ7FbqxWiTKD9GQFNelc9pm65mjUAuThL6JckHu2BTkhI7QapMGKt0cz8qJ0Ib4GtHcgldr2zSb1uaeaXAb0zu/qWQ84/h4gkg0yUJGED+xVoFfzbqVxcQNbOsCvuz4l1BT+stib9HIvBSQhWV8lXoLzbBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drt5sVJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drt5sVJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE367C4CEF7;
	Tue, 17 Mar 2026 17:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767375;
	bh=rWUOMPSKBbuk1cI9rH1VDf8DwTJbehsv0JBcO8Uiisg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drt5sVJUoG3QrOISFjTUnMDHvwnvc8c1jlCARcZ1s3LV3pRTpmLdpQJBjzOavN5Di
	 Yu30t3sUuMSUYUvh2apSvgAT4l569Im4ffKA3XXZgze+ke2E0Qx3AYMIz6kO2cV7Ex
	 ZtxYGtOllhEMFOX32bH2pf2BaooKr3RvFEQDNSmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/333] net/mlx5: Fix peer miss rules host disabled checks
Date: Tue, 17 Mar 2026 17:31:10 +0100
Message-ID: <20260317163000.887357356@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
index 1ff6c3d502e9b..f1585df13b732 100644
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



