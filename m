Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3984637DEBE;
	Sat, 17 Oct 2026 16:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253120; cv=none; b=aF70PhYjBpDq9PXDgag4sXrGZz/rmwk1+y7TLaIUXpuxfZXGdUrILdDP9deosZs8PIKTEC+4sm/Jjt+X9d83+FZuKJQ8+u1a4rZ3B+ZeirhtIFkIjADIwFqHOg/sXbZxiD7b5eHpEw5xXFNDAOs8KQk7/3NMimh5sPF1aa4IJVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253120; c=relaxed/simple;
	bh=h4ANy34ctrYTQ6G0+69hIxvBZQCK7RAW7ONH+MCopXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CF5QBpLKYzYJKSeUKdrrznVCdTuWC/FUOjFX9q+SzZ9HOINqpS0UpHgOK8EQciY8wmCky08f8o0ZD+i0Bf1enMahHo4xGsp+MFX2R90Z2VhzdkOYJ0/zpJ51o99V64kBRfY/Z7IXqgI/7cDxt0PMHqI6JQ1ai5boleDfOd+huAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+kZVm55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+kZVm55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4491F000C4;
	Sat, 17 Oct 2026 16:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253119;
	bh=I9t9diaFvGil48PjqeRC9aqEb+1jwZnZu3gwdFNM17g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+kZVm55LpIoFiSie6ODukm5foqiR+cPypQaxaufzk1A+HCbrHHk1IkrsbeK2Dv9C
	 I9ESre1wST5ukcAzXrVYvufcgl4wnlysgQjR1qBC9hfxpGkdXnofGwNKTa5QUXargk
	 Hbo+w398eC009UI988+IZCqIBwSNLgkJsve8kdpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/869] mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP
Date: Sat, 17 Oct 2026 17:47:38 +0200
Message-ID: <20261017160037.450545481@linuxfoundation.org>
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

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 597e4b9ab48a3f841080f627722064853d3f650e ]

The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
operations that keep the original VMA in place.

Historically this has led to a lot of bugs where non-obvious interactions
occur between existing mremap() operations and the original VMA.

Fix another of these - partial copies.

The long-standing mremap() partial VMA logic has the baked-in assumption
that the originating VMA is unmapped and thus moved.

However MREMAP_DONTUNMAP defeats this by performing a partial copy
instead since it keeps the source VMA around.

An mremap(..., MREMAP_DONTUNMAP) operation disallows resizing of the VMA,
but the operation can be performed partially:

                           |-----------------|
                           |                 |
                           |                 v
                        <------>          <------>
                        .new_sz.           new_sz
                     |--.------.--|       |------|
                     |  .source.  |       | dest |
                     |--.------.--|       |------|
                     <------------>
                         old_sz

The page tables in the specified range are moved, but the original VMA is
kept intact.

This interacts poorly with mlock()'d VMAs, as the VMA_LOCKED_BIT flag is
cleared for the entire source VMA and set for the entire destination VMA.

This results in an mm->locked_vm leak as the change is therefore not
accounted correctly.

The clear solution here is to make the portion of the source VMA which is
mremap()'d distinct from the rest of it, a.k.a. split it.

Therefore resolve this issue by splitting it ahead of the rest of the
mremap() operation if the VMA is mlock()'d.

This is valid, as the source VMA will lose its VMA_LOCKED_BIT flag, so if a
partial remap it will become distinct from the rest of the VMA.

In order to make this change re-expose split_vma() in vma.h for
CONFIG_MMU (nommu doesn't compile mremap.c and uses a static helper
instead).

Finally, update the sys_map_count check to account for this case.

Note that the early check does not use needs_pre_split() - this is because
the VMA has not been looked up by this point, so be conservative and assume
that the VMA is mlock()'d in this case for the purposes of the
sys_map_count check.

Link: https://lore.kernel.org/20260930-fix-dontunmap-partial-self-merge-v2-2-f388985a0f0a@kernel.org
Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
[ sashal: Moved the VMA splitting sequence from prep_move_vma() into the existing move_vma(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 21 +++++++++++++++++++--
 mm/vma.c    |  4 ++--
 mm/vma.h    |  5 +++++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 9685ea816fde1..2e717cf938aa6 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -702,6 +702,8 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 	int err = 0;
 	bool need_rmap_locks;
 	struct vma_iterator vmi;
+	const bool split_before = vma->vm_start != old_addr;
+	const bool split_after = vma->vm_end != old_addr + old_len;
 
 	/*
 	 * We'd prefer to avoid failure later on in do_munmap:
@@ -714,9 +716,9 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		to_account = new_len;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
-		if (vma->vm_start != old_addr)
+		if (split_before)
 			err = vma->vm_ops->may_split(vma, old_addr);
-		if (!err && vma->vm_end != old_addr + old_len)
+		if (!err && split_after)
 			err = vma->vm_ops->may_split(vma, old_addr + old_len);
 		if (err)
 			return err;
@@ -734,6 +736,21 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 	if (err)
 		return err;
 
+	/*
+	 * To account mlock()'d pages correctly in the MREMAP_DONTUNMAP
+	 * case perform any split ahead of time for an mlock()'d VMA.
+	 */
+	if ((flags & MREMAP_DONTUNMAP) && (vma->vm_flags & VM_LOCKED)) {
+		vma_iter_init(&vmi, mm, old_addr);
+
+		if (split_before)
+			err = split_vma(&vmi, vma, old_addr, 1);
+		if (!err && split_after)
+			err = split_vma(&vmi, vma, old_addr + old_len, 0);
+		if (err)
+			return err;
+	}
+
 	if (vm_flags & VM_ACCOUNT) {
 		if (security_vm_enough_memory_mm(mm, to_account >> PAGE_SHIFT))
 			return -ENOMEM;
diff --git a/mm/vma.c b/mm/vma.c
index 3df4cf796c7ff..55321fe0f7912 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -457,8 +457,8 @@ static int __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
  * Split a vma into two pieces at address 'addr', a new vma is allocated
  * either for the first part or the tail.
  */
-static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		     unsigned long addr, int new_below)
+int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	      unsigned long addr, int new_below)
 {
 	if (vma->vm_mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
diff --git a/mm/vma.h b/mm/vma.h
index 729fe3741e897..c953d4ade1f0d 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -343,6 +343,11 @@ bool vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
 int mm_take_all_locks(struct mm_struct *mm);
 void mm_drop_all_locks(struct mm_struct *mm);
 
+#ifdef CONFIG_MMU
+int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	      unsigned long addr, int new_below);
+#endif
+
 static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
 {
 	/*
-- 
2.53.0



