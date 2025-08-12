Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E762868AF;
	Tue, 12 Aug 2025 17:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021105; cv=none; b=uSSepG5pnFV/9ZQ2jYlp0piW7JOI/y478gZq7bgaMXZ+YehL/EmkGEHq36Oz2NYLWSGoi9iAyDTUAeBJEy+/P82mW6n3tbzDNn6s0nQHiO7E7AmkTEwyvnRU7KGlBtts+LTcrhbt5UTN/Xu5dWdNVwblLp5YlKTNOE0S5UhHvtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021105; c=relaxed/simple;
	bh=75idTpOlEDqhyYG2F7ggGHbE9OEw9kPqlPfEkBTduPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2j3q/9hYuWPbntyAUZ9RrHxAWVckNlMgKsR3nkiCxQ65fTpj2pZQMuNN6+GM6prQLYY81l6tIr2Se+SExYcnauE1pE+8+uSOGU51vUsSLcK2951eqnxCL2sK0UYXT2cLpS7bw44sssehgpFYl6HPhnBeo68bLUSTj+OdiJpiOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbENgoOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbENgoOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA66C4CEF0;
	Tue, 12 Aug 2025 17:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021105;
	bh=75idTpOlEDqhyYG2F7ggGHbE9OEw9kPqlPfEkBTduPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbENgoOJzMPuwnOBIidvt6Q3ba5usfQn3EK4n7RGwJtn9XySGNDE6XEMcibFfBA6P
	 E7VF/WZwbdfMTY/8Ez3onc8HACuCinhvMzNrkI8YAIeOx46A/cyyt8eb8GTB8KIREY
	 4D67a3fZvyCvyCrzg1NieKS8FbWKAxLpqnnxsbEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stav Aviram <saviram@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/262] net/mlx5: Check device memory pointer before usage
Date: Tue, 12 Aug 2025 19:27:30 +0200
Message-ID: <20250812172955.628686050@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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
index 3669c90b2dad..672e5cfd2fca 100644
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
index 9482e51ac82a..bdbbfaf504d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
@@ -28,7 +28,7 @@ struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
 
 	dm = kzalloc(sizeof(*dm), GFP_KERNEL);
 	if (!dm)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	spin_lock_init(&dm->lock);
 
@@ -80,7 +80,7 @@ struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
 err_steering:
 	kfree(dm);
 
-	return ERR_PTR(-ENOMEM);
+	return NULL;
 }
 
 void mlx5_dm_cleanup(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 32fa789a6960..62a85f09b52f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1055,9 +1055,6 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
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



