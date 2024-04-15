Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D9775818;
	Mon, 15 Apr 2024 14:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191259; cv=none; b=Y3NMvBQzRpMP6XtQwzqXDiqEw+KmN7f0WeoOvWWA++I7OQD/Exo4BX57Fs7J50ous/6YaBYYMbPqubvppuB4+pVkr+xFEAk4IFsTt9PE/x8j3KXn5Iz7a6WmUNgcDpzu7vxcJm99xubjjYQVXzvCGiq+A7GTwblPVDwZf9q+x94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191259; c=relaxed/simple;
	bh=TGLOy6hz4YtOLU3f+DRQuGHBQn2jdNJm1ndPAlvRwEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnPE/DGlL3Vstth++2ck3FbQ3vsjKGFG/N4pkt/HSNRo4yTrBwxlus2JgHJWdkKhuTzzCmaNOQXYnt3UCvC1rX6b/J6Ojt9WeHZR7yuNN1eR8o2vet+7apSDvGdRRixCEJrdJyJSdJOfoiPSX5MkInsUEh74CAPiG35oppOFvJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rdwl0LOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rdwl0LOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CDBC113CC;
	Mon, 15 Apr 2024 14:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191258;
	bh=TGLOy6hz4YtOLU3f+DRQuGHBQn2jdNJm1ndPAlvRwEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rdwl0LOQtglO6NbFPXknoBe+SbTt446QBd2pELAo/DIHaQSL22SfrKnL9YeI0jeQT
	 Ngco7hsPgP5I87NOB0wpzYMrqWf0jgXLhW+PAtg8ZSWSLKvPY9ckneXTpf19vkRP8u
	 9QrClYcWsEVzdGRW1U7/2x85n3gCrkZAP3MUDJlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 083/172] net/mlx5: Register devlink first under devlink lock
Date: Mon, 15 Apr 2024 16:19:42 +0200
Message-ID: <20240415142002.919012929@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit c6e77aa9dd82bc18a89bf49418f8f7e961cfccc8 ]

In case device is having a non fatal FW error during probe, the
driver will report the error to user via devlink. This will trigger
a WARN_ON, since mlx5 is calling devlink_register() last.
In order to avoid the WARN_ON[1], change mlx5 to invoke devl_register()
first under devlink lock.

[1]
WARNING: CPU: 5 PID: 227 at net/devlink/health.c:483 devlink_recover_notify.constprop.0+0xb8/0xc0
CPU: 5 PID: 227 Comm: kworker/u16:3 Not tainted 6.4.0-rc5_for_upstream_min_debug_2023_06_12_12_38 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
Workqueue: mlx5_health0000:08:00.0 mlx5_fw_reporter_err_work [mlx5_core]
RIP: 0010:devlink_recover_notify.constprop.0+0xb8/0xc0
Call Trace:
 <TASK>
 ? __warn+0x79/0x120
 ? devlink_recover_notify.constprop.0+0xb8/0xc0
 ? report_bug+0x17c/0x190
 ? handle_bug+0x3c/0x60
 ? exc_invalid_op+0x14/0x70
 ? asm_exc_invalid_op+0x16/0x20
 ? devlink_recover_notify.constprop.0+0xb8/0xc0
 devlink_health_report+0x4a/0x1c0
 mlx5_fw_reporter_err_work+0xa4/0xd0 [mlx5_core]
 process_one_work+0x1bb/0x3c0
 ? process_one_work+0x3c0/0x3c0
 worker_thread+0x4d/0x3c0
 ? process_one_work+0x3c0/0x3c0
 kthread+0xc6/0xf0
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30
 </TASK>

Fixes: cf530217408e ("devlink: Notify users when objects are accessible")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240409190820.227554-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 37 ++++++++++---------
 .../mellanox/mlx5/core/sf/dev/driver.c        |  1 -
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index bccf6e53556c6..131a836c127e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1480,6 +1480,14 @@ int mlx5_init_one_devl_locked(struct mlx5_core_dev *dev)
 	if (err)
 		goto err_register;
 
