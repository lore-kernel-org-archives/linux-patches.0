Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C5C3A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nCESo6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B13C433C8;
	Wed, 15 Nov 2023 19:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077342;
	bh=W/fiX5azb8t2StkebXQBFtlAKpg4N5aDHj1/fwS0zRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0nCESo6mxZGcE1PrVFCqLudlx66JQ/B6RJtdLd4EagQdgQvV5F0pCfcLcBfGaLRZk
	 i+yuBqiduPkBZWSSP/Wq5VTJ+cx84YBsCOKxZArDLBylx4U3FxOINkFKNvfvz41wTm
	 dY/iAdM6qszuEAANUac5PEt6y6gFjSpjq6EmnDSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	James Zhu <james.zhu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/603] drm/amdkfd: Handle errors from svm validate and map
Date: Wed, 15 Nov 2023 14:13:09 -0500
Message-ID: <20231115191630.115582245@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit eb3c357bcb286e89386e89302061fe717fe4e562 ]

If new range is splited to multiple pranges with max_svm_range_pages
alignment and added to update_list, svm validate and map should keep
going after error to make sure prange->mapped_to_gpu flag is up to date
for the whole range.

svm validate and map update set prange->mapped_to_gpu after mapping to
GPUs successfully, otherwise clear prange->mapped_to_gpu flag (for
update mapping case) instead of setting error flag, we can remove
the redundant error flag to simpliy code.

Refactor to remove goto and update prange->mapped_to_gpu flag inside
svm_range_lock, to guarant we always evict queues or unmap from GPUs if
there are invalid ranges.

After svm validate and map return error -EAGIN, the caller retry will
update the mapping for the whole range again.

Fixes: c22b04407097 ("drm/amdkfd: flag added to handle errors from svm validate and map")
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Tested-by: James Zhu <james.zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 82 +++++++++++++---------------
 drivers/gpu/drm/amd/amdkfd/kfd_svm.h |  1 -
 2 files changed, 39 insertions(+), 44 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index dfc11699e79ab..2a42fbddcb7ae 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -820,7 +820,7 @@ svm_range_is_same_attrs(struct kfd_process *p, struct svm_range *prange,
 		}
 	}
 
