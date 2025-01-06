Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0871482F2;
	Mon,  6 Jan 2025 16:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179213; cv=none; b=gc6tII4BK4GzD/XMYIDn1HFsUYQ2qDelrswCmwPf4pd7iZIICFghPuLFhXm2NRjgZ5+/dlgyrZlO29UqKiO0d6YT3YJ4bc0GLOHW77561Xnwx8+V+F2NN9BgHH+NWipqCoA+uY1lkhOe4d0a0pZI7Zj/qjweSvhOhZJWvWbKNdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179213; c=relaxed/simple;
	bh=GzFaKfMTJBZo6HjwHYKAszySPkLRTMEYsLOeaDTyA3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8iOESPikM9gGjBoQH2XD5qVSxii7kcKmeQbJgfV94NPYdJBrtuUnqxJMMfSxft2fw2NwPH6xpKwAN8r0X8FihlawJhaU2BBwA7RikzT8MVoRoePckZCkMs+4QoD+p0EKbyzrpP3Aou8uhZcSseTW32/1egu0/R9XJQHzQfdJF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbJyinGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbJyinGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB18C4CED2;
	Mon,  6 Jan 2025 16:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179213;
	bh=GzFaKfMTJBZo6HjwHYKAszySPkLRTMEYsLOeaDTyA3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbJyinGNFFg2gMCKGBBlUEmI0IIT+BgAPQlNKrDn/lpNWXy3WdVIJT6zihwZE3TVL
	 zyoPZ99yEUXSKX4y2sOFs6NPjweNqnUQxR8SI5/mheTh7lhC1MfBh4psRFq+ajKSKe
	 tModu66+jGd+/fsdc+slIH09mwzYwTHuNIQsQRPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@mellanox.com>,
	Vu Pham <vuhuong@mellanox.com>,
	Saeed Mahameed <saeedm@mellanox.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 64/93] IB/mlx5: Introduce and use mlx5_core_is_vf()
Date: Mon,  6 Jan 2025 16:17:40 +0100
Message-ID: <20250106151131.121201006@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit e53a9d26cf80565cfb7172fc52a0dfac73613a0f ]

Instead of deciding a given device is virtual function or
not based on a device is PF or not, use already defined
MLX5_COREDEV_VF by introducing an helper API mlx5_core_is_vf().

This enables to clearly identify PF, VF and non virtual functions.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Stable-dep-of: e05feab22fd7 ("RDMA/mlx5: Enforce same type port association for multiport RoCE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 2 +-
 include/linux/mlx5/driver.h       | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 6698032af87d..5e00acb9bb31 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1034,7 +1034,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (MLX5_CAP_GEN(mdev, cd))
 		props->device_cap_flags |= IB_DEVICE_CROSS_CHANNEL;
 
-	if (!mlx5_core_is_pf(mdev))
+	if (mlx5_core_is_vf(mdev))
 		props->device_cap_flags |= IB_DEVICE_VIRTUAL_FUNCTION;
 
 	if (mlx5_ib_port_link_layer(ibdev, 1) ==
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 18fd0a030584..9744d9a2d71e 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1132,6 +1132,11 @@ static inline bool mlx5_core_is_pf(const struct mlx5_core_dev *dev)
 	return dev->coredev_type == MLX5_COREDEV_PF;
 }
 
+static inline bool mlx5_core_is_vf(const struct mlx5_core_dev *dev)
+{
+	return dev->coredev_type == MLX5_COREDEV_VF;
+}
+
 static inline bool mlx5_core_is_ecpf(struct mlx5_core_dev *dev)
 {
 	return dev->caps.embedded_cpu;
-- 
2.39.5



