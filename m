Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A311C3148C1;
	Wed,  3 Dec 2025 15:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776279; cv=none; b=sUYtaP3PjSXJGCb1O9bRhKqAlS/M55Ch8jXnCDXs+0YlrFqww++I2GiHHDSjzKxxDp21l7+1fzPcd1MbyH1t1rxGZuIgdR1xYTot+TX97HExM4wjXgCYGu+oKcOmTDrOzv8Bz1omJufdSjXSuShb6UxhlRFXgPRFjL30n+AfFrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776279; c=relaxed/simple;
	bh=BzOQ7YANzYQfaunqRrdZhHnNch4mFKLGDr4BGGj1gf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhKwVOHYLp4w0hiz9ZyXc5WMT4z4CAnq9P7qel8DI0S/ui/kZUkNEYMMa3Q+cqjO3tt69/xQFxI9LuUDCsy5GcSC9MapDJio/sIFKMjk7J1FlfZEfoSOaiGA9wAAwbarfzZkiaHtUtcc6RJ0PUQHmkrA/9JocIkM5Gs2QK7lY8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKxMnypU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKxMnypU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE587C4CEF5;
	Wed,  3 Dec 2025 15:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776279;
	bh=BzOQ7YANzYQfaunqRrdZhHnNch4mFKLGDr4BGGj1gf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKxMnypU6E2XSSe63mi6BXQWgYGzhcAXm6BIXFKGvYZN59ibY98Pj7pN3/60WQq+G
	 0UK5ZhM+AGMafaXXfBBLo+msmqUtnSFZk5qiyBhDepLOb6b5woyrmXm03UJtQ2HWZ0
	 S/LRROAzi9Xqq8BwjZqtENjVDwoT84pS11PsgeTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devendra K Verma <devverma@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/300] dmaengine: dw-edma: Set status for callback_result
Date: Wed,  3 Dec 2025 16:25:06 +0100
Message-ID: <20251203152404.403643470@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f91dbf43a5980..df2874f6f4620 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -488,6 +488,25 @@ dw_edma_device_prep_dma_cyclic(struct dma_chan *dchan, dma_addr_t paddr,
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
@@ -503,6 +522,8 @@ static void dw_edma_done_interrupt(struct dw_edma_chan *chan)
 		case EDMA_REQ_NONE:
 			desc = vd2dw_edma_desc(vd);
 			if (!desc->chunks_alloc) {
+				dw_hdma_set_callback_result(vd,
+							    DMA_TRANS_NOERROR);
 				list_del(&vd->node);
 				vchan_cookie_complete(vd);
 			}
@@ -541,6 +562,7 @@ static void dw_edma_abort_interrupt(struct dw_edma_chan *chan)
 	spin_lock_irqsave(&chan->vc.lock, flags);
 	vd = vchan_next_desc(&chan->vc);
 	if (vd) {
+		dw_hdma_set_callback_result(vd, DMA_TRANS_ABORTED);
 		list_del(&vd->node);
 		vchan_cookie_complete(vd);
 	}
-- 
2.51.0



