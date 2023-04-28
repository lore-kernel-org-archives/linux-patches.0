Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFA0290A
	for <patches@lists.linux.dev>; Fri, 28 Apr 2023 11:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4666BC433D2;
	Fri, 28 Apr 2023 11:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682681366;
	bh=I8fzXVLWx+5cs6wQMdcqu3QQighOHe1MMoBgcxKJvI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o49LUAw4X3SgwsduliFBwCTtKkXx8NJugquC/+0BR59p4B4YE6iqKKAY27Hm8rhqb
	 c16ay6aUy8urdiDyEtSZ/10v3GZ3t2IZC8IE3sRUa6OkwKXNd0GZFs40WocuyGDu+z
	 z6KV/nIVmDwS8X9n8THRlsbhQjQuNF8gNnaPOork=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	syzbot+a7c1ec5b1d71ceaa5186@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 04/16] mm/mempolicy: fix use-after-free of VMA iterator
Date: Fri, 28 Apr 2023 13:27:56 +0200
Message-Id: <20230428112040.210767326@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230428112040.063291126@linuxfoundation.org>
References: <20230428112040.063291126@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit f4e9e0e69468583c2c6d9d5c7bfc975e292bf188 upstream.

set_mempolicy_home_node() iterates over a list of VMAs and calls
mbind_range() on each VMA, which also iterates over the singular list of
the VMA passed in and potentially splits the VMA.  Since the VMA iterator
is not passed through, set_mempolicy_home_node() may now point to a stale
node in the VMA tree.  This can result in a UAF as reported by syzbot.

Avoid the stale maple tree node by passing the VMA iterator through to the
underlying call to split_vma().

mbind_range() is also overly complicated, since there are two calling
functions and one already handles iterating over the VMAs.  Simplify
mbind_range() to only handle merging and splitting of the VMAs.

Align the new loop in do_mbind() and existing loop in
set_mempolicy_home_node() to use the reduced mbind_range() function.  This
allows for a single location of the range calculation and avoids
constantly looking up the previous VMA (since this is a loop over the
VMAs).

