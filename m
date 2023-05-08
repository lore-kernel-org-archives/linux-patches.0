Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8455168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C95EC433EF;
	Mon,  8 May 2023 10:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540573;
	bh=Xiirx7cPwY2MtZxUrOUtjGSKgrhhGJE5VKfliRBOCrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvm25uprtRz0z3Rj4cog41JB+YudhzOiMk99qnHwCeRuh+gX2YFe0+TjDmg7MbSOC
	 IgHCILUMLLrCrZMyMRI2CpaSEPzlAOaikbWJKWktYMppt7ANVbJoVn32Xoa1jY9ogR
	 iPO4nE79AiFGCHQjfddlbpYDnE/wFs4h5xwB1bxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 383/611] Revert "net/mlx5: Remove "recovery" arg from mlx5_load_one() function"
Date: Mon,  8 May 2023 11:43:45 +0200
Message-Id: <20230508094434.766124169@linuxfoundation.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 21608a2cf38e9f743636b5f86507ffbca18ecee7 ]

This reverts commit 5977ac3910f1cbaf44dca48179118b25c206ac29.

Revert this patch as we need the "recovery" arg back in mlx5_load_one()
function. This arg will be used in the next patch for using recovery
timeout during sync reset flow.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: dfad99750c0f ("net/mlx5: Use recovery timeout on sync reset flow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c      | 9 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 2ef42d76ac6a3..2b74729180394 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -154,7 +154,7 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 		if (mlx5_health_wait_pci_up(dev))
 			mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
 		else
-			mlx5_load_one(dev);
+			mlx5_load_one(dev, false);
 		devlink_remote_reload_actions_performed(priv_to_devlink(dev), 0,
 							BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 							BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 4c72cb3ac30cd..cc8057c4f9080 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1484,13 +1484,13 @@ int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery)
 	return err;
 }
 
-int mlx5_load_one(struct mlx5_core_dev *dev)
+int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery)
 {
 	struct devlink *devlink = priv_to_devlink(dev);
 	int ret;
 
 	devl_lock(devlink);
-	ret = mlx5_load_one_devl_locked(dev, false);
+	ret = mlx5_load_one_devl_locked(dev, recovery);
 	devl_unlock(devlink);
 	return ret;
 }
@@ -1875,7 +1875,8 @@ static void mlx5_pci_resume(struct pci_dev *pdev)
 
 	mlx5_pci_trace(dev, "Enter, loading driver..\n");
 
-	err = mlx5_load_one(dev);
+	err = mlx5_load_one(dev, false);
+
 	if (!err)
 		devlink_health_reporter_state_update(dev->priv.health.fw_fatal_reporter,
 						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
@@ -1966,7 +1967,7 @@ static int mlx5_resume(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 
-	return mlx5_load_one(dev);
+	return mlx5_load_one(dev, false);
 }
 
 static const struct pci_device_id mlx5_core_pci_table[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 02fef8b2d268a..1a35b3c2a3674 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -321,7 +321,7 @@ int mlx5_init_one(struct mlx5_core_dev *dev);
 void mlx5_uninit_one(struct mlx5_core_dev *dev);
 void mlx5_unload_one(struct mlx5_core_dev *dev, bool suspend);
 void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev, bool suspend);
-int mlx5_load_one(struct mlx5_core_dev *dev);
+int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery);
 int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery);
 
 int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out);
-- 
2.39.2



