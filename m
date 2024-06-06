Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92FC19AA7F;
	Thu,  6 Jun 2024 14:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683327; cv=none; b=f07fKMfgu5ICXCOIkOHs43FgWE6o402e2b2gX+dQa/MlrCc4bSQREpACH1xW1RSbmYQw6mgHVv9OJF+4Xn/sQfUC2n2wTitQWOzyU0V5CuUkhQK1vU8PS4U0qipIL51G7zCeWiw3Z0d6pN5sPGVy0XbSp49vHVHTfZDbN9W8+IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683327; c=relaxed/simple;
	bh=YVYjwotcqwOpho/CBIsGaH7Ce2d181dhwH79IagmA4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvaaD531kAgRv49UniLeyNbtKH+vmRTSSiN5nG16ckE/OE5C/iomYmRSlk34zDhxmxivESwA+ynTpwMPP3zeCU7ZiGUCCgpplFt974posd8eGbf5+f95ljSrHFLP75+wFBY/jmp/JHqOIHqseJ6uRuj9GknxOshAlPUmhQT0XWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hb2QqNkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hb2QqNkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8875C32782;
	Thu,  6 Jun 2024 14:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683327;
	bh=YVYjwotcqwOpho/CBIsGaH7Ce2d181dhwH79IagmA4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hb2QqNkAV/lFxE4eWYTknBPTThsuzuyYGDVgjZON1Gh0KebCxgLL8SY4LFAD/Hq8F
	 KsxqFf+MH54jAa3JMW2HvR9b33nlIzqTopSP0Wcr5P8jp/tWZiV4AbAEc6aMiSXPl6
	 IttnO1cUv02AnITbmQVF1F0Y1Pe/MSKNiYVjkIXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 178/473] net/mlx5: Add a timeout to acquire the command queue semaphore
Date: Thu,  6 Jun 2024 16:01:47 +0200
Message-ID: <20240606131705.811503024@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index ac6a0785b10d8..946923b9404fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -964,19 +964,32 @@ static void cmd_work_handler(struct work_struct *work)
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
@@ -989,10 +1002,11 @@ static void cmd_work_handler(struct work_struct *work)
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
@@ -1000,6 +1014,8 @@ static void cmd_work_handler(struct work_struct *work)
 		spin_unlock_irqrestore(&cmd->alloc_lock, flags);
 	}
 
+	complete(&ent->slotted);
+
 	lay = get_inst(cmd, ent->idx);
 	ent->lay = lay;
 	memset(lay, 0, sizeof(*lay));
@@ -1018,7 +1034,7 @@ static void cmd_work_handler(struct work_struct *work)
 	ent->ts1 = ktime_get_ns();
 	cmd_mode = cmd->mode;
 
-	if (ent->callback && schedule_delayed_work(&ent->cb_timeout_work, cb_timeout))
+	if (ent->callback && schedule_delayed_work(&ent->cb_timeout_work, timeout))
 		cmd_ent_get(ent);
 	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 
@@ -1138,6 +1154,9 @@ static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 		ent->ret = -ECANCELED;
 		goto out_err;
 	}
+
+	wait_for_completion(&ent->slotted);
+
 	if (cmd->mode == CMD_MODE_POLLING || ent->polling)
 		wait_for_completion(&ent->done);
 	else if (!wait_for_completion_timeout(&ent->done, timeout))
@@ -1152,6 +1171,9 @@ static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 	} else if (err == -ECANCELED) {
 		mlx5_core_warn(dev, "%s(0x%x) canceled on out of queue timeout.\n",
 			       mlx5_command_str(ent->op), ent->op);
+	} else if (err == -EBUSY) {
+		mlx5_core_warn(dev, "%s(0x%x) timeout while waiting for command semaphore.\n",
+			       mlx5_command_str(ent->op), ent->op);
 	}
 	mlx5_core_dbg(dev, "err %d, delivery status %s(%d)\n",
 		      err, deliv_status_to_str(ent->status), ent->status);
@@ -1203,6 +1225,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 	ent->polling = force_polling;
 
 	init_completion(&ent->handling);
+	init_completion(&ent->slotted);
 	if (!callback)
 		init_completion(&ent->done);
 
@@ -1220,7 +1243,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 		return 0; /* mlx5_cmd_comp_handler() will put(ent) */
 
 	err = wait_func(dev, ent);
-	if (err == -ETIMEDOUT || err == -ECANCELED)
+	if (err == -ETIMEDOUT || err == -ECANCELED || err == -EBUSY)
 		goto out_free;
 
 	ds = ent->ts2 - ent->ts1;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 93ec34a94b724..1cae12185cf04 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -850,6 +850,7 @@ struct mlx5_cmd_work_ent {
 	void		       *context;
 	int			idx;
 	struct completion	handling;
+	struct completion	slotted;
 	struct completion	done;
 	struct mlx5_cmd        *cmd;
 	struct work_struct	work;
-- 
2.43.0



