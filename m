Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E57125A642;
	Wed, 25 Feb 2026 01:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983842; cv=none; b=SuKoLCz+lrQSGLlUVAEGxUG+RdLFuwtPn78gVD3W2SWht5Yc2ve/x8Bu6hRNwnJ1EbjrCgNHTziTYsCDnpcfdwLSVt605JLAZr+/IwKK104iGqPm9uELrohPrtJvxurWV4snEOyCS4WKMtm7mX4FPnGdOI0yFacYAHeVHk28SiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983842; c=relaxed/simple;
	bh=ZeiU29uCH0cAqTQ1EKaa1aW7/trRpcZXMObnADEr9Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLj94IWqfrVmjMx4ktjHBHzscKbMau7oGsxMdO/9MYMQAxpOylHAL7O+YpIraqUYyJy0q6M1wvPvr1qc+4mNHJ9P0kAzKZPkbq+CKqmztPmQ2FDgPYkAxNuS2Xw6B8vRZRSIdaEo3/qZiWYpfFqcum7ocsRn5l0+8/8F8P1J3mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSBSseXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSBSseXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2B2C116D0;
	Wed, 25 Feb 2026 01:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983842;
	bh=ZeiU29uCH0cAqTQ1EKaa1aW7/trRpcZXMObnADEr9Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSBSseXG0bxpNKkd03xcGC9JqQN6ZDp2PZpcSSLg+lQFdVUBSjVr8jNvnW8hKzsux
	 P8iKwn13ww6t5eyI6HUPlmg5cEAjMzX3IQN59yZQQST4eA08JFYH7PprC6ZdFhyg3y
	 BjvJIoSNLurGCJzebYFeINvIvoffAf01c9LSn1ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/641] crypto: starfive - Fix memory leak in starfive_aes_aead_do_one_req()
Date: Tue, 24 Feb 2026 17:17:26 -0800
Message-ID: <20260225012352.042872416@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



