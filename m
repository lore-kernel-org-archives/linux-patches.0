Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29A61F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B73C433C7;
	Fri, 21 Jul 2023 16:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955798;
	bh=1dvuQ/1iWQE/U69Zn0yqkXZb3NP+ObglhX/3TqFUIz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlDHdus3WtyURDU7Q4UEZFN/UZE6JKZfOl1fyCi4o4GNQqL9Rt/eSNw1462NysZWn
	 kLbuTtHML41z382DF+ZHja+OSDboIUmN5qvr+0ePRpIzcvmrpyUxGsB326Co7sqlbA
	 Dg4OtGPlPN5JATVwv/iQEkZbrsYbHjHpKN/lSi3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 034/292] net/mlx5e: RX, Fix page_pool page fragment tracking for XDP
Date: Fri, 21 Jul 2023 18:02:23 +0200
Message-ID: <20230721160530.267148114@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 7abd955a58fb0fcd4e756fa2065c03ae488fcfa7 ]

Currently mlx5e releases pages directly to the page_pool for XDP_TX and
does page fragment counting for XDP_REDIRECT. RX pages from the
page_pool are leaking on XDP_REDIRECT because the xdp core will release
only one fragment out of MLX5E_PAGECNT_BIAS_MAX and subsequently the page
is marked as "skip release" which avoids the driver release.

A fix would be to take an extra fragment for XDP_REDIRECT and not set the
"skip release" bit so that the release on the driver side can handle the
remaining bias fragments. But this would be a shortsighted solution.
Instead, this patch converges the two XDP paths (XDP_TX and XDP_REDIRECT) to
always do fragment tracking. The "skip release" bit is no longer
necessary for XDP.

Fixes: 6f5742846053 ("net/mlx5e: RX, Enable skb page recycling through the page_pool")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 32 +++++++------------
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index f0e6095809faf..40589cebb7730 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -662,8 +662,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 				/* No need to check ((page->pp_magic & ~0x3UL) == PP_SIGNATURE)
 				 * as we know this is a page_pool page.
 				 */
-				page_pool_put_defragged_page(page->pp,
-							     page, -1, true);
+				page_pool_recycle_direct(page->pp, page);
 			} while (++n < num);
 
 			break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 111f6a4a64b64..08e08489f4220 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1753,11 +1753,11 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 
 	prog = rcu_dereference(rq->xdp_prog);
 	if (prog && mlx5e_xdp_handle(rq, prog, &mxbuf)) {
-		if (test_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
+		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
 			struct mlx5e_wqe_frag_info *pwi;
 
 			for (pwi = head_wi; pwi < wi; pwi++)
-				pwi->flags |= BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
+				pwi->frag_page->frags++;
 		}
 		return NULL; /* page/packet was consumed by XDP */
 	}
@@ -1827,12 +1827,8 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 			      rq, wi, cqe, cqe_bcnt);
 	if (!skb) {
 		/* probably for XDP */
-		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
-			/* do not return page to cache,
-			 * it will be returned on XDP_TX completion.
-			 */
-			wi->flags |= BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
-		}
+		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
+			wi->frag_page->frags++;
 		goto wq_cyc_pop;
 	}
 
@@ -1878,12 +1874,8 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 			      rq, wi, cqe, cqe_bcnt);
 	if (!skb) {
 		/* probably for XDP */
-		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
-			/* do not return page to cache,
-			 * it will be returned on XDP_TX completion.
-			 */
-			wi->flags |= BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
-		}
+		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
+			wi->frag_page->frags++;
 		goto wq_cyc_pop;
 	}
 
@@ -2062,12 +2054,12 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 	if (prog) {
 		if (mlx5e_xdp_handle(rq, prog, &mxbuf)) {
 			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
-				int i;
+				struct mlx5e_frag_page *pfp;
+
+				for (pfp = head_page; pfp < frag_page; pfp++)
+					pfp->frags++;
 
-				for (i = 0; i < sinfo->nr_frags; i++)
-					/* non-atomic */
-					__set_bit(page_idx + i, wi->skip_release_bitmap);
-				return NULL;
+				wi->linear_page.frags++;
 			}
 			mlx5e_page_release_fragmented(rq, &wi->linear_page);
 			return NULL; /* page/packet was consumed by XDP */
@@ -2165,7 +2157,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 				 cqe_bcnt, &mxbuf);
 		if (mlx5e_xdp_handle(rq, prog, &mxbuf)) {
 			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
-				__set_bit(page_idx, wi->skip_release_bitmap); /* non-atomic */
+				frag_page->frags++;
 			return NULL; /* page/packet was consumed by XDP */
 		}
 
-- 
2.39.2



