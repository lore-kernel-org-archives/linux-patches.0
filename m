Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E50BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB900C433D2;
	Tue,  7 Mar 2023 17:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209558;
	bh=YuYhB/dKHorjUyZL4Inu0z7kFjwTLil0DAr9I6YhTa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLDaVpLj+/9XS19rUn3PEP0TyOLXHz4b+G8g3gCBJ/fN4qXFxi74wbreFP8O19/3I
	 WpODy9PXVOcAXpGVGsJPZXEoAJsH85UVEp+BjO9UXyDNWjWhu/uB+PArN8Mcr81IaJ
	 l0a60d3eOLtiCGqzYNeMOyFBSceXRQxx/hu52oDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0226/1001] crypto: xts - Handle EBUSY correctly
Date: Tue,  7 Mar 2023 17:49:58 +0100
Message-Id: <20230307170031.688873742@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 51c082514c2dedf2711c99d93c196cc4eedceb40 ]

As it is xts only handles the special return value of EINPROGRESS,
which means that in all other cases it will free data related to the
request.

However, as the caller of xts may specify MAY_BACKLOG, we also need
to expect EBUSY and treat it in the same way.  Otherwise backlogged
requests will trigger a use-after-free.

Fixes: 8083b1bf8163 ("crypto: xts - add support for ciphertext stealing")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/xts.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 63c85b9e64e08..de6cbcf69bbd6 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -203,12 +203,12 @@ static void xts_encrypt_done(struct crypto_async_request *areq, int err)
 	if (!err) {
 		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 
-		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+		rctx->subreq.base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
 		err = xts_xor_tweak_post(req, true);
 
 		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
 			err = xts_cts_final(req, crypto_skcipher_encrypt);
-			if (err == -EINPROGRESS)
+			if (err == -EINPROGRESS || err == -EBUSY)
 				return;
 		}
 	}
@@ -223,12 +223,12 @@ static void xts_decrypt_done(struct crypto_async_request *areq, int err)
 	if (!err) {
 		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 
-		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+		rctx->subreq.base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
 		err = xts_xor_tweak_post(req, false);
 
 		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
 			err = xts_cts_final(req, crypto_skcipher_decrypt);
-			if (err == -EINPROGRESS)
+			if (err == -EINPROGRESS || err == -EBUSY)
 				return;
 		}
 	}
-- 
2.39.2



