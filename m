Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE94C34252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301695; cv=none; b=V85YRnwjeGqw1oXL1T9SDll1oh2e6T8Mnltflk2r8FRlVgKUsQyNJq0Pj0p3J6CDbD0zPtSRmr2H+rJQi76GvjEWSoowDO5AEk2vceDc/tg/rYpU7J41X3PZH/0BglcwKxY7+M3ZF6dtMdZN5rNN7WqaA2BQaVWFTB1FW3dq80k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301695; c=relaxed/simple;
	bh=7ZqA44pwoDDDq8yaqbf2WQtRq40cPl6ZcM24X/l7EeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftweK94MS3PoQs+diIsvIK0Mo2m4gYAU1SI+UOjsR6neyI0LTIn23BBJ2FYzqjtwbQUKr3wBaAxhSdpsoGrR0Xe34wVEImr5vf8sGHDH1oVbLqyRPpat4jRr+v8/fi7jgrEiVfBF1wQCNGTd8+jBfiAak1ZC8JttF3yhiKXxe6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J2xNnTN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J2xNnTN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3495FC19423;
	Sat, 28 Feb 2026 18:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301695;
	bh=7ZqA44pwoDDDq8yaqbf2WQtRq40cPl6ZcM24X/l7EeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2xNnTN/aedbjnPhnBFNgPOgc2gO37rMNJlOHrJI6PiflG8xtKRFbsp6PO+j2wiuJ
	 /IdQ0QEXE6gSwK2nGsAN6XHdzegHbVZTtuNGwCtqoWi4KHQPqh7fKUxRbGxby2S1pZ
	 g4GY+48U/7H1oMhKryV/xxYrE9ijatFheBeusQoLB6QJVnTNbRnkfxjWGAtAMRtJn5
	 p7lHKU+ZioheL0OJfkYVFeDmvatd6S+xOdVR1ZJGNEWO943DgpweK/aNy2fro6Nx4e
	 RtYveC3JpJOyPywWD6y6XCnEOXL1fqiKdx93Si0O0sRm+LajoQ6HhoBbr6nKsrljtC
	 M5Odv2ILrqtFQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/385] crypto: starfive - Fix memory leak in starfive_aes_aead_do_one_req()
Date: Sat, 28 Feb 2026 12:55:09 -0500
Message-ID: <20260228180011.1568201-87-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 86a1a1fa9f8f9..04f2f97ce238a 100644
--- a/drivers/crypto/starfive/jh7110-aes.c
+++ b/drivers/crypto/starfive/jh7110-aes.c
@@ -673,8 +673,10 @@ static int starfive_aes_aead_do_one_req(struct crypto_engine *engine, void *areq
 					     "Failed to alloc memory for adata");
 
 		if (sg_copy_to_buffer(req->src, sg_nents_for_len(req->src, cryp->assoclen),
-				      rctx->adata, cryp->assoclen) != cryp->assoclen)
+				      rctx->adata, cryp->assoclen) != cryp->assoclen) {
+			kfree(rctx->adata);
 			return -EINVAL;
+		}
 	}
 
 	if (cryp->total_in)
@@ -685,8 +687,11 @@ static int starfive_aes_aead_do_one_req(struct crypto_engine *engine, void *areq
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

