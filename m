Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9753EE1CB;
	Mon, 20 Apr 2026 13:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691521; cv=none; b=UJcSZvLTKNBr1qDf409ejdrTcV6/voLHVfBSkcVVwOKastKWyx/cjSnzJaGcAas+yoGEsjIVWG0QGLHN6ylCsmoaNB8ruqC98IOB7PH0YU4+l293CYz052Hx0MaJWpzOI5rEuCeL4dUV1wFPtm6cFc0YAbLA5oM3VEHU5DOWb+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691521; c=relaxed/simple;
	bh=NrkqdAASRuKR/pQPHHV8xtbXGNEIJNzvqOYq17VQT84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K54Zy+yn93pb0wH8+t4FrpkSGh7OXif+dX9JQcgxpahbD1KultLGDbrKN77nvBS0PagNzt3j48jRDmUjhbQ31ZTBCOWfFpE0tJ/kkebq1Y3eKQLNVSHhOzfVwE+t6LiHPuoMq0GiEBPM1qy6pXDiWjqL7pq41FlGOKyif00aDXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L3vZioMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L3vZioMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30156C19425;
	Mon, 20 Apr 2026 13:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691521;
	bh=NrkqdAASRuKR/pQPHHV8xtbXGNEIJNzvqOYq17VQT84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3vZioMsoCKga1j2gWMgHm5ExP1gwbbmvG1Axv8kmCCczq4z1ZGuYexfpUKD/O2FB
	 g8iE3FfQpzkXEXybQ1RqwcA798ABJP11pY4cokT3zR/71UJEFS3FNP2yiuWJ9NLigp
	 CtIoYIRC0E4BezjTSVwTFmyUwZWlA3z1yug88yk66HxwG/d2B8H7X6hpgKlH70dd7B
	 rbJ/4lMo7j1dkWv8aADfpnYCtIuBJudHm6xGZ97dK/GHOJYBIwegTPwjUXIm/G92wS
	 k3vzDJZkWEa/9VaNoy0v2OiO+MHnOP6KoWJX3lpvOz49nfeUGnPHI6bNzDRwmVRhUC
	 sHOU2b3zvpnWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ivan Lipski <ivan.lipski@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
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
Subject: [PATCH AUTOSEL 7.0-6.12] drm/amd/display: Fix cursor pos at overlay plane edges on DCN4
Date: Mon, 20 Apr 2026 09:17:52 -0400
Message-ID: <20260420132314.1023554-78-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Ivan Lipski <ivan.lipski@amd.com>

[ Upstream commit d8f6c978fd3d12ae129879dd1c514cec2e8cf2f8 ]

[Why&How]
On DCN4, when cursor straddles the left/top edge of an overlay plane, the
recout-relative position becomes negative. These negative values wrap
to large positive numbers when cast to uint32_t, causing the cursor on the
the overlay plane to disappear.

Fix by adding hotspot adjustment and position clamping after the
recout-relative calculation, matching the existing ODM/MPC slice
boundary handling.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile everything.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: drm/amd/display (AMD display controller, DCN4
  specifically)
- **Action verb**: "Fix" - explicit bug fix
- **Summary**: Fixes cursor position bug at overlay plane edges on DCN4
  hardware

### Step 1.2: Tags
- **Reviewed-by**: Nicholas Kazlauskas (AMD display driver maintainer) -
  strong quality signal
- **Signed-off-by**: Ivan Lipski (author), Alex Deucher (AMD GPU
  maintainer)
- **Tested-by**: Dan Wheeler (AMD QA)
- No Fixes: tag, no Cc: stable, no Reported-by - expected for manual
  review candidates

### Step 1.3: Body Text
The bug mechanism is clearly explained: On DCN4, when the cursor
straddles the left/top edge of an overlay plane, the recout-relative
position calculation produces negative values. These negative values
wrap to large positive numbers when cast to uint32_t, causing the cursor
to disappear. The fix adds hotspot adjustment and position clamping,
matching the existing ODM/MPC slice boundary handling pattern.

### Step 1.4: Hidden Bug Fix Detection
Not hidden at all - this is explicitly labeled as a bug fix with a clear
mechanism described.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **1 file changed**:
  `drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c`
- **+19 lines**, 0 lines removed
- **Function modified**: `dcn401_set_cursor_position()`
- **Scope**: Single-file, single-function surgical fix

### Step 2.2: Code Flow Change
**Before**: After `x_pos = pos_cpy.x - param.recout.x` (line 1211),
negative x_pos values flow directly to `pos_cpy.x = x_pos` (line 1229),
wrapping the uint32_t to a huge positive number.

**After**: Negative x_pos/y_pos values are clamped to 0 with
corresponding hotspot adjustment, preventing the uint32_t wrapping.

