Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416853A901E;
	Wed, 21 Jan 2026 18:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020032; cv=none; b=mOiQ4YhnInBwd2FHvYdviUp6OCF0JntlHUoxFGlu0stMMJNEtDvgUm7l1RM+wU1TKGIwWYTCqp2UZQEkZC1+aIhUPWXDt4AixQo97q+XS5WKUVCWEAFik3bvZ5/GbF0ELwKuxS2FZDC0T1qEZYf2NV5uPMsfHnNp5/vExp14snY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020032; c=relaxed/simple;
	bh=NjgU90UxxGDxHGOQu+sFQ6OPpjU1HUSJA63Rnz7YUsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Etmb+teGcllpF5moO7/vemZMN6y1x5yuuunCeISzc3qhyC8068PHgpzeZNjTSq+UPNcnXvmO38W/afO/U/MwrAxma73mGiH0ifo4hfxx8UKZglQWXMbVhKK8pshUpIziEO13I9TUEKJ0G5+Kk+9I482Gqq03rHfWh90DRbakg8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IfOCgwP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IfOCgwP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C1EC16AAE;
	Wed, 21 Jan 2026 18:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020032;
	bh=NjgU90UxxGDxHGOQu+sFQ6OPpjU1HUSJA63Rnz7YUsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfOCgwP2lloadCv4ly0YSbkKUWefGUVDstWPw7rVvCpP58ZWym0vd6Umw2dP7IK6o
	 ykMmw/DlVn0hO0NarTtfzHUkjsV2Wtx7yxy4iOas67Gxyn1uIDbFSszmqO4omvheBr
	 l5uwcZfmvf36MG24nbW3wq82tQTA4lsch4SdwyPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 040/198] net/mlx5e: Dont store mlx5e_priv in mlx5e_dev devlink priv
Date: Wed, 21 Jan 2026 19:14:28 +0100
Message-ID: <20260121181419.992282434@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 20 ++++++++++---------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index cfdbeb21b61cf..bc1b343f89a25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -963,7 +963,7 @@ struct mlx5e_priv {
 };
 
 struct mlx5e_dev {
-	struct mlx5e_priv *priv;
+	struct net_device *netdev;
 	struct devlink_port dl_port;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3850c267dfc02..dcf1cd3488709 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6635,8 +6635,8 @@ static int _mlx5e_resume(struct auxiliary_device *adev)
 {
 	struct mlx5_adev *edev = container_of(adev, struct mlx5_adev, adev);
 	struct mlx5e_dev *mlx5e_dev = auxiliary_get_drvdata(adev);
-	struct mlx5e_priv *priv = mlx5e_dev->priv;
-	struct net_device *netdev = priv->netdev;
+	struct mlx5e_priv *priv = netdev_priv(mlx5e_dev->netdev);
+	struct net_device *netdev = mlx5e_dev->netdev;
 	struct mlx5_core_dev *mdev = edev->mdev;
 	struct mlx5_core_dev *pos, *to;
 	int err, i;
@@ -6682,10 +6682,11 @@ static int mlx5e_resume(struct auxiliary_device *adev)
 
 static int _mlx5e_suspend(struct auxiliary_device *adev, bool pre_netdev_reg)
 {
+	struct mlx5_adev *edev = container_of(adev, struct mlx5_adev, adev);
 	struct mlx5e_dev *mlx5e_dev = auxiliary_get_drvdata(adev);
-	struct mlx5e_priv *priv = mlx5e_dev->priv;
-	struct net_device *netdev = priv->netdev;
-	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_priv *priv = netdev_priv(mlx5e_dev->netdev);
+	struct net_device *netdev = mlx5e_dev->netdev;
+	struct mlx5_core_dev *mdev = edev->mdev;
 	struct mlx5_core_dev *pos;
 	int i;
 
@@ -6746,11 +6747,11 @@ static int _mlx5e_probe(struct auxiliary_device *adev)
 		goto err_devlink_port_unregister;
 	}
 	SET_NETDEV_DEVLINK_PORT(netdev, &mlx5e_dev->dl_port);
+	mlx5e_dev->netdev = netdev;
 
 	mlx5e_build_nic_netdev(netdev);
 
 	priv = netdev_priv(netdev);
-	mlx5e_dev->priv = priv;
 
 	priv->profile = profile;
 	priv->ppriv = NULL;
@@ -6813,7 +6814,8 @@ static void _mlx5e_remove(struct auxiliary_device *adev)
 {
 	struct mlx5_adev *edev = container_of(adev, struct mlx5_adev, adev);
 	struct mlx5e_dev *mlx5e_dev = auxiliary_get_drvdata(adev);
-	struct mlx5e_priv *priv = mlx5e_dev->priv;
+	struct net_device *netdev = mlx5e_dev->netdev;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = edev->mdev;
 
 	mlx5_core_uplink_netdev_set(mdev, NULL);
@@ -6822,8 +6824,8 @@ static void _mlx5e_remove(struct auxiliary_device *adev)
 	 * if it's from legacy mode. If from switchdev mode, it
 	 * is already unregistered before changing to NIC profile.
 	 */
-	if (priv->netdev->reg_state == NETREG_REGISTERED) {
-		unregister_netdev(priv->netdev);
+	if (netdev->reg_state == NETREG_REGISTERED) {
+		unregister_netdev(netdev);
 		_mlx5e_suspend(adev, false);
 	} else {
 		struct mlx5_core_dev *pos;
-- 
2.51.0



