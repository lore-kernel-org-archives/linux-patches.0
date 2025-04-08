Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA0E268FED;
	Tue,  8 Apr 2025 12:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115691; cv=none; b=PCp6jN3uNSxaCX4YcQdNoH6IqYZF9tV9U6X98FcxdDgRloDT0Gxh661OG+pEe5vuoWAE3P6yzkatCy1jRZ9xiSj4v5z+I5rYGiGAbXGu4U5/PQmSnZzco5Q1qts8dCcQrsq2xACLRUjonoYMV8xx8gKykmLjskcpmFP9GcQQt1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115691; c=relaxed/simple;
	bh=exINIggIh+T/u0yM/FvwqOIa8NxVewEToXpNnxDuyWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RC1hQl7yF9pXv7uW0oOB/pjDDc+Npe1DukX+FpUiOYhIKYFkgW9loX3TyQhsnGNTz948+ldYkXLBqTI/MoW8JKQ+rUwXgjdPoa1TgcVcf1cBqp74UkisB4tQH9FgwhMEcuax4eRHphHwdyXTU+j4EHJWlv37bdLiQcQeDpBs04M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZ/h6ufW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZ/h6ufW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCBFC4CEE5;
	Tue,  8 Apr 2025 12:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115691;
	bh=exINIggIh+T/u0yM/FvwqOIa8NxVewEToXpNnxDuyWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZ/h6ufWWsJwKhOHOW7rDKn4QPg0BW+HL3GhIVQWuwutBYMVZgtZHTb35+08IxOXC
	 aoEYKlNDJCcTE88YTDFpSLsRID9XdCNSInDOZsNP/oPyK5jn5UxdnJt3sMGSe03km5
	 cprtzb+BTC4pac4CzBrp2z3vRtaDItjOL2HAOIx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/204] RDMA/mlx5: Fix calculation of total invalidated pages
Date: Tue,  8 Apr 2025 12:49:57 +0200
Message-ID: <20250408104822.328884926@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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
index 87fbee8061003..89682fe0747ff 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -275,9 +275,6 @@ static bool mlx5_ib_invalidate_range(struct mmu_interval_notifier *mni,
 				blk_start_idx = idx;
 				in_block = 1;
 			}
-
-			/* Count page invalidations */
-			invalidations += idx - blk_start_idx + 1;
 		} else {
 			u64 umr_offset = idx & umr_block_mask;
 
@@ -287,14 +284,19 @@ static bool mlx5_ib_invalidate_range(struct mmu_interval_notifier *mni,
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



