Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4581D5ABA;
	Sat, 14 Feb 2026 01:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031142; cv=none; b=T0Nkwvn6GyVHSy3Al+aLFjpwUqJtD8jFxxznj4ZT8fXUTU9OHGgDKoITgAbymiNTMfVurxS1f85oDyf+PKVkqvLEtwP0MkJ5qIVnUMzWOZO0oAnZ5EeoyHbP7RWzDpPJM+eLHj7zf5aAmej2BAnMBEo7HfjncNwCC9Ho3B0UK0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031142; c=relaxed/simple;
	bh=W53QJEJAmrPalFrMxaKV2Qv8HFHkH2FBkXh51NWtAwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdlVgbB4Yoa6dkXSrxUd5c2eXR0ZRnh9tQq4vFkCj3hqUKUaXaHGaziYdIata0fCWamQKDq6k3ucvzupl2JnPqSVodqpzzWiDYxqrb8uiWakYTva90bgHRsZD4Ei0Y+BjLDx49gziUi3WjWy2PYRmSjY3rb9DifgivXgYfp4eLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DH1vhD4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DH1vhD4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA47AC16AAE;
	Sat, 14 Feb 2026 01:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031142;
	bh=W53QJEJAmrPalFrMxaKV2Qv8HFHkH2FBkXh51NWtAwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DH1vhD4+OGqnFhMVWC1NsWWnjWlpZp8wrTXKhSjMnb4qyIo7OoAaqf1NHHe845V3B
	 GxK5g2zva9qGBsNRLBxhKWscJzJVbVJieIQrr0ZcQGYy+aeoZVSpb8LqcXxfkBdbxm
	 q/ahjJZ4/+KpCrLnAqhwIGUtfUk80GieUxAkZxMmcDGuwSSndm23uDTJ3jA6PD4PpJ
	 24uu1qRFQesl1BBNPc2jnp2/m1352xZFJ7lzzWNSZs/8dyd5VmFDh3Z4/5BeNwfrri
	 MdRi3Xx/kA3lDgUvjndgv2JnddKYaCLGacDa7+NOtP6i0km51vN1zLh96RdCf3oB8a
	 pdzj7Xsqqdd7A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Philip Yang <Philip.Yang@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.19-6.12] drm/amdkfd: Handle GPU reset and drain retry fault race
Date: Fri, 13 Feb 2026 19:59:20 -0500
Message-ID: <20260214010245.3671907-80-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 5b57c3c3f22336e8fd5edb7f0fef3c7823f8eac1 ]

Only check and drain IH1 ring if CAM is not enabled.

If GPU is under reset, don't access IH to drain retry fault.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile my findings.

---

## Detailed Analysis

### 1. Commit Message Analysis

**Subject:** "drm/amdkfd: Handle GPU reset and drain retry fault race"

The commit addresses a **race condition** between GPU reset and the
drain retry fault mechanism. The message describes two specific fixes:

1. "Only check and drain IH1 ring if CAM is not enabled" - a correctness
   fix for interrupt handler ring selection logic
2. "If GPU is under reset, don't access IH to drain retry fault" -
   protecting against hardware access during GPU reset

Both are bug fix descriptions, not feature additions.

### 2. Code Change Analysis

The patch makes two distinct changes in `kfd_svm.c`:

#### Change A: `svm_range_drain_retry_fault()` - GPU reset protection

**Before (current code):**

```2337:2364:drivers/gpu/drm/amd/amdkfd/kfd_svm.c
static void svm_range_drain_retry_fault(struct svm_range_list *svms)
{
        // ... iterates over GPUs ...
                amdgpu_ih_wait_on_checkpoint_process_ts(pdd->dev->adev,
                                pdd->dev->adev->irq.retry_cam_enabled ?
                                &pdd->dev->adev->irq.ih :
                                &pdd->dev->adev->irq.ih1);
                // ... no reset protection ...
}
```

**After (patched code):** Adds
`down_read_trylock(&pdd->dev->adev->reset_domain->sem)` before accessing
the IH hardware and `up_read(...)` after. If the trylock fails (GPU is
resetting), it `continue`s to the next GPU.

**Why this matters:** `svm_range_drain_retry_fault()` calls
`amdgpu_ih_wait_on_checkpoint_process_ts()` which calls
`amdgpu_ih_get_wptr()`. Looking at `vega20_ih_get_wptr()`, it does
`RREG32_NO_KIQ(ih_regs->ih_rb_wptr)` - a **direct hardware register
read**. During GPU reset (`amdgpu_device_lock_reset_domain` takes a
write lock on `reset_domain->sem`), the hardware is being torn down and
reinitialized. Accessing registers during this window can cause:
- **System hangs** (MMIO reads to offline hardware can hang the CPU bus)
- **Garbage data reads** leading to incorrect behavior
- **Kernel crashes** if the driver acts on invalid data

This is the **exact same pattern** used throughout the amdgpu driver -
there are **20+ existing call sites** that use
`down_read_trylock(&adev->reset_domain->sem)` to protect hardware
access. The fix follows an established, well-tested pattern.

#### Change B: `svm_range_unmap_from_cpu()` - CAM-aware IH1 check

**Before:**
```c
if (adev->irq.ih1.ring_size) {
```

**After:**
```c
if (!adev->irq.retry_cam_enabled && adev->irq.ih1.ring_size) {
```

