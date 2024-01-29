Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D32C15B305;
	Mon, 29 Jan 2024 17:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548556; cv=none; b=vDY1WgxCL0TkyiR63dwaSA5YZoU0vayk4uGsTNPHx2a2vjG81AX+emUpUrIr3u/zJvRMo3lzn/3t3kWmNkQK/j9ZHkmIhlmECbxkSXnoJ3FfxcuPQaHHx6pcZPzemMjqTFRJKbLKGzPGLfZv/2AkvuEH6tGeamPpd9rksjYefSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548556; c=relaxed/simple;
	bh=aDtB0gWN9n8TLkSDJjIvJgaB7xTiFHh5OzsYsuY62aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sB5E8sTcQjxq3f0G8oYUtHCOEuzL3uI7BnzEv0y93uj7naDUPi/2SH6dOl0aoj38tmhKbCK87qRVZ9cxwtyJJRhE2BVymvX3+NVnaIGn+v5sjFo9cMu05ulEYINTIaX9hfxkSG+9UaA77r/s1BmctM0WGHjGuwknvTh82uJHkps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/4pufRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/4pufRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F20C433C7;
	Mon, 29 Jan 2024 17:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548556;
	bh=aDtB0gWN9n8TLkSDJjIvJgaB7xTiFHh5OzsYsuY62aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/4pufRXlKzpHPtyhCO1xG2gVjvNWd8OHlaTV/TCv0bWdAFo2eAcJY16t6LzTmLNW
	 LRxIDOwJIfKKQx7VKkJBacZNZ/fs3A1K9m7S361rRmsxug/RgLwvxdD3s1EK7UT7b9
	 s8Af8evwVdZPwS2kKDDfv9qTP4ValXQYKORXFIpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 202/331] net/mlx5e: fix a double-free in arfs_create_groups
Date: Mon, 29 Jan 2024 09:04:26 -0800
Message-ID: <20240129170020.788635118@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bb7f86c993e5..e66f486faafe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -254,11 +254,13 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 
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
@@ -278,7 +280,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 		break;
 	default:
 		err = -EINVAL;
-		goto out;
+		goto err_free_in;
 	}
 
 	switch (type) {
@@ -300,7 +302,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 		break;
 	default:
 		err = -EINVAL;
-		goto out;
+		goto err_free_in;
 	}
 
 	MLX5_SET_CFG(in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
@@ -309,7 +311,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 	MLX5_SET_CFG(in, end_flow_index, ix - 1);
 	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
 	if (IS_ERR(ft->g[ft->num_groups]))
-		goto err;
+		goto err_clean_group;
 	ft->num_groups++;
 
 	memset(in, 0, inlen);
@@ -318,18 +320,20 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
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



