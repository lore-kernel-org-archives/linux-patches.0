Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A18B1849DD;
	Wed,  3 Jul 2024 11:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005751; cv=none; b=b+GOwZvaL4VICYoXHvHfZSvdIX9hWYyusADAi1lyP82fthX4lR7nQ9ulEYxNknr2Eaoj5TRxvCs4RWfCRxtmj/w3jR1MQ9l3fjsGTPrlY/Wq/kgvC+gW9TGsHbWFHGW4ybo8KpwVyh/xguixwlAkV6ERTdPO3Pr/zpLwsD/Esi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005751; c=relaxed/simple;
	bh=8JeZz9flsRfJyLVlHgOgObtzIxH4lYhY0gzPgexdjOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVZ5A8CL7Yzv3sKve7g7HN7Z+pl4LijM15p4411iczMLR0Odko2VK/UE12Z+C5J5O+1ubdw+3jFItjpY2BpvFYFlsSitTR6x65wSZzSRgqU10BmuSAOGRErsL8aB0sFuJU6L/HX0XaMbu/iUD7XRCgIroa9nKXBTMT12YGqxUKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUPB8P/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUPB8P/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95631C4AF0B;
	Wed,  3 Jul 2024 11:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005751;
	bh=8JeZz9flsRfJyLVlHgOgObtzIxH4lYhY0gzPgexdjOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUPB8P/ozl6Nfme1yGzbL5MD+PIzFVhOmaVE7YT4j4UQydVbyTDtjSJ3Hufxu6ahM
	 5MIEWihhD96/xZnq9hxYdY84aYfP6Ss0VhUOrz4Cdcd2p2d6pp8ImR14vR7AC6zz3W
	 RybZR2JT2hlAjHN4LFNx3xdqSXtdEAJj8/DCTeyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Pinto <jpinto@synopsys.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 177/356] Avoid hw_desc array overrun in dw-axi-dmac
Date: Wed,  3 Jul 2024 12:38:33 +0200
Message-ID: <20240703102919.800625080@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cfc47efcb5d93..6715ade391aa1 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -213,6 +213,7 @@ static struct axi_dma_desc *axi_desc_alloc(u32 num)
 		kfree(desc);
 		return NULL;
 	}
+	desc->nr_hw_descs = num;
 
 	return desc;
 }
@@ -239,7 +240,7 @@ static struct axi_dma_lli *axi_desc_get(struct axi_dma_chan *chan,
 static void axi_desc_put(struct axi_dma_desc *desc)
 {
 	struct axi_dma_chan *chan = desc->chan;
-	int count = atomic_read(&chan->descs_allocated);
+	int count = desc->nr_hw_descs;
 	struct axi_dma_hw_desc *hw_desc;
 	int descs_put;
 
@@ -1049,9 +1050,6 @@ static void axi_chan_block_xfer_complete(struct axi_dma_chan *chan)
 		/* Remove the completed descriptor from issued list before completing */
 		list_del(&vd->node);
 		vchan_cookie_complete(vd);
-
-		/* Submit queued descriptors after processing the completed ones */
-		axi_chan_start_first_queued(chan);
 	}
 
 out:
diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
index 380005afde160..58fc6310ee364 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
@@ -101,6 +101,7 @@ struct axi_dma_desc {
 	u32				completed_blocks;
 	u32				length;
 	u32				period_len;
+	u32				nr_hw_descs;
 };
 
 static inline struct device *dchan2dev(struct dma_chan *dchan)
-- 
2.43.0



