Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E4350255E;
	Wed, 30 Sep 2026 16:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784083; cv=none; b=ZjuTdqgypHx6uVtlRNrUAdcy0eWJ/3tJregcncFo6aUDZCaLw2pJwYr/Lkwc7EDoncM56V3a/MH2BrtKczWBd6CdgYu0sA2zwlIdBw1c714/+8cXtenMZul1xEFLej8nIRKizunrKD967Sy6g9pJ0CKPrbqWTfjVYPRLB6+pVRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784083; c=relaxed/simple;
	bh=PZ9/wRUy4vhow0JhnbQWEbmC7L2dRjSP2twN8SdZ9R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omPufa3XijmzA7uzHpaYUp56tylOuYjceLdnw/yVSxMT8FhmAlsqlhJqka5vh9d/W1RbynAO7dyFXbTQdl9+OaUEh7cAEeuZ0+0XpqR02KEEVEbL6s1AzcMyaoIF/ze++fhNjbXtzbNHpXt3YQ8PwA3GwbOLBHx2zMnR7xuH2tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7imHML3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7imHML3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60681F00893;
	Wed, 30 Sep 2026 16:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784077;
	bh=GFZP6+gcjUnpFSGVr0r7zcnddvX4vQWpOgfSdjJ0S4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V7imHML3gUNuLYQDgPhFnx/XFrZ0mofuT3t6H81cNBAeoIHjfau8CAEQ54LI+YeSt
	 B14iJ217EGr1tfpSHs6BJXmrs/J+C4U2eOUxHtsGR0ViBvP/BE2dJnp8O2vVyorY/f
	 Ica4HQMgM/FjGYk+tKq2+HxaG0D3e685R+gDVzSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/982] crypto: ixp4xx - fix buffer chain unwind on allocation failure
Date: Wed, 30 Sep 2026 17:12:45 +0200
Message-ID: <20260930152417.422388988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 25056329384010a8672552b134f609601dc4f80e ]

chainup_buffers() builds a linked list of buffer descriptors for a
scatterlist. If dma_pool_alloc() fails while constructing the list, the
current code sets buf to NULL and later dereferences it unconditionally
at the end of the function:

  buf->next = NULL;
  buf->phys_next = 0;

This can lead to a null-pointer dereference on allocation failure.

If the failure happens after part of the descriptor chain has already
been allocated and DMA-mapped, the partially constructed chain also
needs to be released.

Fix this by terminating the partially constructed chain on allocation
failure and letting the callers unwind it via their existing cleanup
paths. Also fix ablk_perform() to preserve the hook pointers before
checking for failure, so partially built chains can be freed correctly.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Acked-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ixp4xx_crypto.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index cfb149302e0a9..c3e2a816476dc 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -882,8 +882,9 @@ static struct buffer_desc *chainup_buffers(struct device *dev,
 		ptr = sg_virt(sg);
 		next_buf = dma_pool_alloc(buffer_pool, flags, &next_buf_phys);
 		if (!next_buf) {
-			buf = NULL;
-			break;
+			buf->next = NULL;
+			buf->phys_next = 0;
+			return NULL;
 		}
 		sg_dma_address(sg) = dma_map_single(dev, ptr, len, dir);
 		buf->next = next_buf;
@@ -981,7 +982,7 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 	unsigned int nbytes = req->cryptlen;
 	enum dma_data_direction src_direction = DMA_BIDIRECTIONAL;
 	struct ablk_ctx *req_ctx = skcipher_request_ctx(req);
-	struct buffer_desc src_hook;
+	struct buffer_desc *buf, src_hook;
 	struct device *dev = &pdev->dev;
 	unsigned int offset;
 	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
@@ -1023,22 +1024,24 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 		/* This was never tested by Intel
 		 * for more than one dst buffer, I think. */
 		req_ctx->dst = NULL;
-		if (!chainup_buffers(dev, req->dst, nbytes, &dst_hook,
-				     flags, DMA_FROM_DEVICE))
-			goto free_buf_dest;
-		src_direction = DMA_TO_DEVICE;
+		buf = chainup_buffers(dev, req->dst, nbytes, &dst_hook,
+				      flags, DMA_FROM_DEVICE);
 		req_ctx->dst = dst_hook.next;
 		crypt->dst_buf = dst_hook.phys_next;
+		if (!buf)
+			goto free_buf_dest;
+		src_direction = DMA_TO_DEVICE;
 	} else {
 		req_ctx->dst = NULL;
 	}
 	req_ctx->src = NULL;
-	if (!chainup_buffers(dev, req->src, nbytes, &src_hook, flags,
-			     src_direction))
-		goto free_buf_src;
-
+	buf = chainup_buffers(dev, req->src, nbytes, &src_hook, flags,
+			      src_direction);
 	req_ctx->src = src_hook.next;
 	crypt->src_buf = src_hook.phys_next;
+	if (!buf)
+		goto free_buf_src;
+
 	crypt->ctl_flags |= CTL_FLAG_PERFORM_ABLK;
 	qmgr_put_entry(send_qid, crypt_virt2phys(crypt));
 	BUG_ON(qmgr_stat_overflow(send_qid));
-- 
2.53.0



