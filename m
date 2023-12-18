Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4C53A1AC;
	Mon, 18 Dec 2023 13:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vf/fTf6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75894C433CA;
	Mon, 18 Dec 2023 13:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907996;
	bh=Ki5aaABXz7nyoA95nmejE5AIGCP2PGD7QjMc9f0RhLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vf/fTf6F2pdKX0kVzgggQ7pa5Wq/gU10D8cFsldZOXdlS4cSkz7+bFVvyq1gUkjKv
	 VloTcloN1PQfd932uQ/RlH/+EaCMut226byOODuK4O205Tto/E2p99eVfoqmb/WfqI
	 yaJ28XgcIOzFdTgXiPAvJ5s3dTdHd87OhBlbyADo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Automatic Verification <verifier@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Shachar Kagan <skagan@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/166] net/mlx5e: TC, Dont offload post action rule if not supported
Date: Mon, 18 Dec 2023 14:49:42 +0100
Message-ID: <20231218135105.670178789@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit ccbe33003b109f14c4dde2a4fca9c2a50c423601 ]

If post action is not supported, eg. ignore_flow_level is not
supported, don't offload post action rule. Otherwise, will hit
panic [1].

Fix it by checking if post action table is valid or not.

[1]
[445537.863880] BUG: unable to handle page fault for address: ffffffffffffffb1
[445537.864617] #PF: supervisor read access in kernel mode
[445537.865244] #PF: error_code(0x0000) - not-present page
[445537.865860] PGD 70683a067 P4D 70683a067 PUD 70683c067 PMD 0
[445537.866497] Oops: 0000 [#1] PREEMPT SMP NOPTI
[445537.867077] CPU: 19 PID: 248742 Comm: tc Kdump: loaded Tainted: G           O       6.5.0+ #1
[445537.867888] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[445537.868834] RIP: 0010:mlx5e_tc_post_act_add+0x51/0x130 [mlx5_core]
[445537.869635] Code: c0 0d 00 00 e8 20 96 c6 d3 48 85 c0 0f 84 e5 00 00 00 c7 83 b0 01 00 00 00 00 00 00 49 89 c5 31 c0 31 d2 66 89 83 b4 01 00 00 <49> 8b 44 24 10 83 23 df 83 8b d8 01 00 00 04 48 89 83 c0 01 00 00
[445537.871318] RSP: 0018:ffffb98741cef428 EFLAGS: 00010246
[445537.871962] RAX: 0000000000000000 RBX: ffff8df341167000 RCX: 0000000000000001
[445537.872704] RDX: 0000000000000000 RSI: ffffffff954844e1 RDI: ffffffff9546e9cb
[445537.873430] RBP: ffffb98741cef448 R08: 0000000000000020 R09: 0000000000000246
[445537.874160] R10: 0000000000000000 R11: ffffffff943f73ff R12: ffffffffffffffa1
[445537.874893] R13: ffff8df36d336c20 R14: ffffffffffffffa1 R15: ffff8df341167000
[445537.875628] FS:  00007fcd6564f800(0000) GS:ffff8dfa9ea00000(0000) knlGS:0000000000000000
[445537.876425] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[445537.877090] CR2: ffffffffffffffb1 CR3: 00000003b5884001 CR4: 0000000000770ee0
[445537.877832] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[445537.878564] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[445537.879300] PKRU: 55555554
[445537.879797] Call Trace:
[445537.880263]  <TASK>
[445537.880713]  ? show_regs+0x6e/0x80
[445537.881232]  ? __die+0x29/0x70
[445537.881731]  ? page_fault_oops+0x85/0x160
[445537.882276]  ? search_exception_tables+0x65/0x70
[445537.882852]  ? kernelmode_fixup_or_oops+0xa2/0x120
[445537.883432]  ? __bad_area_nosemaphore+0x18b/0x250
[445537.884019]  ? bad_area_nosemaphore+0x16/0x20
[445537.884566]  ? do_kern_addr_fault+0x8b/0xa0
[445537.885105]  ? exc_page_fault+0xf5/0x1c0
[445537.885623]  ? asm_exc_page_fault+0x2b/0x30
[445537.886149]  ? __kmem_cache_alloc_node+0x1df/0x2a0
[445537.886717]  ? mlx5e_tc_post_act_add+0x51/0x130 [mlx5_core]
[445537.887431]  ? mlx5e_tc_post_act_add+0x30/0x130 [mlx5_core]
[445537.888172]  alloc_flow_post_acts+0xfb/0x1c0 [mlx5_core]
[445537.888849]  parse_tc_actions+0x582/0x5c0 [mlx5_core]
[445537.889505]  parse_tc_fdb_actions+0xd7/0x1f0 [mlx5_core]
[445537.890175]  __mlx5e_add_fdb_flow+0x1ab/0x2b0 [mlx5_core]
[445537.890843]  mlx5e_add_fdb_flow+0x56/0x120 [mlx5_core]
[445537.891491]  ? debug_smp_processor_id+0x1b/0x30
[445537.892037]  mlx5e_tc_add_flow+0x79/0x90 [mlx5_core]
[445537.892676]  mlx5e_configure_flower+0x305/0x450 [mlx5_core]
[445537.893341]  mlx5e_rep_setup_tc_cls_flower+0x3d/0x80 [mlx5_core]
[445537.894037]  mlx5e_rep_setup_tc_cb+0x5c/0xa0 [mlx5_core]
[445537.894693]  tc_setup_cb_add+0xdc/0x220
[445537.895177]  fl_hw_replace_filter+0x15f/0x220 [cls_flower]
[445537.895767]  fl_change+0xe87/0x1190 [cls_flower]
[445537.896302]  tc_new_tfilter+0x484/0xa50

Fixes: f0da4daa3413 ("net/mlx5e: Refactor ct to use post action infrastructure")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Automatic Verification <verifier@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shachar Kagan <skagan@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en/tc/post_act.c       |  6 +++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 25 ++++++++++++++++---
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
index 4e923a2874aef..86bf007fd05b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
@@ -83,6 +83,9 @@ mlx5e_tc_post_act_offload(struct mlx5e_post_act *post_act,
 	struct mlx5_flow_spec *spec;
 	int err;
 
+	if (IS_ERR(post_act))
+		return PTR_ERR(post_act);
+
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec)
 		return -ENOMEM;
@@ -111,6 +114,9 @@ mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *po
 	struct mlx5e_post_act_handle *handle;
 	int err;
 
+	if (IS_ERR(post_act))
+		return ERR_CAST(post_act);
+
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
 	if (!handle)
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index b62fd37493410..1bead98f73bf5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -444,6 +444,9 @@ mlx5e_tc_add_flow_meter(struct mlx5e_priv *priv,
 	struct mlx5e_flow_meter_handle *meter;
 	enum mlx5e_post_meter_type type;
 
+	if (IS_ERR(post_act))
+		return PTR_ERR(post_act);
+
 	meter = mlx5e_tc_meter_replace(priv->mdev, &attr->meter_attr.params);
 	if (IS_ERR(meter)) {
 		mlx5_core_err(priv->mdev, "Failed to get flow meter\n");
@@ -3736,6 +3739,20 @@ alloc_flow_post_acts(struct mlx5e_tc_flow *flow, struct netlink_ext_ack *extack)
 	return err;
 }
 
+static int
+set_branch_dest_ft(struct mlx5e_priv *priv, struct mlx5_flow_attr *attr)
+{
+	struct mlx5e_post_act *post_act = get_post_action(priv);
+
+	if (IS_ERR(post_act))
+		return PTR_ERR(post_act);
+
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	attr->dest_ft = mlx5e_tc_post_act_get_ft(post_act);
+
+	return 0;
+}
+
 static int
 alloc_branch_attr(struct mlx5e_tc_flow *flow,
 		  struct mlx5e_tc_act_branch_ctrl *cond,
@@ -3759,8 +3776,8 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
 		break;
 	case FLOW_ACTION_ACCEPT:
 	case FLOW_ACTION_PIPE:
-		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-		attr->dest_ft = mlx5e_tc_post_act_get_ft(get_post_action(flow->priv));
+		if (set_branch_dest_ft(flow->priv, attr))
+			goto out_err;
 		break;
 	case FLOW_ACTION_JUMP:
 		if (*jump_count) {
@@ -3769,8 +3786,8 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
 			goto out_err;
 		}
 		*jump_count = cond->extval;
-		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-		attr->dest_ft = mlx5e_tc_post_act_get_ft(get_post_action(flow->priv));
+		if (set_branch_dest_ft(flow->priv, attr))
+			goto out_err;
 		break;
 	default:
 		err = -EOPNOTSUPP;
-- 
2.43.0