-	return !prange->is_error_flag;
+	return true;
 }
 
 /**
@@ -1662,71 +1662,66 @@ static int svm_range_validate_and_map(struct mm_struct *mm,
 
 	start = prange->start << PAGE_SHIFT;
 	end = (prange->last + 1) << PAGE_SHIFT;
-	for (addr = start; addr < end && !r; ) {
+	for (addr = start; !r && addr < end; ) {
 		struct hmm_range *hmm_range;
 		struct vm_area_struct *vma;
-		unsigned long next;
+		unsigned long next = 0;
 		unsigned long offset;
 		unsigned long npages;
 		bool readonly;
 
 		vma = vma_lookup(mm, addr);
-		if (!vma) {
+		if (vma) {
+			readonly = !(vma->vm_flags & VM_WRITE);
+
+			next = min(vma->vm_end, end);
+			npages = (next - addr) >> PAGE_SHIFT;
+			WRITE_ONCE(p->svms.faulting_task, current);
+			r = amdgpu_hmm_range_get_pages(&prange->notifier, addr, npages,
+						       readonly, owner, NULL,
+						       &hmm_range);
+			WRITE_ONCE(p->svms.faulting_task, NULL);
+			if (r) {
+				pr_debug("failed %d to get svm range pages\n", r);
+				if (r == -EBUSY)
+					r = -EAGAIN;
+			}
+		} else {
 			r = -EFAULT;
-			goto unreserve_out;
-		}
-		readonly = !(vma->vm_flags & VM_WRITE);
-
-		next = min(vma->vm_end, end);
-		npages = (next - addr) >> PAGE_SHIFT;
-		WRITE_ONCE(p->svms.faulting_task, current);
-		r = amdgpu_hmm_range_get_pages(&prange->notifier, addr, npages,
-					       readonly, owner, NULL,
-					       &hmm_range);
-		WRITE_ONCE(p->svms.faulting_task, NULL);
-		if (r) {
-			pr_debug("failed %d to get svm range pages\n", r);
-			if (r == -EBUSY)
-				r = -EAGAIN;
-			goto unreserve_out;
 		}
 
-		offset = (addr - start) >> PAGE_SHIFT;
-		r = svm_range_dma_map(prange, ctx->bitmap, offset, npages,
-				      hmm_range->hmm_pfns);
-		if (r) {
-			pr_debug("failed %d to dma map range\n", r);
-			goto unreserve_out;
+		if (!r) {
+			offset = (addr - start) >> PAGE_SHIFT;
+			r = svm_range_dma_map(prange, ctx->bitmap, offset, npages,
+					      hmm_range->hmm_pfns);
+			if (r)
+				pr_debug("failed %d to dma map range\n", r);
 		}
 
 		svm_range_lock(prange);
-		if (amdgpu_hmm_range_get_pages_done(hmm_range)) {
+		if (!r && amdgpu_hmm_range_get_pages_done(hmm_range)) {
 			pr_debug("hmm update the range, need validate again\n");
 			r = -EAGAIN;
-			goto unlock_out;
 		}
-		if (!list_empty(&prange->child_list)) {
+
+		if (!r && !list_empty(&prange->child_list)) {
 			pr_debug("range split by unmap in parallel, validate again\n");
 			r = -EAGAIN;
-			goto unlock_out;
 		}
 
-		r = svm_range_map_to_gpus(prange, offset, npages, readonly,
-					  ctx->bitmap, wait, flush_tlb);
+		if (!r)
+			r = svm_range_map_to_gpus(prange, offset, npages, readonly,
+						  ctx->bitmap, wait, flush_tlb);
+
+		if (!r && next == end)
+			prange->mapped_to_gpu = true;
 
-unlock_out:
 		svm_range_unlock(prange);
 
 		addr = next;
 	}
 
-	if (addr == end)
-		prange->mapped_to_gpu = true;
-
-unreserve_out:
 	svm_range_unreserve_bos(ctx);
-
-	prange->is_error_flag = !!r;
 	if (!r)
 		prange->validate_timestamp = ktime_get_boottime();
 
@@ -2095,7 +2090,8 @@ svm_range_add(struct kfd_process *p, uint64_t start, uint64_t size,
 		next = interval_tree_iter_next(node, start, last);
 		next_start = min(node->last, last) + 1;
 
-		if (svm_range_is_same_attrs(p, prange, nattr, attrs)) {
+		if (svm_range_is_same_attrs(p, prange, nattr, attrs) &&
+		    prange->mapped_to_gpu) {
 			/* nothing to do */
 		} else if (node->start < start || node->last > last) {
 			/* node intersects the update range and its attributes
@@ -3505,7 +3501,7 @@ svm_range_set_attr(struct kfd_process *p, struct mm_struct *mm,
 	struct svm_range *next;
 	bool update_mapping = false;
 	bool flush_tlb;
-	int r = 0;
+	int r, ret = 0;
 
 	pr_debug("pasid 0x%x svms 0x%p [0x%llx 0x%llx] pages 0x%llx\n",
 		 p->pasid, &p->svms, start, start + size - 1, size);
@@ -3593,7 +3589,7 @@ svm_range_set_attr(struct kfd_process *p, struct mm_struct *mm,
 out_unlock_range:
 		mutex_unlock(&prange->migrate_mutex);
 		if (r)
-			break;
+			ret = r;
 	}
 
 	dynamic_svm_range_dump(svms);
@@ -3606,7 +3602,7 @@ svm_range_set_attr(struct kfd_process *p, struct mm_struct *mm,
 	pr_debug("pasid 0x%x svms 0x%p [0x%llx 0x%llx] done, r=%d\n", p->pasid,
 		 &p->svms, start, start + size - 1, r);
 
-	return r;
+	return ret ? ret : r;
 }
 
 static int
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.h b/drivers/gpu/drm/amd/amdkfd/kfd_svm.h
index c216c8dd13c6c..25f7119057386 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.h
@@ -133,7 +133,6 @@ struct svm_range {
 	DECLARE_BITMAP(bitmap_access, MAX_GPU_INSTANCE);
 	DECLARE_BITMAP(bitmap_aip, MAX_GPU_INSTANCE);
 	bool				mapped_to_gpu;
-	bool				is_error_flag;
 };
 
 static inline void svm_range_lock(struct svm_range *prange)
-- 
2.42.0



