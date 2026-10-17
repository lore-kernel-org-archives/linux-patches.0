Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2DC3B8124;
	Sat, 17 Oct 2026 17:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258775; cv=none; b=V4cSj8aaPTspseap3sPGTU4HbisCSZCaBUNkyuA4c5ZA27ETc26WOHcMImk8/Xt9bG9Uge+PBcp2lLF0YBeLuIn4oXAB69/kHc9cDGN57258XWEbZSTzkK95yNTtmRW64c6FiComIktNJRXRo1w2mpb9HKgKh7qyHQSb2w3/nlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258775; c=relaxed/simple;
	bh=HLczCx/gKTe0rXXNk80aDzAej6NtluX/9gcFQvFuRCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLOGGK4AZvW3JTh3ti+ybHhmM5rnroiUdi6HKx26Fg3jrfP7U7UeM/BLXNXvvhAH4bGx52SHl8sGxsbxeX+0hYHMNfsJ2FyleAW5pzi7x4fRgP/2WoIu6NHUIHDJd5ZX4N4JVgAGZC1TzbjPBhW8IAkdyoTCXJvvnGp62ejnGBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0CNOUhn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0CNOUhn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39B01F000C4;
	Sat, 17 Oct 2026 17:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258774;
	bh=uG/gqUAYLL5YayeUdXF9YL554aTeyIA8TsjO6p8/C8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A0CNOUhnT91F5Be7CotIIz5ZNkZ/015fogDcKSXPStWorQAQmwvFbNLmE4xyscSiv
	 OkiaEEtox5U/YdXaz9sNzCWFw+4QDEUKxSeXYFWE16bg79chzHQJd+Ot1nJhbSgS/X
	 YoZLEJ/VpvYDJo4x9DBGRqO0gbLVfHSyebXVFR/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0995/1674] powerpc/pgtable-frag: Fix bad page state in pte_frag_destroy
Date: Sat, 17 Oct 2026 17:54:27 +0200
Message-ID: <20261017160456.656981898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 8c31802f97e82..01600cac89dcd 100644
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



