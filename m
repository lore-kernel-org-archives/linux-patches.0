Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42974A4985;
	Mon, 31 Aug 2026 13:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183811; cv=none; b=AJv2VeZVo0VmaXES1JhrTYgNTMIujVmILttKszs+5VSyYb+Y9J0HvUy/cFCEmHfkCsXJakEaDJAU9ECLDy2feFzQCEBfnTCsHFqfLznbfgezFjcs8OrW9M0Ym9hGhQpiDYSsK8pRDQMVyafCTdjO0IfqqCBc15UsOi5EoWuDHW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183811; c=relaxed/simple;
	bh=uzpinNGOWYQmGN6ZNEP+r/xryJzhJLRV/XbW1sxs2mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YaL34Xtfyf2jQ5VdifhuG+EHKEFjWrEfTnwxQbMxa2RCeclDqy8KlrhOY7ok/phwsoBcsRgRfhIvloC98H3JkvQJiZzptNYpnMtx3eS7pzduhwKO35wayqvDEd41KETZBqZWz8abEFEcsVaRXgr4cidaK6LkChbGGDGlMpyX/gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bf6xtnwA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bf6xtnwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524111F00ACA;
	Mon, 31 Aug 2026 13:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183808;
	bh=psClh4hrb8WRXaHOA+7YUWMNqjmF3EMw8eZUp8Sw7rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bf6xtnwAnfmYBHQ5hL9567+brZWCaeyYC0j+PVuJPOnA3SYNUFSE6mwDpP+cuZJlE
	 SY/1q8wiJUf+8boJ7QZLiLMWC9AA1DXFzE7tbCUyTXk2SgbS9e7b2O7DEEdvp9O8Ly
	 9/55sUZ2KZziCaiUomJ14iqyqkQbYYYcAiIAUz1WTJ4EPoHDjj3UMVnTqJhFu23uBa
	 O6QuuX2WUDDaQR9bN1aHctZuEm+mBUlx++/rsWNMl03/ka5VrwPYNmwrPyGMXxaGB6
	 59F/hQWOk2+lvcmN/051wwmshK3Z2h2Ecu5EKih5MfIko6rEXaCSLTAoa1yL1iHypm
	 KRtsyCYezrmYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiang Liu <xiang.liu@amd.com>,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amd/ras: reset CPER ring on corrupt entry size
Date: Mon, 31 Aug 2026 09:25:45 -0400
Message-ID: <20260831133314.4125787-317-sashal@kernel.org>
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

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit 4d695e66d7027a0c78302e47ac76293675fbbb4d ]

When CPER ring overflow handling advances the read pointer, it trusts the
parsed entry size from the current ring contents. Corrupt CPER data can
produce an entry size that does not advance rptr after dword conversion
and pointer masking.

In that case the recovery loop keeps testing the same location while
holding the CPER ring mutex. This can hang the worker that is writing the
next CPER record.

