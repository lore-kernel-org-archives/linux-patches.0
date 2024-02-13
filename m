Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5581E5FDD8;
	Tue, 13 Feb 2024 17:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845030; cv=none; b=pkJBVbc1SrC2YlHSOY0x95NfbbSCVhEzCMFdVzDGSFQlgQU1l4+VBaSRsWlfgoI/TGDKcziPeRNm9nzaezY7XUPz7uHW6y49IUIYi6TtfLVOmaM0lUaVboY9/5BgUQpsIAUa84IYbk2zHL2PeWMiVYfaYI2x//gnKikLm1RqPmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845030; c=relaxed/simple;
	bh=R2Ww+BDKfkuYHMME2VwVWxu5i6a7gSBTapt0B8n4U54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syt56zCXSdZ3I8sQ22WV/T7uysylcEju4xPn8xY4+qp8KLAK47GsVW0fYPCyobHMiVoENAC9t1O8U06Xm5OrnMHBoghYuBYaFPv7t62wtziD6K+FMiWy4EcFVGAm9LBucGXM9rGwMo4wKQE+3wDng19ynX9ziEJnYqqxmINlWUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZ2FgIf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZ2FgIf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BBDC433C7;
	Tue, 13 Feb 2024 17:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845030;
	bh=R2Ww+BDKfkuYHMME2VwVWxu5i6a7gSBTapt0B8n4U54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZ2FgIf8FvqB+dvRI4k7DPy4IzLXnCvZSnFc3QDU5PkaRb4Ll6Bosc3PoCVWvDXWw
	 T2DoBQP2Z6gmWM1A3mnQ5quq6j+m4PPEa2q+9Nh28Gs60EV0leRZ4tQDqwhjA+r8Jg
	 vzj3R6NbEFBiWkGKbEGIYaN9VnkWeHgFy9ebGTgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <j-luthra@ti.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 03/64] dmaengine: ti: k3-udma: Report short packet errors
Date: Tue, 13 Feb 2024 18:20:49 +0100
Message-ID: <20240213171844.830813079@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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
index b86b809eb1f7..82e7acfda6ed 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -3963,6 +3963,7 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
 {
 	struct udma_chan *uc = to_udma_chan(&vc->chan);
 	struct udma_desc *d;
+	u8 status;
 
 	if (!vd)
 		return;
@@ -3972,12 +3973,12 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
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
@@ -3986,7 +3987,12 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
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



