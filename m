Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB83A8F54;
	Mon, 13 Oct 2025 15:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368380; cv=none; b=hKBUUbb2Qxza8KHYNSEDA7REZ0is2L2ZOFk7QXL8uoXyiEp0eCQh5KDitz+2HznDLnTDAYy7wx4BgIKVn2l7gWVjGydoMwOSNCOQ5MByQXtzyrVbY0jvXc+A8fy3ORhfthXY/jn3ERfKDuLzeK0L5WW5X58Q/sJL7vOwmslilag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368380; c=relaxed/simple;
	bh=Y9b2BjPwrDel7+3z1hDmTtKuVMElHeNC3SLI0/t6bQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIuewGO4E1+yR3d9X03PhIw9QGAgbNmfUv4hjXcbgTGww9oLSSYLPZQxs77e1Wl54DjoIWIHM+4Wc5GJuGa6CkjmqgZtd7GK4dzsae/g9cDujJEUf7eDn5YRe3SuesNs2tU2tS3/KSg/kk/iD3n6duvFxijdiCSNkCGHLxbXpDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHTPT/Yv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHTPT/Yv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471F7C4CEE7;
	Mon, 13 Oct 2025 15:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368380;
	bh=Y9b2BjPwrDel7+3z1hDmTtKuVMElHeNC3SLI0/t6bQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHTPT/YvritLxJGDXvQiYTRRtPbHE59EhpBOJrEp+wEGqI0fczG0qvh+jUsqa6knT
	 EheOttmVIiO0lBWKmnNpwGMyhWKFojOsXHjyySTLy5B+XLXA81HTlJauw8e/pDmkUd
	 RY4beQxtaZH+/QtzrXGDrhJyhhjW5dZYOvEvig7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/262] RDMA/mlx5: Fix vport loopback forcing for MPV device
Date: Mon, 13 Oct 2025 16:44:09 +0200
Message-ID: <20251013144329.980486659@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 08aae7860450c89eebbc6fd4d38416e53c7a33d2 ]

Previously loopback for MPV was supposed to be permanently enabled,
however other driver flows were able to over-ride that configuration and
disable it.

Add force_lb parameter that indicates that loopback should always be
enabled which prevents all other driver flows from disabling it.

Fixes: a9a9e68954f2 ("RDMA/mlx5: Fix vport loopback for MPV device")
Link: https://patch.msgid.link/r/cfc6b1f0f99f8100b087483cc14da6025317f901.1755088808.git.leon@kernel.org
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 19 +++++++++++++++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 29d0bc583169b..f3e58797705d7 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1813,7 +1813,8 @@ static void deallocate_uars(struct mlx5_ib_dev *dev,
 }
 
 static int mlx5_ib_enable_lb_mp(struct mlx5_core_dev *master,
-				struct mlx5_core_dev *slave)
+				struct mlx5_core_dev *slave,
+				struct mlx5_ib_lb_state *lb_state)
 {
 	int err;
 
@@ -1825,6 +1826,7 @@ static int mlx5_ib_enable_lb_mp(struct mlx5_core_dev *master,
 	if (err)
 		goto out;
 
+	lb_state->force_enable = true;
 	return 0;
 
 out:
@@ -1833,16 +1835,22 @@ static int mlx5_ib_enable_lb_mp(struct mlx5_core_dev *master,
 }
 
 static void mlx5_ib_disable_lb_mp(struct mlx5_core_dev *master,
-				  struct mlx5_core_dev *slave)
+				  struct mlx5_core_dev *slave,
+				  struct mlx5_ib_lb_state *lb_state)
 {
 	mlx5_nic_vport_update_local_lb(slave, false);
 	mlx5_nic_vport_update_local_lb(master, false);
+
+	lb_state->force_enable = false;
 }
 
 int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 {
 	int err = 0;
 
+	if (dev->lb.force_enable)
+		return 0;
+
 	mutex_lock(&dev->lb.mutex);
 	if (td)
 		dev->lb.user_td++;
@@ -1864,6 +1872,9 @@ int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 
 void mlx5_ib_disable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 {
+	if (dev->lb.force_enable)
+		return;
+
 	mutex_lock(&dev->lb.mutex);
 	if (td)
 		dev->lb.user_td--;
@@ -3521,7 +3532,7 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 
 	lockdep_assert_held(&mlx5_ib_multiport_mutex);
 
-	mlx5_ib_disable_lb_mp(ibdev->mdev, mpi->mdev);
+	mlx5_ib_disable_lb_mp(ibdev->mdev, mpi->mdev, &ibdev->lb);
 
 	mlx5_core_mp_event_replay(ibdev->mdev,
 				  MLX5_DRIVER_EVENT_AFFILIATION_REMOVED,
@@ -3618,7 +3629,7 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
 				  MLX5_DRIVER_EVENT_AFFILIATION_DONE,
 				  &key);
 
-	err = mlx5_ib_enable_lb_mp(ibdev->mdev, mpi->mdev);
+	err = mlx5_ib_enable_lb_mp(ibdev->mdev, mpi->mdev, &ibdev->lb);
 	if (err)
 		goto unbind;
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 29bde64ea1eac..f49cb588a856d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1083,6 +1083,7 @@ struct mlx5_ib_lb_state {
 	u32			user_td;
 	int			qps;
 	bool			enabled;
+	bool			force_enable;
 };
 
 struct mlx5_ib_pf_eq {
-- 
2.51.0



