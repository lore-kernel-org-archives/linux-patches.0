Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8682E1465A8;
	Tue, 25 Jun 2024 09:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309013; cv=none; b=MH3I+8Ter3hrUEVR6tIC9WvFDWEhAgUi/HYyhzq1wXRG1LhHCNBpLgTBqklcjZ13+528iypKDvYnNvE/mJq1BSeZLflrHOI5b9CW8tqjEmwjHzgizFyV8cJeXst2Pt4LqV4/lilbc/rOISp6CHgduyOPmgJXlyEbF2wh1E94W9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309013; c=relaxed/simple;
	bh=7BO7G1nYK9Bpa18lPTx66xSHqf5OFDvE5WjdK8xlLOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJI8T9/flEKIxArMlunXa3M3e3HAqg4P3pGMrSQC0bo50+BB3yNVlUECsmw2F763Do7QKJSJspLwo9/Wqxf9vx2Iijy9sCx3ryslbDc2lCUDfm+Ho58iu2PuNWruf1TW2AbG+xmkKLisc7VTZGUzvm5fqcKw1+yMPvi7F8V8cEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZFddfhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZFddfhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C42DC32781;
	Tue, 25 Jun 2024 09:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309013;
	bh=7BO7G1nYK9Bpa18lPTx66xSHqf5OFDvE5WjdK8xlLOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZFddfhKP+BDQGCHaCYzsf+x294/+VlRWUWEk7mS5QgZlcV3eCNDebWqy+Bg1Fq15
	 SGUR63ThSBqN8E0iD1sYwxOjj6R9OvfPJ2R2b8X5YGD8BA/wWuqJBALaerWLBasf3B
	 6dcAckXTfCpTX0R5XI4Pc0nHp5LNxvokRDClwNzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Pinto <jpinto@synopsys.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/192] Avoid hw_desc array overrun in dw-axi-dmac
Date: Tue, 25 Jun 2024 11:32:00 +0200
Message-ID: <20240625085539.013849654@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Joao Pinto <Joao.Pinto@synopsys.com>

[ Upstream commit 333e11bf47fa8d477db90e2900b1ed3c9ae9b697 ]

I have a use case where nr_buffers = 3 and in which each descriptor is composed by 3
segments, resulting in the DMA channel descs_allocated to be 9. Since axi_desc_put()
handles the hw_desc considering the descs_allocated, this scenario would result in a
kernel panic (hw_desc array will be overrun).

To fix this, the proposal is to add a new member to the axi_dma_desc structure,
where we keep the number of allocated hw_descs (axi_desc_alloc()) and use it in
axi_desc_put() to handle the hw_desc array correctly.

Additionally I propose to remove the axi_chan_start_first_queued() call after completing
the transfer, since it was identified that unbalance can occur (started descriptors can
be interrupted and transfer ignored due to DMA channel not being enabled).

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
Link: https://lore.kernel.org/r/1711536564-12919-1-git-send-email-jpinto@synopsys.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 6 ++----
 drivers/dma/dw-axi-dmac/dw-axi-dmac.h          | 1 +
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index dd02f84e404d0..72fb40de58b3f 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -256,6 +256,7 @@ static struct axi_dma_desc *axi_desc_alloc(u32 num)
 		kfree(desc);
 		return NULL;
 	}
+	desc->nr_hw_descs = num;
 
 	return desc;
 }
@@ -282,7 +283,7 @@ static struct axi_dma_lli *axi_desc_get(struct axi_dma_chan *chan,
 static void axi_desc_put(struct axi_dma_desc *desc)
 {
 	struct axi_dma_chan *chan = desc->chan;
-	int count = atomic_read(&chan->descs_allocated);
+	int count = desc->nr_hw_descs;
 	struct axi_dma_hw_desc *hw_desc;
 	int descs_put;
 
@@ -1093,9 +1094,6 @@ static void axi_chan_block_xfer_complete(struct axi_dma_chan *chan)
 		/* Remove the completed descriptor from issued list before completing */
 		list_del(&vd->node);
 		vchan_cookie_complete(vd);
-
-		/* Submit queued descriptors after processing the completed ones */
-		axi_chan_start_first_queued(chan);
 	}
 
 out:
diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
index eb267cb24f670..8521530a34ec4 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
@@ -104,6 +104,7 @@ struct axi_dma_desc {
 	u32				completed_blocks;
 	u32				length;
 	u32				period_len;
+	u32				nr_hw_descs;
 };
 
 struct axi_dma_chan_config {
-- 
2.43.0



