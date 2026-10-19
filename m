Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEF45DD574;
	Mon, 19 Oct 2026 14:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418538; cv=none; b=KdQJQTbCRbNSXuBymwUn5wcd4cAnZ8cQvYI299p9bk7N/eKW2kBcKjJUKP/XpjhpcMD7ukQIooU6IBNbfNwQGefaaozEbAjr2u4fMHnBPM1WEgYYBKjDBphCC1HtYrE6+CLe5mQ6PQ80Az8OiWCMfJoUyoOnVSC1UX1SEjR0Uqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418538; c=relaxed/simple;
	bh=rdreeGsyL3pCHnz92Zx9K7T1XZ/e3VBbHHTB7w/ja3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=peY3AfcrSe6lB1LyGx0CcYY7a17LE2P4/h8yL36jWFaM+mO/EEtCGamwsvQgK33jrtFhWtpEeY8TqrytEWE+IrAlIx/OKykTB0WsFOKzONCfCa56nqepsriR/PkOTnU1xUVZ2nc/nMD4ktPCpnQl6PHT4Ml1TNm0HVf+LpTrpuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Or2ODciU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Or2ODciU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978431F000C7;
	Mon, 19 Oct 2026 14:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418531;
	bh=Y0Acs1GjZ8s3VI9YkREK3IWGQmpvGOM/AWX2WIww85A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Or2ODciU7WUELSUSN+yZmyPGr/PS8WZKTgNbpybAuAqGVWDsVCkxt8LrS7x8JmDwu
	 KpFhrgYCCRh4r9iNfIWGD+LE4LSNShoVp2ZfQ91HbE1ONYV246+aJJm1TWS3Vrmwq3
	 24VwhOf6iLMqYb642cHJwhAeY9axs2BHX/FSfSpk6gfld9amhoSsaZ9GUIyFSmyMl9
	 882G2cKs9ZNbq1b/KEOqwlE0nXwKiP8Z8i+bvworf+P9cJ/bd9WkimaICz39EjezPH
	 Pe5mygpsVRxtKPsQWhJ69/O94+jt1bhGdLwfKrsG8SQe7u0POrUenilTSEAc5T3T/i
	 I348Ibf1o5sKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dio Zhang <dioyc_zhang@compal.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/panel: panel-edp: Adjust T8 timing for AUO B116XAK01.6 and B140XTK02.4
Date: Mon, 19 Oct 2026 09:50:05 -0400
Message-ID: <20261019135441.1420968-314-sashal@kernel.org>
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

From: Dio Zhang <dioyc_zhang@compal.corp-partner.google.com>

[ Upstream commit 0d40cab39158704e372240ed9821a00bfe117125 ]

Screen garbage or flickering can be observed during mode changes (such
as VT switches) on systems using the AUO B116XAK01.6 and B140XTK02.4
panels.

This occurs because the backlight is enabled before the video signal
stabilizes. Waveform measurements show that the panel signal takes
around 140ms to stabilize after a mode change, meaning the previous 50ms T8
timing was insufficient.

To resolve this issue, adjust the eDP panel delay entry from
delay_200_500_e50 to delay_200_500_e200 (increasing T8 from 50ms to 200ms).
This matches the updated panel specifications from AUO, which now formally
define T8 as 200ms to mask any display abnormalities during mode changes.

Signed-off-by: Dio Zhang <dioyc_zhang@compal.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260720025358.2781136-1-dioyc_zhang@compal.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This checkout is **Linux 7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
change is a two-line eDP T8 delay quirk for two AUO panels. Both panel
IDs and `delay_200_500_e200` exist here; the fix is a hardware timing
workaround, not a new API.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[drm/panel: panel-edp] [Adjust] [increase T8/enable delay from
50ms to 200ms for two AUO eDP panels]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Dio Zhang <dioyc_zhang@compal.corp-
  partner.google.com>` (author)
- `Reviewed-by: Douglas Anderson <dianders@chromium.org>` (panel-edp
  reviewer in MAINTAINERS)
- `Signed-off-by: Douglas Anderson <dianders@chromium.org>` (applied via
  drm-misc)
- `Link: https://patch.msgid.link/20260720025358.2781136-1-
  dioyc_zhang@compal.corp-partner.google.com`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Acked-by:`, or `Cc:
  stable` (absence expected)
- Ignore any pipeline `Upstream commit` / Sasha Levin SOB (none present
  on the real commit)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** On AUO B116XAK01.6 and B140XTK02.4, the backlight comes on
  before the video signal is stable after a mode change.
