Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DF2FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0E9C433D2;
	Mon, 15 May 2023 17:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171212;
	bh=00FmT+z1PKLvoKIRJY9/jHXNtjJzgtWwtcL1SvPB5gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUzp7jXrVe7pDhXfxgghVLlYENiUwYoLEzNPB9kMxKdgbgTH9M/pY1h13wHsPxEwp
	 l8YUAfUvE3t/6PCGQBYrUeTwPFRAAuf+HxlrYeoP2g4w+ZuyPb5CTXbykPRVp7ArMn
	 5AXouq6Pqy+RkFP2s8xgXj8qNWzhuGqY0DYsVlmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 107/242] crypto: engine - Use crypto_request_complete
Date: Mon, 15 May 2023 18:27:13 +0200
Message-Id: <20230515161725.114096241@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 6909823d47c17cba84e9244d04050b5db8d53789 ]

Use the crypto_request_complete helper instead of calling the
completion function directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 4140aafcff16 ("crypto: engine - fix crypto_queue backlog handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/crypto_engine.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index bb8e77077f020..48c15f4079bb8 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -54,7 +54,7 @@ static void crypto_finalize_request(struct crypto_engine *engine,
 		}
 	}
 	lockdep_assert_in_softirq();
-	req->complete(req, err);
+	crypto_request_complete(req, err);
 
 	kthread_queue_work(engine->kworker, &engine->pump_requests);
 }
@@ -130,7 +130,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		engine->cur_req = async_req;
 
 	if (backlog)
-		backlog->complete(backlog, -EINPROGRESS);
+		crypto_request_complete(backlog, -EINPROGRESS);
 
 	if (engine->busy)
 		was_busy = true;
@@ -214,7 +214,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	}
 
 req_err_2:
-	async_req->complete(async_req, ret);
+	crypto_request_complete(async_req, ret);
 
 retry:
 	/* If retry mechanism is supported, send new requests to engine */
-- 
2.39.2



