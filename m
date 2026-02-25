Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADABC1D5ABA;
	Wed, 25 Feb 2026 01:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982957; cv=none; b=KqGw2VO+gaqFHJcqbj4lui+7yituY4vOaqPnPUlC5N+xGGH+ESvh9uhagzxMbDr+nrQvSv6Jy6EZSqKv3nFUtjla7x0fNWmSUAVT4YhVgJHAD3HL5/KKq1G1bmEcaYxj1dIGRj3Dr3sbySF4gI1+yE9w7ohGfU6fh92/em6hfIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982957; c=relaxed/simple;
	bh=nc1LS9gPQt0ZjMLGBqIgVVhrBVuUtvDjmjs1lOyK5UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/M81OW2/+WkLXE7goxgjiQaumsRLdhtMSMUf05CaAFaOWcYWm9X3N/pkFG4hLfP025MaSMmzAnbr+Qnus5ONRhIjS+IyDhV2i7g9+r6ZzLSPRBSrdNhIe2XsMlX2Vk28+epSTpEzRDyGOLGz1yu1zNAoWkVfdTgldbYXT0GyKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjAJtkHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjAJtkHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642BFC116D0;
	Wed, 25 Feb 2026 01:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982957;
	bh=nc1LS9gPQt0ZjMLGBqIgVVhrBVuUtvDjmjs1lOyK5UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjAJtkHss6GCEiEJ6Kf78P2xmGhgQvFyr3FMcZSqrPvjDwk9Gqsn+Kldo/daZWwWx
	 mwgDz+mhDaLxUzjO5GB8D/hEVU7rnAVr0GkpC6P6WcY3K3sis1PzYwIyTapcOR5w6W
	 P4etSv9+zEtw+cXtWNSmqAVIQUwwC3Z/GVh+tDMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 134/781] crypto: starfive - Fix memory leak in starfive_aes_aead_do_one_req()
Date: Tue, 24 Feb 2026 17:14:03 -0800
Message-ID: <20260225012402.956396630@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit ccb679fdae2e62ed92fd9acb25ed809c0226fcc6 ]

The starfive_aes_aead_do_one_req() function allocates rctx->adata with
kzalloc() but fails to free it if sg_copy_to_buffer() or
starfive_aes_hw_init() fails, which lead to memory leaks.

Since rctx->adata is unconditionally freed after the write_adata
operations, ensure consistent cleanup by freeing the allocation in these
earlier error paths as well.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 7467147ef9bf ("crypto: starfive - Use dma for aes requests")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/starfive/jh7110-aes.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-aes.c b/drivers/crypto/starfive/jh7110-aes.c
index 426b24889af85..01195664cc7cd 100644
--- a/drivers/crypto/starfive/jh7110-aes.c
+++ b/drivers/crypto/starfive/jh7110-aes.c
@@ -669,8 +669,10 @@ static int starfive_aes_aead_do_one_req(struct crypto_engine *engine, void *areq
 			return -ENOMEM;
 
 		if (sg_copy_to_buffer(req->src, sg_nents_for_len(req->src, cryp->assoclen),
-				      rctx->adata, cryp->assoclen) != cryp->assoclen)
+				      rctx->adata, cryp->assoclen) != cryp->assoclen) {
+			kfree(rctx->adata);
 			return -EINVAL;
+		}
 	}
 
 	if (cryp->total_in)
@@ -681,8 +683,11 @@ static int starfive_aes_aead_do_one_req(struct crypto_engine *engine, void *areq
 	ctx->rctx = rctx;
 
 	ret = starfive_aes_hw_init(ctx);
-	if (ret)
+	if (ret) {
+		if (cryp->assoclen)
+			kfree(rctx->adata);
 		return ret;
+	}
 
 	if (!cryp->assoclen)
 		goto write_text;
-- 
2.51.0



