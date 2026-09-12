Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8004BEE54;
	Sat, 12 Sep 2026 09:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205196; cv=none; b=bdMH5YuwzO2kc0vqObOCl3au2CG4J//VUn2pwLLwaU0tN95yie0mGkVWO0XPQO/Ql19JLSbSnuEQ+LHYlke+TalSsZGuJ5i6qhPcDHjJWQcdm2S1NHSxMw5GJmkkhzcBkJpCgTYez8Qajng67ganJqSIWDntwflRxZ3zhLmuMac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205196; c=relaxed/simple;
	bh=YLVrXvE1W9gNwU2RarotNfkHr6ud/ZTvK10eHd/yCkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fq/CVUBP1R75rSi9yVeDehCHyePrzz8VRujBH/sKFF0dARG+S9abKyfplpnbhnpZMRKJ7Y/hQUKFBp2Zb2eiS+Jcj7aNXKif8V6wsSkeVPuu4U2PZd6j411RLP8Gq1EG6M83x3YudvMewBAO4NQFHPb8OwpS5vrK/fvE2VtFgjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJf2Av7c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJf2Av7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510A11F000FF;
	Sat, 12 Sep 2026 09:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205194;
	bh=17HJZHFsUUI9SVh2k7nTfwb/naaXdsTt6x18hyGmtq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJf2Av7cWwfivduQcUNqUTqVFSGtFKP5E1Q67wXG8JbtzV2L82nFBSbh3ebrX/h3T
	 yChKukGUl5aEQjxAnSL7LHOY8vcCl3wBYTzDhjXTbp8iYlsYV5GvtQ7Z2rTm3abTgR
	 y8YoKjKzyKbAK2mHtVF5YR2vJtZcjksEF3qQlvdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1767/1815] crypto: acomp - allocate async request context when cloning
Date: Sat, 12 Sep 2026 08:58:37 +0200
Message-ID: <20260912065730.483900019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 032de704eb2ca..4de1a2ad577f2 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -559,12 +559,22 @@ EXPORT_SYMBOL_GPL(acomp_walk_virt);
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



