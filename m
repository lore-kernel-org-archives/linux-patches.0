Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09352F6186;
	Tue, 11 Nov 2025 01:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825415; cv=none; b=AYO+JN+X8WpqhzY24w3YJY8hlIUunu1MSpgJydJkzzK9W25ZwERsXN4Q+wH4Z1LGGtvVWsARS74RC5LzobCRhDBaUFr2PpmNDiiy45+zv6VjpGsi964gW8ZUWUfkZOUgBenTEqCamo34+gHdTjylmMbl6soCKNjirzvD9bFD+VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825415; c=relaxed/simple;
	bh=m1sLZtZ2RwcVa/BdA6Ncov+ar8ZkgNLr7gkGZ+z688w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhEpDxqUpaByVDVLnGQN3DFJyYIJvKQQ7tDbO2Sq9gfck8G8cMz5fvjF/FoXYg0hUt8maKeD+4QKTMzaxDJK0Ai9pN+dZ7qoViJhzYY5+u6HHZszIV8udWLip6ywJc/Wb4K9ZHEdz6BwbtXxOmo0GDGBZCkL+ZxgUh6ZZwCf5D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqGE27Ia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqGE27Ia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2F1C19424;
	Tue, 11 Nov 2025 01:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825414;
	bh=m1sLZtZ2RwcVa/BdA6Ncov+ar8ZkgNLr7gkGZ+z688w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqGE27Iaq7bM+kJSVD5f7DSF3cE+Rt44RjKJ5nvw+/tU++pVKi/etzmiornPRKR9Y
	 hrx9FGtAvfpH4PEQ0FEAbvIvYN6KgfGO/vZyD0RLlDiVfEh40wcNUfPJ7W9dTChXU6
	 1h/zmqwqL6UhE2zRNK2DIb5CmnZP2Myqw6SRbNj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 791/849] net/mlx5e: SHAMPO, Fix header mapping for 64K pages
Date: Tue, 11 Nov 2025 09:46:01 +0900
Message-ID: <20251111004555.554777770@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 665a7e13c220bbde55531a24bd5524320648df10 ]

HW-GRO is broken on mlx5 for 64K page sizes. The patch in the fixes tag
didn't take into account larger page sizes when doing an align down
of max_ksm_entries. For 64K page size, max_ksm_entries is 0 which will skip
mapping header pages via WQE UMR. This breaks header-data split
and will result in the following syndrome:

mlx5_core 0000:00:08.0 eth2: Error cqe on cqn 0x4c9, ci 0x0, qn 0x1133, opcode 0xe, syndrome 0x4, vendor syndrome 0x32
00000000: 00 00 00 00 04 4a 00 00 00 00 00 00 20 00 93 32
00000010: 55 00 00 00 fb cc 00 00 00 00 00 00 07 18 00 00
00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4a
00000030: 00 00 3b c7 93 01 32 04 00 00 00 00 00 00 bf e0
mlx5_core 0000:00:08.0 eth2: ERR CQE on RQ: 0x1133

Furthermore, the function that fills in WQE UMRs for the headers
(mlx5e_build_shampo_hd_umr()) only supports mapping page sizes that
fit in a single UMR WQE.

This patch goes back to the old non-aligned max_ksm_entries value and it
changes mlx5e_build_shampo_hd_umr() to support mapping a large page over
multiple UMR WQEs.

This means that mlx5e_build_shampo_hd_umr() can now leave a page only
partially mapped. The caller, mlx5e_alloc_rx_hd_mpwqe(), ensures that
there are enough UMR WQEs to cover complete pages by working on
ksm_entries that are multiples of MLX5E_SHAMPO_WQ_HEADER_PER_PAGE.

Fixes: 8a0ee54027b1 ("net/mlx5e: SHAMPO, Simplify UMR allocation for headers")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1762238915-1027590-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 36 +++++++++----------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 5dbf48da2f4f1..f19e94884a52e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -670,7 +670,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 	u16 pi, header_offset, err, wqe_bbs;
 	u32 lkey = rq->mdev->mlx5e_res.hw_objs.mkey;
 	struct mlx5e_umr_wqe *umr_wqe;
-	int headroom, i = 0;
+	int headroom, i;
 
 	headroom = rq->buff.headroom;
 	wqe_bbs = MLX5E_KSM_UMR_WQEBBS(ksm_entries);
@@ -678,25 +678,24 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 	umr_wqe = mlx5_wq_cyc_get_wqe(&sq->wq, pi);
 	build_ksm_umr(sq, umr_wqe, shampo->mkey_be, index, ksm_entries);
 
-	WARN_ON_ONCE(ksm_entries & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1));
-	while (i < ksm_entries) {
-		struct mlx5e_frag_page *frag_page = mlx5e_shampo_hd_to_frag_page(rq, index);
+	for (i = 0; i < ksm_entries; i++, index++) {
+		struct mlx5e_frag_page *frag_page;
 		u64 addr;
 
-		err = mlx5e_page_alloc_fragmented(rq->hd_page_pool, frag_page);
-		if (unlikely(err))
-			goto err_unmap;
+		frag_page = mlx5e_shampo_hd_to_frag_page(rq, index);
+		header_offset = mlx5e_shampo_hd_offset(index);
+		if (!header_offset) {
+			err = mlx5e_page_alloc_fragmented(rq->hd_page_pool,
+							  frag_page);
+			if (err)
+				goto err_unmap;
+		}
 
 		addr = page_pool_get_dma_addr_netmem(frag_page->netmem);
-
-		for (int j = 0; j < MLX5E_SHAMPO_WQ_HEADER_PER_PAGE; j++) {
-			header_offset = mlx5e_shampo_hd_offset(index++);
-
-			umr_wqe->inline_ksms[i++] = (struct mlx5_ksm) {
-				.key = cpu_to_be32(lkey),
-				.va  = cpu_to_be64(addr + header_offset + headroom),
-			};
-		}
+		umr_wqe->inline_ksms[i] = (struct mlx5_ksm) {
+			.key = cpu_to_be32(lkey),
+			.va  = cpu_to_be64(addr + header_offset + headroom),
+		};
 	}
 
 	sq->db.wqe_info[pi] = (struct mlx5e_icosq_wqe_info) {
@@ -712,7 +711,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 	return 0;
 
 err_unmap:
-	while (--i) {
+	while (--i >= 0) {
 		--index;
 		header_offset = mlx5e_shampo_hd_offset(index);
 		if (!header_offset) {
@@ -734,8 +733,7 @@ static int mlx5e_alloc_rx_hd_mpwqe(struct mlx5e_rq *rq)
 	struct mlx5e_icosq *sq = rq->icosq;
 	int i, err, max_ksm_entries, len;
 
-	max_ksm_entries = ALIGN_DOWN(MLX5E_MAX_KSM_PER_WQE(rq->mdev),
-				     MLX5E_SHAMPO_WQ_HEADER_PER_PAGE);
+	max_ksm_entries = MLX5E_MAX_KSM_PER_WQE(rq->mdev);
 	ksm_entries = bitmap_find_window(shampo->bitmap,
 					 shampo->hd_per_wqe,
 					 shampo->hd_per_wq, shampo->pi);
-- 
2.51.0



