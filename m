Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC07B4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D854C433D6;
	Mon, 14 Nov 2022 13:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431060;
	bh=ej7Nqw1F+DNL0ek6sRU9Ya9dCWZv8pb2D8ZhkkKj+JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnXJdp9gOML3Tx161BQmsfHigGRCcckxx6uQJBUE0gmFul3lMUqe6by42SsnBOWu4
	 kiMMlvpWzOIfEnSk58jrO2vxrxLoK1nE/9UCbo9by1iUPlXyxGsdIybsAfv0BbdU47
	 l8FR9vuz2cdwvSEyMW3D8XToiqNwdUcCwGATmmAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 086/190] net/mlx5: Bridge, verify LAG state when adding bond to bridge
Date: Mon, 14 Nov 2022 13:45:10 +0100
Message-Id: <20221114124502.442265971@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit 15f8f168952f54d3c86d734dc764f20844e423ac ]

Mlx5 LAG is initialized asynchronously on a workqueue which means that for
a brief moment after setting mlx5 UL representors as lower devices of a
bond netdevice the LAG itself is not fully initialized in the driver. When
adding such bond device to a bridge mlx5 bridge code will not consider it
as offload-capable, skip creating necessary bookkeeping and fail any
further bridge offload-related commands with it (setting VLANs, offloading
FDBs, etc.). In order to make the error explicit during bridge
initialization stage implement the code that detects such condition during
NETDEV_PRECHANGEUPPER event and returns an error.

Fixes: ff9b7521468b ("net/mlx5: Bridge, support LAG")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en/rep/bridge.c        | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 39ef2a2561a3..8099a21e674c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -164,6 +164,36 @@ static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr
 	return err;
 }
 
+static int
+mlx5_esw_bridge_changeupper_validate_netdev(void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct netdev_notifier_changeupper_info *info = ptr;
+	struct net_device *upper = info->upper_dev;
+	struct net_device *lower;
+	struct list_head *iter;
+
+	if (!netif_is_bridge_master(upper) || !netif_is_lag_master(dev))
+		return 0;
+
+	netdev_for_each_lower_dev(dev, lower, iter) {
+		struct mlx5_core_dev *mdev;
+		struct mlx5e_priv *priv;
+
+		if (!mlx5e_eswitch_rep(lower))
+			continue;
+
+		priv = netdev_priv(lower);
+		mdev = priv->mdev;
+		if (!mlx5_lag_is_active(mdev))
+			return -EAGAIN;
+		if (!mlx5_lag_is_shared_fdb(mdev))
+			return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int mlx5_esw_bridge_switchdev_port_event(struct notifier_block *nb,
 						unsigned long event, void *ptr)
 {
@@ -171,6 +201,7 @@ static int mlx5_esw_bridge_switchdev_port_event(struct notifier_block *nb,
 
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
+		err = mlx5_esw_bridge_changeupper_validate_netdev(ptr);
 		break;
 
 	case NETDEV_CHANGEUPPER:
-- 
2.35.1



