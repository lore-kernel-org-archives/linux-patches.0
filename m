Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018729;
	b=uhhqvCKKrrLv0+4uc8F5YHpNiGKe/9bdk1BRTOZGe4LNkF+QUevDBiI9A7iglTWhOGbX
	 Rn0feTTkV4kQPOmRobolGyQvXzZmvUJV445IZs98W71uR0d2SSeANZr0PQpca8YAKsFPm
	 9WiNkZoUqftiJW004gGsn4QZczwrwiTWuXAVBGPFjmAVRCMj3RVMsaDb4GEHWpqTgRoX9
	 xZoqi+Pr/ht/OaaRDxeJvP5oVSzThSvwM9zqJFYNJCcNFYOsMpVlwzAtspp71plTcJ6jk
	 JZlIVJqjxDSQvy5hxHeH423+0a69mjvylsCQ0QUoCAsARJv6CVMLtZ3BYXgW7VIclRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5uLaRF2fdQzxTU36ixjMuqK10U8zMm8yLoKOevqE2wQ=;
	b=TuvWi1bXTwce60ANSfvf57FIggZfU8NQrGms9CkSVLuVdY9yZr4o4S0cnUlz8lcJHOMx
	 4NAaxbr/FRb0kgtxnrwcIKF6XbIFQJ10IReqmDjlLtz/imwa3VOrpqqYbpfQAsYqjj2sg
	 ZLJTJxeR+0BaPA9U9W3wpTKqZbDRz7SH19zX1r0mpsJO/x7KW/C2BQfoBcG3W9F1IZqff
	 L6RrgFYMM2Fkr7fcM5fptCJOouYfeVS0KLBAJPDHsQQQT3ppwtjy7ptLJOALRNlGnPTYy
	 wHb1KTYfwyTq/E5/S2A2WReEuZIxYISG24n11AlRs5u41G9iUC5a1CdIOGb6qe95YZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=caFrtQg3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D55606A32F;
	Wed, 18 Nov 2026 16:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=caFrtQg3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C571C1F000C4;
	Wed, 18 Nov 2026 16:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018728;
	bh=5uLaRF2fdQzxTU36ixjMuqK10U8zMm8yLoKOevqE2wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=caFrtQg31IA1anaAsDMYmWEnUher9wWZtvHLA93B89sPJ2uC1RhSrevr/uy9biChL
	 Om02M9Jam0OX6qfFKp6d1dzUMtKSQJQXjgbZLcTsZ/sHbKv3sJfGU7BqXAP4nL/EyT
	 +ipR26gYzYdpyRVvIYt4/vE8BCgkdDhAqDSTHj+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1342/2651] dmaengine: ste_dma40: Fix DMA registration unwind
Date: Wed, 18 Nov 2026 15:43:02 +0100
Message-ID: <20261118150336.333993210@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit f71ef686f913c8e9771a54466a76d653b83cd3dd ]

d40_dmaengine_init() registers DMAengine devices using devres-managed
unregister actions. If probe fails after one of those registrations, the
DMAengine devices stay visible until devres unwinds after d40_probe()
returns.

The channel tasklets are also initialized before each DMAengine device is
registered. An interrupt can therefore have queued a tasklet by the time a
later registration step fails, but unregistering the DMAengine devices
does not drain that tasklet before probe-owned storage is released.

Add tasklet cleanup actions to the DMAengine registration devres group.
Install each action before publishing its DMAengine device. If action
registration fails, those tasklets have never been exposed and cannot have
been scheduled, so use devm_add_action() without immediate reset cleanup.

On later failure, free the IRQ before releasing the group so no new
tasklets can be scheduled, then unregister the DMAengine devices and drain
their tasklets before freeing the remaining probe resources. Keep the
managed registrations and cleanup actions in place on successful probe by
removing only the temporary group markers.

Fixes: 42ae6f1695be ("dmaengine: ste_dma40: Remove platform data")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260819225215.5EA2F1F000E9@smtp.kernel.org/
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-11-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 45 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 4c545a9472642..f72d91c8d0fa6 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3039,6 +3039,18 @@ static void __init d40_chan_init(struct d40_base *base, struct dma_device *dma,
 	}
 }
 
+static void d40_kill_tasklets(void *data)
+{
+	struct dma_device *dma = data;
+	struct d40_chan *d40c;
+	struct dma_chan *chan;
+
+	list_for_each_entry(chan, &dma->channels, device_node) {
+		d40c = container_of(chan, struct d40_chan, chan);
+		tasklet_kill(&d40c->tasklet);
+	}
+}
+
 static void d40_ops_init(struct d40_base *base, struct dma_device *dev)
 {
 	if (dma_has_cap(DMA_SLAVE, dev->cap_mask)) {
@@ -3085,6 +3097,11 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 
 	d40_ops_init(base, &base->dma_slave);
 
+	err = devm_add_action(base->dev, d40_kill_tasklets,
+			      &base->dma_slave);
+	if (err)
+		goto exit;
+
 	err = dmaenginem_async_device_register(&base->dma_slave);
 
 	if (err) {
@@ -3100,6 +3117,11 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 
 	d40_ops_init(base, &base->dma_memcpy);
 
+	err = devm_add_action(base->dev, d40_kill_tasklets,
+			      &base->dma_memcpy);
+	if (err)
+		goto exit;
+
 	err = dmaenginem_async_device_register(&base->dma_memcpy);
 
 	if (err) {
@@ -3117,6 +3139,12 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	dma_cap_set(DMA_CYCLIC, base->dma_both.cap_mask);
 
 	d40_ops_init(base, &base->dma_both);
+
+	err = devm_add_action(base->dev, d40_kill_tasklets,
+			      &base->dma_both);
+	if (err)
+		goto exit;
+
 	err = dmaenginem_async_device_register(&base->dma_both);
 
 	if (err) {
@@ -3714,6 +3742,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	struct d40_base *base;
 	struct resource *res;
 	struct resource res_lcpa;
+	void *dmaenginem_reg_group;
 	int num_reserved_chans;
 	u32 val;
 	int ret;
@@ -3844,20 +3873,32 @@ static int __init d40_probe(struct platform_device *pdev)
 		d40_err(dev, "No IRQ defined\n");
 		goto destroy_cache;
 	}
+
+	dmaenginem_reg_group = devres_open_group(dev, NULL, GFP_KERNEL);
+	if (!dmaenginem_reg_group) {
+		ret = -ENOMEM;
+		goto release_irq;
+	}
+
 	ret = d40_dmaengine_init(base, num_reserved_chans);
 	if (ret)
-		goto release_irq;
+		goto release_dmaenginem;
 
 	ret = of_dma_controller_register(np, d40_xlate, NULL);
 	if (ret) {
 		dev_err(dev,
 			"could not register of_dma_controller\n");
-		goto release_irq;
+		goto release_dmaenginem;
 	}
+	devres_remove_group(dev, dmaenginem_reg_group);
 
 	dev_info(base->dev, "initialized\n");
 	return 0;
 
+ release_dmaenginem:
+	free_irq(base->irq, base);
+	devres_release_group(dev, dmaenginem_reg_group);
+	goto destroy_cache;
  release_irq:
 	free_irq(base->irq, base);
  destroy_cache:
-- 
2.53.0



