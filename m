Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E0626A0B3;
	Tue,  8 Apr 2025 11:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113226; cv=none; b=U5TgsTWrPCT04AkY1eKmpkjuNtlk7d7EHRRgyffzoDMxMS5Z/zpT6qizF5Xew8HxeuJmbO9l+BmYZwwBEHv1PL7ltZSqtN7c8clULh2rfEv/oLDleyl+tJ2J5Pv0E/QQbcLhexFf/k/+yhcDrbqWwqgGmu+/cKHAJlvzFRJEZtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113226; c=relaxed/simple;
	bh=0KPKSbzD4dbCNBjOAOhxwLBExqK9HPRG+ZyXt9KigA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naBA3m+ldaTxxxU3ZWYHuhNXpHZe7HKCwUMBo5PGVT+UeKLOliXmIUtUFLHohyyKNuYnMPOnuZf1JD1fWIwpuundgbEdeRzw0n2kp7fSWEAm8npQmw496wGRmcA6O+9GLzgzJwLirbv9cE+t2CXx7EEafUcoSCPNIq9+QBhcQIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOSe5pUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOSe5pUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1FEC4CEE5;
	Tue,  8 Apr 2025 11:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113225;
	bh=0KPKSbzD4dbCNBjOAOhxwLBExqK9HPRG+ZyXt9KigA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOSe5pUvoz8N5PJ/ZA2j+FeYekh4OX2ZJ7eNInvDyxK0D9PfeH6MsTHRh9ryryBLC
	 lALk/4hi4DVyWoFQQp5TDvoI/yOc8krFPt2dgO8kCE0XHjCG6M60IDZGxFDAQLFajF
	 CO16vn3A08+J8S0N8icT3P7xhqZm1/6SmEsMbaPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/268] RDMA/mlx5: Fix calculation of total invalidated pages
Date: Tue,  8 Apr 2025 12:48:12 +0200
Message-ID: <20250408104830.683120687@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

From: Chiara Meiohas <cmeiohas@nvidia.com>

[ Upstream commit 79195147644653ebffadece31a42181e4c48c07d ]

When invalidating an address range in mlx5, there is an optimization to
do UMR operations in chunks.
Previously, the invalidation counter was incorrectly updated for the
same indexes within a chunk. Now, the invalidation counter is updated
only when a chunk is complete and mlx5r_umr_update_xlt() is called.
This ensures that the counter accurately represents the number of pages
invalidated using UMR.

Fixes: a3de94e3d61e ("IB/mlx5: Introduce ODP diagnostic counters")
Signed-off-by: Chiara Meiohas <cmeiohas@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/560deb2433318e5947282b070c915f3c81fef77f.1741875692.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index f1a0a324223c0..7ad5db46ffce7 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -274,9 +274,6 @@ static bool mlx5_ib_invalidate_range(struct mmu_interval_notifier *mni,
 				blk_start_idx = idx;
 				in_block = 1;
 			}
-
-			/* Count page invalidations */
-			invalidations += idx - blk_start_idx + 1;
 		} else {
 			u64 umr_offset = idx & umr_block_mask;
 
@@ -286,14 +283,19 @@ static bool mlx5_ib_invalidate_range(struct mmu_interval_notifier *mni,
 						     MLX5_IB_UPD_XLT_ZAP |
 						     MLX5_IB_UPD_XLT_ATOMIC);
 				in_block = 0;
+				/* Count page invalidations */
+				invalidations += idx - blk_start_idx + 1;
 			}
 		}
 	}
-	if (in_block)
+	if (in_block) {
 		mlx5r_umr_update_xlt(mr, blk_start_idx,
 				     idx - blk_start_idx + 1, 0,
 				     MLX5_IB_UPD_XLT_ZAP |
 				     MLX5_IB_UPD_XLT_ATOMIC);
+		/* Count page invalidations */
+		invalidations += idx - blk_start_idx + 1;
+	}
 
 	mlx5_update_odp_stats(mr, invalidations, invalidations);
 
-- 
2.39.5



