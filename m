Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851B33925A
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0117DC433EF;
	Wed,  7 Jun 2023 20:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169279;
	bh=uuveVWXEdaEMPk8Y3r7gl0E0eal9T0amcy6EQ+gvONQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XO93YwXFhue7Wu+qWNh2ztwjLD54MlpGwy0PRisEYoeQQ/ggcy6D48Ab89XtiFhL6
	 WfYG2oWcYsA/phGWdmoDcDRbE0YosN6PARHrlsP6nj+5x1DEaEWBQMxshW6ZxjPqyL
	 2wDiuAWRVKPDpVgB/HKUjKSDTTZOWQs8hFNbfAZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Blakey <paulb@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 020/286] net/mlx5e: TC, Remove unused vf_tun variable
Date: Wed,  7 Jun 2023 22:11:59 +0200
Message-ID: <20230607200923.669792023@linuxfoundation.org>
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

[ Upstream commit 7195d9a0c8df0ab78c9d7a587809d16b00432426 ]

vf_tun is being assigned but never being used so remove it.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 37c3b9fa7ccf ("net/mlx5e: Prevent encap offload when neigh update is running")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 53acd9a8a4c35..d9e651d33f8b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1792,8 +1792,7 @@ set_encap_dests(struct mlx5e_priv *priv,
 static void
 clean_encap_dests(struct mlx5e_priv *priv,
 		  struct mlx5e_tc_flow *flow,
-		  struct mlx5_flow_attr *attr,
-		  bool *vf_tun)
+		  struct mlx5_flow_attr *attr)
 {
 	struct mlx5_esw_flow_attr *esw_attr;
 	int out_index;
@@ -1802,17 +1801,11 @@ clean_encap_dests(struct mlx5e_priv *priv,
 		return;
 
 	esw_attr = attr->esw_attr;
-	*vf_tun = false;
 
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
 		if (!(esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP))
 			continue;
 
-		if (esw_attr->dests[out_index].flags &
-		    MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE &&
-		    !esw_attr->dest_int_port)
-			*vf_tun = true;
-
 		mlx5e_detach_encap(priv, flow, attr, out_index);
 		kfree(attr->parse_attr->tun_info[out_index]);
 	}
@@ -2046,7 +2039,6 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_esw_flow_attr *esw_attr;
-	bool vf_tun;
 
 	esw_attr = attr->esw_attr;
 	mlx5e_put_flow_tunnel_id(flow);
@@ -2068,7 +2060,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (flow->decap_route)
 		mlx5e_detach_decap_route(priv, flow);
 
-	clean_encap_dests(priv, flow, attr, &vf_tun);
+	clean_encap_dests(priv, flow, attr);
 
 	mlx5_tc_ct_match_del(get_ct_priv(priv), &flow->attr->ct_attr);
 
@@ -4452,7 +4444,6 @@ static void
 mlx5_free_flow_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr)
 {
 	struct mlx5_core_dev *counter_dev = get_flow_counter_dev(flow);
-	bool vf_tun;
 
 	if (!attr)
 		return;
@@ -4460,7 +4451,7 @@ mlx5_free_flow_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr)
 	if (attr->post_act_handle)
 		mlx5e_tc_post_act_del(get_post_action(flow->priv), attr->post_act_handle);
 
-	clean_encap_dests(flow->priv, flow, attr, &vf_tun);
+	clean_encap_dests(flow->priv, flow, attr);
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
 		mlx5_fc_destroy(counter_dev, attr->counter);
-- 
2.39.2



