Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E93A15E8B;
	Mon, 30 Dec 2024 15:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574273; cv=none; b=qWl3KRTSKs1o1/9hb1htxWJKd4ELKofH7wOcYPESFdC2xpBFNIVnio5P68OSo6qqIYcX2gDz7wm9VurY5JPo/gpOWLt5lSgzJWa6h5OY8NwUz+d3BgKRJLePrWUiM5tXdKe2ewIk48CCdKDC9ETQ2/xyW5O0qXKd6IUeyha2pl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574273; c=relaxed/simple;
	bh=cyhQkdxOxTJx7kpUvA6tqi3dCY6ckUzTW1MiyFn8jSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnjckz6a9+sMPIVsr/s/H/bGaCJMFOMMXda4JVzUhElPQDutowOhwWE1yF4ueZ94Kcfi0t0jJsMcuU0WLK3poxDV11gm4CSGeRYNUdM3B+g4ZSA3QbQaW0YOJWNdjx2zm6NsJZaXgj9YYQo3SDX91J/ylMAlUILyIu1BUBSb37E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+bzGCBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+bzGCBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE8AC4CED0;
	Mon, 30 Dec 2024 15:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574273;
	bh=cyhQkdxOxTJx7kpUvA6tqi3dCY6ckUzTW1MiyFn8jSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+bzGCBofV7QzFRdh6GNz1VW6lkN9a262XTM5T5XzW8ANV5V3tQaugEqg7c6Ha/bV
	 7BmGdnGYEbA+gqz2TCQ459hIDieNNiIVkAWQPYls9xfjA1qqtHDS0PoL0m5k/uy0zX
	 FBtKXV2aiwRwd7DMPe/zgU1T0KskxU6/USqlkYbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/114] ALSA: sh: Use standard helper for buffer accesses
Date: Mon, 30 Dec 2024 16:42:55 +0100
Message-ID: <20241230154220.312261318@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9b5f8ee43e48c25fbe1a10163ec04343d750acd0 ]

The SH DAC audio driver uses the kmalloc'ed buffer as the main PCM
buffer, and the data is transferred via hrtimer callbacks manually
from there to the hardware.  Meanwhile, some of its code are written
as if the buffer is on iomem and use the special helpers for the iomem
(e.g. copy_from_iter_toio() or memset_io()).  Those are rather useless
and the standard helpers should be used.

Similarly, the PCM mmap callback is set to a special one with
snd_pcm_lib_mmap_iomem, but this is also nonsense, because SH
architecture doesn't support this function, hence it leads just to
NULL -- the fallback to the standard helper.

This patch replaces those special setups with the standard ones.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411281337.I4M07b7i-lkp@intel.com/
Link: https://patch.msgid.link/20241128104939.13755-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/sh/sh_dac_audio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/sh/sh_dac_audio.c b/sound/sh/sh_dac_audio.c
index e7b6ce7bd086..5a9f77908a3d 100644
--- a/sound/sh/sh_dac_audio.c
+++ b/sound/sh/sh_dac_audio.c
@@ -163,7 +163,7 @@ static int snd_sh_dac_pcm_copy(struct snd_pcm_substream *substream,
 	/* channel is not used (interleaved data) */
 	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
 
-	if (copy_from_iter_toio(chip->data_buffer + pos, src, count))
+	if (copy_from_iter(chip->data_buffer + pos, src, count) != count)
 		return -EFAULT;
 	chip->buffer_end = chip->data_buffer + pos + count;
 
@@ -182,7 +182,7 @@ static int snd_sh_dac_pcm_silence(struct snd_pcm_substream *substream,
 	/* channel is not used (interleaved data) */
 	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
 
-	memset_io(chip->data_buffer + pos, 0, count);
+	memset(chip->data_buffer + pos, 0, count);
 	chip->buffer_end = chip->data_buffer + pos + count;
 
 	if (chip->empty) {
@@ -211,7 +211,6 @@ static const struct snd_pcm_ops snd_sh_dac_pcm_ops = {
 	.pointer	= snd_sh_dac_pcm_pointer,
 	.copy		= snd_sh_dac_pcm_copy,
 	.fill_silence	= snd_sh_dac_pcm_silence,
-	.mmap		= snd_pcm_lib_mmap_iomem,
 };
 
 static int snd_sh_dac_pcm(struct snd_sh_dac *chip, int device)
-- 
2.39.5



