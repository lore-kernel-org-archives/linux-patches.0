Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6517FBBA;
	Wed, 21 Feb 2024 14:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524574; cv=none; b=S8RdyGNDEEj2KbeLxJL4JhkgoWSD8lwjkGVb0terXLKtoMWRwDGFwtCzU1UaKASeIhq72O+j78N4FgtXpdsnjEDMH2GlnTku6fjVlMYI00i2ULFOYxO7fCpEPt95XF9B/BfsxLE8s3w+9XAtZkdod6FlpPH1RMnelT96DdiCpEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524574; c=relaxed/simple;
	bh=yOmXw6GS2nGW4yARH+/Vo4vGD+dKcxSZ3+0izUBTPL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6e6dql65ZegqLIxuMO97QVzAvZAKK+qNF2o/7ftnM8MQGbaz8C4XWBD9piqk6NxctJf959ejx4koas6G6eOwUaX9iAaalETRwHrGbnyHTdL5FgDt6rMY5HlR1+z1bRLlpT5bM9oPf8GO+KPGmW1ZXwQx1Qlep/kORxQ8nh44jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FL/gEsPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FL/gEsPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BA4C433C7;
	Wed, 21 Feb 2024 14:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524574;
	bh=yOmXw6GS2nGW4yARH+/Vo4vGD+dKcxSZ3+0izUBTPL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FL/gEsPsv5DXm5TAlIshuRf4JFvUptjAURt19nds/CWnA+3Qct/E/OnP8XqvfX6pE
	 FFXAvD3Bq+uRmMiLlxlIAp6vmGNBH3dblJKDgTV28Q599URH28lrc7hj/7VVCsYR4E
	 WHXp+r8y1k/ybQ6K3gY21Dnocl2rwtNHk4SsUNxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <j-luthra@ti.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/379] dmaengine: ti: k3-udma: Report short packet errors
Date: Wed, 21 Feb 2024 14:07:06 +0100
Message-ID: <20240221130002.217275426@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d3902784cae2..15eecb757619 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -2877,6 +2877,7 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
 {
 	struct udma_chan *uc = to_udma_chan(&vc->chan);
 	struct udma_desc *d;
+	u8 status;
 
 	if (!vd)
 		return;
@@ -2886,12 +2887,12 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
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
@@ -2900,7 +2901,12 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
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



