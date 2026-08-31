Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BC04C77CE;
	Mon, 31 Aug 2026 13:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183544; cv=none; b=NZk7perIPvdWBhsvQnye39iuEhdPsCs9T04nPsGLZ7fgYLtipTnjATs9sugyE5/r7pBkY9PLM/C8ARFdr//mdNJzv/qhCmhZFcKVG6uWtCyzCPKHuN+twFKW3v49GoMZrTagCUiuuRHJT0pn5cCHADMCbgUbyu5SpFF/k8cDFD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183544; c=relaxed/simple;
	bh=RCWdAs8Xw3ancUHSJnz3jhNBXeSYLLUU4r9NeoQfPxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uY5sbxmC46dBCHdOIBvHZM5HKebVB8TFpFQqMbJAdlASB/yhCOL0reNQOnE1RmIJ7qks3MsDEHZVeCHDuCao5r7YDSmCZ13IKwlpOfWvDO5yeSNbooHyxFw2gVpIZo9cNB1m9579ii8MA1cUe3+lyxRtj9S1zDQPa6PrtMA2l8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VrlesS+S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VrlesS+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1451F00A3F;
	Mon, 31 Aug 2026 13:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183541;
	bh=MarN4AraKuRVOJPKbh8zqsJjzOiy10fIeHb6tsohb+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VrlesS+SfoS/09Oc/rvl/pOuiaVCDRkAW2iJDbkrcw2qhM73PS9M/XBL/ozY3y2oI
	 0QnYNIJvHERVXoXMY3IPGMBbIVxCo1vZv4P864hs0cBH1s59hB4rv6sWhTWVbK0iIw
	 90tTunl3fEDBrzHO/w5sOQUVNZNpII8koUZABtZcytr4BbcdPvDxqQ8CJQvP0LR6Oh
	 8eJSRlRnVPWQNHtVbFwinQZ7Xve19QwLAcTpyrksmvgcXfbpVUCJ0AShsF+iyDT6DX
	 ANHa8WSeiiYDC/4UeicMFFZ65uG2nxQdrnie7Kkpq0UXne1JufaiowuK6zluTtnyNb
	 V04PTRDZDZugQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiaogang Chen <xiaogang.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] drm/amdkfd: Let driver decide buffer size at AMDKFD_IOC_GET_DMABUF_INFO ioctl
Date: Mon, 31 Aug 2026 09:23:06 -0400
Message-ID: <20260831133314.4125787-158-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit 8242a8d9d7194d5ef8a8b38a5621ca0966a3ec15 ]

amdkfd driver needs allocate buffer to return bo metadata to user space. The
buffer size is controlled by user currently. It is a potential security issue
that hostile value (e.g. 2 GiB) lets any render-group user trigger order-MAX
allocation/OOM in kernel context.

This patch first finds bo metadata size. If the size is smaller than user
provided value drive can safely allocate buffer in kernel space and copy to
user space buffer. If not, driver will let user know, not allocate and copy.
User will redo with new buffer in user space.

