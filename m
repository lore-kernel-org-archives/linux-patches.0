Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBB02505A7;
	Wed,  5 Mar 2025 17:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197276; cv=none; b=uYVfCzBN1Um/RTwxcZnOMgg9c/WCkIH6qvUfkTOGK5k+XXiWOyBp6zaI7srJ5gbTuZyd/O0L3jbbhoJR2wfHXe1PIKFXT3z7SXAGlCJFyNtR+EXeIavuDORfOri3DxfyqVRZ4yqgwhXMEFNvPrbLbpMZNRVb8GdrjrurKdKmt2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197276; c=relaxed/simple;
	bh=X2tAiaB/A2H+vreCEMyg06gnGNEc+ktRzqEXFRXnViM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIio80ffKkahKKS6pp0eKdVoZ6fDBB1u3RFALph/eAZs8Y0VO9GVNDohiWdvS0IEYMQ5BaNUrbXYBuZVnVglNffcVF9QjjmowyLCEc2yDoGToMWgDPeVKbOtPCqp5dX9hh9HAuIixBUq/FW5SxQFkYM0KybdmkGU2zAHxJ0lpSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orT2PQzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orT2PQzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFB7C4CED1;
	Wed,  5 Mar 2025 17:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197273;
	bh=X2tAiaB/A2H+vreCEMyg06gnGNEc+ktRzqEXFRXnViM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=orT2PQzocFuiyZ3/2LBI1d+/nbgPW+g8eGZ6BTKu7eYdSvmDuBxfB08idVWI7Ox0h
	 VKa1A2djevGbSZ386Sfbdt4l5NM3Pci0zRN1DpkUaaWeX5XmabN8wHmWjX1PkCiBQo
	 Yj8MzRXhm72kjBdq4GVd6jgb+cpL2rpL1vb2+1GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aharon Landau <aharonl@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/176] RDMA/mlx5: Remove implicit ODP cache entry
Date: Wed,  5 Mar 2025 18:47:47 +0100
Message-ID: <20250305174509.396902593@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aharon Landau <aharonl@nvidia.com>

[ Upstream commit 18b1746bddf5e7f6b2618966596d9517172a5cd7 ]

Implicit ODP mkey doesn't have unique properties. It shares the same
properties as the order 18 cache entry. There is no need to devote a
special entry for that.

Link: https://lore.kernel.org/r/20230125222807.6921-3-michaelgur@nvidia.com
Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: d97505baea64 ("RDMA/mlx5: Fix the recovery flow of the UMR QP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 20 +++++---------------
 include/linux/mlx5/driver.h      |  1 -
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index a5c9baec8be85..5f0a17382de73 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -406,6 +406,7 @@ static void mlx5_ib_page_fault_resume(struct mlx5_ib_dev *dev,
 static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 						unsigned long idx)
 {
+	int order = order_base_2(MLX5_IMR_MTT_ENTRIES);
 	struct mlx5_ib_dev *dev = mr_to_mdev(imr);
 	struct ib_umem_odp *odp;
 	struct mlx5_ib_mr *mr;
@@ -418,7 +419,8 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 	if (IS_ERR(odp))
 		return ERR_CAST(odp);
 
-	mr = mlx5_mr_cache_alloc(dev, &dev->cache.ent[MLX5_IMR_MTT_CACHE_ENTRY],
+	BUILD_BUG_ON(order > MKEY_CACHE_LAST_STD_ENTRY);
+	mr = mlx5_mr_cache_alloc(dev, &dev->cache.ent[order],
 				 imr->access_flags);
 	if (IS_ERR(mr)) {
 		ib_umem_odp_release(odp);
@@ -1595,20 +1597,8 @@ void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent)
 {
 	if (!(ent->dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
 		return;
-
-	switch (ent->order - 2) {
-	case MLX5_IMR_MTT_CACHE_ENTRY:
-		ent->ndescs = MLX5_IMR_MTT_ENTRIES;
-		ent->access_mode = MLX5_MKC_ACCESS_MODE_MTT;
-		ent->limit = 0;
-		break;
-
-	case MLX5_IMR_KSM_CACHE_ENTRY:
-		ent->ndescs = mlx5_imr_ksm_entries;
-		ent->access_mode = MLX5_MKC_ACCESS_MODE_KSM;
-		ent->limit = 0;
-		break;
-	}
+	ent->ndescs = mlx5_imr_ksm_entries;
+	ent->access_mode = MLX5_MKC_ACCESS_MODE_KSM;
 }
 
 static const struct ib_device_ops mlx5_ib_dev_odp_ops = {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 3c3e0f26c2446..6cea62ca76d6b 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -744,7 +744,6 @@ enum {
 
 enum {
 	MKEY_CACHE_LAST_STD_ENTRY = 20,
-	MLX5_IMR_MTT_CACHE_ENTRY,
 	MLX5_IMR_KSM_CACHE_ENTRY,
 	MAX_MKEY_CACHE_ENTRIES
 };
-- 
2.39.5



