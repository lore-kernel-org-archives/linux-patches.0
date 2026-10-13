Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F314CE699;
	Tue, 13 Oct 2026 11:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892140; cv=none; b=Gxnmk5GNoaeN8yKgaqoMewSSU5XLh9mPuncHG2oAtVFYzI58hwtAuopvbA7R7o8QJShGuVMNzaMR4mi4dOC4CwyF/FzqUVCGHvGpxH1cWhuT2NMnzl4nMz6pHtZdfZoXGbr0iqZqWofeIrzUMDm5ODx1NnhA7TvVsSmvlhgvcoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892140; c=relaxed/simple;
	bh=xxn5FEZvQuZj34fOrXGanhKh36InegcPWEzjj3QZ9ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlYlJdrRufF/YprmrvKIREMGAoTSevaAY9Tb0py/xKDkPJpKeCN5fQRu0uuKwIWaERXQ6OAI8LpLPildvJJPKIs2VR8+Wd6ynp/C6CBBE+0RCeU1bly9rZwEXD26P8oG5//fiu442kZgbvfrN113Ya09hgdSEdPV2qC7l9Gy0fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qa/W7Y5O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qa/W7Y5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0B01F000FF;
	Tue, 13 Oct 2026 11:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892138;
	bh=P4zeTqJyLexFIdwzkRWEbzdhEmz/RCAyO79O74Fy+74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qa/W7Y5Ox8RM0GaSRY68MpI/UYA7QLn0vJNceiZLKYiaVbUB1/waHy1U62LTauxs5
	 mcL3bYmljlUFdV66oPPAOB1ivBBL4geioOgH8+b/WGScsPTucUmDwagpUcySGAdYmP
	 j40hDGwZFzphvr1JGE319YWQcQ9M4PDlQ6RfWSGY=
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
	Minchan Kim <minchan@kernel.org>
Subject: [PATCH 7.2 071/281] mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP
Date: Tue, 13 Oct 2026 13:36:27 +0200
Message-ID: <20261013112856.853107578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

commit 597e4b9ab48a3f841080f627722064853d3f650e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mremap.c |   62 ++++++++++++++++++++++++++++++++++++++++++++----------------
 mm/vma.c    |    4 +--
 mm/vma.h    |    5 ++++
 3 files changed, 53 insertions(+), 18 deletions(-)

--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1029,6 +1029,7 @@ static void vrm_stat_account(struct vma_
 }
 
 static bool __check_map_count_against_split(struct mm_struct *mm,
+					    bool pre_split,
 					    bool before_unmaps)
 {
 	const int sys_map_count = get_sysctl_max_map_count();
@@ -1080,26 +1081,42 @@ static bool __check_map_count_against_sp
 	 * Therefore we must check to ensure we have headroom of 2 additional
 	 * VMAs.
 	 */
-	return map_count + 2 <= sys_map_count;
+	map_count += 2;
+
+	/* If pre-split, the -1 observed above doesn't apply. */
+	if (pre_split)
+		map_count++;
+
+	return map_count <= sys_map_count;
+}
+
+static bool needs_pre_split(struct vma_remap_struct *vrm)
+{
+	/*
+	 * An MREMAP_DONTUNMAP of a mlock()'d VMA needs to unlock the
+	 * source VMA, so split in this case.
+	 */
+	return (vrm->flags & MREMAP_DONTUNMAP) &&
+		vma_test(vrm->vma, VMA_LOCKED_BIT);
 }
 
 /* Do we violate the map count limit if we split VMAs when moving the VMA? */
-static bool check_map_count_against_split(void)
+static bool check_map_count_against_split(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
-					       /*before_unmaps=*/false);
+		needs_pre_split(vrm), /*before_unmaps=*/false);
 }
 
 /* Do we violate the map count limit if we split VMAs prior to early unmaps? */
-static bool check_map_count_against_split_early(void)
+static bool check_map_count_against_split_early(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
-					       /*before_unmaps=*/true);
+		vrm->flags & MREMAP_DONTUNMAP, /*before_unmaps=*/true);
 }
 
 /*
- * Perform checks before attempting to write a VMA prior to it being
- * moved.
+ * Perform checks and preparation before attempting to write a VMA prior to it
+ * being moved.
  */
 static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 {
@@ -1108,19 +1125,17 @@ static unsigned long prep_move_vma(struc
 	unsigned long old_addr = vrm->addr;
 	unsigned long old_len = vrm->old_len;
 	vm_flags_t dummy = vma->vm_flags;
+	const bool split_before = vma->vm_start != old_addr;
+	const bool split_after = vma->vm_end != old_addr + old_len;
 
-	/*
-	 * We'd prefer to avoid failure later on in do_munmap: we copy a VMA,
-	 * which may not merge, then (if MREMAP_DONTUNMAP is not set) unmap the
-	 * source, which may split, causing a net increase of 2 mappings.
-	 */
-	if (!check_map_count_against_split())
+	/* Avoid failure later on. */
+	if (!check_map_count_against_split(vrm))
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
-		if (vma->vm_start != old_addr)
+		if (split_before)
 			err = vma->vm_ops->may_split(vma, old_addr);
-		if (!err && vma->vm_end != old_addr + old_len)
+		if (!err && split_after)
 			err = vma->vm_ops->may_split(vma, old_addr + old_len);
 		if (err)
 			return err;
@@ -1138,6 +1153,21 @@ static unsigned long prep_move_vma(struc
 	if (err)
 		return err;
 
+	/*
+	 * To account mlock()'d pages correctly in the MREMAP_DONTUNMAP
+	 * case perform any split ahead of time for an mlock()'d VMA.
+	 */
+	if (needs_pre_split(vrm)) {
+		VMA_ITERATOR(vmi, vma->vm_mm, old_addr);
+
+		if (split_before)
+			err = split_vma(&vmi, vma, old_addr, 1);
+		if (!err && split_after)
+			err = split_vma(&vmi, vma, old_addr + old_len, 0);
+		vrm->vmi_needs_invalidate = true;
+		return err;
+	}
+
 	return 0;
 }
 
@@ -1992,7 +2022,7 @@ static unsigned long do_mremap(struct vm
 		return -EINTR;
 	vrm->mmap_locked = true;
 
-	if (!check_map_count_against_split_early()) {
+	if (!check_map_count_against_split_early(vrm)) {
 		mmap_write_unlock(mm);
 		return -ENOMEM;
 	}
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -590,8 +590,8 @@ out_free_vma:
  * Split a vma into two pieces at address 'addr', a new vma is allocated
  * either for the first part or the tail.
  */
-static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		     unsigned long addr, int new_below)
+int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	      unsigned long addr, int new_below)
 {
 	if (vma->vm_mm->map_count >= get_sysctl_max_map_count())
 		return -ENOMEM;
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -470,6 +470,11 @@ int do_brk_flags(struct vma_iterator *vm
 unsigned long unmapped_area(struct vm_unmapped_area_info *info);
 unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info);
 
+#ifdef CONFIG_MMU
+int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	      unsigned long addr, int new_below);
+#endif
+
 static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
 {
 	/*