This patch lets driver decide buffer allocation size to avoid potential hostile
size from user space.

Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f54ce9e8cbd3abe0eda3a285f54dc4f572fe589a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[drm/amdkfd]` `[Let driver decide]` — ioctl security hardening
for `AMDKFD_IOC_GET_DMABUF_INFO` so the kernel no longer allocates based
on user-supplied buffer size.

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>` (author)
- `Reviewed-by: Alex Deucher <alexander.deucher@amd.com>` (AMD DRM
  maintainer)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (committer)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable@vger.kernel.org`,
  `Tested-by:`, or `Acked-by:`

Notable: maintainer review only; no fuzzer or user bug report cited.

**Step 1.3 — Body analysis**

Record:
- **Bug:** `kfd_ioctl_get_dmabuf_info()` allocates a kernel buffer with
  `kzalloc(args->metadata_size, GFP_KERNEL)` where `metadata_size` is
  fully user-controlled.
- **Symptom:** A render-group user can pass a hostile size (e.g. 2 GiB)
  and force large kernel allocations → OOM / denial of service.
- **Root cause:** Allocation size is driven by userspace, not by actual
  BO metadata size.
- **Fix approach:** Query actual metadata size first via
  `amdgpu_bo_get_metadata()` with `buffer=NULL`; allocate only
  `*metadata_size` bytes (bounded by driver data); reject with `-EINVAL`
  if user buffer is too small.
- **Version info:** None in message.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Although not labeled “fix”, this is a classic user-
controlled kernel allocation / DoS hardening pattern, same class as
other KFD ioctl validation fixes already in stable.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- `drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c`: +15 / -3
- `drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h`: signature change (1
  line)
- `drivers/gpu/drm/amd/amdkfd/kfd_chardev.c`: +2 / -8
- **Functions:** `amdgpu_amdkfd_get_dmabuf_info()`,
  `kfd_ioctl_get_dmabuf_info()`
- **Scope:** Single-subsystem, 3-file surgical fix (~22 insertions, ~13
  deletions)

**Step 2.2 — Code flow per hunk**

Record:
1. **`kfd_chardev.c`:** Before → `kzalloc(args->metadata_size)` when
   `metadata_ptr` set. After → no user-size allocation; passes
   `&metadata_buffer` to helper; copies only if both kernel buffer and
   `metadata_ptr` are set.
2. **`amdgpu_amdkfd.c`:** Before → passes user buffer directly to
   `amdgpu_bo_get_metadata()`. After → queries size with `buffer=NULL`,
   allocates `kzalloc(*metadata_size)` only when `*metadata_size <=
   buffer_size`, else `-EINVAL`.
3. **`amdgpu_amdkfd.h`:** `metadata_buffer` parameter becomes `void **`
   so callee can allocate and return buffer pointer.

**Step 2.3 — Bug mechanism**

Record: **Memory safety / DoS via user-controlled allocation size.**
Category: unvalidated userspace size passed to `kzalloc()` in ioctl
handler. Fix caps kernel allocation to actual BO metadata size (small,
driver-controlled).

**Step 2.4 — Fix quality**

Record: **Obviously correct** for the stated problem. Minimal, focused
change. Minor concern: on `kzalloc()` failure the fix returns `-ENOMEM`
directly without `goto out_put`, leaking a `dma_buf` reference — rare
path, does not undermine the security fix. No API or UAPI structure
changes.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: Vulnerable `kzalloc(args->metadata_size, ...)` introduced in
`1dde0ea95b782` (Felix Kuehling, 2018-11-20) — “drm/amdkfd: Add DMABuf
import functionality”. Bug present since v4.20 era; definitely present
in this 6.18.44 tree.

**Step 3.2 — Fixes: tag**

Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related file history**

Record: Related stable-style KFD ioctl hardening already in this tree:
- `db9530a9873a7` — “drm/amdkfd: validate SVM ioctl nattr against buffer
  size” (cherry-picked to stable by Greg K-H)
- `9e52212aff8ed` — missing authorization check fix
- `6156c101e5f08` — `memdup_user` replacing `kzalloc` + `copy_from_user`

Standalone fix; not part of a multi-patch series.

**Step 3.4 — Author context**

Record: Xiaogang Chen is an AMD contributor (recent KFD/amdgpu commits).
Alex Deucher reviewed and committed — strong subsystem credibility.

**Step 3.5 — Dependencies**

Record: **None.** Uses existing `amdgpu_bo_get_metadata()` NULL-buffer
query path (supported since that function was written). Only caller of
`amdgpu_amdkfd_get_dmabuf_info()` is `kfd_ioctl_get_dmabuf_info()`. `git
apply --check` passes cleanly on this tree.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig -c f54ce9e8cbd3` — **no match found** on
lore.kernel.org. Manual lore search blocked (Anubis bot protection).
Phase partially N/A.

**Step 4.2 — Reviewers from b4 -w**

Record: N/A (b4 found nothing).

**Step 4.3 — Bug report**

Record: N/A — no `Reported-by:` or `Link:` tags.

