Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E903A7E17;
	Wed, 21 Jan 2026 18:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020035; cv=none; b=eHClad3MZSz695gZfLwI0YkScyo5nB3KFdm7riebAgcXL28Uphgg7vOV/GqroXcO9o7LCSM52UoCQGB1p8wYoQ96SuANXL08MuAfWgoYKRFDWUtkXh5zoizQCObspZa3yn8R5Y6Qyc66WuzD7gByx+gHQ/0Oatw9rrb7OeTU6pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020035; c=relaxed/simple;
	bh=5RHPk/e4K8Y1MUdHAeJIWxAop++HCMpkA6CHLQtTSE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0YTc6DyNXIAubGwRmSx0U0rYRqO/G0H+YNkbVK8TvrZsnXRflRrmrxTk6wosU8oTYbD4sEcajzKmkU51103FgdZtKIaoHill1Gm9TJzmgTfXikJgQNliVHdgVHU41LKr8hfbNV0PPq7B+ytkBHD6ixIjtwDO54NAEYLRz5arh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=La9hk5W5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="La9hk5W5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2890AC4CEF1;
	Wed, 21 Jan 2026 18:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020035;
	bh=5RHPk/e4K8Y1MUdHAeJIWxAop++HCMpkA6CHLQtTSE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=La9hk5W5+j/HmyTHBDaKwwGI57GWBIi3n/2F4BqIhRbCbQ8SVJzr1sZQBho2ffhwr
	 UA3Aw1lOvyB0bG7FrdrSjGI/y205Cux5fhx7FIyxwZwGNM7qmN90Zuf4Y9+4JQZWsL
	 duZGMtBYauAxj7B3CHWHO2AF+ncP8z5ERex6/lSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/198] net/mlx5e: Pass netdev to mlx5e_destroy_netdev instead of priv
Date: Wed, 21 Jan 2026 19:14:29 +0100
Message-ID: <20260121181420.028642839@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit 4ef8512e1427111f7ba92b4a847d181ff0aeec42 ]

mlx5e_priv is an unstable structure that can be memset(0) if profile
attaching fails.

Pass netdev to mlx5e_destroy_netdev() to guarantee it will work on a
valid netdev.

On mlx5e_remove: Check validity of priv->profile, before attempting
to cleanup any resources that might be not there.

This fixes a kernel oops in mlx5e_remove when switchdev mode fails due
to change profile failure.

$ devlink dev eswitch set pci/0000:00:03.0 mode switchdev
Error: mlx5_core: Failed setting eswitch to offloads.
dmesg:
workqueue: Failed to create a rescuer kthread for wq "mlx5e": -EINTR
mlx5_core 0012:03:00.1: mlx5e_netdev_init_profile:6214:(pid 37199): mlx5e_priv_init failed, err=-12
mlx5_core 0012:03:00.1 gpu3rdma1: mlx5e_netdev_change_profile: new profile init failed, -12
workqueue: Failed to create a rescuer kthread for wq "mlx5e": -EINTR
mlx5_core 0012:03:00.1: mlx5e_netdev_init_profile:6214:(pid 37199): mlx5e_priv_init failed, err=-12
mlx5_core 0012:03:00.1 gpu3rdma1: mlx5e_netdev_change_profile: failed to rollback to orig profile, -12

$ devlink dev reload pci/0000:00:03.0 ==> oops

BUG: kernel NULL pointer dereference, address: 0000000000000370
PGD 0 P4D 0
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 15 UID: 0 PID: 520 Comm: devlink Not tainted 6.18.0-rc5+ #115 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40 04/01/2014
RIP: 0010:mlx5e_dcbnl_dscp_app+0x23/0x100
RSP: 0018:ffffc9000083f8b8 EFLAGS: 00010286
RAX: ffff8881126fc380 RBX: ffff8881015ac400 RCX: ffffffff826ffc45
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8881035109c0
RBP: ffff8881035109c0 R08: ffff888101e3e838 R09: ffff888100264e10
R10: ffffc9000083f898 R11: ffffc9000083f8a0 R12: ffff888101b921a0
R13: ffff888101b921a0 R14: ffff8881015ac9a0 R15: ffff8881015ac400
FS:  00007f789a3c8740(0000) GS:ffff88856aa59000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000370 CR3: 000000010b6c0001 CR4: 0000000000370ef0
Call Trace:
 <TASK>
 mlx5e_remove+0x57/0x110
 device_release_driver_internal+0x19c/0x200
 bus_remove_device+0xc6/0x130
 device_del+0x160/0x3d0
 ? devl_param_driverinit_value_get+0x2d/0x90
 mlx5_detach_device+0x89/0xe0
 mlx5_unload_one_devl_locked+0x3a/0x70
 mlx5_devlink_reload_down+0xc8/0x220
 devlink_reload+0x7d/0x260
 devlink_nl_reload_doit+0x45b/0x5a0
 genl_family_rcv_msg_doit+0xe8/0x140

