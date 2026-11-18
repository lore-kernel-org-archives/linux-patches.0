Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047973;
	b=eXWsun94lXQimrsKmN+A6ansD2eWXEfQZXXEOlLmhCWYFSSChAJnlp8EgkWrsQxdr2UY
	 WnRegy38DPuPhOuuBgTX8hJnAjK25MiSIjg7mLWilyhjI55k78bLlf9noh6Z3ZFwM54MV
	 5irjIQnB3dRA0YitnvQYdlpmDD88yt7cpPeFjnnGM6P4YYwAM6abJghvnfZoleamKUyoo
	 bh0/h0jc0NWg1o6ZQflhxzYp+rqMhS1IRcWParmIZlYgp4VGigCwwlN3pXJQeHA0PNuKA
	 PD6ynFZT1Fqc09cG80PomZ+GZa4lQHMgAZ9xdSOMOUWK9vHgxbSwsvsC0pUtyCg+DOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RmfOqp2XurDoG3jf+DPWXS6e2tnrP12/BMEE8LB2jXI=;
	b=xc8s8UW2ViCLV4XGvRVDAFr3s4z6KCO5ots25XUlhrqa/LX6StV/FondhZvU73jyRm0b
	 QbkJYcoh7WScMxp8+WBg8b5JTD/NL6xo7Usn7SpLeMimd00149o+JiHZ/XHep49IpktCY
	 OAow/Rp1OC+6FOE8y1/ZudPQH4yViqHGUNoITqurbkwLCwHlRWJzuM/WAvgJUkwZ+XERS
	 ivXc2HQ8XxUdFUEpVk5M20RCvIpHq002z23OBE2D9L5YU8mFtlTngp12mx2w/wEs/b0AE
	 Fr8GGraO7d85ZpPejupxDoCtZTy+zhNO6LktOq6skOYA/TB3TwYL3pGMAY7mYcMxNnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="A1K3Xy+/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D992606A32A;
	Thu, 19 Nov 2026 00:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1K3Xy+/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D40E1F000C4;
	Thu, 19 Nov 2026 00:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047973;
	bh=RmfOqp2XurDoG3jf+DPWXS6e2tnrP12/BMEE8LB2jXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1K3Xy+/s1Og6pWFRBeXuEbe0Kkeu8EpMrD/sErd5c+suiziLy6h4+SyvN//6QCN1
	 tS90ozfemmWZLDTtRXbZ33t6H1LFxN8J1385jIIzT2jj3zhZWhl3quuEe5tuksBAfq
	 2Y9F5VPfxkREsHjTcAUbFLkTy6s4b2a0s4V2vMu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1830/2857] dmaengine: xilinx_dma: Freeup active list based on descriptor completion bit
Date: Wed, 18 Nov 2026 15:47:44 +0100
Message-ID: <20261118150307.142669999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

[ Upstream commit 7bcdaa65810212c999d21e5c3019d03da37b3be3 ]

AXIDMA IP in SG mode sets completion bit to 1 when the transfer is
completed. Read this bit to move descriptor from active list to the
done list. This feature is needed when interrupt delay timeout and
IRQThreshold is enabled i.e Dly_IrqEn is triggered w/o completing
interrupt threshold.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://lore.kernel.org/r/1691387509-2113129-6-git-send-email-radhey.shyam.pandey@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 5b585cc87781 ("dmaengine: xilinx_dma: Move descriptors to done list based on completion bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index a2f4f94ee8144..fe1256a114612 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -182,6 +182,7 @@
 #define XILINX_DMA_CR_DELAY_SHIFT	24
 #define XILINX_DMA_BD_SOP		BIT(27)
 #define XILINX_DMA_BD_EOP		BIT(26)
+#define XILINX_DMA_BD_COMP_MASK		BIT(31)
 #define XILINX_DMA_COALESCE_MAX		255
 #define XILINX_DMA_NUM_DESCS		255
 #define XILINX_DMA_NUM_APP_WORDS	5
@@ -1730,6 +1731,14 @@ static void xilinx_dma_complete_descriptor(struct xilinx_dma_chan *chan)
 		return;
 
 	list_for_each_entry_safe(desc, next, &chan->active_list, node) {
+		if (chan->xdev->dma_config->dmatype == XDMA_TYPE_AXIDMA) {
+			struct xilinx_axidma_tx_segment *seg;
+
+			seg = list_last_entry(&desc->segments,
+					      struct xilinx_axidma_tx_segment, node);
+			if (!(seg->hw.status & XILINX_DMA_BD_COMP_MASK) && chan->has_sg)
+				break;
+		}
 		if (chan->has_sg && chan->xdev->dma_config->dmatype !=
 		    XDMA_TYPE_VDMA)
 			desc->residue = xilinx_dma_get_residue(chan, desc);
-- 
2.53.0



