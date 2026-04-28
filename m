Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4473F2110;
	Tue, 28 Apr 2026 10:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372901; cv=none; b=ZJD7P2qaVUx4TV6bgmpYELHvd0Nv/k3fArYN+2IhC6BFlc4UwvaMEOc4xxwC3Ncul6/2iJYRnYckyQsvSxNqSMpZKKFBKMV0Hp1pWuoevI6eQTbKehYVOA/BV4Xf2hYw6kMuerbjShKHh6xE14vzHJUSEaO6nrI7uYr/A9f0FnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372901; c=relaxed/simple;
	bh=BtHpGPoYej0w33vENI7k/1T0u2nyGXQnT4NZ4i/LTI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dlfjGuVoUMqPlcNKLdiacH1jzF5vdoj4Qg8908acoM0wDom8DPix2G7CyvckGk6q/0nhBM5JsmKG80qVZOPMD1f1prFpUPpPB2SPheZP5V0hDlKEg4SHWuM2DBsAw9tU/nc4LB6pfu88kn/6jD6EEjEfeUncNBZmT5U8xhCmlTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lv5zfiVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lv5zfiVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E655C2BCB5;
	Tue, 28 Apr 2026 10:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372901;
	bh=BtHpGPoYej0w33vENI7k/1T0u2nyGXQnT4NZ4i/LTI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lv5zfiVlKDTF942pSovKzujO/YUjMMbo5A1tR7dDXvzJjk0VbBrKEtk69tDR1lCZ5
	 bylNcxmpnLe/hTeFwenI3+xpUMAWZa9KjLpAbqheuRzAGzZvD4f3Pjhklmy3WSSHXy
	 qtbKXnn7ciBVnVCAbyYD25p0XPHEr/EwQmAZeCHfcAqANvrftUIxsQmcWkwQ9mhxBD
	 h/BLAUSM155YzEHFLQa3ICdU6MW6F2xTFDrnIG37jkdzsvpCKRCyHi8CtttXNwQ9Dm
	 NRoSHtuSsMhOFZHfCAsfgEj4l7CWb5R/oPR8bpesu0nLlusRib5pK0EqBOgNnBudVW
	 oNf9HGKphPORQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiang Liu <xiang.liu@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	Xinhui.Pan@amd.com,
	airlied@gmail.com,
	daniel@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/amdgpu: fix CPER ring header parsing
Date: Tue, 28 Apr 2026 06:40:16 -0400
Message-ID: <20260428104133.2858589-5-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit b8939bd764c9c8bf6488dc0d71d9c718c25d8cfc ]

amdgpu_cper_ring_get_ent_sz() parses CPER headers directly from the
circular ring buffer to determine the current entry size. When the ring
is full and the write pointer lands near the end of the buffer, the
header can wrap across the ring boundary.

The existing code treats the 4-byte CPER signature as a C string and
uses strcmp() on in-ring binary data, then reads record_length through a
direct struct pointer cast. Both assumptions are unsafe for wrapped
entries and can read past the end of the ring mapping.

Fix the parser by comparing the signature as raw bytes and by copying
the header into a local buffer before reading record_length, handling
wraparound explicitly in both cases. This avoids out-of-bounds reads in
amdgpu_cper_ring_get_ent_sz() when the CPER ring is full or the current
entry starts at the tail of the ring.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough context to make a comprehensive analysis. Let me
complete the structured investigation.

## Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: SUBJECT LINE PARSING**
- Subsystem prefix: `drm/amdgpu:`
- Action verb: "fix"
- Record: `[drm/amdgpu]` `[fix]` Fix CPER ring header parsing - handle
  wrap-around and avoid OOB reads when entries straddle ring boundary.

**Step 1.2: COMMIT MESSAGE TAGS**
- No `Fixes:` tag (the Fixes target would be `4d614ce8ffd75 "drm/amdgpu:
  add RAS CPER ring buffer"`)
- No `Reported-by:`, `Tested-by:`, `Link:` to bug report
- `Reviewed-by: Tao Zhou <tao.zhou1@amd.com>` — same Tao Zhou who
  originally added the CPER ring buffer code (subsystem expert)
- `Signed-off-by:` chain: Xiang Liu (author) -> Alex Deucher (AMD GPU
  maintainer)
- No `Cc: stable@vger.kernel.org`
- Record: Limited tags, but reviewed by subsystem expert and signed off
  by maintainer.

