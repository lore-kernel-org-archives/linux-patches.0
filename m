Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471B7468C0C;
	Thu, 20 Aug 2026 16:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244561; cv=none; b=RDppcahnFYJ1N6R5gwcVJhdU49q0soaKr8wGYObp4+3aVicDWQIXTZaARKIpCpbIa2Wi8vGREnVVCbf4T68OOL58GpvOtaD6mClRTx2r1MbUHre71igwqHORsus+vYUw30nb6oCv3OTlwAkDDWAbKmukvQ9BL6URZ59lkviZzEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244561; c=relaxed/simple;
	bh=4epDJSPY5BvHVcFL0DeyLcjlTHq6UnsPPaOgM75Muug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cj0IEMDC61AKETZyfP0GORv1pz1CsH3uGppEGxOdzOkzNYQTxldldcUauInO9Z2n+vvLJOJkir5zr+KypGImQpPz3s+uizEkcaxZw2aiLORjuCDiJ8CL+E3hUctt159tQt01wufWSHxx1ZRY4+0MPycVnSUdgIgI6bNC0SA7b4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7i7x5QK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7i7x5QK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606761F000E9;
	Thu, 20 Aug 2026 16:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244559;
	bh=2yO8LppZnuEXO/v+RslsLSBhlCXrJhvNUjgnDCnoDdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7i7x5QKUjEK4xY3pv7BYU6vtO3RkIOd9DxS6X9tBoXuj7z7Sn6w4wQS/jzyMN0uC
	 ZvbRD2jo3T3yinWWdTJJNfohKRTLYtuNW7aphz1ckQ8yre/qXuMNTGmlXO95Mz4vpq
	 rBZ0G/BuxzStxGyYkr9T6Hokzec136n593Z7Rm3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/235] ALSA: usx2y: Fix potential leaks of uninitialized memory
Date: Thu, 20 Aug 2026 16:57:26 +0200
Message-ID: <20260820145222.955054577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4e268db74770b454b877ab5260f1868a457d212c ]

usx2y drivers may expose the allocated pages via mmap, but it performs
zero-clear only for the struct size, not aligned with the page size.
This leaves out some uninitialized trailing bytes.

This patch fixes the clearance to cover all memory that are exposed to
user-space.

Link: https://lore.kernel.org/r/20210517131545.27252-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 2ca1eea3cd17 ("ALSA: usx2y: bound the hwdep mmap fault offset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/usx2y/usX2Yhwdep.c      |    8 ++++----
 sound/usb/usx2y/usbus428ctldefs.h |    2 ++
 sound/usb/usx2y/usbusx2y.c        |    2 +-
 sound/usb/usx2y/usx2yhwdeppcm.c   |   13 ++++++++-----
 4 files changed, 15 insertions(+), 10 deletions(-)

