Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483C61F76B5;
	Tue,  3 Dec 2024 16:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241643; cv=none; b=MXSGgC4pHkduoSBf5AKmTz/NuNRovqrxz4wxu/kk4vBUNJFAYTB5J8iU5vUW2uxHaybUX8AigXKyYXAQ5eitkn1Kt1WHfZMq6ozx3285rQ3rI7oTKy+0erafRTsW9H12CQkCQSCo7zcV3pYuiwE+Sy1CynjaWIsp5hRSLMwyfxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241643; c=relaxed/simple;
	bh=VnFVG5KMrV8BWhDTHjSA+HxORKy8IHTlUbNw2ABaHG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfphOubr3LWNvngg2YnvOB5xzbs0r1Xas2cPVxmnmHSS+j/ji0A4tFiOFwU/uzB0GMJAZglPALSEATcbUXv1LPV1fhWQn8tVpHbiqWEoqvQIUvgDHsam49XiAAMEKWAGd06552Q2UlnxuSmQxut2BGJhQb3Amph8+0I6KNtFfsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VV/RHSrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VV/RHSrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A611AC4CECF;
	Tue,  3 Dec 2024 16:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241643;
	bh=VnFVG5KMrV8BWhDTHjSA+HxORKy8IHTlUbNw2ABaHG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VV/RHSrprmwN0DpWh0yErsYNz5R2Ypo9nyi1K/fJQZ5AFKYXUzbVbF8KM9m5LBVYa
	 f+1aKY84IIWw7+y3++MdnJ5McVY3cfr56cDXFT0LvADwuKPbnaUAjgcIkiew3m7o71
	 oi9NAJt9ly1Q7dv6XIFUfZBu8/xHvOBtMdgFe9xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 446/826] RDMA/mlx5: Move events notifier registration to be after device registration
Date: Tue,  3 Dec 2024 15:42:53 +0100
Message-ID: <20241203144801.158281812@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit ede132a5cf559f3ab35a4c28bac4f4a6c20334d8 ]

Move pkey change work initialization and cleanup from device resources
stage to notifier stage, since this is the stage which handles this work
events.

Fix a race between the device deregistration and pkey change work by moving
MLX5_IB_STAGE_DEVICE_NOTIFIER to be after MLX5_IB_STAGE_IB_REG in order to
ensure that the notifier is deregistered before the device during cleanup.
Which ensures there are no works that are being executed after the
device has already unregistered which can cause the panic below.

BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 1 PID: 630071 Comm: kworker/1:2 Kdump: loaded Tainted: G W OE --------- --- 5.14.0-162.6.1.el9_1.x86_64 #1
Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090008 02/27/2023
Workqueue: events pkey_change_handler [mlx5_ib]
RIP: 0010:setup_qp+0x38/0x1f0 [mlx5_ib]
Code: ee 41 54 45 31 e4 55 89 f5 53 48 89 fb 48 83 ec 20 8b 77 08 65 48 8b 04 25 28 00 00 00 48 89 44 24 18 48 8b 07 48 8d 4c 24 16 <4c> 8b 38 49 8b 87 80 0b 00 00 4c 89 ff 48 8b 80 08 05 00 00 8b 40
RSP: 0018:ffffbcc54068be20 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff954054494128 RCX: ffffbcc54068be36
RDX: ffff954004934000 RSI: 0000000000000001 RDI: ffff954054494128
RBP: 0000000000000023 R08: ffff954001be2c20 R09: 0000000000000001
R10: ffff954001be2c20 R11: ffff9540260133c0 R12: 0000000000000000
R13: 0000000000000023 R14: 0000000000000000 R15: ffff9540ffcb0905
FS: 0000000000000000(0000) GS:ffff9540ffc80000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000010625c001 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
mlx5_ib_gsi_pkey_change+0x20/0x40 [mlx5_ib]
process_one_work+0x1e8/0x3c0
worker_thread+0x50/0x3b0
? rescuer_thread+0x380/0x380
kthread+0x149/0x170
? set_kthread_struct+0x50/0x50
ret_from_fork+0x22/0x30
Modules linked in: rdma_ucm(OE) rdma_cm(OE) iw_cm(OE) ib_ipoib(OE) ib_cm(OE) ib_umad(OE) mlx5_ib(OE) mlx5_fwctl(OE) fwctl(OE) ib_uverbs(OE) mlx5_core(OE) mlxdevm(OE) ib_core(OE) mlx_compat(OE) psample mlxfw(OE) tls knem(OE) netconsole nfsv3 nfs_acl nfs lockd grace fscache netfs qrtr rfkill sunrpc intel_rapl_msr intel_rapl_common rapl hv_balloon hv_utils i2c_piix4 pcspkr joydev fuse ext4 mbcache jbd2 sr_mod sd_mod cdrom t10_pi sg ata_generic pci_hyperv pci_hyperv_intf hyperv_drm drm_shmem_helper drm_kms_helper hv_storvsc syscopyarea hv_netvsc sysfillrect sysimgblt hid_hyperv fb_sys_fops scsi_transport_fc hyperv_keyboard drm ata_piix crct10dif_pclmul crc32_pclmul crc32c_intel libata ghash_clmulni_intel hv_vmbus serio_raw [last unloaded: ib_core]
CR2: 0000000000000000
---[ end trace f6f8be4eae12f7bc ]---

Fixes: 7722f47e71e5 ("IB/mlx5: Create GSI transmission QPs when P_Key table is changed")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/d271ceeff0c08431b3cbbbb3e2d416f09b6d1621.1731496944.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 40 +++++++++++++---------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +-
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5fef9288699c6..ac20ab3bbabf4 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2997,7 +2997,6 @@ int mlx5_ib_dev_res_srq_init(struct mlx5_ib_dev *dev)
 static int mlx5_ib_dev_res_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_ib_resources *devr = &dev->devr;
-	int port;
 	int ret;
 
 	if (!MLX5_CAP_GEN(dev->mdev, xrc))
@@ -3013,10 +3012,6 @@ static int mlx5_ib_dev_res_init(struct mlx5_ib_dev *dev)
 		return ret;
 	}
 
-	for (port = 0; port < ARRAY_SIZE(devr->ports); ++port)
-		INIT_WORK(&devr->ports[port].pkey_change_work,
-			  pkey_change_handler);
-
 	mutex_init(&devr->cq_lock);
 	mutex_init(&devr->srq_lock);
 
