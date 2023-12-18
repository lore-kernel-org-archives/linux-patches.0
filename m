Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFA74237E;
	Mon, 18 Dec 2023 14:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KBjjXL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFB0C433CB;
	Mon, 18 Dec 2023 14:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908002;
	bh=cOi7AblVtvqC3udD0cZyQaiUKYucwcnAm0SU9spYivs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KBjjXL0oIjwTQkUYsBY9Y7Ks0fqTSALXud1cvew7GF6qS3GSMIqt+MEFmMC6pa4J
	 LWRvNY7fpBBQOgbsi8LjfsBzur+aeunqXyfzbWSuWp1SCzWeHv8zf8azI5Wsb9wNxd
	 2+t/rBk0zy/Wm8/aK+wRRVwJHZHYZGuz8hvu4lpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Li <gavinl@nvidia.com>,
	Gavi Teitz <gavi@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/166] net/mlx5e: Check netdev pointer before checking its net ns
Date: Mon, 18 Dec 2023 14:49:44 +0100
Message-ID: <20231218135105.751161323@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Li <gavinl@nvidia.com>

[ Upstream commit 7aaf975238c47b710fcc4eca0da1e7902a53abe2 ]

Previously, when comparing the net namespaces, the case where the netdev
doesn't exist wasn't taken into account, and therefore can cause a crash.
In such a case, the comparing function should return false, as there is no
netdev->net to compare the devlink->net to.

Furthermore, this will result in an attempt to enter switchdev mode
without a netdev to fail, and which is the desired result as there is no
meaning in switchdev mode without a net device.

Fixes: 662404b24a4c ("net/mlx5e: Block entering switchdev mode with ns inconsistency")
Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/eswitch_offloads.c        | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index bf78eeca401be..bb8bcb448ae90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3653,14 +3653,18 @@ static int esw_inline_mode_to_devlink(u8 mlx5_mode, u8 *mode)
 
 static bool esw_offloads_devlink_ns_eq_netdev_ns(struct devlink *devlink)
 {
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	struct net *devl_net, *netdev_net;
-	struct mlx5_eswitch *esw;
-
-	esw = mlx5_devlink_eswitch_nocheck_get(devlink);
-	netdev_net = dev_net(esw->dev->mlx5e_res.uplink_netdev);
-	devl_net = devlink_net(devlink);
+	bool ret = false;
 
-	return net_eq(devl_net, netdev_net);
+	mutex_lock(&dev->mlx5e_res.uplink_netdev_lock);
+	if (dev->mlx5e_res.uplink_netdev) {
+		netdev_net = dev_net(dev->mlx5e_res.uplink_netdev);
+		devl_net = devlink_net(devlink);
+		ret = net_eq(devl_net, netdev_net);
+	}
+	mutex_unlock(&dev->mlx5e_res.uplink_netdev_lock);
+	return ret;
 }
 
 int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev)
-- 
2.43.0



