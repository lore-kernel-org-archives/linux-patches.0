Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FA82B9C7;
	Sun,  1 Sep 2024 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208438; cv=none; b=CquURyYfAciBFZO6Na4/JfpcDAbRntI+guN/rJbCiPxN0HFyDFW8fO/sqFigbhrJwaHqg/ldj+XnnNrUJMSCw1FsJyNsWLaQbyT7V/PH+aCtXiUAp0C5CowufhGduZZWB8ykqwudnKNfW11d5MfU20AC+pPP83bdFkOsyeqHxM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208438; c=relaxed/simple;
	bh=p2eHvkZ1Rm/9vHx36DoAogTfUaig4FyG6VIwEpxlOgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ov2Usm01GGG/9nCl2O7Yt9WzTnlPqBFkwJNy/qeOTG3r6FZaWPfbXOdbwsZ/FC2zkEqF/DeU5v9qD98h9Bwz8qj6zloWs2Z/MZk9WtMdJv0u91qoBZs1Tx8cQkg9UPrijQfLdpeGr20cW4u+BzcAPmscOWYE4VUdfjWRSyO6ShU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekMSJvc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekMSJvc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D691CC4CEC3;
	Sun,  1 Sep 2024 16:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208438;
	bh=p2eHvkZ1Rm/9vHx36DoAogTfUaig4FyG6VIwEpxlOgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekMSJvc+cZTmEwuiMr7eR+SPekRkrb+eoVS4NQzilWspup5bIC4gW95ALj17n7c1E
	 xa3Xe6Z8ebB8wMnUkf9WTr6Msanxbsg2rB4BRfeUlIkxm6Mtu+r+vnMyaJAKKCV38z
	 saK4qScW4CUznvkg4WcGylLG1XE+7dqr30AH97YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mrinmay Sarkar <quic_msarkar@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Serge Semin <fancer.lancer@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.10 082/149] dmaengine: dw-edma: Do not enable watermark interrupts for HDMA
Date: Sun,  1 Sep 2024 18:16:33 +0200
Message-ID: <20240901160820.552245009@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mrinmay Sarkar <quic_msarkar@quicinc.com>

commit 9f646ff25c09c52cebe726601db27a60f876f15e upstream.

DW_HDMA_V0_LIE and DW_HDMA_V0_RIE are initialized as BIT(3) and BIT(4)
respectively in dw_hdma_control enum. But as per HDMA register these
bits are corresponds to LWIE and RWIE bit i.e local watermark interrupt
enable and remote watermarek interrupt enable. In linked list mode LWIE
and RWIE bits only enable the local and remote watermark interrupt.

Since the watermark interrupts are not used but enabled, this leads to
spurious interrupts getting generated. So remove the code that enables
them to avoid generating spurious watermark interrupts.

And also rename DW_HDMA_V0_LIE to DW_HDMA_V0_LWIE and DW_HDMA_V0_RIE to
DW_HDMA_V0_RWIE as there is no LIE and RIE bits in HDMA and those bits
are corresponds to LWIE and RWIE bits.

Fixes: e74c39573d35 ("dmaengine: dw-edma: Add support for native HDMA")
cc: stable@vger.kernel.org
Signed-off-by: Mrinmay Sarkar <quic_msarkar@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/1724674261-3144-3-git-send-email-quic_msarkar@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-hdma-v0-core.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/drivers/dma/dw-edma/dw-hdma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-hdma-v0-core.c
@@ -17,8 +17,8 @@ enum dw_hdma_control {
 	DW_HDMA_V0_CB					= BIT(0),
 	DW_HDMA_V0_TCB					= BIT(1),
 	DW_HDMA_V0_LLP					= BIT(2),
-	DW_HDMA_V0_LIE					= BIT(3),
-	DW_HDMA_V0_RIE					= BIT(4),
+	DW_HDMA_V0_LWIE					= BIT(3),
+	DW_HDMA_V0_RWIE					= BIT(4),
 	DW_HDMA_V0_CCS					= BIT(8),
 	DW_HDMA_V0_LLE					= BIT(9),
 };
@@ -195,25 +195,14 @@ static void dw_hdma_v0_write_ll_link(str
 static void dw_hdma_v0_core_write_chunk(struct dw_edma_chunk *chunk)
 {
 	struct dw_edma_burst *child;
-	struct dw_edma_chan *chan = chunk->chan;
 	u32 control = 0, i = 0;
-	int j;
 
 	if (chunk->cb)
 		control = DW_HDMA_V0_CB;
 
-	j = chunk->bursts_alloc;
-	list_for_each_entry(child, &chunk->burst->list, list) {
-		j--;
-		if (!j) {
-			control |= DW_HDMA_V0_LIE;
-			if (!(chan->dw->chip->flags & DW_EDMA_CHIP_LOCAL))
-				control |= DW_HDMA_V0_RIE;
-		}
-
+	list_for_each_entry(child, &chunk->burst->list, list)
 		dw_hdma_v0_write_ll_data(chunk, i++, control, child->sz,
 					 child->sar, child->dar);
-	}
 
 	control = DW_HDMA_V0_LLP | DW_HDMA_V0_TCB;
 	if (!chunk->cb)


