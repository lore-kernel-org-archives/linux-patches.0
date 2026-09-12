Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BDD3D3339;
	Sat, 12 Sep 2026 07:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197365; cv=none; b=rXH+jTN89PbGWANL9mLMfFQunRRE8HKtwjc/ybN2IVMmjueTH/cxp+F/ifwYQRTF8Ye+6Ls8qjlwNqIlHgRbBZx2aAL5ebLSZCApFx1zkc06hwDQQV1REfR56qe0nPLnyxzwbkH+l2fmuFryWHEVemis8UcbixQhnIOt2KNP0IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197365; c=relaxed/simple;
	bh=1b7UVdJD31brUEFQ+fzBOvrY+S2fi+mQYG4XarAEm1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htNVvhxPCLf5Y3o/4bX1QGPS6sFVit0OE6bgWWUCCVy+zlTh1h4JyqzKnPX1UJ3OJTAo8linFOSZ9ilYtzFRi2T4imoualrEjtS0P7Y+cbEiYbJFr0ScjTFv4RsibvA7tVYVN2397XFBxP5+uQXn6RXZHPgzcf385BHIbec6qio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o3a0e9Ln; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o3a0e9Ln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7111F000FF;
	Sat, 12 Sep 2026 07:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197363;
	bh=38jojGNL5mLfJLpgK6+jHmrIuSCEm3nWNsbDTmu2zDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o3a0e9Lndct0kFBOwJmrfRekPkBx6M793FRMmd02jnenXo2jRTfU8s+Ks8fCk2eeU
	 ltvvs0oSbqcmVBlgmHwAv94ir2m36sL7kZGdZbslyUVOWXCLPcEWxwO0qnhfVA6c0l
	 EsXs2vUq7MfRQ72V6hZA/WBgtUHzE7wUMvvpffRo=
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
Subject: [PATCH 7.2 0159/1815] dmaengine: xilinx_dma: Fix channel idle state management in AXIDMA and MCDMA interrupt handlers
Date: Sat, 12 Sep 2026 08:31:49 +0200
Message-ID: <20260912065652.744024959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 404235c173538..ca396b7097427 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -1893,8 +1893,10 @@ static irqreturn_t xilinx_mcdma_irq_handler(int irq, void *data)
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
 
@@ -1950,8 +1952,10 @@ static irqreturn_t xilinx_dma_irq_handler(int irq, void *data)
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



