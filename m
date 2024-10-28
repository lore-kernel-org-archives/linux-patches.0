Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D377118FDA7;
	Mon, 28 Oct 2024 06:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097258; cv=none; b=rqtZJqyJ0FHZKfpdfYgMQzISApMJ3jO9Md+PGV+8X1/TAwPiglJJn+Mxz8VwucfE6vk50fGAXZ+Vz3TL8PxxhvhkBr4dyFPFIBIVRV4d2s86MRib5FFzNJE6lt7kTa2WTkpND2YTsju1DtbfcQ+GEmTJKg0XeiVPx+1VR304z9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097258; c=relaxed/simple;
	bh=FvbCwR/ivGZa8oaxzpxGfYkg16pIEFeS8ZQI3PoZutw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnaBwEQeDdMA+89WQP4ErlGZnwXiyxCE2Majbiy80Iqo1v67YXlfxLHFQCiUn5duM/hvSeR+Ou9LkXN11EUxgj/0H2QnksoA7Kegl0JGW/fAlBxizkDRDpRUeWcKNbgd5rhuLCPM+A3hbt1AjmA0YNLwAn40oBmaxP35FKev0aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kn9mUZwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kn9mUZwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E3CC4CEC7;
	Mon, 28 Oct 2024 06:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097258;
	bh=FvbCwR/ivGZa8oaxzpxGfYkg16pIEFeS8ZQI3PoZutw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kn9mUZwv9oqVhX0/jU2J0c/SG9LfxMe/6sHuKj55JwvMyGXOignfUsRZ+uUyCjqQi
	 hEOzyNf67le1pM8HMYPuOqj2xeu9MWs7FffcxuYLW2LfZamsl1LcB9S90yYaK5J9r9
	 JameLR0jdF84MVxZNrbMzIiUlE/VHpdwdWDFaVIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/137] net/mlx5: split mlx5_cmd_init() to probe and reload routines
Date: Mon, 28 Oct 2024 07:24:49 +0100
Message-ID: <20241028062300.183560601@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 06cd555f73caec515a14d42ef052221fa2587ff9 ]

There is no need to destroy and allocate cmd SW structs during reload,
this is time consuming for no reason.
Hence, split mlx5_cmd_init() to probe and reload routines.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: d62b14045c65 ("net/mlx5: Fix command bitmask initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 121 ++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/main.c    |  15 ++-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 3 files changed, 82 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 2269f5e0e3c75..c6ddf51818efe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1570,7 +1570,6 @@ static void clean_debug_files(struct mlx5_core_dev *dev)
 	if (!mlx5_debugfs_root)
 		return;
 
-	mlx5_cmdif_debugfs_cleanup(dev);
 	debugfs_remove_recursive(dbg->dbg_root);
 }
 
@@ -1585,8 +1584,6 @@ static void create_debugfs_files(struct mlx5_core_dev *dev)
 	debugfs_create_file("out_len", 0600, dbg->dbg_root, dev, &olfops);
 	debugfs_create_u8("status", 0600, dbg->dbg_root, &dbg->status);
 	debugfs_create_file("run", 0200, dbg->dbg_root, dev, &fops);
-
-	mlx5_cmdif_debugfs_init(dev);
 }
 
 void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode)
@@ -2215,19 +2212,10 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 	int size = sizeof(struct mlx5_cmd_prot_block);
 	int align = roundup_pow_of_two(size);
 	struct mlx5_cmd *cmd = &dev->cmd;
-	u32 cmd_h, cmd_l;
+	u32 cmd_l;
 	int err;
 	int i;
 
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->vars.cmdif_rev = cmdif_rev(dev);
-	if (cmd->vars.cmdif_rev != CMD_IF_REV) {
-		mlx5_core_err(dev,
-			      "Driver cmdif rev(%d) differs from firmware's(%d)\n",
-			      CMD_IF_REV, cmd->vars.cmdif_rev);
-		return -EINVAL;
-	}
-
 	cmd->pool = dma_pool_create("mlx5_cmd", mlx5_core_dma_dev(dev), size, align, 0);
 	if (!cmd->pool)
 		return -ENOMEM;
@@ -2236,43 +2224,93 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 	if (err)
 		goto err_free_pool;
 
