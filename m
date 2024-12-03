Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594431DE8A5;
	Tue,  3 Dec 2024 15:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241379; cv=none; b=CZZ4bzhYEWgz8w3XliSQAE8FjT1YxdGygq3XCyiEziwcq96eUDmm9HkGzqGUFBfkxKWdPtpNEIs2aO9k2QexRMjVFOjgV41P+Xum3SRzGK+pJLRwSKP51AzF/6NS7JEl512QhnPxclxTlXiln3OcD43EoG0jH2PFfhBl9CbLKzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241379; c=relaxed/simple;
	bh=ZZazt/HE9JX8FfkHgdleV4HCxWiDQosW5myW7Ixi+2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbHbXnctEq6L1tTYASMxoBZd3YxlcVARhdMFCO/c2ygvnHWwvtVeA2H6KTSKtdKuoPWuU4HZDsZmCJ91H6nDtWCpR51uTG66Iw0+W2owE1rW7diMWLj78/azymDC9d5KABXHb1SZraJnsCkLj2y2c9Q9++DP6YjC0a1m1R1u7JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZ2plNIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZ2plNIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCA6C4CECF;
	Tue,  3 Dec 2024 15:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241378;
	bh=ZZazt/HE9JX8FfkHgdleV4HCxWiDQosW5myW7Ixi+2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZ2plNIqWDb7QTb6oH6aHFEJP3mvoScEcKXH5Ek+lmuPHiloON1SdrHgqqBCLo7WW
	 57g3T0xIvGIGV1yP+BCE5UNyyyIhzGs/VxpVanZAg8LWIN4aZKlvaWM+TflD7YkkGn
	 ioFY0VXnVzGtrmyH9elBAFQUOypvxH3zN72kaEwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 402/826] RDMA/mlx5: Ensure active slave attachment to the bond IB device
Date: Tue,  3 Dec 2024 15:42:09 +0100
Message-ID: <20241203144759.443488969@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chiara Meiohas <cmeiohas@nvidia.com>

[ Upstream commit 0bd2c61df95321e1ec123017cd8657360d15a24e ]

Fix a race condition when creating a lag bond in active backup
mode where after the bond creation the backup slave was
attached to the IB device, instead of the active slave.
This caused stale entries in the GID table, as the gid updating
mechanism relies on ib_device_get_netdev(), which would return
the backup slave.

Send an MLX5_DRIVER_EVENT_ACTIVE_BACKUP_LAG_CHANGE_LOWERSTATE
event when activating the lag, additionally to when modifying
the lag. This ensures that eventually the active netdevice is
stored in the bond IB device.
When handling this event remove the GIDs of the previously
attached netdevice in this port and rescan the GIDs of the
newly attached netdevice.

This ensures that eventually the active slave netdevice is
correctly stored in the IB device port. While there might be
a brief moment where the backup slave GIDs appear in the GID
table, it will eventually stabilize with the correct GIDs
(of the bond and the active slave).

Fixes: 8d159eb2117b ("RDMA/mlx5: Use IB set_netdev and get_netdev functions")
Signed-off-by: Chiara Meiohas <cmeiohas@nvidia.com>
Link: https://patch.msgid.link/91fc2cb24f63add266a528c1c702668a80416d9f.1730381292.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c             | 28 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 11 ++++++++
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 32e57cc343361..5fef9288699c6 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3211,12 +3211,14 @@ static int lag_event(struct notifier_block *nb, unsigned long event, void *data)
 	struct mlx5_ib_dev *dev = container_of(nb, struct mlx5_ib_dev,
 					       lag_events);
 	struct mlx5_core_dev *mdev = dev->mdev;
+	struct ib_device *ibdev = &dev->ib_dev;
+	struct net_device *old_ndev = NULL;
 	struct mlx5_ib_port *port;
 	struct net_device *ndev;
-	int  i, err;
-	int portnum;
+	u32 portnum = 0;
+	int ret = 0;
+	int i;
 
-	portnum = 0;
 	switch (event) {
 	case MLX5_DRIVER_EVENT_ACTIVE_BACKUP_LAG_CHANGE_LOWERSTATE:
 		ndev = data;
@@ -3232,18 +3234,24 @@ static int lag_event(struct notifier_block *nb, unsigned long event, void *data)
 					}
 				}
 			}
-			err = ib_device_set_netdev(&dev->ib_dev, ndev,
-						   portnum + 1);
-			if (err)
-				return err;
-			/* Rescan gids after new netdev assignment */
-			rdma_roce_rescan_device(&dev->ib_dev);
+			old_ndev = ib_device_get_netdev(ibdev, portnum + 1);
+			ret = ib_device_set_netdev(ibdev, ndev, portnum + 1);
+			if (ret)
+				goto out;
+
+			if (old_ndev)
+				roce_del_all_netdev_gids(ibdev, portnum + 1,
+							 old_ndev);
+			rdma_roce_rescan_port(ibdev, portnum + 1);
 		}
 		break;
 	default:
 		return NOTIFY_DONE;
 	}
-	return NOTIFY_OK;
+
+out:
+	dev_put(old_ndev);
+	return notifier_from_errno(ret);
 }
 
 static void mlx5e_lag_event_register(struct mlx5_ib_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index d661267d98ffc..7f68468c2e759 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -919,6 +919,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	struct lag_tracker tracker = { };
+	struct net_device *ndev;
 	bool do_bond, roce_lag;
 	int err;
 	int i;
@@ -982,6 +983,16 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 				return;
 			}
 		}
+		if (tracker.tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP) {
+			ndev = mlx5_lag_active_backup_get_netdev(dev0);
+			/** Only sriov and roce lag should have tracker->TX_type
+			 *  set so no need to check the mode
+			 */
+			blocking_notifier_call_chain(&dev0->priv.lag_nh,
+						     MLX5_DRIVER_EVENT_ACTIVE_BACKUP_LAG_CHANGE_LOWERSTATE,
+						     ndev);
+			dev_put(ndev);
+		}
 	} else if (mlx5_lag_should_modify_lag(ldev, do_bond)) {
 		mlx5_modify_lag(ldev, &tracker);
 	} else if (mlx5_lag_should_disable_lag(ldev, do_bond)) {
-- 
2.43.0



