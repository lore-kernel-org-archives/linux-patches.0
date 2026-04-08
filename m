Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3D72727F3;
	Wed,  8 Apr 2026 18:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674355; cv=none; b=hHV7VqOaXmtN+gKcTiJAD8Gu1pwsZ+B5qBdVKjdHXc7wu9vOfc1rPleRJrw2TsDTMCHHdBNKYCUSo98qznS4/8Xrw2uFdB34iKRY+N8A/H2eozlZCGOl0RqzZaZRxJkjwknxMdDCAwJvpv7r7zggTxaxQ61tddDaJCUMbcP3jmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674355; c=relaxed/simple;
	bh=rIKMcHQ+J3XufiN/IsinPKCsIPFWo5q6DeRjsQ4vAiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1t7w4Xo05FSPTrwMAT+B3Tt5pRlKDVFJrneWuLP1/xsZX3QBNa2RlcN0ixBoL38N/L5GY7tP00Dt+7aI6ZnVMdM0J654aOZ55NePZiVBFXkLUpgZRn8hqaxAtwrHqnXqmv7RZ1zCnGtMmI11BbYryG8+zUVSE3+D4s7PUZIOEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDFBB033; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDFBB033"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D2DC19421;
	Wed,  8 Apr 2026 18:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674355;
	bh=rIKMcHQ+J3XufiN/IsinPKCsIPFWo5q6DeRjsQ4vAiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDFBB033/g8AtKUASaHLv8xiKRv2MTaYK2vY0b8LvlWC07ptx/U6lNNf7wYIp7Klr
	 txf4zTDXYMIHGcWSo4wFbnetdDPyGvLoOlIcm0P8qTLsEMBmOQPp5w1lgDmHXERVOJ
	 D3gUa41VlQKwjL6SvTpdL6a+OpihmXjSz4xjS70E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhur Agrawal <Madhur.Agrawal@airoha.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 064/311] net: airoha: Add missing cleanup bits in airoha_qdma_cleanup_rx_queue()
Date: Wed,  8 Apr 2026 20:01:04 +0200
Message-ID: <20260408175941.807207778@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 514aac3599879a7ed48b7dc19e31145beb6958ac ]

In order to properly cleanup hw rx QDMA queues and bring the device to
the initial state, reset rx DMA queue head/tail index. Moreover, reset
queued DMA descriptor fields.

Fixes: 23020f049327 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Tested-by: Madhur Agrawal <Madhur.Agrawal@airoha.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260327-airoha_qdma_cleanup_rx_queue-fix-v1-1-369d6ab1511a@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index c37a1b86180f3..454d7dcf198d9 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -794,18 +794,34 @@ static int airoha_qdma_init_rx_queue(struct airoha_queue *q,
 
 static void airoha_qdma_cleanup_rx_queue(struct airoha_queue *q)
 {
-	struct airoha_eth *eth = q->qdma->eth;
+	struct airoha_qdma *qdma = q->qdma;
+	struct airoha_eth *eth = qdma->eth;
+	int qid = q - &qdma->q_rx[0];
 
 	while (q->queued) {
 		struct airoha_queue_entry *e = &q->entry[q->tail];
+		struct airoha_qdma_desc *desc = &q->desc[q->tail];
 		struct page *page = virt_to_head_page(e->buf);
 
 		dma_sync_single_for_cpu(eth->dev, e->dma_addr, e->dma_len,
 					page_pool_get_dma_dir(q->page_pool));
 		page_pool_put_full_page(q->page_pool, page, false);
+		/* Reset DMA descriptor */
+		WRITE_ONCE(desc->ctrl, 0);
+		WRITE_ONCE(desc->addr, 0);
+		WRITE_ONCE(desc->data, 0);
+		WRITE_ONCE(desc->msg0, 0);
+		WRITE_ONCE(desc->msg1, 0);
+		WRITE_ONCE(desc->msg2, 0);
+		WRITE_ONCE(desc->msg3, 0);
+
 		q->tail = (q->tail + 1) % q->ndesc;
 		q->queued--;
 	}
+
+	q->head = q->tail;
+	airoha_qdma_rmw(qdma, REG_RX_DMA_IDX(qid), RX_RING_DMA_IDX_MASK,
+			FIELD_PREP(RX_RING_DMA_IDX_MASK, q->tail));
 }
 
 static int airoha_qdma_init_rx(struct airoha_qdma *qdma)
-- 
2.53.0



