Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8CE3546C8;
	Wed, 20 May 2026 17:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299202; cv=none; b=ZkUza6lgKY1pCaeeUvJCqdXXZJDl3DIg3dVoGPyDtfN1r1QeDGr6Yq1U3tr9KiiSi4o9cvbtQik+CzUpkkgFMOdT41HWcJ/LO4JuqxDl18iTj/o/xZhS/ip2sb1aa+iOZAUfe5RAxzhTBbRFei4UvT0BzmYDnEayr+wx3Yu5YZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299202; c=relaxed/simple;
	bh=flcPIiSnxS8FwPxUIYag+btjH8EbjRxbDOvzK70Y8ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDsk02/KAwddyFPDyHfltXr2WVFe1l+icaTYwIm2nJ5Wy0Ccs/mddEV6V+AId28AyDAtoqk7JL3ZMy24ph8ZvCwqfj7KNNuylwGdJyIeNrwbkylbgU9zLBBCI6+NL5UPiLqGrcLupmyurEgc5x10AuxyNAfpbNgpiYajInPkrnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtQ22dEU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtQ22dEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FE21F000E9;
	Wed, 20 May 2026 17:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299201;
	bh=JKh6IS9gciuGLhwyrQKCwzbW77XOsi0izEJx7aTb5M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JtQ22dEULx7bwiOGglKHz74ghAH+AYrrc8Ndfv79azfSzlz8xWqNfDZZe+ZkZzDf5
	 GsezXACJNtoYF84UaaeYeom2IswzKUSjUHKKugbipA4WHu4bav7i33UIJp5VW3xgeB
	 vgNnJOqwbhC38uqKk9QHBwyPc+F1j/gpTynQfLvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 700/957] net: airoha: Add size check for TX NAPIs in airoha_qdma_cleanup()
Date: Wed, 20 May 2026 18:19:43 +0200
Message-ID: <20260520162149.720462630@linuxfoundation.org>
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

[ Upstream commit 4b91cb65789b794bfc8d50554b8994f8e0f16309 ]

If airoha_qdma_init routine fails before airoha_qdma_tx_irq_init() runs
successfully for all TX NAPIs, airoha_qdma_cleanup() will
unconditionally runs netif_napi_del() on TX NAPIs, triggering a NULL
pointer dereference. Fix the issue relying on q_tx_irq size value to
check if the TX NAPIs is properly initialized in airoha_qdma_cleanup().
Moreover, run netif_napi_add_tx() just if irq_q queue is properly
allocated.

Fixes: 23020f049327 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260420-airoha_qdma_init_rx_queue-fix-v2-2-d99347e5c18d@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 8416451f4786a..865b854bd4afc 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -1051,8 +1051,6 @@ static int airoha_qdma_tx_irq_init(struct airoha_tx_irq_queue *irq_q,
 	struct airoha_eth *eth = qdma->eth;
 	dma_addr_t dma_addr;
 
-	netif_napi_add_tx(eth->napi_dev, &irq_q->napi,
-			  airoha_qdma_tx_napi_poll);
 	irq_q->q = dmam_alloc_coherent(eth->dev, size * sizeof(u32),
 				       &dma_addr, GFP_KERNEL);
 	if (!irq_q->q)
@@ -1062,6 +1060,9 @@ static int airoha_qdma_tx_irq_init(struct airoha_tx_irq_queue *irq_q,
 	irq_q->size = size;
 	irq_q->qdma = qdma;
 
+	netif_napi_add_tx(eth->napi_dev, &irq_q->napi,
+			  airoha_qdma_tx_napi_poll);
+
 	airoha_qdma_wr(qdma, REG_TX_IRQ_BASE(id), dma_addr);
 	airoha_qdma_rmw(qdma, REG_TX_IRQ_CFG(id), TX_IRQ_DEPTH_MASK,
 			FIELD_PREP(TX_IRQ_DEPTH_MASK, size));
@@ -1481,8 +1482,12 @@ static void airoha_qdma_cleanup(struct airoha_qdma *qdma)
 		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(qdma->q_tx_irq); i++)
+	for (i = 0; i < ARRAY_SIZE(qdma->q_tx_irq); i++) {
+		if (!qdma->q_tx_irq[i].size)
+			continue;
+
 		netif_napi_del(&qdma->q_tx_irq[i].napi);
+	}
 
 	for (i = 0; i < ARRAY_SIZE(qdma->q_tx); i++) {
 		if (!qdma->q_tx[i].ndesc)
-- 
2.53.0



