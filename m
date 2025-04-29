Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97E72459FA;
	Tue, 29 Apr 2025 16:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945814; cv=none; b=BCenmbvn3UXuFibZnt7sCgdZ/gdnxWKeRJQk33oI1A/oD6F3eknLrJp+ToACjXlipewH6N3j6zvoxq4A1bHSBKg0grCgzyJzBMGRaEL4QA8XiKPE7WLgsS8UC0V1zYk9L8WmHejZ7G15Zw1T2+WBCqBsPzUm4mZUSkrgH6sxa/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945814; c=relaxed/simple;
	bh=EbFb0twjB33FdfI6fzOzOo/IVTjY5cXpKGrhybxx0NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCRWWS3HDo6vls0qBSDXzL/tWjTPOwPHxCZzLpIQduLKyKzzYbekpqc5SE0vUrHVthxNQkDb6b7K/FnASsd9f2R5odrpYGdL3+6LGQwB4ATOEdb6kZLx0WywO//b+/tDZIKAzHiyDJdMrdysSIiNoDMFegRAu5+R6GheuGvdJ8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q44nYq5g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q44nYq5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587B2C4CEE3;
	Tue, 29 Apr 2025 16:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945814;
	bh=EbFb0twjB33FdfI6fzOzOo/IVTjY5cXpKGrhybxx0NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q44nYq5g6HcCueGowSBSiz9ZyOigdurfPJNWQVbfYhZzqf4FsNh0sssXkYsh6HxhW
	 hRQ5E6Zk9oDznV+TRfrSSWiMQ1HGAqILn5V0XVWkeUZi29jeIcRF0oMAx487CtEeu2
	 WwBR+2sb+wzmYUf3Z8a3IG0EFht++7NNmKHj1AOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 051/311] net/mlx5: Move ttc allocation after switch case to prevent leaks
Date: Tue, 29 Apr 2025 18:38:08 +0200
Message-ID: <20250429161123.123395429@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit fa8fd315127ca48c65e7e6692a84ffcf3d07168e ]

Relocate the memory allocation for ttc table after the switch statement
that validates params->ns_type in both mlx5_create_inner_ttc_table() and
mlx5_create_ttc_table(). This ensures memory is only allocated after
confirming valid input, eliminating potential memory leaks when invalid
ns_type cases occur.

Fixes: 137f3d50ad2a ("net/mlx5: Support matching on l4_type for ttc_table")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250418023814.71789-3-bsdhenrymartin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
index 510879e1ba30e..43b2216bc0a22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
@@ -618,10 +618,6 @@ struct mlx5_ttc_table *mlx5_create_inner_ttc_table(struct mlx5_core_dev *dev,
 	bool use_l4_type;
 	int err;
 
-	ttc = kvzalloc(sizeof(*ttc), GFP_KERNEL);
-	if (!ttc)
-		return ERR_PTR(-ENOMEM);
-
 	switch (params->ns_type) {
 	case MLX5_FLOW_NAMESPACE_PORT_SEL:
 		use_l4_type = MLX5_CAP_GEN_2(dev, pcc_ifa2) &&
@@ -635,6 +631,10 @@ struct mlx5_ttc_table *mlx5_create_inner_ttc_table(struct mlx5_core_dev *dev,
 		return ERR_PTR(-EINVAL);
 	}
 
+	ttc = kvzalloc(sizeof(*ttc), GFP_KERNEL);
+	if (!ttc)
+		return ERR_PTR(-ENOMEM);
+
 	ns = mlx5_get_flow_namespace(dev, params->ns_type);
 	if (!ns) {
 		kvfree(ttc);
@@ -696,10 +696,6 @@ struct mlx5_ttc_table *mlx5_create_ttc_table(struct mlx5_core_dev *dev,
 	bool use_l4_type;
 	int err;
 
-	ttc = kvzalloc(sizeof(*ttc), GFP_KERNEL);
-	if (!ttc)
-		return ERR_PTR(-ENOMEM);
-
 	switch (params->ns_type) {
 	case MLX5_FLOW_NAMESPACE_PORT_SEL:
 		use_l4_type = MLX5_CAP_GEN_2(dev, pcc_ifa2) &&
@@ -713,6 +709,10 @@ struct mlx5_ttc_table *mlx5_create_ttc_table(struct mlx5_core_dev *dev,
 		return ERR_PTR(-EINVAL);
 	}
 
+	ttc = kvzalloc(sizeof(*ttc), GFP_KERNEL);
+	if (!ttc)
+		return ERR_PTR(-ENOMEM);
+
 	ns = mlx5_get_flow_namespace(dev, params->ns_type);
 	if (!ns) {
 		kvfree(ttc);
-- 
2.39.5



