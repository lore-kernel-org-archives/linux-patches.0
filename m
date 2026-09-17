Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA38951AECC;
	Thu, 17 Sep 2026 17:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665289; cv=none; b=DO7PJ/MrIqcGjgGIaHWUGgpRHMEjZ3fS08JbuRu9zIePZktEEu4Sxs7DrGVvFKlIt4gvqBq1HdhLfan5M5SCgBW3Ky5pvvzQIehBH5qra9IYraO4heyvjTNgUOIEALU6n65ML/dLMc4Y15BfpiAGlx4pHnwtPXSWMECxyJyWvpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665289; c=relaxed/simple;
	bh=i7yxUqXOOy+xR2WMlwTKnA8RHaGl4et6nV8urobm8I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eo+FrQV14OOsf6VuWKe8A6086O3PBdlZ2Mu6+McwV+Yh+X5hIfETc4s5phocWRU/rzoRNlsIHHoAgHufEwEpEMptxpEsR6467sk6HAC6DPWc0wNDEaswdyTnlDYKduQ11kRVBRQxq9Q4NlLfiLD6EelCZJLl2jnYL/Rvkrg2iQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luAZYuEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luAZYuEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284CA1F000FF;
	Thu, 17 Sep 2026 17:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665287;
	bh=f7a3sX6faChe5pqq42hxummKzY1ZWWmWVKk7kFR+OIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=luAZYuErzdQVHP/sMLgncgZPcQdoAydOhaI+R0WDAnRb1dQTxMJaqkmTDNRnIMjCI
	 MZZNn9GyUhJ+ghfZPoRazJueNsZfYqZMuhFVF0YYPWSstaONejiCU2EOk6kIY7In8S
	 V2UJcXy8t0N4Dwt71v3ny6nucd1UNRa+EhCgxGUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kimi Security Team <bug-report@moonshot.ai>,
	Yilin Zhang <yilinzhang@moonshot.ai>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0648/1250] ALSA: pcm: Serialize PCM mmap with buffer reallocation to fix page UAF
Date: Thu, 17 Sep 2026 16:07:23 +0100
Message-ID: <20260917151609.461712201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yilin Zhang <yilinzhang@moonshot.ai>

[ Upstream commit 9b110a9dcecc59516c77cb3c0caf1f492f75df2d ]

snd_pcm_hw_params() and snd_pcm_hw_free() guard buffer reallocation
with an mmap_count check performed under the PCM stream lock, but the
lock is released long before the buffer is actually freed:
snd_pcm_sync_stop(), constraint refinement and do_free_pages() all
happen in between.  snd_pcm_mmap_data(), on the other hand, takes no
lock at all: it validates against the old buffer's state and
dma_bytes, remaps its pages into the VMA, and only then increments
mmap_count.

A concurrent mmap() can therefore slip in between the check and the
free.  remap_pfn_range() installs writable PTEs for the old buffer's
pages without taking page references, and the subsequent
do_free_pages() returns those pages to the page allocator while the
VMA still maps them.  This leaves a stale, writable mapping of freed
pages: a page-level use-after-free that can be leveraged for local
privilege escalation.

Make snd_pcm_mmap_data() participate in the buffer-access scheme
introduced for hw_params/hw_free: acquire runtime->buffer_accessing
before validating and remapping, and release it afterwards.  Buffer
reallocation already fails with -EBUSY while accessors are active,
and the mmap side now fails with -EBUSY while a reallocation is in
progress, so the validate/remap sequence and the check/free sequence
can no longer interleave.

A reproducer that turns this race into a stale writable mapping of
the freed DMA buffer pages is available on request.

Reported-by: Kimi Security Team <bug-report@moonshot.ai>
Fixes: 92ee3c60ec9f ("ALSA: pcm: Fix races among concurrent hw_params and hw_free calls")
Signed-off-by: Yilin Zhang <yilinzhang@moonshot.ai>
Link: https://patch.msgid.link/20260831045506.889070-1-yilinzhang@moonshot.ai
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 03e4859c2b6f6..304b7e4965e3f 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3991,20 +3991,33 @@ int snd_pcm_mmap_data(struct snd_pcm_substream *substream, struct file *file,
 			return -EINVAL;
 	}
 	runtime = substream->runtime;
-	if (runtime->state == SNDRV_PCM_STATE_OPEN)
-		return -EBADFD;
-	if (!(runtime->info & SNDRV_PCM_INFO_MMAP))
-		return -ENXIO;
+	/* don't race with buffer reallocation in hw_params/hw_free */
+	if (!atomic_inc_unless_negative(&runtime->buffer_accessing))
+		return -EBUSY;
+	if (runtime->state == SNDRV_PCM_STATE_OPEN) {
+		err = -EBADFD;
+		goto out;
+	}
+	if (!(runtime->info & SNDRV_PCM_INFO_MMAP)) {
+		err = -ENXIO;
+		goto out;
+	}
 	if (runtime->access == SNDRV_PCM_ACCESS_RW_INTERLEAVED ||
-	    runtime->access == SNDRV_PCM_ACCESS_RW_NONINTERLEAVED)
-		return -EINVAL;
+	    runtime->access == SNDRV_PCM_ACCESS_RW_NONINTERLEAVED) {
+		err = -EINVAL;
+		goto out;
+	}
 	size = area->vm_end - area->vm_start;
 	offset = area->vm_pgoff << PAGE_SHIFT;
 	dma_bytes = PAGE_ALIGN(runtime->dma_bytes);
-	if ((size_t)size > dma_bytes)
-		return -EINVAL;
-	if (offset > dma_bytes - size)
-		return -EINVAL;
+	if ((size_t)size > dma_bytes) {
+		err = -EINVAL;
+		goto out;
+	}
+	if (offset > dma_bytes - size) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	area->vm_ops = &snd_pcm_vm_ops_data;
 	area->vm_private_data = substream;
@@ -4014,6 +4027,8 @@ int snd_pcm_mmap_data(struct snd_pcm_substream *substream, struct file *file,
 		err = snd_pcm_lib_default_mmap(substream, area);
 	if (!err)
 		atomic_inc(&substream->mmap_count);
+out:
+	atomic_dec(&runtime->buffer_accessing);
 	return err;
 }
 EXPORT_SYMBOL(snd_pcm_mmap_data);
-- 
2.53.0



