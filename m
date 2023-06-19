Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF0B3C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DF1C433C8;
	Mon, 19 Jun 2023 10:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171088;
	bh=SUr+mMq9bpoAFA6NzA1CMrYomDWo2jABpek2PKJiZIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7Ya62Z2hb1d4P0SJOh0hu+d7mnmYwIqwpqR7veHUsXRQ4Xf9W8xVVZ907S93XNrw
	 8QpD0kBwTP7BA5lPBcfzHxaQ5qCspIEOA6vWweXBwGtJKIk+Zq1on4oHbxUHlCFrlY
	 dU6JSYoPUk2ILDDMLOqr+LmCYFtge+fKMNJSwG+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 143/187] RDMA/mlx5: Fix affinity assignment
Date: Mon, 19 Jun 2023 12:29:21 +0200
Message-ID: <20230619102204.567740944@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit 617f5db1a626f18d5cbb7c7faf7bf8f9ea12be78 ]

The cited commit aimed to ensure that Virtual Functions (VFs) assign a
queue affinity to a Queue Pair (QP) to distribute traffic when
the LAG master creates a hardware LAG. If the affinity was set while
the hardware was not in LAG, the firmware would ignore the affinity value.

However, this commit unintentionally assigned an affinity to QPs on the LAG
master's VPORT even if the RDMA device was not marked as LAG-enabled.
In most cases, this was not an issue because when the hardware entered
hardware LAG configuration, the RDMA device of the LAG master would be
destroyed and a new one would be created, marked as LAG-enabled.

The problem arises when a user configures Equal-Cost Multipath (ECMP).
In ECMP mode, traffic can be directed to different physical ports based on
the queue affinity, which is intended for use by VPORTS other than the
E-Switch manager. ECMP mode is supported only if both E-Switch managers are
in switchdev mode and the appropriate route is configured via IP. In this
configuration, the RDMA device is not destroyed, and we retain the RDMA
device that is not marked as LAG-enabled.

To ensure correct behavior, Send Queues (SQs) opened by the E-Switch
manager through verbs should be assigned strict affinity. This means they
will only be able to communicate through the native physical port
associated with the E-Switch manager. This will prevent the firmware from
assigning affinity and will not allow the SQs to be remapped in case of
failover.

Fixes: 802dcc7fc5ec ("RDMA/mlx5: Support TX port affinity for VF drivers in LAG mode")
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://lore.kernel.org/r/425b05f4da840bc684b0f7e8ebf61aeb5cef09b0.1685960567.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h                |  3 +++
 drivers/infiniband/hw/mlx5/qp.c                     |  3 +++
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 12 ------------
 include/linux/mlx5/driver.h                         | 12 ++++++++++++
 4 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 91fc0cdf377d1..2dfa6f49a6f48 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1598,6 +1598,9 @@ static inline bool mlx5_ib_lag_should_assign_affinity(struct mlx5_ib_dev *dev)
 	    MLX5_CAP_PORT_SELECTION(dev->mdev, port_select_flow_table_bypass))
 		return 0;
 
+	if (mlx5_lag_is_lacp_owner(dev->mdev) && !dev->lag_active)
+		return 0;
+
 	return dev->lag_active ||
 		(MLX5_CAP_GEN(dev->mdev, num_lag_ports) > 1 &&
 		 MLX5_CAP_GEN(dev->mdev, lag_tx_port_affinity));
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 86284aba3470d..5bc63020b766d 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1233,6 +1233,9 @@ static int create_raw_packet_qp_tis(struct mlx5_ib_dev *dev,
 
 	MLX5_SET(create_tis_in, in, uid, to_mpd(pd)->uid);
 	MLX5_SET(tisc, tisc, transport_domain, tdn);
+	if (!mlx5_ib_lag_should_assign_affinity(dev) &&
+	    mlx5_lag_is_lacp_owner(dev->mdev))
+		MLX5_SET(tisc, tisc, strict_lag_tx_port_affinity, 1);
 	if (qp->flags & IB_QP_CREATE_SOURCE_QPN)
 		MLX5_SET(tisc, tisc, underlay_qpn, qp->underlay_qpn);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index a3c5c2dab5fd7..d7ef853702b79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -275,18 +275,6 @@ static inline bool mlx5_sriov_is_enabled(struct mlx5_core_dev *dev)
 	return pci_num_vf(dev->pdev) ? true : false;
 }
 
-static inline int mlx5_lag_is_lacp_owner(struct mlx5_core_dev *dev)
-{
-	/* LACP owner conditions:
-	 * 1) Function is physical.
-	 * 2) LAG is supported by FW.
-	 * 3) LAG is managed by driver (currently the only option).
-	 */
-	return  MLX5_CAP_GEN(dev, vport_group_manager) &&
-		   (MLX5_CAP_GEN(dev, num_lag_ports) > 1) &&
-		    MLX5_CAP_GEN(dev, lag_master);
-}
-
 int mlx5_rescan_drivers_locked(struct mlx5_core_dev *dev);
 static inline int mlx5_rescan_drivers(struct mlx5_core_dev *dev)
 {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 68a3183d5d589..33dbe941d070c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1233,6 +1233,18 @@ static inline u16 mlx5_core_max_vfs(const struct mlx5_core_dev *dev)
 	return dev->priv.sriov.max_vfs;
 }
 
+static inline int mlx5_lag_is_lacp_owner(struct mlx5_core_dev *dev)
+{
+	/* LACP owner conditions:
+	 * 1) Function is physical.
+	 * 2) LAG is supported by FW.
+	 * 3) LAG is managed by driver (currently the only option).
+	 */
+	return  MLX5_CAP_GEN(dev, vport_group_manager) &&
+		   (MLX5_CAP_GEN(dev, num_lag_ports) > 1) &&
+		    MLX5_CAP_GEN(dev, lag_master);
+}
+
 static inline int mlx5_get_gid_table_len(u16 param)
 {
 	if (param > 4) {
-- 
2.39.2



