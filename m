Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F6F79D8;
	Sat, 30 Dec 2023 12:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmvtuW6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B789C433C7;
	Sat, 30 Dec 2023 12:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938074;
	bh=77IGdY+ktmf/1Qj/Jm1KZ2qWbN31SLJvgl/0gU9HK8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmvtuW6fTKXFmlWKyaZxoNSCA7UAM4f0gFHptPLTe8dBnJmHCLCLjdlag6/4dNqir
	 s0UNFZw0vOHeGqxNKe7xORmAwIm3F/GzJfv3CvTl5Af/36/qHwe6oSj1RzvuAObUTJ
	 5phYfrgjZDmH68YpYTSX0HP3X0aj/sY9b0ND34l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/112] net/mlx5: Introduce and use opcode getter in command interface
Date: Sat, 30 Dec 2023 11:58:50 +0000
Message-ID: <20231230115807.299900346@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit 7cb5eb937231663d11f7817e366f6f86a142d6d3 ]

Introduce an opcode getter in the FW command interface, and use it.
Initialize the entry's opcode field early in cmd_alloc_ent() and use it
when possible.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 8f5100da56b3 ("net/mlx5e: Fix a race in command alloc flow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 88 +++++++++----------
 1 file changed, 42 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index b3253e263ebc8..edc42f0b3e74d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -48,6 +48,25 @@
 #define CREATE_TRACE_POINTS
 #include "diag/cmd_tracepoint.h"
 
+struct mlx5_ifc_mbox_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x40];
+};
+
+struct mlx5_ifc_mbox_in_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x40];
+};
+
 enum {
 	CMD_IF_REV = 5,
 };
@@ -71,6 +90,11 @@ enum {
 	MLX5_CMD_DELIVERY_STAT_CMD_DESCR_ERR		= 0x10,
 };
 
+static u16 in_to_opcode(void *in)
+{
+	return MLX5_GET(mbox_in, in, opcode);
+}
+
 static struct mlx5_cmd_work_ent *
 cmd_alloc_ent(struct mlx5_cmd *cmd, struct mlx5_cmd_msg *in,
 	      struct mlx5_cmd_msg *out, void *uout, int uout_size,
@@ -92,6 +116,7 @@ cmd_alloc_ent(struct mlx5_cmd *cmd, struct mlx5_cmd_msg *in,
 	ent->context	= context;
 	ent->cmd	= cmd;
 	ent->page_queue = page_queue;
+	ent->op         = in_to_opcode(in->first.data);
 	refcount_set(&ent->refcnt, 1);
 
 	return ent;
@@ -753,25 +778,6 @@ static int cmd_status_to_err(u8 status)
 	}
 }
 
-struct mlx5_ifc_mbox_out_bits {
-	u8         status[0x8];
-	u8         reserved_at_8[0x18];
-
-	u8         syndrome[0x20];
-
-	u8         reserved_at_40[0x40];
-};
-
-struct mlx5_ifc_mbox_in_bits {
-	u8         opcode[0x10];
-	u8         uid[0x10];
-
-	u8         reserved_at_20[0x10];
-	u8         op_mod[0x10];
-
-	u8         reserved_at_40[0x40];
-};
-
 void mlx5_cmd_out_err(struct mlx5_core_dev *dev, u16 opcode, u16 op_mod, void *out)
 {
 	u32 syndrome = MLX5_GET(mbox_out, out, syndrome);
@@ -789,7 +795,7 @@ static void cmd_status_print(struct mlx5_core_dev *dev, void *in, void *out)
 	u16 opcode, op_mod;
 	u16 uid;
 
-	opcode = MLX5_GET(mbox_in, in, opcode);
+	opcode = in_to_opcode(in);
 	op_mod = MLX5_GET(mbox_in, in, op_mod);
 	uid    = MLX5_GET(mbox_in, in, uid);
 
@@ -801,7 +807,7 @@ int mlx5_cmd_check(struct mlx5_core_dev *dev, int err, void *in, void *out)
 {
 	/* aborted due to PCI error or via reset flow mlx5_cmd_trigger_completions() */
 	if (err == -ENXIO) {
-		u16 opcode = MLX5_GET(mbox_in, in, opcode);
+		u16 opcode = in_to_opcode(in);
 		u32 syndrome;
 		u8 status;
 
@@ -830,9 +836,9 @@ static void dump_command(struct mlx5_core_dev *dev,
 			 struct mlx5_cmd_work_ent *ent, int input)
 {
 	struct mlx5_cmd_msg *msg = input ? ent->in : ent->out;
-	u16 op = MLX5_GET(mbox_in, ent->lay->in, opcode);
 	struct mlx5_cmd_mailbox *next = msg->next;
 	int n = mlx5_calc_cmd_blocks(msg);
+	u16 op = ent->op;
 	int data_only;
 	u32 offset = 0;
 	int dump_len;
@@ -884,11 +890,6 @@ static void dump_command(struct mlx5_core_dev *dev,
 	mlx5_core_dbg(dev, "cmd[%d]: end dump\n", ent->idx);
 }
 
-static u16 msg_to_opcode(struct mlx5_cmd_msg *in)
-{
-	return MLX5_GET(mbox_in, in->first.data, opcode);
-}
-
 static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool forced);
 
 static void cb_timeout_handler(struct work_struct *work)
@@ -906,13 +907,13 @@ static void cb_timeout_handler(struct work_struct *work)
 	/* Maybe got handled by eq recover ? */
 	if (!test_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state)) {
 		mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) Async, recovered after timeout\n", ent->idx,
-			       mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
+			       mlx5_command_str(ent->op), ent->op);
 		goto out; /* phew, already handled */
 	}
 
 	ent->ret = -ETIMEDOUT;
 	mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) Async, timeout. Will cause a leak of a command resource\n",
