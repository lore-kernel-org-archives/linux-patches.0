Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01FC36A34D;
	Wed, 20 May 2026 16:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294843; cv=none; b=JgC2kQS023zFdDdcPUoLBMTzzuNEsl9+y99CILB8pdpHZ2jOiVaBvM4704PERKQFt+pUEOOYCQqF1zSOzmJL8KnjzEhwskl3+0Wh6yJn+FYj1KPewFaABlQfNjvj06XcdiXuSDw/juR3zgFrAPcC5Hx0vRb8OSffB7OZSASQfcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294843; c=relaxed/simple;
	bh=Ig7Yyp7Q3yXdz0jCzxPExGTVyIlZkn6b0zJt0tevRFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nzn0Vha5IdMi67pwEcLM6kjeOpYKD1fEspT7pGVSXf4vFSYZDTh4AWvz7sNQeFG+/UzdGuzQFgXn8VSFi6fZqTa+njJbEp+2pNnYl4d/Fuc1Y/muLWzWLeGHQurR/PIwvcu2xpJXZ3lJRfqGji9RprlOOxqX0XcaNLK3LqFlLT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPggRqQ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPggRqQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F701F000E9;
	Wed, 20 May 2026 16:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294842;
	bh=5Cr/j80xKtCrmLPCsXCnsPYGCptQAc75F/p49K2zxQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPggRqQ19fKmHMvl9/BJoD3FiYLKfzYgmfE4Y9ofEzkui1Y340+oHMBj5cUPUFUHn
	 ilVtgLsLky891lVuxt/7Rq+Uh4IlvEFFDUlK304bxPsYV2p1bByIec+/y837xpbJ0t
	 W9AXWKup0OXFuT3C8Nv/ZkdYgq+s0WQQPvUtAbD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0193/1146] net: airoha: Add missing RX_CPU_IDX() configuration in airoha_qdma_cleanup_rx_queue()
Date: Wed, 20 May 2026 18:07:23 +0200
Message-ID: <20260520162152.643722428@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 656121b155030086b01cfce9bd31b0c925ee6860 ]

When the descriptor index written in REG_RX_CPU_IDX() is equal to the one
stored in REG_RX_DMA_IDX(), the hw will stop since the QDMA RX ring is
empty.
Add missing REG_RX_CPU_IDX() configuration in airoha_qdma_cleanup_rx_queue
routine during QDMA RX ring cleanup.

Fixes: 514aac359987 ("net: airoha: Add missing cleanup bits in airoha_qdma_cleanup_rx_queue()")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260408-airoha-cpu-idx-airoha_qdma_cleanup_rx_queue-v1-1-8efa64844308@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index c14cdce588a7c..9e995094c32af 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -825,6 +825,11 @@ static void airoha_qdma_cleanup_rx_queue(struct airoha_queue *q)
 	}
 
 	q->head = q->tail;
+	/* Set RX_DMA_IDX to RX_CPU_IDX to notify the hw the QDMA RX ring is
+	 * empty.
+	 */
+	airoha_qdma_rmw(qdma, REG_RX_CPU_IDX(qid), RX_RING_CPU_IDX_MASK,
+			FIELD_PREP(RX_RING_CPU_IDX_MASK, q->head));
 	airoha_qdma_rmw(qdma, REG_RX_DMA_IDX(qid), RX_RING_DMA_IDX_MASK,
 			FIELD_PREP(RX_RING_DMA_IDX_MASK, q->tail));
 }
-- 
2.53.0



