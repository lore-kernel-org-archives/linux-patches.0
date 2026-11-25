Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624245;
	b=Z96hOpvVOLboUBRZSb+8e01nGCTmb3+HH0ZTWp7a3f3IhqRJh+nldGfGVxi5kdG+i93n
	 nvWBNztSTPK5ojYE70LgqhxFc0KYINYwAN3epHHAKXD2xShQ911t7kwuBIBhS6tu+ONlL
	 fXO/25hIaYSbMiA/jQ1U5Ia/Lf69SHjx9UTL9FWM6B5o1oH2kBWvhAknONmQ3qlOPHMYq
	 42XaFg1VSBtNL5D8l0xd0uZWl0zMO20dIZjg42wgGjPx/ix8DVFvVUDp9Fc+KE2nfuUzd
	 yh4qW2E3gFPzs31nALoZMXMMouAAuXdjjGdTbJD2vRamvtsVjTXkFXrNemEr79ztfsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QPyT0IpwxJzEzbfOxW1bLkDguaTBgBtR+HTjzM7D3Wk=;
	b=s7eQ5xmoOn04MahYLvRlCuvGUzhmm7Pa5uCtLGMMa2reGVT377qXDT4pyX8i9ASL4Aco
	 YUg3wqAe0ljGNEaJGUlxk/yXXTZ9IFhyTrpBI5mWi5LIE9exnNnd9RBOSfw79ELKo6sl2
	 A/HNIBtCa0+yLCcHcVJOljGSxzQD/K6mTNvgIYPS2ndJKRNvA7wbYd7/sjK8+uOXXFNGA
	 4MdhXhp32NYwX8RuyrHK1UILtrQBzE0PhjcrHnIW3PzT9GB/RL7p2CQKW/Zqzzr1kOTvb
	 558zCcZxfcOLxWnxDr5a6Cja1cM+j4PtZr6rYmL/pprfqSM/+blB2VkPw2CM3ueLuhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hzT+aeZz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81BB606A682;
	Wed, 25 Nov 2026 16:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hzT+aeZz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9551E1F000CA;
	Wed, 25 Nov 2026 16:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624245;
	bh=QPyT0IpwxJzEzbfOxW1bLkDguaTBgBtR+HTjzM7D3Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hzT+aeZzG+vCyMpwgl8d7g7TZVnSK8eGRx5uZFpb41i6RegjSKI8G2pjggHaA8Ctq
	 oz84CLgHCeLtZt4MMqfVzbPLd9rXxZQNyZuqIGUQKbmsJ4BOmEwMrXS2FLqmkko9QU
	 fd7U3YHx4lBHikpWafDmlYu9mU8Px8wBC8OFzcMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 085/816] ALSA: memalloc: Free the new pages when WC DMA mapping fails
Date: Wed, 25 Nov 2026 15:27:13 +0100
Message-ID: <20261125143851.188781297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



