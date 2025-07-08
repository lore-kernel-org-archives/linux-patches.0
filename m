Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB8A2E540C;
	Tue,  8 Jul 2025 16:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992831; cv=none; b=fBiXGtJeUeAE5Urf3zsamhgmNynA/rxo1Pi6hkEiglLSMfqHgz4sjPD3cKo0afOevuN0NvgX0HFzk6I63ewtCTWOHcY1afVrVixUEwh4C15L1SB7CS2bHSJhAK5+dgrLmSA/mtGQaJri1YhMsxrqtNPP1DudULDWnXYHDu1uKvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992831; c=relaxed/simple;
	bh=ZB6G23KGTDbiwlwDJTWlW08ZzYgg++FXHeJVXEeTw44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPFs22lVleitNPi+dePFfpH/LPnAtPldgm8mZz4V/SFZzTqRdLwkKBXoOpiFFw78RFAVMk5ZQTmKW31pCXC0ya+JxeZ284bNOvpJxsXK5AjdvPVlUllzvBk0OfYeanMx0/KDKKoAY8xpXi7r78q18fCNvLvMdYS/ISL1pAgaeMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImrHY9HE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImrHY9HE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7EDC4CEED;
	Tue,  8 Jul 2025 16:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992831;
	bh=ZB6G23KGTDbiwlwDJTWlW08ZzYgg++FXHeJVXEeTw44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImrHY9HEk/waMuEKaCWggMiyqgT08HUBKiZpClL7UyZhNd9nMsBkMeudj9jpFMIAl
	 mTeL7SHUrAPWgEUDdGWpcd7s2Kt3t5xBZXZeYnITKmwq4WNgU9GdsMZXH/LJvF1fbu
	 8Lo0h0s+osqNr+n46JYsSKOtbNs514zH+S1VUrZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/232] crypto: iaa - Remove dst_null support
Date: Tue,  8 Jul 2025 18:21:30 +0200
Message-ID: <20250708162243.908772419@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 02c974294c740bfb747ec64933e12148eb3d99e1 ]

