Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17783BBF2;
	Mon, 14 Oct 2024 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918253; cv=none; b=VfZXvHRZqL91AM0gqiV5kj6TiOGvPLByHwtNRQqp093EPQ31rIjVMfIGiK38yfchVlJfLVv11gawxgqKHxJe/PXQxGz0KmI/uXF6PImVnAEc/tegwEOYk18sMnBovEocwGzDQWaPs6RXzMeB1BrOjLdO3mc+hHYAp0l9pLOYPPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918253; c=relaxed/simple;
	bh=pnuyR0vt0BSQb+Ahmixm0Nbf6HWsx0yRzm8oElNlo0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqcF6G2Ahkaz43rVThPZCam0Crh+vs2JeoX34Z24wTMB8CRGZWsdVC+pDffkG3WBByMc3OHTgswep6rrAaAUh0AA5GqDSJrIuI1TLVYjcwhOOBQrPLdyafnwOIVpjTpz6n9E7j4rz1QTDX2DzwdZ6c/o27OGeeN4IrTnTbpupwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1uBMfzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1uBMfzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111A7C4CEC3;
	Mon, 14 Oct 2024 15:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918253;
	bh=pnuyR0vt0BSQb+Ahmixm0Nbf6HWsx0yRzm8oElNlo0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1uBMfzoYt8vr3XdOJ8/fGd0Qg533ceDeDbXvv9Nd8FbU4VGp7UuUGIlxEBAhpXiq
	 bJYMof5GWwrz1Cf7oW8ZFi9ebEuXMGrzmuK3WAG6cpPIw1PYtvzc0eNJtz785mrO4I
	 9v+W3vWpica+YiZ8aOikPqwPX9TJaLqmbybrivT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furong Xu <0x1207@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 269/798] net: stmmac: set PP_FLAG_DMA_SYNC_DEV only if XDP is enabled
Date: Mon, 14 Oct 2024 16:13:43 +0200
Message-ID: <20241014141228.500696180@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 93630840309e7..b5b7ff5b32616 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2015,7 +2015,7 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv,
 	rx_q->queue_index = queue;
 	rx_q->priv_data = priv;
 
-	pp_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
+	pp_params.flags = PP_FLAG_DMA_MAP | (xdp_prog ? PP_FLAG_DMA_SYNC_DEV : 0);
 	pp_params.pool_size = dma_conf->dma_rx_size;
 	num_pages = DIV_ROUND_UP(dma_conf->dma_buf_sz, PAGE_SIZE);
 	pp_params.order = ilog2(num_pages);
-- 
2.43.0



