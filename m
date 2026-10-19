Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5D2526067;
	Mon, 19 Oct 2026 14:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418557; cv=none; b=Vqfofk+bG+Ns5DDM3UtgYNX+Dxo/XLWhJCey+JPJdLV07B66m2xaolpC8StIN5/Z60ygA/OXeC4vhtoH413BHaEazIY5rZf7a1n+o7KmBLUMY8gCynljLm7FWeeb9ZZPlx6VwyF1g4vpsvCxD+IizAzKUFS9P6mgPl2QSNwb1c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418557; c=relaxed/simple;
	bh=Vx8G1Ap52bGm8oaLGWhx+6tiy8cMDRzp5hlYzWtbZFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u8cVEb2BjBT0VcWhhurXTUlJkVUegrWb6r2bvxEXH2agpMV7ehZBG6YOFqpHzpUfcB5Ye8D5W032ejXQ8GjY8yT0AZcjYhsCICePD07e4WNKV9hxTMDjdNek2Xa/iNpygdOJ9z5VZQL9lwa2zlKPHH/b3IJowBqcc822qtBYEVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+q/kK5n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+q/kK5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A151F000C7;
	Mon, 19 Oct 2026 14:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418554;
	bh=fZgwjOjgTxDqGJwWA9/YuOYS62n2TA1ttameMJdX5oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O+q/kK5nnEjkaNIWNb/kUGc+4pUHrgM4q2M/QviLdhoS4ctY+PDFQXoe45BC4x0+4
	 bwdUVP0fqCipC7pYkuVaVpGaaFlZUr4j/eN5SvzBujHNN7SuoDh3WND0Jf2hqhSPmS
	 LBTgOMAs7lCBVgt0Z6uE+x8fKT4bZKf7O2MWmGObVO7zt2juwjegt7iep2RefegfWW
	 W3a19uZPhRayJq30YDMAzqn3xDXZQWYaKCGLYhEZjTlgPqA+aHly2LN4buCb/iDG8d
	 VoF3qwGuDITN+HTM82eo42YFkN0NUQvHGa9m1btsV4JrezkPQ8eY+EVQpLpwvgq4j4
	 Kg4HpaLXQHbHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gilles Risch <gilles.risch@gmail.com>,
	Lukas Wunner <lukas@wunner.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] drm/radeon: fix internal display on iMac11, 1 (RV770/DCE3.1)
Date: Mon, 19 Oct 2026 09:50:22 -0400
Message-ID: <20261019135441.1420968-331-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gilles Risch <gilles.risch@gmail.com>

[ Upstream commit 275c3332585bbabcefad109a6978cc0cbecf2008 ]

The Apple iMac11,1 (27-inch, Late 2009) uses a Mobility Radeon HD 4850
(RV770/DCE3.1) with a 2560x1440 internal panel on an internal
DisplayPort path. Without this fix the display stays dark under KMS.

This machine suffers from the same issue as iMac10,1 and iMac11,2:
Apple routes the internal display through Link B of the DIG encoder
instead of Link A. Add iMac11,1 to the existing DMI quirk and move
the Apple-specific encoder assignment into its own block, independent
of the DCE version check.

Additionally, the 2560x1440 panel requires RADEON_PLL_USE_FRAC_FB_DIV
and ATOM_ENCODER_CMD_DP_VIDEO_ON, limited to iMac11,1 via dmi_match()
to avoid affecting other boards.

Reviewed-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Gilles Risch <gilles.risch@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The iMac11,1 Link-B
quirk is missing here; iMac10,1 and iMac11,2 already have it. This is a
DMI-limited hardware quirk that lights the internal panel, and it
matches the stable exception for device-specific workarounds.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[drm/radeon] [fix] internal display stays dark on iMac11,1
(RV770/DCE3.1)`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Reviewed-by: Lukas Wunner <lukas@wunner.de>`
- `Signed-off-by: Gilles Risch <gilles.risch@gmail.com>` (author)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (radeon
  maintainer)
