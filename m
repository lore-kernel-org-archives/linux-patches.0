Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E7E168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BFAC433A0;
	Mon,  8 May 2023 10:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542951;
	bh=y2N7+oE41vBXkxludOGv3SC0Y9LV09mk2h/wIlGf6eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQ74egQWNFkezhIfylpqZkntOca7pHC5l+jed2F5Px+jN9/WQMw2n8eqzv+K2HDai
	 D+EgACFThCZHSL1IdFQfBK19HllRh+6LxpDSXeQa28BeRk//rMGI7/alFBtKYuHpzH
	 dUVEXlBbETDX3RAgr8mkP4uUSDN6tNemKsvN/mts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shunsuke Mie <mie@igel.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 594/663] dmaengine: dw-edma: Fix to enable to issue dma request on DMA processing
Date: Mon,  8 May 2023 11:47:00 +0200
Message-Id: <20230508094448.743585728@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shunsuke Mie <mie@igel.co.jp>

[ Upstream commit 970b17dfe264a9085ba4e593730ecfd496b950ab ]

The issue_pending request is ignored while driver is processing a DMA
request. Fix to issue the pending requests on any dma channel status.

Fixes: e63d79d1ffcd ("dmaengine: Add Synopsys eDMA IP core driver")
Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
Link: https://lore.kernel.org/r/20230411101758.438472-2-mie@igel.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
index cb46cbef212ab..ef4cdcf6beba0 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -279,9 +279,12 @@ static void dw_edma_device_issue_pending(struct dma_chan *dchan)
 	struct dw_edma_chan *chan = dchan2dw_edma_chan(dchan);
 	unsigned long flags;
 
+	if (!chan->configured)
+		return;
+
 	spin_lock_irqsave(&chan->vc.lock, flags);
-	if (chan->configured && chan->request == EDMA_REQ_NONE &&
-	    chan->status == EDMA_ST_IDLE && vchan_issue_pending(&chan->vc)) {
+	if (vchan_issue_pending(&chan->vc) && chan->request == EDMA_REQ_NONE &&
+	    chan->status == EDMA_ST_IDLE) {
 		chan->status = EDMA_ST_BUSY;
 		dw_edma_start_transfer(chan);
 	}
-- 
2.39.2



