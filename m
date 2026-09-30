Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616F93AFB11;
	Wed, 30 Sep 2026 16:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785947; cv=none; b=cVFtiwy1pUskzplRGj3ABBHCTnTFhTrDoL4p92Y6zn6pxtEpTqSXF4KHgrBIduza2uw2RLPaULu4oBsW6n9GKHSwVA4x3Crcha9ippZykEXXUbR0pqpqsskPoFUZqG1u2vM0gJB3NceyIr60ya8pOPbr1JV013PcGWp3Mr0TTGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785947; c=relaxed/simple;
	bh=xh0RRzuxQyMGmloDwiEBd5Ad9SxZXmaKDE5biQKSsNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ar65mA3xJdeke9ZzgGem2a0G8JYogdUV8tI03e8uyNy/U93hr9sD9W7bc4z/xgObp36EOBGsnqwHiFG+iuA0fj8HrFWlZaooSQDmlaqlk+U2TBeFaAZYuehyw49gvfT9N47I6v4n96OqyPSk5njop0tZ8UHVQFGKHpTtz+hpPRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuJhjdHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuJhjdHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9081F000FF;
	Wed, 30 Sep 2026 16:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785946;
	bh=iv8nnMMZGjgAO90e6NqJFrTr5xDFvnv86HrcspIuxbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EuJhjdHBSCmS3fdTMAransUABK/bUNc22Ou9kM2nJewmqLmJcTVg2MM0nuzyIQQI5
	 d/X81KEzCOizSh2GklMTTt4JS/UN7U3sDhlI4KxYzOO3aN5JgAHsyoAYc1sR4v5rta
	 4FQ93fy52LXM+mHG1LGez+zFtu44DGAw3N3r/3Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bereza <alex@bereza.email>,
	Frank Li <Frank.Li@nxp.com>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 643/982] dmaengine: xilinx_dma: Fix hardware buffer descriptor reuse order
Date: Wed, 30 Sep 2026 17:22:59 +0200
Message-ID: <20260930152430.577853774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 914399ba74935..53e791513b7e0 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -889,9 +889,9 @@ static void xilinx_dma_free_descriptors(struct xilinx_dma_chan *chan)
 
 	spin_lock_irqsave(&chan->lock, flags);
 
-	xilinx_dma_free_desc_list(chan, &chan->pending_list);
 	xilinx_dma_free_desc_list(chan, &chan->done_list);
 	xilinx_dma_free_desc_list(chan, &chan->active_list);
+	xilinx_dma_free_desc_list(chan, &chan->pending_list);
 
 	spin_unlock_irqrestore(&chan->lock, flags);
 }
-- 
2.53.0