+	cmd_l = (u32)(cmd->dma);
+	if (cmd_l & 0xfff) {
+		mlx5_core_err(dev, "invalid command queue address\n");
+		err = -ENOMEM;
+		goto err_cmd_page;
+	}
+	cmd->checksum_disabled = 1;
+
+	spin_lock_init(&cmd->alloc_lock);
+	spin_lock_init(&cmd->token_lock);
+	for (i = 0; i < MLX5_CMD_OP_MAX; i++)
+		spin_lock_init(&cmd->stats[i].lock);
+
+	create_msg_cache(dev);
+
+	set_wqname(dev);
+	cmd->wq = create_singlethread_workqueue(cmd->wq_name);
+	if (!cmd->wq) {
+		mlx5_core_err(dev, "failed to create command workqueue\n");
+		err = -ENOMEM;
+		goto err_cache;
+	}
+
+	mlx5_cmdif_debugfs_init(dev);
+
+	return 0;
+
+err_cache:
+	destroy_msg_cache(dev);
+err_cmd_page:
+	free_cmd_page(dev, cmd);
+err_free_pool:
+	dma_pool_destroy(cmd->pool);
+	return err;
+}
+
+void mlx5_cmd_cleanup(struct mlx5_core_dev *dev)
+{
+	struct mlx5_cmd *cmd = &dev->cmd;
+
+	mlx5_cmdif_debugfs_cleanup(dev);
+	destroy_workqueue(cmd->wq);
+	destroy_msg_cache(dev);
+	free_cmd_page(dev, cmd);
+	dma_pool_destroy(cmd->pool);
+}
+
+int mlx5_cmd_enable(struct mlx5_core_dev *dev)
+{
+	struct mlx5_cmd *cmd = &dev->cmd;
+	u32 cmd_h, cmd_l;
+
+	memset(&cmd->vars, 0, sizeof(cmd->vars));
+	cmd->vars.cmdif_rev = cmdif_rev(dev);
+	if (cmd->vars.cmdif_rev != CMD_IF_REV) {
+		mlx5_core_err(dev,
+			      "Driver cmdif rev(%d) differs from firmware's(%d)\n",
+			      CMD_IF_REV, cmd->vars.cmdif_rev);
+		return -EINVAL;
+	}
+
 	cmd_l = ioread32be(&dev->iseg->cmdq_addr_l_sz) & 0xff;
 	cmd->vars.log_sz = cmd_l >> 4 & 0xf;
 	cmd->vars.log_stride = cmd_l & 0xf;
 	if (1 << cmd->vars.log_sz > MLX5_MAX_COMMANDS) {
 		mlx5_core_err(dev, "firmware reports too many outstanding commands %d\n",
 			      1 << cmd->vars.log_sz);
-		err = -EINVAL;
-		goto err_free_page;
+		return -EINVAL;
 	}
 
 	if (cmd->vars.log_sz + cmd->vars.log_stride > MLX5_ADAPTER_PAGE_SHIFT) {
 		mlx5_core_err(dev, "command queue size overflow\n");
-		err = -EINVAL;
-		goto err_free_page;
+		return -EINVAL;
 	}
 
 	cmd->state = MLX5_CMDIF_STATE_DOWN;
-	cmd->checksum_disabled = 1;
 	cmd->vars.max_reg_cmds = (1 << cmd->vars.log_sz) - 1;
 	cmd->vars.bitmask = (1UL << cmd->vars.max_reg_cmds) - 1;
 
-	spin_lock_init(&cmd->alloc_lock);
-	spin_lock_init(&cmd->token_lock);
-	for (i = 0; i < MLX5_CMD_OP_MAX; i++)
-		spin_lock_init(&cmd->stats[i].lock);
-
 	sema_init(&cmd->vars.sem, cmd->vars.max_reg_cmds);
 	sema_init(&cmd->vars.pages_sem, 1);
 	sema_init(&cmd->vars.throttle_sem, DIV_ROUND_UP(cmd->vars.max_reg_cmds, 2));
 
 	cmd_h = (u32)((u64)(cmd->dma) >> 32);
 	cmd_l = (u32)(cmd->dma);
-	if (cmd_l & 0xfff) {
-		mlx5_core_err(dev, "invalid command queue address\n");
-		err = -ENOMEM;
-		goto err_free_page;
-	}
+	if (WARN_ON(cmd_l & 0xfff))
+		return -EINVAL;
 
 	iowrite32be(cmd_h, &dev->iseg->cmdq_addr_h);
 	iowrite32be(cmd_l, &dev->iseg->cmdq_addr_l_sz);
@@ -2285,40 +2323,17 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 	cmd->mode = CMD_MODE_POLLING;
 	cmd->allowed_opcode = CMD_ALLOWED_OPCODE_ALL;
 
-	create_msg_cache(dev);
-
-	set_wqname(dev);
-	cmd->wq = create_singlethread_workqueue(cmd->wq_name);
-	if (!cmd->wq) {
-		mlx5_core_err(dev, "failed to create command workqueue\n");
-		err = -ENOMEM;
-		goto err_cache;
-	}
-
 	create_debugfs_files(dev);
 
 	return 0;
-
-err_cache:
-	destroy_msg_cache(dev);
-
-err_free_page:
-	free_cmd_page(dev, cmd);
-
-err_free_pool:
-	dma_pool_destroy(cmd->pool);
-	return err;
 }
 