- No `Fixes:` tag (expected)
- No `Reported-by:` / `Tested-by:` / `Link:` / `Cc: stable` (expected
  for this review pipeline)
- No syzbot / sanitizer tags

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** Apple iMac11,1 (27-inch, Late 2009) Mobility Radeon HD 4850
  (RV770/DCE3.1), 2560x1440 internal panel on an internal DisplayPort
  path.
- **Symptom:** Internal display stays dark under KMS.
- **Root cause:** Same Apple Link-B DIG routing as iMac10,1 and
  iMac11,2; plus this 2560x1440 panel also needs
  `RADEON_PLL_USE_FRAC_FB_DIV` and `ATOM_ENCODER_CMD_DP_VIDEO_ON`.
- **Fix approach:** Add iMac11,1 to the existing DMI quirk; move Apple
  encoder assignment out of the DCE-version check; DMI-limit the PLL and
  DP_VIDEO_ON extras to iMac11,1.
- **Version info:** None in the message. Hardware is 2009; related
  quirks date to 2017/2023.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not hidden. This is an explicit hardware-quirk bug fix (dark
panel). Not cleanup, refactor, or a new API.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- `drivers/gpu/drm/radeon/atombios_crtc.c`: +`#include <linux/dmi.h>`;
  PLL flag condition widened for iMac11,1 (~3 lines net)
- `drivers/gpu/drm/radeon/atombios_encoders.c`: DP_VIDEO_ON DMI match;
  encoder picker restructure (~12 lines)
- Functions: `atombios_adjust_pll()`, `radeon_atom_encoder_dpms_dig()`,
  `radeon_atom_pick_dig_encoder()`
- Scope: small, two-file surgical driver quirk (~17 insertions / 11
  deletions)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
1. **PLL (`atombios_adjust_pll`):** Before, `RADEON_PLL_USE_FRAC_FB_DIV`
   for clocks >165 MHz only if `ASIC_IS_DCE32()`. After, also if DMI
   product is `iMac11,1`. RV770 is not DCE3.2 (`CHIP_RV770` precedes
   `CHIP_RV730`), so iMac11,1 never took this path.
2. **DPMS ON (`radeon_atom_encoder_dpms_dig`):** Before,
   `ATOM_ENCODER_CMD_DP_VIDEO_ON` only if `ASIC_IS_DCE4()`. After, also
   for iMac11,1. DCE3.1 iMac11,1 never issued VIDEO_ON.
3. **Encoder pick (`radeon_atom_pick_dig_encoder`):** Before, Apple
   Link-B assignment lived inside `if (ASIC_IS_DCE32())` for iMac10,1
   and iMac11,2 only. iMac11,1 (DCE3.1) fell through to DCE3 LVTMA
   logic, which does not use `dig->linkb`. After, Apple DMI check runs
   first (now including iMac11,1), then DCE32 still uses `crtc_id`.
   iMac10,1/11,2 behavior is preserved.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[h] Hardware workaround / DMI quirk.** Wrong DIG encoder (Link
A vs Link B), missing fractional FB divider for a high-clock 2560x1440
panel, missing DP video-on ATOM command. Combined result: dark internal
panel.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Quality: high. PLL and VIDEO_ON are DMI-limited. Encoder change for
  other Apple iMacs is behavior-preserving. Non-Apple DCE3.1 still uses
  the old LVTMA path.
- Maintainer (Alex Deucher) rejected v4’s `ASIC_IS_DCE31()` because it
  would change encoder routing for all DCE3.1 boards; v5 follows that
  request.
- Residual: DPMS OFF still does not send `DP_VIDEO_OFF` for iMac11,1
  (only DCE4+ does). That can only affect this one DMI product, and v5
  dropped the broader resume/OFF series on purpose.
