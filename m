Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DDE17E90E;
	Mon, 27 May 2024 19:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836949; cv=none; b=YAb/JE5Kuxl5zXzdeCUFRvlsh75A2CQWnfM3PvJt2sxnCPx05ZNzlD3ki7spg9ku90uq8fBnyXVZwICPkzblJ+L6F872j+KGLs3K8UHcBfazxmNe3xzPPnt4YYjTQAlKxeOge2pWj/jnp5XcbtrHbRHhfpflSzKDkRW+ZVEL1+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836949; c=relaxed/simple;
	bh=7i87ZwrqxQguw1i75nn2WQHRNuumT+MhIuJKIiYXsV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpHOs57oY93ZV4swFVLS7J8KE6bDnBSmkNiWu+7zSiyyp6D+IrAm1iHPtV+8qhfGkd0NyqSbOYxfscMWh4hw2mGNYMc6a8/zQKJEUW+6PgWxRShW0ZPv/N3z+jktD3YUn6iLm7nBnCR4BHXvOOa8fJrICZbdlYn8FfLaE1T3mSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DE8IZoV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DE8IZoV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C1AC2BBFC;
	Mon, 27 May 2024 19:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836948;
	bh=7i87ZwrqxQguw1i75nn2WQHRNuumT+MhIuJKIiYXsV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DE8IZoV/NhO4uuntLMFR8qfeB6pJHsYkUV4N9C3rnO+4Vxs7iW3S0vKG87ZAALnWq
	 nqxvpc8rZS2yjoYg+ZEhqvsXoTkHJopk7XashCUFrbeM8bGvmSRaFXbjZW6GA7hojm
	 hOSr2qp02qckd8bGGBkh+skUsQ37K+pTywLUIrqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 251/427] net/mlx5e: Fix netif state handling
Date: Mon, 27 May 2024 20:54:58 +0200
Message-ID: <20240527185625.968704720@linuxfoundation.org>
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

[ Upstream commit 3d5918477f94e4c2f064567875c475468e264644 ]

mlx5e_suspend cleans resources only if netif_device_present() returns
true. However, mlx5e_resume changes the state of netif, via
mlx5e_nic_enable, only if reg_state == NETREG_REGISTERED.
In the below case, the above leads to NULL-ptr Oops[1] and memory
leaks:

mlx5e_probe
 _mlx5e_resume
  mlx5e_attach_netdev
   mlx5e_nic_enable  <-- netdev not reg, not calling netif_device_attach()
  register_netdev <-- failed for some reason.
ERROR_FLOW:
 _mlx5e_suspend <-- netif_device_present return false, resources aren't freed :(

Hence, clean resources in this case as well.

