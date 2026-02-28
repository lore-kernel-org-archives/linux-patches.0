Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A587343D64
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301847; cv=none; b=VDqQYYYgcFdsqNMute/1lr6sHbiP7d80MgPQPzJZiFDoSQKMczpS9g31lOhmlMlxcIVG9YEWjMzDl7IBFoXDGPYrQx42POiNPq6q0DzddlqGNMRrG4H1mUZnSrS188kpBwFUzbTro1w5CI8/jp4oHXffB2JMQaz3it1QJuKExRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301847; c=relaxed/simple;
	bh=Ixf2Z+VrfCvyCuiN+NvIvY/CnOv3WVn6B46TG0Pomuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3N9+RIaWhENCUjVuXsJ2ni9OuR/G0MSjCcfyYDw7HUXNl9ayWh73tkAEdTog9P9cNPOln42K3pU16MJt/g5L8efc6UdyoS5UqArXJ+UxjtB0ykDjMgWcFBzYq00AE4VF8lacSyp+0es8qgTw95uq9O0ipjt9nWvM/uG1OHD05E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uP7NxISB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uP7NxISB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEAAC116D0;
	Sat, 28 Feb 2026 18:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301847;
	bh=Ixf2Z+VrfCvyCuiN+NvIvY/CnOv3WVn6B46TG0Pomuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uP7NxISB7qZZ5Sp4B1eVvb1Pp6/Fesx7g0DPf5+YWccpuyonn8yQ3ecYAQ3ufGozM
	 XDHMbnbHLkCo3rxA4OREzOLDMzRfo1OIV5hxXGzG9VW9LIPLEXkJHfly8Nuu3/stIq
	 bNYW2x072Zbx+KP+uMBSnDEOdrTMlg+BzIsuNkb114i4PzB8AikjOOroYW8KG+0oyp
	 GfkqhvYYK0YOy6xUB6vWZN0o6e8mxzMBI4NXCGukmM4gUXg1r4VXsRRc4HQ4BtRHY5
	 Li4yzrsZRqv6Z1Rf4rnMzC31/+Mc4G1WK/evAmN2e4WMnTe03ahuJQpNmcolCV7wc/
	 l8XAmigqNDi3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chiara Meiohas <cmeiohas@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 267/385] RDMA/mlx5: Fix UMR hang in LAG error state unload
Date: Sat, 28 Feb 2026 12:58:09 -0500
Message-ID: <20260228180011.1568201-267-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chiara Meiohas <cmeiohas@nvidia.com>

[ Upstream commit ebc2164a4cd4314503f1a0c8e7aaf76d7e5fa211 ]

During firmware reset in LAG mode, a race condition causes the driver
to hang indefinitely while waiting for UMR completion during device
unload. See [1].

In LAG mode the bond device is only registered on the master, so it
never sees sys_error events from the slave.
During firmware reset this causes UMR waits to hang forever on unload
as the slave is dead but the master hasn't entered error state yet, so
UMR posts succeed but completions never arrive.

Fix this by adding a sys_error notifier that gets registered before
MLX5_IB_STAGE_IB_REG and stays alive until after ib_unregister_device().
This ensures error events reach the bond device throughout teardown.

[1]
Call Trace:
 __schedule+0x2bd/0x760
 schedule+0x37/0xa0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.isra.6+0x2b5/0x4a0
 __mlx5_ib_dereg_mr+0x606/0x870 [mlx5_ib]
 ? __xa_erase+0x4a/0xa0
 ? _cond_resched+0x15/0x30
 ? wait_for_completion+0x31/0x100
 ib_dereg_mr_user+0x48/0xc0 [ib_core]
 ? rdmacg_uncharge_hierarchy+0xa0/0x100
 destroy_hw_idr_uobject+0x20/0x50 [ib_uverbs]
 uverbs_destroy_uobject+0x37/0x150 [ib_uverbs]
 __uverbs_cleanup_ufile+0xda/0x140 [ib_uverbs]
 uverbs_destroy_ufile_hw+0x3a/0xf0 [ib_uverbs]
 ib_uverbs_remove_one+0xc3/0x140 [ib_uverbs]
 remove_client_context+0x8b/0xd0 [ib_core]
 disable_device+0x8c/0x130 [ib_core]
 __ib_unregister_device+0x10d/0x180 [ib_core]
 ib_unregister_device+0x21/0x30 [ib_core]
 __mlx5_ib_remove+0x1e4/0x1f0 [mlx5_ib]
 auxiliary_bus_remove+0x1e/0x30
 device_release_driver_internal+0x103/0x1f0
 bus_remove_device+0xf7/0x170
 device_del+0x181/0x410
 mlx5_rescan_drivers_locked.part.10+0xa9/0x1d0 [mlx5_core]
 mlx5_disable_lag+0x253/0x260 [mlx5_core]
 mlx5_lag_disable_change+0x89/0xc0 [mlx5_core]
 mlx5_eswitch_disable+0x67/0xa0 [mlx5_core]
 mlx5_unload+0x15/0xd0 [mlx5_core]
 mlx5_unload_one+0x71/0xc0 [mlx5_core]
 mlx5_sync_reset_reload_work+0x83/0x100 [mlx5_core]
 process_one_work+0x1a7/0x360
 worker_thread+0x30/0x390
 ? create_worker+0x1a0/0x1a0
 kthread+0x116/0x130
 ? kthread_flush_work_fn+0x10/0x10
 ret_from_fork+0x22/0x40

