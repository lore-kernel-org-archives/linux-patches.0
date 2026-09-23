Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30C7538D94;
	Wed, 23 Sep 2026 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174762; cv=none; b=E0oR/p+S7jh1e9g1sstCzX9TikmUru8hkYVc9u8Y0O6PkWUYx9TYCttG2+Kq8rv5FbKKACCprsKhyXEURDfUpT04Uy+zaXHpVSzTBiH1RcBorAe0fnTKTfblP+7kePDD/Ddiou/HqJe1GjQeitqtZR5PW7nqYL62jUQc04cPX0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174762; c=relaxed/simple;
	bh=oIPjjwBa68rlXYMeFnIF2F/vRO5Jwj4nSubVkRo0Nrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLLHGK8r4ypzKD2kVHo+5hPWOy0zT9BIQCv6kSnHlui0taWzPr6ktNBHlyEVLPLZmwgnlRPQW85ixGXCT0rdAviPGqt5DysZxXvAjNZgsk4hJuz2apvOdv76KZPiPmyh6ZtI2KylkQ8vbLvyYbMMAIPu0y/ljnrAZem7Tfgho4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bvq94PTM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bvq94PTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394051F000FF;
	Wed, 23 Sep 2026 14:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174760;
	bh=jYyoUH3B09NUSU3fwo8HolaFm36YhZ1lRQsxBKHZAu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bvq94PTMEgvWnYCJuG+LiAm67MRRfg3O/SOj2F1r0OiSBVXYkPkdvmwcWZ167f7R4
	 ZGdKXgqkdoLv8OUTAKcob5IHLzaDmS2AoVV0Zsntl/rAcJM74/vzGtOuisnEij6Xd3
	 oOvN7WLQa0tgp9eW0pRTzFy+BSdSHXLGnVERNmuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.18 218/398] swiotlb: use the adjusted address for the highmem page lookup
Date: Wed, 23 Sep 2026 16:04:52 +0200
Message-ID: <20260923140649.074022546@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -869,7 +869,6 @@ static void swiotlb_bounce(struct device
 	int index = (tlb_addr - mem->start) >> IO_TLB_SHIFT;
 	phys_addr_t orig_addr = mem->slots[index].orig_addr;
 	size_t alloc_size = mem->slots[index].alloc_size;
-	unsigned long pfn = PFN_DOWN(orig_addr);
 	unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
 	int tlb_offset;
 
@@ -899,7 +898,8 @@ static void swiotlb_bounce(struct device
 		size = alloc_size;
 	}
 
-	if (PageHighMem(pfn_to_page(pfn))) {
+	if (PhysHighMem(orig_addr)) {
+		unsigned long pfn = PFN_DOWN(orig_addr);
 		unsigned int offset = orig_addr & ~PAGE_MASK;
 		struct page *page;
 		unsigned int sz = 0;