Detect a no-progress rptr update and reset the CPER ring to an empty
state instead. This drops the corrupt contents and lets the writer leave
the recovery path without spinning.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[drm/amd/ras] [reset] reset CPER ring on corrupt entry size` —
subsystem is AMDGPU RAS/CPER; action is a defensive recovery/reset in
response to corrupt data.

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Xiang Liu <xiang.liu@amd.com>` (author)
- `Reviewed-by: Stanley.Yang <Stanley.Yang@amd.com>`
- `Reviewed-by: Tao Zhou <tao.zhou1@amd.com>`
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (maintainer)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable@vger.kernel.org`, or
  `Tested-by:` tags
- Notable: AMD subsystem reviewers and maintainer sign-off; no syzbot or
  user bug report

**Step 1.3 — Body analysis**
Record:
- **Bug:** On CPER ring overflow, the recovery loop advances `rptr`
  using parsed entry sizes from ring contents. Corrupt CPER data can
  yield an entry size that does not advance `rptr` after dword
  conversion and masking.
- **Symptom:** Recovery loop spins forever at the same location while
  holding `cper.ring_lock`, hanging the worker writing the next CPER
  record.
- **Fix:** Detect no-progress `rptr` updates and reset the ring to empty
  rather than spinning.
- **Root cause:** Trusting corrupt in-ring metadata during overflow
  recovery.

**Step 1.4 — Hidden bug fix?**
Record: Yes. Despite “reset” wording, this is a hang/deadlock-class bug
fix in error-recovery code, not a feature addition.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- File: `drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c` (+12 net lines)
- Function modified: `amdgpu_cper_ring_write()`
- Scope: single-file, surgical fix in overflow recovery path

**Step 2.2 — Code flow per hunk**
Record:
- **Before:** `rptr += (ent_sz >> 2); rptr &= ring->ptr_mask;` always
  runs; if `ent_sz` is 0, <4, or a multiple of ring circumference,
  `rptr` may not move.
- **After:** Compute `next_rptr` only when `ent_sz >= sizeof(u32)`; if
  `next_rptr == rptr`, reset ring (`rptr = wptr`, update `count_dw`,
  `goto out_unlock`); otherwise advance normally.
- **Path affected:** CPER ring overflow recovery inside
  `amdgpu_cper_ring_write()`, while `ring_lock` is held.

**Step 2.3 — Bug mechanism**
Record:
- Category: logic/correctness bug → infinite loop with mutex held (soft
  hang)
- Mechanism: corrupt `record_length` or garbage between headers can make
  `(rptr + (ent_sz >> 2)) & ptr_mask == rptr`; old code never exits the
  `do { ... } while (!amdgpu_cper_is_hdr(...))` loop

**Step 2.4 — Fix quality**
Record:
- Fix is minimal and obviously correct: no-progress detection is
  standard for ring-buffer parsers
- Recovery (drop corrupt contents, reset pointers) is preferable to
  infinite spin
- Low regression risk: only triggers on already-corrupt overflow state
- Trade-off: loses corrupt CPER records, but that is acceptable vs.
  permanent hang

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: Overflow recovery loop introduced in `a6d9d192903ea`
(“drm/amdgpu: add data write function for CPER ring”, 2025-01-22).
Present in this tree at lines 507–515. First appeared in tag `v6.15`.

**Step 3.2 — Fixes: tag**
Record: Not applicable — no `Fixes:` tag in commit message.

**Step 3.3 — Related file history**
Record: Related prior fix `d6f9bbce18762` (“Fix computation for remain
size of CPER ring”) already in this tree; it fixed a *different*
infinite-loop cause in the same function. `8e0d1edb5c167` added missing
lock protection and was nominated for stable (`Cc:
stable@vger.kernel.org`). CPER subsystem landed starting `92d5d2a09de16`
in v6.15.

**Step 3.4 — Author context**
Record: Xiang Liu authored multiple CPER fixes including `d6f9bbce18762`
(same infinite-loop class). Reviews from AMD RAS engineers and
maintainer Alex Deucher.

**Step 3.5 — Dependencies**
Record: Standalone fix; no series markers, no prerequisite commits
referenced. Assumes existing `amdgpu_cper_ring_write()` overflow path —
present in this tree.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record: `b4 dig -c d5e59c24d907d` failed (commit not in local history).
`b4 shazam` found no matching message-id. lore.kernel.org search blocked
by bot protection. **UNVERIFIED:** full review-thread content.

**Step 4.2 — Reviewers**
Record: **UNVERIFIED** via `b4 dig -w` (commit hash unavailable
locally). Commit message lists Stanley.Yang, Tao Zhou, Alex Deucher.

**Step 4.3 — Bug report**
Record: Not applicable — no `Reported-by:` or `Link:` tags.

**Step 4.4 — Related patches**
Record: Complements `d6f9bbce18762` (already in tree) which fixed
another overflow infinite-loop cause. This patch addresses corrupt-
entry-size no-progress separately.

**Step 4.5 — Stable list history**
Record: **UNVERIFIED** — lore stable search inaccessible. Prior CPER
lock fix `8e0d1edb5c167` was explicitly CC'd to stable.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `amdgpu_cper_ring_write()` (modified); uses
`amdgpu_cper_ring_get_ent_sz()`, `amdgpu_cper_is_hdr()`.

**Step 5.2 — Callers**
Record: `amdgpu_cper_ring_write()` called from:
- `amdgpu_cper_generate_ue_record()` — uncorrectable GPU errors
- `amdgpu_cper_generate_bp_threshold_record()` — bad-page threshold
  (also from `amdgpu_ras_eeprom.c`)
- `amdgpu_cper_generate_ce_records()` — corrected errors
- `amdgpu_virt.c` — SR-IOV guest CPER dump path

All are RAS/error-reporting paths on ACA-enabled or SR-IOV CPER-enabled
devices.

**Step 5.3 — Callees**
Record: `mutex_lock/unlock(&ring->adev->cper.ring_lock)`,
`amdgpu_cper_ring_get_ent_sz()`, `memcpy()`, pointer masking.

**Step 5.4 — Reachability**
Record: Triggered when CPER ring overflows during error-record writes.
Call chain: ACA bank update (`aca_banks_update` →
`aca_banks_generate_cper` → `amdgpu_cper_generate_*` →
`amdgpu_cper_ring_write`). Reachable during real GPU RAS events — the
same conditions that fill the CPER ring. Not a syscall path, but
triggered by hardware error handling that must not hang.

**Step 5.5 — Similar patterns**
Record: Prior fix `d6f9bbce18762` explicitly described “unbreakable
while cycle when CPER ring overflow” in the same function — same bug
class, different root cause.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**
Record: **Yes.** Local tree is `v6.18.44` (Makefile: 6.18.44). Buggy
code at `amdgpu_cper.c:510-511` (`rptr += (ent_sz >> 2)` without no-
progress check). CPER code is an ancestor of HEAD; first CPER commits
tagged `v6.15`.

**Step 6.2 — Backport complications**
Record: Expected **clean apply with possible minor fuzz** — the
`amdgpu_cper_ring_write()` hunk matches this tree exactly; upstream diff
context in `amdgpu_cper_ring_get_ent_sz()` differs slightly (local uses
inline `chdr` check vs. `amdgpu_cper_is_hdr()` in upstream diff), but
the fix hunk is independent.

**Step 6.3 — Related fixes already present?**
Record: `d6f9bbce18762` (different overflow loop fix) and
`8e0d1edb5c167` (lock fix) are in tree. This specific corrupt-entry-size
hang is **not** yet fixed.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**
Record: `drivers/gpu/drm/amd/amdgpu` — IMPORTANT (AMD GPU RAS/CPER error
reporting). Not universal like mm/net, but critical for affected AMD GPU
users with ACA/RAS enabled.

**Step 7.2 — Activity**
Record: CPER code is actively developed (20 commits on `amdgpu_cper.c`);
subsystem is new (v6.15+) and still receiving bug fixes.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: AMD GPU systems with CPER enabled (`amdgpu_aca_is_enabled()` or
`amdgpu_sriov_ras_cper_en()`). Config/driver-specific, but includes
production RAS workloads and SR-IOV hosts.

**Step 8.2 — Trigger conditions**
Record: CPER ring overflow **and** corrupt/non-advancing entry size in
ring buffer. Plausible when the ring already contains damaged data from
hardware errors or partial overwrites. Not everyday, but realistic in
the exact failure mode CPER exists to handle.

**Step 8.3 — Failure mode severity**
Record: **CRITICAL** — infinite loop with `cper.ring_lock` held; CPER
writer thread/worker hangs permanently; subsequent CPER records cannot
be written; RAS error logging stalls during hardware fault scenarios.

**Step 8.4 — Risk/benefit**
Record:
- **Benefit:** HIGH — prevents permanent hang in RAS error path during
  overflow recovery
- **Risk:** LOW — ~15 lines, defensive reset only on detected no-
  progress, reviewed by AMD maintainers
- **Ratio:** Strong benefit, minimal risk

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence compile**

FOR backport:
- Real infinite-loop hang with mutex held
- Affects RAS error reporting on AMD GPUs with CPER
- Small, surgical, obviously correct fix
- Buggy code present since v6.15, present in this v6.18.44 tree
- Prior related infinite-loop fix already backported-worthy and in tree
- AMD reviewer + maintainer sign-off

AGAINST backport:
- No syzbot/user bug report (weaker impact evidence, but mechanism is
  clear)
- Only affects CPER-enabled AMD GPUs (narrower audience)
- Lore review thread not verified

UNRESOLVED:
- Full mailing-list review discussion
- Whether any reviewer explicitly nominated for stable

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic is clear; reviewed by
   AMD engineers; no Tested-by
2. Fixes a real bug? **PASS** — infinite loop on corrupt overflow
   recovery
3. Important issue? **PASS** — worker hang during RAS error handling
   (CRITICAL)
4. Small and contained? **PASS** — one file, ~15 lines
5. No new features/APIs? **PASS** — defensive recovery only
6. Can apply to local tree? **PASS** — target code exists; fix hunk
   matches

**Step 9.3 — Exception categories**
Record: Not a device-ID/quirk/DT/docs/build fix. Qualifies as a critical
bug fix on its own merits.

**Step 9.4 — Decision rationale**
For this **v6.18.44** tree, the AMDGPU CPER ring overflow recovery code
exists and contains the described infinite-loop bug. The fix prevents a
permanent hang in RAS error logging when corrupt ring data prevents
`rptr` advancement — exactly the scenario CPER is meant to survive. The
patch is small, self-contained, and follows the same pattern as the
already-merged `d6f9bbce18762` overflow-loop fix.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff
- [Phase 2] Analyzed diff: `amdgpu_cper_ring_write()` overflow loop
  change
- [Phase 3] `git describe HEAD` → `v6.18.44`; Makefile confirms 6.18.44
- [Phase 3] `git blame -L 507,516` → buggy loop from `a6d9d192903ea`
  (2025-01-22)
- [Phase 3] `git tag --contains 92d5d2a09de16` → CPER introduced in
  `v6.15`
- [Phase 3] `git show d6f9bbce18762` → related prior infinite-loop fix
  in same function, already in tree
- [Phase 3] `git log --oneline -20 -- amdgpu_cper.c` → CPER subsystem
  history reviewed
- [Phase 4] `b4 dig -c d5e59c24d907d` → no match (commit not in local
  repo)
- [Phase 4] `b4 shazam -s 'reset CPER ring on corrupt entry size'` →
  message-id not known
- [Phase 4] lore.kernel.org fetch → blocked by Anubis bot protection
- [Phase 4] Workspace `*.mbx` grep → no matching thread found
- [Phase 5] `grep amdgpu_cper_ring_write` → 4 call sites in
  `amdgpu_cper.c`, `amdgpu_virt.c`
- [Phase 5] Traced `aca_banks_update` → `aca_banks_generate_cper` →
  `amdgpu_cper_generate_*` → `amdgpu_cper_ring_write`
- [Phase 6] Read `amdgpu_cper.c:466-521` → buggy code confirmed present,
  fix absent
- [Phase 6] `git merge-base --is-ancestor 4d614ce8ffd75 HEAD` → CPER
  ring code is in this tree
- [Phase 6] Patch apply via `git apply --check` → failed on upstream
  context mismatch in unrelated hunk; target `amdgpu_cper_ring_write()`
  hunk verified identical by direct file read
- [Phase 7] `amdgpu_cper_init()` requires `amdgpu_aca_is_enabled()` or
  `amdgpu_sriov_ras_cper_en()` — verified in source
- [Phase 8] Confirmed mutex held across infinite loop (`mutex_lock` at
  line 481, loop at 507-515, `mutex_unlock` at 520)

**YES**The background search finished: the fix commit **is not in this
tree** (`v6.18.44`). `git log --grep='reset CPER ring'` and
`--grep='corrupt entry size'` found nothing; Xiang Liu’s other CPER
commits (including `d6f9bbce18762`, a related overflow infinite-loop
fix) are present, but not this one.

The buggy overflow-recovery loop is still in `amdgpu_cper.c` at lines
510–511. This patch should be backported here: it prevents an infinite
spin with `cper.ring_lock` held when corrupt CPER ring data doesn’t
advance `rptr` during overflow recovery — a hang in the RAS error-
reporting path on ACA/SR-IOV CPER-enabled AMD GPUs.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
index 425a3e5643608..2694facb06c73 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
@@ -465,7 +465,7 @@ static u32 amdgpu_cper_ring_get_ent_sz(struct amdgpu_ring *ring, u64 pos)
 
 void amdgpu_cper_ring_write(struct amdgpu_ring *ring, void *src, int count)
 {
-	u64 pos, wptr_old, rptr;
+	u64 pos, wptr_old, rptr, next_rptr;
 	int rec_cnt_dw = count >> 2;
 	u32 chunk, ent_sz;
 	u8 *s = (u8 *)src;
@@ -506,9 +506,19 @@ void amdgpu_cper_ring_write(struct amdgpu_ring *ring, void *src, int count)
 
 		do {
 			ent_sz = amdgpu_cper_ring_get_ent_sz(ring, pos);
-
-			rptr += (ent_sz >> 2);
-			rptr &= ring->ptr_mask;
+			next_rptr = rptr;
+			if (ent_sz >= sizeof(u32))
+				next_rptr = (rptr + (ent_sz >> 2)) & ring->ptr_mask;
+
+			if (next_rptr == rptr) {
+				/* Corrupt entry size, reset the ring to avoid an infinite loop. */
+				rptr = ring->wptr;
+				*ring->rptr_cpu_addr = rptr;
+				ring->count_dw = (ring->ring_size - 4) >> 2;
+				goto out_unlock;
+			}
+
+			rptr = next_rptr;
 			*ring->rptr_cpu_addr = rptr;
 
 			pos = rptr;
@@ -517,6 +527,8 @@ void amdgpu_cper_ring_write(struct amdgpu_ring *ring, void *src, int count)
 
 	if (ring->count_dw >= rec_cnt_dw)
 		ring->count_dw -= rec_cnt_dw;
+
+out_unlock:
 	mutex_unlock(&ring->adev->cper.ring_lock);
 }
 
-- 
2.53.0

