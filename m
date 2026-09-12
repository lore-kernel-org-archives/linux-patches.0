Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CFE3AEF51;
	Sat, 12 Sep 2026 12:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214731; cv=none; b=O8wuav5/i+jSfA2R/3YH25a5mA0cRH9oCYQhagkT1gr2fXe6gDtvIVBnYItMUR5vGrRrmpVLko5dnB0z/GSSmBxhX8kYPuyx1RoOpvq5DpOiOug+FDJGjrhi+7iSgleB1GGsw8Fw8GwMF9uyHM1y6eBKLKzGjE4cZfkGPvvmWAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214731; c=relaxed/simple;
	bh=xP7O/s2CjysFY81kBGbRShKXOiesKG/WCyy3s+MMeX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlpU5LOnaEHY6RAtwrSNRtCo6wLFSZjOdISg6s9jnQHU8qUSoeOUNdpbL17k8gc2rRD0lqs5g4IzMji+RFgmfB6uCAJ2JGzKLUjiBQNDANmH/c7ssul3P4bzWhLNr9f4tC4knlwutJk9312IKlNPhy10r5LWpcvFLbZHUGo4VXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIlvzPA0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIlvzPA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56591F000FF;
	Sat, 12 Sep 2026 12:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214729;
	bh=5vfIM5tagbo/C5sK1hPp9AJWx2KjHYyvWRrEudoDAwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KIlvzPA0q4/4qwYzhYmjz0XgC5hEj0VDi/NvUYbXyMcZKS3/JyRMvMVtxVtRfNZVz
	 0NWxKduP5dBJA6oMOkVnDJZhzX1dDK3HCEnNuATG/ai+O0TlxkMbG45y1uWkzqgo1F
	 1396jVeTQJEVuvoHP1aYCbaY6Ozo2NHD+41oyhjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Folker Schwesinger <dev@folker-schwesinger.de>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Srinivas Neeli <srinivas.neeli@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0387/1376] dmaengine: xilinx_dma: Fix channel idle state management in AXIDMA and MCDMA interrupt handlers
Date: Sat, 12 Sep 2026 08:46:53 +0200
Message-ID: <20260912065616.172256926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Gupta <suraj.gupta2@amd.com>

[ Upstream commit 0b6d055edb55ecadadf54e930c2b4fab76fa9a5a ]

Fix a race condition in AXIDMA and MCDMA irq handlers where the channel
could be incorrectly marked as idle and attempt spurious transfers when
descriptors are still being processed.

The issue occurs when:
1. Multiple descriptors are queued and active.
2. An interrupt fires after completing some descriptors.
3. xilinx_dma_complete_descriptor() moves completed descriptors to
done_list.
4. Channel is marked idle and start_transfer() is called even though
   active_list still contains unprocessed descriptors.
5. This leads to premature transfer attempts and potential descriptor
   corruption or missed completions.

Only mark the channel as idle and start new transfers when the active list
is actually empty, ensuring proper channel state management and avoiding
spurious transfer attempts.

Fixes: c0bba3a99f07 ("dmaengine: vdma: Add Support for Xilinx AXI Direct Memory Access Engine")
Tested-by: Folker Schwesinger <dev@folker-schwesinger.de>
Signed-off-by: Suraj Gupta <suraj.gupta2@amd.com>
Co-developed-by: Srinivas Neeli <srinivas.neeli@amd.com>
Signed-off-by: Srinivas Neeli <srinivas.neeli@amd.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20260626092656.1563871-2-suraj.gupta2@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index a0361bcee1201..bea55dc99673b 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -1869,8 +1869,10 @@ static irqreturn_t xilinx_mcdma_irq_handler(int irq, void *data)
 	if (status & XILINX_MCDMA_IRQ_IOC_MASK) {
 		spin_lock(&chan->lock);
 		xilinx_dma_complete_descriptor(chan);
-		chan->idle = true;
-		chan->start_transfer(chan);
+		if (list_empty(&chan->active_list)) {
+			chan->idle = true;
+			chan->start_transfer(chan);
+		}
 		spin_unlock(&chan->lock);
 	}
 
@@ -1926,8 +1928,10 @@ static irqreturn_t xilinx_dma_irq_handler(int irq, void *data)
 		      XILINX_DMA_DMASR_DLY_CNT_IRQ)) {
 		spin_lock(&chan->lock);
 		xilinx_dma_complete_descriptor(chan);
-		chan->idle = true;
-		chan->start_transfer(chan);
+		if (list_empty(&chan->active_list)) {
+			chan->idle = true;
+			chan->start_transfer(chan);
+		}
 		spin_unlock(&chan->lock);
 	}
 
-- 
2.53.0



