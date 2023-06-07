Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2131E3925B
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934D0C433EF;
	Wed,  7 Jun 2023 20:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169415;
	bh=NCN4/3K29y/IzQFYBtrAOZTLbrVfPUDZUKOu4RcdFss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzL5bO2fBb/ZTlPCNVb/H97eHOLEGmOvLDVPbq6fsQzqBhFthWL5SkhEMwkcXpi8q
	 OtRZOJKIUYpfqFXHW1FLup2dlBjmEd22ztcBxFYTgbepOCJWroLOskwHhxJCc73FuD
	 TLfsu0MlSjhUwWcV2gDMRFSB5d+SMagGiuMhBHuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Blakey <paulb@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 031/286] net/mlx5e: TC, Remove CT action reordering
Date: Wed,  7 Jun 2023 22:12:10 +0200
Message-ID: <20230607200924.044727295@linuxfoundation.org>
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

[ Upstream commit 67efaf45930df662111acf7c706d545c83f83999 ]

CT action reordering was done as a workaround when CT misses
used to restore the relevant filter's tc chain and continuing sw processing
from that chain. As such, there was a need to reorder CT action to be before
any packet modifying actions (e.g mac rewrite).

Currently (after patch "net/mlx5e: TC, Set CT miss to the specific ct
action instance"), CT misses continues from the relevant ct action in
software, and so reordering isn't needed anymore.

Remove the reordering.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 5d862ec631f3 ("net/mlx5: Fix post parse infra to only parse every action once")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en/tc/act/act.c        | 20 ------------
 .../mellanox/mlx5/core/en/tc/act/act.h        |  4 ---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 32 ++++++-------------
 3 files changed, 9 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index eba0c86989263..fc923a99b6a48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -82,26 +82,6 @@ mlx5e_tc_act_init_parse_state(struct mlx5e_tc_act_parse_state *parse_state,
 	parse_state->flow_action = flow_action;
 }
 
-void
-mlx5e_tc_act_reorder_flow_actions(struct flow_action *flow_action,
-				  struct mlx5e_tc_flow_action *flow_action_reorder)
-{
-	struct flow_action_entry *act;
-	int i, j = 0;
-
-	flow_action_for_each(i, act, flow_action) {
-		/* Add CT action to be first. */
-		if (act->id == FLOW_ACTION_CT)
-			flow_action_reorder->entries[j++] = act;
-	}
-
-	flow_action_for_each(i, act, flow_action) {
-		if (act->id == FLOW_ACTION_CT)
-			continue;
-		flow_action_reorder->entries[j++] = act;
-	}
-}
-
 int
 mlx5e_tc_act_post_parse(struct mlx5e_tc_act_parse_state *parse_state,
 			struct flow_action *flow_action,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index cdcddf6e1b08b..d7615e329e6d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -112,10 +112,6 @@ mlx5e_tc_act_init_parse_state(struct mlx5e_tc_act_parse_state *parse_state,
 			      struct flow_action *flow_action,
 			      struct netlink_ext_ack *extack);
 
-void
-mlx5e_tc_act_reorder_flow_actions(struct flow_action *flow_action,
-				  struct mlx5e_tc_flow_action *flow_action_reorder);
-
 int
 mlx5e_tc_act_post_parse(struct mlx5e_tc_act_parse_state *parse_state,
 			struct flow_action *flow_action,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 82b76dcc05ac1..a78e201fd883b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3967,32 +3967,22 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		 struct flow_action *flow_action)
 {
 	struct netlink_ext_ack *extack = parse_state->extack;
-	struct mlx5e_tc_flow_action flow_action_reorder;
 	struct mlx5e_tc_flow *flow = parse_state->flow;
 	struct mlx5e_tc_jump_state jump_state = {};
 	struct mlx5_flow_attr *attr = flow->attr;
 	enum mlx5_flow_namespace_type ns_type;
 	struct mlx5e_priv *priv = flow->priv;
-	struct flow_action_entry *act, **_act;
 	struct mlx5_flow_attr *prev_attr;
+	struct flow_action_entry *act;
 	struct mlx5e_tc_act *tc_act;
 	bool is_missable;
 	int err, i;
 
-	flow_action_reorder.num_entries = flow_action->num_entries;
-	flow_action_reorder.entries = kcalloc(flow_action->num_entries,
-					      sizeof(flow_action), GFP_KERNEL);
-	if (!flow_action_reorder.entries)
-		return -ENOMEM;
-
-	mlx5e_tc_act_reorder_flow_actions(flow_action, &flow_action_reorder);
-
 	ns_type = mlx5e_get_flow_namespace(flow);
 	list_add(&attr->list, &flow->attrs);
 
-	flow_action_for_each(i, _act, &flow_action_reorder) {
+	flow_action_for_each(i, act, flow_action) {
 		jump_state.jump_target = false;
-		act = *_act;
 		is_missable = false;
 		prev_attr = attr;
 
@@ -4000,23 +3990,23 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		if (!tc_act) {
 			NL_SET_ERR_MSG_MOD(extack, "Not implemented offload action");
 			err = -EOPNOTSUPP;
-			goto out_free;
+			goto out_free_post_acts;
 		}
 
 		if (!tc_act->can_offload(parse_state, act, i, attr)) {
 			err = -EOPNOTSUPP;
-			goto out_free;
+			goto out_free_post_acts;
 		}
 
 		err = tc_act->parse_action(parse_state, act, priv, attr);
 		if (err)
-			goto out_free;
+			goto out_free_post_acts;
 
 		dec_jump_count(act, tc_act, attr, priv, &jump_state);
 
 		err = parse_branch_ctrl(act, tc_act, flow, attr, &jump_state, extack);
 		if (err)
-			goto out_free;
+			goto out_free_post_acts;
 
 		parse_state->actions |= attr->action;
 
@@ -4024,17 +4014,17 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		if (jump_state.jump_target ||
 		    (tc_act->is_multi_table_act &&
 		    tc_act->is_multi_table_act(priv, act, attr) &&
-		    i < flow_action_reorder.num_entries - 1)) {
+		    i < flow_action->num_entries - 1)) {
 			is_missable = tc_act->is_missable ? tc_act->is_missable(act) : false;
 
 			err = mlx5e_tc_act_post_parse(parse_state, flow_action, attr, ns_type);
 			if (err)
-				goto out_free;
+				goto out_free_post_acts;
 
 			attr = mlx5e_clone_flow_attr_for_post_act(flow->attr, ns_type);
 			if (!attr) {
 				err = -ENOMEM;
-				goto out_free;
+				goto out_free_post_acts;
 			}
 
 			list_add(&attr->list, &flow->attrs);
@@ -4051,8 +4041,6 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		}
 	}
 
-	kfree(flow_action_reorder.entries);
-
 	err = mlx5e_tc_act_post_parse(parse_state, flow_action, attr, ns_type);
 	if (err)
 		goto out_free_post_acts;
@@ -4063,8 +4051,6 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 
 	return 0;
 
-out_free:
-	kfree(flow_action_reorder.entries);
 out_free_post_acts:
 	free_flow_post_acts(flow);
 
-- 
2.39.2



