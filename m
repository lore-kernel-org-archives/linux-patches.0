Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9FD50A8F;
	Tue, 23 Jan 2024 00:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970504; cv=none; b=jfuBop+sJJulnoIOxMv+Z+b2aDWcZaJAmeYJ2sp5OMW5n1nmCpjhVO8vTGeoNJyRBzWFV2gYBmUPERDqdAXBHJJTju0QtsIl7KKS5QWvQnkRkAQEYIhO0FpZATJxd5d/Udg8mofx/aTp2Bi7X/A3ahBcxkQuJrNM3G8CJ4BQF9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970504; c=relaxed/simple;
	bh=o3AU3xcroDuuuVHujeb69GDmndxu/EsQdIlnVl1bK7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqqOG/mg0M5WKXHvcQ61IuSNFjb9XH3wlLBnArUj7bdLf/0xgTP6ujBy48DnjLPyCAy6S0w/VeNcNXMxIDB8km6UJcyqIgQKTCMjeeH6o0CFnOAmADVCk1G1IA2Vvp7hLN9MYqe6T/PYGX5SFDN2h2g65B+Gj/Yo57RsxIBCgh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tsh1kcE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tsh1kcE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAB7C433C7;
	Tue, 23 Jan 2024 00:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970504;
	bh=o3AU3xcroDuuuVHujeb69GDmndxu/EsQdIlnVl1bK7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tsh1kcE6TYnHLGUREeuaXHV9Bt8ZGdXlEkjl57xce/8bXEun71n0nyc94dFW+mlI8
	 aTzWFmEmz9Y4YszPVbrmksZrkhItYaMY9R7C9nzmn18mGL1T5UVHZfSPMNWllnCY2U
	 mPin5h5/afzNAE+UxfbL9cibBpzWTznmWOkkJNzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/417] crypto: af_alg - Disallow multiple in-flight AIO requests
Date: Mon, 22 Jan 2024 15:53:25 -0800
Message-ID: <20240122235752.901321180@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e893c0f6c879..fef69d2a6b18 100644
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



