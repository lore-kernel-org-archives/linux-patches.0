Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71C91D0960;
	Wed,  2 Oct 2024 13:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876691; cv=none; b=ebIJkB7b69xTp/8SAidnKFv340Gad5lH1gaAceOal+sVoQtCFyKHo1xKNY0Tp36I2Sx2pDSapNzqRPG15fK1DMfPjb4K29rF33+RzV18QEb50H5SfrMbFiKuX5NLYg0bDSNOnpfrbc11nSLZQ/M6jk5httb9yMJgevNfgnuKMLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876691; c=relaxed/simple;
	bh=QTuOqCZCfV44omaSQ0RnTQT818Z8sC3u2wYVOVsvJ0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aU/7R3DfzTzQLTpgUV1MT+kGE4gsGe5KyXivHX8eL4Md8Pza593qMDarB6V6diKWMCskRfaTZuFbIxG4i6uGfcxxXJ3/NPzFfCmUGPrG6QMrkVwpRInwDk7Zq5MSQ7iviu49ixwgj9cl6gb4S1JhZEWQ7oRZiiscfl4rnbwcFzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpjHbKnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpjHbKnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFB6C4CEC5;
	Wed,  2 Oct 2024 13:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876691;
	bh=QTuOqCZCfV44omaSQ0RnTQT818Z8sC3u2wYVOVsvJ0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpjHbKnxN1C7G1ggZvWK16NoqnH2GgPhlh05miFjxLbFLCj5/1nZQR2bPM3Vy6gsq
	 uX33uz62v8L19fgo+3XRqgATkTthnyOZc/cSbhC+o9P4AngMNOQzQhTTV1K57zPXir
	 3d4LQZbMkz66phThDRrkqMKWBfk4CBapJY9TPJbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furong Xu <0x1207@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 489/695] net: stmmac: set PP_FLAG_DMA_SYNC_DEV only if XDP is enabled
Date: Wed,  2 Oct 2024 14:58:07 +0200
Message-ID: <20241002125841.988368119@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Furong Xu <0x1207@gmail.com>

[ Upstream commit b514c47ebf41a6536551ed28a05758036e6eca7c ]

Commit 5fabb01207a2 ("net: stmmac: Add initial XDP support") sets
PP_FLAG_DMA_SYNC_DEV flag for page_pool unconditionally,
page_pool_recycle_direct() will call page_pool_dma_sync_for_device()
on every page even the page is not going to be reused by XDP program.

When XDP is not enabled, the page which holds the received buffer
will be recycled once the buffer is copied into new SKB by
skb_copy_to_linear_data(), then the MAC core will never reuse this
page any longer. Always setting PP_FLAG_DMA_SYNC_DEV wastes CPU cycles
on unnecessary calling of page_pool_dma_sync_for_device().

After this patch, up to 9% noticeable performance improvement was observed
on certain platforms.

Fixes: 5fabb01207a2 ("net: stmmac: Add initial XDP support")
Signed-off-by: Furong Xu <0x1207@gmail.com>
Link: https://patch.msgid.link/20240919121028.1348023-1-0x1207@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f3a1b179aaeac..95d3d1081727f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2022,7 +2022,7 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv,
 	rx_q->queue_index = queue;
 	rx_q->priv_data = priv;
 
-	pp_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
+	pp_params.flags = PP_FLAG_DMA_MAP | (xdp_prog ? PP_FLAG_DMA_SYNC_DEV : 0);
 	pp_params.pool_size = dma_conf->dma_rx_size;
 	num_pages = DIV_ROUND_UP(dma_conf->dma_buf_sz, PAGE_SIZE);
 	pp_params.order = ilog2(num_pages);
-- 
2.43.0