--- a/sound/usb/usx2y/usX2Yhwdep.c
+++ b/sound/usb/usx2y/usX2Yhwdep.c
@@ -55,17 +55,17 @@ static int snd_us428ctls_mmap(struct snd
 		return -EBUSY;
 
 	/* if userspace tries to mmap beyond end of our buffer, fail */
-	if (size > PAGE_ALIGN(sizeof(struct us428ctls_sharedmem))) {
-		snd_printd("%lu > %lu\n", size, (unsigned long)sizeof(struct us428ctls_sharedmem));
+	if (size > US428_SHAREDMEM_PAGES) {
+		snd_printd("%lu > %lu\n", size, (unsigned long)US428_SHAREDMEM_PAGES);
 		return -EINVAL;
 	}
 
 	if (!us428->us428ctls_sharedmem) {
 		init_waitqueue_head(&us428->us428ctls_wait_queue_head);
-		us428->us428ctls_sharedmem = alloc_pages_exact(sizeof(struct us428ctls_sharedmem), GFP_KERNEL);
+		us428->us428ctls_sharedmem = alloc_pages_exact(US428_SHAREDMEM_PAGES, GFP_KERNEL);
 		if (!us428->us428ctls_sharedmem)
 			return -ENOMEM;
-		memset(us428->us428ctls_sharedmem, -1, sizeof(struct us428ctls_sharedmem));
+		memset(us428->us428ctls_sharedmem, -1, US428_SHAREDMEM_PAGES);
 		us428->us428ctls_sharedmem->ctl_snapshot_last = -2;
 	}
 	area->vm_ops = &us428ctls_vm_ops;
--- a/sound/usb/usx2y/usbus428ctldefs.h
+++ b/sound/usb/usx2y/usbus428ctldefs.h
@@ -89,3 +89,5 @@ struct us428ctls_sharedmem {
 	struct us428_p4out	p4out[N_US428_P4OUT_BUFS];
 	int			p4out_last, p4out_sent;
 };
+
+#define US428_SHAREDMEM_PAGES	PAGE_ALIGN(sizeof(struct us428ctls_sharedmem))
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -376,7 +376,7 @@ static void snd_usx2y_card_private_free(
 	usb_free_urb(usx2y->in04_urb);
 	if (usx2y->us428ctls_sharedmem)
 		free_pages_exact(usx2y->us428ctls_sharedmem,
-				 sizeof(*usx2y->us428ctls_sharedmem));
+				 US428_SHAREDMEM_PAGES);
 	if (usx2y->card_index >= 0 && usx2y->card_index < SNDRV_CARDS)
 		snd_usx2y_card_used[usx2y->card_index] = 0;
 }
--- a/sound/usb/usx2y/usx2yhwdeppcm.c
+++ b/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -485,6 +485,9 @@ static int usx2y_usbpcm_urbs_start(struc
 	return err;
 }
 
+#define USX2Y_HWDEP_PCM_PAGES	\
+	PAGE_ALIGN(sizeof(struct snd_usx2y_hwdep_pcm_shm))
+
 /*
  * prepare callback
  *
@@ -501,11 +504,11 @@ static int snd_usx2y_usbpcm_prepare(stru
 	snd_printdd("snd_usx2y_pcm_prepare(%p)\n", substream);
 
 	if (!usx2y->hwdep_pcm_shm) {
-		usx2y->hwdep_pcm_shm = alloc_pages_exact(sizeof(struct snd_usx2y_hwdep_pcm_shm),
+		usx2y->hwdep_pcm_shm = alloc_pages_exact(USX2Y_HWDEP_PCM_PAGES,
 							 GFP_KERNEL);
 		if (!usx2y->hwdep_pcm_shm)
 			return -ENOMEM;
-		memset(usx2y->hwdep_pcm_shm, 0, sizeof(struct snd_usx2y_hwdep_pcm_shm));
+		memset(usx2y->hwdep_pcm_shm, 0, USX2Y_HWDEP_PCM_PAGES);
 	}
 
 	mutex_lock(&usx2y->pcm_mutex);
@@ -692,8 +695,8 @@ static int snd_usx2y_hwdep_pcm_mmap(stru
 		return -EBUSY;
 
 	/* if userspace tries to mmap beyond end of our buffer, fail */
-	if (size > PAGE_ALIGN(sizeof(struct snd_usx2y_hwdep_pcm_shm))) {
-		snd_printd("%lu > %lu\n", size, (unsigned long)sizeof(struct snd_usx2y_hwdep_pcm_shm));
+	if (size > USX2Y_HWDEP_PCM_PAGES) {
+		snd_printd("%lu > %lu\n", size, (unsigned long)USX2Y_HWDEP_PCM_PAGES);
 		return -EINVAL;
 	}
 
@@ -711,7 +714,7 @@ static void snd_usx2y_hwdep_pcm_private_
 	struct usx2ydev *usx2y = hwdep->private_data;
 
 	if (usx2y->hwdep_pcm_shm)
-		free_pages_exact(usx2y->hwdep_pcm_shm, sizeof(struct snd_usx2y_hwdep_pcm_shm));
+		free_pages_exact(usx2y->hwdep_pcm_shm, USX2Y_HWDEP_PCM_PAGES);
 }
 
 int usx2y_hwdep_pcm_new(struct snd_card *card)


