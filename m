Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5AC28DB6
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccXXQeWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7DBC433C9;
	Mon, 16 Oct 2023 14:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467797;
	bh=+X1e9UZ7H+S/xOBiYYVv3JlcEE7Om0gUuhz8yFbdfP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccXXQeWcUepvk+bfgWHwwbt4/7FWPQ7LvEWcTTkuS+xYKrFknecTxVA0MCcCjP/Yt
	 LlTV5e09hGvgBGiwpj7dg1zNyvWDScST7sp68dTdKegzEGNC0o0bT6LLQiIhwg/4gb
	 g5N3VHzx65UQot1BhIcFTnLuWhVRhTrItre38bW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.5 097/191] dmaengine: stm32-mdma: use Link Address Register to compute residue
Date: Mon, 16 Oct 2023 10:41:22 +0200
Message-ID: <20231016084017.655795009@linuxfoundation.org>
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

commit a4b306eb83579c07b63dc65cd5bae53b7b4019d0 upstream.

Current implementation relies on curr_hwdesc index. But to keep this index
up to date, Block Transfer interrupt (BTIE) has to be enabled.
If it is not, curr_hwdesc is not updated, and then residue is not reliable.
Rely on Link Address Register instead. And disable BTIE interrupt
in stm32_mdma_setup_xfer() because it is no more needed in case of
_prep_slave_sg() to maintain curr_hwdesc up to date.
It avoids extra interrupts and also ensures a reliable residue. These
improvements are required for STM32 DCMI camera capture use case, which
need STM32 DMA and MDMA chaining for good performance.

Fixes: 696874322771 ("dmaengine: stm32-mdma: add support to be triggered by STM32 DMA")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231004163531.2864160-2-amelie.delaunay@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/stm32-mdma.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/dma/stm32-mdma.c
+++ b/drivers/dma/stm32-mdma.c
@@ -778,8 +778,6 @@ static int stm32_mdma_setup_xfer(struct
 	/* Enable interrupts */
 	ccr &= ~STM32_MDMA_CCR_IRQ_MASK;
 	ccr |= STM32_MDMA_CCR_TEIE | STM32_MDMA_CCR_CTCIE;
-	if (sg_len > 1)
-		ccr |= STM32_MDMA_CCR_BTIE;
 	desc->ccr = ccr;
 
 	return 0;
@@ -1325,12 +1323,21 @@ static size_t stm32_mdma_desc_residue(st
 {
 	struct stm32_mdma_device *dmadev = stm32_mdma_get_dev(chan);
 	struct stm32_mdma_hwdesc *hwdesc;
-	u32 cbndtr, residue, modulo, burst_size;
+	u32 cisr, clar, cbndtr, residue, modulo, burst_size;
 	int i;
 
+	cisr = stm32_mdma_read(dmadev, STM32_MDMA_CISR(chan->id));
+
 	residue = 0;
-	for (i = curr_hwdesc + 1; i < desc->count; i++) {
+	/* Get the next hw descriptor to process from current transfer */
+	clar = stm32_mdma_read(dmadev, STM32_MDMA_CLAR(chan->id));
+	for (i = desc->count - 1; i >= 0; i--) {
 		hwdesc = desc->node[i].hwdesc;
+
+		if (hwdesc->clar == clar)
+			break;/* Current transfer found, stop cumulating */
+
+		/* Cumulate residue of unprocessed hw descriptors */
 		residue += STM32_MDMA_CBNDTR_BNDT(hwdesc->cbndtr);
 	}
 	cbndtr = stm32_mdma_read(dmadev, STM32_MDMA_CBNDTR(chan->id));


