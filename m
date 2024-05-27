Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC95262BE;
	Mon, 27 May 2024 19:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838234; cv=none; b=l2UA2ECo4kuPxAFz7uQL/fFUoJxDXd8REetjz8tnJkGkLukxaf9dT5Cea9e8vd0yz3BpNHiJKyP+71d6DUmLexEDT+8ez4uZ2M6/86mEjwwcgpNULkJ9eGHWzB6QtNJ4K47z47r3e9J0lOYAMnkPG6q/sdFgJhOtXhS1zCbaZsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838234; c=relaxed/simple;
	bh=ZmGFmWISRovXeVBz5AS0lverTWZsB3Iso7x0/NBM/E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3gows+ihkpblcHCMmM8YyoTp0k5/7Ph/SnE/6Dba/bcCI4zv7R0y8gOPnipwjveZwg2YhkIR7SFICbnAsQzd0I2KnGmDqru9I5qWdE7EktMp/Fr2sds5XEws98LnsdeumoCxW0+BRA/qZ7Ml7TCbXG2EsKO3emmrblGWhvpX48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOZyshpc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOZyshpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5840C2BBFC;
	Mon, 27 May 2024 19:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838234;
	bh=ZmGFmWISRovXeVBz5AS0lverTWZsB3Iso7x0/NBM/E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SOZyshpc6q4QzrfpUqNYN3wuzjjTuej6afHRFjtLV/c9Elcaws6jE0qykuSVsBpc/
	 +QiEPF0o8w2r4bruYisAWiBW5iqNOwYyONCas9OdvS8HCScT33PALZvFdhrlYJimel
	 aeHC7fgaPoH5E87r/G2L9c09KPUjPQycBRt75Tw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 317/493] net/mlx5: Add a timeout to acquire the command queue semaphore
Date: Mon, 27 May 2024 20:55:19 +0200
Message-ID: <20240527185640.653037119@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akiva Goldberger <agoldberger@nvidia.com>

[ Upstream commit 485d65e1357123a697c591a5aeb773994b247ad7 ]

Prevent forced completion handling on an entry that has not yet been
assigned an index, causing an out of bounds access on idx = -22.
Instead of waiting indefinitely for the sem, blocking flow now waits for
index to be allocated or a sem acquisition timeout before beginning the
timer for FW completion.

Kernel log example:
mlx5_core 0000:06:00.0: wait_func_handle_exec_timeout:1128:(pid 185911): cmd[-22]: CREATE_UCTX(0xa04) No done completion

Fixes: 8e715cd613a1 ("net/mlx5: Set command entry semaphore up once got index free")
Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240509112951.590184-5-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 41 +++++++++++++++----
 include/linux/mlx5/driver.h                   |  1 +
 2 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 4957412ff1f65..511e7fee39ac5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -969,19 +969,32 @@ static void cmd_work_handler(struct work_struct *work)
 	bool poll_cmd = ent->polling;
 	struct mlx5_cmd_layout *lay;
 	struct mlx5_core_dev *dev;
-	unsigned long cb_timeout;
-	struct semaphore *sem;
+	unsigned long timeout;
 	unsigned long flags;
 	int alloc_ret;
 	int cmd_mode;
 
+	complete(&ent->handling);
+
 	dev = container_of(cmd, struct mlx5_core_dev, cmd);
-	cb_timeout = msecs_to_jiffies(mlx5_tout_ms(dev, CMD));
+	timeout = msecs_to_jiffies(mlx5_tout_ms(dev, CMD));
 
