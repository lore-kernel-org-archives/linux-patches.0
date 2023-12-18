Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDF7129ED2;
	Mon, 18 Dec 2023 13:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWSozLUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506E5C433C8;
	Mon, 18 Dec 2023 13:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907988;
	bh=0ewGjKGpm/o/j+0I8k6BhFjefFQOxPV7X9nw0BaXYA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWSozLUbSHSGfbw8vlFBAYtrd97BL1iTo7OajkQjcvOW1qjNUiNFK1+15aKRc7vBZ
	 shvQBJe1LuJv+qznSQo+ZZ5W+6f85OCWpreFrN/sk0FpP82Oy+wzSVkIX6LG1ihmMd
	 +vnZqjg+tPiPBBZCEnl0iwpN2fkBHWFNRWqr/Iyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/166] RDMA/mlx5: Send events from IB driver about device affiliation state
Date: Mon, 18 Dec 2023 14:49:39 +0100
Message-ID: <20231218135105.552145002@linuxfoundation.org>
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

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 0d293714ac32650bfb669ceadf7cc2fad8161401 ]

Send blocking events from IB driver whenever the device is done being
affiliated or if it is removed from an affiliation.

This is useful since now the EN driver can register to those event and
know when a device is affiliated or not.

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Link: https://lore.kernel.org/r/a7491c3e483cfd8d962f5f75b9a25f253043384a.1695296682.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 762a55a54eec ("net/mlx5e: Disable IPsec offload support if not FW steering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c              | 17 +++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c |  6 ++++++
 include/linux/mlx5/device.h                    |  2 ++
 include/linux/mlx5/driver.h                    |  2 ++
 4 files changed, 27 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5d963abb7e609..4c4233b9c8b08 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -24,6 +24,7 @@
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/eswitch.h>
+#include <linux/mlx5/driver.h>
 #include <linux/list.h>
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem_odp.h>
@@ -3175,6 +3176,13 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 
 	lockdep_assert_held(&mlx5_ib_multiport_mutex);
 
+	mlx5_core_mp_event_replay(ibdev->mdev,
+				  MLX5_DRIVER_EVENT_AFFILIATION_REMOVED,
+				  NULL);
+	mlx5_core_mp_event_replay(mpi->mdev,
+				  MLX5_DRIVER_EVENT_AFFILIATION_REMOVED,
+				  NULL);
+
 	mlx5_ib_cleanup_cong_debugfs(ibdev, port_num);
 
 	spin_lock(&port->mp.mpi_lock);
@@ -3226,6 +3234,7 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
 				    struct mlx5_ib_multiport_info *mpi)
 {
 	u32 port_num = mlx5_core_native_port_num(mpi->mdev) - 1;
+	u64 key;
 	int err;
 
 	lockdep_assert_held(&mlx5_ib_multiport_mutex);
@@ -3254,6 +3263,14 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
 
 	mlx5_ib_init_cong_debugfs(ibdev, port_num);
 
+	key = ibdev->ib_dev.index;
+	mlx5_core_mp_event_replay(mpi->mdev,
+				  MLX5_DRIVER_EVENT_AFFILIATION_DONE,
+				  &key);
+	mlx5_core_mp_event_replay(ibdev->mdev,
+				  MLX5_DRIVER_EVENT_AFFILIATION_DONE,
+				  &key);
+
 	return true;
 
 unbind:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 15561965d2afa..6ca91c0e8a6a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -361,6 +361,12 @@ void mlx5_core_uplink_netdev_event_replay(struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_core_uplink_netdev_event_replay);
 
+void mlx5_core_mp_event_replay(struct mlx5_core_dev *dev, u32 event, void *data)
+{
+	mlx5_blocking_notifier_call_chain(dev, event, data);
+}
+EXPORT_SYMBOL(mlx5_core_mp_event_replay);
+
 int mlx5_core_get_caps_mode(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type,
 			    enum mlx5_cap_mode cap_mode)
 {
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 4d5be378fa8cc..26333d602a505 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -366,6 +366,8 @@ enum mlx5_driver_event {
 	MLX5_DRIVER_EVENT_UPLINK_NETDEV,
 	MLX5_DRIVER_EVENT_MACSEC_SA_ADDED,
 	MLX5_DRIVER_EVENT_MACSEC_SA_DELETED,
+	MLX5_DRIVER_EVENT_AFFILIATION_DONE,
+	MLX5_DRIVER_EVENT_AFFILIATION_REMOVED,
 };
 
 enum {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 3033bbaeac81c..5ca4e085d8133 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1027,6 +1027,8 @@ bool mlx5_cmd_is_down(struct mlx5_core_dev *dev);
 void mlx5_core_uplink_netdev_set(struct mlx5_core_dev *mdev, struct net_device *netdev);
 void mlx5_core_uplink_netdev_event_replay(struct mlx5_core_dev *mdev);
 
+void mlx5_core_mp_event_replay(struct mlx5_core_dev *dev, u32 event, void *data);
+
 void mlx5_health_cleanup(struct mlx5_core_dev *dev);
 int mlx5_health_init(struct mlx5_core_dev *dev);
 void mlx5_start_health_poll(struct mlx5_core_dev *dev);
-- 
2.43.0



