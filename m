Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7C430C617;
	Sat, 12 Sep 2026 14:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222629; cv=none; b=DKvXCnZnpmhfukUy+aDeUfRavJhF67NjQfE1GuDQ4vZz9BnkTKmBNIaQbIkPpUzW5qalWexSeADhBAjsncf4MW9dVWRfFD6n8QG+sQ6DSIBoRKTh6J6k8nkojrlisU+Nj3SbdJq4+rZZzkHUgI5Z0XhfSxVmOVPgO+8A+isHObM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222629; c=relaxed/simple;
	bh=T81xufGvrMgubpHkfznyu+dYIKPMyO7CKdgu+goIEjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIECWZdqfsVsnXyX4EfsyHzPeedLRU7N6jrIzpLgf0PMXgwe7ylrp/eXRfAFWrsp/izNPww2Lo2ho8Du8JSIxrY1PNmzVTfXSCD80fy/zcYgH1cZRqwGiewkg16iumBLiA9/g9yijqs72SWGBhMOFuCU/O6QLOWXTA+BlOQAiDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzMLeSLo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzMLeSLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D2E1F000FF;
	Sat, 12 Sep 2026 14:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222627;
	bh=iC90yqkwc3QADD5heXgacYH8jllndt0Iozeo+46WqSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzMLeSLoRgK+FANcotE0E477F6oLTSY2c5tyrFlsZ2mx0ByQgd0sUc6ItfUkV7wAc
	 fZ/yaVUy8cSz8CGM5uylmT4I4RRlRyKyTAhidSR2gTSqqmfs2/BFm8FQDsd8PiF9yH
	 ykeMvTKARqa8CHlmrjvKcdwXn1h5F29NzYzVPqKg=
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
Subject: [PATCH 6.6 0623/1424] dmaengine: xilinx_dma: Fix channel idle state management in AXIDMA and MCDMA interrupt handlers
Date: Sat, 12 Sep 2026 08:50:55 +0200
Message-ID: <20260912065621.242902458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3d728dd1ecde1..2c5a85259eb79 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -1867,8 +1867,10 @@ static irqreturn_t xilinx_mcdma_irq_handler(int irq, void *data)
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
 
@@ -1924,8 +1926,10 @@ static irqreturn_t xilinx_dma_irq_handler(int irq, void *data)
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



