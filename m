Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F25823506A;
	Tue, 30 Sep 2025 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244673; cv=none; b=ew3x7w7nDVc/rMEy2lqaBdfARso5piRs9Z3Bw7EmuZaRzrtCtMUz7hMBp5GlUwJ/Mh8B8H3r68wuM3F3UCpyGm73S+68OVJ2cs+zwdvrjcBe31b6kHmKpOhBBQ+Nq7AfRBQBBCCviXSLpcF0KYpTZec62TvjYl3/OfP1ZZdR0Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244673; c=relaxed/simple;
	bh=w818rA3od17EZ0/LicuxX9j/O5AXwnPyaCJd9c9CsHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIPU9w9By3mHiopurpERSt6vhzUhoQNXph5W6jFk2stcXVgUp/wMg/SKkEpqD3xN0a+q1Y+d6/EDfr2PDAecCvCIUt2koIKAYmHxnEi2kzaeqI4AHW+8zd+kNVVYFtsomROwUFKfWLnd2fMdBXm6jU70gNolLIlEZ6RWDY8KUTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsmLkA+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsmLkA+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C3BC4CEF0;
	Tue, 30 Sep 2025 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244673;
	bh=w818rA3od17EZ0/LicuxX9j/O5AXwnPyaCJd9c9CsHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsmLkA+1UXePFNBCvz8P0+6slYT49/96rX8VVSd/7SBINmzrzOIeFWxTnCjFqGMLO
	 zVWTqL7c5sxLrPwHjSPQTFdtqFruNDL1iUFbung5vMC2J60FYl9En8QImMezWx8FvG
	 W81Ovt8MRZVSpKrH+Z9ie8FZZOhzh6dA0EOnMbo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 079/143] net/mlx5: fs, fix UAF in flow counter release
Date: Tue, 30 Sep 2025 16:46:43 +0200
Message-ID: <20250930143834.386694130@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 6043819e707cefb1c9e59d6e431dcfa735c4f975 ]

Fix a kernel trace [1] caused by releasing an HWS action of a local flow
counter in mlx5_cmd_hws_delete_fte(), where the HWS action refcount and
mutex were not initialized and the counter struct could already be freed
when deleting the rule.

Fix it by adding the missing initializations and adding refcount for the
local flow counter struct.

[1] Kernel log:
 Call Trace:
  <TASK>
  dump_stack_lvl+0x34/0x48
  mlx5_fs_put_hws_action.part.0.cold+0x21/0x94 [mlx5_core]
  mlx5_fc_put_hws_action+0x96/0xad [mlx5_core]
  mlx5_fs_destroy_fs_actions+0x8b/0x152 [mlx5_core]
  mlx5_cmd_hws_delete_fte+0x5a/0xa0 [mlx5_core]
  del_hw_fte+0x1ce/0x260 [mlx5_core]
  mlx5_del_flow_rules+0x12d/0x240 [mlx5_core]
  ? ttwu_queue_wakelist+0xf4/0x110
  mlx5_ib_destroy_flow+0x103/0x1b0 [mlx5_ib]
  uverbs_free_flow+0x20/0x50 [ib_uverbs]
  destroy_hw_idr_uobject+0x1b/0x50 [ib_uverbs]
  uverbs_destroy_uobject+0x34/0x1a0 [ib_uverbs]
  uobj_destroy+0x3c/0x80 [ib_uverbs]
  ib_uverbs_run_method+0x23e/0x360 [ib_uverbs]
  ? uverbs_finalize_object+0x60/0x60 [ib_uverbs]
  ib_uverbs_cmd_verbs+0x14f/0x2c0 [ib_uverbs]
  ? do_tty_write+0x1a9/0x270
  ? file_tty_write.constprop.0+0x98/0xc0
  ? new_sync_write+0xfc/0x190
  ib_uverbs_ioctl+0xd7/0x160 [ib_uverbs]
  __x64_sys_ioctl+0x87/0xc0
  do_syscall_64+0x59/0x90

Fixes: b581f4266928 ("net/mlx5: fs, manage flow counters HWS action sharing by refcount")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1758525094-816583-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  1 +
 .../ethernet/mellanox/mlx5/core/fs_counters.c | 25 ++++++++++++++++---
 .../mlx5/core/steering/hws/fs_hws_pools.c     |  8 +++++-
 include/linux/mlx5/fs.h                       |  2 ++
 5 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 3b57ef6b3de38..93fb4e861b691 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -663,7 +663,7 @@ static void del_sw_hw_rule(struct fs_node *node)
 			BIT(MLX5_SET_FTE_MODIFY_ENABLE_MASK_ACTION) |
 			BIT(MLX5_SET_FTE_MODIFY_ENABLE_MASK_FLOW_COUNTERS);
 		fte->act_dests.action.action &= ~MLX5_FLOW_CONTEXT_ACTION_COUNT;
