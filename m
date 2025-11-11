Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD75E2FE059;
	Tue, 11 Nov 2025 01:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825131; cv=none; b=mbRI0vDjXAnSCAnTcrxayCfetxe7ziA059JippKzxMz5fS21xlJplruTCKKcySz+ew062GS3egdxIuLc3h73/MvB1W/9pm91aQd06UbXMZTIk+mBVzVMOW27xcmJlQDSUwvJxGcAi1rNhLgD2Ko2sgQxwg7iyj0eX+0Y2+6zqeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825131; c=relaxed/simple;
	bh=RscwkTDg2rS2NPXDOAL1M/qBPFXsJPkmWGhWcjS9Wb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTK75B102QBfdv4yUUa2VqmJDfhjsGXpu2+aGN9pkvEPnlCzM/jyibCiY9VTv9xU8r4Bfc4LKfkPPxXyfccOlX8056q2DwLh2VpUVaoBPHtCmCQUaqmbu9tZIAoK5W7AWEAq89KXXDlMVh0RvJFtMK8VYkTgjRtHnF5r9HlK8Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jznpju6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jznpju6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450ACC4CEF5;
	Tue, 11 Nov 2025 01:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825131;
	bh=RscwkTDg2rS2NPXDOAL1M/qBPFXsJPkmWGhWcjS9Wb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jznpju6f/jK6+Fa8MVjfYg0391BWrYtF3YbgQOeRbPq6xg9ahSuuIO6Id6vInZqcL
	 lIn18i+wONiUCroNA07ejkBoUjjldh13a4VdZzPvIqXWJRKKcdf1tXOTT1AyqWL2KA
	 ijW/nVBgJlCSuAp0vdEiW0VNsmIwfrClPKzIOpqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 675/849] net/mlx5e: Prevent entering switchdev mode with inconsistent netns
Date: Tue, 11 Nov 2025 09:44:05 +0900
Message-ID: <20251111004552.737239040@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 06fdc45f16c392dc3394c67e7c17ae63935715d3 ]

When a PF enters switchdev mode, its netdevice becomes the uplink
representor but remains in its current network namespace. All other
representors (VFs, SFs) are created in the netns of the devlink
instance.

If the PF's netns has been moved and differs from the devlink's netns,
enabling switchdev mode would create a state where the OVS control
plane (ovs-vsctl) cannot manage the switch because the PF uplink
representor and the other representors are split across different
namespaces.

To prevent this inconsistent configuration, block the request to enter
switchdev mode if the PF netdevice's netns does not match the netns of
its devlink instance.

As part of this change, the PF's netns is first marked as immutable.
This prevents race conditions where the netns could be changed after
the check is performed but before the mode transition is complete, and
it aligns the PF's behavior with that of the final uplink representor.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1759094723-843774-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f358e8fe432cf..59a1a3a5fc8b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3739,6 +3739,29 @@ void mlx5_eswitch_unblock_mode(struct mlx5_core_dev *dev)
 	up_write(&esw->mode_lock);
 }
 
+/* Returns false only when uplink netdev exists and its netns is different from
+ * devlink's netns. True for all others so entering switchdev mode is allowed.
+ */
+static bool mlx5_devlink_netdev_netns_immutable_set(struct devlink *devlink,
+						    bool immutable)
+{
+	struct mlx5_core_dev *mdev = devlink_priv(devlink);
+	struct net_device *netdev;
+	bool ret;
+
+	netdev = mlx5_uplink_netdev_get(mdev);
+	if (!netdev)
+		return true;
+
+	rtnl_lock();
+	netdev->netns_immutable = immutable;
+	ret = net_eq(dev_net(netdev), devlink_net(devlink));
+	rtnl_unlock();
+
+	mlx5_uplink_netdev_put(mdev, netdev);
+	return ret;
+}
+
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 				  struct netlink_ext_ack *extack)
 {
@@ -3781,6 +3804,14 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	esw->eswitch_operation_in_progress = true;
 	up_write(&esw->mode_lock);
 
+	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV &&
+	    !mlx5_devlink_netdev_netns_immutable_set(devlink, true)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can't change E-Switch mode to switchdev when netdev net namespace has diverged from the devlink's.");
+		err = -EINVAL;
+		goto skip;
+	}
+
 	if (mode == DEVLINK_ESWITCH_MODE_LEGACY)
 		esw->dev->priv.flags |= MLX5_PRIV_FLAGS_SWITCH_LEGACY;
 	mlx5_eswitch_disable_locked(esw);
@@ -3799,6 +3830,8 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	}
 
 skip:
+	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV && err)
+		mlx5_devlink_netdev_netns_immutable_set(devlink, false);
 	down_write(&esw->mode_lock);
 	esw->eswitch_operation_in_progress = false;
 unlock:
-- 
2.51.0



