Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C555737F01B;
	Wed,  8 Apr 2026 18:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672961; cv=none; b=Paj8aOlg4UCO3IFAjaFSxt38T3y7WAHHqUZ2/kqzQx0DEacYNw7k6jFU7AUe5izYvYAbxTTUEY6IW+zbuLyHeeeMgc919+/7Y8pWclN+2QU3+EOn2Tz/PNUWzWXlYI0S5MIR5Wk1B2xqzt40WhnID3NEU0pNaewCtA8EqOtD+BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672961; c=relaxed/simple;
	bh=0zIhdvrZr5uAGoGn0Ibw0NerucdenRVBeVDxP64CsE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXKkr/RFr5ta6ABMRFl2wgAsjbsnfT5bqWvM3pQPr0JbeYPG+qLTZpJclOTXMnH/92owaJA9BM5VdMfePl1gWJHmsGIDYXkd3sSbwBWhX+6w/TnquWS1I7SEvNJTyLWpUL6LgHGdeH6VPIm9sl/DwKwX6IqXrwCi6GJwSPA2Dyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBekEBUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBekEBUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1DFC19421;
	Wed,  8 Apr 2026 18:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672961;
	bh=0zIhdvrZr5uAGoGn0Ibw0NerucdenRVBeVDxP64CsE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBekEBUYSwAgDTZJa44MFrEPKchBfGVvUbqPhLVwoJ1UcB+UWUjbEU/LgctV+d7GM
	 pM6le4/Di7owoSmT5mlmPBXdUPLDxc7dn0QzcsOOTuD6Quilgpq5F8ud/1NYOP8B7u
	 5b9a3enHcHYOK0Q0+Wp+ebaKoWs0S4ssXidOjgDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhur Agrawal <Madhur.Agrawal@airoha.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/277] net: airoha: Add missing cleanup bits in airoha_qdma_cleanup_rx_queue()
Date: Wed,  8 Apr 2026 20:00:33 +0200
Message-ID: <20260408175935.651003414@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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
index b16b9ae7d3311..4fc6bd282b465 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -806,18 +806,34 @@ static int airoha_qdma_init_rx_queue(struct airoha_queue *q,
 
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