-	complete(&ent->handling);
-	sem = ent->page_queue ? &cmd->vars.pages_sem : &cmd->vars.sem;
-	down(sem);
 	if (!ent->page_queue) {
+		if (down_timeout(&cmd->vars.sem, timeout)) {
+			mlx5_core_warn(dev, "%s(0x%x) timed out while waiting for a slot.\n",
+				       mlx5_command_str(ent->op), ent->op);
+			if (ent->callback) {
+				ent->callback(-EBUSY, ent->context);
+				mlx5_free_cmd_msg(dev, ent->out);
+				free_msg(dev, ent->in);
+				cmd_ent_put(ent);
+			} else {
+				ent->ret = -EBUSY;
+				complete(&ent->done);
+			}
+			complete(&ent->slotted);
+			return;
+		}
 		alloc_ret = cmd_alloc_index(cmd, ent);
 		if (alloc_ret < 0) {
 			mlx5_core_err_rl(dev, "failed to allocate command entry\n");
@@ -994,10 +1007,11 @@ static void cmd_work_handler(struct work_struct *work)
 				ent->ret = -EAGAIN;
 				complete(&ent->done);
 			}
-			up(sem);
+			up(&cmd->vars.sem);
 			return;
 		}
 	} else {
+		down(&cmd->vars.pages_sem);
 		ent->idx = cmd->vars.max_reg_cmds;
 		spin_lock_irqsave(&cmd->alloc_lock, flags);
 		clear_bit(ent->idx, &cmd->vars.bitmask);
@@ -1005,6 +1019,8 @@ static void cmd_work_handler(struct work_struct *work)
 		spin_unlock_irqrestore(&cmd->alloc_lock, flags);
 	}
 
+	complete(&ent->slotted);
+
 	lay = get_inst(cmd, ent->idx);
 	ent->lay = lay;
 	memset(lay, 0, sizeof(*lay));
@@ -1023,7 +1039,7 @@ static void cmd_work_handler(struct work_struct *work)
 	ent->ts1 = ktime_get_ns();
 	cmd_mode = cmd->mode;
 
-	if (ent->callback && schedule_delayed_work(&ent->cb_timeout_work, cb_timeout))
+	if (ent->callback && schedule_delayed_work(&ent->cb_timeout_work, timeout))
 		cmd_ent_get(ent);
 	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 
@@ -1143,6 +1159,9 @@ static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 		ent->ret = -ECANCELED;
 		goto out_err;
 	}
+
+	wait_for_completion(&ent->slotted);
+
 	if (cmd->mode == CMD_MODE_POLLING || ent->polling)
 		wait_for_completion(&ent->done);
 	else if (!wait_for_completion_timeout(&ent->done, timeout))
@@ -1157,6 +1176,9 @@ static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 	} else if (err == -ECANCELED) {
 		mlx5_core_warn(dev, "%s(0x%x) canceled on out of queue timeout.\n",
 			       mlx5_command_str(ent->op), ent->op);
+	} else if (err == -EBUSY) {
+		mlx5_core_warn(dev, "%s(0x%x) timeout while waiting for command semaphore.\n",
+			       mlx5_command_str(ent->op), ent->op);
 	}
 	mlx5_core_dbg(dev, "err %d, delivery status %s(%d)\n",
 		      err, deliv_status_to_str(ent->status), ent->status);
@@ -1208,6 +1230,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 	ent->polling = force_polling;
 
 	init_completion(&ent->handling);
+	init_completion(&ent->slotted);
 	if (!callback)
 		init_completion(&ent->done);
 
@@ -1225,7 +1248,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 		return 0; /* mlx5_cmd_comp_handler() will put(ent) */
 
 	err = wait_func(dev, ent);
-	if (err == -ETIMEDOUT || err == -ECANCELED)
+	if (err == -ETIMEDOUT || err == -ECANCELED || err == -EBUSY)
 		goto out_free;
 
 	ds = ent->ts2 - ent->ts1;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 41f03b352401e..38d425a187fa3 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -861,6 +861,7 @@ struct mlx5_cmd_work_ent {
 	void		       *context;
 	int			idx;
 	struct completion	handling;
+	struct completion	slotted;
 	struct completion	done;
 	struct mlx5_cmd        *cmd;
 	struct work_struct	work;
-- 
2.43.0



