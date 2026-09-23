Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C98E3A380F;
	Wed, 23 Sep 2026 14:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174346; cv=none; b=ir+e8vKp5vEBKGH3rx2c+S7LQyHoRb3lyFKNuLvCUAIwqgLZc+7j6H+koALopskkeGubB+xXrttpSCWINT9R7Kiyeq4tIqFguwgwe31QgP002O1hkONFkNeUMTs5X4LE4q5AAktlclG6uQFWrIqaVIH6IzuZz1VINXz745OMY5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174346; c=relaxed/simple;
	bh=127fP2vZrU3wosw59lef90vvKRLVxOf0NcGroEtJ0C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UywQFIpNsDfF3Gdt59lz96Mh6946KXtW/8yIgYUWsI0OaZ8w3JOSCRDRH37Gn4MYLOXIgtmXKJcsJkBR+XX0yvTWvm1XETgA+bVVT42f6Mv84MDTwVBaxEb6HtmGORCjgpmessO+Q79to6r0XLSsKk+Z3kADGfnDow3X25nf1OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6TFYjYA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6TFYjYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76361F000FF;
	Wed, 23 Sep 2026 14:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174345;
	bh=42+EJTBYLxMef8OWpR3ifMG0buXb2MUIhF0dQbSAEvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6TFYjYAg8jc55XspJ1gBEQ97ie/p2M+4NK8ynEQWIiC49Gz/j/WslHEC/09tOAVq
	 5oUwWSMUnS3xM586trWSlh7XDi6MYo0hIxGHwTn2+KuB1biF2uLS51rtITUrInLXeY
	 /9pYmIPmcCEgJkzsDZT7I4SE50lSS6bLZjGaw1Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bereza <alex@bereza.email>,
	Frank Li <Frank.Li@nxp.com>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/398] dmaengine: xilinx_dma: Fix hardware buffer descriptor reuse order
Date: Wed, 23 Sep 2026 16:02:39 +0200
Message-ID: <20260923140645.639533304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Bereza <alex@bereza.email>

[ Upstream commit cee9c863ee68cb27d66745eb03f60e357f4f8ad2 ]

xilinx_dma_alloc_chan_resources() builds a static ring of hardware
buffer descriptors once and the driver uses this ring throughout the
lifetime of a channel. This requires the allocation order of hardware
buffer descriptors from chan->free_seg_list to stay in sync with the
hardware buffer descriptor ring built at channel allocation time by
returning oldest descriptors to chan->free_seg_list first.

When chan->pending_list is not empty e.g. during
xilinx_dma_terminate_all() the chan->free_seg_list and the order of the
static hardware buffer descriptor ring get out of sync. Descriptors age
in this order: pending -> active -> done. So freeing pending_list first
returns the newest buffer descriptors to the chan->free_seg_list first
and thus breaks the order required by the static hardware buffer
descriptor ring. Then when the channel is reused, after a wrap around of
the free_seg_list the DMA will find a hardware buffer descriptor with a
length field that is still zeroed and stop with something like this:

  xilinx-vdma 86000000.dma: Channel 000000003a21d7b8 has errors 10, cdr 6de4c000 tdr 6de4c000

After this no more descriptors are completed and a consumer potentially
blocks and waits forever. The only way to get out of this error state is
to rebuild the static hardware buffer descriptor ring and the
free_seg_list by releasing and re-acquiring the channel.

Fix the order in which hardware buffer descriptors are returned to
free_seg_list to ensure the mentioned requirement holds.

Fixes: 23059408b6a3 ("dmaengine: xilinx_dma: Fix race condition in the driver for multiple descriptor scenario")
Signed-off-by: Alex Bereza <alex@bereza.email>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Suraj Gupta <suraj.gupta2@amd.com>
Link: https://patch.msgid.link/20260817-fix-hw-buf-desc-reuse-v1-1-d79827a844c7@bereza.email
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 30e3db94ddf07..4ccf519d39610 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -918,9 +918,9 @@ static void xilinx_dma_free_descriptors(struct xilinx_dma_chan *chan)
 
 	spin_lock_irqsave(&chan->lock, flags);
 
-	xilinx_dma_free_desc_list(chan, &chan->pending_list);
 	xilinx_dma_free_desc_list(chan, &chan->done_list);
 	xilinx_dma_free_desc_list(chan, &chan->active_list);
+	xilinx_dma_free_desc_list(chan, &chan->pending_list);
 
 	spin_unlock_irqrestore(&chan->lock, flags);
 }
-- 
2.53.0



