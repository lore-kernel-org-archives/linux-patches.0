Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3360191F66;
	Mon, 22 Sep 2025 19:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569689; cv=none; b=UKDcML820+lUGiJqVbmzPcmUPLspeSSAkPOQNf5FZbBC+l80HRUXjhLArQAApmUwS2Ozh2F4tPTE+TNzZ7sEyz9mewfDl6lIxXSb+FyzUEWCb2atxcut3e5j3fAruIngTqnL2X1huGzlZSaCg5uOh+YwePYzMt1OBoIlZxrApWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569689; c=relaxed/simple;
	bh=UN2Z2W9fxv0BbEcJvcWX7jPkBxPuWGgaVKxjcshWlYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MF4R1/4VgsZgVgc+lXOorVnbHVY+GVHBHJtVkWA3nBBJ6OKwEKhU7fYlp1wbkO+k0E7YIoRtSsFw/GFWbtrNn7yCaDThqEuCsG4SRAbe3ly4J0hWMylB9K21O8hJDNhDmvL9EAaS2NlNElvhD1YFAmLLXRUHvl3WlP9svwpSMZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDQTPKJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDQTPKJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299A9C4CEF0;
	Mon, 22 Sep 2025 19:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569688;
	bh=UN2Z2W9fxv0BbEcJvcWX7jPkBxPuWGgaVKxjcshWlYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDQTPKJJQDQjFaQ/ZNi9XY95q45Dn4M2ngtvlezCx4HedjfV97V2xu0Ir3lYZLLhH
	 0mt8xG6gCLvio7yMkcLSusP8l/LVFukQ0zx6TA39ChueB/0QfgXpp5oaxkugkmpd9s
	 589cZT393CGpHXAeCFxz/Gf72ypzMNiVEy2sg4tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 17/70] net/mlx5e: Consider aggregated port speed during rate configuration
Date: Mon, 22 Sep 2025 21:29:17 +0200
Message-ID: <20250922192405.002938669@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 8d88e198dcaf700e33c2a4c796af9434652c56e7 ]

When LAG is configured, functions (PF,VF,SF) can utilize the maximum
aggregated link speed for transmission. Currently the aggregated link
speed is not considered.

Hence, improve it to use the aggregated link speed by referring to the
physical port's upper bonding device when LAG is configured.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 6b4be64fd9fe ("net/mlx5e: Harden uplink netdev access against device unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c | 84 ++++++++++++++++---
 1 file changed, 72 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index cc0f2be21a265..34f7d814859db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
 
 #include "eswitch.h"
+#include "lib/mlx5.h"
 #include "esw/qos.h"
 #include "en/port.h"
 #define CREATE_TRACE_POINTS
@@ -712,6 +713,70 @@ int mlx5_esw_qos_set_vport_rate(struct mlx5_eswitch *esw, struct mlx5_vport *vpo
 	return err;
 }
 
+static u32 mlx5_esw_qos_lag_link_speed_get_locked(struct mlx5_core_dev *mdev)
+{
+	struct ethtool_link_ksettings lksettings;
+	struct net_device *slave, *master;
+	u32 speed = SPEED_UNKNOWN;
+
+	/* Lock ensures a stable reference to master and slave netdevice
+	 * while port speed of master is queried.
+	 */
+	ASSERT_RTNL();
+
+	slave = mlx5_uplink_netdev_get(mdev);
+	if (!slave)
+		goto out;
+
+	master = netdev_master_upper_dev_get(slave);
+	if (master && !__ethtool_get_link_ksettings(master, &lksettings))
+		speed = lksettings.base.speed;
+
+out:
+	return speed;
+}
+
+static int mlx5_esw_qos_max_link_speed_get(struct mlx5_core_dev *mdev, u32 *link_speed_max,
+					   bool hold_rtnl_lock, struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (!mlx5_lag_is_active(mdev))
+		goto skip_lag;
+
+	if (hold_rtnl_lock)
+		rtnl_lock();
+
+	*link_speed_max = mlx5_esw_qos_lag_link_speed_get_locked(mdev);
+
+	if (hold_rtnl_lock)
+		rtnl_unlock();
+
+	if (*link_speed_max != (u32)SPEED_UNKNOWN)
+		return 0;
+
+skip_lag:
+	err = mlx5_port_max_linkspeed(mdev, link_speed_max);
+	if (err)
+		NL_SET_ERR_MSG_MOD(extack, "Failed to get link maximum speed");
+
+	return err;
+}
+
+static int mlx5_esw_qos_link_speed_verify(struct mlx5_core_dev *mdev,
+					  const char *name, u32 link_speed_max,
+					  u64 value, struct netlink_ext_ack *extack)
+{
+	if (value > link_speed_max) {
+		pr_err("%s rate value %lluMbps exceed link maximum speed %u.\n",
+		       name, value, link_speed_max);
+		NL_SET_ERR_MSG_MOD(extack, "TX rate value exceed link maximum speed");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int mlx5_esw_qos_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num, u32 rate_mbps)
 {
 	u32 ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
@@ -755,12 +820,6 @@ static int esw_qos_devlink_rate_to_mbps(struct mlx5_core_dev *mdev, const char *
 	u64 value;
 	int err;
 
-	err = mlx5_port_max_linkspeed(mdev, &link_speed_max);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "Failed to get link maximum speed");
-		return err;
-	}
-
 	value = div_u64_rem(*rate, MLX5_LINKSPEED_UNIT, &remainder);
 	if (remainder) {
 		pr_err("%s rate value %lluBps not in link speed units of 1Mbps.\n",
@@ -769,12 +828,13 @@ static int esw_qos_devlink_rate_to_mbps(struct mlx5_core_dev *mdev, const char *
 		return -EINVAL;
 	}
 
-	if (value > link_speed_max) {
-		pr_err("%s rate value %lluMbps exceed link maximum speed %u.\n",
-		       name, value, link_speed_max);
-		NL_SET_ERR_MSG_MOD(extack, "TX rate value exceed link maximum speed");
-		return -EINVAL;
-	}
+	err = mlx5_esw_qos_max_link_speed_get(mdev, &link_speed_max, true, extack);
+	if (err)
+		return err;
+
+	err = mlx5_esw_qos_link_speed_verify(mdev, name, link_speed_max, value, extack);
+	if (err)
+		return err;
 
 	*rate = value;
 	return 0;
-- 
2.51.0



