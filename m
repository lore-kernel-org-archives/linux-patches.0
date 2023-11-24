Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5A833CC2;
	Fri, 24 Nov 2023 18:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgqgfaBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F354C433C8;
	Fri, 24 Nov 2023 18:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852236;
	bh=ZVYkXEN+I7U42BYSdp6Kqv9fk43iAFaCGZ0sLNMh7kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgqgfaBsUZwRYaht3fS8UK8gaBa1GPc189afD5/A2pT1Z5xaAng2W/kXRNou6+uqo
	 iRSB/2hWkfd2dYEKrKvF1gfiKBUvDsSMNqfh0Ue2j4YhUdwL31aSvke6o8PWUpm3Sw
	 54+a2NRqv9njXfjbAyHcb45DOaGhMN3SpDVvWdkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 250/372] dmaengine: stm32-mdma: correct desc prep when channel running
Date: Fri, 24 Nov 2023 17:50:37 +0000
Message-ID: <20231124172018.866436953@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

From: Alain Volmat <alain.volmat@foss.st.com>

commit 03f25d53b145bc2f7ccc82fc04e4482ed734f524 upstream.

In case of the prep descriptor while the channel is already running, the
CCR register value stored into the channel could already have its EN bit
set.  This would lead to a bad transfer since, at start transfer time,
enabling the channel while other registers aren't yet properly set.
To avoid this, ensure to mask the CCR_EN bit when storing the ccr value
into the mdma channel structure.

Fixes: a4ffb13c8946 ("dmaengine: Add STM32 MDMA driver")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Cc: stable@vger.kernel.org
Tested-by: Alain Volmat <alain.volmat@foss.st.com>
Link: https://lore.kernel.org/r/20231009082450.452877-1-amelie.delaunay@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/stm32-mdma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma/stm32-mdma.c
+++ b/drivers/dma/stm32-mdma.c
@@ -490,7 +490,7 @@ static int stm32_mdma_set_xfer_param(str
 	src_maxburst = chan->dma_config.src_maxburst;
 	dst_maxburst = chan->dma_config.dst_maxburst;
 
-	ccr = stm32_mdma_read(dmadev, STM32_MDMA_CCR(chan->id));
+	ccr = stm32_mdma_read(dmadev, STM32_MDMA_CCR(chan->id)) & ~STM32_MDMA_CCR_EN;
 	ctcr = stm32_mdma_read(dmadev, STM32_MDMA_CTCR(chan->id));
 	ctbr = stm32_mdma_read(dmadev, STM32_MDMA_CTBR(chan->id));
 
@@ -966,7 +966,7 @@ stm32_mdma_prep_dma_memcpy(struct dma_ch
 	if (!desc)
 		return NULL;
 
-	ccr = stm32_mdma_read(dmadev, STM32_MDMA_CCR(chan->id));
+	ccr = stm32_mdma_read(dmadev, STM32_MDMA_CCR(chan->id)) & ~STM32_MDMA_CCR_EN;
 	ctcr = stm32_mdma_read(dmadev, STM32_MDMA_CTCR(chan->id));
 	ctbr = stm32_mdma_read(dmadev, STM32_MDMA_CTBR(chan->id));
 	cbndtr = stm32_mdma_read(dmadev, STM32_MDMA_CBNDTR(chan->id));


