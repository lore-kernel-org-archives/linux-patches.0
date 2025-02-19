Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D881F8BDD;
	Wed, 19 Feb 2025 08:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954835; cv=none; b=O7fKunmzVzsJBUIoweo4RNG+t4yCUzhcyG6k38gn2zYRKDLhqLApBu0IRH55QeeaKI6qrAn326NHgcIpmTOzF+xJU1ZYRh2+M2UefAshypb6GOWTz80rkteOVgIriPjLmDpRSS9uw72e0mLR2/5K6n0GvIJq+sEdJ/E2MDrx05s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954835; c=relaxed/simple;
	bh=a76bHN6abmqKFKTmGaq+QCFPbFlQklVislZFyonKF2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1ZLnadhxVh38mb5V/xDbM/4PgOQYdZ1h25CWCEe4djzEEPc5PU+K8Libwzs2Rzh0eO1xfH7mD9I8SIA5f3rfzEDcb48yHBYGtQjNwqIvZJwHTsAWz0s9MMbFBaGtmVHwAG3eE+l3LndWqfcpg5+25N2h3Km8EaLqesGNp1G1gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgmBfVey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgmBfVey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85CEC4CED1;
	Wed, 19 Feb 2025 08:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954835;
	bh=a76bHN6abmqKFKTmGaq+QCFPbFlQklVislZFyonKF2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DgmBfVey+aS/yoxqryDrBP9KyN6Ax5UecdrM69jM1Tgq6T96qufJEAuRPNrGwX0OA
	 0SKCR0GqIH+VLuUKRhj/Fq7o45UrNb5ycRHsi0zSjbNCEDtf6xxjUYtKHYQnJLrBVN
	 qIurcukISHcUEoquEopZb3yBQu5xnhQ6OyumhpMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Alan Robinson <Alan.Robinson@fujitsu.com>,
	Jan Beulich <jbeulich@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/230] x86/xen: allow larger contiguous memory regions in PV guests
Date: Wed, 19 Feb 2025 09:26:08 +0100
Message-ID: <20250219082603.705789601@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit e93ec87286bd1fd30b7389e7a387cfb259f297e3 ]

Today a PV guest (including dom0) can create 2MB contiguous memory
regions for DMA buffers at max. This has led to problems at least
with the megaraid_sas driver, which wants to allocate a 2.3MB DMA
buffer.

The limiting factor is the frame array used to do the hypercall for
making the memory contiguous, which has 512 entries and is just a
static array in mmu_pv.c.

In order to not waste memory for non-PV guests, put the initial
frame array into .init.data section and dynamically allocate an array
from the .init_after_bootmem hook of PV guests.

In case a contiguous memory area larger than the initially supported
2MB is requested, allocate a larger buffer for the frame list. Note
that such an allocation is tried only after memory management has been
initialized properly, which is tested via a flag being set in the
.init_after_bootmem hook.

Fixes: 9f40ec84a797 ("xen/swiotlb: add alignment check for dma buffers")
Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Alan Robinson <Alan.Robinson@fujitsu.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/mmu_pv.c | 71 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 62 insertions(+), 9 deletions(-)

diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index 55a4996d0c04f..ffdf0d299c5d7 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -111,6 +111,51 @@ static pud_t level3_user_vsyscall[PTRS_PER_PUD] __page_aligned_bss;
  */
 static DEFINE_SPINLOCK(xen_reservation_lock);
 
