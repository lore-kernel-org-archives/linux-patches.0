Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD197A124;
	Mon,  4 Mar 2024 21:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587917; cv=none; b=Fqryui8fWCYxIo/gGkWhLwyDAp+zqVhN1kbHzpPV++OQCRaGxGm2hG3rs/Xc6bn3l5gAyHS1nFwYlv93GbygAy3oSY8OrpHDClWgijLpWaOIAVcHKWGMInkTn1dmSDUyrFOZtOgyaECVXjrx1cZz1OmXuzyrgVNZYCCUrRUEM7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587917; c=relaxed/simple;
	bh=iiBlqWK5akyJRFnJFDg7SIRqn9ThNDhEAKlWrSosorw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LB/KeBTtZ75h2pE95kk/pqZeSRZ0R5qtVymNd1cKJk/x1OI6jJ+u7VMzkh+q5LUl97eDr1eKmcUpG0bguGRCnDQn2/nGxCynciMdrua6Vbc6NC1mGzGSsJgzNAcEQQLGCMOJZ2OG9mOItlNFcx3OdslNQ95tlCbbgvcZgjFgcQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDrja90Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDrja90Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C015C433F1;
	Mon,  4 Mar 2024 21:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587917;
	bh=iiBlqWK5akyJRFnJFDg7SIRqn9ThNDhEAKlWrSosorw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDrja90ZAujE8IXpTPGKjVMS6sjjgoHrB5mkd+igzqxj7+XGojxHIoCMCK1xhxDH1
	 f5S/OpaR/n27JsiQjzi/2raqBHPN88alhKLMYKdetM2l5/y5l/d4bjI8Y79IL7eqKR
	 70jh9bTv5XLHbZXTYAtP2lpVDN+E/EJpWagUcu2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 139/162] dmaengine: dw-edma: HDMA: Add sync read before starting the DMA transfer in remote setup
Date: Mon,  4 Mar 2024 21:23:24 +0000
Message-ID: <20240304211556.172432422@linuxfoundation.org>
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

[ Upstream commit 712a92a48158e02155b4b6b21e03a817f78c9b7e ]

The Linked list element and pointer are not stored in the same memory as
the HDMA controller register. If the doorbell register is toggled before
the full write of the linked list a race condition error will occur.
In remote setup we can only use a readl to the memory to assure the full
write has occurred.

Fixes: e74c39573d35 ("dmaengine: dw-edma: Add support for native HDMA")
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://lore.kernel.org/r/20240129-b4-feature_hdma_mainline-v7-5-8e8c1acb7a46@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-hdma-v0-core.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/dma/dw-edma/dw-hdma-v0-core.c b/drivers/dma/dw-edma/dw-hdma-v0-core.c
index 04b0bcb6ded97..10e8f0715114f 100644
--- a/drivers/dma/dw-edma/dw-hdma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-hdma-v0-core.c
@@ -222,6 +222,20 @@ static void dw_hdma_v0_core_write_chunk(struct dw_edma_chunk *chunk)
 	dw_hdma_v0_write_ll_link(chunk, i, control, chunk->ll_region.paddr);
 }
 
+static void dw_hdma_v0_sync_ll_data(struct dw_edma_chunk *chunk)
+{
+	/*
+	 * In case of remote HDMA engine setup, the DW PCIe RP/EP internal
+	 * configuration registers and application memory are normally accessed
+	 * over different buses. Ensure LL-data reaches the memory before the
+	 * doorbell register is toggled by issuing the dummy-read from the remote
+	 * LL memory in a hope that the MRd TLP will return only after the
+	 * last MWr TLP is completed
+	 */
+	if (!(chunk->chan->dw->chip->flags & DW_EDMA_CHIP_LOCAL))
+		readl(chunk->ll_region.vaddr.io);
+}
+
 static void dw_hdma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
 {
 	struct dw_edma_chan *chan = chunk->chan;
@@ -252,6 +266,9 @@ static void dw_hdma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
 	/* Set consumer cycle */
 	SET_CH_32(dw, chan->dir, chan->id, cycle_sync,
 		  HDMA_V0_CONSUMER_CYCLE_STAT | HDMA_V0_CONSUMER_CYCLE_BIT);
+
+	dw_hdma_v0_sync_ll_data(chunk);
+
 	/* Doorbell */
 	SET_CH_32(dw, chan->dir, chan->id, doorbell, HDMA_V0_DOORBELL_START);
 }
-- 
2.43.0