-		mlx5_fc_local_destroy(rule->dest_attr.counter);
+		mlx5_fc_local_put(rule->dest_attr.counter);
 		goto out;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index 500826229b0be..e6a95b310b555 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -343,6 +343,7 @@ struct mlx5_fc {
 	enum mlx5_fc_type type;
 	struct mlx5_fc_bulk *bulk;
 	struct mlx5_fc_cache cache;
+	refcount_t fc_local_refcount;
 	/* last{packets,bytes} are used for calculating deltas since last reading. */
 	u64 lastpackets;
 	u64 lastbytes;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index 492775d3d193a..83001eda38842 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -562,17 +562,36 @@ mlx5_fc_local_create(u32 counter_id, u32 offset, u32 bulk_size)
 	counter->id = counter_id;
 	fc_bulk->base_id = counter_id - offset;
 	fc_bulk->fs_bulk.bulk_len = bulk_size;
+	refcount_set(&fc_bulk->hws_data.hws_action_refcount, 0);
+	mutex_init(&fc_bulk->hws_data.lock);
 	counter->bulk = fc_bulk;
+	refcount_set(&counter->fc_local_refcount, 1);
 	return counter;
 }
 EXPORT_SYMBOL(mlx5_fc_local_create);
 
 void mlx5_fc_local_destroy(struct mlx5_fc *counter)
 {
-	if (!counter || counter->type != MLX5_FC_TYPE_LOCAL)
-		return;
-
 	kfree(counter->bulk);
 	kfree(counter);
 }
 EXPORT_SYMBOL(mlx5_fc_local_destroy);
+
+void mlx5_fc_local_get(struct mlx5_fc *counter)
+{
+	if (!counter || counter->type != MLX5_FC_TYPE_LOCAL)
+		return;
+
+	refcount_inc(&counter->fc_local_refcount);
+}
+
+void mlx5_fc_local_put(struct mlx5_fc *counter)
+{
+	if (!counter || counter->type != MLX5_FC_TYPE_LOCAL)
+		return;
+
+	if (!refcount_dec_and_test(&counter->fc_local_refcount))
+		return;
+
+	mlx5_fc_local_destroy(counter);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
index f1ecdba74e1f4..839d71bd42164 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
@@ -407,15 +407,21 @@ struct mlx5hws_action *mlx5_fc_get_hws_action(struct mlx5hws_context *ctx,
 {
 	struct mlx5_fs_hws_create_action_ctx create_ctx;
 	struct mlx5_fc_bulk *fc_bulk = counter->bulk;
+	struct mlx5hws_action *hws_action;
 
 	create_ctx.hws_ctx = ctx;
 	create_ctx.id = fc_bulk->base_id;
 	create_ctx.actions_type = MLX5HWS_ACTION_TYP_CTR;
 
-	return mlx5_fs_get_hws_action(&fc_bulk->hws_data, &create_ctx);
+	mlx5_fc_local_get(counter);
+	hws_action = mlx5_fs_get_hws_action(&fc_bulk->hws_data, &create_ctx);
+	if (!hws_action)
+		mlx5_fc_local_put(counter);
+	return hws_action;
 }
 
 void mlx5_fc_put_hws_action(struct mlx5_fc *counter)
 {
 	mlx5_fs_put_hws_action(&counter->bulk->hws_data);
+	mlx5_fc_local_put(counter);
 }
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 939e58c2f3865..fb5f98fcc7269 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -308,6 +308,8 @@ struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging);
 void mlx5_fc_destroy(struct mlx5_core_dev *dev, struct mlx5_fc *counter);
 struct mlx5_fc *mlx5_fc_local_create(u32 counter_id, u32 offset, u32 bulk_size);
 void mlx5_fc_local_destroy(struct mlx5_fc *counter);
+void mlx5_fc_local_get(struct mlx5_fc *counter);
+void mlx5_fc_local_put(struct mlx5_fc *counter);
 u64 mlx5_fc_query_lastuse(struct mlx5_fc *counter);
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
 			  u64 *bytes, u64 *packets, u64 *lastuse);
-- 
2.51.0



