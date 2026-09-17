Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC0040A93E;
	Thu, 17 Sep 2026 18:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671463; cv=none; b=mSMVp/V1PjEVq5tW6JUV2xG8cIrzH/SWR+x9rdyIBvG1jG3dGwBbSZ0TBEynIAQcq/D9MCp8xtzQybivOWWBl+6kj6G6/iJriMZRinK2gQ5a3XfRgvKNmYiBev3k+7JdQ6t2tpRBvtraH4Z8BsxYJpB7Ws7E2+8992GnGyK1TFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671463; c=relaxed/simple;
	bh=tMB2Kqh+lld7E4cmXZDghEgCNZ9bo12+7s7BZWG4HwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVU7HV9iKUgN8BL/tlcDytj7PLo5uZ5626LSSoBtGEjPc/xAglmg20wTjp3t1sl7JrWon3eDPZkNelOzhhxzGt09pvDJXIgAhuy9cz7owE1HxdaMNcZLnLw8QF9gfC/DxfAl72M2mfRsJTcXbqW2ccnFJQYxEUCW8d6vhIBSDas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPcEFiCn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPcEFiCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EEC1F00893;
	Thu, 17 Sep 2026 18:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671462;
	bh=F6UdhMkm6M4yG7glBOQbosUOI8KrnsbmxGGiuhmJg0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPcEFiCn7+GgW7THgNGKGmMbVfPV+0jEaBR1W+3YDkpl/1PGjt1cEq7RKa4YjZWUd
	 D/ryocJZgU5DTiW3GofHLRQyWzRMMqEkfmB8Rq1whhmmbKhR5A7lxth7xk7b1jE3W+
	 8rBCYtZrx7Hs7nL8RIAKURNaiOC/QpK/bC7q7XX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0984/1102] crypto: iaa - unmap dst before software fallback on decompress
Date: Thu, 17 Sep 2026 16:15:27 +0100
Message-ID: <20260917151605.407696132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit 94a25930477113730372e0fa2985da4c5ac95c9a ]

On a hardware analytics error, decompress retries through the software
fallback, which writes req->dst with the CPU while it is still mapped
DMA_FROM_DEVICE. With SWIOTLB active the later dma_unmap_sg() copies the
stale bounce buffer over req->dst, corrupting the result.

Unmap before the fallback runs. The async path unmaps inline; the sync
path signals the retry with -EAGAIN so iaa_comp_adecompress() runs the
fallback after unmapping.

Fixes: 2ec6761df889 ("crypto: iaa - Add support for deflate-iaa compression algorithm")
Cc: stable@vger.kernel.org
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ replaced unavailable iaa_unmap_src() calls with direct source scatterlist unmapping ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c |   36 +++++++++++++++--------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -987,6 +987,11 @@ out:
 	return ret;
 }
 
+static bool iaa_error_should_retry(struct idxd_desc *idxd_desc)
+{
+	return idxd_desc->iax_completion->status == IAA_ANALYTICS_ERROR;
+}
+
 static int deflate_generic_decompress(struct acomp_req *req)
 {
 	void *src, *dst;
@@ -1050,18 +1055,22 @@ static void iaa_desc_complete(struct idx
 			       ctx->compress, false);
 	if (ret) {
 		dev_dbg(dev, "%s: check_completion failed ret=%d\n", __func__, ret);
-		if (!ctx->compress &&
-		    idxd_desc->iax_completion->status == IAA_ANALYTICS_ERROR) {
+		if (!ctx->compress && iaa_error_should_retry(idxd_desc)) {
 			pr_warn("%s: falling back to deflate-generic decompress, "
 				"analytics error code %x\n", __func__,
 				idxd_desc->iax_completion->error_code);
+			dma_unmap_sg(dev, ctx->req->dst, sg_nents(ctx->req->dst),
+				     DMA_FROM_DEVICE);
+			dma_unmap_sg(dev, ctx->req->src, sg_nents(ctx->req->src),
+				     DMA_TO_DEVICE);
+
 			ret = deflate_generic_decompress(ctx->req);
 			if (ret) {
 				dev_dbg(dev, "%s: deflate-generic failed ret=%d\n",
 					__func__, ret);
 				err = -EIO;
-				goto err;
 			}
+			goto out;
 		} else {
 			err = -EIO;
 			goto err;
@@ -1446,19 +1455,9 @@ static int iaa_decompress(struct crypto_
 	ret = check_completion(dev, idxd_desc->iax_completion, false, false);
 	if (ret) {
 		dev_dbg(dev, "%s: check_completion failed ret=%d\n", __func__, ret);
-		if (idxd_desc->iax_completion->status == IAA_ANALYTICS_ERROR) {
-			pr_warn("%s: falling back to deflate-generic decompress, "
-				"analytics error code %x\n", __func__,
-				idxd_desc->iax_completion->error_code);
-			ret = deflate_generic_decompress(req);
-			if (ret) {
-				dev_dbg(dev, "%s: deflate-generic failed ret=%d\n",
-					__func__, ret);
-				goto err;
-			}
-		} else {
-			goto err;
-		}
+		if (iaa_error_should_retry(idxd_desc))
+			ret = -EAGAIN;
+		goto err;
 	} else {
 		req->dlen = idxd_desc->iax_completion->output_size;
 	}
@@ -1650,7 +1649,7 @@ static int iaa_comp_adecompress(struct a
 	if (ret == -EINPROGRESS)
 		return ret;
 
-	if (ret != 0)
+	if (ret != 0 && ret != -EAGAIN)
 		dev_dbg(dev, "asynchronous decompress failed ret=%d\n", ret);
 
 	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
@@ -1659,6 +1658,9 @@ err_map_dst:
 out:
 	iaa_wq_put(wq);
 
+	if (ret == -EAGAIN)
+		ret = deflate_generic_decompress(req);
+
 	return ret;
 }
 