Fixes: c4d7eb57687f ("net/mxl5e: Add change profile method")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260108212657.25090-4-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 15 +++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  |  4 ++--
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index bc1b343f89a25..b34b85539f3b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1238,7 +1238,7 @@ struct net_device *
 mlx5e_create_netdev(struct mlx5_core_dev *mdev, const struct mlx5e_profile *profile);
 int mlx5e_attach_netdev(struct mlx5e_priv *priv);
 void mlx5e_detach_netdev(struct mlx5e_priv *priv);
-void mlx5e_destroy_netdev(struct mlx5e_priv *priv);
+void mlx5e_destroy_netdev(struct net_device *netdev);
 int mlx5e_netdev_change_profile(struct net_device *netdev,
 				struct mlx5_core_dev *mdev,
 				const struct mlx5e_profile *new_profile,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index dcf1cd3488709..3863fb40ff929 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6623,11 +6623,12 @@ void mlx5e_netdev_attach_nic_profile(struct net_device *netdev,
 	mlx5e_netdev_change_profile(netdev, mdev, &mlx5e_nic_profile, NULL);
 }
 
-void mlx5e_destroy_netdev(struct mlx5e_priv *priv)
+void mlx5e_destroy_netdev(struct net_device *netdev)
 {
-	struct net_device *netdev = priv->netdev;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
 
-	mlx5e_priv_cleanup(priv);
+	if (priv->profile)
+		mlx5e_priv_cleanup(priv);
 	free_netdev(netdev);
 }
 
@@ -6784,7 +6785,7 @@ static int _mlx5e_probe(struct auxiliary_device *adev)
 err_profile_cleanup:
 	profile->cleanup(priv);
 err_destroy_netdev:
-	mlx5e_destroy_netdev(priv);
+	mlx5e_destroy_netdev(netdev);
 err_devlink_port_unregister:
 	mlx5e_devlink_port_unregister(mlx5e_dev);
 err_devlink_unregister:
@@ -6819,7 +6820,9 @@ static void _mlx5e_remove(struct auxiliary_device *adev)
 	struct mlx5_core_dev *mdev = edev->mdev;
 
 	mlx5_core_uplink_netdev_set(mdev, NULL);
-	mlx5e_dcbnl_delete_app(priv);
+
+	if (priv->profile)
+		mlx5e_dcbnl_delete_app(priv);
 	/* When unload driver, the netdev is in registered state
 	 * if it's from legacy mode. If from switchdev mode, it
 	 * is already unregistered before changing to NIC profile.
@@ -6840,7 +6843,7 @@ static void _mlx5e_remove(struct auxiliary_device *adev)
 	/* Avoid cleanup if profile rollback failed. */
 	if (priv->profile)
 		priv->profile->cleanup(priv);
-	mlx5e_destroy_netdev(priv);
+	mlx5e_destroy_netdev(netdev);
 	mlx5e_devlink_port_unregister(mlx5e_dev);
 	mlx5e_destroy_devlink(mlx5e_dev);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 2f6aa5e61747c..8b65441246244 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1611,7 +1611,7 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	priv->profile->cleanup(priv);
 
 err_destroy_netdev:
-	mlx5e_destroy_netdev(netdev_priv(netdev));
+	mlx5e_destroy_netdev(netdev);
 	return err;
 }
 
@@ -1666,7 +1666,7 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	mlx5e_rep_vnic_reporter_destroy(priv);
 	mlx5e_detach_netdev(priv);
 	priv->profile->cleanup(priv);
-	mlx5e_destroy_netdev(priv);
+	mlx5e_destroy_netdev(netdev);
 free_ppriv:
 	kvfree(ppriv); /* mlx5e_rep_priv */
 }
-- 
2.51.0



