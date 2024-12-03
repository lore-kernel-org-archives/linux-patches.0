Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8568205AD5;
	Tue,  3 Dec 2024 15:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240240; cv=none; b=fJHPNHKQP9IJRq4M7NxO5mmolGLfxMG8UNC5XPQLggKec8jfxmXmSdv7wZ2/Cx1kSug1UyXmrRQ1JTdtxX6ie6UJBYhQAaXSXVAa3ezUx2MoBTl/eBaSxTN9JshFV8R7oi+ao8duC1ECxDl1St+XWk8+zr34fYjGi/j1e5QZYjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240240; c=relaxed/simple;
	bh=DmKdxU/mMeTQA79jza+fwWy/dN7Ml2py2q26tIxGgRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxpEJK1YEoEufuw/Bo21d4X16blsU53xmeaL/d1LEUXQNVtWgkAMe+pOXyPspdftMpcYE79SFQxa1BcoIjAmQTU9MmeetI8hIIkvZ8h1OxydhPo8rlzTsKVuwtFOKYClN4jcf9niDE5f/NAaK6QRX9+czTm623ul7/QrMU3NAlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVS+Iqea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVS+Iqea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53921C4CED6;
	Tue,  3 Dec 2024 15:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240240;
	bh=DmKdxU/mMeTQA79jza+fwWy/dN7Ml2py2q26tIxGgRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVS+IqeaKutt7sunWmePzVppjWboIoaa5whDIMjsUXKmoCgQP7Sljf6FR/c72ga84
	 SbgWMHXN7kx5o/PEpzWpOfdtoj6gR8cBcmyiqeaohEHeIAb/jF5gKhvEX7TQEyqsyB
	 A09pPx+e3AVo4kchjNcPAvEXTxLEWxE/pA0nM144=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Paukrt <tomaspaukrt@email.cz>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/826] crypto: mxs-dcp - Fix AES-CBC with hardware-bound keys
Date: Tue,  3 Dec 2024 15:36:07 +0100
Message-ID: <20241203144745.028557510@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tomas Paukrt <tomaspaukrt@email.cz>

[ Upstream commit 0dbb6854ca14933e194e8e46c894ca7bff95d0f3 ]

Fix passing an initialization vector in the payload field which
is necessary for AES in CBC mode even with hardware-bound keys.

Fixes: 3d16af0b4cfa ("crypto: mxs-dcp: Add support for hardware-bound keys")
Signed-off-by: Tomas Paukrt <tomaspaukrt@email.cz>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/mxs-dcp.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index c82775dbb557a..77a6301f37f0a 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -225,21 +225,22 @@ static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
 static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 			   struct skcipher_request *req, int init)
 {
-	dma_addr_t key_phys = 0;
-	dma_addr_t src_phys, dst_phys;
+	dma_addr_t key_phys, src_phys, dst_phys;
 	struct dcp *sdcp = global_sdcp;
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
 	struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	bool key_referenced = actx->key_referenced;
 	int ret;
 
-	if (!key_referenced) {
+	if (key_referenced)
+		key_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_key + AES_KEYSIZE_128,
+					  AES_KEYSIZE_128, DMA_TO_DEVICE);
+	else
 		key_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_key,
 					  2 * AES_KEYSIZE_128, DMA_TO_DEVICE);
-		ret = dma_mapping_error(sdcp->dev, key_phys);
-		if (ret)
-			return ret;
-	}
+	ret = dma_mapping_error(sdcp->dev, key_phys);
+	if (ret)
+		return ret;
 
 	src_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_in_buf,
 				  DCP_BUF_SZ, DMA_TO_DEVICE);
@@ -300,7 +301,10 @@ static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 err_dst:
 	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
 err_src:
-	if (!key_referenced)
+	if (key_referenced)
+		dma_unmap_single(sdcp->dev, key_phys, AES_KEYSIZE_128,
+				 DMA_TO_DEVICE);
+	else
 		dma_unmap_single(sdcp->dev, key_phys, 2 * AES_KEYSIZE_128,
 				 DMA_TO_DEVICE);
 	return ret;
-- 
2.43.0



