Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D76118634
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCxq0IRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73BAC433C8;
	Mon, 16 Oct 2023 09:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446920;
	bh=C05dGbU4YkjewGXgds54XisJtOCaclPoQhJo42w4rOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCxq0IRKmwcd/F+TmsrDYXm92cI0vbsUBVfW0g2D/onIQx5HES00330YiejUpI/9n
	 LqrAKZzmsCuTh9UmcyV3uWkgMqwaHvFAAN7r7EEvda1DHXkWN1XZs37esG5PtYOhfN
	 OIGJJK0MCQ2yPKx7VMIfDMaDFHBa1wrkM9Z27Di4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 069/131] dmaengine: stm32-dma: fix stm32_dma_prep_slave_sg in case of MDMA chaining
Date: Mon, 16 Oct 2023 10:40:52 +0200
Message-ID: <20231016084001.780406628@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

commit 2df467e908ce463cff1431ca1b00f650f7a514b4 upstream.

Current Target (CT) have to be reset when starting an MDMA chaining use
case, as Double Buffer mode is activated. It ensures the DMA will start
processing the first memory target (pointed with SxM0AR).

Fixes: 723795173ce1 ("dmaengine: stm32-dma: add support to trigger STM32 MDMA")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231004155024.2609531-1-amelie.delaunay@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/stm32-dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/stm32-dma.c b/drivers/dma/stm32-dma.c
index 5c36811aa134..7427acc82259 100644
--- a/drivers/dma/stm32-dma.c
+++ b/drivers/dma/stm32-dma.c
@@ -1113,8 +1113,10 @@ static struct dma_async_tx_descriptor *stm32_dma_prep_slave_sg(
 		chan->chan_reg.dma_scr &= ~STM32_DMA_SCR_PFCTRL;
 
 	/* Activate Double Buffer Mode if DMA triggers STM32 MDMA and more than 1 sg */
-	if (chan->trig_mdma && sg_len > 1)
+	if (chan->trig_mdma && sg_len > 1) {
 		chan->chan_reg.dma_scr |= STM32_DMA_SCR_DBM;
+		chan->chan_reg.dma_scr &= ~STM32_DMA_SCR_CT;
+	}
 
 	for_each_sg(sgl, sg, sg_len, i) {
 		ret = stm32_dma_set_xfer_param(chan, direction, &buswidth,
-- 
2.42.0



