Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C72348A2D1;
	Mon, 20 Apr 2026 13:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691914; cv=none; b=gutOiPCqRHMNZYRhOFkOLXB7vKwCCOIJ5OObDj+/p/PZ71Lrwm4FkphtgLrmjckOyGpc2/dwU302C/99vb/Ls6Fc/qUGd4QyQCjL46xb4AgFFuZNVjC2sotHc9A150ZLbZiqlZTX2YwkhDmydc852BmVaC891NrBq9+eFW2WrOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691914; c=relaxed/simple;
	bh=y3ah3GKJjHFrdayhjIe3vmRKN4uPnejjCykot+9kPso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E9FJGBoE6Z8+XBGk9fZiFOQ1e0iHjqlKdhickuh6M30ZJ6SNfSfm3Clg0fQu/YriAv6QxpCLfwjJqNNLn7RziWl+oqKTO25g7qE30TmFYIT2rn8ovpIjGs4FJzVahE1O4Pnfa0bH0HnxKYSxxiTlJCYGLx4qy2xsa7TCIwnASg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KETZ+edK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KETZ+edK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367CCC4AF09;
	Mon, 20 Apr 2026 13:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691914;
	bh=y3ah3GKJjHFrdayhjIe3vmRKN4uPnejjCykot+9kPso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KETZ+edKDzQXglFePRK4CCszVx/YXFBjk/vm8iY9EDdeD6/m3SDrC4eAFlG7Hcy7v
	 s0pq0vvJNwUZywLIcv51yUW8ZTv3KAMItSz6nC4rUqMQqiokbVoohzjaUA9iqa+xhm
	 2Nib3Ntjzq+UCVWq+IT4QO8ljISaWP1CRuaxOBrq77RHpQW59M9lJyrd3UguPS3Ed7
	 rfAcM8SHJmPFFnCof5cye1A4OViB+1EtMwdjd8RZF1mQI/EXAOrtf65KxG5O6gcbtU
	 gYpsspe0E9wLuthpvzCAeQX+8hA5ELLvDbr/uNlM6dabvk5Is3S4UIVn8byPy3dErW
	 30hOxIwRfolrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/amd/display: Fix HWSS v3 fast path determination
Date: Mon, 20 Apr 2026 09:21:00 -0400
Message-ID: <20260420132314.1023554-266-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit d3e79f333d90f6d3d268c3b073cf3afc0b019036 ]

[WHY]
We're checking surface and stream updates after they've been applied to
their respective states within `update_planes_and_stream_state`.

Medium updates under the HWSS V3 fast path that are not supported or
tested are getting implicitly if they don't trigger a DML validation
and getting updated in place on the dc->current_state context.

[HOW]
Fix this issue by moving up the fast path determination check prior
to `update_planes_and_stream_state`. This is how the V2 path works
and how the V3 path used to work prior to the refactors in this area.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for the complete analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: **[drm/amd/display]** **[Fix]** Fix HWSS v3 fast path
determination — corrects the ordering of fast path evaluation in the V3
update flow.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Reviewed-by:** Dillon Varone <dillon.varone@amd.com> — an AMD
  display engineer reviewed this
- **Signed-off-by:** Nicholas Kazlauskas <nicholas.kazlauskas@amd.com> —
  the author, an AMD display subsystem developer
- **Signed-off-by:** Alex Hung <alex.hung@amd.com> — AMD display
  committer
- **Tested-by:** Dan Wheeler <daniel.wheeler@amd.com> — AMD QA testing
- **Signed-off-by:** Alex Deucher <alexander.deucher@amd.com> — AMD GPU
  maintainer
- No Fixes: tag (expected for autosel)
- No Cc: stable (expected for autosel)
- No Reported-by (likely found internally during code review/testing)

Record: Multiple AMD engineers reviewed/tested/signed off. Standard AMD
display commit flow through maintainer tree.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit clearly describes:
- **Bug**: Surface and stream updates are checked AFTER they've been
  applied to state within `update_planes_and_stream_state`. This means
  `fast_update_only` sees already-modified state, causing incorrect fast
  path determination.
- **Symptom**: Medium updates that should go through the full commit
  path are incorrectly routed to the fast path. These "are not supported
  or tested" updates get "implicitly" applied "in place on the
  dc->current_state context."
- **Fix**: Move the fast path determination check BEFORE
  `update_planes_and_stream_state`, matching V2 behavior and original V3
  behavior prior to refactoring.

Record: Bug = incorrect fast path determination due to wrong ordering.
Failure mode = untested update types being applied via fast path,
leading to potential display corruption.

### Step 1.4: DETECT HIDDEN BUG FIXES
This is explicitly marked as "Fix" and the commit message clearly
explains the bug mechanism. Not a hidden bug fix.

