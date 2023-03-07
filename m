Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30526BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F32C433EF;
	Tue,  7 Mar 2023 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214975;
	bh=cBF1/Qk0+xh1TTVKI8F7IAXlNSjq9Ld5rWWXvJrULPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=meskJL0ryhPf8MuiIg3+dUKFlr9ebh8T4XlTHo+Z6iyZl8qVb18rXzbyRqyXi8/md
	 Lrraheevnmxm+eOqdIXYcSd1EFUuC9BTTY8qthVc3wQyNOy4ZBt0DEULsLUybkHjDL
	 n+oxHSncGk5tTjDOBKSgSna2JeWjiwSoEERwUNg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/567] crypto: essiv - Handle EBUSY correctly
Date: Tue,  7 Mar 2023 17:57:26 +0100
Message-Id: <20230307165910.676850494@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

[ Upstream commit b5a772adf45a32c68bef28e60621f12617161556 ]

As it is essiv only handles the special return value of EINPROGERSS,
which means that in all other cases it will free data related to the
request.

However, as the caller of essiv may specify MAY_BACKLOG, we also need
to expect EBUSY and treat it in the same way.  Otherwise backlogged
requests will trigger a use-after-free.

Fixes: be1eb7f78aa8 ("crypto: essiv - create wrapper template...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/essiv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/crypto/essiv.c b/crypto/essiv.c
index 8bcc5bdcb2a95..3505b071e6471 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -171,7 +171,12 @@ static void essiv_aead_done(struct crypto_async_request *areq, int err)
 	struct aead_request *req = areq->data;
 	struct essiv_aead_request_ctx *rctx = aead_request_ctx(req);
 
+	if (err == -EINPROGRESS)
+		goto out;
+
 	kfree(rctx->assoc);
+
+out:
 	aead_request_complete(req, err);
 }
 
@@ -247,7 +252,7 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
 	err = enc ? crypto_aead_encrypt(subreq) :
 		    crypto_aead_decrypt(subreq);
 
-	if (rctx->assoc && err != -EINPROGRESS)
+	if (rctx->assoc && err != -EINPROGRESS && err != -EBUSY)
 		kfree(rctx->assoc);
 	return err;
 }
-- 
2.39.2



