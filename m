Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5D7348C55;
	Wed, 20 May 2026 18:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301268; cv=none; b=Xuougo1nSVkBLpvfxKYN9rEmEaHzqn5kjvsXfmq/xg0xje1oX3bH5N6/qO4udeXvP/NCITwm3cX+2DNYY0CiLP3rN1kVtFHtjxRMiWzktb+wBcPGpDxsJ/DCmQ4t28XU1LKEs3mtnmUNz5I3hUGxjzPG24r9uuM7f4WSHi/Y3J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301268; c=relaxed/simple;
	bh=Wiwfo94+zByYsja3zGolDYm5Vsfs3LsaArYi9pXRE2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ja4kEwAjdFR9o2E1lacfQmte7VtqqaHY8vY1EI9eVmwvddAx5pne5W4iGvYTcL0muoS0OvlUCqdlo6xucepiVgZHwwWCb5ONRTFiXgaM5tzGT2Hu2dQzT8dOrCuFsBFfclVg1iXs+VcR2gNJX9cz8UD3K1p3ZaesXESxoKvhpPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvYllkhj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvYllkhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0057B1F000E9;
	Wed, 20 May 2026 18:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301267;
	bh=JBdUogOLU//82YqFmPJme2/lH/XvTIkarKOtQdZTZtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvYllkhja/MZ2b557iQZFZ8TsmgrwYZJvkGtpM4e5CottZRjv5HRUmUihgf6HjPqL
	 SjW/8a+1McOWqSgKSIo5OcxdqR5NFgMt34wjkGcDET+ES2ClUe4FRNpQ+xzCHf5AwU
	 PpAhvY3AE1cvmNzjNRtVmmr9jHA/vYpaeD/yykLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 491/666] net: airoha: Move ndesc initialization at end of airoha_qdma_init_rx_queue()
Date: Wed, 20 May 2026 18:21:42 +0200
Message-ID: <20260520162121.905819753@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 379050947a1828826ad7ea50c95245a56929b35a ]

If queue entry or DMA descriptor list allocation fails in
airoha_qdma_init_rx_queue routine, airoha_qdma_cleanup() will trigger a
NULL pointer dereference running netif_napi_del() for RX queue NAPIs
since netif_napi_add() has never been executed to this particular RX NAPI.
The issue is due to the early ndesc initialization in
airoha_qdma_init_rx_queue() since airoha_qdma_cleanup() relies on ndesc
value to check if the queue is properly initialized. Fix the issue moving
ndesc initialization at end of airoha_qdma_init_tx routine.
Move page_pool allocation after descriptor list allocation in order to
avoid memory leaks if desc allocation fails.

Fixes: 23020f049327 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260420-airoha_qdma_init_rx_queue-fix-v2-1-d99347e5c18d@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/airoha_eth.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/airoha_eth.c b/drivers/net/ethernet/mediatek/airoha_eth.c
index d8af267f64f71..7b929b20fe64b 100644
--- a/drivers/net/ethernet/mediatek/airoha_eth.c
+++ b/drivers/net/ethernet/mediatek/airoha_eth.c
@@ -1574,14 +1574,18 @@ static int airoha_qdma_init_rx_queue(struct airoha_queue *q,
 	dma_addr_t dma_addr;
 
 	q->buf_size = PAGE_SIZE / 2;
-	q->ndesc = ndesc;
 	q->qdma = qdma;
 
-	q->entry = devm_kzalloc(eth->dev, q->ndesc * sizeof(*q->entry),
+	q->entry = devm_kzalloc(eth->dev, ndesc * sizeof(*q->entry),
 				GFP_KERNEL);
 	if (!q->entry)
 		return -ENOMEM;
 
+	q->desc = dmam_alloc_coherent(eth->dev, ndesc * sizeof(*q->desc),
+				      &dma_addr, GFP_KERNEL);
+	if (!q->desc)
+		return -ENOMEM;
+
 	q->page_pool = page_pool_create(&pp_params);
 	if (IS_ERR(q->page_pool)) {
 		int err = PTR_ERR(q->page_pool);
@@ -1590,11 +1594,7 @@ static int airoha_qdma_init_rx_queue(struct airoha_queue *q,
 		return err;
 	}
 
-	q->desc = dmam_alloc_coherent(eth->dev, q->ndesc * sizeof(*q->desc),
-				      &dma_addr, GFP_KERNEL);
-	if (!q->desc)
-		return -ENOMEM;
-
+	q->ndesc = ndesc;
 	netif_napi_add(eth->napi_dev, &q->napi, airoha_qdma_rx_napi_poll);
 
 	airoha_qdma_wr(qdma, REG_RX_RING_BASE(qid), dma_addr);
-- 
2.53.0



