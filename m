Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00ABB37A498;
	Thu, 20 Aug 2026 15:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238806; cv=none; b=DrAB9Vw2KKdiBg8mus/fL+iCG4nz1hg/GInwUfGXT3PJUtNq9Vm8XG/zY4Wol7bzPikJZTWDeClD+tachrYBUKx1X9hHPmV1MWioIEfSts2Qoy6/i+4OPnaMYhhG0Doi1eXyKCsz9ok2qu+4GmUQxOCALKatHVW8QjIOsOoYE30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238806; c=relaxed/simple;
	bh=6HoThjAqw1RB1qbUP5ntUL6v0N+nKNs3aqfKS8tRgZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kubQgnZRlWC39u41Jjgg9QaW8pAEWN241mpCO90AE8+FJLCtzuEVig9EFKHGALp+CJ8evds/JSEz+NI85uYYzKQ/p2DztV4W2+qHzA2dyWdmS8Y9FZULPS4v7JLuMczImZ74FjdRL9u+Ffb02BFxdaLqpy97Eo3V8lX23/JP+dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOzV5jEJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOzV5jEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9861F000E9;
	Thu, 20 Aug 2026 15:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238804;
	bh=docsi1/lX9UqoE/9ghxsTSsYca6GPfISq+LpSo4MFmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SOzV5jEJ4z6bOi1pWHmi6AmsoE5rSSgF87HtqtvePbpRrKJHKlSiFnXNu6FuVxbWL
	 /sfa2SktrmJSuTOF9hDD7FcGEWcSHY7XqE+izDDN8GxczcxK9SUGPvOYsb0KCZt0Ke
	 KVm6S+G8ISXbvEcrxSJuMmXljO+a8Peua2xThQ14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 048/217] crypto: starfive - use scatterlist length before DMA mapping
Date: Thu, 20 Aug 2026 16:53:36 +0200
Message-ID: <20260820145239.070120980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 6b36f13891ab4709b7d60023005176cdd5c368cf upstream.

Using sg_dma_len() is only valid after mapping a scatterlist with
dma_map_sg(). However, starfive_aes_aead_do_one_req() uses it before
mapping the scatterlist.

Use the original scatterlist length because the DMA length has not been
populated yet when CONFIG_NEED_SG_DMA_LENGTH=y.

Fixes: 7467147ef9bf ("crypto: starfive - Use dma for aes requests")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/starfive/jh7110-aes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/starfive/jh7110-aes.c
+++ b/drivers/crypto/starfive/jh7110-aes.c
@@ -677,7 +677,7 @@ static int starfive_aes_aead_do_one_req(
 
 	if (cryp->total_in)
 		sg_zero_buffer(rctx->in_sg, sg_nents(rctx->in_sg),
-			       sg_dma_len(rctx->in_sg) - cryp->total_in,
+			       rctx->in_sg->length - cryp->total_in,
 			       cryp->total_in);
 
 	ctx->rctx = rctx;


