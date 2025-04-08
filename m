Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BF526B953;
	Tue,  8 Apr 2025 12:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114594; cv=none; b=S4LX1pGIkZGIVL/CvtwYxv7K5eBaP0kD2SQhNoSVdl4vhMjb6E+Y3/WpK5YOBRI/4/Od/g3Hov6PFXUNeO2CLuts/cmvzpF9tjEKsKe7Cdx322OEosguM0vfIIvMF6waNiCvDmSenDQ7HWr+aBxx7Gh0G3nKofBypg+1xzW+gRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114594; c=relaxed/simple;
	bh=sbS485/cz2ULhwOzANgvUfPpJPBjeTH6JzyVNJtzx+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHV1GLmKObYp/2UdX7gnfMAfRDF5X4Rl6r9Cmt1i0gumv3vTWbAXZqKaQmNrRdNPYwy13VogzDUhR5jnmhOOZiZ8LASC6NFJSUhvnMaVy1ugZGN5It9ibtdwZeK+Dy8mFQbfX5jeFVcJXvMANSBITVTy3iQ5fmOsOXpV0YuUS2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0J9TegF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0J9TegF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E2CC4CEEA;
	Tue,  8 Apr 2025 12:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114594;
	bh=sbS485/cz2ULhwOzANgvUfPpJPBjeTH6JzyVNJtzx+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0J9TegFiGtgK/+3In6wkbaCxHLjqY/AMiVyfmnmFj4SCX57wRX2d8AJXwKtQFNfd
	 9MgGXB0yhgfK56cW8WT6JKCSIZtmun7y3arUTIGsjxJw0IzKcVNcqBtTlnsbZZNnoV
	 QkDkF/YhJQ80hM9wqbmVrcnVJfAKdmYTO01fncEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 163/499] RDMA/mlx5: Fix calculation of total invalidated pages
Date: Tue,  8 Apr 2025 12:46:15 +0200
Message-ID: <20250408104855.246692971@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index b4e2a6f9cb9c3..e158d5b1ab17b 100644
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
 
 	mlx5_update_odp_stats(mr, invalidations, invalidations);
 
-- 
2.39.5



