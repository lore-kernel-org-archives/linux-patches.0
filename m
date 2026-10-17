Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596733515E7;
	Sat, 17 Oct 2026 16:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253407; cv=none; b=OCe8h+RU4HA2GXlHTCzqCQ3PSAJHmxedOPvwIwZsMLMMLVVAUFDJ//mTuhgyRW//muT99FSE+JbzgGzseZ17iH64Oss7DPXZnYY42fZMVGk7KQX108YEQn+QxUCfqzQO5PhHQdun5bcTZBz2VRXZivojCLjv3Jdf17f3VFWNlq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253407; c=relaxed/simple;
	bh=F7ZDt8DreTIT0JOIN3Pq9e8eEMt+kmPc3qExxf9QmCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ef+jHj1YlCajWCePZijMsrDjZbJKSRoFajEAyTYUcbS/PsTsz2nPEi6QmSy9D943JvdHRq/ma7ag+e2AmvCTC41cyASdSqlbzUiQjsYL1ttZ2F/hSJnD73Y5Ljal5Mo1oulxPAvEAmC7DN1dh4K3fZIGdqjgch07G8vEC9Y4wLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZZTwHOa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZZTwHOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711991F000C4;
	Sat, 17 Oct 2026 16:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253406;
	bh=FzVjNNE70M3sk30Pxajj2oJUrCCQEF1mOsCkluautDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZZTwHOaofJNgFGu6bzpa2ID+DovRy4ekqPSutEMih+J4bVUMBS5NFPUluyy4I6b1
	 8IvOi7+Yg00WVl/JR1ILgp2tCRavAEff54S/uDHagG+jzE8b5JUVrpgKoqSkosovPX
	 Fw3w57fZun2MtjKdVtq8ymrUR0HIWwGIoNAwPK4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com,
	Harry Yoo <harry.yoo@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/869] mm/mremap: fix WARN with uffd that has remap events disabled
Date: Sat, 17 Oct 2026 17:49:07 +0200
Message-ID: <20261017160039.754168548@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 772e5b4a5e8360743645b9a466842d16092c4f94 ]

Registering userfaultd on a VMA that spans at least one PMD and then
mremap()'ing that VMA can trigger a WARN when recovering from a failed
page table move due to a page table allocation error.

The code ends up doing the right thing (recurse, avoiding moving actual
page tables), but triggering that WARN is unpleasant:

WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_normal_pmd mm/mremap.c:357 [inline]
WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_pgt_entry mm/mremap.c:595 [inline]
WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_page_tables+0x3832/0x44a0 mm/mremap.c:852
Modules linked in:
CPU: 2 UID: 0 PID: 6133 Comm: syz.0.19 Not tainted 6.17.0-rc1-syzkaller-00004-g53e760d89498 #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:move_normal_pmd mm/mremap.c:357 [inline]
RIP: 0010:move_pgt_entry mm/mremap.c:595 [inline]
RIP: 0010:move_page_tables+0x3832/0x44a0 mm/mremap.c:852
Code: ...
RSP: 0018:ffffc900037a76d8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000032930007 RCX: ffffffff820c6645
RDX: ffff88802e56a440 RSI: ffffffff820c7201 RDI: 0000000000000007
RBP: ffff888037728fc0 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000032930007 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc900037a79a8 R14: 0000000000000001 R15: dffffc0000000000
FS:  000055556316a500(0000) GS:ffff8880d68bc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30863fff CR3: 0000000050171000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 copy_vma_and_data+0x468/0x790 mm/mremap.c:1215
 move_vma+0x548/0x1780 mm/mremap.c:1282
 mremap_to+0x1b7/0x450 mm/mremap.c:1406
 do_mremap+0xfad/0x1f80 mm/mremap.c:1921
 __do_sys_mremap+0x119/0x170 mm/mremap.c:1977
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f00d0b8ebe9
Code: ...
RSP: 002b:00007ffe5ea5ee98 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
RAX: ffffffffffffffda RBX: 00007f00d0db5fa0 RCX: 00007f00d0b8ebe9
RDX: 0000000000400000 RSI: 0000000000c00000 RDI: 0000200000000000
RBP: 00007ffe5ea5eef0 R08: 0000200000c00000 R09: 0000000000000000
R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f00d0db5fa0 R14: 00007f00d0db5fa0 R15: 0000000000000005
 </TASK>

