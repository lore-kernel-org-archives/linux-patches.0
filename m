Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3614F168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90529C433D2;
	Mon,  8 May 2023 11:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544615;
	bh=UBzvF0FoCgQgMa1PKXy3y+lqYqNUOOW8S9SEJLq5O0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvCTCbry0RwcyMAX2ad+YUocHJkukPS/rO5K9aDdHyzTGPaWChTmKSpSEB3vkZXPy
	 8UraAD8iVShrxnwAZuBwdNSggijx4qLN/ufnbfIVqRaobBTc0GCiV2mk3veZRqNRO3
	 wlhr7YnDDT2CYY//qFjE2kul/nDrC3i5Ctb4YVqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 467/694] net/mlx5: Use recovery timeout on sync reset flow
Date: Mon,  8 May 2023 11:45:02 +0200
Message-Id: <20230508094448.897897714@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

[ Upstream commit dfad99750c0f83b0242572a573afa2c055f85b36 ]

Use the same timeout for sync reset flow and health recovery flow, since
the former involves driver's recovery from firmware reset, which is
similar to health recovery. Otherwise, in some cases, such as a firmware
upgrade on the DPU, the firmware pre-init bit may not be ready within
current timeout and the driver will abort loading back after reset.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Fixes: 37ca95e62ee2 ("net/mlx5: Increase FW pre-init timeout for health recovery")
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index c5d2fdcabd566..e5f03d071a37a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -202,7 +202,7 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 			break;
 		/* On fw_activate action, also driver is reloaded and reinit performed */
 		*actions_performed |= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
-		ret = mlx5_load_one_devl_locked(dev, false);
+		ret = mlx5_load_one_devl_locked(dev, true);
 		break;
 	default:
 		/* Unsupported action should not get to this function */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 289e915def989..50022e7565f14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -167,7 +167,7 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 		if (mlx5_health_wait_pci_up(dev))
 			mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
 		else
-			mlx5_load_one(dev, false);
+			mlx5_load_one(dev, true);
 		devlink_remote_reload_actions_performed(priv_to_devlink(dev), 0,
 							BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 							BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
@@ -499,7 +499,7 @@ int mlx5_fw_reset_wait_reset_done(struct mlx5_core_dev *dev)
 	err = fw_reset->ret;
 	if (test_and_clear_bit(MLX5_FW_RESET_FLAGS_RELOAD_REQUIRED, &fw_reset->reset_flags)) {
 		mlx5_unload_one_devl_locked(dev, false);
-		mlx5_load_one_devl_locked(dev, false);
+		mlx5_load_one_devl_locked(dev, true);
 	}
 out:
 	clear_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags);
-- 
2.39.2



