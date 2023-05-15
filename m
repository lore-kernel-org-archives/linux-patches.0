Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFFFFBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2ADC433D2;
	Mon, 15 May 2023 17:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170344;
	bh=8Lgu7rcqPYGGGIGRc7qodfM48wMhsSauvbe+6XYwy8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1npMDIjbJIGMJpiJQcgKAXjtBeowKtraunTquIGj16ZCTc0mBEV4Wl4C3Nd6w3tz5
	 MEZuVanCtejY/Ua/UxvGfUDTBjLbjZ9dE03xv/tDT+TnlIWmr6qrxw2GlQ3v0atywX
	 4pvUlDpN5tSxe2rvp/HEuW+iwKP3YKLDVxvHTkVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sylvain Ouellet <souellet@genetec.com>,
	Olivier Bacon <obacon@genetec.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/239] crypto: engine - fix crypto_queue backlog handling
Date: Mon, 15 May 2023 18:26:05 +0200
Message-Id: <20230515161724.742706737@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Olivier Bacon <olivierb89@gmail.com>

[ Upstream commit 4140aafcff167b5b9e8dae6a1709a6de7cac6f74 ]

CRYPTO_TFM_REQ_MAY_BACKLOG tells the crypto driver that it should
internally backlog requests until the crypto hw's queue becomes
full. At that point, crypto_engine backlogs the request and returns
-EBUSY. Calling driver such as dm-crypt then waits until the
complete() function is called with a status of -EINPROGRESS before
sending a new request.

The problem lies in the call to complete() with a value of -EINPROGRESS
that is made when a backlog item is present on the queue. The call is
done before the successful execution of the crypto request. In the case
that do_one_request() returns < 0 and the retry support is available,
the request is put back in the queue. This leads upper drivers to send
a new request even if the queue is still full.

The problem can be reproduced by doing a large dd into a crypto
dm-crypt device. This is pretty easy to see when using
Freescale CAAM crypto driver and SWIOTLB dma. Since the actual amount
of requests that can be hold in the queue is unlimited we get IOs error
and dma allocation.

The fix is to call complete with a value of -EINPROGRESS only if
the request is not enqueued back in crypto_queue. This is done
by calling complete() later in the code. In order to delay the decision,
crypto_queue is modified to correctly set the backlog pointer
when a request is enqueued back.

Fixes: 6a89f492f8e5 ("crypto: engine - support for parallel requests based on retry mechanism")
Co-developed-by: Sylvain Ouellet <souellet@genetec.com>
Signed-off-by: Sylvain Ouellet <souellet@genetec.com>
Signed-off-by: Olivier Bacon <obacon@genetec.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algapi.c        | 3 +++
 crypto/crypto_engine.c | 6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index c72622f20f52b..8c3a869cc43a9 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -944,6 +944,9 @@ EXPORT_SYMBOL_GPL(crypto_enqueue_request);
 void crypto_enqueue_request_head(struct crypto_queue *queue,
 				 struct crypto_async_request *request)
 {
+	if (unlikely(queue->qlen >= queue->max_qlen))
+		queue->backlog = queue->backlog->prev;
+
 	queue->qlen++;
 	list_add(&request->list, &queue->list);
 }
diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 48c15f4079bb8..50bac2ab55f17 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -129,9 +129,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	if (!engine->retry_support)
 		engine->cur_req = async_req;
 
-	if (backlog)
-		crypto_request_complete(backlog, -EINPROGRESS);
-
 	if (engine->busy)
 		was_busy = true;
 	else
@@ -217,6 +214,9 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	crypto_request_complete(async_req, ret);
 
 retry:
+	if (backlog)
+		crypto_request_complete(backlog, -EINPROGRESS);
+
 	/* If retry mechanism is supported, send new requests to engine */
 	if (engine->retry_support) {
 		spin_lock_irqsave(&engine->queue_lock, flags);
-- 
2.39.2



