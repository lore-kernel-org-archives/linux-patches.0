Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755021836EF;
	Wed,  3 Jul 2024 11:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004901; cv=none; b=jDYziieN3QI60MNDm/6vmqDfTtCxyZY7a2GYbm53tP7gjQvPXJCv0elVqcrO7P8SseQJK3AqnoMO+Q/cOjzt2gHxFbPnkN/m+QxVMkX0IcwQ5EKZ0/CCsceH2BRN9IlRuWu8dewV97x3URrN8d1D2LH+nTB6XqpTBnK5uP+86BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004901; c=relaxed/simple;
	bh=o9QhYoc1ZA3kR5ugnhBG/se6TljkD8WrqbuqBcSsW3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6LjezaU9itR3zH22/EP8qON8yLti6nSClsek5s8uTCtWQxiJh/9rZdUU2SEYyqTe1OlsHNM/h+AWvF/kp0+gsFM4BWZnSmKl/B9uvGE3TB7IkDxC5EJs4Z2HmhvMukOOiZ43+hh8oSlOBt6WRtXHQCl4HZQ5C8XEGB5LTBSqZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1LJrOxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1LJrOxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01B0C2BD10;
	Wed,  3 Jul 2024 11:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004901;
	bh=o9QhYoc1ZA3kR5ugnhBG/se6TljkD8WrqbuqBcSsW3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1LJrOxkjAiWqT8oh+H4h1HNSn7IV+Eh9rCuFcYegLrtu5dJivz+Wn0qk9jnA8hyt
	 DM9iUq3a/+TFnQhE5lUohPK8DvwEulyTYIqonNQmJwwNpP+z9Q+Ix23WilIOb1S84E
	 Xkn11FYw7dqfvcR9PnuxEicQR87Xc5OLoBh1/LVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/290] RDMA/mlx5: Add check for srq max_sge attribute
Date: Wed,  3 Jul 2024 12:39:04 +0200
Message-ID: <20240703102910.334962671@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 36ab7ada64caf08f10ee5a114d39964d1f91e81d ]

max_sge attribute is passed by the user, and is inserted and used
unchecked, so verify that the value doesn't exceed maximum allowed value
before using it.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Link: https://lore.kernel.org/r/277ccc29e8d57bfd53ddeb2ac633f2760cf8cdd0.1716900410.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/srq.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -225,12 +225,15 @@ int mlx5_ib_create_srq(struct ib_srq *ib
 	int err;
 	struct mlx5_srq_attr in = {};
 	__u32 max_srq_wqes = 1 << MLX5_CAP_GEN(dev->mdev, log_max_srq_sz);
+	__u32 max_sge_sz =  MLX5_CAP_GEN(dev->mdev, max_wqe_sz_rq) /
+			    sizeof(struct mlx5_wqe_data_seg);
 
-	/* Sanity check SRQ size before proceeding */
-	if (init_attr->attr.max_wr >= max_srq_wqes) {
-		mlx5_ib_dbg(dev, "max_wr %d, cap %d\n",
-			    init_attr->attr.max_wr,
-			    max_srq_wqes);
+	/* Sanity check SRQ and sge size before proceeding */
+	if (init_attr->attr.max_wr >= max_srq_wqes ||
+	    init_attr->attr.max_sge > max_sge_sz) {
+		mlx5_ib_dbg(dev, "max_wr %d,wr_cap %d,max_sge %d, sge_cap:%d\n",
+			    init_attr->attr.max_wr, max_srq_wqes,
+			    init_attr->attr.max_sge, max_sge_sz);
 		return -EINVAL;
 	}
 


