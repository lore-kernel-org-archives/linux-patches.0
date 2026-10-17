Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA4517BED0;
	Sat, 17 Oct 2026 16:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254054; cv=none; b=Z7rdEm26N8WvZA2Waa+oZ/cvRTEkoYDma9ls+sQpp4OYmW2P8HMAe3vsDahnN/BJYGp2pPoHjAdNqiy2iMraRaxbE0zTQoaG9oHJ+wmeD9Orv7JxSrfYL/tiHqjYXaT4FJwbvFQfc0bq98IPGRq1tonJs3aLrJVJMud0ouUCoDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254054; c=relaxed/simple;
	bh=0tXPbNJT/lkTexsrN+evFq4FMIpAffFW0K493wYsbyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+vmRIkyDQyY5E7Iwu/ABEl49gHJe70dCRgf+89tPGebRe/sgQt9twig/R0WDC87J65AubWKCJHx9EYKKplSLrnoS902yvfwon8N0t+N/FBhvoFQoJhiXzpqaW2YGz5bjVS3Jwgzl/vo+v1Iehaqq87bekyx2mGELzDLb2bcuiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjuF0EkH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjuF0EkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631261F000C4;
	Sat, 17 Oct 2026 16:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254052;
	bh=BMCPt6HTbo/gXWaM2Mw4LM88GpKZdnrcv/v2bMvf03A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjuF0EkH4yhDIuXMYDWQ7H2v4ISqvg0GQWquD9fezRD2cwL3Z6EdpDKrGLKXD+pkx
	 QYniAnAAIsambC3UyGQgUA4W/hIM6UQJrNFHJVBb1qbL5N8ZJYs55fw2ZU99quhmHM
	 dl55yJcCcwE3oe73wQ6bpCD6y8QLaZircHhXpyVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 319/869] powerpc/pgtable-frag: Fix bad page state in pte_frag_destroy
Date: Sat, 17 Oct 2026 17:52:40 +0200
Message-ID: <20261017160045.255478293@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

[ Upstream commit fda4d71651f71c44b35829d13f3c8bf920032f77 ]

powerpc uses pt_frag_refcount as a reference counter for tracking it's
pte and pmd page table fragments. For PTE table, in case of Hash with
64K pagesize, we have 16 fragments of 4K size in one 64K page.

Patch series [1] "mm: free retracted page table by RCU"
added pte_free_defer() to defer the freeing of PTE tables when
retract_page_tables() is called for madvise MADV_COLLAPSE on shmem
range.
[1]: https://lore.kernel.org/all/7cd843a9-aa80-14f-5eb2-33427363c20@google.com/

pte_free_defer() sets the active flag on the corresponding fragment's
folio & calls pte_fragment_free(), which reduces the pt_frag_refcount.
When pt_frag_refcount reaches 0 (no active fragment using the folio), it
checks if the folio active flag is set, if set, it calls call_rcu to
free the folio, it the active flag is unset then it calls pte_free_now().

Now, this can lead to following problem in a corner case...

[  265.351553][  T183] BUG: Bad page state in process a.out  pfn:20d62
[  265.353555][  T183] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20d62
[  265.355457][  T183] flags: 0x3ffff800000100(active|node=0|zone=0|lastcpupid=0x7ffff)
[  265.358719][  T183] raw: 003ffff800000100 0000000000000000 5deadbeef0000122 0000000000000000
[  265.360177][  T183] raw: 0000000000000000 c0000000119caf58 00000000ffffffff 0000000000000000
[  265.361438][  T183] page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
[  265.362572][  T183] Modules linked in:
[  265.364622][  T183] CPU: 0 UID: 0 PID: 183 Comm: a.out Not tainted 6.18.0-rc3-00141-g1ddeaaace7ff-dirty #53 VOLUNTARY
[  265.364785][  T183] Hardware name: IBM pSeries (emulated by qemu) POWER10 (architected) 0x801200 0xf000006 of:SLOF,git-ee03ae pSeries
[  265.364908][  T183] Call Trace:
[  265.364955][  T183] [c000000011e6f7c0] [c000000001cfaa18] dump_stack_lvl+0x130/0x148 (unreliable)
[  265.365202][  T183] [c000000011e6f7f0] [c000000000794758] bad_page+0xb4/0x1c8
[  265.365384][  T183] [c000000011e6f890] [c00000000079c020] __free_frozen_pages+0x838/0xd08
[  265.365554][  T183] [c000000011e6f980] [c0000000000a70ac] pte_frag_destroy+0x298/0x310
[  265.365729][  T183] [c000000011e6fa30] [c0000000000aa764] arch_exit_mmap+0x34/0x218
[  265.365912][  T183] [c000000011e6fa80] [c000000000751698] exit_mmap+0xb8/0x820
[  265.366080][  T183] [c000000011e6fc30] [c0000000001b1258] __mmput+0x98/0x300
[  265.366244][  T183] [c000000011e6fc80] [c0000000001c81f8] do_exit+0x470/0x1508
[  265.366421][  T183] [c000000011e6fd70] [c0000000001c95e4] do_group_exit+0x88/0x148
[  265.366602][  T183] [c000000011e6fdc0] [c0000000001c96ec] pid_child_should_wake+0x0/0x178
[  265.366780][  T183] [c000000011e6fdf0] [c00000000003a270] system_call_exception+0x1b0/0x4e0
[  265.366958][  T183] [c000000011e6fe50] [c00000000000d05c] system_call_vectored_common+0x15c/0x2ec

The bad page state error occurs when such a folio gets freed (with
active flag set), from do_exit() path in parallel.

... this can happen when the pte fragment was allocated from this folio,
but when all the fragments get freed, the pte_frag_refcount still had some
unused fragments. Now, if this process exits, with such folio as it's cached
pte_frag in mm->context, then during pte_frag_destroy(), we simply call
pagetable_dtor() and pagetable_free(), meaning it doesn't clear the
active flag. This, can lead to the above bug. Since we are anyway in
do_exit() path, then if the refcount is 0, then I guess it should be
ok to simply clear the folio active flag before calling pagetable_dtor()
& pagetable_free().

Fixes: 32cc0b7c9d50 ("powerpc: add pte_free_defer() for pgtables sharing page")
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/ee13e7f99b8f258019da2b37655b998e73e5ef8b.1773078178.git.ritesh.list@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/pgtable-frag.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/mm/pgtable-frag.c b/arch/powerpc/mm/pgtable-frag.c
index e89f64a0f24ae..2d817d95db80f 100644
--- a/arch/powerpc/mm/pgtable-frag.c
+++ b/arch/powerpc/mm/pgtable-frag.c
@@ -25,6 +25,7 @@ void pte_frag_destroy(void *pte_frag)
 	count = ((unsigned long)pte_frag & ~PAGE_MASK) >> PTE_FRAG_SIZE_SHIFT;
 	/* We allow PTE_FRAG_NR fragments from a PTE page */
 	if (atomic_sub_and_test(PTE_FRAG_NR - count, &ptdesc->pt_frag_refcount)) {
+		folio_clear_active(ptdesc_folio(ptdesc));
 		pagetable_pte_dtor(ptdesc);
 		pagetable_free(ptdesc);
 	}
-- 
2.53.0



