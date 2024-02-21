Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2593C69942;
	Wed, 21 Feb 2024 14:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525025; cv=none; b=Y0XV3bc+Fw6g4R5S9pXO1jDfwdfgn1mITjVoVCNdeV4ksfZ7d7mv301evzAKh4+HC9GSkofyYWMA6PxJoAWTTt6yC7pOvRjQYNANDnQEm9RgBGtXpr+z7JdYGhAq727udo9QOjoVKq7mKryezlZ3m9Zmb+yiRTb1m+xBfb4ebVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525025; c=relaxed/simple;
	bh=0LFGoDtGidrrJTFPy1pfakleeTI4pdUZShVZIOk/wH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V50xXRfjjfvFdWhYTEfr5XsjQlSDJE2lvcfEa/n05tR+HNwWlj0caP1rj/gADzZQ4+p4Otp7XuCZ3FKZ86ZyCF7m3uLOctn2h3N2R13746BpeDaxuWkOpbaRiaZVwZLe+bzD2J6ziT05J1RysuLzmDXxH6eBLjogvdXwbynyxyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QS/ijctK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QS/ijctK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73FDC433F1;
	Wed, 21 Feb 2024 14:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525025;
	bh=0LFGoDtGidrrJTFPy1pfakleeTI4pdUZShVZIOk/wH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QS/ijctKm0LhwbecX7twPrCOKRMS4iWW9iYk77t8WTBty+UBypeCL8G1Zr2rzNBJN
	 duSVpf/dm89Pa9CkHONHz2KTTmWh7lc6BHSE3ojJl/EpknG9bqMx9nhhe5hoxXq5PV
	 D1vAektUCcyX/yQdFGNzJodB9NcbXTgnbYSMZZnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/267] net/mlx5e: fix a double-free in arfs_create_groups
Date: Wed, 21 Feb 2024 14:06:18 +0100
Message-ID: <20240221125941.190756291@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 3c6d5189246f590e4e1f167991558bdb72a4738b ]

When `in` allocated by kvzalloc fails, arfs_create_groups will free
ft->g and return an error. However, arfs_create_table, the only caller of
arfs_create_groups, will hold this error and call to
mlx5e_destroy_flow_table, in which the ft->g will be freed again.

Fixes: 1cabe6b0965e ("net/mlx5e: Create aRFS flow tables")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c | 26 +++++++++++--------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index b75074d8d22b..18c2abbe0b7e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -227,11 +227,13 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 
 	ft->g = kcalloc(MLX5E_ARFS_NUM_GROUPS,
 			sizeof(*ft->g), GFP_KERNEL);
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if  (!in || !ft->g) {
-		kfree(ft->g);
-		kvfree(in);
+	if (!ft->g)
 		return -ENOMEM;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in) {
+		err = -ENOMEM;
+		goto err_free_g;
 	}
 
 	mc = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
@@ -251,7 +253,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 		break;
 	default:
 		err = -EINVAL;
-		goto out;
+		goto err_free_in;
 	}
 
 	switch (type) {
@@ -273,7 +275,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 		break;
 	default:
 		err = -EINVAL;
-		goto out;
+		goto err_free_in;
 	}
 
 	MLX5_SET_CFG(in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
@@ -282,7 +284,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 	MLX5_SET_CFG(in, end_flow_index, ix - 1);
 	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
 	if (IS_ERR(ft->g[ft->num_groups]))
-		goto err;
+		goto err_clean_group;
 	ft->num_groups++;
 
 	memset(in, 0, inlen);
@@ -291,18 +293,20 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 	MLX5_SET_CFG(in, end_flow_index, ix - 1);
 	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
 	if (IS_ERR(ft->g[ft->num_groups]))
-		goto err;
+		goto err_clean_group;
 	ft->num_groups++;
 
 	kvfree(in);
 	return 0;
 
-err:
+err_clean_group:
 	err = PTR_ERR(ft->g[ft->num_groups]);
 	ft->g[ft->num_groups] = NULL;
-out:
+err_free_in:
 	kvfree(in);
-
+err_free_g:
+	kfree(ft->g);
+	ft->g = NULL;
 	return err;
 }
 
-- 
2.43.0



