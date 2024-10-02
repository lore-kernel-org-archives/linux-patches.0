Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC5B1EA80;
	Wed,  2 Oct 2024 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880199; cv=none; b=gJbk9sYmP3qV/0olPl7wQK6gb65t79Z3s8AybqknS5eUVx9zDGHUvo54cw9SNMah/AO9Bzx5z3kneHnzEI/DKl4O56TTzhTo5DZp4HNOGfHxhIdQwHUOUwPvS0s6LPf8d5SeFMytqt6rrobuLOACw5SRIxcP3BnUNSE5FXrjoqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880199; c=relaxed/simple;
	bh=44Qk29Rq6y1fkUBd4/KfB5dHztCg2AsXPRpd28f213w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5FfRupMBspaL99QCwBeIQKdbQU7yoLFj1AlA4/f/MVV5Vmu0fXhyTRWY4ZkZYb2zF/3aq8cJydIsRLWE+a2u1DfUtB1Jn1vkpmuD0CYSMRn5BkHldH/3L+vnEwPxxevolN1w0I8BpwIQKuAbTJTelsewC7XFdzmwvDem3hLVls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsB5ZP0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsB5ZP0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7389C4CEC2;
	Wed,  2 Oct 2024 14:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880199;
	bh=44Qk29Rq6y1fkUBd4/KfB5dHztCg2AsXPRpd28f213w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsB5ZP0K6x96291m3/9EJMHiu83FyjNm/G0nVEDzB5K8wdZUmFlpCBVQPeOar/MDM
	 P42FHHPRVmNDoaG+M2z1AZlVBRGe51P//n/ojn82xlq9jSJxJZ4QihAKEseaL3xcQl
	 owfAJK5c/YV+hJlOcxcsgSnulwYREV6HxGYQd46o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furong Xu <0x1207@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 378/538] net: stmmac: set PP_FLAG_DMA_SYNC_DEV only if XDP is enabled
Date: Wed,  2 Oct 2024 15:00:17 +0200
Message-ID: <20241002125807.351975150@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d6167a7b19f21..89a80e3e8bb88 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2018,7 +2018,7 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv,
 	rx_q->queue_index = queue;
 	rx_q->priv_data = priv;
 
-	pp_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
+	pp_params.flags = PP_FLAG_DMA_MAP | (xdp_prog ? PP_FLAG_DMA_SYNC_DEV : 0);
 	pp_params.pool_size = dma_conf->dma_rx_size;
 	num_pages = DIV_ROUND_UP(dma_conf->dma_buf_sz, PAGE_SIZE);
 	pp_params.order = ilog2(num_pages);
-- 
2.43.0



