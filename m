Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0137E1F75BD;
	Tue,  3 Dec 2024 14:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237858; cv=none; b=aZ+jzHJEbwFPx/NWobnDwl4/Dg8eNdR6x7/9qooajSehKgIIcrlnaLfSUiB9udFCAhaswGjdImdG+ydjxbuahG+52MCrtTU3aXPDDY3wQEBMJ5qOpG3ftTm1vPakn0XtvAdyKy7iD57D68ZRdFGH332XXtI48rwevRRMH0eS2XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237858; c=relaxed/simple;
	bh=NRqFO9dpE2sgOd6kCM9UoHiTHiS6W5aEBIpdU4Ji8sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkE5g9yUomy3TI08e5GtqPuX4wgYDXwQE8upQ2EuwZvG9suhO4q8+ij3i89ue/8oVoSSVOoZnPilV2Z8ZUE/y/pEHRPtTP1xigYdmP3ygJifhqTnAkQb5xPwgF8sDchLOea7601FeuTRrobavGe3TSQ9c4yDfNicx2W+9UEtBgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KLFhmqyG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLFhmqyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64222C4CED9;
	Tue,  3 Dec 2024 14:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237857;
	bh=NRqFO9dpE2sgOd6kCM9UoHiTHiS6W5aEBIpdU4Ji8sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLFhmqyGZD60BBOPpz50dSvPxC44jN4oCRaZd2Ai4PrBbLn2rfsPQXe5iMFL1Ma+9
	 CukL7kz24LFLC10Hvk/BW2yjZRlnjN0bIZYpx5i40XeX0ABqCJFz8tNHExOqqEbb3U
	 egg5j9nCPv8sbgTKMI/TdJX7GIb5F2Nf3y0Pd6+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Paukrt <tomaspaukrt@email.cz>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 088/817] crypto: mxs-dcp - Fix AES-CBC with hardware-bound keys
Date: Tue,  3 Dec 2024 15:34:20 +0100
Message-ID: <20241203143959.136230248@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



