Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2388364C1;
	Fri, 24 Nov 2023 19:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vg7b/3Ig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFEEC433C7;
	Fri, 24 Nov 2023 19:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853350;
	bh=fyAmZFgGwYz0PlpJQgkL24GywT1VcDutfTlRyd1x+Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vg7b/3Ig9SY/JhkNkusIZBp94ZfDf2DOsFnu/Nvbojo8IoP6i1adFdfr4+mraoyiO
	 WlXdzxiqqsTgTXyn46PTrWF5ZYd84lwhgkTwaRPCnOqEM9X/oTkaSVYjt6W3Hn/puY
	 RvtZHs7Va01FzS6ASW7cW2JE1avwqWgmw7M+lIGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>,
	Oz Shlomo <ozsh@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/297] net/mlx5e: Move mod hdr allocation to a single place
Date: Fri, 24 Nov 2023 17:52:51 +0000
Message-ID: <20231124172004.815008793@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit d9581e2fa73fadba187b2e62e05306e24e8a1ded ]

Move mod hdr allocation chunk from parse_tc_fdb_actions() and
parse_tc_nic_actions() to a shared function.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 0c101a23ca7e ("net/mlx5e: Fix pedit endianness")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 87 +++++++++++--------
 1 file changed, 51 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d13ffba138934..433602f871bd4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3502,10 +3502,50 @@ static int validate_goto_chain(struct mlx5e_priv *priv,
 	return 0;
 }
 
-static int parse_tc_nic_actions(struct mlx5e_priv *priv,
-				struct flow_action *flow_action,
+static int
+actions_prepare_mod_hdr_actions(struct mlx5e_priv *priv,
 				struct mlx5e_tc_flow *flow,
+				struct mlx5_flow_attr *attr,
+				struct pedit_headers_action *hdrs,
 				struct netlink_ext_ack *extack)
+{
+	struct mlx5e_tc_flow_parse_attr *parse_attr = attr->parse_attr;
+	enum mlx5_flow_namespace_type ns_type;
+	int err;
+
+	if (!hdrs[TCA_PEDIT_KEY_EX_CMD_SET].pedits &&
+	    !hdrs[TCA_PEDIT_KEY_EX_CMD_ADD].pedits)
+		return 0;
+
+	ns_type = get_flow_name_space(flow);
+
+	err = alloc_tc_pedit_action(priv, ns_type, parse_attr, hdrs,
+				    &attr->action, extack);
+	if (err)
+		return err;
+
+	/* In case all pedit actions are skipped, remove the MOD_HDR flag. */
+	if (parse_attr->mod_hdr_acts.num_actions > 0)
+		return 0;
+
+	attr->action &= ~MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
+
+	if (ns_type != MLX5_FLOW_NAMESPACE_FDB)
+		return 0;
+
+	if (!((attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) ||
+	      (attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH)))
+		attr->esw_attr->split_count = 0;
+
+	return 0;
+}
+
+static int
+parse_tc_nic_actions(struct mlx5e_priv *priv,
+		     struct flow_action *flow_action,
+		     struct mlx5e_tc_flow *flow,
+		     struct netlink_ext_ack *extack)
 {
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
@@ -3617,21 +3657,6 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 		}
 	}
 
-	if (hdrs[TCA_PEDIT_KEY_EX_CMD_SET].pedits ||
-	    hdrs[TCA_PEDIT_KEY_EX_CMD_ADD].pedits) {
-		err = alloc_tc_pedit_action(priv, MLX5_FLOW_NAMESPACE_KERNEL,
-					    parse_attr, hdrs, &action, extack);
-		if (err)
-			return err;
-		/* in case all pedit actions are skipped, remove the MOD_HDR
-		 * flag.
-		 */
-		if (parse_attr->mod_hdr_acts.num_actions == 0) {
-			action &= ~MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-			dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
-		}
-	}
-
 	attr->action = action;
 
 	if (attr->dest_chain && parse_attr->mirred_ifindex[0]) {
@@ -3639,6 +3664,10 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
+	err = actions_prepare_mod_hdr_actions(priv, flow, attr, hdrs, extack);
+	if (err)
+		return err;
+
 	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
 		return -EOPNOTSUPP;
 
@@ -4192,26 +4221,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			return err;
 	}
 
-	if (hdrs[TCA_PEDIT_KEY_EX_CMD_SET].pedits ||
-	    hdrs[TCA_PEDIT_KEY_EX_CMD_ADD].pedits) {
-		err = alloc_tc_pedit_action(priv, MLX5_FLOW_NAMESPACE_FDB,
-					    parse_attr, hdrs, &action, extack);
-		if (err)
-			return err;
-		/* in case all pedit actions are skipped, remove the MOD_HDR
-		 * flag. we might have set split_count either by pedit or
-		 * pop/push. if there is no pop/push either, reset it too.
-		 */
-		if (parse_attr->mod_hdr_acts.num_actions == 0) {
-			action &= ~MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-			dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
-			if (!((action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) ||
-			      (action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH)))
-				esw_attr->split_count = 0;
-		}
-	}
-
 	attr->action = action;
+
+	err = actions_prepare_mod_hdr_actions(priv, flow, attr, hdrs, extack);
+	if (err)
+		return err;
+
 	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
 		return -EOPNOTSUPP;
 
-- 
2.42.0



