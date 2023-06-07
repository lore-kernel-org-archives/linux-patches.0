Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08A33AE45
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFC9C4339C;
	Wed,  7 Jun 2023 20:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169329;
	bh=Aei50GuRfILfFOHJVJY278KmY/aBz09HMRM07P5OlNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xAsChIxOp94KjSmVbAHKNpueJzr+YugL4/mMC86cJGjPGJbiNxVshkQHcsjGWcrTL
	 JkC5nlC88vXnUuzPX//lYY1R2YN5ykykxsgzoRZVJhcK1+UoF0jWSo1djkx95c1Y9J
	 kT3Oxhz8MTCgzih83h4d2ymGAdkdyJ4OWCZ61850=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 032/286] net/mlx5: Fix post parse infra to only parse every action once
Date: Wed,  7 Jun 2023 22:12:11 +0200
Message-ID: <20230607200924.078454214@linuxfoundation.org>
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

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit 5d862ec631f3d3cc3b4f8cdb5b9fc5879663f1d3 ]

Caller of mlx5e_tc_act_post_parse() needs it to parse only the subset of
actions starting after previous split and ending at the current action.
However, that range is not provided as arguments and
mlx5e_tc_act_post_parse() uses generic flow_action_for_each() that iterates
over all flow actions. Not only this is redundant, it also causes a bug
when mlx5e_tc_act->post_parse() callback is not idempotent since it will be
called for every split. For example, ct action tc_act_post_parse_ct()
callback obtains a reference to mlx5_ct_ft instance and calling it several
times during parsing stage will cause reference counter imbalance.

Fix the issue by providing a proper action range of the current split
subset to mlx5e_tc_act_post_parse() and only calling
mlx5e_tc_act->post_parse() for actions inside the subset range.

Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c | 7 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c         | 8 +++++---
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index fc923a99b6a48..0380a04c3691c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -84,7 +84,7 @@ mlx5e_tc_act_init_parse_state(struct mlx5e_tc_act_parse_state *parse_state,
 
 int
 mlx5e_tc_act_post_parse(struct mlx5e_tc_act_parse_state *parse_state,
-			struct flow_action *flow_action,
+			struct flow_action *flow_action, int from, int to,
 			struct mlx5_flow_attr *attr,
 			enum mlx5_flow_namespace_type ns_type)
 {
@@ -96,6 +96,11 @@ mlx5e_tc_act_post_parse(struct mlx5e_tc_act_parse_state *parse_state,
 	priv = parse_state->flow->priv;
 
 	flow_action_for_each(i, act, flow_action) {
+		if (i < from)
+			continue;
+		else if (i > to)
+			break;
+
 		tc_act = mlx5e_tc_act_get(act->id, ns_type);
 		if (!tc_act || !tc_act->post_parse)
 			continue;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index d7615e329e6d9..84c78d5f5bed8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -114,7 +114,7 @@ mlx5e_tc_act_init_parse_state(struct mlx5e_tc_act_parse_state *parse_state,
 
 int
 mlx5e_tc_act_post_parse(struct mlx5e_tc_act_parse_state *parse_state,
-			struct flow_action *flow_action,
+			struct flow_action *flow_action, int from, int to,
 			struct mlx5_flow_attr *attr,
 			enum mlx5_flow_namespace_type ns_type);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a78e201fd883b..82b96196e97b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3975,8 +3975,8 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 	struct mlx5_flow_attr *prev_attr;
 	struct flow_action_entry *act;
 	struct mlx5e_tc_act *tc_act;
+	int err, i, i_split = 0;
 	bool is_missable;
-	int err, i;
 
 	ns_type = mlx5e_get_flow_namespace(flow);
 	list_add(&attr->list, &flow->attrs);
@@ -4017,7 +4017,8 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		    i < flow_action->num_entries - 1)) {
 			is_missable = tc_act->is_missable ? tc_act->is_missable(act) : false;
 
-			err = mlx5e_tc_act_post_parse(parse_state, flow_action, attr, ns_type);
+			err = mlx5e_tc_act_post_parse(parse_state, flow_action, i_split, i, attr,
+						      ns_type);
 			if (err)
 				goto out_free_post_acts;
 
@@ -4027,6 +4028,7 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 				goto out_free_post_acts;
 			}
 
+			i_split = i + 1;
 			list_add(&attr->list, &flow->attrs);
 		}
 
@@ -4041,7 +4043,7 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		}
 	}
 
-	err = mlx5e_tc_act_post_parse(parse_state, flow_action, attr, ns_type);
+	err = mlx5e_tc_act_post_parse(parse_state, flow_action, i_split, i, attr, ns_type);
 	if (err)
 		goto out_free_post_acts;
 
-- 
2.39.2



