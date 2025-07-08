Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16B91CD1E4;
	Tue,  8 Jul 2025 16:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992676; cv=none; b=e/r3v8pz/maFyn8ckD6nXBvGFlSLHQ2y8aQcrW/FUwpcxbwS9lh5FUWCo6R5vSzOsti7DMRmNdFpZcl5RGrXJgiAU9DlUtVNyGDHip6mUjBfElR2laZHPNh+iMenwLnUd72Bi5fNjmlCvCmgwQ6FPHf4+EvInKV/IexYDfPDbD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992676; c=relaxed/simple;
	bh=+1BLoNLXUm1xJi6Ia5z4jgpdbzu3dow5mimGOqy2/aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+u8r7VsLs6TwefRB3ft/3QPQdstX+YtZn1Xhfmwg51ys/KHRjlxeaRAUZtBVi20w6pF/NaNUzwy8Ecfk6qOERYL2wS4w8P6mZVVCYzqGs267+9823kxAo7jpfij8ULRxPHyT3JIXbM6CHJVJqgsVFsbnUPLhXx7SEdG9+hJzEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLVdJuPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLVdJuPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599A0C4CEED;
	Tue,  8 Jul 2025 16:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992676;
	bh=+1BLoNLXUm1xJi6Ia5z4jgpdbzu3dow5mimGOqy2/aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLVdJuPbN9DkNV9VnRUE3C/t562p7nzzhqOUQo1dgioivZU9XG88FZVuJzNCrPUXY
	 cURy9qUOQNs1ikA56jYw6l0nWLf0g4yXuqZ7Ady2nsqqf9KINXdSC72QcVfKF0fWoS
	 kNWOQfk5/QbPqR1x1Jv3uQbPDJgcbWn+vZ1F7xIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/232] RDMA/mlx5: Fix vport loopback for MPV device
Date: Tue,  8 Jul 2025 18:20:39 +0200
Message-ID: <20250708162242.588748138@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8c47cb4edd0a0..435c456a4fd5b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1766,6 +1766,33 @@ static void deallocate_uars(struct mlx5_ib_dev *dev,
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
@@ -3448,6 +3475,8 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 
 	lockdep_assert_held(&mlx5_ib_multiport_mutex);
 
+	mlx5_ib_disable_lb_mp(ibdev->mdev, mpi->mdev);
+
 	mlx5_core_mp_event_replay(ibdev->mdev,
 				  MLX5_DRIVER_EVENT_AFFILIATION_REMOVED,
 				  NULL);
@@ -3543,6 +3572,10 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
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



