Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36843412294;
	Fri,  4 Sep 2026 05:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500232; cv=none; b=PHY3v4YnIDIJ6kmQelYO9ZCPpyc3cVIr4BZbGpnIKIv/Id2iKJ5Nxg618DoMVWsYsDj/wlbHkm/m47nNXiQmc2iyv8uxTNNRELREjO0TTkcSh2xeVV10V1i26GQy+05dYNxkAF+bZ1cPbI+G79qG17l9Xc/SXColFGdsqCvqBdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500232; c=relaxed/simple;
	bh=ApbTkDQ+QNb2vf4RsCGelVG8xkJcgMyxReHuJ7Uzmio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNmDrQXsvN2rxOCwTYqV/26WGWPvNH5aF/Xc4K81stKktunr3IynWsBOKSH2Famh2656TOLqgudnjTExVgonGbEMkZHNLBSphMg6qPJW6NFC3k+haUh/DFY7lJuCs6cdiaN+Op3D5LTPwCFTy5kX6ZNEh/IXhnVerdu+dc7Vgj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zq7mpap5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zq7mpap5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C0E1F00A3D;
	Fri,  4 Sep 2026 05:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500231;
	bh=Y3S2G0nzVIW1mqOoT/8+lBp6YK9KwWQ8BYRBk6K0IB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zq7mpap5p8ZNx7hxSAWqC7mZno/agl1WQiK9/Lcim1fwF1cO/lqIXpdnkU8QkB/0S
	 MnUBTkAOHEhy8NWbt9EqQZWR2mSFnt45q3MgeZCDFF1NP0MhOJMy/t6w4+PkPHVoB7
	 BYmK0NWY+fDgYSM1q8kvjMu+nkgBoF4Vy3aCSIug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 680/713] crypto: iaa - unmap dst before software fallback on decompress
Date: Fri,  4 Sep 2026 07:00:48 +0200
Message-ID: <20260904045819.081758939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -1058,13 +1058,17 @@ static void iaa_desc_complete(struct idx
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
@@ -1447,19 +1451,9 @@ static int iaa_decompress(struct crypto_
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
@@ -1647,13 +1641,16 @@ static int iaa_comp_adecompress(struct a
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
 


