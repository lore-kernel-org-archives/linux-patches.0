Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B2928DB6
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYAWAykH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BD8C433C8;
	Mon, 16 Oct 2023 14:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467804;
	bh=vzPSnOqMhc6YMbplDSRQd2RCS1U7NN4b7o0SwldkvS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYAWAykH41baP47tnJ+rNb28U+alK93h5ECJwGGLu9+Wbu/hGAw+pw0pCHk8mRgn/
	 h8BBFm6emOCeQqP38x7KWrQmw4K7gekeC1qLxxAb6vp5IQxmdGmEhXpqImB/i84Rz+
	 NAGCHDB9zTb2w6ODsFeWIO1XwseBlouRA9oAoSms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.5 098/191] dmaengine: stm32-mdma: set in_flight_bytes in case CRQA flag is set
Date: Mon, 16 Oct 2023 10:41:23 +0200
Message-ID: <20231016084017.678103893@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

commit 584970421725b7805db84714b857851fdf7203a9 upstream.

CRQA flag is set by hardware when the channel request become active and
the channel is enabled. It is cleared by hardware, when the channel request
is completed.
So when it is set, it means MDMA is transferring bytes.
This information is useful in case of STM32 DMA and MDMA chaining,
especially when the user pauses DMA before stopping it, to trig one last
MDMA transfer to get the latest bytes of the SRAM buffer to the
destination buffer.
STM32 DCMI driver can then use this to know if the last MDMA transfer in
case of chaining is done.

Fixes: 696874322771 ("dmaengine: stm32-mdma: add support to be triggered by STM32 DMA")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231004163531.2864160-3-amelie.delaunay@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/stm32-mdma.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/dma/stm32-mdma.c
+++ b/drivers/dma/stm32-mdma.c
@@ -1319,7 +1319,8 @@ static int stm32_mdma_slave_config(struc
 
 static size_t stm32_mdma_desc_residue(struct stm32_mdma_chan *chan,
 				      struct stm32_mdma_desc *desc,
-				      u32 curr_hwdesc)
+				      u32 curr_hwdesc,
+				      struct dma_tx_state *state)
 {
 	struct stm32_mdma_device *dmadev = stm32_mdma_get_dev(chan);
 	struct stm32_mdma_hwdesc *hwdesc;
@@ -1343,6 +1344,10 @@ static size_t stm32_mdma_desc_residue(st
 	cbndtr = stm32_mdma_read(dmadev, STM32_MDMA_CBNDTR(chan->id));
 	residue += cbndtr & STM32_MDMA_CBNDTR_BNDT_MASK;
 
+	state->in_flight_bytes = 0;
+	if (chan->chan_config.m2m_hw && (cisr & STM32_MDMA_CISR_CRQA))
+		state->in_flight_bytes = cbndtr & STM32_MDMA_CBNDTR_BNDT_MASK;
+
 	if (!chan->mem_burst)
 		return residue;
 
@@ -1372,11 +1377,10 @@ static enum dma_status stm32_mdma_tx_sta
 
 	vdesc = vchan_find_desc(&chan->vchan, cookie);
 	if (chan->desc && cookie == chan->desc->vdesc.tx.cookie)
-		residue = stm32_mdma_desc_residue(chan, chan->desc,
-						  chan->curr_hwdesc);
+		residue = stm32_mdma_desc_residue(chan, chan->desc, chan->curr_hwdesc, state);
 	else if (vdesc)
-		residue = stm32_mdma_desc_residue(chan,
-						  to_stm32_mdma_desc(vdesc), 0);
+		residue = stm32_mdma_desc_residue(chan, to_stm32_mdma_desc(vdesc), 0, state);
+
 	dma_set_residue(state, residue);
 
 	spin_unlock_irqrestore(&chan->vchan.lock, flags);


