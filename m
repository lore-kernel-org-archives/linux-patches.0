Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580D546D544;
	Tue, 21 Jul 2026 18:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657161; cv=none; b=PNlS1xlk12zs/7JHoomxw4lBsmdRvA1ITE4Iw4dqQFb984jVcvS9jhBdzj8avDXpNXUXuBwBGNNXFsU03ZjvkvFTiH8X9J20u0EkLnEnzigayLKjZBOyJ3Kr4RdA8/SezgHwfxeEI2bwl/fHXmzAjdaval5PoY+6wrD0YkRpwe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657161; c=relaxed/simple;
	bh=4cmUygaDaSHJjTDt8HZc3CjEC3YnsQkcbBQplPAQpnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rMKaST1n5pXos9I4RCebu0cMyvxtJLqTDeGJnGu7dMkv2YHWrUBOt5o7Iz5/5zmtrBPEnuEYyG9WULWpfcCWUat+Qsh5/H5j9TFN1hHlwuEPmEHNSazjFh1SvE6LAaCsE39a491IZoOQG1vlxQ6PW2kv1bCwW3iDQ/YYJIhE+7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNBrAJyd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNBrAJyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2DF1F000E9;
	Tue, 21 Jul 2026 18:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657160;
	bh=qzIrULtdfVL3TQ+aH/FBsZh165IRCe5Qn7OcVFwf7uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNBrAJydlQhfXKSIrV3tpOLWBDUuHnYitpK6Rmb+afHlxyCNa8ZglzHE+rH+diy6+
	 Cj/aueUV67pFFAiG+4945PuRNro2a67L9yxUIY3qNsWsnfAQzrx6ljcfpIFwA2iLu0
	 bA1wjUia125Ltgv2J6FYxAMVz+bFHzNFh9hVL6P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0661/1611] dmaengine: dma-axi-dmac: use DMA pool to manange DMA descriptor
Date: Tue, 21 Jul 2026 17:12:57 +0200
Message-ID: <20260721152530.252674880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 9e942c8579130e62734c14338e9f451780669164 ]

For architectures like Microblaze or arm64 (where this IP is used),
DMA_DIRECT_REMAP is set which means that dma_alloc_coherent() might
remap (and hence vmalloc()) some memory. This became visible in a design
where dma_direct_use_pool() is not possible.

With the above, when calling dma_free_coherent(), vunmap() would be
called from softirq context and thus leading to a BUG().

To fix it, use a dma pool that is allocated in
.device_alloc_chan_resources() and allocate blocks from it. The key
point is that now dma_pool_free() is used in axi_dmac_free_desc() to
free the blocks and that just frees the blocks from the pool in the
sense they can be used again. In other words, no actual call to
dma_free_coherent() happens. That only happens when destroying the pool
in axi_dmac_free_chan_resources() which does not happen in any interrupt
context.

Fixes: 3f8fd25936ee ("dmaengine: axi-dmac: Allocate hardware descriptors")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260424-dma-dmac-handle-vunmap-v4-4-90f43412fdc0@analog.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dma-axi-dmac.c | 66 +++++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 26 deletions(-)

diff --git a/drivers/dma/dma-axi-dmac.c b/drivers/dma/dma-axi-dmac.c
index a04b09b8cd6f8e..66fc1afaf5b0ce 100644
--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -12,6 +12,7 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
+#include <linux/dmapool.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -143,6 +144,7 @@ struct axi_dmac_chan {
 	struct virt_dma_chan vchan;
 
 	struct axi_dmac_desc *next_desc;
+	void *pool;
 	struct list_head active_descs;
 	enum dma_transfer_direction direction;
 
@@ -524,11 +526,17 @@ static void axi_dmac_issue_pending(struct dma_chan *c)
 	spin_unlock_irqrestore(&chan->vchan.lock, flags);
 }
 
