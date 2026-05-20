Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AD5349AFF;
	Wed, 20 May 2026 17:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299197; cv=none; b=NQbFuaE8/1hvmB36Ip6OBWLg77CXVg76nmktAuKkGM3od8Ywk42fQV51hNdk82Sfv7IOPYlh6j6QmWeRLZVMR4jb6QgDWMDK/80r7ZmBkxkVs42fbyfCAqVFUbIInuJegJQApbS3XpAz4aD/V0ynQmnhaSwoXgXeam4SgyIEwjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299197; c=relaxed/simple;
	bh=aSMb1jf7vIof42ij+qxI8d9lJWQGE59P5a/yW+f2FTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQdXhB/KzwLgyIIsN/FQruotjdcTMljZRyjB2/e5Hwff9htz24bqd3bYXC7YSFtuQM3AvoAA0i2VYno0gXycwnliDorq5hvLSkFrZ918IyxqeWSHVz//oIDbY0RNT6sFxurfTnXU+18wr3N8ijcDlXNNaNEqH7qYxdVUslJxhwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUrSbN1L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUrSbN1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4CF1F000E9;
	Wed, 20 May 2026 17:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299195;
	bh=xqNJiOMq24JJpON1CLS/4qUrrv2GEWqhdcqthZdElcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUrSbN1LcHfRuj+MY6JyLjPO/HBvbcJI9H0JwIM8JuYq1k0+Ycy9HUuZzdm6wOaZ7
	 UJ69NsI6wwp9YamiXVMjc83tImULB62wkBq7VQp1ek2k1Mok76i09jfmFHImkkxdJm
	 O1FWD7eFyjQmyWg8fYMwS4GH3L6YEsTzGtE4KS+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 698/957] net: airoha: Move ndesc initialization at end of airoha_qdma_init_rx_queue()
Date: Wed, 20 May 2026 18:19:41 +0200
Message-ID: <20260520162149.677491843@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/ethernet/airoha/airoha_eth.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index f088f25128eb4..1d5447684ecab 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -776,14 +776,18 @@ static int airoha_qdma_init_rx_queue(struct airoha_queue *q,
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
@@ -792,11 +796,7 @@ static int airoha_qdma_init_rx_queue(struct airoha_queue *q,
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



