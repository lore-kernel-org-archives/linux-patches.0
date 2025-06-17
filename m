Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288722E9753;
	Tue, 17 Jun 2025 15:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174549; cv=none; b=I+Vx7GVNoOCLhOxMVLBTi+ItlsHH0JV6W8+gEcAbI9rPL6AZo4/Vl3qD4LdltfRIEJ5lnJEd7eIW+SqcYuajL5D9m3qyQHbYtts/3Tahgou9kT4EOE/hoGapw6MnzBVXzMT/c/Aq9uCiSP3VR0ziwWLK/S7aKky9w8TaMtWYJpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174549; c=relaxed/simple;
	bh=32irv2qdhGbiHEmFIDBtgezIskKz9tQ39EwChdz2g2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJdvcqZ7zKEfkl/HBibEzerPwe9VWjffFhfi3oXHwPDIAhawOYA42U/k/wQEexyFgqS6q83ntLFuKctJwqULTM5mxYpOCWxcRl8Nk+Po/u1cleqC++UE+NGXCAeOuxYChj7UIKbWL7AD0IQtpKbTCqK1V2pqy6yC5lNDLSdRzuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWFiwRIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWFiwRIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFC6C4CEE3;
	Tue, 17 Jun 2025 15:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174549;
	bh=32irv2qdhGbiHEmFIDBtgezIskKz9tQ39EwChdz2g2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWFiwRIeVEtPb4CKkl99gbqC9j+Fio6+zdCG3b+pskmgSZSYUdpAiclHge1LOaHqq
	 6dEZV1mU7ogqjYFt+4nYCcccYQ6Qiw80+bHbGt1rKNJUc+LjNgmSsxs39KN/692KSQ
	 2O2BU2E00rWquQCrqWULyJOu1Qg95UEf24Q092KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/512] crypto: sun8i-ce-cipher - fix error handling in sun8i_ce_cipher_prepare()
Date: Tue, 17 Jun 2025 17:19:36 +0200
Message-ID: <20250617152419.940791827@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

[ Upstream commit f31adc3e356f7350d4a4d68c98d3f60f2f6e26b3 ]

Fix two DMA cleanup issues on the error path in sun8i_ce_cipher_prepare():

1] If dma_map_sg() fails for areq->dst, the device driver would try to free
   DMA memory it has not allocated in the first place. To fix this, on the
   "theend_sgs" error path, call dma unmap only if the corresponding dma
   map was successful.

2] If the dma_map_single() call for the IV fails, the device driver would
   try to free an invalid DMA memory address on the "theend_iv" path:
   ------------[ cut here ]------------
   DMA-API: sun8i-ce 1904000.crypto: device driver tries to free an invalid DMA memory address
   WARNING: CPU: 2 PID: 69 at kernel/dma/debug.c:968 check_unmap+0x123c/0x1b90
   Modules linked in: skcipher_example(O+)
   CPU: 2 UID: 0 PID: 69 Comm: 1904000.crypto- Tainted: G           O        6.15.0-rc3+ #24 PREEMPT
   Tainted: [O]=OOT_MODULE
   Hardware name: OrangePi Zero2 (DT)
   pc : check_unmap+0x123c/0x1b90
   lr : check_unmap+0x123c/0x1b90
   ...
   Call trace:
    check_unmap+0x123c/0x1b90 (P)
    debug_dma_unmap_page+0xac/0xc0
    dma_unmap_page_attrs+0x1f4/0x5fc
    sun8i_ce_cipher_do_one+0x1bd4/0x1f40
    crypto_pump_work+0x334/0x6e0
    kthread_worker_fn+0x21c/0x438
    kthread+0x374/0x664
    ret_from_fork+0x10/0x20
   ---[ end trace 0000000000000000 ]---

To fix this, check for !dma_mapping_error() before calling
dma_unmap_single() on the "theend_iv" path.

Fixes: 06f751b61329 ("crypto: allwinner - Add sun8i-ce Crypto Engine")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 19b7fb4a93e86..05f67661553c9 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -275,13 +275,16 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	} else {
 		if (nr_sgs > 0)
 			dma_unmap_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
-		dma_unmap_sg(ce->dev, areq->dst, nd, DMA_FROM_DEVICE);
+
+		if (nr_sgd > 0)
+			dma_unmap_sg(ce->dev, areq->dst, nd, DMA_FROM_DEVICE);
 	}
 
 theend_iv:
 	if (areq->iv && ivsize > 0) {
-		if (rctx->addr_iv)
+		if (!dma_mapping_error(ce->dev, rctx->addr_iv))
 			dma_unmap_single(ce->dev, rctx->addr_iv, rctx->ivlen, DMA_TO_DEVICE);
+
 		offset = areq->cryptlen - ivsize;
 		if (rctx->op_dir & CE_DECRYPTION) {
 			memcpy(areq->iv, chan->backup_iv, ivsize);
-- 
2.39.5



