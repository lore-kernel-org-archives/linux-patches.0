Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6554E9AE6;
	Mon, 31 Aug 2026 13:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183620; cv=none; b=lUrXb0G8kat5QvEoL0UGtBlQgVjDpbcnmn9ftWX/yMhs0dHATwIoaoOms+NtNi7ann4shc2Gq8zcB4cxR3dYhC5bUi1oVrPWx/yJJlK2d2sOTbvzRqp6iyfW76uPJrvkccTjhyyBxYDRKOikglywGIWzdNKfTvZdF5S8lGMso2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183620; c=relaxed/simple;
	bh=4q0ju1VWAl8GQNq2P1RnE/AbKvFxaJRaJ7NN9Ztg8YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWMgJjazqAhGLv2e0dW+9Epvo9c6hxEiFsf+MWgi3+exsdPPDm36gdH4Gq+d2FFXnZlEHlvRLJFAtDlWpHBmot8ponv20z+6Rvi0AD/MY5iizLLp+oZb4ddSwDubwenOUZ9e7o4fg95t6a0J2FZ25q2f9WjvT0sDZpymdXBeoEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDpG8MVD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDpG8MVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ACF1F00A3E;
	Mon, 31 Aug 2026 13:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183618;
	bh=tpOanzleqkadCrSU7SoDarf+DUMypXbnwdWII/cKcGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDpG8MVDZ1Ff1Af7PUCRB/+D/IUn8znpUNsXOumrZt6BzWDVEbuGtbXJbmnm/enBx
	 PZ7517Mi6rxti8+lfi5LIMxW2o7ulizkaeNy1ruPlI1Hya9ZvEaWuUgechyuyvBW1G
	 6TKmhmd+s9RLOpkcbQUravKyY+zIDWW0VQvAMeVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.2 58/71] crypto: iaa - fall back to software for multi-entry scatterlists
Date: Mon, 31 Aug 2026 15:34:23 +0200
Message-ID: <20260831133402.236346242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

commit c7fdfd2bee1cf1448e5244da1a734e680f634b02 upstream.

IAA cannot process source or destination scatterlists with more than one
entry directly. Instead of failing these requests, route them through a
separate deflate acomp transform and keep the request alive in software.

The IAA driver has never handled multi-entry scatterlists, but the
limitation was latent until commit e2c3b6b21c77 ("mm: zswap: use SG list
decompression APIs from zsmalloc") made zswap pass the raw zsmalloc SG
list directly to crypto drivers, so objects spanning multiple pages now
reach IAA as multi-entry sources and would otherwise fail decompression.

Fallback to the generic DEFLATE implementation for scatterlists with
more than one entry. After the multi-entry cases fall back early,
simplify the DMA mapping path to a single scatterlist entry and fall
back on mapping failure as well.

Add counters to track the number of requests processed by the software
implementation on the compression direction.

Fixes: 2ec6761df889 ("crypto: iaa - Add support for deflate-iaa compression algorithm")
Fixes: e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from zsmalloc")
Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c  |  111 +++++++++++++++-------------
 drivers/crypto/intel/iaa/iaa_crypto_stats.c |    9 ++
 drivers/crypto/intel/iaa/iaa_crypto_stats.h |    2 
 3 files changed, 71 insertions(+), 51 deletions(-)

--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2021 Intel Corporation. All rights rsvd. */
 
 #include <linux/init.h>
+#include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -996,6 +997,19 @@ static int deflate_generic_decompress(st
 	return ret;
 }
 
+static int deflate_generic_compress(struct acomp_req *req)
+{
+	ACOMP_FBREQ_ON_STACK(fbreq, req);
+	int ret;
+
+	ret = crypto_acomp_compress(fbreq);
+	req->dlen = fbreq->dlen;
+
+	update_total_sw_comp_calls();
+
+	return ret;
+}
+
 static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 				struct acomp_req *req,
 				dma_addr_t *src_addr, dma_addr_t *dst_addr);
