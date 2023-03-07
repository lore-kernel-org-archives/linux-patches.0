Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9028ABA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7961C433D2;
	Tue,  7 Mar 2023 18:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213362;
	bh=7fymXT6a76Kfg39zLL2wxjZ6QOHP06Z+W0Vp4ZfdjD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAsXK7+7StEH3hcc6xsYtvhJqqAbNbO5acR4GEQK5qQGPvw0fxbCX85aKMcX4mNIH
	 GG/rlQuXpYLYb2OCBGX7fcDk2GxniLYzoePAcARWZ61lS3MjD7U51R3W3UWTzvfELB
	 8jk5K38wNLyPIN7JGIWLRTE6zSiahkuuO5Sa0Ds8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shravan Chippa <shravan.chippa@microchip.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 484/885] dmaengine: sf-pdma: pdma_desc memory leak fix
Date: Tue,  7 Mar 2023 17:56:58 +0100
Message-Id: <20230307170023.495513962@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shravan Chippa <shravan.chippa@microchip.com>

[ Upstream commit b02e07015a5ac7bbc029da931ae17914b8ae0339 ]

Commit b2cc5c465c2c ("dmaengine: sf-pdma: Add multithread support for a
DMA channel") changed sf_pdma_prep_dma_memcpy() to unconditionally
allocate a new sf_pdma_desc each time it is called.

The driver previously recycled descs, by checking the in_use flag, only
allocating additional descs if the existing one was in use. This logic
was removed in commit b2cc5c465c2c ("dmaengine: sf-pdma: Add multithread
support for a DMA channel"), but sf_pdma_free_desc() was not changed to
handle the new behaviour.

As a result, each time sf_pdma_prep_dma_memcpy() is called, the previous
descriptor is leaked, over time leading to memory starvation:

  unreferenced object 0xffffffe008447300 (size 192):
  comm "irq/39-mchp_dsc", pid 343, jiffies 4294906910 (age 981.200s)
  hex dump (first 32 bytes):
    00 00 00 ff 00 00 00 00 b8 c1 00 00 00 00 00 00  ................
    00 00 70 08 10 00 00 00 00 00 00 c0 00 00 00 00  ..p.............
  backtrace:
    [<00000000064a04f4>] kmemleak_alloc+0x1e/0x28
    [<00000000018927a7>] kmem_cache_alloc+0x11e/0x178
    [<000000002aea8d16>] sf_pdma_prep_dma_memcpy+0x40/0x112

Add the missing kfree() to sf_pdma_free_desc(), and remove the redundant
in_use flag.

Fixes: b2cc5c465c2c ("dmaengine: sf-pdma: Add multithread support for a DMA channel")
Signed-off-by: Shravan Chippa <shravan.chippa@microchip.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230120100623.3530634-1-shravan.chippa@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sf-pdma/sf-pdma.c | 3 +--
 drivers/dma/sf-pdma/sf-pdma.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/dma/sf-pdma/sf-pdma.c b/drivers/dma/sf-pdma/sf-pdma.c
index 6b524eb6bcf3a..e578ad5569494 100644
--- a/drivers/dma/sf-pdma/sf-pdma.c
+++ b/drivers/dma/sf-pdma/sf-pdma.c
@@ -96,7 +96,6 @@ sf_pdma_prep_dma_memcpy(struct dma_chan *dchan,	dma_addr_t dest, dma_addr_t src,
 	if (!desc)
 		return NULL;
 
-	desc->in_use = true;
 	desc->dirn = DMA_MEM_TO_MEM;
 	desc->async_tx = vchan_tx_prep(&chan->vchan, &desc->vdesc, flags);
 
@@ -290,7 +289,7 @@ static void sf_pdma_free_desc(struct virt_dma_desc *vdesc)
 	struct sf_pdma_desc *desc;
 
 	desc = to_sf_pdma_desc(vdesc);
-	desc->in_use = false;
+	kfree(desc);
 }
 
 static void sf_pdma_donebh_tasklet(struct tasklet_struct *t)
diff --git a/drivers/dma/sf-pdma/sf-pdma.h b/drivers/dma/sf-pdma/sf-pdma.h
index dcb3687bd5da2..5c398a83b491a 100644
--- a/drivers/dma/sf-pdma/sf-pdma.h
+++ b/drivers/dma/sf-pdma/sf-pdma.h
@@ -78,7 +78,6 @@ struct sf_pdma_desc {
 	u64				src_addr;
 	struct virt_dma_desc		vdesc;
 	struct sf_pdma_chan		*chan;
-	bool				in_use;
 	enum dma_transfer_direction	dirn;
 	struct dma_async_tx_descriptor *async_tx;
 };
-- 
2.39.2