The underlying issue is that we recurse during the original page table
move, but not during the recovery move.

Fix it by checking for both VMAs and performing the check before the
pmd_none() sanity check.

Add a new helper where we perform+document that check for the PMD and PUD
level.

Thanks to Harry for bisecting.

Link: https://lkml.kernel.org/r/20250818175358.1184757-1-david@redhat.com
Fixes: 0cef0bb836e3 ("mm: clear uffd-wp PTE/PMD state on mremap()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/689bb893.050a0220.7f033.013a.GAE@google.com
Tested-by: Harry Yoo <harry.yoo@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 83c37ad39d345..8b507e228a274 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -281,15 +281,6 @@ static bool move_normal_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 	if (WARN_ON_ONCE(!pmd_none(*new_pmd)))
 		return false;
 
-	/* If this pmd belongs to a uffd vma with remap events disabled, we need
-	 * to ensure that the uffd-wp state is cleared from all pgtables. This
-	 * means recursing into lower page tables in move_page_tables(), and we
-	 * can reuse the existing code if we simply treat the entry as "not
-	 * moved".
-	 */
-	if (vma_has_uffd_without_event_remap(vma))
-		return false;
-
 	/*
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.
@@ -345,15 +336,6 @@ static bool move_normal_pud(struct vm_area_struct *vma, unsigned long old_addr,
 	if (WARN_ON_ONCE(!pud_none(*new_pud)))
 		return false;
 
-	/* If this pud belongs to a uffd vma with remap events disabled, we need
-	 * to ensure that the uffd-wp state is cleared from all pgtables. This
-	 * means recursing into lower page tables in move_page_tables(), and we
-	 * can reuse the existing code if we simply treat the entry as "not
-	 * moved".
-	 */
-	if (vma_has_uffd_without_event_remap(vma))
-		return false;
-
 	/*
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.
@@ -587,6 +569,7 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 	struct mmu_notifier_range range;
 	pmd_t *old_pmd, *new_pmd;
 	pud_t *old_pud, *new_pud;
+	bool uffd_supports_move;
 
 	if (!len)
 		return 0;
@@ -597,6 +580,22 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 		return move_hugetlb_page_tables(vma, new_vma, old_addr,
 						new_addr, len);
 
+	/*
+	 * If we are moving a VMA that has uffd-wp registered but with
+	 * remap events disabled (new VMA will not be registered with uffd), we
+	 * need to ensure that the uffd-wp state is cleared from all pgtables.
+	 * This means recursing into lower page tables in move_page_tables().
+	 *
+	 * We might get called with VMAs reversed when recovering from a
+	 * failed page table move. In that case, the
+	 * "old"-but-actually-"originally new" VMA during recovery will not have
+	 * a uffd context. Recursing into lower page tables during the original
+	 * move but not during the recovery move will cause trouble, because we
+	 * run into already-existing page tables. So check both VMAs.
+	 */
+	uffd_supports_move = !vma_has_uffd_without_event_remap(vma) &&
+			     !vma_has_uffd_without_event_remap(new_vma);
+
 	/*
 	 * If possible, realign addresses to PMD boundary for faster copy.
 	 * Only realign if the mremap copying hits a PMD boundary.
@@ -631,7 +630,8 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 				/* We ignore and continue on error? */
 				continue;
 			}
-		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PUD) && extent == PUD_SIZE) {
+		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PUD) &&
+			   extent == PUD_SIZE && uffd_supports_move) {
 
 			if (move_pgt_entry(NORMAL_PUD, vma, old_addr, new_addr,
 					   old_pud, new_pud, true))
@@ -654,7 +654,7 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 				continue;
 			split_huge_pmd(vma, old_pmd, old_addr);
 		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PMD) &&
-			   extent == PMD_SIZE) {
+			   extent == PMD_SIZE && uffd_supports_move) {
 			/*
 			 * If the extent is PMD-sized, try to speed the move by
 			 * moving at the PMD level if possible.
-- 
2.53.0



