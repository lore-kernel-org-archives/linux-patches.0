Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3192AF07;
	Mon, 28 Oct 2024 06:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098234; cv=none; b=TG7Lk+AgeVZg+S3cHKYPP24I9So8KZ35L/XUQFXzFFfPCzcfcpUSO8uqx7IeSTu+GNDP2fOwUO5/sx+fFLLAAiszF7BWbZx1hyAKngu0XrX7ybWCKs4n2nb8pHumfn4nM1Hql67mbPXMc2Bld1hpXvuEEbuKdJsZe86vMSZl4z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098234; c=relaxed/simple;
	bh=RLCoMqVIuOQnBBwRMTDxG/H5xtXQBerbxqIpMQ+WPMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4/HZ4oNhtLcTmVnA0SvA3iRlNyNBJ+fep2eh3qghNT2KR4BO+wKu+5ppJ5qTNpuQ/+zYzTv/w1Md4R8WctTL2nVXMU862d+1oGzo126nI/DfPzMGazPAn8YSWS04EqUqKDIS0NmwnRo0Kj9M5M6ROyg8UkBel29yJJyETNE9fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5mSLQbk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5mSLQbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40E4C4CEC7;
	Mon, 28 Oct 2024 06:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098233;
	bh=RLCoMqVIuOQnBBwRMTDxG/H5xtXQBerbxqIpMQ+WPMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5mSLQbke5to19lqlAn3i71viRX7gU9UrYcymDQG8OhOCXQZ9o7s/5oCP0mZgIRdq
	 bqz7qSHeOHdAyIQrUkGgzT6tZM2WdGOw/owgPzbA363JSaRfNBZlBx0HcKw77ILHQ+
	 psjQ7FmkRyaj4meIs9moRQAvEv1SI9Qflw58zL6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 101/261] net/mlx5e: Dont call cleanup on profile rollback failure
Date: Mon, 28 Oct 2024 07:24:03 +0100
Message-ID: <20241028062314.560807749@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 4dbc1d1a9f39c3711ad2a40addca04d07d9ab5d0 ]

When profile rollback fails in mlx5e_netdev_change_profile, the netdev
profile var is left set to NULL. Avoid a crash when unloading the driver
by not calling profile->cleanup in such a case.

This was encountered while testing, with the original trigger that
the wq rescuer thread creation got interrupted (presumably due to
Ctrl+C-ing modprobe), which gets converted to ENOMEM (-12) by
mlx5e_priv_init, the profile rollback also fails for the same reason
(signal still active) so the profile is left as NULL, leading to a crash
later in _mlx5e_remove.

 [  732.473932] mlx5_core 0000:08:00.1: E-Switch: Unload vfs: mode(OFFLOADS), nvfs(2), necvfs(0), active vports(2)
 [  734.525513] workqueue: Failed to create a rescuer kthread for wq "mlx5e": -EINTR
 [  734.557372] mlx5_core 0000:08:00.1: mlx5e_netdev_init_profile:6235:(pid 6086): mlx5e_priv_init failed, err=-12
 [  734.559187] mlx5_core 0000:08:00.1 eth3: mlx5e_netdev_change_profile: new profile init failed, -12
 [  734.560153] workqueue: Failed to create a rescuer kthread for wq "mlx5e": -EINTR
 [  734.589378] mlx5_core 0000:08:00.1: mlx5e_netdev_init_profile:6235:(pid 6086): mlx5e_priv_init failed, err=-12
 [  734.591136] mlx5_core 0000:08:00.1 eth3: mlx5e_netdev_change_profile: failed to rollback to orig profile, -12
 [  745.537492] BUG: kernel NULL pointer dereference, address: 0000000000000008
 [  745.538222] #PF: supervisor read access in kernel mode
<snipped>
 [  745.551290] Call Trace:
 [  745.551590]  <TASK>
 [  745.551866]  ? __die+0x20/0x60
 [  745.552218]  ? page_fault_oops+0x150/0x400
 [  745.555307]  ? exc_page_fault+0x79/0x240
 [  745.555729]  ? asm_exc_page_fault+0x22/0x30
 [  745.556166]  ? mlx5e_remove+0x6b/0xb0 [mlx5_core]
 [  745.556698]  auxiliary_bus_remove+0x18/0x30
 [  745.557134]  device_release_driver_internal+0x1df/0x240
 [  745.557654]  bus_remove_device+0xd7/0x140
 [  745.558075]  device_del+0x15b/0x3c0
 [  745.558456]  mlx5_rescan_drivers_locked.part.0+0xb1/0x2f0 [mlx5_core]
 [  745.559112]  mlx5_unregister_device+0x34/0x50 [mlx5_core]
 [  745.559686]  mlx5_uninit_one+0x46/0xf0 [mlx5_core]
 [  745.560203]  remove_one+0x4e/0xd0 [mlx5_core]
 [  745.560694]  pci_device_remove+0x39/0xa0
 [  745.561112]  device_release_driver_internal+0x1df/0x240
 [  745.561631]  driver_detach+0x47/0x90
 [  745.562022]  bus_remove_driver+0x84/0x100
 [  745.562444]  pci_unregister_driver+0x3b/0x90
 [  745.562890]  mlx5_cleanup+0xc/0x1b [mlx5_core]
 [  745.563415]  __x64_sys_delete_module+0x14d/0x2f0
 [  745.563886]  ? kmem_cache_free+0x1b0/0x460
 [  745.564313]  ? lockdep_hardirqs_on_prepare+0xe2/0x190
 [  745.564825]  do_syscall_64+0x6d/0x140
 [  745.565223]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
 [  745.565725] RIP: 0033:0x7f1579b1288b

Fixes: 3ef14e463f6e ("net/mlx5e: Separate between netdev objects and mlx5e profiles initialization")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 16b67c457b605..3e11c1c6d4f69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6508,7 +6508,9 @@ static void _mlx5e_remove(struct auxiliary_device *adev)
 	mlx5e_dcbnl_delete_app(priv);
 	unregister_netdev(priv->netdev);
 	_mlx5e_suspend(adev, false);
-	priv->profile->cleanup(priv);
+	/* Avoid cleanup if profile rollback failed. */
+	if (priv->profile)
+		priv->profile->cleanup(priv);
 	mlx5e_destroy_netdev(priv);
 	mlx5e_devlink_port_unregister(mlx5e_dev);
 	mlx5e_destroy_devlink(mlx5e_dev);
-- 
2.43.0



