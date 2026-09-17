Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4893D34B6;
	Thu, 17 Sep 2026 18:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671427; cv=none; b=horNnKb9Q5/vy0eZRQLQ9WfezXIgXWQR3t+eecVHqSifcbLqZP5huymR52PbNWkGW/ThSaqFPrBwkuDHm+qutBBwP8JpEOZnMlRHc8scdT/7NJYk67zAD5M0VKM+AIGzWJEmdMM36J6PxV0preywEdhi7MQas0LjG1CtMhPt7Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671427; c=relaxed/simple;
	bh=DGrGhjNLbumaDVHxX/xk3XRFbRSt8OMHgjsCmrxcEjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=St85ROdq1yMk3IlG415ztUEPxXGJa3B8Ty2QrcsWeJEhu+a7xm9O23hs9SSmOfYAs2gNfW2PexCddMvL3zKp93ckgEba6SPDb/IxqTJfQ8PnvQmt8hMd1n55igBKbhCUMnoLrNiX2zCVwxadnK2ffYu9yvhbuTXQyjbLnnZhvGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEi+hnZS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEi+hnZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2BF1F000FF;
	Thu, 17 Sep 2026 18:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671426;
	bh=dBVIH4xTOI3ArNaSHbvOpYF5TGeP9SOJkhdUlzVdet8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kEi+hnZSBZb2+MZ6oUlSJJfOpv//ehIP0/fPv20hgbY7K4skbTe9yYBtrFjggwwDo
	 c9+VCrgynBiap0ze7qLBmk0pTmKcbvj969k27tnbaclbJpW7DO+dQefu8uQbHXZqw2
	 7KaZqa2ewb/o6dHEu0NkFNIQVEiaqbJCGCAJ/fik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0973/1102] crypto: virtio - Drop superfluous [as]kcipher_ctx pointer
Date: Thu, 17 Sep 2026 16:15:16 +0100
Message-ID: <20260917151605.116921158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit dc91d858fb9251b25828ab63ac7220145cef282c ]

The request context virtio_crypto_{akcipher,sym}_request contains a
pointer to the transform context virtio_crypto_[as]kcipher_ctx.

The pointer is superfluous as it can be calculated with the cheap
crypto_akcipher_reqtfm() + akcipher_tfm_ctx() and
crypto_skcipher_reqtfm() + crypto_skcipher_ctx() combos.

Drop the superfluous pointer.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: f77a956f6a19 ("crypto: virtio - bound the akcipher result length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c |    8 ++++----
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c |    5 +----
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -36,7 +36,6 @@ struct virtio_crypto_akcipher_ctx {
 
 struct virtio_crypto_akcipher_request {
 	struct virtio_crypto_request base;
-	struct virtio_crypto_akcipher_ctx *akcipher_ctx;
 	struct akcipher_request *akcipher_req;
 	void *src_buf;
 	void *dst_buf;
@@ -213,7 +212,8 @@ out:
 static int __virtio_crypto_akcipher_do_req(struct virtio_crypto_akcipher_request *vc_akcipher_req,
 		struct akcipher_request *req, struct data_queue *data_vq)
 {
-	struct virtio_crypto_akcipher_ctx *ctx = vc_akcipher_req->akcipher_ctx;
+	struct crypto_akcipher *atfm = crypto_akcipher_reqtfm(req);
+	struct virtio_crypto_akcipher_ctx *ctx = akcipher_tfm_ctx(atfm);
 	struct virtio_crypto_request *vc_req = &vc_akcipher_req->base;
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
 	struct virtio_crypto_op_data_req *req_data = vc_req->req_data;
@@ -273,7 +273,8 @@ static int virtio_crypto_rsa_do_req(stru
 	struct akcipher_request *req = container_of(vreq, struct akcipher_request, base);
 	struct virtio_crypto_akcipher_request *vc_akcipher_req = akcipher_request_ctx(req);
 	struct virtio_crypto_request *vc_req = &vc_akcipher_req->base;
-	struct virtio_crypto_akcipher_ctx *ctx = vc_akcipher_req->akcipher_ctx;
+	struct crypto_akcipher *atfm = crypto_akcipher_reqtfm(req);
+	struct virtio_crypto_akcipher_ctx *ctx = akcipher_tfm_ctx(atfm);
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
 	struct data_queue *data_vq = vc_req->dataq;
 	struct virtio_crypto_op_header *header;
@@ -319,7 +320,6 @@ static int virtio_crypto_rsa_req(struct
 
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_akcipher_callback;
-	vc_akcipher_req->akcipher_ctx = ctx;
 	vc_akcipher_req->akcipher_req = req;
 	vc_akcipher_req->opcode = opcode;
 
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -28,7 +28,6 @@ struct virtio_crypto_sym_request {
 
 	/* Cipher or aead */
 	uint32_t type;
-	struct virtio_crypto_skcipher_ctx *skcipher_ctx;
 	struct skcipher_request *skcipher_req;
 	uint8_t *iv;
 	/* Encryption? */
@@ -325,7 +324,7 @@ __virtio_crypto_skcipher_do_req(struct v
 		struct data_queue *data_vq)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct virtio_crypto_skcipher_ctx *ctx = vc_sym_req->skcipher_ctx;
+	struct virtio_crypto_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct virtio_crypto_request *vc_req = &vc_sym_req->base;
 	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
@@ -481,7 +480,6 @@ static int virtio_crypto_skcipher_encryp
 
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_sym_callback;
-	vc_sym_req->skcipher_ctx = ctx;
 	vc_sym_req->skcipher_req = req;
 	vc_sym_req->encrypt = true;
 
@@ -506,7 +504,6 @@ static int virtio_crypto_skcipher_decryp
 
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_sym_callback;
-	vc_sym_req->skcipher_ctx = ctx;
 	vc_sym_req->skcipher_req = req;
 	vc_sym_req->encrypt = false;
 


