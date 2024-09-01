Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A67144C97;
	Sun,  1 Sep 2024 16:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208011; cv=none; b=hB/n85fruadZmG2ynMH1GJF/WZvQtDrSpiAoXnezSYIrANj2WN4e+58UDjhIEULxEWWabZAn1nVq5yNJp9J2blNAbN/TLw+GGMlshndhf0VcWC0T2Xs58KsciuvJJqQfnSH3Ovusfk0A1IJfb3Xto4m5v5AiK63D4NSt7dyIThg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208011; c=relaxed/simple;
	bh=4Pvmx2x+vpw5+kr1mRC3NtwH/6QG2dXoEQ+b5QcvNsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRtYZ1rjm0OdZi/TMZz0GVAGQr9mp3zCoOv+FXfpKIbl5c9UMxFBgjL9iZOCtc5nMwHf2+amGkn3UUptbfv3/1n25bQBsUQu33xAJ6FEbsEQazpfrmgDhVy61N4nKogrZxSdx0JInROKzwv9ew6YD9yIjTiM5moTC4JCf5VZYLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDY7uSmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDY7uSmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB309C4CEC3;
	Sun,  1 Sep 2024 16:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208011;
	bh=4Pvmx2x+vpw5+kr1mRC3NtwH/6QG2dXoEQ+b5QcvNsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDY7uSmGrvj4gsL6RGN2Dhp1UuZB0ofV6dM/95KQimHxKwNo5Ev0Y5oqA19jlv4JS
	 JUewBNxuWVOoeMs53KX0nE4q1FV8dMNFD5PsJR1+G6VeNxxFLjBp8pVjO5ZAKvztLR
	 dnCjAUl6DUj2aISKwg5iEd98QC9XXH/McTnw2wog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mrinmay Sarkar <quic_msarkar@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Serge Semin <fancer.lancer@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 47/93] dmaengine: dw-edma: Do not enable watermark interrupts for HDMA
Date: Sun,  1 Sep 2024 18:16:34 +0200
Message-ID: <20240901160809.133798898@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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
 drivers/dma/dw-edma/dw-hdma-v0-core.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/dw-edma/dw-hdma-v0-core.c b/drivers/dma/dw-edma/dw-hdma-v0-core.c
index 2addaca3b694..e3f8db4fe909 100644
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
@@ -195,25 +195,14 @@ static void dw_hdma_v0_write_ll_link(struct dw_edma_chunk *chunk,
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
-- 
2.46.0