- Regression risk: low. No public API, no lock, no refcount, no new
  module param.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- PLL DCE32 check: `a02dc74b317d78` (Alex Deucher, 2012) “dce32+: use
  fractional fb dividers for high clocks”
- DP_VIDEO_ON DCE4 check: `3f03ced8808792` (Alex Deucher, 2011)
- Apple DMI quirk: `564d8a2cf3abf1` (Mario Kleiner, 2017, iMac10,1) then
  `05eacc198c68cb` (Mark Hawrylak, 2023, iMac11,2)
- DCE32 encoder pick: `3f03ced8808792` (2011)
- Bug is long-standing (pre-3.13 for the sibling iMac10,1 issue).
  Present in this 6.12 tree.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Closest ancestors in this tree:
- `564d8a2cf3abf` “Fix eDP for single-display iMac10,1 (v2)” — `Cc:
  stable`, `git merge-base --is-ancestor` = yes
- `05eacc198c68c` “Fix eDP for single-display iMac11,2” — `Cc: stable`,
  ancestor = yes

Those two patches could not cover iMac11,1 because they are inside
`ASIC_IS_DCE32()`, and RV770 is not DCE3.2.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent radeon encoder/crtc history is backlight, helper
conversions, iMac12,x backlight — not a conflicting refactor of this
picker. Standalone v5 (earlier v3 was 2/2; resume patch was dropped). No
missing prerequisite in this tree.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Gilles Risch has no radeon commits in this tree (first-time
hardware reporter/tester). Alex Deucher is the radeon maintainer and
signed off. Lukas Wunner (Apple/x86) reviewed.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Uses existing `dmi_match()`, `RADEON_PLL_USE_FRAC_FB_DIV`,
`ATOM_ENCODER_CMD_DP_VIDEO_ON`, `radeon_atom_pick_dig_encoder()`. Adds
`#include <linux/dmi.h>` to `atombios_crtc.c` (not currently included;
`atombios_encoders.c` already has it). Applies standalone. Companion eDP
resume patch is not required for the boot-time dark-panel fix.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- Candidate SHA is not in this tree, so `b4 dig -c <this-commit>` cannot
  be used. Located via subject search.
- v5: https://lore.gitlab.freedesktop.org/drm-ai-
  reviews/20260601211931.2837-2-gilles.risch@gmail.com/ (Message-ID
  `20260601211931.2837-2-gilles.risch@gmail.com`)
- v4 review (Alex): https://lists.freedesktop.org/archives/amd-
  gfx/2026-May/145586.html
- Revisions: v1 (2026-05-10) → v2 → v3 0/2 (plus resume patch) → v4
  (`ASIC_IS_DCE31`) → **v5** (DMI-only encoder block; this commit)
- Alex NAK’d v4’s `if (ASIC_IS_DCE31())` as changing DCE3.1 routing
  generally; asked for an iMac11,1 DMI block with `goto assigned`. v5
  does that (and includes the other two Apple DMI IDs).
- No NAK on v5. No reviewer `Cc: stable` found.
- `b4 mbox` of the v5 msgid started (30 messages) then failed on a local
  save path; thread content was retrieved via lore/gitlab and
  lists.freedesktop.org instead.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: To: Alex Deucher. Cc: amd-gfx, dri-devel. Reviewed-by Lukas
Wunner (on v2; tag kept). Applied/signed-off by Alex Deucher.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: Author tested on a real iMac11,1. Symptom is dark KMS display.
Same class as documented iMac10,1 (Mario Kleiner, 2017: black display
when radeon KMS loads) and iMac11,2 (2023). A 2023 amd-gfx attempt (“Fix
eDP for single-display iMac11,1”) used `ASIC_IS_DCE31` and did not land;
this 2026 series is the one that did.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: v3 2/2 “fix eDP resume from suspend” (VIDEO_OFF +
`atombios_set_edp_panel_power` for iMac11,1) was not part of v5. v5 is
self-contained for initial bring-up. Not a hard dependency.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: UNVERIFIED — lore.kernel.org returned 403. Sibling iMac10,1 and
iMac11,2 quirks both carried `Cc: stable@vger.kernel.org` and are in
this tree.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `atombios_adjust_pll`, `radeon_atom_encoder_dpms_dig`,
`radeon_atom_pick_dig_encoder`

