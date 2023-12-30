Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CB2611A;
	Sat, 30 Dec 2023 12:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4I/arpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BFAC433C8;
	Sat, 30 Dec 2023 12:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938077;
	bh=//3KtTdq+RH2POQiD9WMSc7u3GSIqjw88maNgXBUQEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4I/arpZckyOXfUyuDDryywW9IyJsqSqjFO3I+REta+dLOm1BAD//AmUBWysG+cyo
	 h2ZX5Q1iKHHLjp2ulCr++1sXHYGr+ob+mLcb+JuLD4USWw5mWKTUbDLJ/HSdLIHDT8
	 BNtWy/M1IdM4gbYsaZqVLMAJVxw9SWKWUXR+U7Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/112] net/mlx5: Prevent high-rate FW commands from populating all slots
Date: Sat, 30 Dec 2023 11:58:51 +0000
Message-ID: <20231230115807.336014327@linuxfoundation.org>
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

[ Upstream commit 63fbae0a74c3e1df7c20c81e04353ced050d9887 ]

Certain connection-based device-offload protocols (like TLS) use
per-connection HW objects to track the state, maintain the context, and
perform the offload properly. Some of these objects are created,
modified, and destroyed via FW commands. Under high connection rate,
this type of FW commands might continuously populate all slots of the FW
command interface and throttle it, while starving other critical control
FW commands.

Limit these throttle commands to using only up to a portion (half) of
the FW command interface slots. FW commands maximal rate is not hit, and
the same high rate is still reached when applying this limitation.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 8f5100da56b3 ("net/mlx5e: Fix a race in command alloc flow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 30 ++++++++++++++++++-
 include/linux/mlx5/driver.h                   |  1 +
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index edc42f0b3e74d..84f926064cf7b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -95,6 +95,21 @@ static u16 in_to_opcode(void *in)
 	return MLX5_GET(mbox_in, in, opcode);
 }
 
+/* Returns true for opcodes that might be triggered very frequently and throttle
+ * the command interface. Limit their command slots usage.
+ */
+static bool mlx5_cmd_is_throttle_opcode(u16 op)
+{
+	switch (op) {
+	case MLX5_CMD_OP_CREATE_GENERAL_OBJECT:
+	case MLX5_CMD_OP_DESTROY_GENERAL_OBJECT:
+	case MLX5_CMD_OP_MODIFY_GENERAL_OBJECT:
+	case MLX5_CMD_OP_QUERY_GENERAL_OBJECT:
+		return true;
+	}
+	return false;
+}
+
 static struct mlx5_cmd_work_ent *
 cmd_alloc_ent(struct mlx5_cmd *cmd, struct mlx5_cmd_msg *in,
 	      struct mlx5_cmd_msg *out, void *uout, int uout_size,
@@ -1826,6 +1841,7 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 {
 	struct mlx5_cmd_msg *inb, *outb;
 	u16 opcode = in_to_opcode(in);
+	bool throttle_op;
 	int pages_queue;
 	gfp_t gfp;
 	u8 token;
@@ -1834,13 +1850,21 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, opcode))
 		return -ENXIO;
 
+	throttle_op = mlx5_cmd_is_throttle_opcode(opcode);
+	if (throttle_op) {
+		/* atomic context may not sleep */
+		if (callback)
+			return -EINVAL;
+		down(&dev->cmd.throttle_sem);
+	}
+
 	pages_queue = is_manage_pages(in);
 	gfp = callback ? GFP_ATOMIC : GFP_KERNEL;
 
 	inb = alloc_msg(dev, in_size, gfp);
 	if (IS_ERR(inb)) {
 		err = PTR_ERR(inb);
-		return err;
+		goto out_up;
 	}
 
 	token = alloc_token(&dev->cmd);
@@ -1874,6 +1898,9 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	mlx5_free_cmd_msg(dev, outb);
 out_in:
 	free_msg(dev, inb);
+out_up:
+	if (throttle_op)
+		up(&dev->cmd.throttle_sem);
 	return err;
 }
 
@@ -2218,6 +2245,7 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 
 	sema_init(&cmd->sem, cmd->max_reg_cmds);
 	sema_init(&cmd->pages_sem, 1);
+	sema_init(&cmd->throttle_sem, DIV_ROUND_UP(cmd->max_reg_cmds, 2));
 
 	cmd_h = (u32)((u64)(cmd->dma) >> 32);
 	cmd_l = (u32)(cmd->dma);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 3660ce6a93496..ce019c337f67f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -308,6 +308,7 @@ struct mlx5_cmd {
 	struct workqueue_struct *wq;
 	struct semaphore sem;
 	struct semaphore pages_sem;
+	struct semaphore throttle_sem;
 	int	mode;
 	u16     allowed_opcode;
 	struct mlx5_cmd_work_ent *ent_arr[MLX5_MAX_COMMANDS];
-- 
2.43.0



