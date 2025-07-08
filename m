Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E917881E;
	Tue,  8 Jul 2025 16:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992247; cv=none; b=UoqIKD1yPPvMjM3az7/H//nnCzmL9vmefUq0lixTwGj/BcYcrRGzl+cGfa7p8OKOhcdClyxHPIOl6taaLcdlb4SiL4b+D6fA1pnfR5q5RgUircfGBVDD/3kIosxw219h3ig3qq/vIq9B3N7kzgT/eBR140VH5VydY56hysk0bjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992247; c=relaxed/simple;
	bh=qBxXnA3lLMjns3Lc90lpYjT7+hkNv95PXP4pzSUOd8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABgwFWeemcyn+aOSzAJhb+ozNiNhTbCcF2yukLvhQ63MWBNdCPkMTTXtRIJLVmVmfMTdzb3mZtjemz1ECfZpWTEcSuVDuqtiKgnTol1VUYMKjvB0jXJ3kZUh2wmH0WoP2WrECFzBn6jV6gFdMxw3la8TAVuKLlE6BUApJjBCdbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7b7GCNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7b7GCNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8166CC4CEED;
	Tue,  8 Jul 2025 16:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992246;
	bh=qBxXnA3lLMjns3Lc90lpYjT7+hkNv95PXP4pzSUOd8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7b7GCNYxGojPpJzsDehJphRn6miu6dKjBAwQjNblnsW157wdvx8n7FJeY66buose
	 O/Ot/+G3iF3m9+V1D9r+N/90l7Vy93cAP/MoYrJu6IGnLnu1uXHP0dpagQRwPVDtuM
	 5TccZsTqGLCwqrvHfBsk98U43YcUkS8kcMNUOWNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/132] RDMA/mlx5: Fix vport loopback for MPV device
Date: Tue,  8 Jul 2025 18:22:19 +0200
Message-ID: <20250708162231.534403803@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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
index ada7dbf8eb1cf..e922fb8728654 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1690,6 +1690,33 @@ static void deallocate_uars(struct mlx5_ib_dev *dev,
 					     context->devx_uid);
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
@@ -3224,6 +3251,8 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 
 	lockdep_assert_held(&mlx5_ib_multiport_mutex);
 
+	mlx5_ib_disable_lb_mp(ibdev->mdev, mpi->mdev);
+
 	mlx5_core_mp_event_replay(ibdev->mdev,
 				  MLX5_DRIVER_EVENT_AFFILIATION_REMOVED,
 				  NULL);
@@ -3319,6 +3348,10 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
 				  MLX5_DRIVER_EVENT_AFFILIATION_DONE,
 				  &key);
 
+	err = mlx5_ib_enable_lb_mp(ibdev->mdev, mpi->mdev);
+	if (err)
+		goto unbind;
+
 	return true;
 
 unbind:
-- 
2.39.5



