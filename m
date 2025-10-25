Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3370C2F5B;
	Sat, 25 Oct 2025 16:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409302; cv=none; b=C+5FlhdoYb4vYZ8/OCHxrOqftUC3DgjBnRMLGGtMhf9Co+uMdDvThJZLBhhKmLcMe4ABcXlarfttZMN+eKxzdjbNcVGYkx/eERLKvECagn1TqAsKOjvLTABq1n01887908ddkUOfTHZxtUFzddcaWqIRdBTuA+CdX0reS2kXwiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409302; c=relaxed/simple;
	bh=IdVJHrq7qjKgEAw8LQrXvJ0Cfy3ZnKYC0uazL97zGE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OVOvdjIZfzy3ordCn470I4ArDnjlnS65o68aWSkq0vW5xUPR3GvSHehA7CyaRQph9Pzpoiz9X56aes/ABLyeS+RmyzSWGzHDr4hNMPQHzfPU6x2abUR+gjTsdlIuFRChG9/wg/Auh50fOuHp78rQDRExS9BqDfre9imu1EDjtq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HtgeNDI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HtgeNDI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC433C2BCB2;
	Sat, 25 Oct 2025 16:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409301;
	bh=IdVJHrq7qjKgEAw8LQrXvJ0Cfy3ZnKYC0uazL97zGE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtgeNDI/T6Cji4jR+6OSi+QzgFrc6psEhBNhmJFM3Uu/mMSNs9sjXoNGJTky1IQFn
	 QwpA6LVHX7cE1WL83Hwzx+AMQCvZzKEmLd2ILfYRCMK8RbH0xrfFKIyapXKLDfvAcr
	 pVGp5oqSjGRG9qwFDF3Ga9deZLNnNCDPUUvDuMrwNWRQmTxtze8S+0yJeVvYfjld1h
	 cJ2beh8AAFYNj1kercCDJHZY3XASKR/pftR05rG+2yy3UxHhrxsryDUvxEauWgjCDg
	 iv3tWpRU9PQvGHhgCn2JaVVtyBODEkD3Y3M0wsrKyTrkNd4vsR2VZ/bCuvaBNuTe1R
	 BP0GWoXsy7bYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kent Russell <kent.russell@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17-6.6] drm/amdkfd: Handle lack of READ permissions in SVM mapping
Date: Sat, 25 Oct 2025 11:58:20 -0400
Message-ID: <20251025160905.3857885-269-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kent Russell <kent.russell@amd.com>

[ Upstream commit 0ed704d058cec7643a716a21888d58c7d03f2c3e ]

HMM assumes that pages have READ permissions by default. Inside
svm_range_validate_and_map, we add READ permissions then add WRITE
permissions if the VMA isn't read-only. This will conflict with regions
that only have PROT_WRITE or have PROT_NONE. When that happens,
svm_range_restore_work will continue to retry, silently, giving the
impression of a hang if pr_debug isn't enabled to show the retries..

If pages don't have READ permissions, simply unmap them and continue. If
they weren't mapped in the first place, this would be a no-op. Since x86
doesn't support write-only, and PROT_NONE doesn't allow reads or writes
anyways, this will allow the svm range validation to continue without
getting stuck in a loop forever on mappings we can't use with HMM.

Signed-off-by: Kent Russell <kent.russell@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation
- Bug fixed: The change addresses an indefinite retry loop (apparent
  hang) in HMM-backed SVM mapping when encountering VMAs without read
  permission, specifically write-only mappings and PROT_NONE. The loop
  is triggered because HMM assumes READ by default and the existing code
  adds READ then WRITE in svm_range_validate_and_map. That conflicts
  with mappings that lack READ and causes svm_range_restore_work to
  silently retry forever.
- Core change: In drivers/gpu/drm/amd/amdkfd/kfd_svm.c inside
  svm_range_validate_and_map, after resolving the VMA and before calling
  amdgpu_hmm_range_get_pages, the patch adds a guard:
  - Check: if (!(vma->vm_flags & VM_READ)) { … continue; }
  - Behavior on no-READ: Acquire range lock, optionally pr_debug if
    VM_WRITE is set without VM_READ, compute the intersection of the
    current address range with prange, call
    svm_range_unmap_from_gpus(prange, s, e,
    KFD_SVM_UNMAP_TRIGGER_UNMAP_FROM_CPU), unlock, advance addr to next,
    and continue.
  - This explicitly treats PROT_NONE and write-only VMAs as unmappable
    for HMM/SVM and avoids mapping attempts that will never succeed.
