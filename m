Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1AE1CF5FB;
	Wed,  2 Oct 2024 14:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878619; cv=none; b=sSUbcOJ5VDKbZttxsKgsJp/5FAt6fuSW8L8W1yp8OdKQO3ipCvEWZzyho4D6IBLDHeVs6EsyS4F1PRvNKIPQVzBI1fVv+oi03OsDdaf/AoA+7Rd65R73O9BJ0iqniJyhunJM/RyOCk/4p6cgzSgc+ROTZYUzn1kgw57Ulb6+PCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878619; c=relaxed/simple;
	bh=tELeybN+sotRaGGqDglIJ6T704Gy+8X3lCmEmvJdJ+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbAb7TCPg79UU/3LU0e3oTZnr+jBNGZwRYvdoB8rh0OoYGzFi0hL5zPJN9RdrLvRItP2QFGqiuw1FmGN+0Zu3QsYVYaskwh9jCXqK5ssMhIpDfUIhk5QLGQhDOGVgIbs7iIziyMhoRZuV2d81JzOqnvsQDqLhjV3AvY2+icSIQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0V4Vrpp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0V4Vrpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848ACC4CEC2;
	Wed,  2 Oct 2024 14:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878618;
	bh=tELeybN+sotRaGGqDglIJ6T704Gy+8X3lCmEmvJdJ+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0V4Vrppwz/2jihSgNJW8Bq4NuMTT/VIpn0P+uo0FjQ3/BRXt0IYT6g1OF1jVX0BX
	 AvJ1RGeZ8Z23yRoMfQeM2HMZxshDaGRI4Ocku0Vy1Y/6T36qiHvKFa5oRQZ4YnN56L
	 l2GVL9r13ZDToIQYw3PLNXvhCOzGIOoKqSlR+a4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furong Xu <0x1207@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 444/634] net: stmmac: set PP_FLAG_DMA_SYNC_DEV only if XDP is enabled
Date: Wed,  2 Oct 2024 14:59:04 +0200
Message-ID: <20241002125828.626508040@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 33e2bd5a351ca..3b1bb6aa5b8c8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2025,7 +2025,7 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv,
 	rx_q->queue_index = queue;
 	rx_q->priv_data = priv;
 
-	pp_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
+	pp_params.flags = PP_FLAG_DMA_MAP | (xdp_prog ? PP_FLAG_DMA_SYNC_DEV : 0);
 	pp_params.pool_size = dma_conf->dma_rx_size;
 	num_pages = DIV_ROUND_UP(dma_conf->dma_buf_sz, PAGE_SIZE);
 	pp_params.order = ilog2(num_pages);
-- 
2.43.0