**Step 5.2: TRACE CALLERS**

Record:
- `atombios_adjust_pll()` ← `atombios_crtc.c` mode-set
  (`radeon_crtc->adjusted_clock = atombios_adjust_pll(...)`)
- `radeon_atom_pick_dig_encoder()` ← `radeon_atom_encoder_prepare()`
  (modeset prepare) ← `radeon_atom_dig_helper_funcs.prepare`
- `radeon_atom_encoder_dpms_dig()` ← `radeon_atom_encoder_dpms()` for
  UNIPHY/LVTMA ← helper `.dpms`, `.commit` (DPMS_ON), `.disable`
  (DPMS_OFF)

**Step 5.3: TRACE CALLEES**

Record: `atombios_dig_encoder_setup()` / `atom_execute_table()` (ATOM
BIOS), `radeon_dp_link_train()`, `dmi_match()`. No alloc/lock changes.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Userspace DRM modeset / KMS bring-up on this iMac. Reachable on
every graphical boot for that machine. Not a syscall fuzzer path; it is
the normal display path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same DMI Link-B pattern already used for iMac10,1 and iMac11,2
in this file. This commit extends that list and lifts it out of
`ASIC_IS_DCE32()`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: Yes. `git describe HEAD` = `p-6.12-3-gc504cf0baa3d8`; `make
kernelversion` = **6.12.111**.
- `atombios_encoders.c:2130-2135` still matches only iMac10,1 / iMac11,2
  inside `ASIC_IS_DCE32()`.
- No `iMac11,1` in `drivers/gpu/drm/radeon/`.
- `ASIC_IS_DCE32` = `family >= CHIP_RV730`; `radeon_family.h` has
  `CHIP_RV770` then `CHIP_RV730`, so RV770 is DCE3 but not DCE3.2.
- Candidate commit is not an ancestor of HEAD.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** Pre-image in this tree matches the provided
diff (PLL line 597, DPMS line 1710, picker 2125-2138). Need the new
`linux/dmi.h` include in `atombios_crtc.c`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: iMac10,1 and iMac11,2 quirks are present. They do not cover
iMac11,1. No alternate iMac11,1 radeon fix in this tree.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: `[drm/radeon] [IMPORTANT]` — legacy AMD GPU KMS driver, still
`CONFIG_DRM_RADEON` in this tree. Affects one Apple DMI product, not
core mm/fs.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature/legacy. Occasional hardware quirks and small fixes.
Encoder picker logic has been stable since ~2011 with Apple DMI
additions in 2017 and 2023.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Driver-specific + DMI-specific: Apple iMac11,1 (Late 2009
27-inch, HD 4850). Encoder restructure also runs on iMac10,1 and
iMac11,2 with the same Link-B assignment they already had.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Loading radeon KMS / modesetting the internal panel. Common for
anyone using this machine as a Linux desktop. Not a race. Unprivileged
user does not need a special trigger beyond using the GUI.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **[Dark internal display / unusable KMS console and desktop]
[HIGH]** — not a panic, but the primary display does not work. Same
severity as the iMac10,1/iMac11,2 quirks that went to stable.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- Benefit: high for iMac11,1 6.12 LTS users (working internal panel).
- Risk: very low (~20 lines, DMI-gated extras, behavior-preserving
  picker for existing Apple IDs).
- Ratio: favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, user-visible bug: internal panel stays dark under KMS.
- Hardware quirk exception (DMI table), same pattern as
  iMac10,1/iMac11,2 which had `Cc: stable` and are already in this tree.
- Small, obviously correct after maintainer feedback (v5 vs rejected v4
  `ASIC_IS_DCE31`).
