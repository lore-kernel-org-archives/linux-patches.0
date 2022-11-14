Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8614C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5916C433C1;
	Mon, 14 Nov 2022 13:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431203;
	bh=bhiukteCK3wgTfUrBzjZScGhIJ5cj2FimMysUYSGIqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBCeBsanrUqTXtHFid1rTdQZD5y4QIl0RCZAI8V5+Ea2k87OtCnaAeD0lWlc7meyL
	 kTmyWI7JVe2gCPaVkOPdIjBA5vcmGflQ+cvEoyNWh4KDxEzlqcUXDqsAeBo7HFP2Nj
	 JlL0MtQaEMlSZmheWuwgJnziUJx3RCSMYeq9bEUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 108/190] ALSA: memalloc: Dont fall back for SG-buffer with IOMMU
Date: Mon, 14 Nov 2022 13:45:32 +0100
Message-Id: <20221114124503.407429608@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9736a325137b62499d2b4be3fc2d742b131f75da ]

When the non-contiguous page allocation for SG buffer allocation
fails, the memalloc helper tries to fall back to the old page
allocation methods.  This would, however, result in the bogus page
addresses when IOMMU is enabled.  Usually in such a case, the fallback
allocation should fail as well, but occasionally it succeeds and
hitting a bad access.

The fallback was thought for non-IOMMU case, and as the error from
dma_alloc_noncontiguous() with IOMMU essentially implies a fatal
memory allocation error, we should return the error straightforwardly
without fallback.  This avoids the corner case like the above.

The patch also renames the local variable "dma_ops" with snd_ prefix
for avoiding the name conflict.

Fixes: a8d302a0b770 ("ALSA: memalloc: Revive x86-specific WC page allocations again")
Reported-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/alpine.DEB.2.22.394.2211041541090.3532114@eliteleevi.tm.intel.com
Link: https://lore.kernel.org/r/20221110132216.30605-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/memalloc.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index cfcd8eff4139..2a773ed2b32a 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
+#include <linux/dma-map-ops.h>
 #include <linux/genalloc.h>
 #include <linux/highmem.h>
 #include <linux/vmalloc.h>
@@ -526,19 +527,20 @@ static void *snd_dma_noncontig_alloc(struct snd_dma_buffer *dmab, size_t size)
 	struct sg_table *sgt;
 	void *p;
 
-	sgt = dma_alloc_noncontiguous(dmab->dev.dev, size, dmab->dev.dir,
-				      DEFAULT_GFP, 0);
-	if (!sgt) {
 #ifdef CONFIG_SND_DMA_SGBUF
+	if (!get_dma_ops(dmab->dev.dev)) {
 		if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG)
 			dmab->dev.type = SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK;
 		else
 			dmab->dev.type = SNDRV_DMA_TYPE_DEV_SG_FALLBACK;
 		return snd_dma_sg_fallback_alloc(dmab, size);
-#else
-		return NULL;
-#endif
 	}
+#endif
+
+	sgt = dma_alloc_noncontiguous(dmab->dev.dev, size, dmab->dev.dir,
+				      DEFAULT_GFP, 0);
+	if (!sgt)
+		return NULL;
 
 	dmab->dev.need_sync = dma_need_sync(dmab->dev.dev,
 					    sg_dma_address(sgt->sgl));
@@ -874,7 +876,7 @@ static const struct snd_malloc_ops snd_dma_noncoherent_ops = {
 /*
  * Entry points
  */
-static const struct snd_malloc_ops *dma_ops[] = {
+static const struct snd_malloc_ops *snd_dma_ops[] = {
 	[SNDRV_DMA_TYPE_CONTINUOUS] = &snd_dma_continuous_ops,
 	[SNDRV_DMA_TYPE_VMALLOC] = &snd_dma_vmalloc_ops,
 #ifdef CONFIG_HAS_DMA
@@ -900,7 +902,7 @@ static const struct snd_malloc_ops *snd_dma_get_ops(struct snd_dma_buffer *dmab)
 	if (WARN_ON_ONCE(!dmab))
 		return NULL;
 	if (WARN_ON_ONCE(dmab->dev.type <= SNDRV_DMA_TYPE_UNKNOWN ||
-			 dmab->dev.type >= ARRAY_SIZE(dma_ops)))
+			 dmab->dev.type >= ARRAY_SIZE(snd_dma_ops)))
 		return NULL;
-	return dma_ops[dmab->dev.type];
+	return snd_dma_ops[dmab->dev.type];
 }
-- 
2.35.1



