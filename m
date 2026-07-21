Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AB438910F;
	Tue, 21 Jul 2026 18:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660395; cv=none; b=bUPer55JmLm9kVEOp1lc4ojMj3ij/hE9fyyIma8UkpBJ17t1PJSGfN3o1y3V+sVGtqXLq45IvFDWGx1IzSEwKP/19vIvewLZpU/9ZtgEF2fqXznRngxlBrUhV0z8u1jbBfttzxeQhxKnMN77kt4Q9sOD3gKMueWkqA6jICvFeoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660395; c=relaxed/simple;
	bh=9NjZhzEsj2Dn2xxNcyH088hKxJuclGf4RR5bK2vq38I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QQO4qsMMlBadkYEpwraRfVxq/n1r3ZHbZkJRtmmcc1ymdrPfIajLB2f4tp6uWlFp1/4Xnw49e4JsEecbW+ICx1TtJ5+VTXWeRrO2RpmoYDgNJCCbRnSvXV66w9Xx16HeW4yvMeco93Fid5i63KYyUiI590VvSuotvNhwudIOQDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzGkL64B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzGkL64B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E591F1F000E9;
	Tue, 21 Jul 2026 18:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660393;
	bh=47TCwTk2PppU6F7D7G/crUwBHOXY3g1wJ0/QQA39vgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzGkL64BT5o1ToCbMkjPSjLgIjtQ9XgBZ/BVmYpsf3nP2qXVfWmO78ueN8g0EqTu9
	 et4ZiMy/64NNcXf/bIQn9MPJL9Ft8hXszhed59a86QMLYoX4qY7At8ES/QHNc/wubu
	 oyTnserRCWZfP8NVuayEOjfFze7l3IYP0ch/tiVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0961/2077] dmaengine: dma-axi-dmac: use DMA pool to manange DMA descriptor
Date: Tue, 21 Jul 2026 17:10:34 +0200
Message-ID: <20260721152615.488460804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 127c3cf80a0e50..ce5cabc460651e 100644
--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -13,6 +13,7 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
+#include <linux/dmapool.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -147,6 +148,7 @@ struct axi_dmac_chan {
 	struct virt_dma_chan vchan;
 
 	struct axi_dmac_desc *next_desc;
+	void *pool;
 	struct list_head active_descs;
 	enum dma_transfer_direction direction;
 
@@ -650,11 +652,17 @@ static void axi_dmac_issue_pending(struct dma_chan *c)
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
@@ -666,22 +674,22 @@ axi_dmac_alloc_desc(struct axi_dmac_chan *chan, unsigned int num_sgs)
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
 
-		hws[i].id = AXI_DMAC_SG_UNUSED;
-		hws[i].flags = 0;
+		desc->sg[i].hw = hws;
+		desc->sg[i].hw_phys = hw_phys;
+
+		hws->id = AXI_DMAC_SG_UNUSED;
 
 		/* Link hardware descriptors */
-		hws[i].next_sg_addr = hw_phys + (i + 1) * sizeof(*hws);
+		if (i)
+			desc->sg[i - 1].hw->next_sg_addr = hw_phys;
 	}
 
 	/* The last hardware descriptor will trigger an interrupt */
@@ -690,18 +698,6 @@ axi_dmac_alloc_desc(struct axi_dmac_chan *chan, unsigned int num_sgs)
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
@@ -935,9 +931,26 @@ static struct dma_async_tx_descriptor *axi_dmac_prep_interleaved(
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
@@ -1239,6 +1252,7 @@ static int axi_dmac_probe(struct platform_device *pdev)
 	dma_cap_set(DMA_SLAVE, dma_dev->cap_mask);
 	dma_cap_set(DMA_CYCLIC, dma_dev->cap_mask);
 	dma_cap_set(DMA_INTERLEAVE, dma_dev->cap_mask);
+	dma_dev->device_alloc_chan_resources = axi_dmac_alloc_chan_resources;
 	dma_dev->device_free_chan_resources = axi_dmac_free_chan_resources;
 	dma_dev->device_tx_status = dma_cookie_status;
 	dma_dev->device_issue_pending = axi_dmac_issue_pending;
-- 
2.53.0



