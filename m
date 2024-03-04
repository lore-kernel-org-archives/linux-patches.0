Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15E88F58;
	Mon,  4 Mar 2024 21:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588395; cv=none; b=cIXf346GIyfEQZajmoVeHuaiqHlBhLVbVlKYrr5v0pzUIzK+QLszmsIZWAkwj5a5AjTVZ12w9tC5I2/ff2R0juU8vg0SRIPaabptDQEMMOBE8XbxGji7zHTDXaHfC9AeIi7qo2RUcwPgwhAy+gTyvE5qmhMKfBxAUbf+NjxC80g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588395; c=relaxed/simple;
	bh=hUufiE2UDANstqNhkc+KC0CyblKLKwv4iWQhTanXaZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7dtgnWbh758r/V1jkXfrS6IV1ZneGvRR883Yoq+Sj7yQkYXr8cbossZCgVZPdD4LfH807B7NvLLI0K8QFv6LPAUSWC2oCprhvRcvJlC6IUt0fBfcLpD2GHSMcy0n4ov+b9Ndy30/HO/zio2XbNfe1zuuDq7L96Y8xdOCSmZnJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Do/6p3DL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Do/6p3DL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78706C433C7;
	Mon,  4 Mar 2024 21:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588394;
	bh=hUufiE2UDANstqNhkc+KC0CyblKLKwv4iWQhTanXaZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Do/6p3DLOr9XCCKjXrHGDf5zWxLDDWtTGn5cWBfPHDSiyTnIBW2CPPWhDg3XMN4/y
	 95nsjZBwjH7Bmf8vzkAiO8UobnLhl35A/5Sas33/INYJ+/1ub+QH3FO5l0OFza/tyw
	 hIx9XW+Kcjf4RxGGRJf2eVRECllPAvbBzZ6o2E24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Zou <joy.zou@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 091/143] dmaengine: fsl-edma: correct calculation of nbytes in multi-fifo scenario
Date: Mon,  4 Mar 2024 21:23:31 +0000
Message-ID: <20240304211552.821145046@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joy Zou <joy.zou@nxp.com>

commit 9ba17defd9edd87970b701085402bc8ecc3a11d4 upstream.

The 'nbytes' should be equivalent to burst * width in audio multi-fifo
setups. Given that the FIFO width is fixed at 32 bits, adjusts the burst
size for multi-fifo configurations to match the slave maxburst in the
configuration.

Cc: stable@vger.kernel.org
Fixes: 72f5801a4e2b ("dmaengine: fsl-edma: integrate v3 support")
Signed-off-by: Joy Zou <joy.zou@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240131163318.360315-1-Frank.Li@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/fsl-edma-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/fsl-edma-common.c b/drivers/dma/fsl-edma-common.c
index b53f46245c37..793f1a7ad5e3 100644
--- a/drivers/dma/fsl-edma-common.c
+++ b/drivers/dma/fsl-edma-common.c
@@ -503,7 +503,7 @@ void fsl_edma_fill_tcd(struct fsl_edma_chan *fsl_chan,
 	if (fsl_chan->is_multi_fifo) {
 		/* set mloff to support multiple fifo */
 		burst = cfg->direction == DMA_DEV_TO_MEM ?
-				cfg->src_addr_width : cfg->dst_addr_width;
+				cfg->src_maxburst : cfg->dst_maxburst;
 		nbytes |= EDMA_V3_TCD_NBYTES_MLOFF(-(burst * 4));
 		/* enable DMLOE/SMLOE */
 		if (cfg->direction == DMA_MEM_TO_DEV) {
-- 
2.44.0