- **Symptom:** Screen garbage or flickering during mode changes (e.g. VT
  switches).
- **Root cause:** T8 (`delay.enable`) was 50ms; waveforms show ~140ms
  until the signal is stable. AUO’s updated spec now lists T8 as 200ms.
- **Fix:** Point those two `EDP_PANEL_ENTRY` rows at
  `delay_200_500_e200` instead of `delay_200_500_e50`.
- **Versions:** none named in the message.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit hardware-timing fix
for a user-visible display glitch.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/gpu/drm/panel/panel-edp.c` — **2 insertions, 2
  deletions** (4 lines with context).
- No functions rewritten; two table initializers in `edp_panels[]`.
- Scope: single-file, surgical table tweak.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: AUO 0x1ea5 (B116XAK01.6) and AUO 0x67a8 (B140XTK02.4) used
  `delay_200_500_e50` (`enable = 50`).
- After: both use `delay_200_500_e200` (`enable = 200`).
- Path: EDID-matched panel probe copies `detected_panel->delay` into
  `desc->delay`; `panel_edp_enable()` then `msleep(delay.enable)` before
  backlight-on. Only those two product IDs change.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** hardware workaround / timing quirk (T8 too short).
- **Mechanism:** backlight enabled while the panel still shows invalid
  frames; lengthening T8 masks the garbage until the signal is valid.
  Matches other `delay_200_500_e200` users in the same table.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: reuses an existing delay struct; no new constants
  or control flow.
- Minimal; no unrelated edits.
- Regression risk is low and local: +150ms backlight-on delay only for
  those two EDID IDs. Maintainer Doug Anderson noted that longer delays
  “always stink, but sometimes is unavoidable,” then reviewed and
  applied the patch. No deadlock/API/locking change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Current lines are commit `0d40cab391587` (Dio Zhang, 2026-07-20) —
  this fix.
- B116XAK01.6 (`0x1ea5`) added in `a70abdd994cb` (“drm/panel-edp: Add
  AUO B116XAK01.6”, 2022-09-23) with `delay_200_500_e50`. Contained in
  `v6.1-rc1`.
- B140XTK02.4 (`0x67a8`) added in `4c34cdb93ea1` (2026-05-09) with
  `delay_200_500_e50`. Present in this 7.3 tree.
- `delay_200_500_e200` first appeared in `f6ff4570e567` (2022-07-20,
  “Add panel entry for R140NWF5 RH”), also `v6.1-rc1` era.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. The original panel-add commits
used a conservative generic 50ms T8 that later proved too short for
these two SKUs.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Same file has many “Fix delays for …” / “Modify … delay” commits (e.g.
  `43113fd4c5f56` INX N116BCA-EA2, `9abe13a0598a8` CMN 0x14d6).
  Established pattern.
- Follow-ups after `0d40cab` are unrelated (I2C leak, new panel IDs,
  `pre_unprepare`).
- Standalone; not “patch X/Y”.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Dio Zhang has this one commit under `drivers/gpu/drm/panel/`.
Douglas Anderson is the listed reviewer for `DRM DRIVER FOR GENERIC EDP
PANELS` and authored/applied many `panel-edp` changes.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs `edp_panels[]`, `delay_200_500_e200`, and the two
`EDP_PANEL_ENTRY` rows. All exist in this tree. Standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 0d40cab391587`: v2 at https://patch.msgid.link/202607200253
  58.2781136-1-dioyc_zhang@compal.corp-partner.google.com
- `b4 dig -a`: v1 2026-07-17, v2 2026-07-20 (applied).
- v1 review (mbox): Doug asked only for a real name in SOB/authorship;
  no NAK; no stable debate.
- v2 review (mbox): Doug R-b’d, fixed subject to name both panels, noted
  it needed a trivial rebase onto drm-misc-next, pushed as
  `0d40cab391587`.
- WebFetch of lore.kernel.org returned **403**; discussion recovered via
  `b4 dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included `dianders@chromium.org`,
`neil.armstrong@linaro.org`, `airlied@gmail.com`, `daniel@ffwll.ch`,
`sam@ravnborg.org`, `dri-devel@lists.freedesktop.org`, `linux-
kernel@vger.kernel.org`. Subsystem reviewer Doug Anderson both reviewed
and applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by` / bugzilla / syzbot. Evidence is the author’s
waveform measurements plus AUO’s updated T8=200ms spec. Compal/Google-
partner author implies Chromebook-class hardware.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Single-patch series. v2 vs v1 is authorship/subject cleanup,
same diff.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** — lore.kernel.org/stable WebFetch returned 403.
No stable mention in the dri-devel mbox.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: No function bodies edited. Runtime users of the table:
`find_edp_panel()`, panel identification in `panel_edp_probe()` path
(`desc->delay = *panel->detected_panel->delay`), `panel_edp_enable()`.

