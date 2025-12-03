Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4237234CFC2;
	Wed,  3 Dec 2025 16:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777736; cv=none; b=IlIUkg8byBaGXEqXEgaEBQTxxB1WuvmFVi9X/GWRkF6AwBrusxb5l57cWmDYXn+Q7ap28rR/MPVHLhIg0LyXSbDPouZaCC+rN7bBM07jvLo9+pCa7+PP6gYPzkz4yT9NnWhf6N37un44p190Sb60tW3haxbxCkNr3kHNJF+wj/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777736; c=relaxed/simple;
	bh=IlRN3VchDwJbR71A9xOTJETG3yhQq39peGx/upSBAWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEg2tUnQu/1vcmhgmR3NEDP5nzTL6UuDrEMknGLJTkH2dWzZzdfaOsaG00o5U4YUBHX1lveOZuALPk4e/zzWIw6V57k/UU4O4vsikQPHHZAtyGCqilPspYNlQC/x0i0Z/dlFAA22UDuID17XIhdYZ9P1MFZt3/7T8aEmHXA5fPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSy+uVG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSy+uVG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6942CC4CEF5;
	Wed,  3 Dec 2025 16:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777735;
	bh=IlRN3VchDwJbR71A9xOTJETG3yhQq39peGx/upSBAWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSy+uVG6dIG+aLfZm99WfWoh0qgqImrcr3G7S8ddeiexUks2yQhJhIIJBPsTPcm9H
	 FQg5BIehVmrmRuHq2fWiBP4hj+/nuMV4iH3AAYdhs/sTF/4PwBhEG7RmMylpS2f6GX
	 sxtMEDOUwlimnVOVHzSFlU1gpC6MLVYcUCw0fEko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devendra K Verma <devverma@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/392] dmaengine: dw-edma: Set status for callback_result
Date: Wed,  3 Dec 2025 16:24:39 +0100
Message-ID: <20251203152418.840116172@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 799ebbaf35be5..f01b6c4bd315f 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -546,6 +546,25 @@ dw_edma_device_prep_interleaved_dma(struct dma_chan *dchan,
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
@@ -561,6 +580,8 @@ static void dw_edma_done_interrupt(struct dw_edma_chan *chan)
 		case EDMA_REQ_NONE:
 			desc = vd2dw_edma_desc(vd);
 			if (!desc->chunks_alloc) {
+				dw_hdma_set_callback_result(vd,
+							    DMA_TRANS_NOERROR);
 				list_del(&vd->node);
 				vchan_cookie_complete(vd);
 			}
@@ -599,6 +620,7 @@ static void dw_edma_abort_interrupt(struct dw_edma_chan *chan)
 	spin_lock_irqsave(&chan->vc.lock, flags);
 	vd = vchan_next_desc(&chan->vc);
 	if (vd) {
+		dw_hdma_set_callback_result(vd, DMA_TRANS_ABORTED);
 		list_del(&vd->node);
 		vchan_cookie_complete(vd);
 	}
-- 
2.51.0



