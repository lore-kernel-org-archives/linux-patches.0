Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D032442B12;
	Mon, 17 Aug 2026 14:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976079; cv=none; b=T4YfHLhnX083hMlU7dQztVob4JvYZ3MkjJCki1wa2g5Stf6Rr45gV//BIh+mpI/+TCdK4JDbvdVORr/GXPaGx9J1QZIpzZVgioMueYCR7f1/uHbdXZO1S37H1+iAKW+bVi2uurButqfhx6b0ItWfZ3G7pjlTnk0TYGktyhTWPzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976079; c=relaxed/simple;
	bh=XrLTduXntdwsm4F/iLvC6qBUTl+aBQ1mesmUR6UL39s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEhunhl8CxuMLIifBQbyvSG6SJy58sf8TUxzSu5RdhQk7FvcxceHGU3t4/UhZIt8b6dbJ3mBAlHx0GIVGXUC6qS4Bwnhmg4e/M0OHcDCTFfJaC4dF2nMI4uwd0U/fQZi8AmUmCFUfE4ndeKgXhTYtUrMUP9nl5lGqyPgJ0B9QA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Gfx46xq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Gfx46xq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAA31F000E9;
	Mon, 17 Aug 2026 14:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976077;
	bh=pxT2NHRyCKTfGPnJWP4USBr8qc1pqTCcUGu0znO7me8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Gfx46xqGIQ6T9khyqRWdAq+5sclbnB4YBp898cuohJBk0mrXfuv5D3W2iOE81iGv
	 QgEN45jSJwktvFsNLtnEdOxmF8oVR/8Yc0iVbJY8/SossNrn5E8maMVZEuhqy7RDek
	 NX0oetsNNQvJ34s5ZJncDsSqCcYwZkqbR4HiyfS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 250/389] ALSA: lx6464es: fix period byte count for 16-bit streams
Date: Mon, 17 Aug 2026 15:31:29 +0200
Message-ID: <20260817132549.004235825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
@@ -412,11 +412,8 @@ static void lx_trigger_start(struct lx64
 
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
@@ -1019,10 +1019,7 @@ static int lx_interrupt_request_new_buff
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