Record: Explicitly a bug fix.

---

## PHASE 2: DIFF ANALYSIS — LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
- **File:** `drivers/gpu/drm/amd/display/dc/core/dc.c`
- **Functions modified:** `update_planes_and_stream_prepare_v3()`
- **Net change:** ~15 lines of code moved from one location to another
  within the same function; removed TODO comments; net line change is
  approximately -2 lines.
- **Scope:** Single-file surgical fix within a single function.

Record: 1 file, 1 function, net ~-2 lines. Single-file surgical fix.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE

**Before:** After `dc_exit_ips_for_hw_access()`, immediately calls
`update_planes_and_stream_state()` which modifies surface/stream state.
THEN, inside the `new_context == current_state` branch, performs
`populate_fast_updates()` and `fast_update_only()` check.

**After:** After `dc_exit_ips_for_hw_access()`, FIRST calls
`populate_fast_updates()` and `fast_update_only()` on the unmodified
state. THEN calls `update_planes_and_stream_state()`. The pre-computed
`is_hwss_fast_path_only` result is used later.

### Step 2.3: IDENTIFY THE BUG MECHANISM
This is a **logic/correctness fix**. The `full_update_required()`
function (called via `fast_update_only()`) compares update values
against current surface/stream state (e.g.,
`srf_updates[i].hdr_mult.value !=
srf_updates->surface->hdr_mult.value`). After
`update_planes_and_stream_state` copies the update into the surface
state (`copy_surface_update_to_plane`), these comparisons see the
already-updated values, causing the function to incorrectly return
`false` (no full update needed) when it should return `true`.

Record: Logic bug — wrong evaluation order causes
`full_update_required()` to compare update values against already-
modified state, leading to false negatives for full-update detection.

### Step 2.4: ASSESS THE FIX QUALITY
- **Obviously correct:** Yes — moving the check before state
  modification is the logical correct order, and matches V2's behavior.
- **Minimal/surgical:** Yes — only moves existing code within one
  function.
- **Regression risk:** Very low — the check now runs on pre-modification
  state, which is how V2 works and how V3 used to work before the
  refactoring.
- **No red flags:** Single function, single file, no API changes.

