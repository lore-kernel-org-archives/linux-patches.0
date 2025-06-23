Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B757252917;
	Mon, 23 Jun 2025 13:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684216; cv=none; b=tY7KTmY6wLQCYFZfXKkI+MyeV2GTMG+HR4KLSkbLZoTDGvBwNzQ5FzefFGPlklZDbd/WkJ2oKXyZMapXhzd0ptKn267RH3TVOcgnTIyDQXSsBykQrroba5FwDJKW9W/eU/qd/rwa0pcAhmk72f8/SKdNZ8Ao1V1anLXaXH7AvvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684216; c=relaxed/simple;
	bh=j519RX/iLTf1rnCuN/XIkPfeuYv7WVVj75U7TEzAg3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XiUeRxvwNEpKtN0IfvCqNPFjLvVoJIfRrNa2OlPwtMV2OdwairpnXnQ9nPb6tjNFpriuWp0VdP+5HvrElNkvRTSBorL+p2dDYKfMBPKvkG2EsAzkFAU+kRKSHnSDbKh9HAncb9qoLMEt9AuNnrvSJ+bQzPBWwM2fk3fH8kttwkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZ0cBARH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZ0cBARH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24DCC4CEEA;
	Mon, 23 Jun 2025 13:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684216;
	bh=j519RX/iLTf1rnCuN/XIkPfeuYv7WVVj75U7TEzAg3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZ0cBARHaDZAxphE4MGyaPHph0ixru6ceCYHOJnmf5A9FzTcFvIZTw1T0w27UMz4C
	 MLiPrclSlGnNdK9Jm3wmlWpsDRaNkfP8ZKq4XYC5asyoB5bDkJ+DuIppoWvaOdPpDI
	 9UGYoDfhoZXL9rNukxv5yo2s4uu750D40s6OUfds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Klaus Kudielka <klaus.kudielka@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 002/290] crypto: marvell/cesa - Do not chain submitted requests
Date: Mon, 23 Jun 2025 15:04:23 +0200
Message-ID: <20250623130626.999774646@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 0413bcf0fc460a68a2a7a8354aee833293d7d693 upstream.

This driver tries to chain requests together before submitting them
to hardware in order to reduce completion interrupts.

However, it even extends chains that have already been submitted
to hardware.  This is dangerous because there is no way of knowing
whether the hardware has already read the DMA memory in question
or not.

Fix this by splitting the chain list into two.  One for submitted
requests and one for requests that have not yet been submitted.
Only extend the latter.

Reported-by: Klaus Kudielka <klaus.kudielka@gmail.com>
Fixes: 85030c5168f1 ("crypto: marvell - Add support for chaining crypto requests in TDMA mode")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/marvell/cesa/cesa.c |    2 -
 drivers/crypto/marvell/cesa/cesa.h |    9 ++++--
 drivers/crypto/marvell/cesa/tdma.c |   53 ++++++++++++++++++++++---------------
 3 files changed, 39 insertions(+), 25 deletions(-)