-void mlx5_cmd_cleanup(struct mlx5_core_dev *dev)
+void mlx5_cmd_disable(struct mlx5_core_dev *dev)
 {
 	struct mlx5_cmd *cmd = &dev->cmd;
 
 	clean_debug_files(dev);
-	destroy_workqueue(cmd->wq);
-	destroy_msg_cache(dev);
-	free_cmd_page(dev, cmd);
-	dma_pool_destroy(cmd->pool);
+	flush_workqueue(cmd->wq);
 }
 
 void mlx5_cmd_set_state(struct mlx5_core_dev *dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 825ad7663fa45..de7baa1a1e163 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1114,7 +1114,7 @@ static int mlx5_function_enable(struct mlx5_core_dev *dev, bool boot, u64 timeou
 		return err;
 	}
 
-	err = mlx5_cmd_init(dev);
+	err = mlx5_cmd_enable(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed initializing command interface, aborting\n");
 		return err;
@@ -1168,7 +1168,7 @@ static int mlx5_function_enable(struct mlx5_core_dev *dev, bool boot, u64 timeou
 	mlx5_stop_health_poll(dev, boot);
 err_cmd_cleanup:
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
-	mlx5_cmd_cleanup(dev);
+	mlx5_cmd_disable(dev);
 
 	return err;
 }
@@ -1179,7 +1179,7 @@ static void mlx5_function_disable(struct mlx5_core_dev *dev, bool boot)
 	mlx5_core_disable_hca(dev, 0);
 	mlx5_stop_health_poll(dev, boot);
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
-	mlx5_cmd_cleanup(dev);
+	mlx5_cmd_disable(dev);
 }
 
 static int mlx5_function_open(struct mlx5_core_dev *dev)
@@ -1644,6 +1644,12 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 						mlx5_debugfs_root);
 	INIT_LIST_HEAD(&priv->traps);
 
+	err = mlx5_cmd_init(dev);
+	if (err) {
+		mlx5_core_err(dev, "Failed initializing cmdif SW structs, aborting\n");
+		goto err_cmd_init;
+	}
+
 	err = mlx5_tout_init(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed initializing timeouts, aborting\n");
@@ -1689,6 +1695,8 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 err_health_init:
 	mlx5_tout_cleanup(dev);
 err_timeout_init:
+	mlx5_cmd_cleanup(dev);
+err_cmd_init:
 	debugfs_remove(dev->priv.dbg.dbg_root);
 	mutex_destroy(&priv->pgdir_mutex);
 	mutex_destroy(&priv->alloc_mutex);
@@ -1711,6 +1719,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	mlx5_pagealloc_cleanup(dev);
 	mlx5_health_cleanup(dev);
 	mlx5_tout_cleanup(dev);
+	mlx5_cmd_cleanup(dev);
 	debugfs_remove_recursive(dev->priv.dbg.dbg_root);
 	mutex_destroy(&priv->pgdir_mutex);
 	mutex_destroy(&priv->alloc_mutex);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 0b560e97a3563..7d90f311b8560 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -177,6 +177,8 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev);
 int mlx5_query_board_id(struct mlx5_core_dev *dev);
 int mlx5_cmd_init(struct mlx5_core_dev *dev);
 void mlx5_cmd_cleanup(struct mlx5_core_dev *dev);
+int mlx5_cmd_enable(struct mlx5_core_dev *dev);
+void mlx5_cmd_disable(struct mlx5_core_dev *dev);
 void mlx5_cmd_set_state(struct mlx5_core_dev *dev,
 			enum mlx5_cmdif_state cmdif_state);
 int mlx5_cmd_init_hca(struct mlx5_core_dev *dev, uint32_t *sw_owner_id);
-- 
2.43.0



