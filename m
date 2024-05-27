Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A8C17E90E;
	Mon, 27 May 2024 19:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836951; cv=none; b=IqZS9JXXmtBL/rQsnc7VDzabg2OR91jE3ucf7JdMm+o5xb2lzoxIAYonjVkt/DLOQuzjPVlxofVkNDNfDS9QLD3EOi4ipidtlvgdjzaGO0zTkLw5ysGr9CbIQe8AcsGAU9XuUZRthH34sILLQSSBQ1fx4Jae1ne+lNMh/xpcC0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836951; c=relaxed/simple;
	bh=mceAmxC/55fntlWEDS92yCrg3umjcAjW44Ag2EVeROs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIN6av/nXl4mbGXSDfXNiG3c1ujT7sJ7EPY8mFwXH+lQguk/aAkWqiwHBg6NnKyW0aBHLicvsv0UYdFGH+GGSsKMgNyzF1JASVbWfU04citdY9xl/BxrVjvsn1sv4x5TUo1TPyFJ9tz9I3Izm2Gv3gw8XNGpU11Irulcy6PBL68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAPydtZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAPydtZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1204CC2BBFC;
	Mon, 27 May 2024 19:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836951;
	bh=mceAmxC/55fntlWEDS92yCrg3umjcAjW44Ag2EVeROs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAPydtZ6oMyKKzyZ6rzHYHCZzRNQ4P3ulYqdRi/7IkNmSJFwkH7McgUfMeCnU/dT+
	 YKjfaPn3oc21BeCzIbXqU514rJyhSBIGvQnFZEZLV5+4sJZSGLdiltsU4pG63vAnSF
	 0dsV9hOT4pJzKuPAu+lfe2vR7A7W92N3z5c6eqkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 252/427] net/mlx5: Fix peer devlink set for SF representor devlink port
Date: Mon, 27 May 2024 20:54:59 +0200
Message-ID: <20240527185626.089311462@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 3c453e8cc672de1f9c662948dba43176bc68d7f0 ]

The cited patch change register devlink flow, and neglect to reflect
the changes for peer devlink set logic. Peer devlink set is
triggering a call trace if done after devl_register.[1]

Hence, align peer devlink set logic with register devlink flow.

[1]
WARNING: CPU: 4 PID: 3394 at net/devlink/core.c:155 devlink_rel_nested_in_add+0x177/0x180
CPU: 4 PID: 3394 Comm: kworker/u40:1 Not tainted 6.9.0-rc4_for_linust_min_debug_2024_04_16_14_08 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
Workqueue: mlx5_vhca_event0 mlx5_vhca_state_work_handler [mlx5_core]
RIP: 0010:devlink_rel_nested_in_add+0x177/0x180
Call Trace:
 <TASK>
 ? __warn+0x78/0x120
 ? devlink_rel_nested_in_add+0x177/0x180
 ? report_bug+0x16d/0x180
 ? handle_bug+0x3c/0x60
 ? exc_invalid_op+0x14/0x70
 ? asm_exc_invalid_op+0x16/0x20
 ? devlink_port_init+0x30/0x30
 ? devlink_port_type_clear+0x50/0x50
 ? devlink_rel_nested_in_add+0x177/0x180
 ? devlink_rel_nested_in_add+0xdd/0x180
 mlx5_sf_mdev_event+0x74/0xb0 [mlx5_core]
 notifier_call_chain+0x35/0xb0
 blocking_notifier_call_chain+0x3d/0x60
 mlx5_blocking_notifier_call_chain+0x22/0x30 [mlx5_core]
 mlx5_sf_dev_probe+0x185/0x3e0 [mlx5_core]
 auxiliary_bus_probe+0x38/0x80
 ? driver_sysfs_add+0x51/0x80
 really_probe+0xc5/0x3a0
 ? driver_probe_device+0x90/0x90
 __driver_probe_device+0x80/0x160
 driver_probe_device+0x1e/0x90
 __device_attach_driver+0x7d/0x100
 bus_for_each_drv+0x80/0xd0
 __device_attach+0xbc/0x1f0
 bus_probe_device+0x86/0xa0
 device_add+0x64f/0x860
 __auxiliary_device_add+0x3b/0xa0
 mlx5_sf_dev_add+0x139/0x330 [mlx5_core]
 mlx5_sf_dev_state_change_handler+0x1e4/0x250 [mlx5_core]
 notifier_call_chain+0x35/0xb0
 blocking_notifier_call_chain+0x3d/0x60
 mlx5_vhca_state_work_handler+0x151/0x200 [mlx5_core]
 process_one_work+0x13f/0x2e0
 worker_thread+0x2bd/0x3c0
 ? rescuer_thread+0x410/0x410
 kthread+0xc4/0xf0
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x2d/0x50
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork_asm+0x11/0x20
 </TASK>

