Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906682BE655;
	Mon,  1 Dec 2025 11:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588518; cv=none; b=jdcVquCWZ9pjrDK6teIEckUQsTNhC+W5/Im9tbnTggqtqh8vf5LN/pIhjMvxUAKtfU7kq2QUvwXxudrFuWpNDVCCUbnBma7NdMkRLm+/4Dw2sa+YkR1C1njm2yyZYzv9OSrOfRYQVTCR+v2X6zJyPV+YVc9+Hpsl1ub/FLtuUL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588518; c=relaxed/simple;
	bh=xD0q7ZIziffp9tYPIwEPxr0/QWIjqdpUdryFZJKo1S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbRz6ZFZzwKmXOAsyF7408HhELNTx4QIB5UoRY8jYqEVaQ5xVYsGCNd4+FFR9U6jmp43LZ4SRVje3U+aaR9fUiL70ctTG8TXKZDqtKqivsmhXNGzI0lz/j56UgvbMn152h/xt7eO4C+1dCbwnS+fZ3rrG0rKHAlbQKLn4+fE/Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFKjWC2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFKjWC2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F357FC4CEF1;
	Mon,  1 Dec 2025 11:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588518;
	bh=xD0q7ZIziffp9tYPIwEPxr0/QWIjqdpUdryFZJKo1S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFKjWC2+mi9Zx/McFQaJ+JGqs97CzoAcbBzxNaqWB/CvD1ArGURWL2jQDdQ9U9xMB
	 5X5V8IxRAJJ0OcRW66L7CBM+RSQUn3ayDXNuGRBYNAu7+GH2eI85qyuIc7qykF8hWD
	 0fpvGtsBZ+xzaMTcDf8ZAea3i/4m0W60ZEXkaKVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devendra K Verma <devverma@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/187] dmaengine: dw-edma: Set status for callback_result
Date: Mon,  1 Dec 2025 12:23:03 +0100
Message-ID: <20251201112243.944239676@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devendra K Verma <devverma@amd.com>

[ Upstream commit 5e742de97c806a4048418237ef1283e7d71eaf4b ]

DMA Engine has support for the callback_result which provides
the status of the request and the residue. This helps in
determining the correct status of the request and in
efficient resource management of the request.
The 'callback_result' method is preferred over the deprecated
'callback' method.

Signed-off-by: Devendra K Verma <devverma@amd.com>
Link: https://lore.kernel.org/r/20250821121505.318179-1-devverma@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-core.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
index 25d65f64cd507..6cbb018c215ad 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -474,6 +474,25 @@ dw_edma_device_prep_dma_cyclic(struct dma_chan *dchan, dma_addr_t paddr,
 	return dw_edma_device_transfer(&xfer);
 }
 
+static void dw_hdma_set_callback_result(struct virt_dma_desc *vd,
+					enum dmaengine_tx_result result)
+{
+	u32 residue = 0;
+	struct dw_edma_desc *desc;
+	struct dmaengine_result *res;
+
+	if (!vd->tx.callback_result)
+		return;
+
+	desc = vd2dw_edma_desc(vd);
+	if (desc)
+		residue = desc->alloc_sz - desc->xfer_sz;
+
+	res = &vd->tx_result;
+	res->result = result;
+	res->residue = residue;
+}
+
 static void dw_edma_done_interrupt(struct dw_edma_chan *chan)
 {
 	struct dw_edma_desc *desc;
@@ -489,6 +508,8 @@ static void dw_edma_done_interrupt(struct dw_edma_chan *chan)
 		case EDMA_REQ_NONE:
 			desc = vd2dw_edma_desc(vd);
 			if (!desc->chunks_alloc) {
+				dw_hdma_set_callback_result(vd,
+							    DMA_TRANS_NOERROR);
 				list_del(&vd->node);
 				vchan_cookie_complete(vd);
 			}
@@ -527,6 +548,7 @@ static void dw_edma_abort_interrupt(struct dw_edma_chan *chan)
 	spin_lock_irqsave(&chan->vc.lock, flags);
 	vd = vchan_next_desc(&chan->vc);
 	if (vd) {
+		dw_hdma_set_callback_result(vd, DMA_TRANS_ABORTED);
 		list_del(&vd->node);
 		vchan_cookie_complete(vd);
 	}
-- 
2.51.0