+	err = mlx5_crdump_enable(dev);
+	if (err)
+		mlx5_core_err(dev, "mlx5_crdump_enable failed with error code %d\n", err);
+
+	err = mlx5_hwmon_dev_register(dev);
+	if (err)
+		mlx5_core_err(dev, "mlx5_hwmon_dev_register failed with error code %d\n", err);
+
 	mutex_unlock(&dev->intf_state_mutex);
 	return 0;
 
@@ -1505,7 +1513,10 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 	int err;
 
 	devl_lock(devlink);
+	devl_register(devlink);
 	err = mlx5_init_one_devl_locked(dev);
+	if (err)
+		devl_unregister(devlink);
 	devl_unlock(devlink);
 	return err;
 }
@@ -1517,6 +1528,8 @@ void mlx5_uninit_one(struct mlx5_core_dev *dev)
 	devl_lock(devlink);
 	mutex_lock(&dev->intf_state_mutex);
 
+	mlx5_hwmon_dev_unregister(dev);
+	mlx5_crdump_disable(dev);
 	mlx5_unregister_device(dev);
 
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
@@ -1534,6 +1547,7 @@ void mlx5_uninit_one(struct mlx5_core_dev *dev)
 	mlx5_function_teardown(dev, true);
 out:
 	mutex_unlock(&dev->intf_state_mutex);
+	devl_unregister(devlink);
 	devl_unlock(devlink);
 }
 
@@ -1680,16 +1694,20 @@ int mlx5_init_one_light(struct mlx5_core_dev *dev)
 	}
 
 	devl_lock(devlink);
+	devl_register(devlink);
+
 	err = mlx5_devlink_params_register(priv_to_devlink(dev));
-	devl_unlock(devlink);
 	if (err) {
 		mlx5_core_warn(dev, "mlx5_devlink_param_reg err = %d\n", err);
 		goto query_hca_caps_err;
 	}
 
+	devl_unlock(devlink);
 	return 0;
 
 query_hca_caps_err:
+	devl_unregister(devlink);
+	devl_unlock(devlink);
 	mlx5_function_disable(dev, true);
 out:
 	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
@@ -1702,6 +1720,7 @@ void mlx5_uninit_one_light(struct mlx5_core_dev *dev)
 
 	devl_lock(devlink);
 	mlx5_devlink_params_unregister(priv_to_devlink(dev));
+	devl_unregister(devlink);
 	devl_unlock(devlink);
 	if (dev->state != MLX5_DEVICE_STATE_UP)
 		return;
@@ -1943,16 +1962,7 @@ static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_init_one;
 	}
 
-	err = mlx5_crdump_enable(dev);
-	if (err)
-		dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code %d\n", err);
-
-	err = mlx5_hwmon_dev_register(dev);
-	if (err)
-		mlx5_core_err(dev, "mlx5_hwmon_dev_register failed with error code %d\n", err);
-
 	pci_save_state(pdev);
-	devlink_register(devlink);
 	return 0;
 
 err_init_one:
@@ -1973,16 +1983,9 @@ static void remove_one(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(dev);
 
 	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
-	/* mlx5_drain_fw_reset() and mlx5_drain_health_wq() are using
-	 * devlink notify APIs.
-	 * Hence, we must drain them before unregistering the devlink.
-	 */
 	mlx5_drain_fw_reset(dev);
 	mlx5_drain_health_wq(dev);
-	devlink_unregister(devlink);
 	mlx5_sriov_disable(pdev, false);
-	mlx5_hwmon_dev_unregister(dev);
-	mlx5_crdump_disable(dev);
 	mlx5_uninit_one(dev);
 	mlx5_pci_close(dev);
 	mlx5_mdev_uninit(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index bc863e1f062e6..e3bf8c7e4baa6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -101,7 +101,6 @@ static void mlx5_sf_dev_remove(struct auxiliary_device *adev)
 	devlink = priv_to_devlink(mdev);
 	set_bit(MLX5_BREAK_FW_WAIT, &mdev->intf_state);
 	mlx5_drain_health_wq(mdev);
-	devlink_unregister(devlink);
 	if (mlx5_dev_is_lightweight(mdev))
 		mlx5_uninit_one_light(mdev);
 	else
-- 
2.43.0