- DMI-limited PLL and VIDEO_ON so other RV770 boards are unchanged.
- Buggy code exists in 6.12.111; patch applies cleanly.
- Reviewed by Lukas Wunner; signed off by Alex Deucher; tested on the
  machine.

AGAINST:
- Not a crash, UAF, or CVE.
- Affects one 2009 iMac model.
- No matching `DP_VIDEO_OFF` (iMac11,1-only residual on DPMS off).
- Resume/eDP power follow-up is a separate patch, not included.

UNRESOLVED:
- lore.kernel.org/stable search (HTTP 403).
- `b4 dig` on the candidate SHA (commit not in this tree).
- Whether a later VIDEO_OFF/resume patch exists upstream after v5.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — v5 matches maintainer
   request; tested on iMac11,1; Reviewed-by + maintainer SOB.
2. Fixes a real bug that affects users? **PASS** — dark KMS display on
   that iMac.
3. Important issue? **PASS** — unusable internal display; hardware-quirk
   class already accepted for the sibling iMacs.
4. Small and contained? **PASS** — two files, ~20 lines.
5. No new features or APIs? **PASS** — DMI quirk on existing driver
   paths.
6. Can apply to the local tree? **PASS** — context matches 6.12.111.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **Hardware quirk/workaround** (Apple DMI encoder/PLL/DP
command). Explicitly allowed for stable.

**Step 9.4: DECISION**

This should be backported to this 6.12 tree. It is the same class of
Apple radeon eDP quirk as iMac10,1 and iMac11,2, which this tree already
carries. iMac11,1 is RV770/DCE3.1, so it never matched `ASIC_IS_DCE32()`
and still boots with a dark panel. The fix is small, DMI-limited,
applies cleanly, and was narrowed specifically so it does not retune
other DCE3.1 boards.

Verification:
- [Phase 1] Parsed subject/tags/body from the provided commit; no
  Fixes/Cc-stable (expected).
- [Phase 2] Diff: `atombios_adjust_pll` FRAC_FB_DIV,
  `radeon_atom_encoder_dpms_dig` DP_VIDEO_ON,
  `radeon_atom_pick_dig_encoder` DMI block moved out of DCE32.
- [Phase 2] Confirmed local code at `atombios_encoders.c:1710` and
  `:2130-2135` and `atombios_crtc.c:597` matches the pre-image.
- [Phase 3] `git blame`: PLL `a02dc74b317d78` (2012), VIDEO_ON
  `3f03ced8808792` (2011), Apple DMI `564d8a2cf3abf` (2017) /
  `05eacc198c68c` (2023).
- [Phase 3] `git merge-base --is-ancestor` 564d8a2cf3abf and
  05eacc198c68c vs HEAD: both present.
- [Phase 3] `radeon_family.h`: CHIP_RV770 immediately before CHIP_RV730;
  `ASIC_IS_DCE32` is `>= CHIP_RV730`.
- [Phase 3] No Gilles Risch radeon commits in this tree; Alex Deucher is
  the maintainer.
- [Phase 4] v5 lore: Message-ID
  `20260601211931.2837-2-gilles.risch@gmail.com`.
- [Phase 4] Alex v4 comment (lists.freedesktop.org/amd-
  gfx/2026-May/145586.html): do not use `ASIC_IS_DCE31()` for routing;
  use iMac11,1 `dmi_match` + `goto assigned`.
- [Phase 4] Lukas Wunner Reviewed-by on v2 (ratatoskr.run/amd-
  gfx/2026/05/9273941).
- [Phase 4] lore.kernel.org fetches: 403. UNVERIFIED: stable@
  discussion.
- [Phase 4] `b4 mbox` v5 msgid: 30 messages found, local save failed.
  UNVERIFIED: full mbox dump.
- [Phase 5] Callers: `radeon_atom_encoder_prepare` → pick encoder;
  `radeon_atom_encoder_dpms` → UNIPHY dpms_dig; `atombios_adjust_pll`
  from CRTC mode set.
