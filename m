Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3FF5328C6;
	Wed, 23 Sep 2026 14:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173589; cv=none; b=VqtMZlH+eJ9nPpRv78xf5nlT+Jp5Sa8ZPJz26qUqbtXXeyiKmd2koSe1zBzVWz/LKssRIQWhY6XlJoqL6fzQq07zm+nyWa0XlciG8LVBzZHKoYWR5SRZvjkjJ2HwGKw5vV3fFcVeeL3rCgBbu+a5k4ZiLAB70rS3k5lbIbO6lxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173589; c=relaxed/simple;
	bh=9rsQi8gGJSPSzQhT//l9Clrj3EroHQ1iYFvz4MMBlCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJG5LmiA6ylR5Iu/AevH6nx0yRkRS6bWVWsMY4rE8FPtIrMCLQaXKRD991Te3MkPAxVF2eE39xVRcX4Vu4dB80lKlI1BlTclpKQIfHqaa47h0GX33H3w5W0UWpvFhMcUC7p1xnPGhD2AqHLLKs1YMnDQjZWFgp66C3FvWXK4EeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvmXuW+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvmXuW+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E5A1F000FF;
	Wed, 23 Sep 2026 14:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173588;
	bh=ZmvtnhzXXzqExaEiJSzwu1fdy1Mwl5K462P1C9476cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qvmXuW+GR2kJ1Y5cGXEZHb7i7tsVFWkdaQ3bkSkeS5HMrzcONTk7PYXBbzXqOsGVK
	 9Tv6qkR09HgDTEUl0vfsCnfIDPVHsaIEwTec2EVPhwbiBJh5mbjPHqQEFodGQVLjOz
	 iVnOJdSjo9my7L8+r3+L37TjWtBq8htPNERJkNfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 7.2 260/438] swiotlb: use the adjusted address for the highmem page lookup
Date: Wed, 23 Sep 2026 16:04:41 +0200
Message-ID: <20260923140651.513107972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit b7d7914a9ae3097e63d113007e4fb44d33d515b1 upstream.

swiotlb_bounce() reads the page frame number from the slot's recorded
orig_addr, then advances orig_addr by tlb_offset to reach the address
the caller asked about. The highmem branch mixes the two: the offset
within the page comes from the adjusted address, the page from the value
before it.

Once the adjustment crosses a page boundary the pair no longer describes
one location, and the whole copy lands one page below the intended one
for a positive tlb_offset, one above for a negative one. DMA_FROM_DEVICE
writes the device data over the wrong page and leaves the intended one
stale, DMA_TO_DEVICE feeds the device from a page the mapping may not
cover. Partial syncs through dma_sync_single_range_for_*() are what make
tlb_offset non-zero.

The branch test is picked the same way, so a slot recorded in lowmem can
be adjusted into highmem and the lowmem path then hands a highmem
address to phys_to_virt().

Take both from orig_addr once it is final and keep pfn in the branch
that uses it. PhysHighMem() asks the question straight from the address,
as dma-debug already does.

Fixes: 5f89468e2f06 ("swiotlb: manipulate orig_addr when tlb_addr has offset")
Cc: stable@vger.kernel.org
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/20260905084210.148255-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/swiotlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -867,7 +867,6 @@ static void swiotlb_bounce(struct device
 	int index = (tlb_addr - mem->start) >> IO_TLB_SHIFT;
 	phys_addr_t orig_addr = mem->slots[index].orig_addr;
 	size_t alloc_size = mem->slots[index].alloc_size;
-	unsigned long pfn = PFN_DOWN(orig_addr);
 	unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
 	int tlb_offset;
 
@@ -900,7 +899,8 @@ static void swiotlb_bounce(struct device
 		size = alloc_size;
 	}
 
-	if (PageHighMem(pfn_to_page(pfn))) {
+	if (PhysHighMem(orig_addr)) {
+		unsigned long pfn = PFN_DOWN(orig_addr);
 		unsigned int offset = orig_addr & ~PAGE_MASK;
 		struct page *page;
 		unsigned int sz = 0;


