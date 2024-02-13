Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CE75F56B;
	Tue, 13 Feb 2024 17:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845197; cv=none; b=Os2pyQ/0IvaazD+JJDoNwf2s/06VyftfkI5ysuTM55jhoVFj6caqdce/x5QgmUDvp+SFG/YSvzYWLgAAOeR4UN0or4G8R8aF+jJazC3/i2oGzU2mnE8NwBox2Ot1QCdTx2w1T+QxvcQ9/vd/EzF//8uXfdjC1jn4xmdm4/7gWCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845197; c=relaxed/simple;
	bh=W+Y1dtXR22GhTJ2ilG0vtotMTZAiTXyuUsFMD3Ck3pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqNXFMQesMSwIZFxuqWIVYjncSQOliBNYg39p70pO5Kkoy5a/XNoiXAev96qgukGRo4OLFUI+uZysTRtBPFnlJik3AiwC1zKpk9Y3LvZJo8epkr/qb16pGkcg5CM4U3cN2Q79wU8t/ialtMpLbPMD8bhf4GwRqIEVVve4SQ9u2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBIl/ggE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBIl/ggE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677C3C43399;
	Tue, 13 Feb 2024 17:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845196;
	bh=W+Y1dtXR22GhTJ2ilG0vtotMTZAiTXyuUsFMD3Ck3pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBIl/ggEkYA2soYpX0/CO4/3KdKzGnopLoqpUuCkEOJ0kywKwrc+Fx4yGyqeGUXV9
	 R3FNcsdnQjdEoppxdWxvKgzGW9Z1Xwu7ewYJ3EIN8TFUl2byoO+bOCZC5IBqWg9I7z
	 TTOlWasGzg10JSD6eYax047gwByeunOTVM+AYGms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <j-luthra@ti.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/121] dmaengine: ti: k3-udma: Report short packet errors
Date: Tue, 13 Feb 2024 18:20:12 +0100
Message-ID: <20240213171853.053494031@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

From: Jai Luthra <j-luthra@ti.com>

[ Upstream commit bc9847c9ba134cfe3398011e343dcf6588c1c902 ]

Propagate the TR response status to the device using BCDMA
split-channels. For example CSI-RX driver should be able to check if a
frame was not transferred completely (short packet) and needs to be
discarded.

Fixes: 25dcb5dd7b7c ("dmaengine: ti: New driver for K3 UDMA")
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20240103-tr_resp_err-v1-1-2fdf6d48ab92@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 30fd2f386f36..037f1408e798 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -3968,6 +3968,7 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
 {
 	struct udma_chan *uc = to_udma_chan(&vc->chan);
 	struct udma_desc *d;
+	u8 status;
 
 	if (!vd)
 		return;
@@ -3977,12 +3978,12 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
 	if (d->metadata_size)
 		udma_fetch_epib(uc, d);
 
-	/* Provide residue information for the client */
 	if (result) {
 		void *desc_vaddr = udma_curr_cppi5_desc_vaddr(d, d->desc_idx);
 
 		if (cppi5_desc_get_type(desc_vaddr) ==
 		    CPPI5_INFO0_DESC_TYPE_VAL_HOST) {
+			/* Provide residue information for the client */
 			result->residue = d->residue -
 					  cppi5_hdesc_get_pktlen(desc_vaddr);
 			if (result->residue)
@@ -3991,7 +3992,12 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
 				result->result = DMA_TRANS_NOERROR;
 		} else {
 			result->residue = 0;
-			result->result = DMA_TRANS_NOERROR;
+			/* Propagate TR Response errors to the client */
+			status = d->hwdesc[0].tr_resp_base->status;
+			if (status)
+				result->result = DMA_TRANS_ABORTED;
+			else
+				result->result = DMA_TRANS_NOERROR;
 		}
 	}
 }
-- 
2.43.0



