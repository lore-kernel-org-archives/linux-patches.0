Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254193925A
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D69C433D2;
	Wed,  7 Jun 2023 20:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169281;
	bh=NItoA8riAvosT2BvL4GdN2PquwDZBqBClHZXcdRX/4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3CDhho/rO3BYrSKvi2fgZsn/RsCtSEsHqhRb9Ir5FGuL28y3uh3yjaJQsqXplVg6
	 iza5qdH5lbGVdjwbwwnGVMvudxqxQwoZXEfKQHF0zhJ0vxXGJxT2kDHSjEcZcVEVYw
	 lqKRWRbB+YM6WftfYqqwSD9raWF2c5dS/Nucv0+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Blakey <paulb@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 021/286] net/mlx5e: TC, Move main flow attribute cleanup to helper func
Date: Wed,  7 Jun 2023 22:12:00 +0200
Message-ID: <20230607200923.706927618@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit a830ec485e8368a29e328d08e2eb28750bbc483f ]

Actions that can be setup per flow attribute (so per split rule)
are cleaned up from mlx5_free_flow_attr(), mlx5e_tc_del_fdb_flow(),
and free_flow_post_acts().

Remove the duplication by re-using the helper function for
the main flow attribute and split rules attributes.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 37c3b9fa7ccf ("net/mlx5e: Prevent encap offload when neigh update is running")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 27 +++++++------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d9e651d33f8b8..3827dbc2b39c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -183,7 +183,8 @@ static struct lock_class_key tc_ht_wq_key;
 
 static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow);
 static void free_flow_post_acts(struct mlx5e_tc_flow *flow);
-static void mlx5_free_flow_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr);
+static void mlx5_free_flow_attr_actions(struct mlx5e_tc_flow *flow,
+					struct mlx5_flow_attr *attr);
 
 void
 mlx5e_tc_match_to_reg_match(struct mlx5_flow_spec *spec,
@@ -2028,7 +2029,7 @@ static void free_branch_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *
 	if (!attr)
 		return;
 
-	mlx5_free_flow_attr(flow, attr);
+	mlx5_free_flow_attr_actions(flow, attr);
 	kvfree(attr->parse_attr);
 	kfree(attr);
 }
@@ -2060,18 +2061,8 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (flow->decap_route)
 		mlx5e_detach_decap_route(priv, flow);
 
-	clean_encap_dests(priv, flow, attr);
-
 	mlx5_tc_ct_match_del(get_ct_priv(priv), &flow->attr->ct_attr);
 
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
-		mlx5e_mod_hdr_dealloc(&attr->parse_attr->mod_hdr_acts);
-		mlx5e_tc_detach_mod_hdr(priv, flow, attr);
-	}
-
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
-		mlx5_fc_destroy(esw_attr->counter_dev, attr->counter);
-
 	if (esw_attr->int_port)
 		mlx5e_tc_int_port_put(mlx5e_get_int_port_priv(priv), esw_attr->int_port);
 
@@ -2084,8 +2075,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	mlx5e_tc_act_stats_del_flow(get_act_stats_handle(priv), flow);
 
 	free_flow_post_acts(flow);
-	free_branch_attr(flow, attr->branch_true);
-	free_branch_attr(flow, attr->branch_false);
+	mlx5_free_flow_attr_actions(flow, attr);
 
 	kvfree(attr->esw_attr->rx_tun_attr);
 	kvfree(attr->parse_attr);
@@ -3804,9 +3794,7 @@ free_flow_post_acts(struct mlx5e_tc_flow *flow)
 		if (list_is_last(&attr->list, &flow->attrs))
 			break;
 
-		mlx5_free_flow_attr(flow, attr);
-		free_branch_attr(flow, attr->branch_true);
-		free_branch_attr(flow, attr->branch_false);
+		mlx5_free_flow_attr_actions(flow, attr);
 
 		list_del(&attr->list);
 		kvfree(attr->parse_attr);
@@ -4441,7 +4429,7 @@ mlx5_alloc_flow_attr(enum mlx5_flow_namespace_type type)
 }
 
 static void
-mlx5_free_flow_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr)
+mlx5_free_flow_attr_actions(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr)
 {
 	struct mlx5_core_dev *counter_dev = get_flow_counter_dev(flow);
 
@@ -4460,6 +4448,9 @@ mlx5_free_flow_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr)
 		mlx5e_mod_hdr_dealloc(&attr->parse_attr->mod_hdr_acts);
 		mlx5e_tc_detach_mod_hdr(flow->priv, flow, attr);
 	}
+
+	free_branch_attr(flow, attr->branch_true);
+	free_branch_attr(flow, attr->branch_false);
 }
 
 static int
-- 
2.39.2



