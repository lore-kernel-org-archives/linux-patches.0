Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE823BB2C
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u92dum4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5231C433C7;
	Wed, 15 Nov 2023 19:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078019;
	bh=WfLkSuwsWGM5ziRXxy9yrwOd5gdVgrxsONL0DSn99Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u92dum4hgfTkve7JK2zQaYT8pCccTopnOJc0gDUgFJ/DTzr088nR3kvRBKCHW96tV
	 TxwwupXIzajRwkI9qCHiwBjUuwSsgEvpNlg3w1MikVP+jNyZLuBrlytW+Vs5mP4VVa
	 aEjQ2pVOO01/aC/i/231kUfRms5ZqTkYmUc+fD4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/379] tls: Only use data field in crypto completion function
Date: Wed, 15 Nov 2023 14:21:50 -0500
Message-ID: <20231115192647.234450116@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

[ Upstream commit 8d338c76f7cfe0eb4bc46078b1c09c8c5fc75353 ]

The crypto_async_request passed to the completion is not guaranteed
to be the original request object.  Only the data field can be relied
upon.

Fix this by storing the socket pointer with the AEAD request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: a2713257ee2b ("tls: Use size_add() in call to struct_size()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls.h    |  2 ++
 net/tls/tls_sw.c | 40 +++++++++++++++++++++++++++++-----------
 2 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 17737a65c643a..0672acab27731 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -70,6 +70,8 @@ struct tls_rec {
 	char content_type;
 	struct scatterlist sg_content_type;
 
+	struct sock *sk;
+
 	char aad_space[TLS_AAD_SPACE_SIZE];
 	u8 iv_data[MAX_IV_SIZE];
 	struct aead_request aead_req;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 2af72d349192e..62d25f355d2c0 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -38,6 +38,7 @@
 #include <linux/bug.h>
 #include <linux/sched/signal.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/splice.h>
 #include <crypto/aead.h>
 
@@ -57,6 +58,7 @@ struct tls_decrypt_arg {
 };
 
 struct tls_decrypt_ctx {
+	struct sock *sk;
 	u8 iv[MAX_IV_SIZE];
 	u8 aad[TLS_MAX_AAD_SIZE];
 	u8 tail;
@@ -179,18 +181,25 @@ static int tls_padding_length(struct tls_prot_info *prot, struct sk_buff *skb,
 	return sub;
 }
 
-static void tls_decrypt_done(struct crypto_async_request *req, int err)
+static void tls_decrypt_done(crypto_completion_data_t *data, int err)
 {
-	struct aead_request *aead_req = (struct aead_request *)req;
+	struct aead_request *aead_req = crypto_get_completion_data(data);
+	struct crypto_aead *aead = crypto_aead_reqtfm(aead_req);
 	struct scatterlist *sgout = aead_req->dst;
 	struct scatterlist *sgin = aead_req->src;
 	struct tls_sw_context_rx *ctx;
+	struct tls_decrypt_ctx *dctx;
 	struct tls_context *tls_ctx;
 	struct scatterlist *sg;
 	unsigned int pages;
 	struct sock *sk;
+	int aead_size;
 
-	sk = (struct sock *)req->data;
+	aead_size = sizeof(*aead_req) + crypto_aead_reqsize(aead);
+	aead_size = ALIGN(aead_size, __alignof__(*dctx));
+	dctx = (void *)((u8 *)aead_req + aead_size);
+
+	sk = dctx->sk;
 	tls_ctx = tls_get_ctx(sk);
 	ctx = tls_sw_ctx_rx(tls_ctx);
 
@@ -242,7 +251,7 @@ static int tls_do_decryption(struct sock *sk,
 	if (darg->async) {
 		aead_request_set_callback(aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
-					  tls_decrypt_done, sk);
+					  tls_decrypt_done, aead_req);
 		atomic_inc(&ctx->decrypt_pending);
 	} else {
 		aead_request_set_callback(aead_req,
@@ -338,6 +347,8 @@ static struct tls_rec *tls_get_rec(struct sock *sk)
 	sg_set_buf(&rec->sg_aead_out[0], rec->aad_space, prot->aad_size);
 	sg_unmark_end(&rec->sg_aead_out[1]);
 
+	rec->sk = sk;
+
 	return rec;
 }
 
@@ -419,22 +430,27 @@ int tls_tx_records(struct sock *sk, int flags)
 	return rc;
 }
 
-static void tls_encrypt_done(struct crypto_async_request *req, int err)
+static void tls_encrypt_done(crypto_completion_data_t *data, int err)
 {
-	struct aead_request *aead_req = (struct aead_request *)req;
-	struct sock *sk = req->data;
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_prot_info *prot = &tls_ctx->prot_info;
-	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
+	struct aead_request *aead_req = crypto_get_completion_data(data);
+	struct tls_sw_context_tx *ctx;
+	struct tls_context *tls_ctx;
+	struct tls_prot_info *prot;
 	struct scatterlist *sge;
 	struct sk_msg *msg_en;
 	struct tls_rec *rec;
 	bool ready = false;
+	struct sock *sk;
 	int pending;
 
 	rec = container_of(aead_req, struct tls_rec, aead_req);
 	msg_en = &rec->msg_encrypted;
 
+	sk = rec->sk;
+	tls_ctx = tls_get_ctx(sk);
+	prot = &tls_ctx->prot_info;
+	ctx = tls_sw_ctx_tx(tls_ctx);
+
 	sge = sk_msg_elem(msg_en, msg_en->sg.curr);
 	sge->offset -= prot->prepend_size;
 	sge->length += prot->prepend_size;
@@ -522,7 +538,7 @@ static int tls_do_encryption(struct sock *sk,
 			       data_len, rec->iv_data);
 
 	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  tls_encrypt_done, sk);
+				  tls_encrypt_done, aead_req);
 
 	/* Add the record in tx_list */
 	list_add_tail((struct list_head *)&rec->list, &ctx->tx_list);
@@ -1495,6 +1511,7 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	 * Both structs are variable length.
 	 */
 	aead_size = sizeof(*aead_req) + crypto_aead_reqsize(ctx->aead_recv);
+	aead_size = ALIGN(aead_size, __alignof__(*dctx));
 	mem = kmalloc(aead_size + struct_size(dctx, sg, n_sgin + n_sgout),
 		      sk->sk_allocation);
 	if (!mem) {
@@ -1505,6 +1522,7 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	/* Segment the allocated memory */
 	aead_req = (struct aead_request *)mem;
 	dctx = (struct tls_decrypt_ctx *)(mem + aead_size);
+	dctx->sk = sk;
 	sgin = &dctx->sg[0];
 	sgout = &dctx->sg[n_sgin];
 
-- 
2.42.0



