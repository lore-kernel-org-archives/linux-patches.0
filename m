Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588F3146D6B;
	Mon,  6 Jan 2025 15:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178859; cv=none; b=N+YqhkLX9ychEtm0LxKMwfK4Y2eYjsjNASbATmCFEiRehZN2OfSj7Um6No3K2Yp0Rv8irH8eX5rjRWfquzhcBvAlGl+LEHLe0vpHoehn+s48UiVdrErcfUm/5qL4O092iBEtxzP2WxI57vVUIZbxq7NrWO9j8J7adDW9ogkw5+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178859; c=relaxed/simple;
	bh=+wAMcC86TPyN8PPdlXEqRu4NEF79PSLp7zdl5Z2/cCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7Rr3kjTrY/SMgC9JRpo47ygHGgFllrpwuE+6Zb/qTKCT5YJige5ZS4MaEsx2i5XYyvbjllXNAEoeAKD/VLwj5A3LxIGJbeqe1VJJmDmTN6PXRcEhQBdCeo47KdfsO+wV5KmgJ/+vJGzl2eKdn05Bpi+zE//v1fW3+ogRTajYOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQqJXAQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQqJXAQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4C4C4CED2;
	Mon,  6 Jan 2025 15:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178859;
	bh=+wAMcC86TPyN8PPdlXEqRu4NEF79PSLp7zdl5Z2/cCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQqJXAQGrei0c2NAjV+mqbA/xh0Do/dTpeK3MUsPe4JIIOCDhVVHQSGO84PVLWqc1
	 DZHiNaQvN1NakyvjuTRdJhiMMT3N5NPZODnojTZ2Btbqh51A9l2RY9n6tRmfeLma5r
	 tErB+cnHr9v+Cjf5j45Fnqqq5tCSl/S7lNtxt98A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/168] RDMA/mlx5: Enforce same type port association for multiport RoCE
Date: Mon,  6 Jan 2025 16:17:05 +0100
Message-ID: <20250106151142.870505102@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

[ Upstream commit e05feab22fd7dabcd6d272c4e2401ec1acdfdb9b ]

Different core device types such as PFs and VFs shouldn't be affiliated
together since they have different capabilities, fix that by enforcing
type check before doing the affiliation.

Fixes: 32f69e4be269 ("{net, IB}/mlx5: Manage port association for multiport RoCE")
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Link: https://patch.msgid.link/88699500f690dff1c1852c1ddb71f8a1cc8b956e.1733233480.git.leonro@nvidia.com
Reviewed-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 6 ++++--
 include/linux/mlx5/driver.h       | 6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index aa7a44ea49fa..2236c62a1980 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3284,7 +3284,8 @@ static int mlx5_ib_init_multiport_master(struct mlx5_ib_dev *dev)
 		list_for_each_entry(mpi, &mlx5_ib_unaffiliated_port_list,
 				    list) {
 			if (dev->sys_image_guid == mpi->sys_image_guid &&
-			    (mlx5_core_native_port_num(mpi->mdev) - 1) == i) {
+			    (mlx5_core_native_port_num(mpi->mdev) - 1) == i &&
+			    mlx5_core_same_coredev_type(dev->mdev, mpi->mdev)) {
 				bound = mlx5_ib_bind_slave_port(dev, mpi);
 			}
 
@@ -4408,7 +4409,8 @@ static int mlx5r_mp_probe(struct auxiliary_device *adev,
 
 	mutex_lock(&mlx5_ib_multiport_mutex);
 	list_for_each_entry(dev, &mlx5_ib_dev_list, ib_dev_list) {
-		if (dev->sys_image_guid == mpi->sys_image_guid)
+		if (dev->sys_image_guid == mpi->sys_image_guid &&
+		    mlx5_core_same_coredev_type(dev->mdev, mpi->mdev))
 			bound = mlx5_ib_bind_slave_port(dev, mpi);
 
 		if (bound) {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 26095c0fd781..62d60a515b03 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1182,6 +1182,12 @@ static inline bool mlx5_core_is_vf(const struct mlx5_core_dev *dev)
 	return dev->coredev_type == MLX5_COREDEV_VF;
 }
 
+static inline bool mlx5_core_same_coredev_type(const struct mlx5_core_dev *dev1,
+					       const struct mlx5_core_dev *dev2)
+{
+	return dev1->coredev_type == dev2->coredev_type;
+}
+
 static inline bool mlx5_core_is_ecpf(const struct mlx5_core_dev *dev)
 {
 	return dev->caps.embedded_cpu;
-- 
2.39.5