+/* Protected by xen_reservation_lock. */
+#define MIN_CONTIG_ORDER 9 /* 2MB */
+static unsigned int discontig_frames_order = MIN_CONTIG_ORDER;
+static unsigned long discontig_frames_early[1UL << MIN_CONTIG_ORDER] __initdata;
+static unsigned long *discontig_frames __refdata = discontig_frames_early;
+static bool discontig_frames_dyn;
+
+static int alloc_discontig_frames(unsigned int order)
+{
+	unsigned long *new_array, *old_array;
+	unsigned int old_order;
+	unsigned long flags;
+
+	BUG_ON(order < MIN_CONTIG_ORDER);
+	BUILD_BUG_ON(sizeof(discontig_frames_early) != PAGE_SIZE);
+
+	new_array = (unsigned long *)__get_free_pages(GFP_KERNEL,
+						      order - MIN_CONTIG_ORDER);
+	if (!new_array)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&xen_reservation_lock, flags);
+
+	old_order = discontig_frames_order;
+
+	if (order > discontig_frames_order || !discontig_frames_dyn) {
+		if (!discontig_frames_dyn)
+			old_array = NULL;
+		else
+			old_array = discontig_frames;
+
+		discontig_frames = new_array;
+		discontig_frames_order = order;
+		discontig_frames_dyn = true;
+	} else {
+		old_array = new_array;
+	}
+
+	spin_unlock_irqrestore(&xen_reservation_lock, flags);
+
+	free_pages((unsigned long)old_array, old_order - MIN_CONTIG_ORDER);
+
+	return 0;
+}
+
 /*
  * Note about cr3 (pagetable base) values:
  *
@@ -812,6 +857,9 @@ static void __init xen_after_bootmem(void)
 	SetPagePinned(virt_to_page(level3_user_vsyscall));
 #endif
 	xen_pgd_walk(&init_mm, xen_mark_pinned, FIXADDR_TOP);
+
+	if (alloc_discontig_frames(MIN_CONTIG_ORDER))
+		BUG();
 }
 
 static void xen_unpin_page(struct mm_struct *mm, struct page *page,
@@ -2199,10 +2247,6 @@ void __init xen_init_mmu_ops(void)
 	memset(dummy_mapping, 0xff, PAGE_SIZE);
 }
 
-/* Protected by xen_reservation_lock. */
-#define MAX_CONTIG_ORDER 9 /* 2MB */
-static unsigned long discontig_frames[1<<MAX_CONTIG_ORDER];
-
 #define VOID_PTE (mfn_pte(0, __pgprot(0)))
 static void xen_zap_pfn_range(unsigned long vaddr, unsigned int order,
 				unsigned long *in_frames,
@@ -2319,18 +2363,25 @@ int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
 				 unsigned int address_bits,
 				 dma_addr_t *dma_handle)
 {
-	unsigned long *in_frames = discontig_frames, out_frame;
+	unsigned long *in_frames, out_frame;
 	unsigned long  flags;
 	int            success;
 	unsigned long vstart = (unsigned long)phys_to_virt(pstart);
 
-	if (unlikely(order > MAX_CONTIG_ORDER))
-		return -ENOMEM;
+	if (unlikely(order > discontig_frames_order)) {
+		if (!discontig_frames_dyn)
+			return -ENOMEM;
+
+		if (alloc_discontig_frames(order))
+			return -ENOMEM;
+	}
 
 	memset((void *) vstart, 0, PAGE_SIZE << order);
 
 	spin_lock_irqsave(&xen_reservation_lock, flags);
 
+	in_frames = discontig_frames;
+
 	/* 1. Zap current PTEs, remembering MFNs. */
 	xen_zap_pfn_range(vstart, order, in_frames, NULL);
 
@@ -2354,12 +2405,12 @@ int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
 
 void xen_destroy_contiguous_region(phys_addr_t pstart, unsigned int order)
 {
-	unsigned long *out_frames = discontig_frames, in_frame;
+	unsigned long *out_frames, in_frame;
 	unsigned long  flags;
 	int success;
 	unsigned long vstart;
 
-	if (unlikely(order > MAX_CONTIG_ORDER))
+	if (unlikely(order > discontig_frames_order))
 		return;
 
 	vstart = (unsigned long)phys_to_virt(pstart);
@@ -2367,6 +2418,8 @@ void xen_destroy_contiguous_region(phys_addr_t pstart, unsigned int order)
 
 	spin_lock_irqsave(&xen_reservation_lock, flags);
 
+	out_frames = discontig_frames;
+
 	/* 1. Find start MFN of contiguous extent. */
 	in_frame = virt_to_mfn((void *)vstart);
 
-- 
2.39.5