+static void axi_dmac_free_desc(struct axi_dmac_desc *desc)
+{
+	for (unsigned int i = 0; i < desc->num_sgs; i++)
+		dma_pool_free(desc->chan->pool, desc->sg[i].hw, desc->sg[i].hw_phys);
+
+	kfree(desc);
+}
+
 static struct axi_dmac_desc *
 axi_dmac_alloc_desc(struct axi_dmac_chan *chan, unsigned int num_sgs)
 {
-	struct axi_dmac *dmac = chan_to_axi_dmac(chan);
-	struct device *dev = dmac->dma_dev.dev;
 	struct axi_dmac_hw_desc *hws;
 	struct axi_dmac_desc *desc;
 	dma_addr_t hw_phys;
@@ -540,22 +548,22 @@ axi_dmac_alloc_desc(struct axi_dmac_chan *chan, unsigned int num_sgs)
 	desc->num_sgs = num_sgs;
 	desc->chan = chan;
 
-	hws = dma_alloc_coherent(dev, PAGE_ALIGN(num_sgs * sizeof(*hws)),
-				&hw_phys, GFP_ATOMIC);
-	if (!hws) {
-		kfree(desc);
-		return NULL;
-	}
-
 	for (i = 0; i < num_sgs; i++) {
-		desc->sg[i].hw = &hws[i];
-		desc->sg[i].hw_phys = hw_phys + i * sizeof(*hws);
+		hws = dma_pool_zalloc(chan->pool, GFP_NOWAIT, &hw_phys);
+		if (!hws) {
+			desc->num_sgs = i;
+			axi_dmac_free_desc(desc);
+			return NULL;
+		}
+
+		desc->sg[i].hw = hws;
+		desc->sg[i].hw_phys = hw_phys;
 
-		hws[i].id = AXI_DMAC_SG_UNUSED;
-		hws[i].flags = 0;
+		hws->id = AXI_DMAC_SG_UNUSED;
 
 		/* Link hardware descriptors */
-		hws[i].next_sg_addr = hw_phys + (i + 1) * sizeof(*hws);
+		if (i)
+			desc->sg[i - 1].hw->next_sg_addr = hw_phys;
 	}
 
 	/* The last hardware descriptor will trigger an interrupt */
@@ -564,18 +572,6 @@ axi_dmac_alloc_desc(struct axi_dmac_chan *chan, unsigned int num_sgs)
 	return desc;
 }
 
-static void axi_dmac_free_desc(struct axi_dmac_desc *desc)
-{
-	struct axi_dmac *dmac = chan_to_axi_dmac(desc->chan);
-	struct device *dev = dmac->dma_dev.dev;
-	struct axi_dmac_hw_desc *hw = desc->sg[0].hw;
-	dma_addr_t hw_phys = desc->sg[0].hw_phys;
-
-	dma_free_coherent(dev, PAGE_ALIGN(desc->num_sgs * sizeof(*hw)),
-			  hw, hw_phys);
-	kfree(desc);
-}
-
 static struct axi_dmac_sg *axi_dmac_fill_linear_sg(struct axi_dmac_chan *chan,
 	enum dma_transfer_direction direction, dma_addr_t addr,
 	unsigned int num_periods, unsigned int period_len,
@@ -807,9 +803,26 @@ static struct dma_async_tx_descriptor *axi_dmac_prep_interleaved(
 	return vchan_tx_prep(&chan->vchan, &desc->vdesc, flags);
 }
 
+static int axi_dmac_alloc_chan_resources(struct dma_chan *c)
+{
+	struct axi_dmac_chan *chan = to_axi_dmac_chan(c);
+	struct device *dev = c->device->dev;
+
+	chan->pool = dma_pool_create(dev_name(dev), dev,
+				     sizeof(struct axi_dmac_hw_desc),
+				     __alignof__(struct axi_dmac_hw_desc), 0);
+	if (!chan->pool)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static void axi_dmac_free_chan_resources(struct dma_chan *c)
 {
+	struct axi_dmac_chan *chan = to_axi_dmac_chan(c);
+
 	vchan_free_chan_resources(to_virt_chan(c));
+	dma_pool_destroy(chan->pool);
 }
 
 static void axi_dmac_desc_free(struct virt_dma_desc *vdesc)
@@ -1093,6 +1106,7 @@ static int axi_dmac_probe(struct platform_device *pdev)
 	dma_cap_set(DMA_SLAVE, dma_dev->cap_mask);
 	dma_cap_set(DMA_CYCLIC, dma_dev->cap_mask);
 	dma_cap_set(DMA_INTERLEAVE, dma_dev->cap_mask);
+	dma_dev->device_alloc_chan_resources = axi_dmac_alloc_chan_resources;
 	dma_dev->device_free_chan_resources = axi_dmac_free_chan_resources;
 	dma_dev->device_tx_status = dma_cookie_status;
 	dma_dev->device_issue_pending = axi_dmac_issue_pending;
-- 
2.53.0



