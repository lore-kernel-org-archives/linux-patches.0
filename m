Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46F515E8B;
	Mon, 30 Dec 2024 15:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573801; cv=none; b=JJhpiQ0/e/IMG0YlQ7AuFzl8zZ6gX7zaGy+7dLJt06XSapjJvRFj6wZHowP5U3qtmbt9U8qxMx/bcAxu0FVb0EQaGBJRCzzoUzweGFWY6S75QrZu3ZUkO9rX/XDE2WVMUTy76hHK5v7ndtAA9f0QQeMDGEpV3yebTvrMFP5ljWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573801; c=relaxed/simple;
	bh=ceGJcNIObDTiqsBLNqVT7SE6e4zcuZEVjKUR501tde0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K67YTIYx5Exnv8BF2FXoevQRveih+FBau7pm0mxDNJvcxuKnHY//AImyfQmapfiApe+3j656XyRZe4O7t11RgNsZM1S83VvSB+NbpB68DPFkovbByUVqKcIRmXx6MYbic+gycnLB2tUfd7ksXDtwHwYMBC9/zNMd3VSRKEyKYEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWMoH3jT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWMoH3jT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1619AC4CED6;
	Mon, 30 Dec 2024 15:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573801;
	bh=ceGJcNIObDTiqsBLNqVT7SE6e4zcuZEVjKUR501tde0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWMoH3jT7nXmsqNFSgW6R48y/mHFUaCsxtfJtd1HYdp/nL1Mh0G0pSXo+0/C6rt9L
	 5fKLL9XvCAbJuRuXYt6k2su2AVuOec4cEO1dvp3Lagopzki8DVQABlb1jf274vf5Hm
	 ikwnVE2DFcT0jwncE9ixeAiIeE2VW5cUJBQBgDtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 38/86] ALSA: sh: Use standard helper for buffer accesses
Date: Mon, 30 Dec 2024 16:42:46 +0100
Message-ID: <20241230154213.165198014@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 95ba3abd4e47..36a973d1c46d 100644
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