**Step 5.2: TRACE CALLERS**
Record:
- `find_edp_panel()` called from the generic eDP identification path
  (~line 820) after reading the EDID panel ID.
- `panel_edp_enable` is the DRM panel `.enable` callback
  (`panel_edp_funcs`).
- Called on modeset/enable (including VT switch), not a rare error path.

**Step 5.3: TRACE CALLEES**
Record: `panel_edp_enable()` uses `msleep(delay)` then
`panel_edp_wait()` for `prepare_to_enable` / `powered_on_to_enable`.
This change only increases the `msleep` for those two IDs.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace modeset / VT switch → DRM enable →
`panel_edp_enable()` → extra 150ms wait → backlight. Reachable on any
system whose eDP panel EDID is AUO 0x1ea5 or 0x67a8.
`CONFIG_DRM_PANEL_EDP` (OF + backlight). Not a syscall memory-safety
bug; it is a common display path for those laptops.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Many other panels already use `delay_200_500_e200`. Prior “Fix
delays for …” commits in this file use the same table-pointer swap.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD`: `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion`: **7.3.0-rc4**.
- Both panel rows exist. `git merge-base --is-ancestor 0d40cab391587
  HEAD` is true (this is mainline after the fix).
- Pre-fix state used `delay_200_500_e50` for both IDs; that is the bug
  this tree’s history actually had. B116XAK01.6 has been in tree since
  v6.1-rc1; B140XTK02.4 since May 2026, also in 7.3.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Context in this tree matches the committed hunk (same
vendor/product rows). `delay_200_500_e200` is present. No structural
mismatch. Forward `git apply --check` of the patch on current HEAD fails
only because the after-image is already applied — expected on this
mainline checkout.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This is the delay fix for those two IDs. No competing alternate
T8 patch found on this file.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/gpu/drm/panel/panel-edp.c` — generic eDP panel driver.
**IMPORTANT** for laptops/Chromebooks using generic eDP, not core
mm/VFS. Peripheral relative to the whole kernel, but the driver is
widely used.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively updated (panel IDs, delay tweaks, probe leak fixes).
Mature table-driven delay model since ~2022.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific / hardware-specific: only EDID AUO 0x1ea5 and
0x67a8. No effect on other panels.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Mode changes such as VT switches (author). Common on laptops.
Unprivileged users can trigger VT/modeset on typical distro setups. Not
a security exploit path.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Screen garbage/flickering. Not oops/deadlock/corruption.
**MEDIUM** user-visible display bug. Official stable rules explicitly
list **hardware quirk** next to oops/hang as acceptable
(`Documentation/process/stable-kernel-rules.rst`).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** Stops garbage/flicker on two real AUO panels; matches
  vendor T8=200ms; waveform-backed (~140ms needed vs 50ms old).
- **Risk:** Very low — 2 pointer swaps, existing struct, +150ms enable
  delay only for those IDs.
- **Ratio:** Favorable. Same class as USB/PCI delay quirks that
  routinely go to stable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real user-visible bug (garbage/flicker on VT/mode change), measured
  and spec-backed.
- Hardware quirk / timing workaround — allowed by stable-kernel-rules.
- 2-line table change; existing `delay_200_500_e200`; no new
  API/feature.
- Reviewed and applied by panel-edp reviewer Douglas Anderson.
- Both panel IDs and delay helper exist in this 7.3 tree.
- Isolated to two EDID IDs.

AGAINST:
- Not a crash, UAF, or data-corruption bug.
- +150ms backlight delay (maintainer accepted that tradeoff).
- No `Reported-by` from multiple end users / no syzbot.
- Stable list discussion could not be fetched (lore 403).

UNRESOLVED:
- Could not read lore.kernel.org/stable (HTTP 403).
- Could not independently view AUO datasheets (not in-tree).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — reuses existing delay
   struct; maintainer review; author reports waveform data.
2. Fixes a real bug that affects users? **PASS** — garbage/flicker on
   mode change.
3. Important issue? **PASS** as hardware quirk (documented exception);
   severity MEDIUM visual, not CRITICAL crash.
