Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61BC2EF659;
	Tue, 17 Jun 2025 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174220; cv=none; b=h1qxgq52+K4PGWovRWifFtjaQgC8HJAilUZlah3mIJsBb7yalFNKUsb1Af3lowInXmE1xoid2+CltBqwGJMlhViipoxDWZWIsCf/n+GC/QhtAsrV1Q8se4sg6Jt3RHyZH25pJpYniVcRQ66pXo5uDOqZiKK9V1nID9s/XCizB0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174220; c=relaxed/simple;
	bh=6qab90dcYUTPnQxYGPCdZNtPE5Agc0XPBvs2YHI5OmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzA8YGMqXyWULFI4tUrI0u6eXUcmfc5wHDcu8pdzSdI8O70qQlDSfNY5xq/NaaRnB/cyiCWQRYd5eBo8bk7PAfgzJwtgQXTQ8dwcu9VC+vrSMsY5EBWt3LhmYkL/9vQAWXOrncrk6KthAlA+NHiU+TGROsA6CqWvUizvYLrACmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LM0vR2uO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LM0vR2uO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE22C4CEE3;
	Tue, 17 Jun 2025 15:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174220;
	bh=6qab90dcYUTPnQxYGPCdZNtPE5Agc0XPBvs2YHI5OmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LM0vR2uOZK6v5s1jUcwd3sjhsymCrBXqzTgPz0LHgM13RrrGK06nJXh0lker3FJD7
	 8vcdwMyqiC+q2GCjHFhhiRieo987gTVykUrU2JXskOV2QJ48oUdNZNHLpWE5tyfDbF
	 S4Y1D3gyHcdXlY6aajWd8pQ8bDp6aCPT5WaVYXc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/356] crypto: sun8i-ce-hash - fix error handling in sun8i_ce_hash_run()
Date: Tue, 17 Jun 2025 17:22:15 +0200
Message-ID: <20250617152339.049302144@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

[ Upstream commit ea4dd134ef332bd9e3e734c1ba0a1521f436b678 ]

Rework error handling in sun8i_ce_hash_run() to unmap the dma buffers in
case of failure. Currently, the dma unmap functions are not called if the
function errors out at various points.

Fixes: 56f6d5aee88d1 ("crypto: sun8i-ce - support hash algorithms")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 34 ++++++++++++-------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index d358334e59811..ebc857ed10e11 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -343,9 +343,8 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	u32 common;
 	u64 byte_count;
 	__le32 *bf;
-	void *buf = NULL;
+	void *buf, *result;
 	int j, i, todo;
-	void *result = NULL;
 	u64 bs;
 	int digestsize;
 	dma_addr_t addr_res, addr_pad;
@@ -365,14 +364,14 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	buf = kzalloc(bs * 2, GFP_KERNEL | GFP_DMA);
 	if (!buf) {
 		err = -ENOMEM;
-		goto theend;
+		goto err_out;
 	}
 	bf = (__le32 *)buf;
 
 	result = kzalloc(digestsize, GFP_KERNEL | GFP_DMA);
 	if (!result) {
 		err = -ENOMEM;
-		goto theend;
+		goto err_free_buf;
 	}
 
 	flow = rctx->flow;
@@ -398,7 +397,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	if (nr_sgs <= 0 || nr_sgs > MAX_SG) {
 		dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
 		err = -EINVAL;
-		goto theend;
+		goto err_free_result;
 	}
 
 	len = areq->nbytes;
@@ -411,7 +410,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	if (len > 0) {
 		dev_err(ce->dev, "remaining len %d\n", len);
 		err = -EINVAL;
-		goto theend;
+		goto err_unmap_src;
 	}
 	addr_res = dma_map_single(ce->dev, result, digestsize, DMA_FROM_DEVICE);
 	cet->t_dst[0].addr = cpu_to_le32(addr_res);
@@ -419,7 +418,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	if (dma_mapping_error(ce->dev, addr_res)) {
 		dev_err(ce->dev, "DMA map dest\n");
 		err = -EINVAL;
-		goto theend;
+		goto err_unmap_src;
 	}
 
 	byte_count = areq->nbytes;
@@ -441,7 +440,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	}
 	if (!j) {
 		err = -EINVAL;
-		goto theend;
+		goto err_unmap_result;
 	}
 
 	addr_pad = dma_map_single(ce->dev, buf, j * 4, DMA_TO_DEVICE);
@@ -450,7 +449,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	if (dma_mapping_error(ce->dev, addr_pad)) {
 		dev_err(ce->dev, "DMA error on padding SG\n");
 		err = -EINVAL;
-		goto theend;
+		goto err_unmap_result;
 	}
 
 	if (ce->variant->hash_t_dlen_in_bits)
@@ -463,16 +462,25 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	err = sun8i_ce_run_task(ce, flow, crypto_ahash_alg_name(tfm));
 
 	dma_unmap_single(ce->dev, addr_pad, j * 4, DMA_TO_DEVICE);
-	dma_unmap_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
+
+err_unmap_result:
 	dma_unmap_single(ce->dev, addr_res, digestsize, DMA_FROM_DEVICE);
+	if (!err)
+		memcpy(areq->result, result, algt->alg.hash.base.halg.digestsize);
 
+err_unmap_src:
+	dma_unmap_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
 
-	memcpy(areq->result, result, algt->alg.hash.base.halg.digestsize);
-theend:
-	kfree(buf);
+err_free_result:
 	kfree(result);
+
+err_free_buf:
+	kfree(buf);
+
+err_out:
 	local_bh_disable();
 	crypto_finalize_hash_request(engine, breq, err);
 	local_bh_enable();
+
 	return 0;
 }
-- 
2.39.5



