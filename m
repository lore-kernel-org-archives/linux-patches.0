Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA41115AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB6EC433C8;
	Wed,  9 Aug 2023 10:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577995;
	bh=eJys+2DDDlUXhk9SQvZ3XN+hty59pz39PJS77QGSCQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G66mplre39uwkE7vWVDiNN92HZrwNGenzRbgwtPRsAKEPz3fXNb3fOqAQR2JhCclN
	 Z8oBW0D4giO7TksWBX6rCwVL1LDh4JF4iok8AM422AJFjErMCO+AA0yH0hvR1wGp82
	 UW0RPLD6nLDIuJYu8bg02vSXsN2esot5O+dqRAfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Paul Blakey <paulb@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 039/165] net/mlx5: fs_chains: Fix ft prio if ignore_flow_level is not supported
Date: Wed,  9 Aug 2023 12:39:30 +0200
Message-ID: <20230809103644.091947191@linuxfoundation.org>
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

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 61eab651f6e96791cfad6db45f1107c398699b2d ]

The cited commit sets ft prio to fs_base_prio. But if
ignore_flow_level it not supported, ft prio must be set based on
tc filter prio. Otherwise, all the ft prio are the same on the same
chain. It is invalid if ignore_flow_level is not supported.

Fix it by setting ft prio based on tc filter prio and setting
fs_base_prio to 0 for fdb.

Fixes: 8e80e5648092 ("net/mlx5: fs_chains: Refactor to detach chains from tc usage")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c    | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 178880ba7c7b3..c1f419b36289c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1376,7 +1376,6 @@ esw_chains_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *miss_fdb)
 
 	esw_init_chains_offload_flags(esw, &attr.flags);
 	attr.ns = MLX5_FLOW_NAMESPACE_FDB;
-	attr.fs_base_prio = FDB_TC_OFFLOAD;
 	attr.max_grp_num = esw->params.large_group_num;
 	attr.default_ft = miss_fdb;
 	attr.mapping = esw->offloads.reg_c0_obj_pool;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index db9df9798ffac..a80ecb672f33d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -178,7 +178,7 @@ mlx5_chains_create_table(struct mlx5_fs_chains *chains,
 	if (!mlx5_chains_ignore_flow_level_supported(chains) ||
 	    (chain == 0 && prio == 1 && level == 0)) {
 		ft_attr.level = chains->fs_base_level;
-		ft_attr.prio = chains->fs_base_prio;
+		ft_attr.prio = chains->fs_base_prio + prio - 1;
 		ns = (chains->ns == MLX5_FLOW_NAMESPACE_FDB) ?
 			mlx5_get_fdb_sub_ns(chains->dev, chain) :
 			mlx5_get_flow_namespace(chains->dev, chains->ns);
-- 
2.40.1