-		       ent->idx, mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
+		       ent->idx, mlx5_command_str(ent->op), ent->op);
 	mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
 
 out:
@@ -986,7 +987,6 @@ static void cmd_work_handler(struct work_struct *work)
 	ent->lay = lay;
 	memset(lay, 0, sizeof(*lay));
 	memcpy(lay->in, ent->in->first.data, sizeof(lay->in));
-	ent->op = be32_to_cpu(lay->in[0]) >> 16;
 	if (ent->in->next)
 		lay->in_ptr = cpu_to_be64(ent->in->next->dma);
 	lay->inlen = cpu_to_be32(ent->in->len);
@@ -1099,12 +1099,12 @@ static void wait_func_handle_exec_timeout(struct mlx5_core_dev *dev,
 	 */
 	if (wait_for_completion_timeout(&ent->done, timeout)) {
 		mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) recovered after timeout\n", ent->idx,
-			       mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
+			       mlx5_command_str(ent->op), ent->op);
 		return;
 	}
 
 	mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) No done completion\n", ent->idx,
-		       mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
+		       mlx5_command_str(ent->op), ent->op);
 
 	ent->ret = -ETIMEDOUT;
 	mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
@@ -1131,12 +1131,10 @@ static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 
 	if (err == -ETIMEDOUT) {
 		mlx5_core_warn(dev, "%s(0x%x) timeout. Will cause a leak of a command resource\n",
-			       mlx5_command_str(msg_to_opcode(ent->in)),
-			       msg_to_opcode(ent->in));
+			       mlx5_command_str(ent->op), ent->op);
 	} else if (err == -ECANCELED) {
 		mlx5_core_warn(dev, "%s(0x%x) canceled on out of queue timeout.\n",
-			       mlx5_command_str(msg_to_opcode(ent->in)),
-			       msg_to_opcode(ent->in));
+			       mlx5_command_str(ent->op), ent->op);
 	}
 	mlx5_core_dbg(dev, "err %d, delivery status %s(%d)\n",
 		      err, deliv_status_to_str(ent->status), ent->status);
@@ -1170,7 +1168,6 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 	u8 status = 0;
 	int err = 0;
 	s64 ds;
-	u16 op;
 
 	if (callback && page_queue)
 		return -EINVAL;
@@ -1210,9 +1207,8 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 		goto out_free;
 
 	ds = ent->ts2 - ent->ts1;
-	op = MLX5_GET(mbox_in, in->first.data, opcode);
-	if (op < MLX5_CMD_OP_MAX) {
-		stats = &cmd->stats[op];
+	if (ent->op < MLX5_CMD_OP_MAX) {
+		stats = &cmd->stats[ent->op];
 		spin_lock_irq(&stats->lock);
 		stats->sum += ds;
 		++stats->n;
@@ -1220,7 +1216,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 	}
 	mlx5_core_dbg_mask(dev, 1 << MLX5_CMD_TIME,
 			   "fw exec time for %s is %lld nsec\n",
-			   mlx5_command_str(op), ds);
+			   mlx5_command_str(ent->op), ds);
 
 out_free:
 	status = ent->status;
@@ -1817,7 +1813,7 @@ static struct mlx5_cmd_msg *alloc_msg(struct mlx5_core_dev *dev, int in_size,
 
 static int is_manage_pages(void *in)
 {
-	return MLX5_GET(mbox_in, in, opcode) == MLX5_CMD_OP_MANAGE_PAGES;
+	return in_to_opcode(in) == MLX5_CMD_OP_MANAGE_PAGES;
 }
 
 /*  Notes:
@@ -1828,8 +1824,8 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 		    int out_size, mlx5_cmd_cbk_t callback, void *context,
 		    bool force_polling)
 {
-	u16 opcode = MLX5_GET(mbox_in, in, opcode);
 	struct mlx5_cmd_msg *inb, *outb;
+	u16 opcode = in_to_opcode(in);
 	int pages_queue;
 	gfp_t gfp;
 	u8 token;
@@ -1952,8 +1948,8 @@ static int cmd_status_err(struct mlx5_core_dev *dev, int err, u16 opcode, u16 op
 int mlx5_cmd_do(struct mlx5_core_dev *dev, void *in, int in_size, void *out, int out_size)
 {
 	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, false);
-	u16 opcode = MLX5_GET(mbox_in, in, opcode);
 	u16 op_mod = MLX5_GET(mbox_in, in, op_mod);
+	u16 opcode = in_to_opcode(in);
 
 	return cmd_status_err(dev, err, opcode, op_mod, out);
 }
@@ -1998,8 +1994,8 @@ int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
 			  void *out, int out_size)
 {
 	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, true);
-	u16 opcode = MLX5_GET(mbox_in, in, opcode);
 	u16 op_mod = MLX5_GET(mbox_in, in, op_mod);
+	u16 opcode = in_to_opcode(in);
 
 	err = cmd_status_err(dev, err, opcode, op_mod, out);
 	return mlx5_cmd_check(dev, err, in, out);
@@ -2051,7 +2047,7 @@ int mlx5_cmd_exec_cb(struct mlx5_async_ctx *ctx, void *in, int in_size,
 
 	work->ctx = ctx;
 	work->user_callback = callback;
-	work->opcode = MLX5_GET(mbox_in, in, opcode);
+	work->opcode = in_to_opcode(in);
 	work->op_mod = MLX5_GET(mbox_in, in, op_mod);
 	work->out = out;
 	if (WARN_ON(!atomic_inc_not_zero(&ctx->num_inflight)))
-- 
2.43.0



