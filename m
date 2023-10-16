Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B006618634
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oi7bMgfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B25AC433C7;
	Mon, 16 Oct 2023 09:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446923;
	bh=aSPR0PcbeXtXpgBTBKqkszRniGlFSKCIf341qGi0pKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oi7bMgfw9gWWOFno1zMIWPfXSvbdkZSRWPa9pRqKMdcSyqFFt2q5j4vtRDcSxF3SO
	 /MEzWQJVv5ljiSol/8D5BlGhKyIeasHBrSRu4TMsdSBofAePzzOHs8RajRYeuTSxF6
	 bsv0YrWfAEgJAcXOk3MplBc4394oueBCNcEICNbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 070/131] dmaengine: stm32-dma: fix residue in case of MDMA chaining
Date: Mon, 16 Oct 2023 10:40:53 +0200
Message-ID: <20231016084001.804115920@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

commit 67e13e89742c3b21ce177f612bf9ef32caae6047 upstream.

In case of MDMA chaining, DMA is configured in Double-Buffer Mode (DBM)
with two periods, but if transfer has been prepared with _prep_slave_sg(),
the transfer is not marked cyclic (=!chan->desc->cyclic). However, as DBM
is activated for MDMA chaining, residue computation must take into account
cyclic constraints.

With only two periods in MDMA chaining, and no update due to Transfer
Complete interrupt masked, n_sg is always 0. If DMA current memory address
(depending on SxCR.CT and SxM0AR/SxM1AR) does not correspond, it means n_sg
should be increased.
Then, the residue of the current period is the one read from SxNDTR and
should not be overwritten with the full period length.

Fixes: 723795173ce1 ("dmaengine: stm32-dma: add support to trigger STM32 MDMA")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231004155024.2609531-2-amelie.delaunay@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/stm32-dma.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/stm32-dma.c b/drivers/dma/stm32-dma.c
index 7427acc82259..0b30151fb45c 100644
--- a/drivers/dma/stm32-dma.c
+++ b/drivers/dma/stm32-dma.c
@@ -1389,11 +1389,12 @@ static size_t stm32_dma_desc_residue(struct stm32_dma_chan *chan,
 
 	residue = stm32_dma_get_remaining_bytes(chan);
 
-	if (chan->desc->cyclic && !stm32_dma_is_current_sg(chan)) {
+	if ((chan->desc->cyclic || chan->trig_mdma) && !stm32_dma_is_current_sg(chan)) {
 		n_sg++;
 		if (n_sg == chan->desc->num_sgs)
 			n_sg = 0;
-		residue = sg_req->len;
+		if (!chan->trig_mdma)
+			residue = sg_req->len;
 	}
 
 	/*
@@ -1403,7 +1404,7 @@ static size_t stm32_dma_desc_residue(struct stm32_dma_chan *chan,
 	 * residue = remaining bytes from NDTR + remaining
 	 * periods/sg to be transferred
 	 */
-	if (!chan->desc->cyclic || n_sg != 0)
+	if ((!chan->desc->cyclic && !chan->trig_mdma) || n_sg != 0)
 		for (i = n_sg; i < desc->num_sgs; i++)
 			residue += desc->sg_req[i].len;
 
-- 
2.42.0