**Step 1.3: COMMIT BODY**
- Bug description: `amdgpu_cper_ring_get_ent_sz()` parses CPER headers
  directly from a circular ring buffer. When the ring is full and write
  pointer lands near the end of the buffer, the header can wrap across
  the ring boundary. The existing code uses `strcmp()` on in-ring binary
  data (signature is 4-byte non-null-terminated) and reads
  `record_length` through a direct struct pointer cast, which can read
  past the end of the ring buffer mapping for wrapped entries.
- Failure mode: "out-of-bounds reads in `amdgpu_cper_ring_get_ent_sz()`
  when the CPER ring is full or the current entry starts at the tail of
  the ring."
- Root cause: Lack of wrap-around handling in ring header parsing.
- Record: Clear description of an out-of-bounds read bug in ring buffer
  parsing logic.

**Step 1.4: HIDDEN BUG FIX DETECTION**
- This commit is explicitly a fix ("fix CPER ring header parsing").
- It addresses two issues: (a) using `strcmp()` on non-null-terminated
  binary data, (b) struct pointer cast reading past ring end.
- Record: Not hidden - clearly a defensive fix for OOB reads.

### PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY**
- 1 file modified: `drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c`
- ~25 lines added, ~9 lines removed
- Functions modified: `amdgpu_cper_is_hdr()`,
  `amdgpu_cper_ring_get_ent_sz()`
- Record: Single file, surgical fix to two static functions.

**Step 2.2: CODE FLOW CHANGE**
- Before: `chdr = (struct cper_hdr *)&(ring->ring[pos])` cast,
  `strcmp(chdr->signature, "CPER")` - assumes linear reads beyond `pos`.
- After: Uses `memcpy()` with explicit bounds check for `(pos << 2) >=
  ring->ring_size`, splits reads when wrapping the ring boundary, uses
  `memcmp()` on bytes (no null-termination assumption). For
  `record_length`, copies the header to a local `struct cper_hdr chdr`
  first.
- Record: Changes from unsafe pointer cast/strcmp to bounded
  memcpy/memcmp with wrap handling.

