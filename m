Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F1F29BD9A;
	Mon,  4 May 2026 13:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902946; cv=none; b=mlZFVjzVQix/XZCT/j5UxP8bM9cICzv0pZ/V7CEjnZeBoTy0DwV4FAJlZDDbDglByQxzDIZdZcLedSldD1272ZPv1KAhsLSKgj2PNOoOlmhQNra0XBddDpXeMLoZKw3Ho2+ZyHumosiQhUq+OqPTyjTdDGvYYXcceQHOu5vnKkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902946; c=relaxed/simple;
	bh=3giCfi7A/wLOELKo5lZjd1LNjdV22rvGaKCDUrQ0MSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ch7vkNHAwHHRvZgVYVfdqa1HBtwMTDkhBxURcKr0/vJ00svLPImgHekd38eiWVsJe4o/hita2EYQ+s3eqQS8n/aSJWfG3VKGzSJrHEpXdZCLYNxsX/GX2XxMcn5dzSGPAQ4GKbkoIO+5HT92vtetCgdddCnmDnL9VDSFnb06qZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kYaFrxSP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kYaFrxSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB2BC2BCB8;
	Mon,  4 May 2026 13:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902945;
	bh=3giCfi7A/wLOELKo5lZjd1LNjdV22rvGaKCDUrQ0MSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYaFrxSPQRV7IbhzonvbTGGcIalH5UBG/SVvqYVW/nVWjEE6y2Zl4oNNJgsap2apC
	 XFwByAaxqt1Uwc/bKU5CmEHyKuV0PqFnTqC9lNjxjVzLlTnW2j1LOfNHWQns++8f0k
	 lsp01SV6/HyD3uNH9MS6+M8j79vGBywxD1dWa8xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Luxing Yin <tr0jan@lzu.edu.cn>,
	Yucheng Lu <kanolyc@gmail.com>,
	Douya Le <ldy3087146292@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7.0 044/307] crypto: algif_aead - snapshot IV for async AEAD requests
Date: Mon,  4 May 2026 15:48:49 +0200
Message-ID: <20260504135144.492882224@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douya Le <ldy3087146292@gmail.com>

commit 5aa58c3a572b3e3b6c786953339f7978b845cc52 upstream.

AF_ALG AEAD AIO requests currently use the socket-wide IV buffer during
request processing.  For async requests, later socket activity can
update that shared state before the original request has fully
completed, which can lead to inconsistent IV handling.

Snapshot the IV into per-request storage when preparing the AEAD
request, so in-flight operations no longer depend on mutable socket
state.

Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Co-developed-by: Luxing Yin <tr0jan@lzu.edu.cn>
Signed-off-by: Luxing Yin <tr0jan@lzu.edu.cn>
Tested-by: Yucheng Lu <kanolyc@gmail.com>
Signed-off-by: Douya Le <ldy3087146292@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/algif_aead.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -72,8 +72,10 @@ static int _aead_recvmsg(struct socket *
 	struct af_alg_ctx *ctx = ask->private;
 	struct crypto_aead *tfm = pask->private;
 	unsigned int as = crypto_aead_authsize(tfm);
+	unsigned int ivsize = crypto_aead_ivsize(tfm);
 	struct af_alg_async_req *areq;
 	struct scatterlist *rsgl_src, *tsgl_src = NULL;
+	void *iv;
 	int err = 0;
 	size_t used = 0;		/* [in]  TX bufs to be en/decrypted */
 	size_t outlen = 0;		/* [out] RX bufs produced by kernel */
@@ -125,10 +127,14 @@ static int _aead_recvmsg(struct socket *
 
 	/* Allocate cipher request for current operation. */
 	areq = af_alg_alloc_areq(sk, sizeof(struct af_alg_async_req) +
-				     crypto_aead_reqsize(tfm));
+				     crypto_aead_reqsize(tfm) + ivsize);
 	if (IS_ERR(areq))
 		return PTR_ERR(areq);
 
+	iv = (u8 *)aead_request_ctx(&areq->cra_u.aead_req) +
+	     crypto_aead_reqsize(tfm);
+	memcpy(iv, ctx->iv, ivsize);
+
 	/* convert iovecs of output buffers into RX SGL */
 	err = af_alg_get_rsgl(sk, msg, flags, areq, outlen, &usedpages);
 	if (err)
@@ -187,7 +193,7 @@ static int _aead_recvmsg(struct socket *
 
 	/* Initialize the crypto operation */
 	aead_request_set_crypt(&areq->cra_u.aead_req, tsgl_src,
-			       areq->first_rsgl.sgl.sgt.sgl, used, ctx->iv);
+			       areq->first_rsgl.sgl.sgt.sgl, used, iv);
 	aead_request_set_ad(&areq->cra_u.aead_req, ctx->aead_assoclen);
 	aead_request_set_tfm(&areq->cra_u.aead_req, tfm);
 