Fixes: bf729988303a ("net/mlx5: Restore mistakenly dropped parts in register devlink flow")
Fixes: c6e77aa9dd82 ("net/mlx5: Register devlink first under devlink lock")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240509112951.590184-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 14 +++++---------
 .../mellanox/mlx5/core/sf/dev/driver.c        | 19 ++++++++-----------
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 331ce47f51a17..6574c145dc1e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1680,6 +1680,8 @@ int mlx5_init_one_light(struct mlx5_core_dev *dev)
 	struct devlink *devlink = priv_to_devlink(dev);
 	int err;
 
+	devl_lock(devlink);
+	devl_register(devlink);
 	dev->state = MLX5_DEVICE_STATE_UP;
 	err = mlx5_function_enable(dev, true, mlx5_tout_ms(dev, FW_PRE_INIT_TIMEOUT));
 	if (err) {
@@ -1693,27 +1695,21 @@ int mlx5_init_one_light(struct mlx5_core_dev *dev)
 		goto query_hca_caps_err;
 	}
 
-	devl_lock(devlink);
-	devl_register(devlink);
-
 	err = mlx5_devlink_params_register(priv_to_devlink(dev));
 	if (err) {
 		mlx5_core_warn(dev, "mlx5_devlink_param_reg err = %d\n", err);
-		goto params_reg_err;
+		goto query_hca_caps_err;
 	}
 
 	devl_unlock(devlink);
 	return 0;
 
-params_reg_err:
-	devl_unregister(devlink);
-	devl_unlock(devlink);
 query_hca_caps_err:
-	devl_unregister(devlink);
-	devl_unlock(devlink);
 	mlx5_function_disable(dev, true);
 out:
 	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
+	devl_unregister(devlink);
+	devl_unlock(devlink);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index 7ebe712808275..b2986175d9afe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -60,6 +60,13 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 		goto remap_err;
 	}
 
+	/* Peer devlink logic expects to work on unregistered devlink instance. */
+	err = mlx5_core_peer_devlink_set(sf_dev, devlink);
+	if (err) {
+		mlx5_core_warn(mdev, "mlx5_core_peer_devlink_set err=%d\n", err);
+		goto peer_devlink_set_err;
+	}
+
 	if (MLX5_ESWITCH_MANAGER(sf_dev->parent_mdev))
 		err = mlx5_init_one_light(mdev);
 	else
@@ -69,20 +76,10 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 		goto init_one_err;
 	}
 
-	err = mlx5_core_peer_devlink_set(sf_dev, devlink);
-	if (err) {
-		mlx5_core_warn(mdev, "mlx5_core_peer_devlink_set err=%d\n", err);
-		goto peer_devlink_set_err;
-	}
-
 	return 0;
 
-peer_devlink_set_err:
-	if (mlx5_dev_is_lightweight(sf_dev->mdev))
-		mlx5_uninit_one_light(sf_dev->mdev);
-	else
-		mlx5_uninit_one(sf_dev->mdev);
 init_one_err:
+peer_devlink_set_err:
 	iounmap(mdev->iseg);
 remap_err:
 	mlx5_mdev_uninit(mdev);
-- 
2.43.0



