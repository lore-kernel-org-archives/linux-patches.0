Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413E215748F;
	Mon, 30 Dec 2024 15:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574060; cv=none; b=Xcz1kjCCB4+WAiztbJCG0kNp/PoSmz5nzgJUZ53AEsXr+jcLz7+UIN1ZUP6hYNtIQaiGwEz9jP3T1uxqM4I+yp+EUFaafrTjtVWBn6TvmyT+MOu48tjTLcU7tgjR2o1ht5ZZgfeGQrZ9cgh6amWnxPJl0U/+OzR2lo+QV3mubxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574060; c=relaxed/simple;
	bh=mI2C/YjOh09MTm5Q0LBxfSFFeccVeUGJXiM2IEnSix8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmf9xE78h3EUZQmiZz23DeGNwQafNsYiA0rE4eESoflXM94aTzT3KSfgcU5k2z2ZI9E609Ob8ZjIR+aLTbGlYT7BGRBUefbf3drOrhJXxbBrQQY84LqDlmQ8ufz3E8a+6Mk2ye6+Hhs/yEnPJphuuADVzdSONBUW5h5E48JuLmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yq8LXwXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yq8LXwXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A092FC4CED0;
	Mon, 30 Dec 2024 15:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574060;
	bh=mI2C/YjOh09MTm5Q0LBxfSFFeccVeUGJXiM2IEnSix8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yq8LXwXCRac79J6KM0E/rYIfhqJp8RDaBI5XPchtarhkj11NBgcG8YhJ1qhrPpuTE
	 xKEOilk/1EqM6u3hWne9MpJfLxaWT1TGVKVzWWdQP0AmI6K/dgqcAALcTiJwPK8BN0
	 Ni6eLL1t89exsbteEw+xfZDB1Is7tfInzer/3UFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 027/114] ALSA: memalloc: prefer dma_mapping_error() over explicit address checking
Date: Mon, 30 Dec 2024 16:42:24 +0100
Message-ID: <20241230154219.112628379@linuxfoundation.org>
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit fa0308134d26dbbeb209a1581eea46df663866b6 upstream.

With CONFIG_DMA_API_DEBUG enabled, the following warning is observed:

DMA-API: snd_hda_intel 0000:03:00.1: device driver failed to check map error[device address=0x00000000ffff0000] [size=20480 bytes] [mapped as single]
WARNING: CPU: 28 PID: 2255 at kernel/dma/debug.c:1036 check_unmap+0x1408/0x2430
CPU: 28 UID: 42 PID: 2255 Comm: wireplumber Tainted: G  W L  6.12.0-10-133577cad6bf48e5a7848c4338124081393bfe8a+ #759
debug_dma_unmap_page+0xe9/0xf0
snd_dma_wc_free+0x85/0x130 [snd_pcm]
snd_pcm_lib_free_pages+0x1e3/0x440 [snd_pcm]
snd_pcm_common_ioctl+0x1c9a/0x2960 [snd_pcm]
snd_pcm_ioctl+0x6a/0xc0 [snd_pcm]
...

Check for returned DMA addresses using specialized dma_mapping_error()
helper which is generally recommended for this purpose by
Documentation/core-api/dma-api.rst.

Fixes: c880a5146642 ("ALSA: memalloc: Use proper DMA mapping API for x86 WC buffer allocations")
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Closes: https://lore.kernel.org/r/CABXGCsNB3RsMGvCucOy3byTEOxoc-Ys+zB_HQ=Opb_GhX1ioDA@mail.gmail.com/
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Link: https://patch.msgid.link/20241219203345.195898-1-pchelkin@ispras.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/memalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 13b71069ae18..b3853583d2ae 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -505,7 +505,7 @@ static void *snd_dma_wc_alloc(struct snd_dma_buffer *dmab, size_t size)
 	if (!p)
 		return NULL;
 	dmab->addr = dma_map_single(dmab->dev.dev, p, size, DMA_BIDIRECTIONAL);
-	if (dmab->addr == DMA_MAPPING_ERROR) {
+	if (dma_mapping_error(dmab->dev.dev, dmab->addr)) {
 		do_free_pages(dmab->area, size, true);
 		return NULL;
 	}
-- 
2.47.1



