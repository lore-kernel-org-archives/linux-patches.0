Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308FC2F0673;
	Sat, 12 Sep 2026 19:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242309; cv=none; b=T8o/p1ObRx7q9wWo5ZL+5bK8VKeTaEvP7YHn/MyJzyUk67S+fFbYWf+HeL5DU5jTyE1HDF2CXT7k6MC04vy59yxwbM4WHYY+QQ2GkUs9MO5PKOSSC9DgnK5X6g7g7zm1rAt59vpxkZCIyT2MsxF+1N4afuyS80PRt2Ckz5jvILY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242309; c=relaxed/simple;
	bh=K9E5J8WHE4WNvnZ7Ygc13cAiGPXZyB2VNZv9WY+OUec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqS3IzZtOsAcsNTZ3a409G1jL20ot3ujzJAQxi6d+srkFopVllj49FCXmhVVyWwrkKaKT22pC7KqPR1yFGvk7oWEkY/uF+CMNbAwjYn5tMWgeb4PbTUo9yvybW2rhh+LHClgzx0HggQ+XFhTe+q3zEfNT2ivhod6cAbCOdP0s3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOCtPOgH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOCtPOgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934CA1F000FF;
	Sat, 12 Sep 2026 19:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242308;
	bh=KOAbwG3B6JussVjxhEB40zulv6xiFT/k2uuCfmwgcok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EOCtPOgH17nxzOUWe/dk9tBaoWzf8N0zsk6LPDFR/QdTrxr/8IbSKO6Y6RBvI867m
	 qFOjgU7dY5Yjpn2OqsoAo+f1HAiTnL9kzt+f8HMXKbMX/GpQ8Z+WMxaP8rdexzJDvt
	 e4sUIf3NX2+4lZ9E7/C3RY0e+bP9B8FchEJ+cKBE=
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
Subject: [PATCH 5.10 359/798] dmaengine: xilinx_dma: Fix channel idle state management in AXIDMA and MCDMA interrupt handlers
Date: Sat, 12 Sep 2026 08:59:47 +0200
Message-ID: <20260912065525.389391573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ff7fda42b5ca2..44d897f2b0f0b 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -1823,8 +1823,10 @@ static irqreturn_t xilinx_mcdma_irq_handler(int irq, void *data)
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
 
@@ -1880,8 +1882,10 @@ static irqreturn_t xilinx_dma_irq_handler(int irq, void *data)
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



