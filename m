Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7180611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5892CC433C7;
	Mon, 28 Aug 2023 10:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219309;
	bh=9ZYdu7WmT7EOq43bNgHExxTx62qDQqJIJ7V4HZikT9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qGFD/ZE4ZH/B3w712yLwAdl6bZWSBVm7OEpM4bl/miUOcKq2DT+jWRn7d+quel9LD
	 hdpZ3thwDd/ix2WZY+m3S3wEOCbyg/riin0cnyEKjuSYM/J7ctd7dISGUz8QzV5/Gr
	 7lqhaK5tCvq0AeU3U7At/DudpVC9NfYZ7gTCkrXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 148/158] ALSA: pcm: Fix build error on m68k and others
Date: Mon, 28 Aug 2023 12:14:05 +0200
Message-ID: <20230828101202.647786424@linuxfoundation.org>
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

commit 467fd0e82b6265b8e6cc078a70bd7592574d5c83 upstream.

The commit 3ad796cbc36a ("ALSA: pcm: Use SG-buffer only when direct
DMA is available") introduced a check of the DMA type and this caused
a build error on m68k (and possibly some others) due to the lack of
dma_is_direct() definition.  Since the check is needed only for
CONFIG_SND_DMA_SGBUF enablement (i.e. solely x86), use #ifdef instead
of IS_ENABLED() for avoiding such a build error.

Fixes: 3ad796cbc36a ("ALSA: pcm: Use SG-buffer only when direct DMA is available")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20200707111225.26826-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/core/pcm_memory.c
+++ b/sound/core/pcm_memory.c
@@ -66,8 +66,9 @@ static int do_alloc_pages(struct snd_car
 	__update_allocated_size(card, size);
 	mutex_unlock(&card->memory_mutex);
 
-	if (IS_ENABLED(CONFIG_SND_DMA_SGBUF) &&
-	    (type == SNDRV_DMA_TYPE_DEV_SG || type == SNDRV_DMA_TYPE_DEV_UC_SG) &&
+
+#ifdef CONFIG_SND_DMA_SGBUF
+	if ((type == SNDRV_DMA_TYPE_DEV_SG || type == SNDRV_DMA_TYPE_DEV_UC_SG) &&
 	    !dma_is_direct(get_dma_ops(dev))) {
 		/* mutate to continuous page allocation */
 		dev_dbg(dev, "Use continuous page allocator\n");
@@ -76,6 +77,7 @@ static int do_alloc_pages(struct snd_car
 		else
 			type = SNDRV_DMA_TYPE_DEV_UC;
 	}
+#endif /* CONFIG_SND_DMA_SGBUF */
 
 	err = snd_dma_alloc_pages(type, dev, size, dmab);
 	if (!err) {