Fixes: ede132a5cf55 ("RDMA/mlx5: Move events notifier registration to be after device registration")
Signed-off-by: Chiara Meiohas <cmeiohas@nvidia.com>
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20260113-umr-hand-lag-fix-v1-1-3dc476e00cd9@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 75 ++++++++++++++++++++++++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +
 2 files changed, 68 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f3e58797705d7..10bda03eb3388 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2826,7 +2826,6 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 		container_of(_work, struct mlx5_ib_event_work, work);
 	struct mlx5_ib_dev *ibdev;
 	struct ib_event ibev;
-	bool fatal = false;
 
 	if (work->is_slave) {
 		ibdev = mlx5_ib_get_ibdev_from_mpi(work->mpi);
@@ -2837,12 +2836,6 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 	}
 
 	switch (work->event) {
-	case MLX5_DEV_EVENT_SYS_ERROR:
-		ibev.event = IB_EVENT_DEVICE_FATAL;
-		mlx5_ib_handle_internal_error(ibdev);
-		ibev.element.port_num  = (u8)(unsigned long)work->param;
-		fatal = true;
-		break;
 	case MLX5_EVENT_TYPE_PORT_CHANGE:
 		if (handle_port_change(ibdev, work->param, &ibev))
 			goto out;
@@ -2864,8 +2857,6 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 	if (ibdev->ib_active)
 		ib_dispatch_event(&ibev);
 
-	if (fatal)
-		ibdev->ib_active = false;
 out:
 	kfree(work);
 }
@@ -2909,6 +2900,66 @@ static int mlx5_ib_event_slave_port(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
+static void mlx5_ib_handle_sys_error_event(struct work_struct *_work)
+{
+	struct mlx5_ib_event_work *work =
+		container_of(_work, struct mlx5_ib_event_work, work);
+	struct mlx5_ib_dev *ibdev = work->dev;
+	struct ib_event ibev;
+
+	ibev.event = IB_EVENT_DEVICE_FATAL;
+	mlx5_ib_handle_internal_error(ibdev);
+	ibev.element.port_num = (u8)(unsigned long)work->param;
+	ibev.device = &ibdev->ib_dev;
+
+	if (!rdma_is_port_valid(&ibdev->ib_dev, ibev.element.port_num)) {
+		mlx5_ib_warn(ibdev, "warning: event on port %d\n",  ibev.element.port_num);
+		goto out;
+	}
+
+	if (ibdev->ib_active)
+		ib_dispatch_event(&ibev);
+
+	ibdev->ib_active = false;
+out:
+	kfree(work);
+}
+
+static int mlx5_ib_sys_error_event(struct notifier_block *nb,
+				   unsigned long event, void *param)
+{
+	struct mlx5_ib_event_work *work;
+
+	if (event != MLX5_DEV_EVENT_SYS_ERROR)
+		return NOTIFY_DONE;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work)
+		return NOTIFY_DONE;
+
+	INIT_WORK(&work->work, mlx5_ib_handle_sys_error_event);
+	work->dev = container_of(nb, struct mlx5_ib_dev, sys_error_events);
+	work->is_slave = false;
+	work->param = param;
+	work->event = event;
+
+	queue_work(mlx5_ib_event_wq, &work->work);
+
+	return NOTIFY_OK;
+}
+
+static int mlx5_ib_stage_sys_error_notifier_init(struct mlx5_ib_dev *dev)
+{
+	dev->sys_error_events.notifier_call = mlx5_ib_sys_error_event;
+	mlx5_notifier_register(dev->mdev, &dev->sys_error_events);
+	return 0;
+}
+
+static void mlx5_ib_stage_sys_error_notifier_cleanup(struct mlx5_ib_dev *dev)
+{
+	mlx5_notifier_unregister(dev->mdev, &dev->sys_error_events);
+}
+
 static int mlx5_ib_get_plane_num(struct mlx5_core_dev *mdev, u8 *num_plane)
 {
 	struct mlx5_hca_vport_context vport_ctx;
@@ -4682,6 +4733,9 @@ static const struct mlx5_ib_profile pf_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_WHITELIST_UID,
 		     mlx5_ib_devx_init,
 		     mlx5_ib_devx_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_SYS_ERROR_NOTIFIER,
+		     mlx5_ib_stage_sys_error_notifier_init,
+		     mlx5_ib_stage_sys_error_notifier_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_IB_REG,
 		     mlx5_ib_stage_ib_reg_init,
 		     mlx5_ib_stage_ib_reg_cleanup),
@@ -4742,6 +4796,9 @@ const struct mlx5_ib_profile raw_eth_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_WHITELIST_UID,
 		     mlx5_ib_devx_init,
 		     mlx5_ib_devx_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_SYS_ERROR_NOTIFIER,
+		     mlx5_ib_stage_sys_error_notifier_init,
+		     mlx5_ib_stage_sys_error_notifier_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_IB_REG,
 		     mlx5_ib_stage_ib_reg_init,
 		     mlx5_ib_stage_ib_reg_cleanup),
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index f49cb588a856d..3135519f1cfdf 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -979,6 +979,7 @@ enum mlx5_ib_stages {
 	MLX5_IB_STAGE_BFREG,
 	MLX5_IB_STAGE_PRE_IB_REG_UMR,
 	MLX5_IB_STAGE_WHITELIST_UID,
+	MLX5_IB_STAGE_SYS_ERROR_NOTIFIER,
 	MLX5_IB_STAGE_IB_REG,
 	MLX5_IB_STAGE_DEVICE_NOTIFIER,
 	MLX5_IB_STAGE_POST_IB_REG_UMR,
@@ -1137,6 +1138,7 @@ struct mlx5_ib_dev {
 	/* protect accessing data_direct_dev */
 	struct mutex			data_direct_lock;
 	struct notifier_block		mdev_events;
+	struct notifier_block		sys_error_events;
 	struct notifier_block           lag_events;
 	int				num_ports;
 	/* serialize update of capability mask
-- 
2.51.0

