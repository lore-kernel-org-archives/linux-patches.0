Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1D61DACBE;
	Mon,  6 Jan 2025 15:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177867; cv=none; b=faftgHE7YnFTNVBJ4RA/Py17G0OGo3GbXCpwfYhir4kuQOifP6ZZJ4xsTYx3KpCaqZZzwJoeL5ew2G3uQbx8B/SMEfB+KGYA9NFKlCHGYRpcCpwL7QW+HYdIHErwL3E2qbTP8hJ3p+0tBjWr+0SPmCyXTcNfiWxAAHkDx0j0oG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177867; c=relaxed/simple;
	bh=ncJciwvPjrOj+w9VJzp8i+vhYBsOnOOVB3I5Opkex+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnXdxfH6HiXOg7DjtP8u9sgZLvpxW/cttcHN3d3+q+nPfUFJUtt10F3AKPWV3ZTjHKNbNQh5AZh2FJsMluqtZtrL2H4d73qYLZypVYsMdK5r2eQZtkbCzoX0CtJvhdkQgOda4feIkyAzUhSiJ40Kb5OsNuDAmmQWtG2RMezfAU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2Bn+Z5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2Bn+Z5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3115CC4CED2;
	Mon,  6 Jan 2025 15:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177867;
	bh=ncJciwvPjrOj+w9VJzp8i+vhYBsOnOOVB3I5Opkex+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2Bn+Z5CxmfI7p9coQsYK6Wn5kNj+RQC/++CxqrOQf44bWYWE49Fx45XrvUAd7vvt
	 0UAXKbbSMnnps+frIMyk8+6j5PjUXAaARCfrK+ICqENSlI2Hza/y3MLuudXRVanL6u
	 jACzM1t757NN7xJlexZK/BkMyR7RwNn35zqD+5xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/156] net/mlx5e: Keep netdev when leave switchdev for devlink set legacy only
Date: Mon,  6 Jan 2025 16:15:38 +0100
Message-ID: <20250106151143.694106818@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 2a4f56fbcc473d8faeb29b73082df39efbe5893c ]

In the cited commit, when changing from switchdev to legacy mode,
uplink representor's netdev is kept, and its profile is replaced with
nic profile, so netdev is detached from old profile, then attach to
new profile.

During profile change, the hardware resources allocated by the old
profile will be cleaned up. However, the cleanup is relying on the
related kernel modules. And they may need to flush themselves first,
which is triggered by netdev events, for example, NETDEV_UNREGISTER.
However, netdev is kept, or netdev_register is called after the
cleanup, which may cause troubles because the resources are still
referred by kernel modules.

The same process applies to all the caes when uplink is leaving
switchdev mode, including devlink eswitch mode set legacy, driver
unload and devlink reload. For the first one, it can be blocked and
returns failure to users, whenever possible. But it's hard for the
others. Besides, the attachment to nic profile is unnecessary as the
netdev will be unregistered anyway for such cases.

So in this patch, the original behavior is kept only for devlink
eswitch set mode legacy. For the others, moves netdev unregistration
before the profile change.

Fixes: 7a9fb35e8c3a ("net/mlx5e: Do not reload ethernet ports when changing eswitch mode")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241220081505.1286093-5-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 19 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 15 +++++++++++++++
 .../mellanox/mlx5/core/eswitch_offloads.c     |  2 ++
 include/linux/mlx5/driver.h                   |  1 +
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c14bef83d84d..62b8a7c1c6b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6510,8 +6510,23 @@ static void _mlx5e_remove(struct auxiliary_device *adev)
 
 	mlx5_core_uplink_netdev_set(mdev, NULL);
 	mlx5e_dcbnl_delete_app(priv);
-	unregister_netdev(priv->netdev);
-	_mlx5e_suspend(adev, false);
+	/* When unload driver, the netdev is in registered state
+	 * if it's from legacy mode. If from switchdev mode, it
+	 * is already unregistered before changing to NIC profile.
+	 */
+	if (priv->netdev->reg_state == NETREG_REGISTERED) {
+		unregister_netdev(priv->netdev);
+		_mlx5e_suspend(adev, false);
+	} else {
+		struct mlx5_core_dev *pos;
+		int i;
+
+		if (test_bit(MLX5E_STATE_DESTROYING, &priv->state))
+			mlx5_sd_for_each_dev(i, mdev, pos)
+				mlx5e_destroy_mdev_resources(pos);
+		else
+			_mlx5e_suspend(adev, true);
+	}
 	/* Avoid cleanup if profile rollback failed. */
 	if (priv->profile)
 		priv->profile->cleanup(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 92094bf60d59..0657d1076535 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1508,6 +1508,21 @@ mlx5e_vport_uplink_rep_unload(struct mlx5e_rep_priv *rpriv)
 
 	priv = netdev_priv(netdev);
 
+	/* This bit is set when using devlink to change eswitch mode from
+	 * switchdev to legacy. As need to keep uplink netdev ifindex, we
+	 * detach uplink representor profile and attach NIC profile only.
+	 * The netdev will be unregistered later when unload NIC auxiliary
+	 * driver for this case.
+	 * We explicitly block devlink eswitch mode change if any IPSec rules
+	 * offloaded, but can't block other cases, such as driver unload
+	 * and devlink reload. We have to unregister netdev before profile
+	 * change for those cases. This is to avoid resource leak because
+	 * the offloaded rules don't have the chance to be unoffloaded before
+	 * cleanup which is triggered by detach uplink representor profile.
+	 */
+	if (!(priv->mdev->priv.flags & MLX5_PRIV_FLAGS_SWITCH_LEGACY))
+		unregister_netdev(netdev);
+
 	mlx5e_netdev_attach_nic_profile(priv);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3cf695425f0a..3950b1d4b3d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3759,6 +3759,8 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	esw->eswitch_operation_in_progress = true;
 	up_write(&esw->mode_lock);
 
+	if (mode == DEVLINK_ESWITCH_MODE_LEGACY)
+		esw->dev->priv.flags |= MLX5_PRIV_FLAGS_SWITCH_LEGACY;
 	mlx5_eswitch_disable_locked(esw);
 	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV) {
 		if (mlx5_devlink_trap_get_num_active(esw->dev)) {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a9fca765b3d1..82c7056e2759 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -555,6 +555,7 @@ enum {
 	 * creation/deletion on drivers rescan. Unset during device attach.
 	 */
 	MLX5_PRIV_FLAGS_DETACH = 1 << 2,
+	MLX5_PRIV_FLAGS_SWITCH_LEGACY = 1 << 3,
 };
 
 struct mlx5_adev {
-- 
2.39.5



