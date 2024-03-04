Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372577A124;
	Mon,  4 Mar 2024 21:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587907; cv=none; b=Z1QMUT5MLR1/7HeFYG9ZRncx94ynRbwIwl9/iUpb14AvSFjsTd+QNxk9uu7XPbfL7Y6yyxucKMqzC2h3LewncQoPfU/oWMMdhY2bFMkkTLDKWbkt6dVsQ0s23AVwAKPDuitHJl8A77M09+TuKPSsqfzBy1LFN7KD9fgMQ9Avp6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587907; c=relaxed/simple;
	bh=CMwhRlVMRvxGnxRu9N3wdEVm2cbyADTyM0DbUeGTOFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgVsKxrXQ+MtN8Lw4oUixEK32uGNNo3BefTzErD8N6X0pint+e8HoGJ3PmdPOr0gTHMcT7nJ6p/yh3WwwZQwV9gfZGKxGc15gZchdvWX7xxRa7qt/wexiIJJzSGq+x5PpedTRzYtEDLUZipY1T97ncV+QN8as0kcl+Retgi6F+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpAy7kGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpAy7kGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE122C433F1;
	Mon,  4 Mar 2024 21:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587907;
	bh=CMwhRlVMRvxGnxRu9N3wdEVm2cbyADTyM0DbUeGTOFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpAy7kGy7oMBXmnTLf89A2NQ+5u74U6F+eabxUV0FFTEc3wLCpKQrEB9JG56m7ECD
	 Yf6KfxoJoDuQ99D9oyZ+OiYUw3d6eGAoX/AMWQGaTWJ4Anm1PN/snMXPewolUcoMpw
	 ysE+/pzHYJCfnTiRiHaNnqPtPmS3MUavcm+Q/5WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Serge Semin <fancer.lancer@gmail.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 135/162] dmaengine: dw-edma: Fix the ch_count hdma callback
Date: Mon,  4 Mar 2024 21:23:20 +0000
Message-ID: <20240304211556.041098453@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit cd665bfc757c71e9b7e0abff0f362d8abd38a805 ]

The current check of ch_en enabled to know the maximum number of available
hardware channels is wrong as it check the number of ch_en register set
but all of them are unset at probe. This register is set at the
dw_hdma_v0_core_start function which is run lately before a DMA transfer.

The HDMA IP have no way to know the number of hardware channels available
like the eDMA IP, then let set it to maximum channels and let the platform
set the right number of channels.

Fixes: e74c39573d35 ("dmaengine: dw-edma: Add support for native HDMA")
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://lore.kernel.org/r/20240129-b4-feature_hdma_mainline-v7-1-8e8c1acb7a46@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-hdma-v0-core.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/dw-edma/dw-hdma-v0-core.c b/drivers/dma/dw-edma/dw-hdma-v0-core.c
index 00b735a0202ab..1f4cb7db54756 100644
--- a/drivers/dma/dw-edma/dw-hdma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-hdma-v0-core.c
@@ -65,18 +65,12 @@ static void dw_hdma_v0_core_off(struct dw_edma *dw)
 
 static u16 dw_hdma_v0_core_ch_count(struct dw_edma *dw, enum dw_edma_dir dir)
 {
-	u32 num_ch = 0;
-	int id;
-
-	for (id = 0; id < HDMA_V0_MAX_NR_CH; id++) {
-		if (GET_CH_32(dw, id, dir, ch_en) & BIT(0))
-			num_ch++;
-	}
-
-	if (num_ch > HDMA_V0_MAX_NR_CH)
-		num_ch = HDMA_V0_MAX_NR_CH;
-
-	return (u16)num_ch;
+	/*
+	 * The HDMA IP have no way to know the number of hardware channels
+	 * available, we set it to maximum channels and let the platform
+	 * set the right number of channels.
+	 */
+	return HDMA_V0_MAX_NR_CH;
 }
 
 static enum dma_status dw_hdma_v0_core_ch_status(struct dw_edma_chan *chan)
-- 
2.43.0