Link: https://lore.kernel.org/linux-mm/000000000000c93feb05f87e24ad@google.com/
Fixes: 66850be55e8e ("mm/mempolicy: use vma iterator & maple state instead of vma linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: syzbot+a7c1ec5b1d71ceaa5186@syzkaller.appspotmail.com
  Link: https://lkml.kernel.org/r/20230410152205.2294819-1-Liam.Howlett@oracle.com
Tested-by: syzbot+a7c1ec5b1d71ceaa5186@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |  113 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 52 insertions(+), 61 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -784,70 +784,56 @@ static int vma_replace_policy(struct vm_
 	return err;
 }
 
-/* Step 2: apply policy to a range and do splits. */
-static int mbind_range(struct mm_struct *mm, unsigned long start,
-		       unsigned long end, struct mempolicy *new_pol)
+/* Split or merge the VMA (if required) and apply the new policy */
+static int mbind_range(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		struct vm_area_struct **prev, unsigned long start,
+		unsigned long end, struct mempolicy *new_pol)
 {
-	MA_STATE(mas, &mm->mm_mt, start, start);
-	struct vm_area_struct *prev;
-	struct vm_area_struct *vma;
-	int err = 0;
+	struct vm_area_struct *merged;
+	unsigned long vmstart, vmend;
 	pgoff_t pgoff;
+	int err;
 
-	prev = mas_prev(&mas, 0);
-	if (unlikely(!prev))
-		mas_set(&mas, start);
+	vmend = min(end, vma->vm_end);
+	if (start > vma->vm_start) {
+		*prev = vma;
+		vmstart = start;
+	} else {
+		vmstart = vma->vm_start;
+	}
 
-	vma = mas_find(&mas, end - 1);
-	if (WARN_ON(!vma))
+	if (mpol_equal(vma_policy(vma), new_pol))
 		return 0;
 
-	if (start > vma->vm_start)
-		prev = vma;
+	pgoff = vma->vm_pgoff + ((vmstart - vma->vm_start) >> PAGE_SHIFT);
+	merged = vma_merge(vma->vm_mm, *prev, vmstart, vmend, vma->vm_flags,
+			   vma->anon_vma, vma->vm_file, pgoff, new_pol,
+			   vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+	if (merged) {
+		*prev = merged;
+		/* vma_merge() invalidated the mas */
+		mas_pause(&vmi->mas);
+		return vma_replace_policy(merged, new_pol);
+	}
 
-	for (; vma; vma = mas_next(&mas, end - 1)) {
-		unsigned long vmstart = max(start, vma->vm_start);
-		unsigned long vmend = min(end, vma->vm_end);
-
-		if (mpol_equal(vma_policy(vma), new_pol))
-			goto next;
-
-		pgoff = vma->vm_pgoff +
-			((vmstart - vma->vm_start) >> PAGE_SHIFT);
-		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
-				 vma->anon_vma, vma->vm_file, pgoff,
-				 new_pol, vma->vm_userfaultfd_ctx,
-				 anon_vma_name(vma));
-		if (prev) {
-			/* vma_merge() invalidated the mas */
-			mas_pause(&mas);
-			vma = prev;
-			goto replace;
-		}
-		if (vma->vm_start != vmstart) {
-			err = split_vma(vma->vm_mm, vma, vmstart, 1);
-			if (err)
-				goto out;
-			/* split_vma() invalidated the mas */
-			mas_pause(&mas);
-		}
-		if (vma->vm_end != vmend) {
-			err = split_vma(vma->vm_mm, vma, vmend, 0);
-			if (err)
-				goto out;
-			/* split_vma() invalidated the mas */
-			mas_pause(&mas);
-		}
-replace:
-		err = vma_replace_policy(vma, new_pol);
+	if (vma->vm_start != vmstart) {
+		err = split_vma(vma->vm_mm, vma, vmstart, 1);
 		if (err)
-			goto out;
-next:
-		prev = vma;
+			return err;
+		/* split_vma() invalidated the mas */
+		mas_pause(&vmi->mas);
 	}
 
-out:
-	return err;
+	if (vma->vm_end != vmend) {
+		err = split_vma(vma->vm_mm, vma, vmend, 0);
+		if (err)
+			return err;
+		/* split_vma() invalidated the mas */
+		mas_pause(&vmi->mas);
+	}
+
+	*prev = vma;
+	return vma_replace_policy(vma, new_pol);
 }
 
 /* Set the process memory policy */
@@ -1259,6 +1245,8 @@ static long do_mbind(unsigned long start
 		     nodemask_t *nmask, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma, *prev;
+	struct vma_iterator vmi;
 	struct mempolicy *new;
 	unsigned long end;
 	int err;
@@ -1328,7 +1316,13 @@ static long do_mbind(unsigned long start
 		goto up_out;
 	}
 
-	err = mbind_range(mm, start, end, new);
+	vma_iter_init(&vmi, mm, start);
+	prev = vma_prev(&vmi);
+	for_each_vma_range(vmi, vma, end) {
+		err = mbind_range(&vmi, vma, &prev, start, end, new);
+		if (err)
+			break;
+	}
 
 	if (!err) {
 		int nr_failed = 0;
@@ -1489,10 +1483,8 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 		unsigned long, home_node, unsigned long, flags)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma, *prev;
 	struct mempolicy *new;
-	unsigned long vmstart;
-	unsigned long vmend;
 	unsigned long end;
 	int err = -ENOENT;
 	VMA_ITERATOR(vmi, mm, start);
@@ -1521,9 +1513,8 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 	if (end == start)
 		return 0;
 	mmap_write_lock(mm);
+	prev = vma_prev(&vmi);
 	for_each_vma_range(vmi, vma, end) {
-		vmstart = max(start, vma->vm_start);
-		vmend   = min(end, vma->vm_end);
 		new = mpol_dup(vma_policy(vma));
 		if (IS_ERR(new)) {
 			err = PTR_ERR(new);
@@ -1547,7 +1538,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 		}
 
 		new->home_node = home_node;
-		err = mbind_range(mm, vmstart, vmend, new);
+		err = mbind_range(&vmi, vma, &prev, start, end, new);
 		mpol_put(new);
 		if (err)
 			break;


