Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265855B5C6;
	Tue, 23 Jan 2024 01:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974324; cv=none; b=qKc8nNPqhqWtMfrC1DVDcopB0nPfPwOkTf/FSM4Oe2Y4EJCkzwpxofvdXZEZVL33VUv8G/xdzFubEeT2Yh04RA/Izjm2yonazxybBvby0DpfLHIJpNNnYHSdw1J/mZFSTaX881AldQUO8uVj8ZazbwV02aKRr1xB/13KkxyUDc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974324; c=relaxed/simple;
	bh=c/s5E+K0yodD/tpkSO4zj3OaAmWIinBlp2mWpp5G+3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ly66keoKvMfs9IlrnCWzYQWhpoSRyNt8xJOAiLT4WgvFDzKda1F83GL4qxIdSA2FXU+Gq+HCbP4zeEX6I5eiuY1LdKykUuNNQYjClp6BCQE0kLPEblcHNToogbF75j0/5GJMk0JNtROGhdIl4D/tB/bgYBcNB/QzXUGPSzvo9O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sxx6YOUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sxx6YOUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1E0C43390;
	Tue, 23 Jan 2024 01:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974323;
	bh=c/s5E+K0yodD/tpkSO4zj3OaAmWIinBlp2mWpp5G+3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sxx6YOUh9OixhzHvfQGu1+FXiThfLbGP4NOOEB2yTxDmzNWlBCRpVVUAE82mi/Pfx
	 8cf2nbLon6IJqbqbTcx1XjXFQTpYcf859i4iQzJYSkpAPRZMuwbQaT8Mg+N7R/LTnC
	 ++vOfmlixomEMxs0dUaPjewInMzUu+FQO7RtJM4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/583] crypto: af_alg - Disallow multiple in-flight AIO requests
Date: Mon, 22 Jan 2024 15:51:38 -0800
Message-ID: <20240122235813.578030080@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ea6fb8e89d06..68cc9290cabe 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1116,9 +1116,13 @@ EXPORT_SYMBOL_GPL(af_alg_sendmsg);
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
 
@@ -1188,11 +1192,19 @@ EXPORT_SYMBOL_GPL(af_alg_poll);
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
 	areq->first_rsgl.sgl.sgt.sgl = areq->first_rsgl.sgl.sgl;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index ef8ce86b1f78..08b803a4fcde 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -136,6 +136,7 @@ struct af_alg_async_req {
  *			recvmsg is invoked.
  * @init:		True if metadata has been sent.
  * @len:		Length of memory allocated for this data structure.
+ * @inflight:		Non-zero when AIO requests are in flight.
  */
 struct af_alg_ctx {
 	struct list_head tsgl_list;
@@ -154,6 +155,8 @@ struct af_alg_ctx {
 	bool init;
 
 	unsigned int len;
+
+	unsigned int inflight;
 };
 
 int af_alg_register_type(const struct af_alg_type *type);
-- 
2.43.0