Remove the unused dst_null support.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: cc98d8ce934b ("crypto: iaa - Do not clobber req->base.data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 136 +--------------------
 1 file changed, 6 insertions(+), 130 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index e1f60f0f507c9..711c6e8914978 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1126,8 +1126,7 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 			struct idxd_wq *wq,
 			dma_addr_t src_addr, unsigned int slen,
 			dma_addr_t dst_addr, unsigned int *dlen,
-			u32 *compression_crc,
-			bool disable_async)
+			u32 *compression_crc)
 {
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -1170,7 +1169,7 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 	desc->src2_size = sizeof(struct aecs_comp_table_record);
 	desc->completion_addr = idxd_desc->compl_dma;
 
-	if (ctx->use_irq && !disable_async) {
+	if (ctx->use_irq) {
 		desc->flags |= IDXD_OP_FLAG_RCI;
 
 		idxd_desc->crypto.req = req;
@@ -1183,7 +1182,7 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 			" src_addr %llx, dst_addr %llx\n", __func__,
 			active_compression_mode->name,
 			src_addr, dst_addr);
-	} else if (ctx->async_mode && !disable_async)
+	} else if (ctx->async_mode)
 		req->base.data = idxd_desc;
 
 	dev_dbg(dev, "%s: compression mode %s,"
@@ -1204,7 +1203,7 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 	update_total_comp_calls();
 	update_wq_comp_calls(wq);
 
-	if (ctx->async_mode && !disable_async) {
+	if (ctx->async_mode) {
 		ret = -EINPROGRESS;
 		dev_dbg(dev, "%s: returning -EINPROGRESS\n", __func__);
 		goto out;
@@ -1224,7 +1223,7 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
 	*compression_crc = idxd_desc->iax_completion->crc;
 
-	if (!ctx->async_mode || disable_async)
+	if (!ctx->async_mode)
 		idxd_free_desc(wq, idxd_desc);
 out:
 	return ret;
@@ -1490,13 +1489,11 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	struct iaa_compression_ctx *compression_ctx;
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
-	bool disable_async = false;
 	int nr_sgs, cpu, ret = 0;
 	struct iaa_wq *iaa_wq;
 	u32 compression_crc;
 	struct idxd_wq *wq;
 	struct device *dev;
-	int order = -1;
 
 	compression_ctx = crypto_tfm_ctx(tfm);
 
@@ -1526,21 +1523,6 @@ static int iaa_comp_acompress(struct acomp_req *req)
 
 	iaa_wq = idxd_wq_get_private(wq);
 
-	if (!req->dst) {
-		gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
-
-		/* incompressible data will always be < 2 * slen */
-		req->dlen = 2 * req->slen;
-		order = order_base_2(round_up(req->dlen, PAGE_SIZE) / PAGE_SIZE);
-		req->dst = sgl_alloc_order(req->dlen, order, false, flags, NULL);
-		if (!req->dst) {
-			ret = -ENOMEM;
-			order = -1;
-			goto out;
-		}
-		disable_async = true;
-	}
-
 	dev = &wq->idxd->pdev->dev;
 
 	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
@@ -1570,7 +1552,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_compress(tfm, req, wq, src_addr, req->slen, dst_addr,
-			   &req->dlen, &compression_crc, disable_async);
+			   &req->dlen, &compression_crc);
 	if (ret == -EINPROGRESS)
 		return ret;
 
@@ -1601,100 +1583,6 @@ static int iaa_comp_acompress(struct acomp_req *req)
 out:
 	iaa_wq_put(wq);
 
-	if (order >= 0)
-		sgl_free_order(req->dst, order);
-
-	return ret;
-}
-
-static int iaa_comp_adecompress_alloc_dest(struct acomp_req *req)
-{
-	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
-		GFP_KERNEL : GFP_ATOMIC;
-	struct crypto_tfm *tfm = req->base.tfm;
-	dma_addr_t src_addr, dst_addr;
-	int nr_sgs, cpu, ret = 0;
-	struct iaa_wq *iaa_wq;
-	struct device *dev;
-	struct idxd_wq *wq;
-	int order = -1;
-
-	cpu = get_cpu();
-	wq = wq_table_next_wq(cpu);
-	put_cpu();
-	if (!wq) {
-		pr_debug("no wq configured for cpu=%d\n", cpu);
-		return -ENODEV;
-	}
-
-	ret = iaa_wq_get(wq);
-	if (ret) {
-		pr_debug("no wq available for cpu=%d\n", cpu);
-		return -ENODEV;
-	}
-
-	iaa_wq = idxd_wq_get_private(wq);
-
-	dev = &wq->idxd->pdev->dev;
-
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
-		dev_dbg(dev, "couldn't map src sg for iaa device %d,"
-			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
-			iaa_wq->wq->id, ret);
-		ret = -EIO;
-		goto out;
-	}
-	src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
-		" req->slen %d, sg_dma_len(sg) %d\n", src_addr, nr_sgs,
-		req->src, req->slen, sg_dma_len(req->src));
-
-	req->dlen = 4 * req->slen; /* start with ~avg comp rato */
-alloc_dest:
-	order = order_base_2(round_up(req->dlen, PAGE_SIZE) / PAGE_SIZE);
-	req->dst = sgl_alloc_order(req->dlen, order, false, flags, NULL);
-	if (!req->dst) {
-		ret = -ENOMEM;
-		order = -1;
-		goto out;
-	}
-
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
-		dev_dbg(dev, "couldn't map dst sg for iaa device %d,"
-			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
-			iaa_wq->wq->id, ret);
-		ret = -EIO;
-		goto err_map_dst;
-	}
-
-	dst_addr = sg_dma_address(req->dst);
-	dev_dbg(dev, "dma_map_sg, dst_addr %llx, nr_sgs %d, req->dst %p,"
-		" req->dlen %d, sg_dma_len(sg) %d\n", dst_addr, nr_sgs,
-		req->dst, req->dlen, sg_dma_len(req->dst));
-	ret = iaa_decompress(tfm, req, wq, src_addr, req->slen,
-			     dst_addr, &req->dlen, true);
-	if (ret == -EOVERFLOW) {
-		dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-		req->dlen *= 2;
-		if (req->dlen > CRYPTO_ACOMP_DST_MAX)
-			goto err_map_dst;
-		goto alloc_dest;
-	}
-
-	if (ret != 0)
-		dev_dbg(dev, "asynchronous decompress failed ret=%d\n", ret);
-
-	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-err_map_dst:
-	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-out:
-	iaa_wq_put(wq);
-
-	if (order >= 0)
-		sgl_free_order(req->dst, order);
-
 	return ret;
 }
 
@@ -1717,9 +1605,6 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		return -EINVAL;
 	}
 
-	if (!req->dst)
-		return iaa_comp_adecompress_alloc_dest(req);
-
 	cpu = get_cpu();
 	wq = wq_table_next_wq(cpu);
 	put_cpu();
@@ -1800,19 +1685,10 @@ static int iaa_comp_init_fixed(struct crypto_acomp *acomp_tfm)
 	return 0;
 }
 
-static void dst_free(struct scatterlist *sgl)
-{
-	/*
-	 * Called for req->dst = NULL cases but we free elsewhere
-	 * using sgl_free_order().
-	 */
-}
-
 static struct acomp_alg iaa_acomp_fixed_deflate = {
 	.init			= iaa_comp_init_fixed,
 	.compress		= iaa_comp_acompress,
 	.decompress		= iaa_comp_adecompress,
-	.dst_free               = dst_free,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa",
-- 
2.39.5



