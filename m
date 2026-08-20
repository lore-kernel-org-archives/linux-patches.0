Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E9332B110;
	Thu, 20 Aug 2026 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238320; cv=none; b=m7MC3erJO67nCOv3fSVHzj7UFKYHrgGVocUhv5dxvyli+vdL/yOZW9uRNJ5fYEx5R56mpOMqf6vmHOUXK750Y+NeuPD6XUjDEzJVslewS49bGOQCzKoDXjzgHJMfKqIiOcDFvg9/zicXjuTL/mqNbKfrF1cU9D0L8bG9HkOjgDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238320; c=relaxed/simple;
	bh=Nf8ApX0aJJ9Nd/o7qLfkDY1rrbVchosdEwp4Y6InR/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3nGLmeFlQgJth3QxgGoDQPQaBGExgN2l2rLmbTjnoYe+aE5pJ3ak98QZG6GDWqN+AIG5xP01/8SX4wxhhHrsBRbodBETeLGtIBj8hzK5yBptTM3HTz+x4J+5IsAYtZJ6AdbcUa64Z7XiqDWGSVWxCrgrZva5gB0+F1Igl3WaGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrTrHWyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrTrHWyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FF11F000E9;
	Thu, 20 Aug 2026 15:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238319;
	bh=JcmzfZ2UFj9VunRZ4wuaAHAHqRN+L7I7f4G730b7nwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrTrHWyb9gF1nnXL7jAuCgcx1MN6TsK1uneDl5yr22zNg5Or0ZYSVq6rXBZE8oEVF
	 sLyvXPCjXZVsUUiiddAGsZfWNYfyGMi28OL0IyYfVxUfx8YEqKEQ5VdotxdEdxrW+S
	 2n47DpUqrb61Y0s3cJYH8EN5gDzetQxCuH6H6bac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 057/228] crypto: starfive - use scatterlist length before DMA mapping
Date: Thu, 20 Aug 2026 16:53:19 +0200
Message-ID: <20260820145246.204716862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


