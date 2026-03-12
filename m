Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B21318EE1;
	Thu, 12 Mar 2026 20:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347258; cv=none; b=u4jMagWpZhcFMeYUZquZRX6G++GTz2AEwPZy0ixDG9WGRDMBXZUBk//uWpYyTLFAEw0urwbXQawxcTi2lIxbBMg2zwDGSPpmnVL1EIC5Slk73pqBDS8fV6jKuViF8ymJFYOpzZPQfUU09tWQ6fqxE8nfr9NAKPnaHZjRn0aAwZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347258; c=relaxed/simple;
	bh=gT6vvRR59yEfj4dYAj31d7rrHj2LqjCZDRBwwmyj9Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOmYR8V6ub206Zd4CIlPXTl8YBB1scmQWmmorRxlsBvVbVkMPTSUZEdK51bFAzkZ6+qH+Vrha3z5Q/LV5klccfFQIG6zcLpD9gsh2zdBryyV/jkTy6pht609UXjIKCt3kDMgsI2EQxALPuW5MyH/MEnaXcTbGw5BWKZ4prBchFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztiA0kN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztiA0kN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01109C4CEF7;
	Thu, 12 Mar 2026 20:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347258;
	bh=gT6vvRR59yEfj4dYAj31d7rrHj2LqjCZDRBwwmyj9Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ztiA0kN+hbidCbaW0Lgzvx7DkwZNluwfUI6M+/bk8Axzcf8kOQXBfUoKGOtd6NbzL
	 2D2SGlOTJDeWXzouGs1fP+L7JY45cp0te7uy/HVCeryIg2fzw/bbRjOW2YVXDGtLRH
	 yohTqBaxQRC23YbIJoQOpXtsQZLF6ArCGnEQidGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 245/265] i40e: use xdp.frame_sz as XDP RxQ info frag_size
Date: Thu, 12 Mar 2026 21:10:32 +0100
Message-ID: <20260312201027.187856145@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 981c01dce0cdf..e7a06db26c915 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3619,6 +3619,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	u16 pf_q = vsi->base_queue + ring->queue_index;
 	struct i40e_hw *hw = &vsi->back->hw;
 	struct i40e_hmc_obj_rxq rx_ctx;
+	u32 xdp_frame_sz;
 	int err = 0;
 	bool ok;
 
@@ -3628,6 +3629,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	memset(&rx_ctx, 0, sizeof(rx_ctx));
 
 	ring->rx_buf_len = vsi->rx_buf_len;
+	xdp_frame_sz = i40e_rx_pg_size(ring) / 2;
 
 	/* XDP RX-queue info only needed for RX rings exposed to XDP */
 	if (ring->vsi->type != I40E_VSI_MAIN)
@@ -3635,11 +3637,12 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 
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
@@ -3655,7 +3658,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 		err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 					 ring->queue_index,
 					 ring->q_vector->napi.napi_id,
-					 ring->rx_buf_len);
+					 xdp_frame_sz);
 		if (err)
 			return err;
 		err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
@@ -3666,7 +3669,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	}
 
 skip:
-	xdp_init_buff(&ring->xdp, i40e_rx_pg_size(ring) / 2, &ring->xdp_rxq);
+	xdp_init_buff(&ring->xdp, xdp_frame_sz, &ring->xdp_rxq);
 
 	rx_ctx.dbuff = DIV_ROUND_UP(ring->rx_buf_len,
 				    BIT_ULL(I40E_RXQ_CTX_DBUFF_SHIFT));
-- 
2.51.0



