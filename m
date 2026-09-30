Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B0530D401;
	Wed, 30 Sep 2026 19:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796342; cv=none; b=aIAEsdm8VIOzhtEp093yAP4ciCBodHfq/G+ejBFHRl5LlAK94RZGjOMdysodHL7tD/FINyTSwkrQL5LK1w/ftrxrhgUTeKWQUbbySG6d8qdumcGqUBSWPAVmj79RwYnzY7W9xn952MY/r/pl7KG/ic7H7tFlf8kmlu1PdhyyNrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796342; c=relaxed/simple;
	bh=lF62djY9+O06wkY4Jt5Kwt3YNMOjbqeH+fkCC6oWp/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0ItYPbW7ZLjk8UxGzzeVbwSzK3vVFLvF0wk4RBfU3l/SIwB5weQBMKC12plAHXnKZzbacRn+P0HYs4JU1lSS5gQaS14lK5eiwx6/Ut890NqV4TVf51yzPuxnCknJ9DCGby0dTC0SNNIz6SFylipmaO7Gc8PpujKe57GsQ2vb0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Fph8Pbi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Fph8Pbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB521F000FF;
	Wed, 30 Sep 2026 19:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796340;
	bh=stzqi4lXo7fFqX5U+Qfz2N0mOfj8aVB+ULWTIfYVHWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Fph8Pbi2rYthbXAnjSMZLBBHDo3GTyt9bapPGBE9kQFLjLJkBEWV/GIKkizQTg31
	 CUPwZviAKZULv42rCn/AX/IqFr8Ti5CBL9afC0RRPr+7bDWFq26utEQ47Ip4oIHILt
	 ci2GiReDQrH186p4exfzeDdNFJcEfxLcGwBTCcrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhei Takeshita <jyohuku.alterego@gmail.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.6 0879/1193] IB/hfi1: Fix the PIO_CRED credit-return mmap
Date: Wed, 30 Sep 2026 17:26:03 +0200
Message-ID: <20260930152453.773024391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuhei Takeshita <jyohuku.alterego@gmail.com>

commit 62f0f34fbd2b2d5653d33d3b9d42fdcabb1c0101 upstream.

hfi1_file_mmap()'s PIO_CRED case must hand user space the single
credit-return page that holds this context's entry.  That page is the
second or third page of the per-node credit-return allocation once the
hardware send context index reaches 64 or 128, so the failure below is
intermittent: when the entry lands on the first page the offset is zero
and everything works.

Two things are wrong.

First, cr_page_offset is a byte offset but .va is a struct
credit_return *, so adding it is pointer arithmetic and scales the offset
by sizeof(struct credit_return) == 64.  memvirt then lands 256 KiB or
512 KiB past a 10240-byte allocation.  With an IOMMU translating, that
address is inside the vmalloc range but in no vm_area, so
dma_mmap_coherent() -> iommu_dma_mmap() finds no pages, vmalloc_to_pfn()
returns page_to_pfn(NULL), and remap_pfn_range() installs a frame above
MAXPHYADDR.  The first user read then takes:

  psm2_ep_open_pr: Corrupted page table at address 7a14d007e000
  PGD 800000013886a067 P4D 800000013886a067 PUD 13886b067 PMD 13886c067
                                            PTE 800049168e911235
  Oops: Bad pagetable: 000d [#1] SMP PTI

Second, and still wrong once the arithmetic is corrected,
dma_mmap_coherent() describes a whole coherent buffer and selects the
page within it with vma->vm_pgoff.  Offsetting cpu_addr has no effect:
for a vmap'd allocation iommu_dma_mmap() uses cpu_addr only to locate the
vm_area and then maps pages[vm_pgoff], which hfi1_file_mmap() has just
set to 0.  User space therefore always receives the first credit-return
page, every credit read is for the wrong context, and send PIO stalls
forever.

Use the DMA API as intended: pass the base of the allocation with its
full length and select the page with vm_pgoff.  A separate length is
needed because memlen must keep describing the VMA for the existing size
check.  The dma-direct path stays correct as well, since dma_direct_mmap()
adds the same vm_pgoff to the base pfn.

Tested on a Dell T7610 (Xeon E5-2650 v2, Intel IOMMU in DMA-FQ mode)
against a Threadripper PRO 3995WX peer, both Omni-Path 100.  Before this
change psm2_ep_open() Oopses the kernel; with only the arithmetic
corrected psm2_ep_open() succeeds but any transfer that uses send PIO
hangs, PSM2_SDMA=2 (send PIO disabled) completing normally while
PSM2_SDMA=0 (send PIO only) hangs every time.  With this change send PIO,
send DMA and the default mixed mode all work.

Fixes: 1ec82317a1da ("IB/hfi1: Use dma_mmap_coherent for matching buffers")
Cc: stable@vger.kernel.org
Signed-off-by: Shuhei Takeshita <jyohuku.alterego@gmail.com>
Link: https://patch.msgid.link/20260809032743.2671579-3-jyohuku.alterego@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -326,6 +326,7 @@ static int hfi1_file_mmap(struct file *f
 	void *memvirt = NULL;
 	dma_addr_t memdma = 0;
 	u8 subctxt, mapio = 0, vmf = 0, type;
+	size_t memdmalen = 0;
 	ssize_t memlen = 0;
 	int ret = 0;
 	u16 ctxt;
@@ -371,7 +372,9 @@ static int hfi1_file_mmap(struct file *f
 		mapio = 1;
 		break;
 	case PIO_CRED: {
+		struct credit_return_base *cr = &dd->cr_base[uctxt->sc->node];
 		u64 cr_page_offset;
+
 		if (flags & VM_WRITE) {
 			ret = -EPERM;
 			goto done;
@@ -381,11 +384,18 @@ static int hfi1_file_mmap(struct file *f
 		 * second or third page allocated for credit returns (if number
 		 * of enabled contexts > 64 and 128 respectively).
 		 */
-		cr_page_offset = ((u64)uctxt->sc->hw_free -
-				  (u64)dd->cr_base[uctxt->sc->node].va) &
+		cr_page_offset = ((u64)uctxt->sc->hw_free - (u64)cr->va) &
 				 PAGE_MASK;
-		memvirt = dd->cr_base[uctxt->sc->node].va + cr_page_offset;
-		memdma = dd->cr_base[uctxt->sc->node].dma + cr_page_offset;
+		/*
+		 * dma_mmap_coherent() describes the whole coherent buffer and
+		 * selects the page within it with vma->vm_pgoff, so pass the
+		 * base of the allocation and its length and let vm_pgoff pick
+		 * the page.
+		 */
+		vma->vm_pgoff = cr_page_offset >> PAGE_SHIFT;
+		memvirt = cr->va;
+		memdma = cr->dma;
+		memdmalen = TXE_NUM_CONTEXTS * sizeof(struct credit_return);
 		memlen = PAGE_SIZE;
 		flags &= ~VM_MAYWRITE;
 		flags |= VM_DONTCOPY | VM_DONTEXPAND;
@@ -567,7 +577,8 @@ static int hfi1_file_mmap(struct file *f
 		ret = 0;
 	} else if (memdma) {
 		ret = dma_mmap_coherent(&dd->pcidev->dev, vma,
-					memvirt, memdma, memlen);
+					memvirt, memdma,
+					memdmalen ? memdmalen : memlen);
 	} else if (mapio) {
 		ret = io_remap_pfn_range(vma, vma->vm_start,
 					 PFN_DOWN(memaddr),


