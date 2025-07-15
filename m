Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E6E2E1757;
	Tue, 15 Jul 2025 13:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587711; cv=none; b=moSrhPHSVy5UOGpxOacXeXyKnJco37yPiHhJnChVIJJX+KFDAegoHcwYpZF2K8KgCbgDCoZwwn25WUgwTwFAsN2q77/C8m2UL8nxw7hnewtLMYzA/8NR7DBpmFzrEz1gmuVKiHwGuXRFRnjuu4JTYraOXrywCbUN5SawrKXw5VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587711; c=relaxed/simple;
	bh=4Oifk2DbG+/gXf3ebjf5hfPdCCM1O7Yu0eoa0lyBbG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQHy8FD/ChaAh1kql/EU7W+vRJLFLQFIgbvXpu3Y6jmpEoXQrgMw80g2Mnt4AFoUa5rFWzl8jsNeSQIQXsW637/SBLkEbEGKC2luUsDMbWu/efO0OoVa4rIpjm3nQKovjweCSSE2q4bKbbXHFanoeomkeWl3pATeVZKx3bL35HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hbPLGYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hbPLGYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B10C4CEE3;
	Tue, 15 Jul 2025 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587711;
	bh=4Oifk2DbG+/gXf3ebjf5hfPdCCM1O7Yu0eoa0lyBbG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hbPLGYzVrjRljMonKuFPl6JU6TE6tTvaPg/MlNd2WT4qRc62UMZNigLWHvLED+YV
	 u/bAfTVIcJnv05rrQE3EHa/hOQ4RMVr93zZEbiMK1+mmGNJ0nSKIkZ4FTm/7NywNdq
	 QZWxLbVNMOFCKeaRsm4QOHBoLByLELHgbSVWoABg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/208] RDMA/mlx5: Fix vport loopback for MPV device
Date: Tue, 15 Jul 2025 15:13:43 +0200
Message-ID: <20250715130815.515131340@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit a9a9e68954f29b1e197663f76289db4879fd51bb ]

Always enable vport loopback for both MPV devices on driver start.

Previously in some cases related to MPV RoCE, packets weren't correctly
executing loopback check at vport in FW, since it was disabled.
Due to complexity of identifying such cases for MPV always enable vport
loopback for both GVMIs when binding the slave to the master port.

Fixes: 0042f9e458a5 ("RDMA/mlx5: Enable vport loopback when user context or QP mandate")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/d4298f5ebb2197459e9e7221c51ecd6a34699847.1750064969.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 33 +++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 1800cea46b2d3..0e20b99cae8b6 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1667,6 +1667,33 @@ static void deallocate_uars(struct mlx5_ib_dev *dev,
 			mlx5_cmd_free_uar(dev->mdev, bfregi->sys_pages[i]);
 }
 
+static int mlx5_ib_enable_lb_mp(struct mlx5_core_dev *master,
+				struct mlx5_core_dev *slave)
+{
+	int err;
+
+	err = mlx5_nic_vport_update_local_lb(master, true);
+	if (err)
+		return err;
+
+	err = mlx5_nic_vport_update_local_lb(slave, true);
+	if (err)
+		goto out;
+
+	return 0;
+
+out:
+	mlx5_nic_vport_update_local_lb(master, false);
+	return err;
+}
+
+static void mlx5_ib_disable_lb_mp(struct mlx5_core_dev *master,
+				  struct mlx5_core_dev *slave)
+{
+	mlx5_nic_vport_update_local_lb(slave, false);
+	mlx5_nic_vport_update_local_lb(master, false);
+}
+
 int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 {
 	int err = 0;
@@ -3424,6 +3451,8 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 
 	lockdep_assert_held(&mlx5_ib_multiport_mutex);
 
+	mlx5_ib_disable_lb_mp(ibdev->mdev, mpi->mdev);
+
 	mlx5_ib_cleanup_cong_debugfs(ibdev, port_num);
 
 	spin_lock(&port->mp.mpi_lock);
@@ -3512,6 +3541,10 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
 
 	mlx5_ib_init_cong_debugfs(ibdev, port_num);
 
+	err = mlx5_ib_enable_lb_mp(ibdev->mdev, mpi->mdev);
+	if (err)
+		goto unbind;
+
 	return true;
 
 unbind:
-- 
2.39.5