4. Small and contained? **PASS** — 2 lines, one table.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — target rows,
   `delay_200_500_e200`, and enable path all exist here.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk/workaround** (panel power-sequence delay,
analogous to USB delay quirks).

**Step 9.4: MAKE YOUR DECISION**
This tree has the driver, both panel IDs, and the 200ms delay helper.
The change is a small, reviewed T8 quirk that fixes real display garbage
on mode changes. That meets stable rules for this checkout.

Verification:
- [Phase 1] Parsed tags: Reviewed-by/SOB Douglas Anderson; Link to
  msgid; no Fixes/Reported-by/Cc:stable
- [Phase 1] Body: VT-switch garbage; T8 50ms vs ~140ms measured; AUO
  spec T8=200ms
- [Phase 2] Diff: two `EDP_PANEL_ENTRY` pointer swaps in `edp_panels[]`;
  +2/-2
- [Phase 2] `delay_200_500_e50.enable=50`,
  `delay_200_500_e200.enable=200` verified in panel-edp.c
- [Phase 2] `panel_edp_enable()` `msleep(p->desc->delay.enable)`; probe
  copies `detected_panel->delay`
- [Phase 3] `git show 0d40cab391587`: confirmed subject/body/stat
- [Phase 3] `git merge-base --is-ancestor 0d40cab391587 HEAD` → yes
  (already in 7.3-rc4 history; not used as circular “already selected”
  reasoning)
- [Phase 3] `git blame` on the two rows: this commit; origins
  `a70abdd994cb` (v6.1-rc1) and `4c34cdb93ea1` (2026-05, in this tree)
- [Phase 3] `delay_200_500_e200` introduced `f6ff4570e567` (v6.1-rc1
  era)
- [Phase 3] Similar delay-fix pattern: `43113fd4c5f56` and others in the
  same file
- [Phase 4] `b4 dig -c 0d40cab391587`: v2 lore URL; `-a`: v1+v2; `-w`:
  dri-devel + dianders
- [Phase 4] mbox: v1 name-only feedback; v2 Reviewed-by + pushed to drm-
  misc-next; no NAK
- [Phase 4] WebFetch lore/stable: 403 — UNVERIFIED stable-list history
- [Phase 5] Call chain: EDID match → delay table → `panel_edp_enable` on
  modeset; CONFIG_DRM_PANEL_EDP
- [Phase 6] `git describe HEAD` / `make kernelversion`: 7.3.0-rc4; both
  IDs and e200 present
- [Phase 7] MAINTAINERS: Douglas Anderson reviewer for panel-edp.c
- [Phase 8] Failure mode: display garbage, MEDIUM; official rules
  include hardware quirk
- [Phase 9] stable-kernel-rules.rst lines 15–20: quirk is an accepted
  class
- UNVERIFIED: AUO datasheet text; stable@ mailing-list traffic

The fix is small, confined to two EDID entries, and is the usual panel-
edp delay quirk pattern. Benefit outweighs the extra 150ms enable wait
on just those panels.

**YES**

 drivers/gpu/drm/panel/panel-edp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 0da04d75e4e96..614c63e95c357 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1901,7 +1901,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x145c, &delay_200_500_e50, "B116XAB01.4"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x1999, &delay_200_500_e50, "Unknown"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x1e9b, &delay_200_500_e50, "B133UAN02.1"),
-	EDP_PANEL_ENTRY('A', 'U', 'O', 0x1ea5, &delay_200_500_e50, "B116XAK01.6"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x1ea5, &delay_200_500_e200, "B116XAK01.6"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x203d, &delay_200_500_e50, "B140HTN02.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x208d, &delay_200_500_e50, "B140HTN02.1"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x235c, &delay_200_500_e50, "B116XTN02.3"),
@@ -1921,7 +1921,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x635c, &delay_200_500_e50, "B116XAN06.3"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x639c, &delay_200_500_e50, "B140HAK02.7"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x643d, &delay_200_500_e50, "B140HAN06.4"),
-	EDP_PANEL_ENTRY('A', 'U', 'O', 0x67a8, &delay_200_500_e50, "B140XTK02.4"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x67a8, &delay_200_500_e200, "B140XTK02.4"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x723c, &delay_200_500_e50, "B140XTN07.2"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x73aa, &delay_200_500_e50, "B116XTN02.3"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x8594, &delay_200_500_e50, "B133UAN01.0"),
-- 
2.53.0

