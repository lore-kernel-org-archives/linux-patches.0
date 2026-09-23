Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D045953FD28;
	Wed, 23 Sep 2026 14:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174833; cv=none; b=odAremgjNJOoEt45aCAE5guRlsQT8HYBB/Ngr5CgKJCYw2D3L4amyyM3DiG952pJbaXpYl5qHe2yxR7237/mKDO+JQMqHF2SudnsQnaMT8Dma5enWGhWRPgTFGFhpjO/8hGSlEorFFdZQ7sATvZD8JtS7Gxy3G02aSzQJ1Fshz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174833; c=relaxed/simple;
	bh=ggTvn1TjTB6eLRHP/uuy3BFoI/Xae+ER+ZSad4GX2GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2i1x4svT1jKf3wwW+urE7ijMWmjZij5FmPoMMa8+130sG+hNRFGwxygs1nNp0YOPNYuYiaNFJqENcpe4NdNyAlrCUrHEtDsQWxHgD8I4EETxsRvH2M/vzrA0TkHMue/bOoIM0NEl2B2vKMOk1FgfFIhPYijjRbvUEAZCH5o0To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypfhDMCY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypfhDMCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060DD1F000FF;
	Wed, 23 Sep 2026 14:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174831;
	bh=ynd4MDrV8H4WKfk0dkkoMs69x4c8gGVqpdXqOyX4nGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypfhDMCYOLXWN72EzfPc0bYKDT2hho6SOAPre29v+3+smvSP1Y+NIczhfQ7xZkVUS
	 MDKEU4uHVLL/hZyXDufZKCEE1X3myF70fz28zzABnU58wi55x0mEusadI32Z5H18hr
	 C8wytqesyz/CCxofDVrqc9R9eOx+Ysd5PXAfJ85k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Lugnberg <christian.lugnberg@soundtrack.io>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 239/398] dmaengine: sun6i: fix non-atomic read of DMA position registers
Date: Wed, 23 Sep 2026 16:05:13 +0200
Message-ID: <20260923140649.614199507@linuxfoundation.org>
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

From: Christian Lugnberg <christian.lugnberg@soundtrack.io>

commit c90b6973daa37f4c283342dff881ae001dea4fe6 upstream.

sun6i_get_chan_size() reads DMA_CHAN_LLI_ADDR and DMA_CHAN_CUR_CNT in two
separate readl() calls with no synchronisation between them:

    pos   = readl(pchan->base + DMA_CHAN_LLI_ADDR);
    bytes = readl(pchan->base + DMA_CHAN_CUR_CNT);

DMA_CHAN_LLI_ADDR holds the physical address of the *next* descriptor the
engine will load once the current one completes. DMA_CHAN_CUR_CNT holds the
remaining byte count for the *current* descriptor. If the DMA engine
advances to the next LLI entry between the two reads, pos becomes stale: it
still points to what was the next descriptor at the time of the first read,
but that descriptor is now the current one and CUR_CNT reflects its initial
(full) byte count. The subsequent virtual-chain walk starts one entry too
early and accumulates an extra full period's worth of bytes into the
residue estimate.

Fix this by re-reading DMA_CHAN_LLI_ADDR after DMA_CHAN_CUR_CNT and
retrying if the value changed. This double-read pattern guarantees that
both registers were sampled during the same descriptor interval. The cost
is at most one extra readl() pair per call in the racy case, which occurs
only at descriptor boundaries (~every 2 ms) and is negligible.

Fixes: a90e173f3faf ("dmaengine: sun6i: Add cyclic capability")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Christian Lugnberg <christian.lugnberg@soundtrack.io>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260817135723.12807-2-christian.lugnberg@soundtrack.io
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/sun6i-dma.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -354,8 +354,10 @@ static size_t sun6i_get_chan_size(struct
 	size_t bytes;
 	dma_addr_t pos;
 
-	pos = readl(pchan->base + DMA_CHAN_LLI_ADDR);
-	bytes = readl(pchan->base + DMA_CHAN_CUR_CNT);
+	do {
+		pos = readl(pchan->base + DMA_CHAN_LLI_ADDR);
+		bytes = readl(pchan->base + DMA_CHAN_CUR_CNT);
+	} while (pos != readl(pchan->base + DMA_CHAN_LLI_ADDR));
 
 	if (pos == LLI_LAST_ITEM)
 		return bytes;


