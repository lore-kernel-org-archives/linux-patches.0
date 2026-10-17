Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297753B4404;
	Sat, 17 Oct 2026 17:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257542; cv=none; b=JNn5c1HkWZHXVl7JI263tslNQLH8+DyOJ9ZRwd4nWwyAtUswQZc+K+ilDiF0m83AweqTrIETFiJTZidBr0ItNw4AZxjZJVXv7Rr4dFjA5YD02OXiqHxwHCMaJy/TgxRTpmj3G0fu23haTwx2CibbGk5E2HZww7dWDbRSXKvBCHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257542; c=relaxed/simple;
	bh=h97RooPaEakDmG8Qn5+nQt4ECXSVsFI5+UK2ru/FQs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsHuNlljHTePVmMQ7F7lu1mVIffAtVisvG8hAvJHZgZgHset6T2PeZrZQHFOySEJA+AyC3BoN6viGOZVsejvhz9j3LzEv0wOtbR4Gj0OBViZTo66sL8wsHby3J7tHz/iNl0KtmHaZ+1ZH+eUclFMPUnhhCPV6qtfOWINMKU3++M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMK6E9h5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMK6E9h5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55721F000C4;
	Sat, 17 Oct 2026 17:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257541;
	bh=mFaIqVvBp40Afr1HrCCvOw9PhT7rNQgE0D/WJPHvt08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMK6E9h5HBV79NJTnepJHpzsN2czmr/MxLGO5l4ge33NhItYdJQHRBCcjQ0x+026B
	 PkiT5e1X0VyGkFSsB2PIsRx1rS6JL1fMDvhOJTCuBMpn30d6pJT2iOwcoShavKeKHn
	 oQSuugZFIDQGnw8BZ9NJklCrEEoOPeJXbRFWvmII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0592/1674] net/mlx5e: Dont store mlx5e_priv in mlx5e_dev devlink priv
Date: Sat, 17 Oct 2026 17:47:44 +0200
Message-ID: <20261017160446.278020684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit 123eda2e5b1638e298e3a66bb1e64a8da92de5e1 ]

mlx5e_priv is an unstable structure that can be memset(0) if profile
attaching fails, mlx5e_priv in mlx5e_dev devlink private is used to
reference the netdev and mdev associated with that struct. Instead,
store netdev directly into mlx5e_dev and get mdev from the containing
mlx5_adev aux device structure.

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

BUG: kernel NULL pointer dereference, address: 0000000000000520
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 3 UID: 0 PID: 521 Comm: devlink Not tainted 6.18.0-rc5+ #117 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40 04/01/2014
RIP: 0010:mlx5e_remove+0x68/0x130
RSP: 0018:ffffc900034838f0 EFLAGS: 00010246
RAX: ffff88810283c380 RBX: ffff888101874400 RCX: ffffffff826ffc45
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff888102d789c0 R08: ffff8881007137f0 R09: ffff888100264e10
R10: ffffc90003483898 R11: ffffc900034838a0 R12: ffff888100d261a0
R13: ffff888100d261a0 R14: ffff8881018749a0 R15: ffff888101874400
FS:  00007f8565fea740(0000) GS:ffff88856a759000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000520 CR3: 000000010b11a004 CR4: 0000000000370ef0
Call Trace:
 <TASK>
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

Fixes: ee75f1fc44dd ("net/mlx5e: Create separate devlink instance for ethernet auxiliary device")
Fixes: c4d7eb57687f ("net/mxl5e: Add change profile method")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://patch.msgid.link/20260108212657.25090-3-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Assisted-by: LLM
[ Backport to 6.6.y: Derive mdev from the auxiliary device in the
  older remove path. The auxiliary device only binds after successful
  netdev registration, and the target uplink profile-switch paths
  retain that registration, so remove performs one unregister without
  upstream's NETREG_REGISTERED conditional. Use that hardware owner
  when clearing the uplink pointer if profile rollback clears priv.
  Apply after the pending 6.6.y backport of 3d5918477f94 (net/mlx5e:
  Fix netif state handling), which makes probe registration-failure
  unwind release resources even before netif_device_attach(). Patch 2
  of this series ("net/mlx5e: Pass netdev to mlx5e_destroy_netdev instead
  of priv") uses netdev-based destruction. ]
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 22 +++++++++++--------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 455d02b6500d0..ee671e16f344c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -945,7 +945,7 @@ struct mlx5e_priv {
 };
 
 struct mlx5e_dev {
-	struct mlx5e_priv *priv;
+	struct net_device *netdev;
 	struct devlink_port dl_port;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d04f959a41382..a296a73771c07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5996,8 +5996,8 @@ static int mlx5e_resume(struct auxiliary_device *adev)
 {
 	struct mlx5_adev *edev = container_of(adev, struct mlx5_adev, adev);
 	struct mlx5e_dev *mlx5e_dev = auxiliary_get_drvdata(adev);
-	struct mlx5e_priv *priv = mlx5e_dev->priv;
-	struct net_device *netdev = priv->netdev;
+	struct mlx5e_priv *priv = netdev_priv(mlx5e_dev->netdev);
+	struct net_device *netdev = mlx5e_dev->netdev;
 	struct mlx5_core_dev *mdev = edev->mdev;
 	int err;
 
@@ -6020,10 +6020,11 @@ static int mlx5e_resume(struct auxiliary_device *adev)
 static int mlx5e_suspend_common(struct auxiliary_device *adev,
 				bool pre_netdev_reg)
 {
+	struct mlx5_adev *edev = container_of(adev, struct mlx5_adev, adev);
 	struct mlx5e_dev *mlx5e_dev = auxiliary_get_drvdata(adev);
-	struct mlx5e_priv *priv = mlx5e_dev->priv;
-	struct net_device *netdev = priv->netdev;
-	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_priv *priv = netdev_priv(mlx5e_dev->netdev);
+	struct net_device *netdev = mlx5e_dev->netdev;
+	struct mlx5_core_dev *mdev = edev->mdev;
 
 	if (!pre_netdev_reg && !netif_device_present(netdev)) {
 		if (test_bit(MLX5E_STATE_DESTROYING, &priv->state))
@@ -6070,11 +6071,11 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 		goto err_devlink_port_unregister;
 	}
 	SET_NETDEV_DEVLINK_PORT(netdev, &mlx5e_dev->dl_port);
+	mlx5e_dev->netdev = netdev;
 
 	mlx5e_build_nic_netdev(netdev);
 
 	priv = netdev_priv(netdev);
-	mlx5e_dev->priv = priv;
 
 	priv->profile = profile;
 	priv->ppriv = NULL;
@@ -6125,13 +6126,16 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 
 static void mlx5e_remove(struct auxiliary_device *adev)
 {
+	struct mlx5_adev *edev = container_of(adev, struct mlx5_adev, adev);
 	struct mlx5e_dev *mlx5e_dev = auxiliary_get_drvdata(adev);
-	struct mlx5e_priv *priv = mlx5e_dev->priv;
+	struct net_device *netdev = mlx5e_dev->netdev;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = edev->mdev;
 	pm_message_t state = {};
 
-	mlx5_core_uplink_netdev_set(priv->mdev, NULL);
+	mlx5_core_uplink_netdev_set(mdev, NULL);
 	mlx5e_dcbnl_delete_app(priv);
-	unregister_netdev(priv->netdev);
+	unregister_netdev(netdev);
 	mlx5e_suspend(adev, state);
 	/* Avoid cleanup if profile rollback failed. */
 	if (priv->profile)
-- 
2.53.0



