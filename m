Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F0D473C8C;
	Fri,  7 Aug 2026 15:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117260; cv=none; b=TGtSpr/xC9ADEPzMRJ/clJ6Ypq8AWpYClqeFv21JeptNKcAuSdN+FGk/EMGSAI9VbFRJk10F/kIn7AEatbdgUlip85T6SCRel62CNAYg0axxQMx+mdvAApORScRxMbeVcANDxmpgBcWCbuYG5wnjpGkguZ3/HM3yURTkeFWp174=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117260; c=relaxed/simple;
	bh=cBRk+ZXtzAJsx+VFJCxs4k5ejCGGWsXHiT4MKg441aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmn9g/KndVQXPXYQ7lXYuJmzbwkRRVUOXT6OQd8zzzQ3wmN8jog+1WO8G/4xouRs1TuUADJs2+ALPp/98WNU7SbyaKWHFj5TbX6LWjsqaOhHAh98DbzkLQ9/xx3Wv2FoFQ7ferm2BahpSD1XA17gfmFCV0GGtsjf4rq8ewKG6Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1S9uZTgy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1S9uZTgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D881F000E9;
	Fri,  7 Aug 2026 15:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117259;
	bh=ecKZijCjF7q7WZa3MIYgvdk1URA59fpfHMlmzDMUi1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1S9uZTgyXQNVUNJKUlYMWb6GABFk5Xi0hPpemRWHkves3m5ky6sHC4cHFDB8PQMH9
	 C5tOKZGzwFOQcnkWWpq/0SkXfEDztzScgcb715w+fP7hyJVq4FVJ4wAX4Y6755f/Kt
	 L3uAdGFQFPOR6Qkv49Ln4SIp9CNvYAQVFn0pOCFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 254/438] ALSA: lx6464es: fix period byte count for 16-bit streams
Date: Fri,  7 Aug 2026 16:37:30 +0200
Message-ID: <20260807143433.411777842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -402,11 +402,8 @@ static void lx_trigger_start(struct lx64
 
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
@@ -969,10 +969,7 @@ static int lx_interrupt_request_new_buff
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


