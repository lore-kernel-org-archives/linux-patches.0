Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1D8268C73;
	Tue, 12 Aug 2025 17:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020312; cv=none; b=FMxIlH7W5YCPr3p+X8AMuc0opyLHaBGatbdhHIeBah1/DtllJGKpppxmyTeInuxOHMC5n1/fODq9I5igoKDf8y3qtXZlS89fHxf7eI0pH3SJCv8vvoLSO89GXWhw0rkqURG8bMdj2CuCVWONnrsfJdHmtt7H2N/oJQW0wvK5pDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020312; c=relaxed/simple;
	bh=8IIpIr2dmxNqHePbSZbHvTneZI5TNGEcCf5G+U/Who0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJipMhlfkTPRjwuVYxLetS66PQ5NhSLm2qXy054an3wIkP35gNvsPI0/oGqDzJWiyGjwiJQPOrUGXoK3utbtTVzOD7jImmPhVgr17Ckf/oPsbMfV4//Ojj/skjYObLaX59yGmSpgVVbO8sctV0s2gmqR4eNj+igf5h8UswMi/P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzVxonsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzVxonsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0728C4CEF0;
	Tue, 12 Aug 2025 17:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020312;
	bh=8IIpIr2dmxNqHePbSZbHvTneZI5TNGEcCf5G+U/Who0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzVxonsF52FOhaOWd9uQ/wR7vij9L6kslWe0fgZssvAV+xAqXNBa7p3PYswPNkDrF
	 SJhlm5y4rpONqsAYRTCtAuM0Y+zgE9yPqktKI9Vut/lz5vZ8cP3BAXl99VHP/nDB3c
	 BnS1oYhzzOsI9dgMzrr5kbb6/Lt5hrEzeBHytbWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/253] drm/amdkfd: Dont call mmput from MMU notifier callback
Date: Tue, 12 Aug 2025 19:27:11 +0200
Message-ID: <20250812172950.571453189@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

commit cf234231fcbc7d391e2135b9518613218cc5347f upstream.

If the process is exiting, the mmput inside mmu notifier callback from
compactd or fork or numa balancing could release the last reference
of mm struct to call exit_mmap and free_pgtable, this triggers deadlock
with below backtrace.

The deadlock will leak kfd process as mmu notifier release is not called
and cause VRAM leaking.

The fix is to take mm reference mmget_non_zero when adding prange to the
deferred list to pair with mmput in deferred list work.

If prange split and add into pchild list, the pchild work_item.mm is not
used, so remove the mm parameter from svm_range_unmap_split and
svm_range_add_child.

The backtrace of hung task:

 INFO: task python:348105 blocked for more than 64512 seconds.
 Call Trace:
  __schedule+0x1c3/0x550
  schedule+0x46/0xb0
  rwsem_down_write_slowpath+0x24b/0x4c0
  unlink_anon_vmas+0xb1/0x1c0
  free_pgtables+0xa9/0x130
  exit_mmap+0xbc/0x1a0
  mmput+0x5a/0x140
  svm_range_cpu_invalidate_pagetables+0x2b/0x40 [amdgpu]
  mn_itree_invalidate+0x72/0xc0
  __mmu_notifier_invalidate_range_start+0x48/0x60
  try_to_unmap_one+0x10fa/0x1400
  rmap_walk_anon+0x196/0x460
  try_to_unmap+0xbb/0x210
  migrate_page_unmap+0x54d/0x7e0
  migrate_pages_batch+0x1c3/0xae0
  migrate_pages_sync+0x98/0x240
  migrate_pages+0x25c/0x520
  compact_zone+0x29d/0x590
  compact_zone_order+0xb6/0xf0
  try_to_compact_pages+0xbe/0x220
  __alloc_pages_direct_compact+0x96/0x1a0
  __alloc_pages_slowpath+0x410/0x930
  __alloc_pages_nodemask+0x3a9/0x3e0
  do_huge_pmd_anonymous_page+0xd7/0x3e0
  __handle_mm_fault+0x5e3/0x5f0
  handle_mm_fault+0xf7/0x2e0
  hmm_vma_fault.isra.0+0x4d/0xa0
  walk_pmd_range.isra.0+0xa8/0x310
  walk_pud_range+0x167/0x240
  walk_pgd_range+0x55/0x100
  __walk_page_range+0x87/0x90
  walk_page_range+0xf6/0x160
  hmm_range_fault+0x4f/0x90
  amdgpu_hmm_range_get_pages+0x123/0x230 [amdgpu]
  amdgpu_ttm_tt_get_user_pages+0xb1/0x150 [amdgpu]
  init_user_pages+0xb1/0x2a0 [amdgpu]
  amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu+0x543/0x7d0 [amdgpu]
  kfd_ioctl_alloc_memory_of_gpu+0x24c/0x4e0 [amdgpu]
  kfd_ioctl+0x29d/0x500 [amdgpu]