### Step 2.3: Bug Mechanism
This is a **type/casting bug** (integer underflow). Negative int values
wrap when assigned to uint32_t, causing the cursor to be positioned far
offscreen and effectively disappear.

### Step 2.4: Fix Quality
- Obviously correct: matches the existing ODM/MPC boundary handling
  already in the same function (lines 1177-1187)
- Minimal/surgical: 19 lines added, all in one block
- Low regression risk: only affects cursor rendering when cursor is at
  overlay plane edges, does not affect normal cursor positioning
- No API or behavioral changes for other paths

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The recout-relative code was introduced by commit `ee8287e068a399` ("Fix
cursor issues with ODMs and HW rotations") by Nevenko Stupar, which
landed in v6.11-rc1. However, the specific bug was **exposed** by commit
`c02288724b98c` ("Fix wrong x_pos and y_pos for cursor offload") by
Nicholas Kazlauskas, which added the `pos_cpy.x = x_pos; pos_cpy.y =
y_pos;` lines that store the recout-relative position into the uint32_t
pos_cpy struct. This commit only exists in **v7.0-rc1 onwards**.

### Step 3.2: Prerequisite Analysis
Commit c02288724b98c is critical. It moved cursor position storage from
the HUBP layer to the HWSS layer. Before this commit (in v6.12, v6.14,
v6.19), pos_cpy.x was NOT updated with recout-relative values, so the
negative wrapping didn't occur in the HWSS path. In older trees, HUBP
did its own translation separately.

### Step 3.3: Related Changes
Many cursor-related fixes have been applied to this file (cursor
offload, ODM issues, MPC slices). This fix is standalone and doesn't
depend on other patches in the series.

### Step 3.4: Author
Ivan Lipski is an AMD display driver contributor. The reviewer Nicholas
Kazlauskas is a key AMD display maintainer who also authored the
prerequisite commit c02288724b98c.

### Step 3.5: Dependencies
- **Depends on c02288724b98c** being present (adds `pos_cpy.x = x_pos;`
  lines). This commit exists in v7.0 but NOT in v6.19 or earlier.
- The fix is standalone within v7.0 - doesn't need any other patches
  from its series.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Original Submission
Found via web search. The patch was submitted February 18, 2026 as
[PATCH 2/9] in "DC Patches February 18, 2026" series. No objections or
NAKs were raised in the thread. Only one version (no v2/v3).

### Step 4.2: Reviewers
CC list includes all major AMD display maintainers: Harry Wentland, Leo
Li, Aurabindo Pillai, Roman Li, Wayne Lin, Tom Chung, Nicholas
Kazlauskas, Alex Hung, Dan Wheeler. Review-by from Nicholas Kazlauskas
confirms subsystem maintainer review.

### Step 4.3-4.5: No specific bug report referenced, no stable-specific
discussion found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.2: Function Context
`dcn401_set_cursor_position()` is called from the hardware sequencer
path for all cursor position updates on DCN4 hardware. It's a commonly-
triggered path - every cursor movement goes through it.

### Step 5.3: Fix Pattern
The fix exactly mirrors the existing ODM slice boundary handling at
lines 1177-1187 of the same function:

```1177:1187:drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
        if (x_pos < 0) {
                pos_cpy.x_hotspot -= x_pos;
                if
(hubp->curs_attr.attribute_flags.bits.ENABLE_MAGNIFICATION)
adjust_hotspot_between_slices_for_2x_magnify(hubp->curs_attr.width,
&pos_cpy);
                x_pos = 0;
        }

        if (y_pos < 0) {
                pos_cpy.y_hotspot -= y_pos;
                y_pos = 0;
        }
```

The new code reuses the same pattern at a different point in the
function.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable Trees
- **v6.12, v6.14, v6.19**: The recout-relative calculation exists, but
  `pos_cpy.x = x_pos;` (c02288724b98c) does NOT. The bug doesn't
  manifest in these trees.
- **v7.0**: Both the recout calculation AND `pos_cpy.x = x_pos;` exist.
  The bug is present.

### Step 6.2: Backport Complications
For v7.0.y: The patch should apply cleanly. The context lines match
exactly.
For 6.19.y and earlier: The fix would be irrelevant as the prerequisite
c02288724b98c doesn't exist.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **drivers/gpu/drm/amd/display** - AMD display controller driver
- **Criticality**: IMPORTANT - affects all users of AMD DCN4 (RDNA 4)
  GPUs using overlay planes

### Step 7.2: Activity
Very actively developed subsystem with dozens of commits per release
cycle.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Users of AMD RDNA 4 (DCN4) GPUs who use overlay planes with cursor
visible near the plane edges. This includes desktop users with
compositors using overlay planes.

### Step 8.2: Trigger Conditions
Moving the mouse cursor near the left/top edge of an overlay plane.
Common in multi-window scenarios and video playback with overlay. Can be
triggered by any user.

### Step 8.3: Failure Mode
Cursor disappears when near overlay plane edges. **Severity: MEDIUM-
HIGH** - not a crash or data corruption, but a visible rendering glitch
that makes the system harder to use.

### Step 8.4: Risk-Benefit
- **Benefit**: HIGH - fixes cursor disappearing for all DCN4 users with
  overlay planes
- **Risk**: VERY LOW - 19 lines, mirrors existing pattern, only affects
  cursor rendering, reviewed by subsystem maintainer
- **Ratio**: Very favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real, user-visible bug (cursor disappearing)
- Small, surgical fix (19 lines added, single function)
- Pattern is well-established in the same function
- Reviewed by AMD display maintainer (Nicholas Kazlauskas)
- Tested by AMD QA (Dan Wheeler)
- No objections during review
- Cleanly applies to v7.0

**AGAINST backporting:**
- Only affects DCN4 (newer AMD GPUs) - narrower user base than core
  kernel
- Symptom is cosmetic (cursor disappears), not a crash or security issue
- Bug only exists in v7.0+ (due to prerequisite c02288724b98c)
- Cannot apply to 6.19.y or earlier stable trees without also
  backporting c02288724b98c

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - mirrors existing pattern,
   Tested-by AMD QA
2. Fixes a real bug? **YES** - cursor disappears at overlay plane edges
3. Important issue? **YES** - user-visible rendering bug affecting
   usability
4. Small and contained? **YES** - 19 lines, single function, single file
5. No new features? **YES** - pure bug fix
6. Can apply to stable? **YES** for 7.0.y; **NO** for older trees
   (missing prerequisite)

### Step 9.3: Exception Categories
Not an exception category - this is a standard bug fix.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Nicholas Kazlauskas, Tested-by Dan
  Wheeler, SOBs from Ivan Lipski and Alex Deucher
- [Phase 2] Diff analysis: +19 lines in `dcn401_set_cursor_position()`,
  adds negative position clamping with hotspot adjustment
- [Phase 3] git blame: recout-relative code from ee8287e068a399 (v6.11),
  bug exposed by c02288724b98c (v7.0-rc1)
- [Phase 3] git show c02288724b98c: confirmed it adds `pos_cpy.x =
  x_pos;` lines, only in v7.0+
- [Phase 3] Verified v6.12 code does NOT have `pos_cpy.x = x_pos;` - bug
  doesn't manifest there
- [Phase 3] Verified v6.14 and v6.19 code also lacks `pos_cpy.x =
  x_pos;` - same conclusion
- [Phase 4] Found original submission on freedesktop.org mailing list
  (Feb 18, 2026): patch 2/9 in DC Patches series
- [Phase 4] No NAKs or objections; reviewed by subsystem maintainer
- [Phase 5] Confirmed pattern matches existing ODM boundary handling at
  lines 1177-1187 of same function
- [Phase 6] Verified buggy code exists in v7.0 (confirmed `pos_cpy.x =
  x_pos` present and no clamping)
- [Phase 6] Verified patch context lines match v7.0 tree - will apply
  cleanly
- [Phase 8] Failure mode: cursor disappears at overlay edges, severity
  MEDIUM-HIGH (usability impact)

The fix is small, surgical, obviously correct, fixes a real user-visible
bug on DCN4 hardware, follows established code patterns, and was
properly reviewed and tested by AMD's display team. It applies cleanly
to the 7.0.y stable tree where the bug exists.

**YES**

 .../amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 4dfb6c8658312..4973d36aadc5d 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -1211,6 +1211,25 @@ void dcn401_set_cursor_position(struct pipe_ctx *pipe_ctx)
 	x_pos = pos_cpy.x - param.recout.x;
 	y_pos = pos_cpy.y - param.recout.y;
 
+	/**
+	 * If the cursor position is negative after recout adjustment, we need
+	 * to shift the hotspot to compensate and clamp position to 0. This
+	 * handles the case where cursor straddles the left/top edge of an
+	 * overlay plane - the cursor is partially visible and needs correct
+	 * hotspot adjustment to render the visible portion.
+	 */
+	if (x_pos < 0) {
+		pos_cpy.x_hotspot -= x_pos;
+		if (hubp->curs_attr.attribute_flags.bits.ENABLE_MAGNIFICATION)
+			adjust_hotspot_between_slices_for_2x_magnify(hubp->curs_attr.width, &pos_cpy);
+		x_pos = 0;
+	}
+
+	if (y_pos < 0) {
+		pos_cpy.y_hotspot -= y_pos;
+		y_pos = 0;
+	}
+
 	recout_x_pos = x_pos - pos_cpy.x_hotspot;
 	recout_y_pos = y_pos - pos_cpy.y_hotspot;
 
-- 
2.53.0