**Step 4.4 — Related patches**

Record: Same subsystem pattern as `db9530a9873a7` (user-controlled ioctl
sizing). No series dependency.

**Step 4.5 — Stable list**

Record: Could not search lore stable archive (bot protection). However,
analogous KFD ioctl validation was already accepted into this 6.18.y
tree (`db9530a9873a7`).

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `kfd_ioctl_get_dmabuf_info()`,
`amdgpu_amdkfd_get_dmabuf_info()`, `amdgpu_bo_get_metadata()`.

**Step 5.2 — Callers**

Record: `kfd_ioctl_get_dmabuf_info()` registered as
`AMDKFD_IOC_GET_DMABUF_INFO` ioctl handler (render-node accessible).
`amdgpu_amdkfd_get_dmabuf_info()` called only from that ioctl path.

**Step 5.3 — Callees**

Record: `dma_buf_get/put`, `amdgpu_bo_get_metadata()`, `kzalloc/kfree`,
`copy_to_user`, `kfd_devcgroup_check_permission()`.

**Step 5.4 — Reachability**

Record: **Userspace-reachable** via `/dev/kfd` ioctl from processes with
render-node access (`kfd_devcgroup_check_permission()` checks
`DEVCG_ACC_READ|WRITE` on DRM render minor). Attacker needs render-group
membership and a valid amdgpu dmabuf fd — realistic on desktop/container
ROCm/GPU compute setups.

**Step 5.5 — Similar patterns**

Record: Same anti-pattern fixed elsewhere in KFD (`db9530a9873a7` for
SVM ioctl). Confirms subsystem maintainers treat user-controlled ioctl
allocation sizes as security issues.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is **Linux 6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`). Commit `f54ce9e8cbd3` is **not** an
ancestor of HEAD. Vulnerable code confirmed at
`kfd_chardev.c:1527-1530`:

```1527:1531:drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
        if (args->metadata_ptr) {
                metadata_buffer = kzalloc(args->metadata_size,
GFP_KERNEL);
                if (!metadata_buffer)
                        return -ENOMEM;
        }
