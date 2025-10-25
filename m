Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8A6306490;
	Sat, 25 Oct 2025 16:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409642; cv=none; b=LOFKs3IdLuD6uZd1rotpzbqPrZbVLu9rwc0MT8eb8UnkhAz05q3pcOMNw8fjw5W5D04tZFIY00ml7ZI/ecGRPwRHvjuyA3+2kPCbXsmKzMumf/J/zPggqw9NcetelZ96iPKe8f0IiPYNodBjaYyYuyI+FQDaGP7YRrLOWcFUGE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409642; c=relaxed/simple;
	bh=VE264P+OydNZRk6EfkVGtbuO77L6Hj+dsXgOCMvVLRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=doUTLqg41tjTlgjXGHdtcD0RpSozUFgWMfS2aNgV4WGNYM73xOBXQZDW0xvvdoOrIK7vmWpwq+ga5ZHFGpNI/LBW5n7h1kWq4vFp9T5fICeA+CNY6XY99auwjBAt7rUT0MvgnKgvgYFYQIxGyMEiwfc5MGDOY46DHMRUPssPSTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDP8pcZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDP8pcZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727C8C4CEFF;
	Sat, 25 Oct 2025 16:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409642;
	bh=VE264P+OydNZRk6EfkVGtbuO77L6Hj+dsXgOCMvVLRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDP8pcZ3vbUWggXGtPSTAgDTOzeMJ+lxFd7pnX3W4OYjPyZwKm/m4qXD4cjgENcu2
	 Q1PceB2nMzq80o4wnikBPsvFYNFHrWBGYeYyN4T+kEmo7S7JAmMTyAQz1/DHl/MP43
	 WCMZ2viZRe71thVaEG8rLO5nVmklrgODs43ZJnTPKF60XUe05fGmxndBaK9uE/tFRX
	 X/oVzuWzEHBjY/jNe2z/bdT1TdsgK/r+gB/fsWy498k6t44oZxvpTb+8cTpnz9BiCP
	 ST/sTFkDpZNhX+YTo7N4W1OgF8c6ogEAvlRZlN1rr7IsPJM6hnqkfvaRBYNUFG+lac
	 LPAofCcxWLSfg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Huang <jinhuieric.huang@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17-6.1] drm/amdkfd: fix vram allocation failure for a special case
Date: Sat, 25 Oct 2025 12:00:34 -0400
Message-ID: <20251025160905.3857885-403-sashal@kernel.org>
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

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit 93aa919ca05bec544b17ee9a1bfe394ce6c94bd8 ]

When it only allocates vram without va, which is 0, and a
SVM range allocated stays in this range, the vram allocation
returns failure. It should be skipped for this case from
SVM usage check.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

This is a small, targeted bug fix that prevents erroneous -EADDRINUSE
failures when userspace allocates a VRAM buffer without providing a VA
(i.e., `va_addr == 0`). The change is confined to the KFD ioctl path and
poses minimal regression risk while fixing a real user-visible issue.

What changed
- In `drivers/gpu/drm/amd/amdkfd/kfd_chardev.c:1045`, inside
  `kfd_ioctl_alloc_memory_of_gpu`, the SVM overlap check was amended to
  skip a special case:
  - New guard added at `drivers/gpu/drm/amd/amdkfd/kfd_chardev.c:1071`:
    - `if (!(!args->va_addr && (flags & KFD_IOC_ALLOC_MEM_FLAGS_VRAM))
      && interval_tree_iter_first(...)) { ... return -EADDRINUSE; }`
  - Practically, this means the SVM interval-tree overlap check is
    bypassed only when:
    - `args->va_addr == 0` (no VA requested), and
    - `flags` includes `KFD_IOC_ALLOC_MEM_FLAGS_VRAM`.
  - Previously, the overlap check was unconditional, which could falsely
    report “Address already allocated by SVM” when VA is 0 (see the
    surrounding context at
    `drivers/gpu/drm/amd/amdkfd/kfd_chardev.c:1064-1079`).

Why it’s a bug fix
- The commit message accurately describes a failure mode: when
  allocating VRAM-only without a VA (VA=0) and there exists an SVM range
  that falls in that [0, size) range, the ioctl incorrectly returns
  `-EADDRINUSE`. For VRAM-only allocations without a VA, SVM address-
  range conflicts are irrelevant and should not block allocation.
- The code change corrects this by skipping the SVM overlap check for
  that specific case, avoiding a false-positive error.

Safety and scope
- Minimal, localized change: It adds a single conditional guard and
  comment in one function. No ABI or architectural changes.
- Confined to AMD KFD user memory allocation path; does not touch core
  MM, scheduler, or unrelated GPU subsystems.
- Consistency with mapping rules: mapping requires a non-zero VA. In
  `kfd_mem_attach` (called during mapping), mapping with `mem->va == 0`
  is rejected
  (`drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c:858-930`, check at
  “if (!va) { ... return -EINVAL; }”). This ensures that skipping the
  SVM check for VA=0 can’t accidentally permit an overlapping SVM GPU-VA
  mapping later: mapping at VA=0 is inherently invalid and denied. Thus
  the change strictly avoids a spurious allocation-time error without
  enabling unsafe mappings.
- Flags behavior matches UAPI: `KFD_IOC_ALLOC_MEM_FLAGS_VRAM` is
  intended for VRAM allocations (`include/uapi/linux/kfd_ioctl.h:407`).
  VRAM-only allocations with VA=0 are valid for certain use cases (e.g.,
  export or CPU-visible VRAM on large BAR), and should not be blocked by
  SVM interval checks.

Stable backport criteria
- Fixes a real bug affecting users (spurious -EADDRINUSE on valid VRAM-
  only allocations).
- Change is small and contained, with clear intent and low regression
  risk.
- No new features or architectural shifts.
- Touches only driver code in a single path
  (`kfd_ioctl_alloc_memory_of_gpu`), no widespread side effects.

Conclusion
- This is a clear, minimal bug fix that prevents erroneous allocation
  failures and aligns with the mapping semantics already enforced
  elsewhere. It is suitable for stable backport.

 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 79ed3be63d0dd..43115a3744694 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1070,7 +1070,12 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
 	svm_range_list_lock_and_flush_work(&p->svms, current->mm);
 	mutex_lock(&p->svms.lock);
 	mmap_write_unlock(current->mm);
-	if (interval_tree_iter_first(&p->svms.objects,
+
+	/* Skip a special case that allocates VRAM without VA,
+	 * VA will be invalid of 0.
+	 */
+	if (!(!args->va_addr && (flags & KFD_IOC_ALLOC_MEM_FLAGS_VRAM)) &&
+	    interval_tree_iter_first(&p->svms.objects,
 				     args->va_addr >> PAGE_SHIFT,
 				     (args->va_addr + args->size - 1) >> PAGE_SHIFT)) {
 		pr_err("Address: 0x%llx already allocated by SVM\n",
-- 
2.51.0

