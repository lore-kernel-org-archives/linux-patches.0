Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53483331A4C;
	Tue, 11 Nov 2025 01:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825419; cv=none; b=h1yBFqY0HwLSGF2pxIxCtDGU3owYUhWLpjamEmzDzlJ2VfYobfgCBtNvIZHFGRrVk8Uo5xb39ez1HMFyKW2mfS7ahBPU6xZzxO5xNYOsZ2e5sfXU9Tlrm7ANeVXpUIFA+9IenMUNWbR95yWNxsgvHBkxL7OhRnjisAoLvr0F7K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825419; c=relaxed/simple;
	bh=AWKZqMswZgiEeiW8pMzWe7A7lUxleg6c00JN2+2D02E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukXW4gTy/tta3aiN/OXp+KenQo3B2jBtyKRf6VyYynN/RU5qD0MeY5gaXRFmt8sZ57QJPbfk8YxlYXRRAgiW5HGvtb3XDShDG/XEMmrNSb/bJ2aVsGf4Tkl5VtBKTdeJvy/SkuSbzMF6IzBbV0/oUznkwMSfGR1c2afoe2BKOWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GR4gy99D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GR4gy99D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6419C19422;
	Tue, 11 Nov 2025 01:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825419;
	bh=AWKZqMswZgiEeiW8pMzWe7A7lUxleg6c00JN2+2D02E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GR4gy99D8Vu8H8DhXJM2zPbnyWQKIVRiyCg37mMHxi60OcObIaCscx5AL/srjgwJF
	 S1c1ABhKntPbVrg7FHTSjoVG+wRMss0DgEib3uydNz9ze3MKHCPbedIrC5kUdFHDiQ
	 HCz7+b9wZeECrQ4dC5FJx58iHEJ4NmQ1ULrFit6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 793/849] net/mlx5e: SHAMPO, Fix header formulas for higher MTUs and 64K pages
Date: Tue, 11 Nov 2025 09:46:03 +0900
Message-ID: <20251111004555.604861360@linuxfoundation.org>
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

[ Upstream commit d8a7ed9586c7579a99e9e2d90988c9eceeee61ff ]

The MLX5E_SHAMPO_WQ_HEADER_PER_PAGE and
MLX5E_SHAMPO_LOG_MAX_HEADER_ENTRY_SIZE macros are used directly in
several places under the assumption that there will always be more
headers per WQE than headers per page. However, this assumption doesn't
hold for 64K page sizes and higher MTUs (> 4K). This can be first
observed during header page allocation: ksm_entries will become 0 during
alignment to MLX5E_SHAMPO_WQ_HEADER_PER_PAGE.

This patch introduces 2 additional members to the mlx5e_shampo_hd struct
which are meant to be used instead of the macrose mentioned above.
When the number of headers per WQE goes below
MLX5E_SHAMPO_WQ_HEADER_PER_PAGE, clamp the number of headers per
page and expand the header size accordingly so that the headers
for one WQE cover a full page.

All the formulas are adapted to use these two new members.

