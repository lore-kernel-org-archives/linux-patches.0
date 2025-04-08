Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46DE268C72;
	Tue,  8 Apr 2025 11:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111331; cv=none; b=sra/xm5TQGMT2oRnRZtNQW7NMGRHNYyLj6KTtDKX43L2O0w7xJv7E9+KUKRmCjhQvMeY1Ppkv7Blx4Sz89QYtwCviePf1CuiDGdfKasw9CWgoDTGd7UfFpFjpHxhWo7Kpd/m7JITfDnxqWJ4f/+3Lb93uGATGa6TZeubkYzN3eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111331; c=relaxed/simple;
	bh=ENylJU+15PpjtEPQ5fh/HdXjjyt2g6UZr7hqrgzOtUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDv5CPQLRotbx2PwuyrDXWWH/VsIHCkzPvfpHloviSXbBcGCIaXNwwyKMPITVWvwkFn3PsSqtvIrni9S4Uu14rFbpsjfGnRpC6LYHzVaD93/CwnwSP2LhlZYkEB2yi7e+VybCvDxBcRI9CSe14XznSIyF5ahE3EofqfIoelMe1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4u8BWG1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4u8BWG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A81C4CEE7;
	Tue,  8 Apr 2025 11:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111331;
	bh=ENylJU+15PpjtEPQ5fh/HdXjjyt2g6UZr7hqrgzOtUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4u8BWG1h1g9m7hh6nD4JPRbaDry8Gd9uBjrkGIR1nJnlL7N+JrD9Sl9vcRFI3SYb
	 YDwCUisGhLpdSjKLlMQIFRxELbbre45TIHUPC+AMGTSlDlx+wrPo4JItOuda8HOpfo
	 qB57sP/CVAALKKqVH+dfsASPBNkpmfhDzwfoxQLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 394/731] RDMA/mlx5: Fix calculation of total invalidated pages
Date: Tue,  8 Apr 2025 12:44:51 +0200
Message-ID: <20250408104923.439287358@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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
index e77c9280c07e4..86d8fa63bf691 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -309,9 +309,6 @@ static bool mlx5_ib_invalidate_range(struct mmu_interval_notifier *mni,
 				blk_start_idx = idx;
 				in_block = 1;
 			}
-
-			/* Count page invalidations */
-			invalidations += idx - blk_start_idx + 1;
 		} else {
 			u64 umr_offset = idx & umr_block_mask;
 
@@ -321,14 +318,19 @@ static bool mlx5_ib_invalidate_range(struct mmu_interval_notifier *mni,
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
 
 	mlx5_update_odp_stats_with_handled(mr, invalidations, invalidations);
 
-- 
2.39.5



