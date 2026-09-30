Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CF64E36F1;
	Wed, 30 Sep 2026 18:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791937; cv=none; b=QFnR/cXqaRikdL/+Cwp0y1215B+shYN+YMad2tvf5fO8+tUntTN6aasvuJ+fX/EKrhqmDGcFlXumwmqXO5YP/YsbqqpXfhp6EyKCBzpOadDqq7kriZXsMmXo6HyI8pAw75zOrK2h6DKJAIUxMd/Ps96F70a2xWuvKUugJpnME/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791937; c=relaxed/simple;
	bh=wVWw7+DxhtmGPef7KH4uJKbYNwC21SWTPt1F6IYToxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZdVJrT8THCL3dR0gw5Av/Uxm7/hKiRMv4Bv+7b2WXgqeU4MEvEK5dUBTLspT+aGiltShfN61iAELF4So4r8CoRwyumIbaRjfKOuQAwoN4Lv0+E3fJSj3CAeLWXDR6/zO4AG1NjnLHOcPJp5W2o2Asvp4HQhpQw81Toq5N5WRmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOeAFcNx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOeAFcNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E75A1F000FF;
	Wed, 30 Sep 2026 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791936;
	bh=85NWjYU9ErV88FRleFkgcGs8SOGkUp9JSZkolsIEFm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zOeAFcNx/yr0t8D2HC5d6VbGzD5FaPt4WGQUtnwawhrqiPe1SZUqmhDiWOdzRp9T+
	 i7+VrzQ9g9WDeayrhNwaRQM962/NzpXiGrVyGIkVPFIjukziyyvQvkXGI9lOAMoRLq
	 fVFqLyjDBz9yQnMhSOJuHjKSW2iqZhb6v1uiSxLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bereza <alex@bereza.email>,
	Frank Li <Frank.Li@nxp.com>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 479/752] dmaengine: xilinx_dma: Fix hardware buffer descriptor reuse order
Date: Wed, 30 Sep 2026 17:25:49 +0200
Message-ID: <20260930152408.635944813@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 64bfada42e29a..d94b90bf2c239 100644
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