@@ -1472,7 +1486,7 @@ static int iaa_comp_acompress(struct aco
 	struct iaa_compression_ctx *compression_ctx;
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
-	int nr_sgs, cpu, ret = 0;
+	int cpu, ret = 0;
 	struct iaa_wq *iaa_wq;
 	struct idxd_wq *wq;
 	struct device *dev;
@@ -1484,11 +1498,15 @@ static int iaa_comp_acompress(struct aco
 		return -ENODEV;
 	}
 
-	if (!req->src || !req->slen) {
-		pr_debug("invalid src, not compressing\n");
+	if (!req->src || !req->slen || !req->dst) {
+		pr_debug("invalid req, not compressing\n");
 		return -EINVAL;
 	}
 
+	/* Fall back to software if src or dst has multiple sg entries */
+	if (sg_nents(req->src) > 1 || sg_nents(req->dst) > 1)
+		return deflate_generic_compress(req);
+
 	cpu = get_cpu();
 	wq = wq_table_next_wq(cpu);
 	put_cpu();
@@ -1507,30 +1525,25 @@ static int iaa_comp_acompress(struct aco
 
 	dev = &wq->idxd->pdev->dev;
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
-		dev_dbg(dev, "couldn't map src sg for iaa device %d,"
-			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
-			iaa_wq->wq->id, ret);
-		ret = -EIO;
-		goto out;
+	if (!dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE)) {
+		dev_dbg(dev, "couldn't map src sg for iaa device %d, wq %d\n",
+			iaa_wq->iaa_device->idxd->id, iaa_wq->wq->id);
+		iaa_wq_put(wq);
+		return deflate_generic_compress(req);
 	}
 	src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
-		" req->slen %d, sg_dma_len(sg) %d\n", src_addr, nr_sgs,
+	dev_dbg(dev, "map src %llx req->src %p slen %d sg_len %d\n", src_addr,
 		req->src, req->slen, sg_dma_len(req->src));
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
-		dev_dbg(dev, "couldn't map dst sg for iaa device %d,"
-			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
-			iaa_wq->wq->id, ret);
-		ret = -EIO;
-		goto err_map_dst;
+	if (!dma_map_sg(dev, req->dst, 1, DMA_FROM_DEVICE)) {
+		dev_dbg(dev, "couldn't map dst sg for iaa device %d, wq %d\n",
+			iaa_wq->iaa_device->idxd->id, iaa_wq->wq->id);
+		dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
+		iaa_wq_put(wq);
+		return deflate_generic_compress(req);
 	}
 	dst_addr = sg_dma_address(req->dst);
-	dev_dbg(dev, "dma_map_sg, dst_addr %llx, nr_sgs %d, req->dst %p,"
-		" req->dlen %d, sg_dma_len(sg) %d\n", dst_addr, nr_sgs,
+	dev_dbg(dev, "map dst %llx req->dst %p dlen %d sg_len %d\n", dst_addr,
 		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_compress(tfm, req, wq, src_addr, req->slen, dst_addr,
@@ -1550,8 +1563,8 @@ static int iaa_comp_acompress(struct aco
 		if (ret)
 			dev_dbg(dev, "asynchronous compress verification failed ret=%d\n", ret);
 
-		dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_TO_DEVICE);
-		dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
+		dma_unmap_sg(dev, req->dst, 1, DMA_TO_DEVICE);
+		dma_unmap_sg(dev, req->src, 1, DMA_FROM_DEVICE);
 
 		goto out;
 	}
@@ -1559,9 +1572,8 @@ static int iaa_comp_acompress(struct aco
 	if (ret)
 		dev_dbg(dev, "asynchronous compress failed ret=%d\n", ret);
 
-	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-err_map_dst:
-	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
+	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
 out:
 	iaa_wq_put(wq);
 
@@ -1572,7 +1584,7 @@ static int iaa_comp_adecompress(struct a
 {
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
-	int nr_sgs, cpu, ret = 0;
+	int cpu, ret = 0;
 	struct iaa_wq *iaa_wq;
 	struct device *dev;
 	struct idxd_wq *wq;
@@ -1582,11 +1594,15 @@ static int iaa_comp_adecompress(struct a
 		return -ENODEV;
 	}
 
-	if (!req->src || !req->slen) {
-		pr_debug("invalid src, not decompressing\n");
+	if (!req->src || !req->slen || !req->dst) {
+		pr_debug("invalid req, not decompressing\n");
 		return -EINVAL;
 	}
 
+	/* Fall back to software if src or dst has multiple sg entries */
+	if (sg_nents(req->src) > 1 || sg_nents(req->dst) > 1)
+		return deflate_generic_decompress(req);
+
 	cpu = get_cpu();
 	wq = wq_table_next_wq(cpu);
 	put_cpu();
@@ -1605,30 +1621,25 @@ static int iaa_comp_adecompress(struct a
 
 	dev = &wq->idxd->pdev->dev;
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
-		dev_dbg(dev, "couldn't map src sg for iaa device %d,"
-			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
-			iaa_wq->wq->id, ret);
-		ret = -EIO;
-		goto out;
+	if (!dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE)) {
+		dev_dbg(dev, "couldn't map src sg for iaa device %d, wq %d\n",
+			iaa_wq->iaa_device->idxd->id, iaa_wq->wq->id);
+		iaa_wq_put(wq);
+		return deflate_generic_decompress(req);
 	}
 	src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
-		" req->slen %d, sg_dma_len(sg) %d\n", src_addr, nr_sgs,
+	dev_dbg(dev, "map src %llx req->src %p slen %d sg_len %d\n", src_addr,
 		req->src, req->slen, sg_dma_len(req->src));
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
-		dev_dbg(dev, "couldn't map dst sg for iaa device %d,"
-			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
-			iaa_wq->wq->id, ret);
-		ret = -EIO;
-		goto err_map_dst;
+	if (!dma_map_sg(dev, req->dst, 1, DMA_FROM_DEVICE)) {
+		dev_dbg(dev, "couldn't map dst sg for iaa device %d, wq %d\n",
+			iaa_wq->iaa_device->idxd->id, iaa_wq->wq->id);
+		dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
+		iaa_wq_put(wq);
+		return deflate_generic_decompress(req);
 	}
 	dst_addr = sg_dma_address(req->dst);
-	dev_dbg(dev, "dma_map_sg, dst_addr %llx, nr_sgs %d, req->dst %p,"
-		" req->dlen %d, sg_dma_len(sg) %d\n", dst_addr, nr_sgs,
+	dev_dbg(dev, "map dst %llx req->dst %p dlen %d sg_len %d\n", dst_addr,
 		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_decompress(tfm, req, wq, src_addr, req->slen,
@@ -1639,10 +1650,8 @@ static int iaa_comp_adecompress(struct a
 	if (ret != 0)
 		dev_dbg(dev, "asynchronous decompress failed ret=%d\n", ret);
 
-	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-err_map_dst:
-	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-out:
+	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
 	iaa_wq_put(wq);
 
 	return ret;
--- a/drivers/crypto/intel/iaa/iaa_crypto_stats.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_stats.c
@@ -19,6 +19,7 @@
 
 static atomic64_t total_comp_calls;
 static atomic64_t total_decomp_calls;
+static atomic64_t total_sw_comp_calls;
 static atomic64_t total_sw_decomp_calls;
 static atomic64_t total_comp_bytes_out;
 static atomic64_t total_decomp_bytes_in;
@@ -43,6 +44,11 @@ void update_total_decomp_calls(void)
 	atomic64_inc(&total_decomp_calls);
 }
 
+void update_total_sw_comp_calls(void)
+{
+	atomic64_inc(&total_sw_comp_calls);
+}
+
 void update_total_sw_decomp_calls(void)
 {
 	atomic64_inc(&total_sw_decomp_calls);
@@ -104,6 +110,7 @@ static void reset_iaa_crypto_stats(void)
 {
 	atomic64_set(&total_comp_calls, 0);
 	atomic64_set(&total_decomp_calls, 0);
+	atomic64_set(&total_sw_comp_calls, 0);
 	atomic64_set(&total_sw_decomp_calls, 0);
 	atomic64_set(&total_comp_bytes_out, 0);
 	atomic64_set(&total_decomp_bytes_in, 0);
@@ -174,6 +181,8 @@ static int global_stats_show(struct seq_
 		   atomic64_read(&total_comp_calls));
 	seq_printf(m, "  total_decomp_calls: %llu\n",
 		   atomic64_read(&total_decomp_calls));
+	seq_printf(m, "  total_sw_comp_calls: %llu\n",
+		   atomic64_read(&total_sw_comp_calls));
 	seq_printf(m, "  total_sw_decomp_calls: %llu\n",
 		   atomic64_read(&total_sw_decomp_calls));
 	seq_printf(m, "  total_comp_bytes_out: %llu\n",
--- a/drivers/crypto/intel/iaa/iaa_crypto_stats.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto_stats.h
@@ -11,6 +11,7 @@ void	iaa_crypto_debugfs_cleanup(void);
 void	update_total_comp_calls(void);
 void	update_total_comp_bytes_out(int n);
 void	update_total_decomp_calls(void);
+void	update_total_sw_comp_calls(void);
 void	update_total_sw_decomp_calls(void);
 void	update_total_decomp_bytes_in(int n);
 void	update_completion_einval_errs(void);
@@ -29,6 +30,7 @@ static inline void	iaa_crypto_debugfs_cl
 static inline void	update_total_comp_calls(void) {}
 static inline void	update_total_comp_bytes_out(int n) {}
 static inline void	update_total_decomp_calls(void) {}
+static inline void	update_total_sw_comp_calls(void) {}
 static inline void	update_total_sw_decomp_calls(void) {}
 static inline void	update_total_decomp_bytes_in(int n) {}
 static inline void	update_completion_einval_errs(void) {}