```

**Step 6.2 — Backport complications**

Record: **Clean apply** — `git show f54ce9e8cbd3 | git apply --check`
succeeds with no conflicts.

**Step 6.3 — Related fixes already present?**

Record: No duplicate fix for this ioctl. Related KFD ioctl validation
fixes exist (`db9530a9873a7`) but not for `GET_DMABUF_INFO`.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**

Record: `drivers/gpu/drm/amd/amdkfd` — **IMPORTANT** (AMD GPU compute /
ROCm users; not universal core kernel, but widely deployed on AMD
systems with `CONFIG_DRM_AMDGPU`).

**Step 7.2 — Activity**

Record: Actively maintained — 20 recent commits on `kfd_chardev.c`
including multiple security/validation fixes in 2026.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users of AMD KFD/ROCm with amdgpu (`CONFIG_DRM_AMDGPU=y/m`). Any
process in the GPU render group on multi-user or containerized systems.

**Step 8.2 — Trigger conditions**

Record: Call `AMDKFD_IOC_GET_DMABUF_INFO` with `metadata_ptr != 0` and
large `metadata_size` (e.g. 2 GiB). **Likelihood:** trivial for
authorized render-group users. **Unprivileged:** requires render-node
access (not fully unprivileged, but local DoS from less-privileged GPU
users is a recognized security concern).

**Step 8.3 — Failure mode severity**

Record: **Kernel OOM / memory exhaustion DoS** — **HIGH** severity
(system-wide impact possible). Not data corruption or privilege
escalation, but a reproducible resource exhaustion attack from userspace
ioctl.

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** HIGH — closes long-standing (since 2018) user-controlled
  kernel allocation hole
- **Risk:** LOW — ~35-line change, reviewed by maintainer, applies
  cleanly, no UAPI changes
- **Ratio:** Strong benefit, low risk

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR backport:**
- Real security issue: user-controlled `kzalloc()` size in ioctl
- DoS / OOM impact on systems with AMD GPU compute
- Bug present in this 6.18.44 tree since 2018
- Small, surgical, maintainer-reviewed fix
- Applies cleanly
- Same class of fix already accepted in this tree (`db9530a9873a7`)
- `amdgpu_bo_get_metadata()` already supports size-only query with
  `buffer=NULL`

**AGAINST backport:**
- Requires render-group access (not arbitrary unprivileged user) —
  reduces universality but not severity for multi-tenant GPU systems
- Minor `dma_buf` leak on `ENOMEM` in the fix itself (rare)
- No external bug report or syzbot confirmation

**Unresolved:** Lore discussion and stable-list nomination could not be
retrieved.

**Step 9.2 — Stable rules checklist**

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — logic is clear;
Reviewed-by maintainer; no Tested-by |
| 2. Fixes real bug affecting users? | **PASS** — user-controlled kernel
allocation DoS |
| 3. Important issue? | **PASS** — HIGH (OOM DoS from ioctl) |
| 4. Small and contained? | **PASS** — 3 files, ~35 lines |
| 5. No new features/APIs? | **PASS** — same ioctl, hardened allocation
|
| 6. Can apply to local tree? | **PASS** — clean `git apply --check` |

**Step 9.3 — Exception category**

Record: Security hardening of existing ioctl (not device ID, quirk, DT,
build, or docs exception — standard security bug fix).

**Step 9.4 — Decision rationale**

This commit fixes a long-standing vulnerability where any render-group
user can force arbitrarily large kernel allocations via
`AMDKFD_IOC_GET_DMABUF_INFO`. The buggy code exists in the local 6.18.44
tree, the fix is small and maintainer-reviewed, it applies cleanly, and
the same subsystem has already accepted analogous ioctl validation fixes
for stable. The fix bounds kernel allocation to actual BO metadata size
(driver-controlled, typically small), eliminating the OOM attack vector.

---

## Verification

- [Phase 1] Parsed commit `f54ce9e8cbd3` message: security issue, user-
  controlled allocation, Reviewed-by Alex Deucher
- [Phase 2] Full diff reviewed: 3 files, `kzalloc` moved from user size
  to `*metadata_size`
- [Phase 2] Read `amdgpu_bo_get_metadata()`: supports `buffer=NULL` +
  `metadata_size` out-param (`amdgpu_object.c:1227-1233`)
- [Phase 3] `git blame` lines 1527-1531 → `1dde0ea95b782` (2018-11-20)
- [Phase 3] `git log -S kfd_ioctl_get_dmabuf_info` → introduced in
  `1dde0ea95b782`
- [Phase 3] `git log --oneline -20 -- kfd_chardev.c` → related stable
  fix `db9530a9873a7` present
- [Phase 3] `grep amdgpu_amdkfd_get_dmabuf_info` → single caller in
  `kfd_chardev.c`
- [Phase 3] `git apply --check` → patch applies cleanly
- [Phase 4] `b4 dig -c f54ce9e8cbd3` → no lore match
- [Phase 4] lore.kernel.org manual fetch → blocked by Anubis (UNVERIFIED
  for list discussion)
- [Phase 5] Read `kfd_devcgroup_check_permission()` → render-node cgroup
  check (`kfd_priv.h:1564-1576`)
- [Phase 5] Confirmed ioctl registration at `kfd_chardev.c:3232-3233`
- [Phase 6] `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- [Phase 6] `git merge-base --is-ancestor f54ce9e8cbd3 HEAD` → commit
  NOT in tree
- [Phase 6] Read current `kfd_chardev.c:1527-1530` → vulnerable code
  present
