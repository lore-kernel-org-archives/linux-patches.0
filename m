Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD4619BC9
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0E9C433EF;
	Wed,  7 Jun 2023 20:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170333;
	bh=7Q1b9kfb0jGjN7g3QZr3FPW6LLQNiR+QDFLs5F6K/b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twqLwI3CY4s0Mu+2/UgK4R7qXXCRn3qW/fP4N6NyFmoGZsM8RknwY62ZkQUgRHWCV
	 bltfN9dnatO81cwodbxJqn9TUGcBToiyn6JG8vlKIrv2DyaHkrPc0m9B/J7/E33eHy
	 fISHtZB4khO5VkKdMaWyqBBjL1E8p05VsmbP9UFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/225] net/mlx5e: Fix error handling in mlx5e_refresh_tirs
Date: Wed,  7 Jun 2023 22:13:57 +0200
Message-ID: <20230607200915.799807093@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit b6193d7030e3c59f1d4c75648c9c8fa40cad2bcd ]

Allocation failure is outside the critical lock section and should
return immediately rather than jumping to the unlock section.

Also unlock as soon as required and remove the now redundant jump label.

Fixes: 80a2a9026b24 ("net/mlx5e: Add a lock on tir list")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_common.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index 68f19324db93c..03a99918a8942 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -139,10 +139,8 @@ int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb,
 
 	inlen = MLX5_ST_SZ_BYTES(modify_tir_in);
 	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!in)
+		return -ENOMEM;
 
 	if (enable_uc_lb)
 		lb_flags = MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST;
@@ -160,14 +158,13 @@ int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb,
 		tirn = tir->tirn;
 		err = mlx5_core_modify_tir(mdev, tirn, in);
 		if (err)
-			goto out;
+			break;
 	}
+	mutex_unlock(&mdev->mlx5e_res.hw_objs.td.list_lock);
 
-out:
 	kvfree(in);
 	if (err)
 		netdev_err(priv->netdev, "refresh tir(0x%x) failed, %d\n", tirn, err);
-	mutex_unlock(&mdev->mlx5e_res.hw_objs.td.list_lock);
 
 	return err;
 }
-- 
2.39.2



