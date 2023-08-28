Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BF1611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF54C433C7;
	Mon, 28 Aug 2023 10:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219204;
	bh=GDCVmVLba0Xfe20+3m042y9vPBwWx9J3Wqyw8u0kH34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ifSNvYw6XgnYWpoYx66Scy5NQ/6Nvp4EWK3y9a0JB5eO2P6kO8rSYpFfZMNDIpK7
	 4ubDQLnfbkjYYwBxj5n+L3VX5rqKokYB7aTa5hdIEmdtLHYJx3tgUipomGDPosLhUL
	 6yzyweX4FVq4y6ZFsocCNugp49c797ATNCu5bISg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BassCheck <bass@buaa.edu.cn>,
	Tuo Li <islituo@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/158] ALSA: pcm: Fix potential data race at PCM memory allocation helpers
Date: Mon, 28 Aug 2023 12:13:28 +0200
Message-ID: <20230828101201.040903876@linuxfoundation.org>
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

[ Upstream commit bd55842ed998a622ba6611fe59b3358c9f76773d ]

The PCM memory allocation helpers have a sanity check against too many
buffer allocations.  However, the check is performed without a proper
lock and the allocation isn't serialized; this allows user to allocate
more memories than predefined max size.

Practically seen, this isn't really a big problem, as it's more or
less some "soft limit" as a sanity check, and it's not possible to
allocate unlimitedly.  But it's still better to address this for more
consistent behavior.

The patch covers the size check in do_alloc_pages() with the
card->memory_mutex, and increases the allocated size there for
preventing the further overflow.  When the actual allocation fails,
the size is decreased accordingly.

Reported-by: BassCheck <bass@buaa.edu.cn>
Reported-by: Tuo Li <islituo@gmail.com>
Link: https://lore.kernel.org/r/CADm8Tek6t0WedK+3Y6rbE5YEt19tML8BUL45N2ji4ZAz1KcN_A@mail.gmail.com
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230703112430.30634-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_memory.c | 44 +++++++++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/sound/core/pcm_memory.c b/sound/core/pcm_memory.c
index 97b471d7b32e5..beca39f7c8f35 100644
--- a/sound/core/pcm_memory.c
+++ b/sound/core/pcm_memory.c
@@ -31,14 +31,40 @@ static unsigned long max_alloc_per_card = 32UL * 1024UL * 1024UL;
 module_param(max_alloc_per_card, ulong, 0644);
 MODULE_PARM_DESC(max_alloc_per_card, "Max total allocation bytes per card.");
 
+static void __update_allocated_size(struct snd_card *card, ssize_t bytes)
+{
+	card->total_pcm_alloc_bytes += bytes;
+}
+
+static void update_allocated_size(struct snd_card *card, ssize_t bytes)
+{
+	mutex_lock(&card->memory_mutex);
+	__update_allocated_size(card, bytes);
+	mutex_unlock(&card->memory_mutex);
+}
+
+static void decrease_allocated_size(struct snd_card *card, size_t bytes)
+{
+	mutex_lock(&card->memory_mutex);
+	WARN_ON(card->total_pcm_alloc_bytes < bytes);
+	__update_allocated_size(card, -(ssize_t)bytes);
+	mutex_unlock(&card->memory_mutex);
+}
+
 static int do_alloc_pages(struct snd_card *card, int type, struct device *dev,
 			  size_t size, struct snd_dma_buffer *dmab)
 {
 	int err;
 
+	/* check and reserve the requested size */
+	mutex_lock(&card->memory_mutex);
 	if (max_alloc_per_card &&
-	    card->total_pcm_alloc_bytes + size > max_alloc_per_card)
+	    card->total_pcm_alloc_bytes + size > max_alloc_per_card) {
+		mutex_unlock(&card->memory_mutex);
 		return -ENOMEM;
+	}
+	__update_allocated_size(card, size);
+	mutex_unlock(&card->memory_mutex);
 
 	if (IS_ENABLED(CONFIG_SND_DMA_SGBUF) &&
 	    (type == SNDRV_DMA_TYPE_DEV_SG || type == SNDRV_DMA_TYPE_DEV_UC_SG) &&
@@ -53,9 +79,14 @@ static int do_alloc_pages(struct snd_card *card, int type, struct device *dev,
 
 	err = snd_dma_alloc_pages(type, dev, size, dmab);
 	if (!err) {
-		mutex_lock(&card->memory_mutex);
-		card->total_pcm_alloc_bytes += dmab->bytes;
-		mutex_unlock(&card->memory_mutex);
+		/* the actual allocation size might be bigger than requested,
+		 * and we need to correct the account
+		 */
+		if (dmab->bytes != size)
+			update_allocated_size(card, dmab->bytes - size);
+	} else {
+		/* take back on allocation failure */
+		decrease_allocated_size(card, size);
 	}
 	return err;
 }
@@ -64,10 +95,7 @@ static void do_free_pages(struct snd_card *card, struct snd_dma_buffer *dmab)
 {
 	if (!dmab->area)
 		return;
-	mutex_lock(&card->memory_mutex);
-	WARN_ON(card->total_pcm_alloc_bytes < dmab->bytes);
-	card->total_pcm_alloc_bytes -= dmab->bytes;
-	mutex_unlock(&card->memory_mutex);
+	decrease_allocated_size(card, dmab->bytes);
 	snd_dma_free_pages(dmab);
 	dmab->area = NULL;
 }
-- 
2.40.1



