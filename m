Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C542E168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A6BC433EF;
	Mon,  8 May 2023 10:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540474;
	bh=NKF0MQBzLvyeOxwP5PYmDqBAOaLtLG9/Xy2Q1qMmrD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQo2aheEpZcV2rNtdgdsoG13rrLOpaHvBp31S8noe0xsypcZecsyrqJnEwk4R7CwR
	 evimPZ+H0GqIPS7ItWvt4BrxhXA7QwdCodMPL/6GqwfY5Sm7uLSqUs9LZPeuUthXWm
	 LO5nQBu5Z13X1Ro0LDpsVeoU6J2rkjzGbBWJb2Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 377/611] net/mlx5e: Dont clone flow post action attributes second time
Date: Mon,  8 May 2023 11:43:39 +0200
Message-Id: <20230508094434.595330774@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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

[ Upstream commit e9fce818fe003b6c527f25517b9ac08eb4661b5d ]

The code already clones post action attributes in
mlx5e_clone_flow_attr_for_post_act(). Creating another copy in
mlx5e_tc_post_act_add() is a erroneous leftover from original
implementation. Instead, assign handle->attribute to post_attr provided by
the caller. Note that cloning the attribute second time is not just
wasteful but also causes issues like second copy not being properly updated
in neigh update code which leads to following use-after-free:

Feb 21 09:02:00 c-237-177-40-045 kernel: BUG: KASAN: use-after-free in mlx5_cmd_set_fte+0x200d/0x24c0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_report+0xbb/0x1a0
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_save_stack+0x1e/0x40
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_set_track+0x21/0x30
Feb 21 09:02:00 c-237-177-40-045 kernel:  __kasan_kmalloc+0x7a/0x90
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_save_stack+0x1e/0x40
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_set_track+0x21/0x30
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_save_free_info+0x2a/0x40
Feb 21 09:02:00 c-237-177-40-045 kernel:  ____kasan_slab_free+0x11a/0x1b0
Feb 21 09:02:00 c-237-177-40-045 kernel: page dumped because: kasan: bad access detected
Feb 21 09:02:00 c-237-177-40-045 kernel: mlx5_core 0000:08:00.0: mlx5_cmd_out_err:803:(pid 8833): SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad resource state(0x9), syndrome (0xf2ff71), err(-22)
Feb 21 09:02:00 c-237-177-40-045 kernel: mlx5_core 0000:08:00.0 enp8s0f0: Failed to add post action rule
Feb 21 09:02:00 c-237-177-40-045 kernel: mlx5_core 0000:08:00.0: mlx5e_tc_encap_flows_add:190:(pid 8833): Failed to update flow post acts, -22
Feb 21 09:02:00 c-237-177-40-045 kernel: Call Trace:
Feb 21 09:02:00 c-237-177-40-045 kernel:  <TASK>
Feb 21 09:02:00 c-237-177-40-045 kernel:  dump_stack_lvl+0x57/0x7d
Feb 21 09:02:00 c-237-177-40-045 kernel:  print_report+0x170/0x471
Feb 21 09:02:00 c-237-177-40-045 kernel:  ? mlx5_cmd_set_fte+0x200d/0x24c0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_report+0xbb/0x1a0
Feb 21 09:02:00 c-237-177-40-045 kernel:  ? mlx5_cmd_set_fte+0x200d/0x24c0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5_cmd_set_fte+0x200d/0x24c0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  ? __module_address.part.0+0x62/0x200
Feb 21 09:02:00 c-237-177-40-045 kernel:  ? mlx5_cmd_stub_create_flow_table+0xd0/0xd0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  ? __raw_spin_lock_init+0x3b/0x110
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5_cmd_create_fte+0x80/0xb0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  add_rule_fg+0xe80/0x19c0 [mlx5_core]
--
Feb 21 09:02:00 c-237-177-40-045 kernel: Allocated by task 13476:
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_save_stack+0x1e/0x40
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_set_track+0x21/0x30
Feb 21 09:02:00 c-237-177-40-045 kernel:  __kasan_kmalloc+0x7a/0x90
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5_packet_reformat_alloc+0x7b/0x230 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_tc_tun_create_header_ipv4+0x977/0xf10 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_attach_encap+0x15b4/0x1e10 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  post_process_attr+0x305/0xa30 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_tc_add_fdb_flow+0x4c0/0xcf0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  __mlx5e_add_fdb_flow+0x7cf/0xe90 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_configure_flower+0xcaa/0x4b90 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_rep_setup_tc_cls_flower+0x99/0x1b0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_rep_setup_tc_cb+0x133/0x1e0 [mlx5_core]
--
Feb 21 09:02:00 c-237-177-40-045 kernel: Freed by task 8833:
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_save_stack+0x1e/0x40
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_set_track+0x21/0x30
Feb 21 09:02:00 c-237-177-40-045 kernel:  kasan_save_free_info+0x2a/0x40
Feb 21 09:02:00 c-237-177-40-045 kernel:  ____kasan_slab_free+0x11a/0x1b0
Feb 21 09:02:00 c-237-177-40-045 kernel:  __kmem_cache_free+0x1de/0x400
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5_packet_reformat_dealloc+0xad/0x100 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_tc_encap_flows_del+0x3c0/0x500 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_rep_update_flows+0x40c/0xa80 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  mlx5e_rep_neigh_update+0x473/0x7a0 [mlx5_core]
Feb 21 09:02:00 c-237-177-40-045 kernel:  process_one_work+0x7c2/0x1310
Feb 21 09:02:00 c-237-177-40-045 kernel:  worker_thread+0x59d/0xec0
Feb 21 09:02:00 c-237-177-40-045 kernel:  kthread+0x28f/0x330

Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/post_act.c  | 11 ++---------
 .../net/ethernet/mellanox/mlx5/core/en/tc/post_act.h  |  2 +-
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
index 4e48946c4c2ac..0290e0dea5390 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
@@ -106,22 +106,17 @@ mlx5e_tc_post_act_offload(struct mlx5e_post_act *post_act,
 }
 
 struct mlx5e_post_act_handle *
-mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *attr)
+mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *post_attr)
 {
-	u32 attr_sz = ns_to_attr_sz(post_act->ns_type);
 	struct mlx5e_post_act_handle *handle;
-	struct mlx5_flow_attr *post_attr;
 	int err;
 
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-	post_attr = mlx5_alloc_flow_attr(post_act->ns_type);
-	if (!handle || !post_attr) {
-		kfree(post_attr);
+	if (!handle) {
 		kfree(handle);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	memcpy(post_attr, attr, attr_sz);
 	post_attr->chain = 0;
 	post_attr->prio = 0;
 	post_attr->ft = post_act->ft;
@@ -145,7 +140,6 @@ mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *at
 	return handle;
 
 err_xarray:
-	kfree(post_attr);
 	kfree(handle);
 	return ERR_PTR(err);
 }
@@ -164,7 +158,6 @@ mlx5e_tc_post_act_del(struct mlx5e_post_act *post_act, struct mlx5e_post_act_han
 	if (!IS_ERR_OR_NULL(handle->rule))
 		mlx5e_tc_post_act_unoffload(post_act, handle);
 	xa_erase(&post_act->ids, handle->id);
-	kfree(handle->attr);
 	kfree(handle);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h
index f476774c0b75d..40b8df184af51 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h
@@ -19,7 +19,7 @@ void
 mlx5e_tc_post_act_destroy(struct mlx5e_post_act *post_act);
 
 struct mlx5e_post_act_handle *
-mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *attr);
+mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *post_attr);
 
 void
 mlx5e_tc_post_act_del(struct mlx5e_post_act *post_act, struct mlx5e_post_act_handle *handle);
-- 
2.39.2