Fixes: fa582c6f3684 ("drm/amdkfd: Use mmget_not_zero in MMU notifier")
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a29e067bd38946f752b0ef855f3dfff87e77bec7)
Cc: stable@vger.kernel.org
[ updated additional svm_range_add_child calls in svm_range_split_by_granularity to remove mm parameter ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c |   47 ++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1076,13 +1076,12 @@ svm_range_split_head(struct svm_range *p
 }
 
 static void
-svm_range_add_child(struct svm_range *prange, struct mm_struct *mm,
-		    struct svm_range *pchild, enum svm_work_list_ops op)
+svm_range_add_child(struct svm_range *prange, struct svm_range *pchild, enum svm_work_list_ops op)
 {
 	pr_debug("add child 0x%p [0x%lx 0x%lx] to prange 0x%p child list %d\n",
 		 pchild, pchild->start, pchild->last, prange, op);
 
-	pchild->work_item.mm = mm;
+	pchild->work_item.mm = NULL;
 	pchild->work_item.op = op;
 	list_add_tail(&pchild->child_list, &prange->child_list);
 }
@@ -1128,14 +1127,14 @@ svm_range_split_by_granularity(struct kf
 		r = svm_range_split(prange, start, prange->last, &head);
 		if (r)
 			return r;
-		svm_range_add_child(parent, mm, head, SVM_OP_ADD_RANGE);
+		svm_range_add_child(parent, head, SVM_OP_ADD_RANGE);
 	}
 
 	if (last < prange->last) {
 		r = svm_range_split(prange, prange->start, last, &tail);
 		if (r)
 			return r;
-		svm_range_add_child(parent, mm, tail, SVM_OP_ADD_RANGE);
+		svm_range_add_child(parent, tail, SVM_OP_ADD_RANGE);
 	}
 
 	/* xnack on, update mapping on GPUs with ACCESS_IN_PLACE */
@@ -2265,15 +2264,17 @@ svm_range_add_list_work(struct svm_range
 		    prange->work_item.op != SVM_OP_UNMAP_RANGE)
 			prange->work_item.op = op;
 	} else {
-		prange->work_item.op = op;
-
-		/* Pairs with mmput in deferred_list_work */
-		mmget(mm);
-		prange->work_item.mm = mm;
-		list_add_tail(&prange->deferred_list,
-			      &prange->svms->deferred_range_list);
-		pr_debug("add prange 0x%p [0x%lx 0x%lx] to work list op %d\n",
-			 prange, prange->start, prange->last, op);
+		/* Pairs with mmput in deferred_list_work.
+		 * If process is exiting and mm is gone, don't update mmu notifier.
+		 */
+		if (mmget_not_zero(mm)) {
+			prange->work_item.mm = mm;
+			prange->work_item.op = op;
+			list_add_tail(&prange->deferred_list,
+				      &prange->svms->deferred_range_list);
+			pr_debug("add prange 0x%p [0x%lx 0x%lx] to work list op %d\n",
+				 prange, prange->start, prange->last, op);
+		}
 	}
 	spin_unlock(&svms->deferred_list_lock);
 }
@@ -2287,8 +2288,7 @@ void schedule_deferred_list_work(struct
 }
 
 static void
-svm_range_unmap_split(struct mm_struct *mm, struct svm_range *parent,
-		      struct svm_range *prange, unsigned long start,
+svm_range_unmap_split(struct svm_range *parent, struct svm_range *prange, unsigned long start,
 		      unsigned long last)
 {
 	struct svm_range *head;
@@ -2309,12 +2309,12 @@ svm_range_unmap_split(struct mm_struct *
 		svm_range_split(tail, last + 1, tail->last, &head);
 
 	if (head != prange && tail != prange) {
-		svm_range_add_child(parent, mm, head, SVM_OP_UNMAP_RANGE);
-		svm_range_add_child(parent, mm, tail, SVM_OP_ADD_RANGE);
+		svm_range_add_child(parent, head, SVM_OP_UNMAP_RANGE);
+		svm_range_add_child(parent, tail, SVM_OP_ADD_RANGE);
 	} else if (tail != prange) {
-		svm_range_add_child(parent, mm, tail, SVM_OP_UNMAP_RANGE);
+		svm_range_add_child(parent, tail, SVM_OP_UNMAP_RANGE);
 	} else if (head != prange) {
-		svm_range_add_child(parent, mm, head, SVM_OP_UNMAP_RANGE);
+		svm_range_add_child(parent, head, SVM_OP_UNMAP_RANGE);
 	} else if (parent != prange) {
 		prange->work_item.op = SVM_OP_UNMAP_RANGE;
 	}
@@ -2353,14 +2353,14 @@ svm_range_unmap_from_cpu(struct mm_struc
 		l = min(last, pchild->last);
 		if (l >= s)
 			svm_range_unmap_from_gpus(pchild, s, l, trigger);
-		svm_range_unmap_split(mm, prange, pchild, start, last);
+		svm_range_unmap_split(prange, pchild, start, last);
 		mutex_unlock(&pchild->lock);
 	}
 	s = max(start, prange->start);
 	l = min(last, prange->last);
 	if (l >= s)
 		svm_range_unmap_from_gpus(prange, s, l, trigger);
-	svm_range_unmap_split(mm, prange, prange, start, last);
+	svm_range_unmap_split(prange, prange, start, last);
 
 	if (unmap_parent)
 		svm_range_add_list_work(svms, prange, mm, SVM_OP_UNMAP_RANGE);
@@ -2403,8 +2403,6 @@ svm_range_cpu_invalidate_pagetables(stru
 
 	if (range->event == MMU_NOTIFY_RELEASE)
 		return true;
-	if (!mmget_not_zero(mni->mm))
-		return true;
 
 	start = mni->interval_tree.start;
 	last = mni->interval_tree.last;
@@ -2431,7 +2429,6 @@ svm_range_cpu_invalidate_pagetables(stru
 	}
 
 	svm_range_unlock(prange);
-	mmput(mni->mm);
 
 	return true;
 }


