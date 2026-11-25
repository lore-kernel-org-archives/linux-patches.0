Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621061;
	b=Mi7o8L8JT3pgVHmtmLZ7ald519tZKXueUFLVKp2S7b6wdghJEHHdCmznlRTWkLElci8R
	 C/S4JklkhKMlTAX1B54Z21ed3xE7RTjiI2VeSqmJUWPz3gMxJBeO7Cnned07Xl769WnxV
	 n1ePMJ2C/JKzj307pSyoB/wZXyS/s02Cew5DDrxCXkQt0t8GuYP+9nx1/ikTPFuUHHUwl
	 ikdjf0cG48OIVmTnKY6nf8UcgNjTp4B/1/u88Kxz//ZNHtWsRjfh2cjntndDo5jcOuflq
	 TNNGNocp57UvRCRgJUhQKrqgJlOWO4qnMI3ZNsiB4hVlAZyG3krjnzrhHSBg+gdK87A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cd/N2iywi6B//XbjqLbAXEgHMbHixYhgtfEcYmJoyrg=;
	b=ufdyhRe1oaB6C+12/nMeN2N4m0QvUdYKGr18kytGJVfan6JKuoz2SiedXtUl+DyM1HBv
	 4t83Y0L9XppVX5jW0mxWz5a8+ULA4SP0qkS66YYMJ1xbD9NkCjtTrsvtr6eokrzrOfg5G
	 N/uE1WmU8lLnFhCy/EuEisxv3cphwRdm9Y8falYWB/LehM7Og640CX3J03Pk968SVtb43
	 iOaIobQZ7xPaE62Kt0VEZCikpEKioSIAjwqjvtivls5EYyq40w7aTiD5AumzwKZnl0ltb
	 4EOjG3xMRMwYfyZ+hauL+QLPpeY0CSrgOdJ7XHo4clw7tyB3M0900pjGcvYZqR4xUTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ObAE02eN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDD1606A321;
	Wed, 25 Nov 2026 15:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ObAE02eN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964861F000C4;
	Wed, 25 Nov 2026 15:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621061;
	bh=Cd/N2iywi6B//XbjqLbAXEgHMbHixYhgtfEcYmJoyrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ObAE02eNfVH/O1mx/eOT0xCS5CwtkkUTM/GF1nWC2545PkuKOx9MVetnpIuRhpJD5
	 jPNReTi7z9nECxNlAYfm98SnV89132prFfaJsAxxf7U0dit8enqL1G/AvnraUvpeZA
	 POpYkPanvMRRIOhT1i1cuQFbH9LK529SwWmA80v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 106/990] ALSA: memalloc: Free the new pages when WC DMA mapping fails
Date: Wed, 25 Nov 2026 15:24:33 +0100
Message-ID: <20261125143824.572998242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit 016fe9695e6dc1322ddfe8c7dbc7b973483b4a24 ]

snd_dma_wc_alloc() keeps the newly allocated pages in a local variable,
and snd_dma_alloc_dir_pages() stores them in dmab->area only after
->alloc() returns.  If dma_map_single() fails, the error path passes
dmab->area to do_free_pages() instead, and that is still NULL at this
point for the usual callers.

The pages are then leaked with their write-combining attribute still
set, set_memory_wb() warns about the zero address, and for buffers
larger than a page free_pages_exact() goes on to free the struct pages
of the bogus addresses 4096, 8192 and so on.  With CONFIG_DEBUG_VM that
hits the VM_BUG_ON() in free_pages():

  kernel BUG at mm/page_alloc.c:5600!
  RIP: 0010:free_pages_exact+0xcb/0xd0
  Call Trace:
   snd_dma_wc_alloc+0x14f/0x160 [snd_pcm]
   snd_dma_alloc_dir_pages+0x4f/0x80 [snd_pcm]

This was reproduced on an x86 guest without swiotlb by allocating
SNDRV_DMA_TYPE_DEV_WC buffers for a device with a 24-bit streaming DMA
mask, so that dma_map_single() fails.

Free the pages that were just allocated.

Fixes: c880a5146642 ("ALSA: memalloc: Use proper DMA mapping API for x86 WC buffer allocations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261028144441.992127-1-sashal@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/memalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index b3853583d2ae1..e2887c9a24631 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -506,7 +506,7 @@ static void *snd_dma_wc_alloc(struct snd_dma_buffer *dmab, size_t size)
 		return NULL;
 	dmab->addr = dma_map_single(dmab->dev.dev, p, size, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dmab->dev.dev, dmab->addr)) {
-		do_free_pages(dmab->area, size, true);
+		do_free_pages(p, size, true);
 		return NULL;
 	}
 	return p;
-- 
2.53.0



