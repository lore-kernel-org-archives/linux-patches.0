Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72822BE653;
	Tue, 26 Aug 2025 13:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215734; cv=none; b=YRMz2cSZDX+g7kbbq0INn3Xy7AVr9EmG0JSL1DQ75CDVNzU9yrZETfjN/U98V21W0hpPeMKWFjeGxHii/4hpS/97HGy29HDl2liLwWqX9IDcU1eAc+Tce+tLh1GwcvqVMgJQFYDfVuP/v7Z+AOFiO8Rr6URNONGq5Ri72k+AK0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215734; c=relaxed/simple;
	bh=X4hfGsyA7Ksgy4nIedhbIWRSZkCWPHIXQg/kcLwfCBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzwmRFdjqJpb/wn5eGMQcBvVBNSqNUUQQG0C+lgc1QeLh0mbgO1wCPiw6RjCSS1crxaXup7rEQ2ZJgqrAEku/236rOjqf2KNjZbdy3Y1l/X0/ozd+Bmic1k5fZGemrv71nLU3kCsax7W/h/DxkwV4fSXJLPYZv9oYF0s8vSKvJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hcd5lo0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hcd5lo0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADD7C116D0;
	Tue, 26 Aug 2025 13:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215733;
	bh=X4hfGsyA7Ksgy4nIedhbIWRSZkCWPHIXQg/kcLwfCBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hcd5lo0j3wNRxIsVXHQ6CTPN3D08fM+V1VEtpG8B9/BNcw8FVorJa9AkjC0L/lAE1
	 ZLY8CW8EgdaIPLLxdv4/Wb9+XQ18OXeSNhEhR5wQCLRdSDhiHDNdRybSNauoCUpqb4
	 tHBBpNo8a7/NH227y6jF61nVM/FtQgToWMaNMZfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stav Aviram <saviram@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/644] net/mlx5: Check device memory pointer before usage
Date: Tue, 26 Aug 2025 13:03:56 +0200
Message-ID: <20250826110950.084242269@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Stav Aviram <saviram@nvidia.com>

[ Upstream commit 70f238c902b8c0461ae6fbb8d1a0bbddc4350eea ]

Add a NULL check before accessing device memory to prevent a crash if
dev->dm allocation in mlx5_init_once() fails.

Fixes: c9b9dcb430b3 ("net/mlx5: Move device memory management to mlx5_core")
Signed-off-by: Stav Aviram <saviram@nvidia.com>
Link: https://patch.msgid.link/c88711327f4d74d5cebc730dc629607e989ca187.1751370035.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/dm.c                  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c   | 3 ---
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index 001d766cf291..a85f9f08877e 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -282,7 +282,7 @@ static struct ib_dm *handle_alloc_dm_memic(struct ib_ucontext *ctx,
 	int err;
 	u64 address;
 
-	if (!MLX5_CAP_DEV_MEM(dm_db->dev, memic))
+	if (!dm_db || !MLX5_CAP_DEV_MEM(dm_db->dev, memic))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	dm = kzalloc(sizeof(*dm), GFP_KERNEL);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
index 3d5e57ff558c..15ee84a2a470 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
@@ -25,7 +25,7 @@ struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
 
 	dm = kzalloc(sizeof(*dm), GFP_KERNEL);
 	if (!dm)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	spin_lock_init(&dm->lock);
 
@@ -61,7 +61,7 @@ struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
 err_steering:
 	kfree(dm);
 
-	return ERR_PTR(-ENOMEM);
+	return NULL;
 }
 
 void mlx5_dm_cleanup(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 13eceb601634..b3627163a292 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -901,9 +901,6 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 	}
 
 	dev->dm = mlx5_dm_create(dev);
-	if (IS_ERR(dev->dm))
-		mlx5_core_warn(dev, "Failed to init device memory %ld\n", PTR_ERR(dev->dm));
-
 	dev->tracer = mlx5_fw_tracer_create(dev);
 	dev->hv_vhca = mlx5_hv_vhca_create(dev);
 	dev->rsc_dump = mlx5_rsc_dump_create(dev);
-- 
2.39.5



