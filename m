Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B81B247280;
	Sat, 12 Sep 2026 11:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212599; cv=none; b=SaCqjbirh2YoBkNRFt3okpParhz4w5nw+5zclmU28cpGgySbYpw7ihCx7W6oHBHRHUcP27dWqaHGrMRX5uyYrt/VIxbGbt61xpt1mCXMNny10Ff15DEc0wQKQvtjYZKQjfsY0moJwX8iYUz9pRULfHAsBpNB9yJnLF5GoiWBP60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212599; c=relaxed/simple;
	bh=gYXLgpMXrwpfWZAX6js02hC91ZEMoIAn9MgJX/QaWqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fOuZpdk4Uu1OzCzC6XHw3m8WDZjuLcnAscA+fhlAA6fw4knJFPnCbl2uMfvqsPURR3GOq3zhgj4etvLamPWnmh6baaJLU1SsJtwyGGSyR0YqDb4QNmKWh4vDhbPKZM10zTvUTC3/cCEjPmyhI5RMZhwnocMmtYkCNZoVUTiVbXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJA0pgUQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJA0pgUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26481F000FF;
	Sat, 12 Sep 2026 11:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212598;
	bh=tyPJ6F9Ll5KTplriQ8Dyddc7dKD61UhwD0042TPxziU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJA0pgUQCjih0h3KAnf7LA+xF0USUiHvdRdaR6X4I7qYeMFnghNiZsaUu96/riWre
	 sAK+wVM452NfkRZSucNX3S2tg3SrKDOyh+/HrYlNpgePM+wZwaEU7YJlBQ9E0Jb4AW
	 ffI3dS5kbBRMhHB8g2TyDGT+b3H5+cipwNwCGBHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1427/1518] crypto: acomp - allocate async request context when cloning
Date: Sat, 12 Sep 2026 08:59:56 +0200
Message-ID: <20260912065655.832087115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit ee440d4fc0d2f15894ab1f64c474a3adbc858880 ]

ACOMP_REQUEST_ON_STACK() reserves only enough storage for the
synchronous fallback. When an async implementation is selected, callers
clone that stack request before retrying, but acomp_request_clone()
currently copies only the stack-sized object. The clone therefore has no
storage for the async provider request context, and providers such as QAT
write past the allocation through acomp_request_ctx(). KASAN does report
a slab OOB write.

Allocate a zeroed clone large enough for the runtime acomp request size,
copy only the bytes present in the source object, and preserve the
existing fallback-on-allocation-failure behavior. Use the runtime reqsize
because an implementation may adjust it during tfm initialization.

Fixes: 097c432caaa6 ("crypto: acomp - Add ACOMP_REQUEST_CLONE")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/acompress.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 25af7697d6bb9..aa427b6235a50 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -567,12 +567,22 @@ EXPORT_SYMBOL_GPL(acomp_walk_virt);
 struct acomp_req *acomp_request_clone(struct acomp_req *req,
 				      size_t total, gfp_t gfp)
 {
+	struct crypto_tfm *tfm = req->base.tfm;
 	struct acomp_req *nreq;
+	size_t len;
 
-	nreq = container_of(crypto_request_clone(&req->base, total, gfp),
-			    struct acomp_req, base);
-	if (nreq == req)
+	len = sizeof(*req) +
+	      crypto_acomp_reqsize(crypto_acomp_reqtfm(req));
+	len = ALIGN(len, CRYPTO_MINALIGN);
+
+	nreq = kzalloc(len, gfp);
+	if (!nreq) {
+		req->base.tfm = tfm->fb;
 		return req;
+	}
+
+	memcpy(nreq, req, sizeof(*req));
+	nreq->base.flags &= ~CRYPTO_TFM_REQ_ON_STACK;
 
 	if (req->src == &req->chain.ssg)
 		nreq->src = &nreq->chain.ssg;
-- 
2.53.0



