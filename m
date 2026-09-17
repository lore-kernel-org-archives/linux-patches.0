Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC844ABBAC;
	Thu, 17 Sep 2026 16:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661081; cv=none; b=IZICByuWxtNtFCwNw/xCW2otRjJwl+bCLQeQBgQiJjyLJWMozNVl8jwiQhp6it8W5z5L897NyFn96IGYIPLIiu7TlJ8oQT86AUNc8bdteLKwA5i4VHn0cBH2wdlpu1B0jazUHJJcJmwbKeLjLtnugD2ClCTJ716Oi6hbRNsn8zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661081; c=relaxed/simple;
	bh=1TCBI2VAKrIkWPk7TZW3+fz7M+kgL1d2NUuJOBGJVMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjgZRyJpie17yocMO1ao43cqIDZ2C5EWo9DtVbtJUqpN2k4N1Tg6wcnS8N9Y3oNIKVIueFH8GKd4smVAZnxrycfZWODhjbsJ6DY8RK7YbK20zsRzsHfM6DC26U5zp6wfJnPxLqWpXnF/jpAg85ObXF25fWociMGnPmCBzCctz/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFiy8p79; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFiy8p79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DD41F00893;
	Thu, 17 Sep 2026 16:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661080;
	bh=mHGPpl5gIEawj+WxlzRmGiBIy1Ch85Bx2bWc7zSxIiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BFiy8p79S0hdYg0CN7nzDKwoMLCXwOJuMztaJ2AVdbERllKf+7SKh5VYxWo7xlGic
	 PGGRyaXhnBCkR/jaeRsyj0Q+PEly9lVo5ZiNgzch6u2kcCtbdBZTID4yuhbp5aEz3l
	 ZF/TyuoN5zfPdsj2OK4ujqO6hAcY4Pz25Kh7LcSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0074/1250] crypto: ixp4xx - fix buffer chain unwind on allocation failure
Date: Thu, 17 Sep 2026 15:57:49 +0100
Message-ID: <20260917151553.957207426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c | 25 ++++++++++++---------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
index fcc0cf4df637d..5b90cf0fb0e41 100644
--- a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
+++ b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
@@ -884,8 +884,9 @@ static struct buffer_desc *chainup_buffers(struct device *dev,
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
@@ -983,7 +984,7 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 	unsigned int nbytes = req->cryptlen;
 	enum dma_data_direction src_direction = DMA_BIDIRECTIONAL;
 	struct ablk_ctx *req_ctx = skcipher_request_ctx(req);
-	struct buffer_desc src_hook;
+	struct buffer_desc *buf, src_hook;
 	struct device *dev = &pdev->dev;
 	unsigned int offset;
 	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
@@ -1025,22 +1026,24 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
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



