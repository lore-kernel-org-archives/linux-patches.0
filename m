Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C6052E054;
	Wed,  9 Sep 2026 14:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964590; cv=none; b=Zevpize6MhF02F8q/Lx6kCiVz6nb9iia9DK/pEsvH36B+jjnORIHEMB4IF1GwMMg7ekdsBJ0yP9IqvtPn2PHDFp+LKVb/U1Xj3LL5RqlbPdSW65CDgNDJRXPjWl9YjmWomIyUlwSIB1Djq7k3dE5KJXPOCitshUS8/Obmqn9uEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964590; c=relaxed/simple;
	bh=brD54eqxevXMw64BqUa8Mct6U46dSHO/r9hLSWV9kL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBcG3u8c4KuhQK10P+X8nZC4K5dG+hBaH20MbsryiqeoNJDFRlrO9XbA0L666FK1DrwKIZTMHTPdgFHWPM+DuYkm87mTEEwwF3l7sBYhkSSpUBr1a89bNngYAjLOvxx9f65fzkjKRlqDv7L2EaDtyXaBHPFE0c/TkNVVFYEEbLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bb2Ovyk1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bb2Ovyk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7551F00A3A;
	Wed,  9 Sep 2026 14:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964588;
	bh=CbPjUYVHzNcy6ZG+gKqiFmHYu4+X0th4+DyGxfOiKAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bb2Ovyk1jYtZcBVScKz4251XZFCBc2HSS0f846uHLD6glJXRU+F43zqXXVe74FU4X
	 3t/9BMji1iQyNillK/xBD3krkrRBOhvxO857eYm29HdOY4jqiYRb6WhE0M+JHvRMjU
	 y49yMMXxJQwyViyGmFlG6cVkDM4zE6OkhLtRYdeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 438/583] crypto: iaa - unmap dst before software fallback on decompress
Date: Wed,  9 Sep 2026 15:42:03 +0200
Message-ID: <20260909134253.164194548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
[ adapted unavailable iaa_unmap_src() calls to single-entry dma_unmap_sg() calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1063,13 +1063,17 @@ static void iaa_desc_complete(struct idx
 			pr_warn("%s: falling back to deflate-generic decompress, "
 				"analytics error code %x\n", __func__,
 				idxd_desc->iax_completion->error_code);
+			dma_unmap_sg(dev, ctx->req->dst, sg_nents(ctx->req->dst),
+				     DMA_FROM_DEVICE);
+			dma_unmap_sg(dev, ctx->req->src, 1, DMA_TO_DEVICE);
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
@@ -1452,19 +1456,9 @@ static int iaa_decompress(struct crypto_
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
+		if (idxd_desc->iax_completion->status == IAA_ANALYTICS_ERROR)
+			ret = -EAGAIN;
+		goto err;
 	} else {
 		req->dlen = idxd_desc->iax_completion->output_size;
 	}
@@ -1652,13 +1646,16 @@ static int iaa_comp_adecompress(struct a
 	if (ret == -EINPROGRESS)
 		return ret;
 
-	if (ret != 0)
+	if (ret != 0 && ret != -EAGAIN)
 		dev_dbg(dev, "asynchronous decompress failed ret=%d\n", ret);
 
 	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
 	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
 	iaa_wq_put(wq);
 
+	if (ret == -EAGAIN)
+		ret = deflate_generic_decompress(req);
+
 	return ret;
 }
 