- [Phase 6] `git describe HEAD` = p-6.12-3-gc504cf0baa3d8; `make
  kernelversion` = 6.12.111; `iMac11,1` absent from radeon/.
- [Phase 8] Failure mode: dark internal panel on KMS load, severity HIGH
  for that DMI product.
- UNVERIFIED: whether a post-v5 DP_VIDEO_OFF/resume patch later landed
  upstream.

**YES**

 drivers/gpu/drm/radeon/atombios_crtc.c     |  5 ++++-
 drivers/gpu/drm/radeon/atombios_encoders.c | 23 ++++++++++++----------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index 9b3a3a9d60e20..837700ab8079f 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -24,6 +24,8 @@
  *          Alex Deucher
  */
 
+#include <linux/dmi.h>
+
 #include <drm/drm_fixed.h>
 #include <drm/drm_fourcc.h>
 #include <drm/drm_framebuffer.h>
@@ -594,7 +596,8 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
 		if (((rdev->family == CHIP_RS780) || (rdev->family == CHIP_RS880))
 		    && !radeon_crtc->ss_enabled)
 			radeon_crtc->pll_flags |= RADEON_PLL_USE_FRAC_FB_DIV;
-		if (ASIC_IS_DCE32(rdev) && mode->clock > 165000)
+		if ((ASIC_IS_DCE32(rdev) || dmi_match(DMI_PRODUCT_NAME, "iMac11,1"))
+		    && mode->clock > 165000)
 			radeon_crtc->pll_flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 	} else {
 		radeon_crtc->pll_flags |= RADEON_PLL_LEGACY;
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 3d9f47bc807af..ddfa31a7b83a5 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1707,7 +1707,7 @@ radeon_atom_encoder_dpms_dig(struct drm_encoder *encoder, int mode)
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector) {
 			/* DP_SET_POWER_D0 is set in radeon_dp_link_train */
 			radeon_dp_link_train(encoder, connector);
-			if (ASIC_IS_DCE4(rdev))
+			if (ASIC_IS_DCE4(rdev) || dmi_match(DMI_PRODUCT_NAME, "iMac11,1"))
 				atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_DP_VIDEO_ON, 0);
 		}
 		if (radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT)) {
@@ -2123,17 +2123,20 @@ int radeon_atom_pick_dig_encoder(struct drm_encoder *encoder, int fe_idx)
 	}
 
 	/*
-	 * On DCE32 any encoder can drive any block so usually just use crtc id,
-	 * but Apple thinks different at least on iMac10,1 and iMac11,2, so there use linkb,
-	 * otherwise the internal eDP panel will stay dark.
+	 * Apple routes the internal eDP panel through Link B of the DIG encoder
+	 * instead of Link A on the iMac10,1, iMac11,1 and iMac11,2.
+	 * Use linkb to avoid a dark display.
 	 */
-	if (ASIC_IS_DCE32(rdev)) {
-		if (dmi_match(DMI_PRODUCT_NAME, "iMac10,1") ||
-		    dmi_match(DMI_PRODUCT_NAME, "iMac11,2"))
-			enc_idx = (dig->linkb) ? 1 : 0;
-		else
-			enc_idx = radeon_crtc->crtc_id;
+	if (dmi_match(DMI_PRODUCT_NAME, "iMac10,1") ||
+	    dmi_match(DMI_PRODUCT_NAME, "iMac11,1") ||
+	    dmi_match(DMI_PRODUCT_NAME, "iMac11,2")) {
+		enc_idx = (dig->linkb) ? 1 : 0;
+		goto assigned;
+	}
 
+	/* on DCE32 and encoder can driver any block so just crtc id */
+	if (ASIC_IS_DCE32(rdev)) {
+		enc_idx = radeon_crtc->crtc_id;
 		goto assigned;
 	}
 
-- 
2.53.0

