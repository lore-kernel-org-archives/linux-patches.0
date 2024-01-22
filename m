Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF42A3D63;
	Tue, 23 Jan 2024 01:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972171; cv=none; b=EtSTYszJz86PeMQuC7JRmGKClFgfxG9zRhBwKtQIjDkryDj4FtRXflvnRPvac6McQrk7M5uiyRaGO1bKcHkoD++WMlOXGAyIjF1c903t+0R+6LXx/GrcWg4FtZh/5LGvVg84D5sg3IMmHugBo1OUszYccsU9VELkjPPmfdwA/rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972171; c=relaxed/simple;
	bh=j6CC5zup8YltpHywoGFbheBt1qkJX2ZKJyMaF6DNzIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMCHFC5NIyJh74ZowrGH+uzYidsniyCPn22zGz7fNkOtHwQyOUNF/0teujn46+FpRs7URDSk/p3Tzoea190fZbijEgjV50Rzl7IOVXiYwwQQiLnXJ7LExhBuLkDvkcoWDZKHUf6WRvWsvFxApJoFpHU6x37Tl+dUT+dKTwgcv8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVCyhOQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVCyhOQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD6DC433C7;
	Tue, 23 Jan 2024 01:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972171;
	bh=j6CC5zup8YltpHywoGFbheBt1qkJX2ZKJyMaF6DNzIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVCyhOQtUH40fF8l07qyHFlEJrZjRjJWoLmPaoWYt0HUXfZuQGIEGtkH8h4WX5yQ3
	 u6Vv4gNe3OiyLaTDjHuS2LuEttTly9xsoNbZ84vgs+IgxMoqzxZTVWSuTuNwQ74Tq+
	 ueuPKaFY7JeIv2yLMqJVQEsE1Mh+tYcJ6fesqwuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/374] crypto: af_alg - Disallow multiple in-flight AIO requests
Date: Mon, 22 Jan 2024 15:55:53 -0800
Message-ID: <20240122235747.971767473@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 67b164a871af1d736f131fd6fe78a610909f06f3 ]

Having multiple in-flight AIO requests results in unpredictable
output because they all share the same IV.  Fix this by only allowing
one request at a time.

Fixes: 83094e5e9e49 ("crypto: af_alg - add async support to algif_aead")
Fixes: a596999b7ddf ("crypto: algif - change algif_skcipher to be asynchronous")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c         | 14 +++++++++++++-
 include/crypto/if_alg.h |  3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 8bd288d2b089..aa93501e27b9 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1045,9 +1045,13 @@ EXPORT_SYMBOL_GPL(af_alg_sendpage);
 void af_alg_free_resources(struct af_alg_async_req *areq)
 {
 	struct sock *sk = areq->sk;
+	struct af_alg_ctx *ctx;
 
 	af_alg_free_areq_sgls(areq);
 	sock_kfree_s(sk, areq, areq->areqlen);
+
+	ctx = alg_sk(sk)->private;
+	ctx->inflight = false;
 }
 EXPORT_SYMBOL_GPL(af_alg_free_resources);
 
@@ -1117,11 +1121,19 @@ EXPORT_SYMBOL_GPL(af_alg_poll);
 struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
 					   unsigned int areqlen)
 {
-	struct af_alg_async_req *areq = sock_kmalloc(sk, areqlen, GFP_KERNEL);
+	struct af_alg_ctx *ctx = alg_sk(sk)->private;
+	struct af_alg_async_req *areq;
+
+	/* Only one AIO request can be in flight. */
+	if (ctx->inflight)
+		return ERR_PTR(-EBUSY);
 
+	areq = sock_kmalloc(sk, areqlen, GFP_KERNEL);
 	if (unlikely(!areq))
 		return ERR_PTR(-ENOMEM);
 
+	ctx->inflight = true;
+
 	areq->areqlen = areqlen;
 	areq->sk = sk;
 	areq->last_rsgl = NULL;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index a5db86670bdf..a406e281ae57 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -138,6 +138,7 @@ struct af_alg_async_req {
  *			recvmsg is invoked.
  * @init:		True if metadata has been sent.
  * @len:		Length of memory allocated for this data structure.
+ * @inflight:		Non-zero when AIO requests are in flight.
  */
 struct af_alg_ctx {
 	struct list_head tsgl_list;
@@ -156,6 +157,8 @@ struct af_alg_ctx {
 	bool init;
 
 	unsigned int len;
+
+	unsigned int inflight;
 };
 
 int af_alg_register_type(const struct af_alg_type *type);
-- 
2.43.0



