Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15477E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE27EC433D6;
	Wed,  2 Nov 2022 02:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357771;
	bh=e2z3GNJ4ETEM5sZw1Kn+BpF8yz3/PLm0BM3XeJG11jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izsZ4AfEF3yi9X3mfBVvjsL+fhu7Fn7jPDlvzBBoU2KF3JY6/PAoNgYX6n80W4F8+
	 Rb+/rRCqUh2TRr1WAKeq/S3LOJ2g1Xlw/WkkpBgAtTZi9LLmulqaXTZ3tzutOMyLBJ
	 BHymQwpNwaKEzdjCoPsetb8HvggPtAAz4pEJGcqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Blakey <paulb@nvidia.com>,
	Oz Shlomo <ozsh@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 227/240] net/mlx5e: Update restore chain id for slow path packets
Date: Wed,  2 Nov 2022 03:33:22 +0100
Message-Id: <20221102022116.537176253@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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

[ Upstream commit 8dc47c0527c1586e3ebe0efd323f1d8abb181c77 ]

Currently encap slow path rules just forward to software without
setting the chain id miss register, so driver doesn't restore
the chain, and packets hitting this rule will restart from tc chain
0 instead of continuing to the chain the encap rule was on.

Fix this by setting the chain id miss register to the chain id mapping.

Fixes: 8f1e0b97cc70 ("net/mlx5: E-Switch, Mark miss packets with new chain id mapping")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20221026135153.154807-6-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 62 ++++++++++++++++++-
 2 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 10c9a8a79d00..2e42d7c5451e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -96,6 +96,7 @@ struct mlx5e_tc_flow {
 	struct encap_flow_item encaps[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct mlx5e_tc_flow *peer_flow;
 	struct mlx5e_mod_hdr_handle *mh; /* attached mod header instance */
+	struct mlx5e_mod_hdr_handle *slow_mh; /* attached mod header instance for slow path */
 	struct mlx5e_hairpin_entry *hpe; /* attached hairpin instance */
 	struct list_head hairpin; /* flows sharing the same hairpin */
 	struct list_head peer;    /* flows with peer flow */
@@ -111,6 +112,7 @@ struct mlx5e_tc_flow {
 	struct completion del_hw_done;
 	struct mlx5_flow_attr *attr;
 	struct list_head attrs;
+	u32 chain_mapping;
 };
 
 struct mlx5_flow_handle *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f154bda668ad..6a0df046064f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1394,8 +1394,13 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 			      struct mlx5e_tc_flow *flow,
 			      struct mlx5_flow_spec *spec)
 {
+	struct mlx5e_tc_mod_hdr_acts mod_acts = {};
+	struct mlx5e_mod_hdr_handle *mh = NULL;
 	struct mlx5_flow_attr *slow_attr;
 	struct mlx5_flow_handle *rule;
+	bool fwd_and_modify_cap;
+	u32 chain_mapping = 0;
+	int err;
 
 	slow_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
 	if (!slow_attr)
@@ -1406,13 +1411,56 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 	slow_attr->esw_attr->split_count = 0;
 	slow_attr->flags |= MLX5_ATTR_FLAG_SLOW_PATH;
 
+	fwd_and_modify_cap = MLX5_CAP_ESW_FLOWTABLE((esw)->dev, fdb_modify_header_fwd_to_table);
+	if (!fwd_and_modify_cap)
+		goto skip_restore;
+
+	err = mlx5_chains_get_chain_mapping(esw_chains(esw), flow->attr->chain, &chain_mapping);
+	if (err)
+		goto err_get_chain;
+
+	err = mlx5e_tc_match_to_reg_set(esw->dev, &mod_acts, MLX5_FLOW_NAMESPACE_FDB,
+					CHAIN_TO_REG, chain_mapping);
+	if (err)
+		goto err_reg_set;
+
+	mh = mlx5e_mod_hdr_attach(esw->dev, get_mod_hdr_table(flow->priv, flow),
+				  MLX5_FLOW_NAMESPACE_FDB, &mod_acts);
+	if (IS_ERR(mh)) {
+		err = PTR_ERR(mh);
+		goto err_attach;
+	}
+
+	slow_attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	slow_attr->modify_hdr = mlx5e_mod_hdr_get(mh);
+
+skip_restore:
 	rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, slow_attr);
-	if (!IS_ERR(rule))
-		flow_flag_set(flow, SLOW);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		goto err_offload;
+	}
 
+	flow->slow_mh = mh;
+	flow->chain_mapping = chain_mapping;
+	flow_flag_set(flow, SLOW);
+
+	mlx5e_mod_hdr_dealloc(&mod_acts);
 	kfree(slow_attr);
 
 	return rule;
+
+err_offload:
+	if (fwd_and_modify_cap)
+		mlx5e_mod_hdr_detach(esw->dev, get_mod_hdr_table(flow->priv, flow), mh);
+err_attach:
+err_reg_set:
+	if (fwd_and_modify_cap)
+		mlx5_chains_put_chain_mapping(esw_chains(esw), chain_mapping);
+err_get_chain:
+	mlx5e_mod_hdr_dealloc(&mod_acts);
+	kfree(slow_attr);
+	return ERR_PTR(err);
 }
 
 void mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
@@ -1430,7 +1478,17 @@ void mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
 	slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	slow_attr->esw_attr->split_count = 0;
 	slow_attr->flags |= MLX5_ATTR_FLAG_SLOW_PATH;
+	if (flow->slow_mh) {
+		slow_attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+		slow_attr->modify_hdr = mlx5e_mod_hdr_get(flow->slow_mh);
+	}
 	mlx5e_tc_unoffload_fdb_rules(esw, flow, slow_attr);
+	if (flow->slow_mh) {
+		mlx5e_mod_hdr_detach(esw->dev, get_mod_hdr_table(flow->priv, flow), flow->slow_mh);
+		mlx5_chains_put_chain_mapping(esw_chains(esw), flow->chain_mapping);
+		flow->chain_mapping = 0;
+		flow->slow_mh = NULL;
+	}
 	flow_flag_clear(flow, SLOW);
 	kfree(slow_attr);
 }
-- 
2.35.1