**Step 2.3: BUG MECHANISM**
- Category (d) Memory safety + (g) Logic correctness:
  - OOB read: When `pos << 2` is near `ring->ring_size`, casting to
    `struct cper_hdr *` and reading 128 bytes (size of struct) reads
    past the allocated ring memory.
  - Wrap-around: When CPER entries wrap the ring boundary, the old code
    reads contiguous memory (which is past the buffer end) instead of
    reading the wrapped portion from the start of the ring.
  - The `strcmp()` on a 4-byte non-null-terminated `signature` field
    happens to work in unwrapped cases because the next byte
    (`revision`'s low byte for `CPER_HDR_REV_1=0x100`) is zero in
    little-endian, but the wrap-around case is genuinely broken.
- Record: OOB read on heap allocation + incorrect handling of ring wrap-
  around.

**Step 2.4: FIX QUALITY**
- Bounds checks before access; correct memcpy splitting at ring boundary
- Localizes the buffer (struct cper_hdr chdr on stack vs. pointer to
  ring memory)
- Reuses `amdgpu_cper_is_hdr()` for the search loop (DRY)
- Risk: low - no locking changes, no API changes, surgical
- Record: Correct, minimal, well-contained.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME**
- The buggy code was introduced in `4d614ce8ffd75 "drm/amdgpu: add RAS
  CPER ring buffer"` (Jan 22, 2025)
- This commit is included in v6.15 (verified via `git tag --contains
  4d614ce8ffd75`)
- Record: Buggy code introduced in v6.15 timeframe.

**Step 3.2: FIXES TARGET**
- No explicit Fixes tag, but the buggy code is clearly `4d614ce8ffd75`
  (and subsequent additions in same series)
- Target exists in v6.15+ (mainline), v6.16, v6.17, v6.18 (LTS), v7.0
  stable trees
- NOT in older LTS (5.10, 5.15, 6.1, 6.6, 6.12) - those don't have CPER
  ring code
- Record: Bug exists in v6.15+ stable trees only.

**Step 3.3: FILE HISTORY**
- The CPER ring buffer infrastructure has been actively developed since
  Jan 2025
- Multiple subsequent fixes: `d6f9bbce18762`, `8e0d1edb5c167` (the
  latter has explicit `Cc: stable@vger.kernel.org`)
- No hard prerequisites identified for this specific patch
- Record: Standalone fix; no dependencies needed.

**Step 3.4: AUTHOR**
- Xiang Liu is a regular AMD contributor with many CPER-related commits
- Tao Zhou is the original author of the CPER ring buffer code (highly
  knowledgeable about it)
- Alex Deucher is the AMD GPU maintainer
- Record: Strong subsystem expertise.

**Step 3.5: DEPENDENCIES**
- No prerequisites; the fix is self-contained
- Record: Self-contained, applies cleanly.

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1: PATCH DISCUSSION**
- `b4 dig` found the original submission: `https://lore.kernel.org/all/2
  0260409092403.572319-1-xiang.liu@amd.com/`
- Only one revision (v1) was sent
- Reviewer Tao Zhou suggested defining a `CPER_SIGNATURE_SZ` macro -
  this was incorporated in the committed version
- No NAK or stability concerns raised
- No explicit `Cc: stable` request in the discussion
- Record: One revision; minor cosmetic feedback incorporated; no
  concerns raised.

**Step 4.2: REVIEWERS**
- CC list: Hawking Zhang, Tao Zhou, amd-gfx mailing list
- Reviewed by Tao Zhou (the original author of the buggy CPER ring code)
- Record: Reviewed by the right subsystem experts.

**Step 4.3: BUG REPORT**
- No bug report referenced - appears to be developer-found via code
  review/audit
- Record: No external bug report - found by AMD developers themselves.

**Step 4.4-4.5: RELATED PATCHES / STABLE HISTORY**
- Single-patch series; no related patches in series
- Earlier CPER fix `8e0d1edb5c167` had explicit `Cc: stable` - shows
  pattern of CPER fixes being sent to stable
- Record: Consistent with other CPER fixes that went to stable.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4: Functions and call sites**
- `amdgpu_cper_is_hdr()` - called by `amdgpu_cper_ring_write()` (line
  516) and `amdgpu_cper_ring_get_ent_sz()` (after fix)
- `amdgpu_cper_ring_get_ent_sz()` - called by `amdgpu_cper_ring_write()`
  (lines 488, 509)
- `amdgpu_cper_ring_write()` - called from `amdgpu_cper_generate_*()` (3
  sites in amdgpu_cper.c) and `amdgpu_virt.c` (1 site for SR-IOV)
- Trigger path: AMD GPU error reporting (RAS/ACA) -> generate CPER entry
  -> write to ring -> parse headers when ring is full
- Reachability: User triggered indirectly when GPU experiences error
  events; CPER ring fills over time
- Record: Path is reachable on systems with RAS-enabled enterprise AMD
  GPUs that experience errors.

**Step 5.5: Similar patterns**
- The fix uses the standard pattern of bounds-checking + memcpy for
  reading from circular buffers
- Record: Standard defensive programming pattern.

### PHASE 6: CROSS-REFERENCING

**Step 6.1: Code in stable**
- The CPER ring code was introduced in v6.15 (commit `4d614ce8ffd75`)
- Buggy code present in: v6.15, v6.16, v6.17, v6.18 (LTS), v7.0
- NOT present in: v6.12 (LTS), v6.6 (LTS), v6.1 (LTS), v5.15 (LTS),
  v5.10 (LTS)
- Record: Only newer stable trees affected.

**Step 6.2: Backport complications**
- Fix applies cleanly against current `linux-7.0.y` HEAD (verified via
  `git diff HEAD..b8939bd764c9c`)
- Record: Clean apply on 7.0 stable; should also apply cleanly to
  6.18.y, 6.17.y, 6.16.y.

**Step 6.3: Related fixes in stable**
- Other CPER fixes (e.g., `8e0d1edb5c167`) went to stable - this is
  consistent treatment
- Record: Pattern of CPER fixes going to stable.

### PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- `drivers/gpu/drm/amd/amdgpu/` - AMD GPU driver, RAS error reporting
  subsystem
- Criticality: PERIPHERAL-to-IMPORTANT (specific hardware, but
  datacenter relevance)
- Record: Affects users of AMD enterprise GPUs (MI series) with RAS
  enabled.

**Step 7.2: Activity**
- CPER subsystem is actively developed (~16 commits since Jan 2025)
- Record: Actively maintained.

### PHASE 8: IMPACT/RISK

**Step 8.1: Affected users**
- AMD GPU users with RAS enabled (datacenter/enterprise GPUs primarily,
  MI200/MI300 etc.)
- SR-IOV virtualized GPU environments also affected
- Record: Smaller but real user population.

**Step 8.2: Trigger conditions**
- Requires CPER ring to become full (many error events recorded)
- AND the CPER entry to start near the end of the ring buffer (wrap
  condition)
- Cannot be triggered by unprivileged users directly
- Record: Realistic but not common trigger; happens on hardware
  experiencing errors.

**Step 8.3: Failure mode**
- OOB read on heap allocation (KASAN-detectable)
- Could read garbage data leading to incorrect ring management
- In worst case: kernel oops if page after ring is unmapped (rare since
  ring is page-aligned)
- More likely: misidentified headers causing wrong rptr advancement,
  dropped CPER entries, or incorrect entry size calculation
- Severity: MEDIUM-HIGH (OOB read is memory safety; ring corruption
  affects RAS data integrity)
- Record: Memory safety bug + correctness bug.

**Step 8.4: Risk-benefit**
- Benefit: Fixes real OOB read on affected systems; fixes incorrect wrap
  handling
- Risk: Very low - small fix to two static functions, no API/lock
  changes, reviewed by subsystem expert
- Record: Good benefit-to-risk ratio.

### PHASE 9: SYNTHESIS

**Step 9.1-9.3: Evidence**
- FOR: Real OOB read bug, real wrap-around logic bug, small contained
  fix, reviewed by subsystem experts, applies cleanly, signed off by
  maintainer
- AGAINST: No Cc:stable, narrow trigger condition, smaller user
  population (enterprise GPU users only), code only in v6.15+ trees
- Stable rules: 1) obviously correct ✓ 2) fixes real bug ✓ 3) memory
  safety / data integrity ✓ 4) small ✓ 5) no new features ✓ 6) applies
  cleanly ✓

