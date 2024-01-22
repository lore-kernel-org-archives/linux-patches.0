Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4703029403;
	Tue, 23 Jan 2024 00:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971091; cv=none; b=dCqDgnSGZMvlbDKnV7Oput5t3VbuSRB9RigWrWpqXGcO6Pvt2aa3KHJwT8PaHW7bSphogwu5XNlOcWIym8zfdUfc12fZRYDEbke5bU8DdZYQfneNhnlhqdeaVqwPO+KycjIjVRKHacJrYHOVWXpsmOgI5dnDzu+X7IhvpZQew+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971091; c=relaxed/simple;
	bh=3+0Lu1ZDNCfp+U8X/CZ+gj2Lc6++zdgDyugonSueiFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tstoYeV1NcfrKoQamBePU/zjJ3FyvgvzQVOaM7w0M9oPabZlXVUvYPrcMbGArzaFHL4SDF2ZVnFPGK/bD6beqO12wD1WbNl4H3QaDwM1KtWNSSheOAXFfKehManwh6gS7nzyvXTHs9zMJ5wZEG3GGcxBfg/u7WSKuDUSf4yRbTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yICUxDMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yICUxDMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE288C433F1;
	Tue, 23 Jan 2024 00:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971091;
	bh=3+0Lu1ZDNCfp+U8X/CZ+gj2Lc6++zdgDyugonSueiFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yICUxDMnMLDpSAYkuKzbSgUtfy96yPqrqkVQsu4oit2BZbcBtzzaVE+T/4uorEVu+
	 49NrXv9Sz2ozmMSDA8KZ+QrSD5of2sSPzXjPW6eHAalWWt4EumIa1EjSYdRfM4ypDE
	 h94n9xewYo7eQ5nHQmlW7KiSJNdeiW4BpcfR9niA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/286] crypto: af_alg - Disallow multiple in-flight AIO requests
Date: Mon, 22 Jan 2024 15:56:32 -0800
Message-ID: <20240122235735.347766769@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9acb9d2c4bcf..755e6caf18d2 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1039,9 +1039,13 @@ EXPORT_SYMBOL_GPL(af_alg_sendpage);
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
 
@@ -1105,11 +1109,19 @@ EXPORT_SYMBOL_GPL(af_alg_poll);
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