--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -94,7 +94,7 @@ static int mv_cesa_std_process(struct mv
 
 static int mv_cesa_int_process(struct mv_cesa_engine *engine, u32 status)
 {
-	if (engine->chain.first && engine->chain.last)
+	if (engine->chain_hw.first && engine->chain_hw.last)
 		return mv_cesa_tdma_process(engine, status);
 
 	return mv_cesa_std_process(engine, status);
--- a/drivers/crypto/marvell/cesa/cesa.h
+++ b/drivers/crypto/marvell/cesa/cesa.h
@@ -440,8 +440,10 @@ struct mv_cesa_dev {
  *			SRAM
  * @queue:		fifo of the pending crypto requests
  * @load:		engine load counter, useful for load balancing
- * @chain:		list of the current tdma descriptors being processed
- *			by this engine.
+ * @chain_hw:		list of the current tdma descriptors being processed
+ *			by the hardware.
+ * @chain_sw:		list of the current tdma descriptors that will be
+ *			submitted to the hardware.
  * @complete_queue:	fifo of the processed requests by the engine
  *
  * Structure storing CESA engine information.
@@ -463,7 +465,8 @@ struct mv_cesa_engine {
 	struct gen_pool *pool;
 	struct crypto_queue queue;
 	atomic_t load;
-	struct mv_cesa_tdma_chain chain;
+	struct mv_cesa_tdma_chain chain_hw;
+	struct mv_cesa_tdma_chain chain_sw;
 	struct list_head complete_queue;
 	int irq;
 };
--- a/drivers/crypto/marvell/cesa/tdma.c
+++ b/drivers/crypto/marvell/cesa/tdma.c
@@ -38,6 +38,15 @@ void mv_cesa_dma_step(struct mv_cesa_req
 {
 	struct mv_cesa_engine *engine = dreq->engine;
 
+	spin_lock_bh(&engine->lock);
+	if (engine->chain_sw.first == dreq->chain.first) {
+		engine->chain_sw.first = NULL;
+		engine->chain_sw.last = NULL;
+	}
+	engine->chain_hw.first = dreq->chain.first;
+	engine->chain_hw.last = dreq->chain.last;
+	spin_unlock_bh(&engine->lock);
+
 	writel_relaxed(0, engine->regs + CESA_SA_CFG);
 
 	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACC0_IDMA_DONE);
@@ -96,25 +105,27 @@ void mv_cesa_dma_prepare(struct mv_cesa_
 void mv_cesa_tdma_chain(struct mv_cesa_engine *engine,
 			struct mv_cesa_req *dreq)
 {
-	if (engine->chain.first == NULL && engine->chain.last == NULL) {
-		engine->chain.first = dreq->chain.first;
-		engine->chain.last  = dreq->chain.last;
-	} else {
-		struct mv_cesa_tdma_desc *last;
+	struct mv_cesa_tdma_desc *last = engine->chain_sw.last;
 
-		last = engine->chain.last;
+	/*
+	 * Break the DMA chain if the request being queued needs the IV
+	 * regs to be set before lauching the request.
+	 */
+	if (!last || dreq->chain.first->flags & CESA_TDMA_SET_STATE)
+		engine->chain_sw.first = dreq->chain.first;
+	else {
 		last->next = dreq->chain.first;
-		engine->chain.last = dreq->chain.last;
-
-		/*
-		 * Break the DMA chain if the CESA_TDMA_BREAK_CHAIN is set on
-		 * the last element of the current chain, or if the request
-		 * being queued needs the IV regs to be set before lauching
-		 * the request.
-		 */
-		if (!(last->flags & CESA_TDMA_BREAK_CHAIN) &&
-		    !(dreq->chain.first->flags & CESA_TDMA_SET_STATE))
-			last->next_dma = cpu_to_le32(dreq->chain.first->cur_dma);
+		last->next_dma = cpu_to_le32(dreq->chain.first->cur_dma);
+	}
+	last = dreq->chain.last;
+	engine->chain_sw.last = last;
+	/*
+	 * Break the DMA chain if the CESA_TDMA_BREAK_CHAIN is set on
+	 * the last element of the current chain.
+	 */
+	if (last->flags & CESA_TDMA_BREAK_CHAIN) {
+		engine->chain_sw.first = NULL;
+		engine->chain_sw.last = NULL;
 	}
 }
 
@@ -127,7 +138,7 @@ int mv_cesa_tdma_process(struct mv_cesa_
 
 	tdma_cur = readl(engine->regs + CESA_TDMA_CUR);
 
-	for (tdma = engine->chain.first; tdma; tdma = next) {
+	for (tdma = engine->chain_hw.first; tdma; tdma = next) {
 		spin_lock_bh(&engine->lock);
 		next = tdma->next;
 		spin_unlock_bh(&engine->lock);
@@ -149,12 +160,12 @@ int mv_cesa_tdma_process(struct mv_cesa_
 								 &backlog);
 
 			/* Re-chaining to the next request */
-			engine->chain.first = tdma->next;
+			engine->chain_hw.first = tdma->next;
 			tdma->next = NULL;
 
 			/* If this is the last request, clear the chain */
-			if (engine->chain.first == NULL)
-				engine->chain.last  = NULL;
+			if (engine->chain_hw.first == NULL)
+				engine->chain_hw.last  = NULL;
 			spin_unlock_bh(&engine->lock);
 
 			ctx = crypto_tfm_ctx(req->tfm);