The comment already says "Check and drain ih1 ring if cam not available"
but the code was missing the `!retry_cam_enabled` check. When CAM
(Content Addressable Memory) is enabled for retry filtering, retry
faults go through the primary IH ring (`ih`), not `ih1`. Checking `ih1`
when CAM is enabled is incorrect because:
- The timestamp from `ih1` would be stale/irrelevant
- It could cause the code to `continue` early (bypassing the `ih_soft`
  check below) with an incorrect `checkpoint_ts`
- This leads to retry faults being incorrectly dropped or not dropped
  when they should be

This same logic (`if (adev->irq.retry_cam_enabled) return;` before `ih1`
access) already exists in `amdgpu_gmc_filter_faults_remove()`,
confirming that the fix aligns with the intended design.

### 3. Bug Classification

- **Change A:** Race condition fix - accessing hardware registers
  without reset domain protection. This is a **system hang / crash**
  bug.
- **Change B:** Logic bug - checking the wrong interrupt handler ring
  when CAM is enabled, leading to incorrect retry fault handling
  (potential data corruption or stale page mappings).

### 4. Scope and Risk Assessment

- **Lines changed:** ~10 lines of actual logic (plus 1 include)
- **Files changed:** 1 file (`kfd_svm.c`)
- **Complexity:** Low - follows a well-established pattern (20+ examples
  in the codebase)
- **Risk of regression:** Very low
  - The `down_read_trylock` pattern is used everywhere in amdgpu and is
    proven safe
  - If trylock fails, we simply skip draining for that GPU (graceful
    degradation)
  - The CAM check aligns with existing logic in
    `amdgpu_gmc_filter_faults_remove()`

### 5. User Impact

- **Affected users:** Anyone using AMD GPUs with KFD
  (compute/ROCm/OpenCL workloads) who experiences GPU resets
- **Severity:** HIGH - GPU reset + drain retry fault = potential system
  hang when register access hangs the CPU
- **Without fix:** If a GPU reset happens concurrently with
  `svm_range_list_fini()` (process exit), the system could hang trying
  to read hardware registers from an offline GPU

### 6. Dependencies

- Requires `amdgpu_reset.h` (available since v6.1)
- Requires `reset_domain->sem` infrastructure (available since v6.1)
- Requires `retry_cam_enabled` field (available since the CAM commit in
  6.6)
- The `svm_range_drain_retry_fault()` function in its current form (with
  the `retry_cam_enabled` ternary) was introduced in 6.12 (commit
  `6ef29715ac06`)
- This patch applies cleanly only to trees with `6ef29715ac06` and
  `96316211eb5c4` (both in 6.12+)

### 7. Stability Indicators

- **Reviewed-by:** Harish Kasiviswanathan (AMD kernel engineer)
- **Author:** Philip Yang (AMD KFD maintainer, regularly contributes SVM
  retry fault fixes)
- **Signed-off-by:** Alex Deucher (AMD GPU subsystem maintainer)
- Pattern is well-established in the driver (20+ existing similar uses)

### Conclusion

This commit fixes two real bugs:

1. A **race condition** between GPU reset and IH ring access that can
   cause **system hangs** - this is the critical fix
2. A **logic error** in IH ring selection when CAM is enabled that
   causes incorrect retry fault handling

The fix is small (10 lines of logic), follows an extremely well-
established pattern in the amdgpu driver (20+ existing call sites use
the same `down_read_trylock` on `reset_domain->sem`), has been reviewed
by an AMD engineer, was authored by the KFD SVM subsystem expert, and
addresses a real crash/hang scenario. The risk of regression is minimal.

The fix applies to kernels 6.12+ where `6ef29715ac06` ("drm/amdkfd:
Change kfd/svm page fault drain handling") exists.

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 79ea138897fcf..a10cf8650c92b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -33,6 +33,7 @@
 #include "amdgpu_hmm.h"
 #include "amdgpu.h"
 #include "amdgpu_xgmi.h"
+#include "amdgpu_reset.h"
 #include "kfd_priv.h"
 #include "kfd_svm.h"
 #include "kfd_migrate.h"
@@ -2349,6 +2350,9 @@ static void svm_range_drain_retry_fault(struct svm_range_list *svms)
 
 		pr_debug("drain retry fault gpu %d svms %p\n", i, svms);
 
+		if (!down_read_trylock(&pdd->dev->adev->reset_domain->sem))
+			continue;
+
 		amdgpu_ih_wait_on_checkpoint_process_ts(pdd->dev->adev,
 				pdd->dev->adev->irq.retry_cam_enabled ?
 				&pdd->dev->adev->irq.ih :
@@ -2358,6 +2362,7 @@ static void svm_range_drain_retry_fault(struct svm_range_list *svms)
 			amdgpu_ih_wait_on_checkpoint_process_ts(pdd->dev->adev,
 				&pdd->dev->adev->irq.ih_soft);
 
+		up_read(&pdd->dev->adev->reset_domain->sem);
 
 		pr_debug("drain retry fault gpu %d svms 0x%p done\n", i, svms);
 	}
@@ -2541,7 +2546,7 @@ svm_range_unmap_from_cpu(struct mm_struct *mm, struct svm_range *prange,
 		adev = pdd->dev->adev;
 
 		/* Check and drain ih1 ring if cam not available */
-		if (adev->irq.ih1.ring_size) {
+		if (!adev->irq.retry_cam_enabled && adev->irq.ih1.ring_size) {
 			ih = &adev->irq.ih1;
 			checkpoint_wptr = amdgpu_ih_get_wptr(adev, ih);
 			if (ih->rptr != checkpoint_wptr) {
-- 
2.51.0