@@ -3026,16 +3021,6 @@ static int mlx5_ib_dev_res_init(struct mlx5_ib_dev *dev)
 static void mlx5_ib_dev_res_cleanup(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_ib_resources *devr = &dev->devr;
-	int port;
-
-	/*
-	 * Make sure no change P_Key work items are still executing.
-	 *
-	 * At this stage, the mlx5_ib_event should be unregistered
-	 * and it ensures that no new works are added.
-	 */
-	for (port = 0; port < ARRAY_SIZE(devr->ports); ++port)
-		cancel_work_sync(&devr->ports[port].pkey_change_work);
 
 	/* After s0/s1 init, they are not unset during the device lifetime. */
 	if (devr->s1) {
@@ -4471,6 +4456,13 @@ static void mlx5_ib_stage_delay_drop_cleanup(struct mlx5_ib_dev *dev)
 
 static int mlx5_ib_stage_dev_notifier_init(struct mlx5_ib_dev *dev)
 {
+	struct mlx5_ib_resources *devr = &dev->devr;
+	int port;
+
+	for (port = 0; port < ARRAY_SIZE(devr->ports); ++port)
+		INIT_WORK(&devr->ports[port].pkey_change_work,
+			  pkey_change_handler);
+
 	dev->mdev_events.notifier_call = mlx5_ib_event;
 	mlx5_notifier_register(dev->mdev, &dev->mdev_events);
 
@@ -4481,8 +4473,14 @@ static int mlx5_ib_stage_dev_notifier_init(struct mlx5_ib_dev *dev)
 
 static void mlx5_ib_stage_dev_notifier_cleanup(struct mlx5_ib_dev *dev)
 {
+	struct mlx5_ib_resources *devr = &dev->devr;
+	int port;
+
 	mlx5r_macsec_event_unregister(dev);
 	mlx5_notifier_unregister(dev->mdev, &dev->mdev_events);
+
+	for (port = 0; port < ARRAY_SIZE(devr->ports); ++port)
+		cancel_work_sync(&devr->ports[port].pkey_change_work);
 }
 
 void mlx5_ib_data_direct_bind(struct mlx5_ib_dev *ibdev,
@@ -4572,9 +4570,6 @@ static const struct mlx5_ib_profile pf_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_RESOURCES,
 		     mlx5_ib_dev_res_init,
 		     mlx5_ib_dev_res_cleanup),
-	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_NOTIFIER,
-		     mlx5_ib_stage_dev_notifier_init,
-		     mlx5_ib_stage_dev_notifier_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_ODP,
 		     mlx5_ib_odp_init_one,
 		     mlx5_ib_odp_cleanup_one),
@@ -4599,6 +4594,9 @@ static const struct mlx5_ib_profile pf_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_IB_REG,
 		     mlx5_ib_stage_ib_reg_init,
 		     mlx5_ib_stage_ib_reg_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_NOTIFIER,
+		     mlx5_ib_stage_dev_notifier_init,
+		     mlx5_ib_stage_dev_notifier_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_POST_IB_REG_UMR,
 		     mlx5_ib_stage_post_ib_reg_umr_init,
 		     NULL),
@@ -4635,9 +4633,6 @@ const struct mlx5_ib_profile raw_eth_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_RESOURCES,
 		     mlx5_ib_dev_res_init,
 		     mlx5_ib_dev_res_cleanup),
-	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_NOTIFIER,
-		     mlx5_ib_stage_dev_notifier_init,
-		     mlx5_ib_stage_dev_notifier_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_COUNTERS,
 		     mlx5_ib_counters_init,
 		     mlx5_ib_counters_cleanup),
@@ -4659,6 +4654,9 @@ const struct mlx5_ib_profile raw_eth_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_IB_REG,
 		     mlx5_ib_stage_ib_reg_init,
 		     mlx5_ib_stage_ib_reg_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_NOTIFIER,
+		     mlx5_ib_stage_dev_notifier_init,
+		     mlx5_ib_stage_dev_notifier_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_POST_IB_REG_UMR,
 		     mlx5_ib_stage_post_ib_reg_umr_init,
 		     NULL),
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 23fd72f7f63df..29bde64ea1eac 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -972,7 +972,6 @@ enum mlx5_ib_stages {
 	MLX5_IB_STAGE_QP,
 	MLX5_IB_STAGE_SRQ,
 	MLX5_IB_STAGE_DEVICE_RESOURCES,
-	MLX5_IB_STAGE_DEVICE_NOTIFIER,
 	MLX5_IB_STAGE_ODP,
 	MLX5_IB_STAGE_COUNTERS,
 	MLX5_IB_STAGE_CONG_DEBUGFS,
@@ -981,6 +980,7 @@ enum mlx5_ib_stages {
 	MLX5_IB_STAGE_PRE_IB_REG_UMR,
 	MLX5_IB_STAGE_WHITELIST_UID,
 	MLX5_IB_STAGE_IB_REG,
+	MLX5_IB_STAGE_DEVICE_NOTIFIER,
 	MLX5_IB_STAGE_POST_IB_REG_UMR,
 	MLX5_IB_STAGE_DELAY_DROP,
 	MLX5_IB_STAGE_RESTRACK,
-- 
2.43.0



