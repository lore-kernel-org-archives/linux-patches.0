Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786371A00F0;
	Mon, 23 Mar 2026 15:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278044; cv=none; b=Jm2fi+gArxN42ij6GtcYVVMC1z+nf6F4adHCjp1dgwnyB+1Dmne+Vn9InCxNZ04tZ50MAmzstTre68govJx9WjN6fbjSXntWYEQr3DsETH5Aww1XXK7e79JBqaiE+kjxL1v0atpaH5KOKX5xJd3fXm7WacMcCJedsY1ja7FitZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278044; c=relaxed/simple;
	bh=BN9Sx3PYgeqK8S/jBz44iPpIHk1mzNEx++uqbu4msk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=codYgWrsmRuBABerKaZ2J6EKi4MiObBEf4WIEy7hN8y7eWfHFRQiKqprtOz1vn5+1QrCrOPSTTG0fvCFkpHKVl9E/nmrCt+OkksPjM8vWbH1l7gdRroZD5s8VpoU3TjAydX33mG3D9sDRD9kJvg62s9ObS4jvqnhvh9OA16DzQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F69ax16m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F69ax16m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CEAC4CEF7;
	Mon, 23 Mar 2026 15:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278044;
	bh=BN9Sx3PYgeqK8S/jBz44iPpIHk1mzNEx++uqbu4msk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F69ax16mzW7Oj4ekpqoOeB6Kb5/ZfP95ui3CHs/krNimWcPawKFuiXbQU27Izh+ew
	 qyUYA+FzgzP45UWa+3AAALO/sEBkht2M6VVmUbGIqt6N1dTj8YAYIDxEkj0Fe7HLPG
	 CIxdLFURrMWy1LcjzJp84n0FyJC4DpdPTPbvRqiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/567] i40e: use xdp.frame_sz as XDP RxQ info frag_size
Date: Mon, 23 Mar 2026 14:41:41 +0100
Message-ID: <20260323134538.327507139@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ca35979482c67..9bcd32d31da77 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3623,6 +3623,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	u16 pf_q = vsi->base_queue + ring->queue_index;
 	struct i40e_hw *hw = &vsi->back->hw;
 	struct i40e_hmc_obj_rxq rx_ctx;
+	u32 xdp_frame_sz;
 	int err = 0;
 	bool ok;
 
@@ -3632,6 +3633,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	memset(&rx_ctx, 0, sizeof(rx_ctx));
 
 	ring->rx_buf_len = vsi->rx_buf_len;
+	xdp_frame_sz = i40e_rx_pg_size(ring) / 2;
 
 	/* XDP RX-queue info only needed for RX rings exposed to XDP */
 	if (ring->vsi->type != I40E_VSI_MAIN)
@@ -3639,11 +3641,12 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 
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
@@ -3659,7 +3662,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 		err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 					 ring->queue_index,
 					 ring->q_vector->napi.napi_id,
-					 ring->rx_buf_len);
+					 xdp_frame_sz);
 		if (err)
 			return err;
 		err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
@@ -3670,7 +3673,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	}
 
 skip:
-	xdp_init_buff(&ring->xdp, i40e_rx_pg_size(ring) / 2, &ring->xdp_rxq);
+	xdp_init_buff(&ring->xdp, xdp_frame_sz, &ring->xdp_rxq);
 
 	rx_ctx.dbuff = DIV_ROUND_UP(ring->rx_buf_len,
 				    BIT_ULL(I40E_RXQ_CTX_DBUFF_SHIFT));
-- 
2.51.0



