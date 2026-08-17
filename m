Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD6838D01E;
	Mon, 17 Aug 2026 15:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979942; cv=none; b=F75dqviANQaOGLxEujkbEet5vz8W0LeoJj5LAFjPsfRNELdW2HCzZK8p1zLMq2CXv4oZDRqmqAlipsXvNzClZv6UFhMNcYfCy1BOHhwxCiStFtEhez8YfEL0VSpvTPliYGf0r7ErkHCKUbqsLvxpEI22L05lu5iOxQG/gGUqSao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979942; c=relaxed/simple;
	bh=m6C39utRmgr1z/omoslLgLvDimMgCi9XhtAcHZ9fthI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XviWALPR+4Eci/6B6mLu+KADrWwvxNEScoY2SVv9d8PWJJW3k/WJ7Ko4T0gO8OBK31A6HZq4RnED6ebSlPDTkBUrSGjAiZA5Zlg47IWFCM/cLfYNdflhBY68xpwuLNvo0lChWlTwAnvf4dAAr4HmEnmHOhV92xh6MMc767XLG0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZoY0FsY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZoY0FsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011D41F00A3A;
	Mon, 17 Aug 2026 15:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979939;
	bh=3YFjk/H19Llos6bb0gQf1jOc04ag44i8kPRZgtodWgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZoY0FsYkzuQMZmehPI9gTEzAIBgE4HPncee4pdFcgknyhhatb9TRMi5F2ZR8rsfX
	 6V2xZuDqJIS6NNwcAIxtz3xI6kePaztJ58yxyCGXiuHCvv+0GTBNp6dEw9/GkSIJ9m
	 HpOM/Y8JkCgUvdraEDQ+2Y7xxbJG7JikUjTV9Cq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 398/609] ALSA: lx6464es: fix period byte count for 16-bit streams
Date: Mon, 17 Aug 2026 15:31:34 +0200
Message-ID: <20260817132557.533612401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit 6437033bffe8bd2af174d139af552d90d40c7ac6 upstream.

The lx6464es driver advertises both 16-bit and packed 24-bit PCM formats,
but lx_trigger_start() and lx_interrupt_request_new_buffer() calculate the
DMA period size as runtime->period_size * runtime->channels * 3.  That is
only correct for the packed 24-bit formats.

For 16-bit streams the driver submits buffers that are 50% larger than the
actual ALSA period and advances the DMA address by the same wrong amount.
For example, with 2 channels, 256 frames and 4 periods, the third buffer
already extends beyond the ALSA buffer and the fourth buffer starts outside
it.

Use snd_pcm_lib_period_bytes() so the byte count matches the runtime
format, channel count and period size.

Fixes: 02bec4904508 ("ALSA: lx6464es - driver for the digigram lx6464es interface")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/8BB12E8D92A7CDBA+20260723085710.2567463-1-raoxu@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/lx6464es/lx6464es.c |    5 +----
 sound/pci/lx6464es/lx_core.c  |    5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/sound/pci/lx6464es/lx6464es.c
+++ b/sound/pci/lx6464es/lx6464es.c
@@ -410,11 +410,8 @@ static void lx_trigger_start(struct lx64
 
 	int err;
 
-	const u32 channels = substream->runtime->channels;
-	const u32 bytes_per_frame = channels * 3;
-	const u32 period_size = substream->runtime->period_size;
 	const u32 periods = substream->runtime->periods;
-	const u32 period_bytes = period_size * bytes_per_frame;
+	const u32 period_bytes = snd_pcm_lib_period_bytes(substream);
 
 	dma_addr_t buf = substream->dma_buffer.addr;
 	int i;
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -1015,10 +1015,7 @@ static int lx_interrupt_request_new_buff
 	const unsigned int is_capture = lx_stream->is_capture;
 	int err;
 
-	const u32 channels = substream->runtime->channels;
-	const u32 bytes_per_frame = channels * 3;
-	const u32 period_size = substream->runtime->period_size;
-	const u32 period_bytes = period_size * bytes_per_frame;
+	const u32 period_bytes = snd_pcm_lib_period_bytes(substream);
 	const u32 pos = lx_stream->frame_pos;
 	const u32 next_pos = ((pos+1) == substream->runtime->periods) ?
 		0 : pos + 1;


