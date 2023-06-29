Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79B214267
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D272C433C0;
	Thu, 29 Jun 2023 18:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064367;
	bh=RO4frDaW/Gfw0IObe2/tF99nwQ4SmNW2FNa6oD2I8lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DeelpdON/1NkQcnHLqkgS1dYNObX+TEq8AFjQVNwdHFznkZFvA3xexBRTLZhuzGJJ
	 Q9Xm9/p6VuFWwr2T9DQyuFiSWEPwOCgQzWqKGNdF1N55TkysMLEVw33DAmZ/bvH/e9
	 lvgXiC9b47Yzgz5Z78BRoZRlbRst3TZZ7Vd5dMa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vegard Nossum <vegard.nossum@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 6.3 01/29] mm/mmap: Fix error path in do_vmi_align_munmap()
Date: Thu, 29 Jun 2023 20:43:31 +0200
Message-ID: <20230629184151.775998931@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.705870770@linuxfoundation.org>
References: <20230629184151.705870770@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Liam R. Howlett" <Liam.Howlett@oracle.com>

commit 606c812eb1d5b5fb0dd9e330ca94b52d7c227830 upstream.

The error unrolling was leaving the VMAs detached in many cases and
leaving the locked_vm statistic altered, and skipping the unrolling
entirely in the case of the vma tree write failing.

Fix the error path by re-attaching the detached VMAs and adding the
necessary goto for the failed vma tree write, and fix the locked_vm
statistic by only updating after the vma tree write succeeds.

Fixes: 763ecb035029 ("mm: remove the vma linked list")
Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ dwmw2: Strictly, the original patch wasn't *re-attaching* the
         detached VMAs. They *were* still attached but just had
         the 'detached' flag set, which is an optimisation. Which
         doesn't exist in 6.3, so drop that. Also drop the call
         to vma_start_write() which came in with the per-VMA
         locking in 6.4. ]
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2280,19 +2280,6 @@ int split_vma(struct vma_iterator *vmi,
 	return __split_vma(vmi, vma, addr, new_below);
 }
 
-static inline int munmap_sidetree(struct vm_area_struct *vma,
-				   struct ma_state *mas_detach)
-{
-	mas_set_range(mas_detach, vma->vm_start, vma->vm_end - 1);
-	if (mas_store_gfp(mas_detach, vma, GFP_KERNEL))
-		return -ENOMEM;
-
-	if (vma->vm_flags & VM_LOCKED)
-		vma->vm_mm->locked_vm -= vma_pages(vma);
-
-	return 0;
-}
-
 /*
  * do_vmi_align_munmap() - munmap the aligned region from @start to @end.
  * @vmi: The vma iterator
@@ -2314,6 +2301,7 @@ do_vmi_align_munmap(struct vma_iterator
 	struct maple_tree mt_detach;
 	int count = 0;
 	int error = -ENOMEM;
+	unsigned long locked_vm = 0;
 	MA_STATE(mas_detach, &mt_detach, 0, 0);
 	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
 	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
@@ -2359,9 +2347,11 @@ do_vmi_align_munmap(struct vma_iterator
 			if (error)
 				goto end_split_failed;
 		}
-		error = munmap_sidetree(next, &mas_detach);
-		if (error)
-			goto munmap_sidetree_failed;
+		mas_set_range(&mas_detach, next->vm_start, next->vm_end - 1);
+		if (mas_store_gfp(&mas_detach, next, GFP_KERNEL))
+			goto munmap_gather_failed;
+		if (next->vm_flags & VM_LOCKED)
+			locked_vm += vma_pages(next);
 
 		count++;
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
@@ -2407,10 +2397,12 @@ do_vmi_align_munmap(struct vma_iterator
 	}
 #endif
 	/* Point of no return */
+	error = -ENOMEM;
 	vma_iter_set(vmi, start);
 	if (vma_iter_clear_gfp(vmi, start, end, GFP_KERNEL))
-		return -ENOMEM;
+		goto clear_tree_failed;
 
+	mm->locked_vm -= locked_vm;
 	mm->map_count -= count;
 	/*
 	 * Do not downgrade mmap_lock if we are next to VM_GROWSDOWN or
@@ -2440,8 +2432,9 @@ do_vmi_align_munmap(struct vma_iterator
 	validate_mm(mm);
 	return downgrade ? 1 : 0;
 
+clear_tree_failed:
 userfaultfd_error:
-munmap_sidetree_failed:
+munmap_gather_failed:
 end_split_failed:
 	__mt_destroy(&mt_detach);
 start_split_failed:


