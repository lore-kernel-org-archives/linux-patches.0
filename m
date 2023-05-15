Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0D1FBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE400C433EF;
	Mon, 15 May 2023 17:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172793;
	bh=rtOpymRfZvfeRVyj11dSXMi9w0U9vzUsi7gXK5tqrrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKjzl6bAVilEDPHAdroExfvqM1VFxQhMz7bSo97hALIU8PP/SblPUqCKN9gtaVAl4
	 9D+4p4zQ2ahaK1wNxmwi/2WJkis9/JhwlrDbs1Gekcveg/POtz+5lva7FbNUBK9yn9
	 TQR27N7ifnTsqRysgvxGLUcpIYtefn9S/WbDyKcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shunsuke Mie <mie@igel.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/381] dmaengine: dw-edma: Fix to change for continuous transfer
Date: Mon, 15 May 2023 18:28:40 +0200
Message-Id: <20230515161748.917736528@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
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

[ Upstream commit a251994a441ee0a69ba7062c8cd2d08ead3db379 ]

The dw-edma driver stops after processing a DMA request even if a request
remains in the issued queue, which is not the expected behavior. The DMA
engine API requires continuous processing.

Add a trigger to start after one processing finished if there are requests
remain.

Fixes: e63d79d1ffcd ("dmaengine: Add Synopsys eDMA IP core driver")
Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
Link: https://lore.kernel.org/r/20230411101758.438472-1-mie@igel.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-core.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
index d7ed50f8b9294..a3790f7b1b530 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -166,7 +166,7 @@ static void vchan_free_desc(struct virt_dma_desc *vdesc)
 	dw_edma_free_desc(vd2dw_edma_desc(vdesc));
 }
 
-static void dw_edma_start_transfer(struct dw_edma_chan *chan)
+static int dw_edma_start_transfer(struct dw_edma_chan *chan)
 {
 	struct dw_edma_chunk *child;
 	struct dw_edma_desc *desc;
@@ -174,16 +174,16 @@ static void dw_edma_start_transfer(struct dw_edma_chan *chan)
 
 	vd = vchan_next_desc(&chan->vc);
 	if (!vd)
-		return;
+		return 0;
 
 	desc = vd2dw_edma_desc(vd);
 	if (!desc)
-		return;
+		return 0;
 
 	child = list_first_entry_or_null(&desc->chunk->list,
 					 struct dw_edma_chunk, list);
 	if (!child)
-		return;
+		return 0;
 
 	dw_edma_v0_core_start(child, !desc->xfer_sz);
 	desc->xfer_sz += child->ll_region.sz;
@@ -191,6 +191,8 @@ static void dw_edma_start_transfer(struct dw_edma_chan *chan)
 	list_del(&child->list);
 	kfree(child);
 	desc->chunks_alloc--;
+
+	return 1;
 }
 
 static int dw_edma_device_config(struct dma_chan *dchan,
@@ -497,14 +499,14 @@ static void dw_edma_done_interrupt(struct dw_edma_chan *chan)
 		switch (chan->request) {
 		case EDMA_REQ_NONE:
 			desc = vd2dw_edma_desc(vd);
-			if (desc->chunks_alloc) {
-				chan->status = EDMA_ST_BUSY;
-				dw_edma_start_transfer(chan);
-			} else {
+			if (!desc->chunks_alloc) {
 				list_del(&vd->node);
 				vchan_cookie_complete(vd);
-				chan->status = EDMA_ST_IDLE;
 			}
+
+			/* Continue transferring if there are remaining chunks or issued requests.
+			 */
+			chan->status = dw_edma_start_transfer(chan) ? EDMA_ST_BUSY : EDMA_ST_IDLE;
 			break;
 
 		case EDMA_REQ_STOP:
-- 
2.39.2



