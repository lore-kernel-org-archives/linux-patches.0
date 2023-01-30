Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F5128EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9AFC433EF;
	Mon, 30 Jan 2023 13:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086869;
	bh=nv738NQUZKt+xcw5QB+k7adWDJc3RB2UF6FCxLl4TN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OglQXMTnk4ktgfYklgYvDzgO7Zmoh2WF1OrSKTyFdnbFb5Akncxkt1bWXMmQvlZJG
	 0csxGvwuuHMIpfLm/OtLGJGgNdZnbp7rCx0O/IFcDfYFxtW+PNO7bmTP0ApqLalix1
	 MlyxUecE73luG6RGgl19XxD17nbkmXy/1OLDMy0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/313] dmaengine: ti: k3-udma: Do conditional decrement of UDMA_CHAN_RT_PEER_BCNT_REG
Date: Mon, 30 Jan 2023 14:47:21 +0100
Message-Id: <20230130134336.943233483@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit efab25894a41a920d9581183741e7fadba00719c ]

PSIL_EP_NATIVE endpoints may not have PEER registers for BCNT and thus
udma_decrement_byte_counters() should not try to decrement these counters.
This fixes the issue of crypto IPERF testing where the client side (EVM)
hangs without transfer of packets to the server side, seen since this
function was added.

Fixes: 7c94dcfa8fcf ("dmaengine: ti: k3-udma: Reset UDMA_CHAN_RT byte counters to prevent overflow")
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20221128085005.489964-1-j-choudhary@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 7b5081989b3d..b86b809eb1f7 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -761,11 +761,12 @@ static void udma_decrement_byte_counters(struct udma_chan *uc, u32 val)
 	if (uc->desc->dir == DMA_DEV_TO_MEM) {
 		udma_rchanrt_write(uc, UDMA_CHAN_RT_BCNT_REG, val);
 		udma_rchanrt_write(uc, UDMA_CHAN_RT_SBCNT_REG, val);
-		udma_rchanrt_write(uc, UDMA_CHAN_RT_PEER_BCNT_REG, val);
+		if (uc->config.ep_type != PSIL_EP_NATIVE)
+			udma_rchanrt_write(uc, UDMA_CHAN_RT_PEER_BCNT_REG, val);
 	} else {
 		udma_tchanrt_write(uc, UDMA_CHAN_RT_BCNT_REG, val);
 		udma_tchanrt_write(uc, UDMA_CHAN_RT_SBCNT_REG, val);
-		if (!uc->bchan)
+		if (!uc->bchan && uc->config.ep_type != PSIL_EP_NATIVE)
 			udma_tchanrt_write(uc, UDMA_CHAN_RT_PEER_BCNT_REG, val);
 	}
 }
-- 
2.39.0



