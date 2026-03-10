Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EC536D512;
	Tue, 10 Mar 2026 11:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141298; cv=none; b=VOZWDM7hUyHBeA4939InmoAottC/2BwkhN0YSC5RqvNn0vRiG2EgvqZHqxCRKApC8TyWBubVGvkDHf1miGxygivC25/2TZCu/s0so0F9MFv8xak6SRaVenwAABG0KTWYbZUYtthdvBHH9eQ0O37h+/kkj/nUYsviiyOpnF6dsjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141298; c=relaxed/simple;
	bh=RTWIn4m5nxc95AtTcxHUvssmCQHfECZAQ9eGexUS9Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAcqPLIPyKRnvH34NSu7Kz60lNhiLI0kd9IE7J3thCEefCjmV7yAwhEcCIBAiT3V6dfEnq43DKYjv75atUBjds4MFEyiObNIwrgeYiNumKLqbUVAs63tHBhzi9QHnlybwzINB0q4o72HjXK+JPpOmOxn3dMt039d9gM9N1A+oWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KaPrDhk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KaPrDhk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F43DC2BC86;
	Tue, 10 Mar 2026 11:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141297;
	bh=RTWIn4m5nxc95AtTcxHUvssmCQHfECZAQ9eGexUS9Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KaPrDhk6hRTE9GWFW2wRyEZDZrY7BP3+/aiMzYTFXC/PrcqiQ3Wm6C5268EzE7VFW
	 L33VhRBM7EF0HYyXCnnh6AfX0w8FYtxpuSO57bN7cTnG81O449VPr56JrJbDhSSi6G
	 l/jOJXSzEJvSuLDajIcI9YVHv2k18lJAMlBlqcjo6xj8XZ/Y8jZ+4axCMJyGIGQup/
	 I3UWRMCnruXJ6Lne/EFmsq15jsD71pPo7Ex3FTgvNFZWkFoiQEzaPB+oMaVRc64PY3
	 VbjLPo/SYOhprO/X0LFf6UlVkLyp9OkiT7L5G78eoSxkyRDOX7IDPCc4GXc/QUsLHr
	 QLpfvtRMxan6g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 302/311] i40e: use xdp.frame_sz as XDP RxQ info frag_size
Date: Tue, 10 Mar 2026 07:05:49 -0400
Message-ID: <e14571ef699a0f3fbc1b624c5ff6ebe7f3e47536.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit c69d22c6c46a1d792ba8af3d8d6356fdc0e6f538 ]

The only user of frag_size field in XDP RxQ info is
bpf_xdp_frags_increase_tail(). It clearly expects whole buffer size instead
of DMA write size. Different assumptions in i40e driver configuration lead
to negative tailroom.

Set frag_size to the same value as frame_sz in shared pages mode, use new
helper to set frag_size when AF_XDP ZC is active.

Fixes: a045d2f2d03d ("i40e: set xdp_rxq_info::frag_size")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://patch.msgid.link/20260305111253.2317394-7-larysa.zaremba@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index bc00bd4f439be..598739220dfb9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3569,6 +3569,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	u16 pf_q = vsi->base_queue + ring->queue_index;
 	struct i40e_hw *hw = &vsi->back->hw;
 	struct i40e_hmc_obj_rxq rx_ctx;
+	u32 xdp_frame_sz;
 	int err = 0;
 	bool ok;
 
@@ -3578,6 +3579,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	memset(&rx_ctx, 0, sizeof(rx_ctx));
 
 	ring->rx_buf_len = vsi->rx_buf_len;
+	xdp_frame_sz = i40e_rx_pg_size(ring) / 2;
 
 	/* XDP RX-queue info only needed for RX rings exposed to XDP */
 	if (ring->vsi->type != I40E_VSI_MAIN)
@@ -3585,11 +3587,12 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 
 	ring->xsk_pool = i40e_xsk_pool(ring);
 	if (ring->xsk_pool) {
+		xdp_frame_sz = xsk_pool_get_rx_frag_step(ring->xsk_pool);
 		ring->rx_buf_len = xsk_pool_get_rx_frame_size(ring->xsk_pool);
 		err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 					 ring->queue_index,
 					 ring->q_vector->napi.napi_id,
-					 ring->rx_buf_len);
+					 xdp_frame_sz);
 		if (err)
 			return err;
 		err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
@@ -3605,7 +3608,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 		err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 					 ring->queue_index,
 					 ring->q_vector->napi.napi_id,
-					 ring->rx_buf_len);
+					 xdp_frame_sz);
 		if (err)
 			return err;
 		err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
@@ -3616,7 +3619,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	}
 
 skip:
-	xdp_init_buff(&ring->xdp, i40e_rx_pg_size(ring) / 2, &ring->xdp_rxq);
+	xdp_init_buff(&ring->xdp, xdp_frame_sz, &ring->xdp_rxq);
 
 	rx_ctx.dbuff = DIV_ROUND_UP(ring->rx_buf_len,
 				    BIT_ULL(I40E_RXQ_CTX_DBUFF_SHIFT));
-- 
2.51.0

