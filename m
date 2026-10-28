Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216283;
	b=o7r5TXAguNKbx8mfEwUMSzNDNbsnyYQ8xAcjWD6QOeQT9VTjTQh/xRYN59sjjkevbkzR
	 1JGR9wmpNA2fskAwtkEPGVw4FJ//NhK6DdyqXYJ3WPL2mKsXPNKGdJu0HApatEFpbBAXg
	 Fgyv8k02Hi3AbVRUAABdamPhHMOvBaDuCwXzw3eqUCQNYA9gf6hoZHoliHjMF8qml8qVM
	 dNaBY9AjyemvCmbrWMy3/4gcvExp5NykMJgbsQA38s8MIF9D8yy9C5pFHSYPekUxkLn7H
	 Gkdyi758KsOSWxS/TWezhO4EQAk7p6Ur6CLiQG/uKhGDXg4l0eZiVXkwGrAt3epRFgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XPWN9KptCdgTar7b/i/6R8wvff6YcIRr0hi6YKF1CVU=;
	b=1M38ZEVObyxf0uAb4EHm4ARcYV0ZQhgwJ2bpcLldeZRGgqI2GIWYC1ang/6dFByyoHSP
	 HgVz+HWSfXU1JeO6ruF2RSIa9+qtUQlKCkJQkuwRVrT9NA+yv+uLvjoXUYsDYQbahbxwf
	 mSYPqlMT6Nt2TWdfAKufhPfIzTwxov7/VHaCH8XvsNE0qosGeqh1tsfVGw5KpGEZdmTeq
	 iGdeUvS40qFSQwspewWdwPxwLJdyumqJUVlBCFrAqNUXL1y7Z+WPi5YCQM/T/Hrp8LMiu
	 CrUyqW1wRqC1S1QOBoFy0MZLVZ25bHMQd29+s92oqB9QFARfbwMC+XYy33wYXPBLWKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HEVkWgy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92AA606A31A;
	Wed, 28 Oct 2026 19:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HEVkWgy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66A01F01825;
	Wed, 28 Oct 2026 19:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216282;
	bh=XPWN9KptCdgTar7b/i/6R8wvff6YcIRr0hi6YKF1CVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HEVkWgyaU86AnmY/KLfp6rwxdnYvDP4ZYV6WEJhv0UaN3dosPm82SN9ZwgoFdBbu
	 cdzSxT0qFnkuHzk+DxB27h8m68346TzVOs7F/pHQ95vsxw4i9mMsoyd13fPuah5swu
	 C+3wDlRevDch0J0qU4mhSPG6rvVuRJxQDfEuKXcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1502/1887] dma-direct: simplify the use atomic pool logic in dma_direct_alloc
Date: Wed, 28 Oct 2026 17:59:58 +0100
Message-ID: <20261028170533.639823286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit b1da46d70e5427a9ba5eae28bcca29a20e68a442 ]

The logic in dma_direct_alloc when to use the atomic pool vs remapping
grew a bit unreadable.  Consolidate it into a single check, and clean
up the set_uncached vs remap logic a bit as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Greg Ungerer <gerg@linux-m68k.org>
Tested-by: Greg Ungerer <gerg@linux-m68k.org>
Stable-dep-of: 94a04ad732c9 ("dma-direct: return struct page from dma_direct_alloc_from_pool()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index d6871a3fe5f6a..621a711224574 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -240,27 +240,22 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 					dma_handle);
 
 		/*
-		 * Otherwise remap if the architecture is asking for it.  But
-		 * given that remapping memory is a blocking operation we'll
-		 * instead have to dip into the atomic pools.
+		 * Otherwise we require the architecture to either be able to
+		 * mark arbitrary parts of the kernel direct mapping uncached,
+		 * or remapped it uncached.
 		 */
+		set_uncached = IS_ENABLED(CONFIG_ARCH_HAS_DMA_SET_UNCACHED);
 		remap = IS_ENABLED(CONFIG_DMA_DIRECT_REMAP);
-		if (remap) {
-			if (dma_direct_use_pool(dev, gfp))
-				return dma_direct_alloc_from_pool(dev, size,
-						dma_handle, gfp);
-		} else {
-			if (!IS_ENABLED(CONFIG_ARCH_HAS_DMA_SET_UNCACHED))
-				return NULL;
-			set_uncached = true;
-		}
+		if (!set_uncached && !remap)
+			return NULL;
 	}
 
 	/*
-	 * Decrypting memory may block, so allocate the memory from the atomic
-	 * pools if we can't block.
+	 * Remapping or decrypting memory may block, allocate the memory from
+	 * the atomic pools instead if we aren't allowed block.
 	 */
-	if (force_dma_unencrypted(dev) && dma_direct_use_pool(dev, gfp))
+	if ((remap || force_dma_unencrypted(dev)) &&
+	    dma_direct_use_pool(dev, gfp))
 		return dma_direct_alloc_from_pool(dev, size, dma_handle, gfp);
 
 	/* we always manually zero the memory once we are done */
-- 
2.53.0



