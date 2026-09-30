Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D88405C3F;
	Wed, 30 Sep 2026 19:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797220; cv=none; b=TdzOl585JdpQr1LCD5LQYVK1K7Q/reuxWO9KsB5UT6kgQ9Rl0pEqJtgubRNUm2oKaYu0plQdlEOdTqxTp9Zz4LTrqwvu0uqtH+7VcLa0xotJQw1aG94AmPUDnZK2VlRtuiBwYO/EzlOr6jdhvoJtszBM4ZOPfrGerib8dxJ2uDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797220; c=relaxed/simple;
	bh=rqq+pttKpz9uFZ9141G8ldSf48tEDSfxWTZDKujCKpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BahbVhWFevAAaP3oIBBmEzGNDAprNsRPTXQi41R8qK12bRbAxUbziZmL14mQE8vsXagTzrPyhP+s3JGR5tIlsgtbuSuDnwlTW2hQFPcHgg9xvYMuXtBIw/wWIEAql47371NDnT6fia1mnchglFxCS/7bzKHJRpy/R38kliS4h1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IF76pxru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IF76pxru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931801F000FF;
	Wed, 30 Sep 2026 19:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797219;
	bh=/mX0wOW/kqC1F8YbuIsoFZ4zhhialP1Po/hvaGODqvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IF76pxruL5o/DFwCxiPzxQftlNwQ4Wm7JbPvu9tptAu+2xPshWCAHf9X/kHHXip50
	 Vn2BBRIxIvHXJoY/amyFqO2FP0HXJHgR8Dg4TPAb2ll9XgI/tSOoz/TAnH9zdr0wq+
	 PSGGtmUqh69bnEbp895JcSapcpMpx59eh0gsBuU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1187/1193] crypto: virtio - Drop superfluous [as]kcipher_req pointer
Date: Wed, 30 Sep 2026 17:31:11 +0200
Message-ID: <20260930152500.617539454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 62d027fb49c76475c5256ab69059752f42c3730f ]

The request context virtio_crypto_{akcipher,sym}_request contains a
pointer to the [as]kcipher_request itself.

The pointer is superfluous as it can be calculated with container_of().

Drop the superfluous pointer.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: f77a956f6a19 ("crypto: virtio - bound the akcipher result length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c |    9 ++++-----
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c |    8 +++-----
 2 files changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -36,7 +36,6 @@ struct virtio_crypto_akcipher_ctx {
 
 struct virtio_crypto_akcipher_request {
 	struct virtio_crypto_request base;
-	struct akcipher_request *akcipher_req;
 	void *src_buf;
 	void *dst_buf;
 	uint32_t opcode;
@@ -68,7 +67,9 @@ static void virtio_crypto_dataq_akcipher
 {
 	struct virtio_crypto_akcipher_request *vc_akcipher_req =
 		container_of(vc_req, struct virtio_crypto_akcipher_request, base);
-	struct akcipher_request *akcipher_req;
+	struct akcipher_request *akcipher_req =
+		container_of((void *)vc_akcipher_req, struct akcipher_request,
+			     __ctx);
 	int error;
 
 	switch (vc_req->status) {
@@ -87,8 +88,7 @@ static void virtio_crypto_dataq_akcipher
 		break;
 	}
 
-	akcipher_req = vc_akcipher_req->akcipher_req;
-	/* actual length maybe less than dst buffer */
+	/* actual length may be less than dst buffer */
 	akcipher_req->dst_len = len - sizeof(vc_req->status);
 	sg_copy_from_buffer(akcipher_req->dst, sg_nents(akcipher_req->dst),
 			    vc_akcipher_req->dst_buf, akcipher_req->dst_len);
@@ -320,7 +320,6 @@ static int virtio_crypto_rsa_req(struct
 
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_akcipher_callback;
-	vc_akcipher_req->akcipher_req = req;
 	vc_akcipher_req->opcode = opcode;
 
 	return crypto_transfer_akcipher_request_to_engine(data_vq->engine, req);
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -28,7 +28,6 @@ struct virtio_crypto_sym_request {
 
 	/* Cipher or aead */
 	uint32_t type;
-	struct skcipher_request *skcipher_req;
 	uint8_t *iv;
 	/* Encryption? */
 	bool encrypt;
@@ -56,7 +55,9 @@ static void virtio_crypto_dataq_sym_call
 {
 	struct virtio_crypto_sym_request *vc_sym_req =
 		container_of(vc_req, struct virtio_crypto_sym_request, base);
-	struct skcipher_request *ablk_req;
+	struct skcipher_request *ablk_req =
+		container_of((void *)vc_sym_req, struct skcipher_request,
+			     __ctx);
 	int error;
 
 	/* Finish the encrypt or decrypt process */
@@ -76,7 +77,6 @@ static void virtio_crypto_dataq_sym_call
 			error = -EIO;
 			break;
 		}
-		ablk_req = vc_sym_req->skcipher_req;
 		virtio_crypto_skcipher_finalize_req(vc_sym_req,
 							ablk_req, error);
 	}
@@ -480,7 +480,6 @@ static int virtio_crypto_skcipher_encryp
 
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_sym_callback;
-	vc_sym_req->skcipher_req = req;
 	vc_sym_req->encrypt = true;
 
 	return crypto_transfer_skcipher_request_to_engine(data_vq->engine, req);
@@ -504,7 +503,6 @@ static int virtio_crypto_skcipher_decryp
 
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_sym_callback;
-	vc_sym_req->skcipher_req = req;
 	vc_sym_req->encrypt = false;
 
 	return crypto_transfer_skcipher_request_to_engine(data_vq->engine, req);