[1]
BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 0 P4D 0
Oops: 0010 [#1] SMP
CPU: 2 PID: 9345 Comm: test-ovs-ct-gen Not tainted 6.5.0_for_upstream_min_debug_2023_09_05_16_01 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:0x0
Code: Unable to access opcode bytes at0xffffffffffffffd6.
RSP: 0018:ffff888178aaf758 EFLAGS: 00010246
Call Trace:
 <TASK>
 ? __die+0x20/0x60
 ? page_fault_oops+0x14c/0x3c0
 ? exc_page_fault+0x75/0x140
 ? asm_exc_page_fault+0x22/0x30
 notifier_call_chain+0x35/0xb0
 blocking_notifier_call_chain+0x3d/0x60
 mlx5_blocking_notifier_call_chain+0x22/0x30 [mlx5_core]
 mlx5_core_uplink_netdev_event_replay+0x3e/0x60 [mlx5_core]
 mlx5_mdev_netdev_track+0x53/0x60 [mlx5_ib]
 mlx5_ib_roce_init+0xc3/0x340 [mlx5_ib]
 __mlx5_ib_add+0x34/0xd0 [mlx5_ib]
 mlx5r_probe+0xe1/0x210 [mlx5_ib]
 ? auxiliary_match_id+0x6a/0x90
 auxiliary_bus_probe+0x38/0x80
 ? driver_sysfs_add+0x51/0x80
 really_probe+0xc9/0x3e0
 ? driver_probe_device+0x90/0x90
 __driver_probe_device+0x80/0x160
 driver_probe_device+0x1e/0x90
 __device_attach_driver+0x7d/0x100
 bus_for_each_drv+0x80/0xd0
 __device_attach+0xbc/0x1f0
 bus_probe_device+0x86/0xa0
 device_add+0x637/0x840
 __auxiliary_device_add+0x3b/0xa0
 add_adev+0xc9/0x140 [mlx5_core]
 mlx5_rescan_drivers_locked+0x22a/0x310 [mlx5_core]
 mlx5_register_device+0x53/0xa0 [mlx5_core]
 mlx5_init_one_devl_locked+0x5c4/0x9c0 [mlx5_core]
 mlx5_init_one+0x3b/0x60 [mlx5_core]
 probe_one+0x44c/0x730 [mlx5_core]
 local_pci_probe+0x3e/0x90
 pci_device_probe+0xbf/0x210
 ? kernfs_create_link+0x5d/0xa0
 ? sysfs_do_create_link_sd+0x60/0xc0
 really_probe+0xc9/0x3e0
 ? driver_probe_device+0x90/0x90
 __driver_probe_device+0x80/0x160
 driver_probe_device+0x1e/0x90
 __device_attach_driver+0x7d/0x100
 bus_for_each_drv+0x80/0xd0
 __device_attach+0xbc/0x1f0
 pci_bus_add_device+0x54/0x80
 pci_iov_add_virtfn+0x2e6/0x320
 sriov_enable+0x208/0x420
 mlx5_core_sriov_configure+0x9e/0x200 [mlx5_core]
 sriov_numvfs_store+0xae/0x1a0
 kernfs_fop_write_iter+0x10c/0x1a0
 vfs_write+0x291/0x3c0
 ksys_write+0x5f/0xe0
 do_syscall_64+0x3d/0x90
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
 CR2: 0000000000000000
 ---[ end trace 0000000000000000  ]---

Fixes: 2c3b5beec46a ("net/mlx5e: More generic netdev management API")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240509112951.590184-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 319930c04093b..64497b6eebd36 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6058,7 +6058,7 @@ static int mlx5e_resume(struct auxiliary_device *adev)
 	return 0;
 }
 
-static int _mlx5e_suspend(struct auxiliary_device *adev)
+static int _mlx5e_suspend(struct auxiliary_device *adev, bool pre_netdev_reg)
 {
 	struct mlx5e_dev *mlx5e_dev = auxiliary_get_drvdata(adev);
 	struct mlx5e_priv *priv = mlx5e_dev->priv;
@@ -6067,7 +6067,7 @@ static int _mlx5e_suspend(struct auxiliary_device *adev)
 	struct mlx5_core_dev *pos;
 	int i;
 
-	if (!netif_device_present(netdev)) {
+	if (!pre_netdev_reg && !netif_device_present(netdev)) {
 		if (test_bit(MLX5E_STATE_DESTROYING, &priv->state))
 			mlx5_sd_for_each_dev(i, mdev, pos)
 				mlx5e_destroy_mdev_resources(pos);
@@ -6090,7 +6090,7 @@ static int mlx5e_suspend(struct auxiliary_device *adev, pm_message_t state)
 
 	actual_adev = mlx5_sd_get_adev(mdev, adev, edev->idx);
 	if (actual_adev)
-		err = _mlx5e_suspend(actual_adev);
+		err = _mlx5e_suspend(actual_adev, false);
 
 	mlx5_sd_cleanup(mdev);
 	return err;
@@ -6157,7 +6157,7 @@ static int _mlx5e_probe(struct auxiliary_device *adev)
 	return 0;
 
 err_resume:
-	_mlx5e_suspend(adev);
+	_mlx5e_suspend(adev, true);
 err_profile_cleanup:
 	profile->cleanup(priv);
 err_destroy_netdev:
@@ -6197,7 +6197,7 @@ static void _mlx5e_remove(struct auxiliary_device *adev)
 	mlx5_core_uplink_netdev_set(mdev, NULL);
 	mlx5e_dcbnl_delete_app(priv);
 	unregister_netdev(priv->netdev);
-	_mlx5e_suspend(adev);
+	_mlx5e_suspend(adev, false);
 	priv->profile->cleanup(priv);
 	mlx5e_destroy_netdev(priv);
 	mlx5e_devlink_port_unregister(mlx5e_dev);
-- 
2.43.0



