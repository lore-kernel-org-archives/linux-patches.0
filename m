Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C639715AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4132DC433C8;
	Wed,  9 Aug 2023 10:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578043;
	bh=dzY6MWIEeXv5l+Lxr4XJLHcKkbGR4STVN8SDeygBfaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YeGjg0iOfmjvBTsVRqSHMmu/oFH3c5tsMjfT/EvrplcF2Th49nlvOf2oKR6Fd5p39
	 EeMs7EJaVh7L2Tg2ryMZM9ZFGO7yVIGKpenVgYjSaoLyD6yhkmTgMMjZ3Kp5k2O7yS
	 HHvlZi18flNrONcvH4wbk0YSJaNX3eF9Knga0P94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 085/165] net/mlx5: fs_core: Make find_closest_ft more generic
Date: Wed,  9 Aug 2023 12:40:16 +0200
Message-ID: <20230809103645.583385385@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 618d28a535a0582617465d14e05f3881736a2962 ]

As find_closest_ft_recursive is called to find the closest FT, the
first parameter of find_closest_ft can be changed from fs_prio to
fs_node. Thus this function is extended to find the closest FT for the
nodes of any type, not only prios, but also the sub namespaces.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/d3962c2b443ec8dde7a740dc742a1f052d5e256c.1690803944.git.leonro@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c635ca45a7a2 ("net/mlx5: fs_core: Skip the FTs in the same FS_TYPE_PRIO_CHAINS fs_prio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 29 +++++++++----------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 19da02c416161..852e265541d19 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -905,18 +905,17 @@ static struct mlx5_flow_table *find_closest_ft_recursive(struct fs_node  *root,
 	return ft;
 }
 
-/* If reverse is false then return the first flow table in next priority of
- * prio in the tree, else return the last flow table in the previous priority
- * of prio in the tree.
+/* If reverse is false then return the first flow table next to the passed node
+ * in the tree, else return the last flow table before the node in the tree.
  */
-static struct mlx5_flow_table *find_closest_ft(struct fs_prio *prio, bool reverse)
+static struct mlx5_flow_table *find_closest_ft(struct fs_node *node, bool reverse)
 {
 	struct mlx5_flow_table *ft = NULL;
 	struct fs_node *curr_node;
 	struct fs_node *parent;
 
-	parent = prio->node.parent;
-	curr_node = &prio->node;
+	parent = node->parent;
+	curr_node = node;
 	while (!ft && parent) {
 		ft = find_closest_ft_recursive(parent, &curr_node->list, reverse);
 		curr_node = parent;
@@ -926,15 +925,15 @@ static struct mlx5_flow_table *find_closest_ft(struct fs_prio *prio, bool revers
 }
 
 /* Assuming all the tree is locked by mutex chain lock */
-static struct mlx5_flow_table *find_next_chained_ft(struct fs_prio *prio)
+static struct mlx5_flow_table *find_next_chained_ft(struct fs_node *node)
 {
-	return find_closest_ft(prio, false);
+	return find_closest_ft(node, false);
 }
 
 /* Assuming all the tree is locked by mutex chain lock */
-static struct mlx5_flow_table *find_prev_chained_ft(struct fs_prio *prio)
+static struct mlx5_flow_table *find_prev_chained_ft(struct fs_node *node)
 {
-	return find_closest_ft(prio, true);
+	return find_closest_ft(node, true);
 }
 
 static struct mlx5_flow_table *find_next_fwd_ft(struct mlx5_flow_table *ft,
@@ -946,7 +945,7 @@ static struct mlx5_flow_table *find_next_fwd_ft(struct mlx5_flow_table *ft,
 	next_ns = flow_act->action & MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_NS;
 	fs_get_obj(prio, next_ns ? ft->ns->node.parent : ft->node.parent);
 
-	return find_next_chained_ft(prio);
+	return find_next_chained_ft(&prio->node);
 }
 
 static int connect_fts_in_prio(struct mlx5_core_dev *dev,
@@ -977,7 +976,7 @@ static int connect_prev_fts(struct mlx5_core_dev *dev,
 {
 	struct mlx5_flow_table *prev_ft;
 
-	prev_ft = find_prev_chained_ft(prio);
+	prev_ft = find_prev_chained_ft(&prio->node);
 	if (prev_ft) {
 		struct fs_prio *prev_prio;
 
@@ -1123,7 +1122,7 @@ static int connect_flow_table(struct mlx5_core_dev *dev, struct mlx5_flow_table
 		if (err)
 			return err;
 
-		next_ft = first_ft ? first_ft : find_next_chained_ft(prio);
+		next_ft = first_ft ? first_ft : find_next_chained_ft(&prio->node);
 		err = connect_fwd_rules(dev, ft, next_ft);
 		if (err)
 			return err;
@@ -1198,7 +1197,7 @@ static struct mlx5_flow_table *__mlx5_create_flow_table(struct mlx5_flow_namespa
 
 	tree_init_node(&ft->node, del_hw_flow_table, del_sw_flow_table);
 	next_ft = unmanaged ? ft_attr->next_ft :
-			      find_next_chained_ft(fs_prio);
+			      find_next_chained_ft(&fs_prio->node);
 	ft->def_miss_action = ns->def_miss_action;
 	ft->ns = ns;
 	err = root->cmds->create_flow_table(root, ft, ft_attr, next_ft);
@@ -2201,7 +2200,7 @@ static struct mlx5_flow_table *find_next_ft(struct mlx5_flow_table *ft)
 
 	if (!list_is_last(&ft->node.list, &prio->node.children))
 		return list_next_entry(ft, node.list);
-	return find_next_chained_ft(prio);
+	return find_next_chained_ft(&prio->node);
 }
 
 static int update_root_ft_destroy(struct mlx5_flow_table *ft)
-- 
2.40.1



