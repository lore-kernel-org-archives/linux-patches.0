Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57272E62AB;
	Tue, 15 Jul 2025 13:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586240; cv=none; b=icZgKwC1nXhPtkAJdpMANWS9EbS4QBj7iUIDvJeNm5gBqHIgJB5zt6e382E7cHezbiyJYfbHcZVTGNdoTqhiX8iL0XRhZUtWlUOfY9jBjTsiT1NES+IYavyQwGiu3mKnbrFuds38vXjwgNkJ4dHi7psHQMykq/CSeEAVh+qxNyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586240; c=relaxed/simple;
	bh=RpRdTX4ISJVQpkAuOxrV3svgb2KVhhOenk4rp8nLyOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3eb7PXjAZFKBgRPPTKoQbOLR/+YK4tVKLVdYRBmlOMSv/f+Z+ltVEGboq9wh7XdMCSfSsfbZnigiQsIS46TXlUXpQZMwpEKKq0r/IntrfGdZq0+Rue4v3R5J+rzpK2htbNXQHz+O2dng/7B2tp/8wF0MxKsgJotliP/hx67Hyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2iEscMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2iEscMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78380C4CEF6;
	Tue, 15 Jul 2025 13:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586239;
	bh=RpRdTX4ISJVQpkAuOxrV3svgb2KVhhOenk4rp8nLyOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2iEscMRGfMFcpwOZOZvdMtjDQBjGr7j06H6avbx5sOR9BZnOJjYD/ySYY7kOMNO3
	 CaUfRReIBHpwoVCu/MXPnPP48v1Wp4mez5C6MOeuw3lco+7ULyoUnhpJlbAjdoyGWV
	 hoIk/ymhyKmhxsJIEM5hD5HeKk4YFpZ+qFvXrhmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 37/77] RDMA/mlx5: Fix vport loopback for MPV device
Date: Tue, 15 Jul 2025 15:13:36 +0200
Message-ID: <20250715130753.197688880@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2236c62a19807..e2f3369342c48 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1680,6 +1680,33 @@ static void deallocate_uars(struct mlx5_ib_dev *dev,
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
@@ -3147,6 +3174,8 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 
 	lockdep_assert_held(&mlx5_ib_multiport_mutex);
 
+	mlx5_ib_disable_lb_mp(ibdev->mdev, mpi->mdev);
+
 	mlx5_ib_cleanup_cong_debugfs(ibdev, port_num);
 
 	spin_lock(&port->mp.mpi_lock);
@@ -3231,6 +3260,10 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
 
 	mlx5_ib_init_cong_debugfs(ibdev, port_num);
 
+	err = mlx5_ib_enable_lb_mp(ibdev->mdev, mpi->mdev);
+	if (err)
+		goto unbind;
+
 	return true;
 
 unbind:
-- 
2.39.5



