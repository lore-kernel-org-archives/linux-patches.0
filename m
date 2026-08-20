Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E2A36212F;
	Thu, 20 Aug 2026 15:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239444; cv=none; b=q8zHKO5Yi1B6374n6l0o45I0zhn9d4MYdILR2svzgdeuU46Ty0BqEPLBUGAsdbhJ0+aN2HMcJQX+01sNYhu8N8dy9Loh1+dI/nFEo9pcvX36uaPblQNY1fPvknVdGQfRaSdHXQqYQMA1/NxdcnvRVTDK4vsuX7MSIyK9W2KEfVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239444; c=relaxed/simple;
	bh=4vouMnb7lletJJyCm7iHhAhBpsbUqYGNR7NBlphrAb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sH6uI5Dsc0HmJKoZMvqqAqCMYgCGiqfCuxtxR+paYT4PY87Sd05WgHKl8eAQmBo8yCQq3kP4qkuCFDPVfjFCNMF4XTENm78z3GjfqKKaAMzBXBGv+ZtM76Idzd8G0ozxp9TaidKf9n97SnaRHgA6sFfgkeHBYekjfpTy8aUc9Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+8AyUIb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+8AyUIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735D01F000E9;
	Thu, 20 Aug 2026 15:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239442;
	bh=1REeTcBwN1zcwNaIyP51gsoBdliQim4UAVu6WYY5tX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1+8AyUIbRbkNnmi8lhaO31Yym5ps5LS/pJoekw0Bxp/fbRtHzvaM/2ir3w1wLNWLL
	 JMgCU/ZHCjLgMJd9BZ0N3q2dzWucC36GNi+It8KphkGnAIyh0ELXrCGI/kieGwSEKa
	 ukge5oiOozGFpJ/Kvrar14A7dFO6pmEITMawSJ6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 050/220] crypto: starfive - use scatterlist length before DMA mapping
Date: Thu, 20 Aug 2026 16:54:00 +0200
Message-ID: <20260820145224.999719684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -681,7 +681,7 @@ static int starfive_aes_aead_do_one_req(
 
 	if (cryp->total_in)
 		sg_zero_buffer(rctx->in_sg, sg_nents(rctx->in_sg),
-			       sg_dma_len(rctx->in_sg) - cryp->total_in,
+			       rctx->in_sg->length - cryp->total_in,
 			       cryp->total_in);
 
 	ctx->rctx = rctx;


