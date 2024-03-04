Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69B98F58;
	Mon,  4 Mar 2024 21:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588481; cv=none; b=XehhQyvpzUCMlli5f6H+7gH8/zfvvImfr7/fk8u/+JCHynxe1PbsiUrO7j7cPtNL+gMz1xv5wYgbwKgTlOfxfgCABvVsuQAMROkhWLD35kGhPg4MYWXt82PPWJHX5BqHAsOpeRP2T9VaRGigXppCzWSr+mj2b7ktLZnE2c3X14o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588481; c=relaxed/simple;
	bh=fKQZGz2vh134rAB+qITmUFFJCxhmRQ72gxN69yBNjLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osxjd6R4HyFWRHp99rIAtRefrUROpp/sZ6Ct7IH3TSBezWmAAZsLbpJIBHVlAVxUqNk6O0Dt2MES/fGlFs25zE+yQr0uJSFFL8maUrCub76r/V4VJgBXiO27VULM58QChJ0NUXKOrufcLOoyFspErrQYpsHaSaoj397ICAAb+sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmbI4CXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmbI4CXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B295C433C7;
	Mon,  4 Mar 2024 21:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588481;
	bh=fKQZGz2vh134rAB+qITmUFFJCxhmRQ72gxN69yBNjLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmbI4CXQZaVq4vFmV62VmolJuuOs1W8G5IjkxinvxHoq3DcDBU/PRcQbxDIKAQXms
	 a2Vwz2es/Iq1FtZco94axNiv4mFMIvJQAgyr/wQ5X1JUHC/XEomZAPvbfyt9ViCTlg
	 wg4EeN7JLdHzWNRWz01KNx1hxAPuLnmceVdVyzvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/143] dmaengine: dw-edma: eDMA: Add sync read before starting the DMA transfer in remote setup
Date: Mon,  4 Mar 2024 21:24:03 +0000
Message-ID: <20240304211553.839606315@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit bbcc1c83f343e580c3aa1f2a8593343bf7b55bba ]

The Linked list element and pointer are not stored in the same memory as
the eDMA controller register. If the doorbell register is toggled before
the full write of the linked list a race condition error will occur.
In remote setup we can only use a readl to the memory to assure the full
write has occurred.

Fixes: 7e4b8a4fbe2c ("dmaengine: Add Synopsys eDMA IP version 0 support")
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://lore.kernel.org/r/20240129-b4-feature_hdma_mainline-v7-6-8e8c1acb7a46@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-v0-core.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/dma/dw-edma/dw-edma-v0-core.c b/drivers/dma/dw-edma/dw-edma-v0-core.c
index b38786f0ad799..b75fdaffad9a4 100644
--- a/drivers/dma/dw-edma/dw-edma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-edma-v0-core.c
@@ -346,6 +346,20 @@ static void dw_edma_v0_core_write_chunk(struct dw_edma_chunk *chunk)
 	dw_edma_v0_write_ll_link(chunk, i, control, chunk->ll_region.paddr);
 }
 
+static void dw_edma_v0_sync_ll_data(struct dw_edma_chunk *chunk)
+{
+	/*
+	 * In case of remote eDMA engine setup, the DW PCIe RP/EP internal
+	 * configuration registers and application memory are normally accessed
+	 * over different buses. Ensure LL-data reaches the memory before the
+	 * doorbell register is toggled by issuing the dummy-read from the remote
+	 * LL memory in a hope that the MRd TLP will return only after the
+	 * last MWr TLP is completed
+	 */
+	if (!(chunk->chan->dw->chip->flags & DW_EDMA_CHIP_LOCAL))
+		readl(chunk->ll_region.vaddr.io);
+}
+
 static void dw_edma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
 {
 	struct dw_edma_chan *chan = chunk->chan;
@@ -412,6 +426,9 @@ static void dw_edma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
 		SET_CH_32(dw, chan->dir, chan->id, llp.msb,
 			  upper_32_bits(chunk->ll_region.paddr));
 	}
+
+	dw_edma_v0_sync_ll_data(chunk);
+
 	/* Doorbell */
 	SET_RW_32(dw, chan->dir, doorbell,
 		  FIELD_PREP(EDMA_V0_DOORBELL_CH_MASK, chan->id));
-- 
2.43.0



