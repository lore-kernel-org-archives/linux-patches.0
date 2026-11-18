Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018642;
	b=RxQXL5JmiJKQryRdufdboL57zm/WXoT7c7Wdp504za5+f1eHYrrtyI4hhTi38mJtl6g1
	 /3Tz5bLOeHV8t8cMIEFfrzuiNDRUpuBmGBEiX3wdlY4Y0yJwvh55OJyY0WACBAi+1d18+
	 jWCizKbMRVdjEZLZOkS7IEYRW8H4AAPk+eq+0n4J6mcOodsIGy1vYfwaiW2jim+4p5XEu
	 6H+BoOeS2mCcfttrvhGR2W9fRVNrcFWyJffEYBMi5MVNGWjvl+rtUDpIK0/XMoqWenMdA
	 x27IdyRPVPvqSqyONVOxdOpB4oTFqRqfvatdsvkI+HeGLhRmssXeXrxK3sg40ZN8wlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ENfOZ6HTZ3TS2AAoTovbo3JKSTEX8uEin/kFfWXPuM8=;
	b=DUpqd+LDCci0cNDhZKUrIlt/z5bGjxGGGEwJ6tjEC2yC+wcwH1qjf2wIVb9U9VKr5aFn
	 jqXyS6IjT3niHHfNVDZjGGe+e5DW+uDAg3h1kTThMvq1SKv6nw0ksYhyi2otBLfaQKk01
	 OSzBmjOnylM4iRm6QLzjqmjjAk4GSROy0+6ms4HNbJfHFVOmxt1xOwHUIXPJKbpnRm1FO
	 Nmc/fqsU5455NDPR2IWoptXN/PTHyafaG4VXd/13oSeh7W9kTQa4V8pcNmzA+2hClK0lf
	 fgh1utjptDjyJdAbatsV51HB+2NdI06uYoB3IVmPbVqVQPlldSeA1aOYk8XCdjmk7cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=azzb9UtW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0E5606A320;
	Wed, 18 Nov 2026 16:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=azzb9UtW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CA41F000C7;
	Wed, 18 Nov 2026 16:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018642;
	bh=ENfOZ6HTZ3TS2AAoTovbo3JKSTEX8uEin/kFfWXPuM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=azzb9UtWuQZE3R3oB/IeEEXabb+DYYdox8I7eraKGjUmsveTioiXX81METtQ58XTs
	 YaWC4NLzYIGp6OP1YY2bGluuHMVnKysS7yyfuxzAmn6Sf4TbdI5wXNRyhvs8LaoUth
	 4QRsuVoTOvBKfb3waQ5VWDTe2a9JRIYoOSs++qJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1314/2651] dmaengine: switchtec-dma: fix double-free in switchtec_dma_free_desc()
Date: Wed, 18 Nov 2026 15:42:34 +0100
Message-ID: <20261118150335.274507373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit bdfd76514bd11301f4e67d150485ab696c26d83d ]

switchtec_dma_free_desc() frees swdma_chan->hw_sq, hw_cq, and every
desc_ring[] entry without clearing the pointers afterward. If
switchtec_dma_alloc_chan_resources() fails partway through and calls
it during unwind, then a later retry of alloc_chan_resources() fails
in switchtec_dma_alloc_desc() before reallocating one of those
pointers, its own failure path calls switchtec_dma_free_desc() again
and frees the same, already-freed pointers a second time.

NULL out each pointer as it's freed so a subsequent call is a no-op
for anything already released.

Fixes: 30eba9df76ad ("dmaengine: switchtec-dma: Implement hardware initialization and cleanup")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Link: https://patch.msgid.link/20260902062153.31048-2-logang@deltatee.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/switchtec_dma.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/switchtec_dma.c b/drivers/dma/switchtec_dma.c
index c8e2169877e92..9eb8a49beda33 100644
--- a/drivers/dma/switchtec_dma.c
+++ b/drivers/dma/switchtec_dma.c
@@ -886,14 +886,18 @@ static void switchtec_dma_free_desc(struct switchtec_dma_chan *swdma_chan)
 	if (swdma_chan->hw_sq)
 		dma_free_coherent(swdma_dev->dma_dev.dev, size,
 				  swdma_chan->hw_sq, swdma_chan->dma_addr_sq);
+	swdma_chan->hw_sq = NULL;
 
 	size = SWITCHTEC_DMA_CQ_SIZE * sizeof(*swdma_chan->hw_cq);
 	if (swdma_chan->hw_cq)
 		dma_free_coherent(swdma_dev->dma_dev.dev, size,
 				  swdma_chan->hw_cq, swdma_chan->dma_addr_cq);
+	swdma_chan->hw_cq = NULL;
 
-	for (i = 0; i < SWITCHTEC_DMA_RING_SIZE; i++)
+	for (i = 0; i < SWITCHTEC_DMA_RING_SIZE; i++) {
 		kfree(swdma_chan->desc_ring[i]);
+		swdma_chan->desc_ring[i] = NULL;
+	}
 }
 
 static int switchtec_dma_alloc_desc(struct switchtec_dma_chan *swdma_chan)
-- 
2.53.0