## Verification

- [Phase 1] Parsed tags: No Fixes:, no Cc:stable, Reviewed-by Tao Zhou,
  Signed-off-by chain Xiang Liu -> Alex Deucher (verified via `git
  show`)
- [Phase 1] Commit message describes OOB read in
  `amdgpu_cper_ring_get_ent_sz()` for wrapped entries (verified)
- [Phase 2] Diff analysis: 25 added, 9 removed in single file
  `amdgpu_cper.c`; modifies `amdgpu_cper_is_hdr()` and
  `amdgpu_cper_ring_get_ent_sz()` (verified via `git show
  b8939bd764c9c`)
- [Phase 2] Verified `struct cper_hdr` is 128 bytes with 4-byte non-
  null-terminated signature followed by uint16_t revision (verified in
  `drivers/gpu/drm/amd/include/amd_cper.h`)
- [Phase 2] Verified ring is allocated as GTT BO with size
  `ring->ring_size + extra_bytes` (verified in
  `drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c` line 381)
- [Phase 3] git log: buggy code introduced by `4d614ce8ffd75` (verified
  - "drm/amdgpu: add RAS CPER ring buffer", Jan 22, 2025)
- [Phase 3] Tag containment: `4d614ce8ffd75` first appears in v6.15
  (verified via `git tag --contains`)
- [Phase 3] Older LTS trees (5.10, 5.15, 6.1, 6.6, 6.12) do NOT contain
  the buggy code (verified)
- [Phase 4] b4 dig found patch at `https://lore.kernel.org/all/202604090
  92403.572319-1-xiang.liu@amd.com/` (verified)
- [Phase 4] b4 dig -a: only v1 of the patch (verified)
- [Phase 4] Mailing thread shows Tao Zhou's review with Reviewed-by;
  suggested CPER_SIGNATURE_SZ macro was incorporated (verified by
  reading `/tmp/cper_thread.mbox`)
- [Phase 4] No NAKs, no stability concerns raised (verified from mbox)
- [Phase 5] `amdgpu_cper_ring_write()` callers:
  `amdgpu_cper_generate_ue_record`,
  `amdgpu_cper_generate_bp_threshold_record`,
  `amdgpu_cper_generate_ce_records`, plus SR-IOV path in `amdgpu_virt.c`
  (verified via Grep)
- [Phase 6] Patch applies cleanly to current `stable/linux-7.0.y` HEAD
  (verified via `git diff HEAD..b8939bd764c9c`)
- [Phase 6] Earlier CPER fix `8e0d1edb5c167` had explicit `Cc:
  stable@vger.kernel.org`, indicating pattern of CPER fixes going to
  stable (verified via `git show`)
- [Phase 8] Trigger requires ring full + entry near end of buffer;
  affects RAS-enabled AMD enterprise GPU users (verified by reading code
  paths and CPER ring init in `amdgpu_cper.c`)
- UNVERIFIED: The actual frequency of the trigger condition in
  production - depends on workload and error rates; likely rare but not
  theoretical.
- UNVERIFIED: Whether KASAN has reported this specific issue - no
  syzbot/KASAN report referenced in commit message.

## Conclusion

