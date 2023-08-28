Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896BE611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2E3C433C8;
	Mon, 28 Aug 2023 10:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219312;
	bh=6T1EYa6ScFFCq3Czktnc5qPp13Yc9CnxG59iNx/3mIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=124CYyWta+BTEQh0jbp+YQp79wZfNhv9V5hDi+IaJsCsjN8nU2PF3NKIFibr3vitd
	 aozn25auZwPlMrclK2ba/0jHfKmQqrFVXPMfUeTrN3CijyJNKAcsHNHJjOtfEAhnQI
	 lVcngiPSxwq6ymw8YiH6Rj9iyrfryvw05wDEhY/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 149/158] Revert "ALSA: pcm: Use SG-buffer only when direct DMA is available"
Date: Mon, 28 Aug 2023 12:14:06 +0200
Message-ID: <20230828101202.695378560@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 7d50b295c4af16f814ee82369c4a234df5228801 upstream.

This reverts commit 3ad796cbc36a ("ALSA: pcm: Use SG-buffer only when
direct DMA is available") also the modification commit 467fd0e82b62
("ALSA: pcm: Fix build error on m68k and others").

Poking the DMA internal helper is a layer violation, so we should
avoid that.  Meanwhile the actual bug has been addressed by the
Kconfig fix in commit dbed452a078d ("dma-pool: decouple DMA_REMAP from
DMA_COHERENT_POOL"), so we can live without this hack.

Link: https://lore.kernel.org/r/20200717064130.22957-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_memory.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/sound/core/pcm_memory.c
+++ b/sound/core/pcm_memory.c
@@ -11,7 +11,6 @@
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
 #include <linux/export.h>
-#include <linux/dma-mapping.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/info.h>
@@ -66,19 +65,6 @@ static int do_alloc_pages(struct snd_car
 	__update_allocated_size(card, size);
 	mutex_unlock(&card->memory_mutex);
 
-
-#ifdef CONFIG_SND_DMA_SGBUF
-	if ((type == SNDRV_DMA_TYPE_DEV_SG || type == SNDRV_DMA_TYPE_DEV_UC_SG) &&
-	    !dma_is_direct(get_dma_ops(dev))) {
-		/* mutate to continuous page allocation */
-		dev_dbg(dev, "Use continuous page allocator\n");
-		if (type == SNDRV_DMA_TYPE_DEV_SG)
-			type = SNDRV_DMA_TYPE_DEV;
-		else
-			type = SNDRV_DMA_TYPE_DEV_UC;
-	}
-#endif /* CONFIG_SND_DMA_SGBUF */
-
 	err = snd_dma_alloc_pages(type, dev, size, dmab);
 	if (!err) {
 		/* the actual allocation size might be bigger than requested,


