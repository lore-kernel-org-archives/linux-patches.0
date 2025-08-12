Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD9F1A3029;
	Tue, 12 Aug 2025 19:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025732; cv=none; b=S9oo4fZ4liB4TtFtB8N9Yl2bKxRNJBUkVTtNVU+0n5BWBoImmuLunhPyrwdSFjbKOQDO9ZbScqJhommE0a0nx+0aShZfd6AJb/b+xQR5+zUjgHKdxJ+NkrdABQ/BuxofcYKDnBYTwsGrQfvTaIYtJ+QtBNbs1lmXPhF3uaRXOj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025732; c=relaxed/simple;
	bh=d+6N2eCYWWryaPwkSijIfTt2nvwkrXw4wla4nzFDIIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/ASS1ept39XPTcYh/XutEZJL1GbRQGn32WvMZ3rciZb9GCDoH5zbVE8KLmCtVXdB7Kwe3avWHftkwxoisTuiKLjE1Cbu1qOp3vyY292ea2Lf/ZrP3WA/8ZWOvVH/u7X9l1IL21zBEfutpBz6uah3WjtWet0TBz24vyFFpjW8Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJ1+Dzdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJ1+Dzdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156AEC4CEF0;
	Tue, 12 Aug 2025 19:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025731;
	bh=d+6N2eCYWWryaPwkSijIfTt2nvwkrXw4wla4nzFDIIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJ1+DzdkhRp3PnOuxHsaY4frHcbdantL2xf/rD7V9WPxqovV/skHtmuUwKEXppO92
	 QfcbwVGBzTds8zO4D8Uqf0www7Hm1/2kN3j1C7TeLh0DIf4ImF1VObyN9Y9RM/tsg1
	 DZ4/2PXa/dUhCHnuUt5bapyUsg7DVFg6NM3yWHQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stav Aviram <saviram@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 128/480] net/mlx5: Check device memory pointer before usage
Date: Tue, 12 Aug 2025 19:45:36 +0200
Message-ID: <20250812174402.806051188@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index b4c97fb62abf..9ded2b7c1e31 100644
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
index 7c5516b0a844..8115071c34a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
@@ -30,7 +30,7 @@ struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
 
 	dm = kzalloc(sizeof(*dm), GFP_KERNEL);
 	if (!dm)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	spin_lock_init(&dm->lock);
 
@@ -96,7 +96,7 @@ struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
 err_steering:
 	kfree(dm);
 
-	return ERR_PTR(-ENOMEM);
+	return NULL;
 }
 
 void mlx5_dm_cleanup(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 9c1504d29d34..e7bcd0f0a709 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1102,9 +1102,6 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
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