- [Phase 8] Assessed failure mode: OOM DoS, HIGH severity for GPU multi-
  tenant scenarios

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c | 23 ++++++++++++++++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c   | 10 ++--------
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
index 1ec26be82f30e..5e8d0d6b55ab6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -528,7 +528,7 @@ uint32_t amdgpu_amdkfd_get_max_engine_clock_in_mhz(struct amdgpu_device *adev)
 
 int amdgpu_amdkfd_get_dmabuf_info(struct amdgpu_device *adev, int dma_buf_fd,
 				  struct amdgpu_device **dmabuf_adev,
-				  uint64_t *bo_size, void *metadata_buffer,
+				  uint64_t *bo_size, void **metadata_buffer,
 				  size_t buffer_size, uint32_t *metadata_size,
 				  uint32_t *flags, int8_t *xcp_id)
 {
@@ -563,9 +563,24 @@ int amdgpu_amdkfd_get_dmabuf_info(struct amdgpu_device *adev, int dma_buf_fd,
 		*dmabuf_adev = adev;
 	if (bo_size)
 		*bo_size = amdgpu_bo_size(bo);
-	if (metadata_buffer)
-		r = amdgpu_bo_get_metadata(bo, metadata_buffer, buffer_size,
-					   metadata_size, &metadata_flags);
+	if (metadata_buffer) {
+		/* first get metadata_size by buffer = NULL */
+		r = amdgpu_bo_get_metadata(bo, NULL, 0,
+					   metadata_size, NULL);
+
+		/* user buf_size is bigger than bo metadata_size
+		 * allocate a buf at kernel space and copy */
+		if (*metadata_size <= buffer_size) {
+			*metadata_buffer = kzalloc(*metadata_size, GFP_KERNEL);
+
+			if (!*metadata_buffer)
+				return -ENOMEM;
+
+			r = amdgpu_bo_get_metadata(bo, *metadata_buffer, *metadata_size,
+						   NULL, &metadata_flags);
+		} else
+			r = -EINVAL;
+	}
 	if (flags) {
 		*flags = (bo->preferred_domains & AMDGPU_GEM_DOMAIN_VRAM) ?
 				KFD_IOC_ALLOC_MEM_FLAGS_VRAM
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 9e120c934cc17..c59b5d9cd36b6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -255,7 +255,7 @@ uint64_t amdgpu_amdkfd_get_gpu_clock_counter(struct amdgpu_device *adev);
 uint32_t amdgpu_amdkfd_get_max_engine_clock_in_mhz(struct amdgpu_device *adev);
 int amdgpu_amdkfd_get_dmabuf_info(struct amdgpu_device *adev, int dma_buf_fd,
 				  struct amdgpu_device **dmabuf_adev,
-				  uint64_t *bo_size, void *metadata_buffer,
+				  uint64_t *bo_size, void **metadata_buffer,
 				  size_t buffer_size, uint32_t *metadata_size,
 				  uint32_t *flags, int8_t *xcp_id);
 int amdgpu_amdkfd_get_pcie_bandwidth_mbytes(struct amdgpu_device *adev, bool is_min);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index d3190c3bb1aee..d220cf60375ba 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1524,16 +1524,10 @@ static int kfd_ioctl_get_dmabuf_info(struct file *filep,
 	if (!dev)
 		return -EINVAL;
 
-	if (args->metadata_ptr) {
-		metadata_buffer = kzalloc(args->metadata_size, GFP_KERNEL);
-		if (!metadata_buffer)
-			return -ENOMEM;
-	}
-
 	/* Get dmabuf info from KGD */
 	r = amdgpu_amdkfd_get_dmabuf_info(dev->adev, args->dmabuf_fd,
 					  &dmabuf_adev, &args->size,
-					  metadata_buffer, args->metadata_size,
+					  &metadata_buffer, args->metadata_size,
 					  &args->metadata_size, &flags, &xcp_id);
 	if (r)
 		goto exit;
@@ -1545,7 +1539,7 @@ static int kfd_ioctl_get_dmabuf_info(struct file *filep,
 	args->flags = flags;
 
 	/* Copy metadata buffer to user mode */
-	if (metadata_buffer) {
+	if (metadata_buffer && args->metadata_ptr) {
 		r = copy_to_user((void __user *)args->metadata_ptr,
 				 metadata_buffer, args->metadata_size);
 		if (r != 0)
-- 
2.53.0

