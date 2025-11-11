Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B4B2D9ECD;
	Tue, 11 Nov 2025 01:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823597; cv=none; b=sntRzikmRM24cNBPxQ2YRuS9fC14mgGnkPXDp4fs6awqMRyfDhhgMQOwwbiLkalfrLvtR0jCAU1Vv1BF1P77x5ovLYY3tHiHBm0NE0rqBP/GF5dEbP78VxBBFb8t7/Lf0czUaFszn3d/oR4mKANpxhU2bxGsBeP3EaANolgLPSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823597; c=relaxed/simple;
	bh=Fib3j1FeVcde93v6bJlxRaKNe27BDAk4VG+Vdrc8+hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlXg8quYuRZsx/wWqhxuc69iJsxZi8VqDs/lKibDDAyhBCAfJkHxjdlXH+d0bHTIUgl0a7j79N9R1ToAAu4kqPbp6crqJxBAG15LzsLbmUD/etdTusqK1HIaICJfvbYX0DwsiFg47gAULiid6y0xYz2SwQdHcbU/cICRbThK/Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQW3lpQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQW3lpQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABADEC4CEF5;
	Tue, 11 Nov 2025 01:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823597;
	bh=Fib3j1FeVcde93v6bJlxRaKNe27BDAk4VG+Vdrc8+hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQW3lpQj3Ew/DIHvk07wnLm5WtCpJJC/aKnXzCoS1HIVy3VKAxwTmjSEk7pO1Ne+0
	 NPCM7KwoI+qQ7469piijlbkIFZJlKo94OomPh2hd/CZknoBcVMhKpaRtJ7rke4MM0i
	 Ug1uGbD2BaUyNf2DEA+U+WcJLOlWlWH7l0J/yRoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devendra K Verma <devverma@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 283/565] dmaengine: dw-edma: Set status for callback_result
Date: Tue, 11 Nov 2025 09:42:19 +0900
Message-ID: <20251111004533.246192393@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 68236247059d1..9ae789d4aca7b 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -595,6 +595,25 @@ dw_edma_device_prep_interleaved_dma(struct dma_chan *dchan,
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
@@ -608,6 +627,8 @@ static void dw_edma_done_interrupt(struct dw_edma_chan *chan)
 		case EDMA_REQ_NONE:
 			desc = vd2dw_edma_desc(vd);
 			if (!desc->chunks_alloc) {
+				dw_hdma_set_callback_result(vd,
+							    DMA_TRANS_NOERROR);
 				list_del(&vd->node);
 				vchan_cookie_complete(vd);
 			}
@@ -644,6 +665,7 @@ static void dw_edma_abort_interrupt(struct dw_edma_chan *chan)
 	spin_lock_irqsave(&chan->vc.lock, flags);
 	vd = vchan_next_desc(&chan->vc);
 	if (vd) {
+		dw_hdma_set_callback_result(vd, DMA_TRANS_ABORTED);
 		list_del(&vd->node);
 		vchan_cookie_complete(vd);
 	}
-- 
2.51.0



