Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054837;
	b=cf9UQy3gOjGAO3HWFyf1cPQeL5SnXArV2woctcRt/yzdtWz+U8yn0997si6R+YElr/0I
	 cfhM5txEDD5LPFCFhjfTI/qnttYG/lfscFfRpgUz1oeQxoYzp29lQFjP7LKW1AIwGJY4G
	 /kmhjTqepkKXDidqAtsVYf+0LpnVLr4f9852ZRGcJCZ8pBnTi/csGNT/Va45+6AioVReE
	 QRvAqkkBtyknrocwrkSGKBVUVlMi2Ykg3XNYcQb27oDZmweX4mQR8lGnY+nQgj5eT5/K9
	 06gdO3z1QEzvpz531vuzJPZ1b8JToH9LgNqfLh2OwdxypqL3uIgIeoWveE+L/HLCI/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C7UicRgtmrdkCt+Y7QDFB0Cx8KE96113ZTxqdYJhVB4=;
	b=mVhSImbBhzoUax5761qwiiKEGAI2kj8Yh9mPJBcg4rWYagzj1Y8zb7W6SWyvAmCLJKqc
	 TBm2jJZxky1x1v3V29BVr/mubztk9Uqy0T48eR3mrHKsrdQUnMVrr7HF7yXiLhM45b+Ze
	 ni1JZ5QPaV9zklgY4+cMi8KuKNsYAn7+7tppAP1wmLQvKaXAE6t5Z52H4rLuIfwXLv4zf
	 M2jcklRbScLfSL/HQ1drfpCd2fCS78GZ6uDkTAEqfowABrc8UiCm0b5TZj9PxqxInPLOX
	 vL9IKhXNOYsOajzNTu5bWE3nutcH4cJqZtRp16lJVUqZ3JkVfeTUr2g8xFlVIdObXOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fo+4+o8E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE056606A325;
	Thu, 19 Nov 2026 02:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fo+4+o8E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A101F000C4;
	Thu, 19 Nov 2026 02:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054837;
	bh=C7UicRgtmrdkCt+Y7QDFB0Cx8KE96113ZTxqdYJhVB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fo+4+o8Efb/NLD0URKSg5E7z10Ug4N5xjzuVjnIbjrR9ijTcKRIIMD+V4yyiE8/QO
	 p+6PJPayKCoPWDzQN9D6PPKqVB1hF+aY7I1YRD2Z2Et6HwgvZxPXWRm8Z+59/7+EQ0
	 GA7hK1ED1aq1idtT19K9AeoXLuHxiYhz6Ti+cmmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1415/2214] dmaengine: xilinx_dma: Freeup active list based on descriptor completion bit
Date: Wed, 18 Nov 2026 15:51:31 +0100
Message-ID: <20261118150107.844869428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2c6c048797279..9ecf42b3b12d9 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -180,6 +180,7 @@
 #define XILINX_DMA_CR_DELAY_SHIFT	24
 #define XILINX_DMA_BD_SOP		BIT(27)
 #define XILINX_DMA_BD_EOP		BIT(26)
+#define XILINX_DMA_BD_COMP_MASK		BIT(31)
 #define XILINX_DMA_COALESCE_MAX		255
 #define XILINX_DMA_NUM_DESCS		255
 #define XILINX_DMA_NUM_APP_WORDS	5
@@ -1727,6 +1728,14 @@ static void xilinx_dma_complete_descriptor(struct xilinx_dma_chan *chan)
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