Record: Fix is obviously correct, minimal, and low regression risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
`git blame` shows the buggy code was introduced by commit
`d38ec099aa6fb7` ("drm/amd/display: Split update_planes_and_stream_v3
into parts (V2)") by Dominik Kaszewski, dated 2025-10-31. This commit
was a refactoring that split the V3 update flow into
prepare/execute/cleanup stages but accidentally placed the fast path
determination after state modification.

Record: Buggy code introduced by d38ec099aa6fb7 (2025-10-31), first
appeared in v7.0-rc1.

### Step 3.2: FOLLOW THE FIXES: TAG
No Fixes: tag present (expected). But the blame clearly identifies
d38ec099aa6fb7 as the introducing commit.

Record: Introducing commit d38ec099aa6fb7 is present in v7.0-rc1 and
v7.0, not in any older stable tree.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Commit `5ad5b0b7845c9` ("Fix and reenable
UPDATE_V3_FLOW_NEW_CONTEXT_MINIMAL") followed the introducing commit and
fixed other issues in the V3 flow but did NOT fix this ordering issue.
The fix under review is a standalone, independent fix.

Record: Related fix 5ad5b0b7845c9 exists but addresses a different V3
issue. This fix is standalone.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Nicholas Kazlauskas is a prolific AMD display developer and the reviewer
of the original refactoring commit. He clearly understands the subsystem
deeply and identified this ordering bug.

Record: Author is a key AMD display developer and subsystem expert.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
The fix has no external dependencies. It modifies code that exists in
v7.0 and applies to the `update_planes_and_stream_prepare_v3` function
as-is in the current tree.

Record: No dependencies. Self-contained fix.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.5: MAILING LIST INVESTIGATION
`b4 dig` could not find the original patch submissions (both the fix and
the introducing commit) on lore.kernel.org. AMD display patches are
often submitted through internal tooling (amd-gfx list) and may not be
indexed by lore in the same way. Lore.kernel.org was also protected by
Anubis anti-bot measures.

Record: Could not find lore discussion. AMD display patches often flow
through internal AMD tooling.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS
- `update_planes_and_stream_prepare_v3()` — the function being fixed
- `populate_fast_updates()` — populates fast update structure from
  surface/stream updates
- `fast_update_only()` → `full_update_required()` — determines if only
  fast updates exist (no full update needed)
- `update_planes_and_stream_state()` — applies updates to surface/stream
  state and determines update type

### Step 5.2: TRACE CALLERS
`update_planes_and_stream_prepare_v3` is called from
`dc_update_planes_and_stream_prepare` → called from
`dc_update_planes_and_stream` → called from `amdgpu_dm.c` (the main AMD
display manager path). This is the **primary display update path** for
all AMD GPU operations including mode setting, cursor updates,
pageflips, etc.

### Step 5.3-5.4: CALL CHAIN
The path is: userspace (DRM ioctl) → `amdgpu_dm` →
`dc_update_planes_and_stream` → `dc_update_planes_and_stream_prepare` →
`update_planes_and_stream_prepare_v3`. This is directly reachable from
userspace display operations.

### Step 5.5: SIMILAR PATTERNS
The V2 path (`update_planes_and_stream_v2`, line 5231-5233) correctly
performs `populate_fast_updates` and `fast_update_only` BEFORE
`update_planes_and_stream_state`. The fix aligns V3 with V2's correct
ordering.

Record: Main display update path, reachable from userspace. V2 already
has the correct ordering.

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
The buggy code was introduced by d38ec099aa6fb7, first tagged in
v7.0-rc1. It does NOT exist in any stable tree older than 7.0.y. Only
the 7.0.y stable tree is affected.

Record: Bug only exists in 7.0.y.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
The fix should apply cleanly to 7.0.y since the code was introduced in
v7.0-rc1 and there have been no significant refactors to this specific
code region since then (only the `5ad5b0b7845c9` commit touched a
different part of the same function).

Record: Expected clean apply to 7.0.y.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE
No related fixes for this specific issue found.

Record: No existing fix for this issue in stable.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
**Subsystem:** `drivers/gpu/drm/amd/display` — AMD GPU display driver
**Criticality:** IMPORTANT — affects all users with AMD RDNA 3 and RDNA
4 GPUs (very popular consumer hardware: RX 7000 series and RX 9000
series).

### Step 7.2: SUBSYSTEM ACTIVITY
The AMD display subsystem is extremely active with dozens of commits per
release cycle.

Record: Very active subsystem, widely-used hardware.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
All users with AMD DCN 3.2 (RDNA 3), DCN 3.21 (RDNA 3 refresh), or DCN
4.01+ (RDNA 4) GPUs running kernel 7.0.y. These are very popular
consumer GPUs.

Record: Driver-specific but affects millions of AMD GPU users.

### Step 8.2: TRIGGER CONDITIONS
The bug triggers whenever a medium update (e.g., HDR metadata, scaling,
color space change) is submitted through the display update path AND the
update values match after state application. This can happen during
normal desktop operations, video playback, HDR content switching, etc.

Record: Triggered during normal display operations. Common trigger.

### Step 8.3: FAILURE MODE SEVERITY
When the bug triggers:
- Display updates that require full hardware programming go through the
  fast path instead
- This can cause **display corruption** (visual artifacts, incorrect
  rendering)
- Updates applied "in place on dc->current_state" without proper
  validation
- The commit message says these code paths "are not supported or tested"

Record: Display corruption. Severity: **HIGH** (visual artifacts,
incorrect rendering, untested code paths).

### Step 8.4: RISK-BENEFIT RATIO
- **BENEFIT:** Prevents display corruption on popular AMD hardware
  during common display operations. HIGH benefit.
- **RISK:** Very low — the fix moves ~15 lines of code within a single
  function, matching proven V2 behavior. The fix was reviewed and tested
  by AMD engineers.

Record: High benefit, very low risk. Clear positive ratio.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Fixes a real display corruption bug on widely-used AMD hardware (RDNA
  3 & RDNA 4)
- Small, surgical fix (single function, ~15 lines moved)
- Obviously correct (matches V2 path behavior and pre-refactoring V3
  behavior)
- Reviewed by AMD display engineer (Dillon Varone)
- Tested by AMD QA (Dan Wheeler)
- Authored by AMD display subsystem expert (Nicholas Kazlauskas)
- Signed off by AMD GPU maintainer (Alex Deucher)
- No external dependencies
- Should apply cleanly to 7.0.y

**AGAINST backporting:**
- Only affects 7.0.y (bug introduced in v7.0-rc1)
- No explicit user bug reports (likely caught internally)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** — reviewed and tested by AMD,
   matches V2 behavior
2. Fixes a real bug? **YES** — incorrect fast path determination leading
   to display corruption
3. Important issue? **YES** — display corruption on popular hardware
4. Small and contained? **YES** — single function, single file, ~15
   lines
5. No new features or APIs? **YES** — pure fix
6. Can apply to stable trees? **YES** — should apply cleanly to 7.0.y

### Step 9.3: EXCEPTION CATEGORIES
Not applicable — this is a straightforward bug fix, not an exception
category.

### Step 9.4: DECISION
The evidence strongly supports backporting. This is a well-reviewed,
tested, small fix for a display corruption bug affecting popular AMD GPU
hardware on the main display update code path.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by (Dillon Varone), Tested-by (Dan
  Wheeler), SOBs from AMD maintainers
- [Phase 2] Diff analysis: ~15 lines of
  `populate_fast_updates`/`fast_update_only` moved before
  `update_planes_and_stream_state` in
  `update_planes_and_stream_prepare_v3()`
- [Phase 2] Confirmed `full_update_required()` compares
  `srf_updates[i].hdr_mult.value !=
  srf_updates->surface->hdr_mult.value` (line 5151-5152), which becomes
  false after `copy_surface_update_to_plane` (line 3592)
- [Phase 2] Confirmed `update_planes_and_stream_state` calls
  `copy_surface_update_to_plane` at line 3592 and
  `copy_stream_update_to_stream` at line 3556
- [Phase 3] git blame: buggy code introduced by d38ec099aa6fb7 (Dominik
  Kaszewski, 2025-10-31) — "Split update_planes_and_stream_v3 into parts
  (V2)"
- [Phase 3] git tag --contains: d38ec099aa6fb7 first in v7.0-rc1, so
  only 7.0.y affected
- [Phase 3] V2 path (line 5231-5233) does fast path check BEFORE
  `update_planes_and_stream_state` (line 5246) — confirmed correct
  ordering
- [Phase 3] Author Nicholas Kazlauskas has 10+ commits in dc.c, is the
  reviewer of the original refactoring commit
- [Phase 4] b4 dig: could not find original submission on lore (AMD
  patches often flow through internal tooling)
- [Phase 5] Call chain: userspace → amdgpu_dm →
  dc_update_planes_and_stream → dc_update_planes_and_stream_prepare →
  update_planes_and_stream_prepare_v3 — main display update path
- [Phase 5] V3 path enabled for DCN_VERSION_4_01+ || DCN_VERSION_3_2 ||
  DCN_VERSION_3_21 (line 7524) — RDNA 3 and RDNA 4
- [Phase 6] Bug only in 7.0.y (d38ec099aa6fb7 first in v7.0-rc1)
- [Phase 8] Failure mode: display corruption from untested fast path
  updates; severity HIGH
- UNVERIFIED: Could not access lore.kernel.org discussion due to anti-
  bot protection

**YES**

 drivers/gpu/drm/amd/display/dc/core/dc.c | 38 +++++++++++-------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 4c5ecbb97d5b0..47064e9bc08ad 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -7285,6 +7285,23 @@ static bool update_planes_and_stream_prepare_v3(
 	ASSERT(scratch->flow == UPDATE_V3_FLOW_INVALID);
 	dc_exit_ips_for_hw_access(scratch->dc);
 
+	/* HWSS path determination needs to be done prior to updating the surface and stream states. */
+	struct dc_fast_update fast_update[MAX_SURFACES] = { 0 };
+
+	populate_fast_updates(fast_update,
+			      scratch->surface_updates,
+			      scratch->surface_count,
+			      scratch->stream_update);
+
+	const bool is_hwss_fast_path_only =
+		fast_update_only(scratch->dc,
+				 fast_update,
+				 scratch->surface_updates,
+				 scratch->surface_count,
+				 scratch->stream_update,
+				 scratch->stream) &&
+		!scratch->dc->check_config.enable_legacy_fast_update;
+
 	if (!update_planes_and_stream_state(
 			scratch->dc,
 			scratch->surface_updates,
@@ -7300,26 +7317,7 @@ static bool update_planes_and_stream_prepare_v3(
 	if (scratch->new_context == scratch->dc->current_state) {
 		ASSERT(scratch->update_type < UPDATE_TYPE_FULL);
 
-		// TODO: Do we need this to be alive in execute?
-		struct dc_fast_update fast_update[MAX_SURFACES] = { 0 };
-
-		populate_fast_updates(
-				fast_update,
-				scratch->surface_updates,
-				scratch->surface_count,
-				scratch->stream_update
-		);
-		const bool fast = fast_update_only(
-				scratch->dc,
-				fast_update,
-				scratch->surface_updates,
-				scratch->surface_count,
-				scratch->stream_update,
-				scratch->stream
-		)
-		// TODO: Can this be used to skip `populate_fast_updates`?
-				&& !scratch->dc->check_config.enable_legacy_fast_update;
-		scratch->flow = fast
+		scratch->flow = is_hwss_fast_path_only
 				? UPDATE_V3_FLOW_NO_NEW_CONTEXT_CONTEXT_FAST
 				: UPDATE_V3_FLOW_NO_NEW_CONTEXT_CONTEXT_FULL;
 		return true;
-- 
2.53.0