- Containment: The change is localized to a single function and code
  path used during SVM range validation/mapping. No APIs or data
  structures are changed. It only affects the slow path when
  encountering a VMA without VM_READ; normal mappings (with READ) follow
  the existing flow unchanged.
- User impact: Prevents a hang-like condition (endless retry) that users
  would experience during SVM range restoration/validation when a VMA
  has PROT_NONE or write-only protection. This is a real, user-facing
  bug that can stall workloads using KFD/HMM.
- Risk assessment:
  - Minimal risk: The unmap is a no-op if the pages were not mapped (“If
    they weren't mapped in the first place, this would be a no-op”), and
    otherwise it correctly tears down mappings that cannot be used by
    HMM anyway (x86 doesn’t support write-only, and PROT_NONE allows
    neither reads nor writes).
  - No architectural changes: No redesign or wide-reaching behavior
    changes outside of this corner case. Logging is via pr_debug, so no
    noisy kernel logs in production.
- Stable criteria:
  - Important bugfix affecting users: Yes (prevents indefinite
    retry/hang).
  - Small and contained: Yes (~20 lines, one function).
  - No new features: Correct.
  - No broad side effects: Correct; behavior is limited to VMAs lacking
    READ, which cannot be supported by HMM.
  - Explicit stable tag: Not shown in the snippet, but the fix clearly
    meets stable backport guidelines due to the hang avoidance and
    limited scope.

Notes for backporters
- Interface compatibility: The patch relies on existing primitives
  present in amdkfd SVM code paths: vma_lookup, svm_range_lock/unlock,
  svm_range_unmap_from_gpus, KFD_SVM_UNMAP_TRIGGER_UNMAP_FROM_CPU, and
  prange fields (start/last). These are stable in recent kernels that
  have SVM/HMM in KFD.
- Unit consistency check: Ensure the parameters passed to
  svm_range_unmap_from_gpus(prange, s, e, …) are in the units expected
  by your target stable branch. In the shown diff, s/e are computed as s
  = max(start, prange->start) and e = min(end, prange->last) where
  start/end appear to be byte addresses (start = map_start <<
  PAGE_SHIFT) and prange->start/last are often page indices in KFD SVM
  code. Upstream code likely uses consistent units (either all pages or
  all bytes). When backporting, verify that s/e match the function’s
  expected units (adjust by PAGE_SHIFT if necessary) to avoid off-by-
  PAGE_SHIFT mistakes.
- Validation suggestion: Reproduce with a user VMA set to PROT_NONE or
  write-only protection and trigger SVM range validation (e.g., by
  causing GPU access). Before the fix, svm_range_restore_work would
  continuously retry; after the fix, the range is unmapped and
  validation proceeds without looping.

Why this is safe and needed
- The patch turns an unrecoverable, retry-forever condition into a
  deterministic handling path by unmapping and moving on. It does not
  try to force unsupported permissions and does not alter behavior for
  the common case. It matches HMM’s requirement that mappings be at
  least readable and avoids futile retry cycles. This is precisely the
  kind of small, correctness-oriented fix that minimizes regression risk
  and improves robustness for users of amdkfd/HMM.

 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 3d8b20828c068..cecdbcea0bb90 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1714,6 +1714,29 @@ static int svm_range_validate_and_map(struct mm_struct *mm,
 
 			next = min(vma->vm_end, end);
 			npages = (next - addr) >> PAGE_SHIFT;
+			/* HMM requires at least READ permissions. If provided with PROT_NONE,
+			 * unmap the memory. If it's not already mapped, this is a no-op
+			 * If PROT_WRITE is provided without READ, warn first then unmap
+			 */
+			if (!(vma->vm_flags & VM_READ)) {
+				unsigned long e, s;
+
+				svm_range_lock(prange);
+				if (vma->vm_flags & VM_WRITE)
+					pr_debug("VM_WRITE without VM_READ is not supported");
+				s = max(start, prange->start);
+				e = min(end, prange->last);
+				if (e >= s)
+					r = svm_range_unmap_from_gpus(prange, s, e,
+						       KFD_SVM_UNMAP_TRIGGER_UNMAP_FROM_CPU);
+				svm_range_unlock(prange);
+				/* If unmap returns non-zero, we'll bail on the next for loop
+				 * iteration, so just leave r and continue
+				 */
+				addr = next;
+				continue;
+			}
+
 			WRITE_ONCE(p->svms.faulting_task, current);
 			r = amdgpu_hmm_range_get_pages(&prange->notifier, addr, npages,
 						       readonly, owner, NULL,
-- 
2.51.0

