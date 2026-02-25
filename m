Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352AC248F54;
	Wed, 25 Feb 2026 01:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983337; cv=none; b=Iz5V7nB2Xe+bz2qhdQadLzAt8GyLLzvpVrz1ED+4yg+cU6RaU/mGLLTltHdtcqH/PLA52EajtsJAhBDbAqRZrfY3ROMvmegxyJtkphYAsM6km6Bm8xkNuDDl24uUFgFWoNOTB9zugXdQ4+gtZvwON3ta9NZd/qbLu8VNMakBofA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983337; c=relaxed/simple;
	bh=5S8BQhTjxNffYnv+hinFV9n94guIPq2bA+11VNZcF9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eojUC6SkXMfzJnIKLl1OxjV+7eUsaejyU4dHmPpaFQKmWjBPBSxBDonve+qDhU/qJIktBW4kUgvzD5VtgKqhRo92QpKf+WaCOnS78QNR4jqtQ2u54DmOjkoHCjba6JJkMcjCGeYTdIksWU1Maj/6VXQBDWNWIYbitZWSyYtXxkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CromKN6A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CromKN6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E12C19424;
	Wed, 25 Feb 2026 01:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983336;
	bh=5S8BQhTjxNffYnv+hinFV9n94guIPq2bA+11VNZcF9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CromKN6AvBY7MsBCUQNj29kTah3VL9ztUkxXcNhEIH4UvIYyjdDfHZPpPq9dN8gwl
	 V3x8OICWB3B3ZKkii3Gz/2HAMzdNMqKEif8Uy8V+eVS58ulN+T7ErfjLYq78lCEQ3D
	 2xZDpyTrNbTHKIyZ3DSPCIoaDkLUPgTPdLL85Amo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 466/781] RDMA/mlx5: Fix UMR hang in LAG error state unload
Date: Tue, 24 Feb 2026 17:19:35 -0800
Message-ID: <20260225012411.251979118@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 8d515d266125e..3485a9a3d75e0 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2878,7 +2878,6 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 		container_of(_work, struct mlx5_ib_event_work, work);
 	struct mlx5_ib_dev *ibdev;
 	struct ib_event ibev;
-	bool fatal = false;
 
 	if (work->is_slave) {
 		ibdev = mlx5_ib_get_ibdev_from_mpi(work->mpi);
@@ -2889,12 +2888,6 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
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
@@ -2916,8 +2909,6 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 	if (ibdev->ib_active)
 		ib_dispatch_event(&ibev);
 
-	if (fatal)
-		ibdev->ib_active = false;
 out:
 	kfree(work);
 }
@@ -2961,6 +2952,66 @@ static int mlx5_ib_event_slave_port(struct notifier_block *nb,
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
@@ -4811,6 +4862,9 @@ static const struct mlx5_ib_profile pf_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_WHITELIST_UID,
 		     mlx5_ib_devx_init,
 		     mlx5_ib_devx_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_SYS_ERROR_NOTIFIER,
+		     mlx5_ib_stage_sys_error_notifier_init,
+		     mlx5_ib_stage_sys_error_notifier_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_IB_REG,
 		     mlx5_ib_stage_ib_reg_init,
 		     mlx5_ib_stage_ib_reg_cleanup),
@@ -4868,6 +4922,9 @@ const struct mlx5_ib_profile raw_eth_profile = {
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
index 09d82d5f95e35..fbccb0362590b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1007,6 +1007,7 @@ enum mlx5_ib_stages {
 	MLX5_IB_STAGE_BFREG,
 	MLX5_IB_STAGE_PRE_IB_REG_UMR,
 	MLX5_IB_STAGE_WHITELIST_UID,
+	MLX5_IB_STAGE_SYS_ERROR_NOTIFIER,
 	MLX5_IB_STAGE_IB_REG,
 	MLX5_IB_STAGE_DEVICE_NOTIFIER,
 	MLX5_IB_STAGE_POST_IB_REG_UMR,
@@ -1165,6 +1166,7 @@ struct mlx5_ib_dev {
 	/* protect accessing data_direct_dev */
 	struct mutex			data_direct_lock;
 	struct notifier_block		mdev_events;
+	struct notifier_block		sys_error_events;
 	struct notifier_block           lag_events;
 	int				num_ports;
 	/* serialize update of capability mask
-- 
2.51.0