This commit fixes a real out-of-bounds read bug and an incorrect ring
wrap-around handling in the AMD GPU CPER (Common Platform Error Record)
ring buffer parser. When the ring is full and a CPER entry's header
straddles the ring boundary, the previous code would:
1. Cast a pointer past the end of the ring buffer to `struct cper_hdr *`
   and read 128 bytes (the struct size), causing OOB reads on the heap
   allocation
2. Use `strcmp()` on non-null-terminated 4-byte binary data
3. Fail to handle the wrap-around case correctly, leading to incorrect
   record_length reads and wrong ring pointer management

The fix is small (~25/9 lines), surgical (single file, two static
functions), reviewed by the original CPER ring author (Tao Zhou), and
signed off by the AMD GPU maintainer. It applies cleanly to current
stable trees that contain the CPER ring code (v6.15+). The bug affects
users with RAS-enabled AMD enterprise GPUs (MI series datacenter cards)
- a smaller but real user population where memory safety and CPER data
integrity matter for reliability.

The fix meets all stable kernel criteria: obviously correct, fixes a
real bug (memory safety + data integrity), small and contained, no new
features, applies cleanly. The pattern of similar CPER fixes (e.g.,
`8e0d1edb5c167`) being sent to stable supports this as a stable
candidate.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c | 36 ++++++++++++++++++------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
index c72c345334d01..4e6e390854e6e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
@@ -32,6 +32,8 @@ static const guid_t BOOT		= BOOT_TYPE;
 static const guid_t CRASHDUMP		= AMD_CRASHDUMP;
 static const guid_t RUNTIME		= AMD_GPU_NONSTANDARD_ERROR;
 
+#define CPER_SIGNATURE_SZ		(sizeof(((struct cper_hdr *)0)->signature))
+
 static void __inc_entry_length(struct cper_hdr *hdr, uint32_t size)
 {
 	hdr->record_length += size;
@@ -425,23 +427,40 @@ int amdgpu_cper_generate_ce_records(struct amdgpu_device *adev,
 
 static bool amdgpu_cper_is_hdr(struct amdgpu_ring *ring, u64 pos)
 {
-	struct cper_hdr *chdr;
+	char signature[CPER_SIGNATURE_SZ];
+
+	if ((pos << 2) >= ring->ring_size)
+		return false;
 
-	chdr = (struct cper_hdr *)&(ring->ring[pos]);
-	return strcmp(chdr->signature, "CPER") ? false : true;
+	if ((pos << 2) + CPER_SIGNATURE_SZ <= ring->ring_size) {
+		memcpy(signature, &ring->ring[pos], CPER_SIGNATURE_SZ);
+	} else {
+		u32 chunk = ring->ring_size - (pos << 2);
+
+		memcpy(signature, &ring->ring[pos], chunk);
+		memcpy(signature + chunk, ring->ring, CPER_SIGNATURE_SZ - chunk);
+	}
+
+	return !memcmp(signature, "CPER", CPER_SIGNATURE_SZ);
 }
 
 static u32 amdgpu_cper_ring_get_ent_sz(struct amdgpu_ring *ring, u64 pos)
 {
-	struct cper_hdr *chdr;
+	struct cper_hdr chdr;
 	u64 p;
 	u32 chunk, rec_len = 0;
 
-	chdr = (struct cper_hdr *)&(ring->ring[pos]);
 	chunk = ring->ring_size - (pos << 2);
 
-	if (!strcmp(chdr->signature, "CPER")) {
-		rec_len = chdr->record_length;
+	if (amdgpu_cper_is_hdr(ring, pos)) {
+		if (chunk >= sizeof(chdr)) {
+			memcpy(&chdr, &ring->ring[pos], sizeof(chdr));
+		} else {
+			memcpy(&chdr, &ring->ring[pos], chunk);
+			memcpy((u8 *)&chdr + chunk, ring->ring, sizeof(chdr) - chunk);
+		}
+
+		rec_len = chdr.record_length;
 		goto calc;
 	}
 
@@ -450,8 +469,7 @@ static u32 amdgpu_cper_ring_get_ent_sz(struct amdgpu_ring *ring, u64 pos)
 		goto calc;
 
 	for (p = pos + 1; p <= ring->buf_mask; p++) {
-		chdr = (struct cper_hdr *)&(ring->ring[p]);
-		if (!strcmp(chdr->signature, "CPER")) {
+		if (amdgpu_cper_is_hdr(ring, p)) {
 			rec_len = (p - pos) << 2;
 			goto calc;
 		}
-- 
2.53.0