Fixes: 945ca432bfd0 ("net/mlx5e: SHAMPO, Drop info array")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1762238915-1027590-4-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  3 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 24 +++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 33 +++++++++++--------
 3 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0dd3bc0f4caae..ff4a68648e604 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -632,7 +632,10 @@ struct mlx5e_dma_info {
 struct mlx5e_shampo_hd {
 	struct mlx5e_frag_page *pages;
 	u32 hd_per_wq;
+	u32 hd_per_page;
 	u16 hd_per_wqe;
+	u8 log_hd_per_page;
+	u8 log_hd_entry_size;
 	unsigned long *bitmap;
 	u16 pi;
 	u16 ci;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 8a63e62938e73..2c82c5100af3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -793,8 +793,9 @@ static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *mdev,
 				int node)
 {
 	void *wqc = MLX5_ADDR_OF(rqc, rqp->rqc, wq);
+	u8 log_hd_per_page, log_hd_entry_size;
+	u16 hd_per_wq, hd_per_wqe;
 	u32 hd_pool_size;
-	u16 hd_per_wq;
 	int wq_size;
 	int err;
 
@@ -817,11 +818,24 @@ static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *mdev,
 	if (err)
 		goto err_umr_mkey;
 
-	rq->mpwqe.shampo->hd_per_wqe =
-		mlx5e_shampo_hd_per_wqe(mdev, params, rqp);
+	hd_per_wqe = mlx5e_shampo_hd_per_wqe(mdev, params, rqp);
 	wq_size = BIT(MLX5_GET(wq, wqc, log_wq_sz));
-	hd_pool_size = (rq->mpwqe.shampo->hd_per_wqe * wq_size) /
-		MLX5E_SHAMPO_WQ_HEADER_PER_PAGE;
+
+	BUILD_BUG_ON(MLX5E_SHAMPO_LOG_MAX_HEADER_ENTRY_SIZE > PAGE_SHIFT);
+	if (hd_per_wqe >= MLX5E_SHAMPO_WQ_HEADER_PER_PAGE) {
+		log_hd_per_page = MLX5E_SHAMPO_LOG_WQ_HEADER_PER_PAGE;
+		log_hd_entry_size = MLX5E_SHAMPO_LOG_MAX_HEADER_ENTRY_SIZE;
+	} else {
+		log_hd_per_page = order_base_2(hd_per_wqe);
+		log_hd_entry_size = order_base_2(PAGE_SIZE / hd_per_wqe);
+	}
+
+	rq->mpwqe.shampo->hd_per_wqe = hd_per_wqe;
+	rq->mpwqe.shampo->hd_per_page = BIT(log_hd_per_page);
+	rq->mpwqe.shampo->log_hd_per_page = log_hd_per_page;
+	rq->mpwqe.shampo->log_hd_entry_size = log_hd_entry_size;
+
+	hd_pool_size = (hd_per_wqe * wq_size) >> log_hd_per_page;
 
 	if (mlx5_rq_needs_separate_hd_pool(rq)) {
 		/* Separate page pool for shampo headers */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 0dcb4d5b06c8e..56a872c4fafe5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -647,17 +647,20 @@ static void build_ksm_umr(struct mlx5e_icosq *sq, struct mlx5e_umr_wqe *umr_wqe,
 	umr_wqe->hdr.uctrl.mkey_mask     = cpu_to_be64(MLX5_MKEY_MASK_FREE);
 }
 
-static struct mlx5e_frag_page *mlx5e_shampo_hd_to_frag_page(struct mlx5e_rq *rq, int header_index)
+static struct mlx5e_frag_page *mlx5e_shampo_hd_to_frag_page(struct mlx5e_rq *rq,
+							    int header_index)
 {
-	BUILD_BUG_ON(MLX5E_SHAMPO_LOG_MAX_HEADER_ENTRY_SIZE > PAGE_SHIFT);
+	struct mlx5e_shampo_hd *shampo = rq->mpwqe.shampo;
 
-	return &rq->mpwqe.shampo->pages[header_index >> MLX5E_SHAMPO_LOG_WQ_HEADER_PER_PAGE];
+	return &shampo->pages[header_index >> shampo->log_hd_per_page];
 }
 
-static u64 mlx5e_shampo_hd_offset(int header_index)
+static u64 mlx5e_shampo_hd_offset(struct mlx5e_rq *rq, int header_index)
 {
-	return (header_index & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1)) <<
-		MLX5E_SHAMPO_LOG_MAX_HEADER_ENTRY_SIZE;
+	struct mlx5e_shampo_hd *shampo = rq->mpwqe.shampo;
+	u32 hd_per_page = shampo->hd_per_page;
+
+	return (header_index & (hd_per_page - 1)) << shampo->log_hd_entry_size;
 }
 
 static void mlx5e_free_rx_shampo_hd_entry(struct mlx5e_rq *rq, u16 header_index);
@@ -683,7 +686,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 		u64 addr;
 
 		frag_page = mlx5e_shampo_hd_to_frag_page(rq, index);
-		header_offset = mlx5e_shampo_hd_offset(index);
+		header_offset = mlx5e_shampo_hd_offset(rq, index);
 		if (!header_offset) {
 			err = mlx5e_page_alloc_fragmented(rq->hd_page_pool,
 							  frag_page);
@@ -713,7 +716,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 err_unmap:
 	while (--i >= 0) {
 		--index;
-		header_offset = mlx5e_shampo_hd_offset(index);
+		header_offset = mlx5e_shampo_hd_offset(rq, index);
 		if (!header_offset) {
 			struct mlx5e_frag_page *frag_page = mlx5e_shampo_hd_to_frag_page(rq, index);
 
@@ -737,7 +740,7 @@ static int mlx5e_alloc_rx_hd_mpwqe(struct mlx5e_rq *rq)
 	ksm_entries = bitmap_find_window(shampo->bitmap,
 					 shampo->hd_per_wqe,
 					 shampo->hd_per_wq, shampo->pi);
-	ksm_entries = ALIGN_DOWN(ksm_entries, MLX5E_SHAMPO_WQ_HEADER_PER_PAGE);
+	ksm_entries = ALIGN_DOWN(ksm_entries, shampo->hd_per_page);
 	if (!ksm_entries)
 		return 0;
 
@@ -855,7 +858,7 @@ mlx5e_free_rx_shampo_hd_entry(struct mlx5e_rq *rq, u16 header_index)
 {
 	struct mlx5e_shampo_hd *shampo = rq->mpwqe.shampo;
 
-	if (((header_index + 1) & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1)) == 0) {
+	if (((header_index + 1) & (shampo->hd_per_page - 1)) == 0) {
 		struct mlx5e_frag_page *frag_page = mlx5e_shampo_hd_to_frag_page(rq, header_index);
 
 		mlx5e_page_release_fragmented(rq->hd_page_pool, frag_page);
@@ -1218,9 +1221,10 @@ static unsigned int mlx5e_lro_update_hdr(struct sk_buff *skb,
 static void *mlx5e_shampo_get_packet_hd(struct mlx5e_rq *rq, u16 header_index)
 {
 	struct mlx5e_frag_page *frag_page = mlx5e_shampo_hd_to_frag_page(rq, header_index);
-	u16 head_offset = mlx5e_shampo_hd_offset(header_index) + rq->buff.headroom;
+	u16 head_offset = mlx5e_shampo_hd_offset(rq, header_index);
+	void *addr = netmem_address(frag_page->netmem);
 
-	return netmem_address(frag_page->netmem) + head_offset;
+	return addr + head_offset + rq->buff.headroom;
 }
 
 static void mlx5e_shampo_update_ipv4_udp_hdr(struct mlx5e_rq *rq, struct iphdr *ipv4)
@@ -2238,7 +2242,8 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 			  struct mlx5_cqe64 *cqe, u16 header_index)
 {
 	struct mlx5e_frag_page *frag_page = mlx5e_shampo_hd_to_frag_page(rq, header_index);
-	u16 head_offset = mlx5e_shampo_hd_offset(header_index);
+	u16 head_offset = mlx5e_shampo_hd_offset(rq, header_index);
+	struct mlx5e_shampo_hd *shampo = rq->mpwqe.shampo;
 	u16 head_size = cqe->shampo.header_size;
 	u16 rx_headroom = rq->buff.headroom;
 	struct sk_buff *skb = NULL;
@@ -2254,7 +2259,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	data		= hdr + rx_headroom;
 	frag_size	= MLX5_SKB_FRAG_SZ(rx_headroom + head_size);
 
-	if (likely(frag_size <= BIT(MLX5E_SHAMPO_LOG_MAX_HEADER_ENTRY_SIZE))) {
+	if (likely(frag_size <= BIT(shampo->log_hd_entry_size))) {
 		/* build SKB around header */
 		dma_sync_single_range_for_cpu(rq->pdev, dma_addr, 0, frag_size, rq->buff.map_dir);
 		net_prefetchw(hdr);
-- 
2.51.0



