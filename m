Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE84848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E16C433EF;
	Fri, 10 Mar 2023 14:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458551;
	bh=vbWed7N8SLciAMWPNCptG+dDcf8uyVJTDJAS9NVJfOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zt5/fMY7JCpiqTPTJO0cLvhCLryKXTWtsienMVAIRD8B3eG8HCI3IthJk6+Kjuy7w
	 lLVHVksFLjS9q+6dsp51JpGmws+SpJ2w454HQdYV1546VD4Vioq2d15gpQXSSv6Far
	 +G4ONveMd4d/bx28+HMvp3i3WOBTctqYLkFjJgZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/357] crypto: essiv - Handle EBUSY correctly
Date: Fri, 10 Mar 2023 14:35:54 +0100
Message-Id: <20230310133736.852135232@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index 3d3f9d7f607ca..aa6b89e91ac80 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -188,7 +188,12 @@ static void essiv_aead_done(struct crypto_async_request *areq, int err)
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
 
@@ -264,7 +269,7 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
 	err = enc ? crypto_aead_encrypt(subreq) :
 		    crypto_aead_decrypt(subreq);
 
-	if (rctx->assoc && err != -EINPROGRESS)
+	if (rctx->assoc && err != -EINPROGRESS && err != -EBUSY)
 		kfree(rctx->assoc);
 	return err;
 }
-- 
2.39.2



