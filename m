Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C3C4B26E0;
	Mon, 31 Aug 2026 13:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184287; cv=none; b=ShkWxTrUoeWJ46C8Dgg/QSD2fecVaM5FGtxQeBfOG4YwcfGxlfHmE2caErMt3qlZqqGc4ibiAFYyMhAYeAWyv2w8D+MfyPXAi5Jry+yMVnn2Enih3eh7sMOXtqQcg28fW+3yhPblL28FpvI52rTPjq3ju6r6Xu/xIrab7YxfHEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184287; c=relaxed/simple;
	bh=L3h44K28RxRDCXPTqoVMMS/eE84caZ2gqB2JXtvtrIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bC/jjqualkk8qFBPYn2VSldPKhN4BDK9Fsvww6kokyUM/AXWkv5OoHAe2ezBcLapAXjuTu+8qTZacIKyKYQn1S5xKDLnSbVDDfV9izyV72uU0myIlDwuz0axj4if97zryRnugBpH2/hkGNeM+k0kbwU70MJyMADSqnrp6n9TBf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YxPe1VzG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YxPe1VzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8135B1F00A3E;
	Mon, 31 Aug 2026 13:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184284;
	bh=gYJ+8ErtlC4Y7RCEVbiGQklUCpLaTHQjEs8L+d++bJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YxPe1VzGTs0HfNpujDQVIPL8TWDmNmUtO9HU1CmIMV3arJqj+nSr9g7RQZshSSzEQ
	 VXGwFX3Eoe8w3qA/XHvMerGUOu4D0J1d4ba4gD0gqR96nxv3zu8Ew7xQrS4k8qbXsD
	 V99+aFVu+wT7jTH/j4L6OfLvVR+0YvcDICvDxH6WsDY9oN6YLA3bIdtDQq0k0bbK6S
	 OycZrRiWMX7wdslySaWZcKy4oZh8RNnVnevokWcRtnlWc6+HKHGD/ZwEOIMTJENYvm
	 J+XgUKXK2mmb5M7Ff9DTlmDfNGrDlQqkmGqwdATdYmhNsZuIEq/9vyTadQF7dqjTa0
	 1FgBDFJuruJ4A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sergey Lebedev <lsa.uz@pm.me>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oder_chiou@realtek.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ASoC: rt1320: run the initialisation preset on the first hardware init
Date: Mon, 31 Aug 2026 09:30:29 -0400
Message-ID: <20260831133314.4125787-601-sashal@kernel.org>
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

From: Sergey Lebedev <lsa.uz@pm.me>

[ Upstream commit 9b30521074f01aff856f539c1241a48342b69f7c ]

rt1320_io_init() applies the vendor initialisation preset only when the
amplifier's SDCA function status has FUNCTION_NEEDS_INITIALIZATION set:

	if ((amp_func_status & FUNCTION_NEEDS_INITIALIZATION)) {

Its two sibling drivers guard the same write differently, also running
the preset on the first hardware init:

  rt712-sdca.c:  if ((amp_func_status & FUNCTION_NEEDS_INITIALIZATION) ||
                     (!rt712->first_hw_init)) {
  rt722-sdca.c:  if ((amp_func_status & FUNCTION_NEEDS_INITIALIZATION) ||
                     (!rt722->first_hw_init)) {

On the Microsoft Surface Pro 11 (Intel) the RT1320 never sets that bit.
Its function status reads back 0x41 on every boot, cold or warm:

  rt1320-sdca sdw:0:0:025d:1320:01: rt1320_io_init amp func_status=0x41

which is NEWLY_ATTACHED | FUNCTION_HAS_BEEN_RESET: the function reports
that it has been reset and does not consider itself in need of
initialisation. Bit 5 is never set, so the preset never runs,
rt1320_vc_preset() and the MCU patch load are skipped, and the amplifier
is left unprogrammed. rt712 and rt722 would have run it via their
first_hw_init fallback.

Add the same fallback. With it rt1320_vc_preset() executes and the
amplifier reports RT1320_KR0_INT_READY=0x1f where previously it did not.

Signed-off-by: Sergey Lebedev <lsa.uz@pm.me>
Link: https://patch.msgid.link/20260804225853.31585-2-lsa.uz@pm.me
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[ASoC: rt1320]` `[run]` — run the vendor initialization
preset on first hardware init.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Sergey Lebedev `<lsa.uz@pm.me>` (author)
- **Link:** https://patch.msgid.link/20260804225853.31585-2-lsa.uz@pm.me
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (ASoC maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`
- Notable: maintainer sign-off; real hardware report (Surface Pro 11);
  no syzbot/fuzzer involvement

### Step 1.3: Body analysis
**Record:**
- **Bug:** `rt1320_io_init()` only runs the vendor preset when
  `FUNCTION_NEEDS_INITIALIZATION` is set; on Surface Pro 11 RT1320
  reports `0x41` (`NEWLY_ATTACHED | FUNCTION_HAS_BEEN_RESET`), never bit
  5
- **Symptom:** `rt1320_vc_preset()` and MCU patch load are skipped;
  amplifier stays unprogrammed; speakers silent
- **Root cause:** RT1320 lacks the `first_hw_init` fallback that sibling
  drivers `rt712-sdca` and `rt722-sdca` already use
- **Version info:** Surface Pro 11 (Intel, Lunar Lake); tested on
  7.1.0-rc7 per cover letter

### Step 1.4: Hidden bug fix?
**Record:** Yes — not disguised cleanup. This is a clear
logic/correctness fix restoring driver behavior that existed at
introduction and was accidentally dropped.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `sound/soc/codecs/rt1320-sdw.c` (+1 / -1)
- **Function:** `rt1320_io_init()`
- **Scope:** Single-file, one-line surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** Preset runs only if `amp_func_status &
  FUNCTION_NEEDS_INITIALIZATION`
- **After:** Also runs when `!rt1320->first_hw_init` (first hardware
  init)
- **Path:** Normal probe via `rt1320_update_status()` →
  `rt1320_io_init()` on `SDW_SLAVE_ATTACHED`

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness (hardware workaround)
- **Mechanism:** Some RT1320 parts never set
  `FUNCTION_NEEDS_INITIALIZATION`; without the `first_hw_init` fallback,
  `rt1320_vc_preset()` / `rt1320_load_mcu_patch()` never execute and the
  amp is left uninitialized

### Step 2.4: Fix quality
**Record:**
- Obviously correct: matches `rt712-sdca.c` and `rt722-sdca.c`, and
  restores original `rt1320` behavior from `bad0a07a7e61a`
- Minimal, no unrelated changes
- **Regression risk:** Very low — restores long-standing pattern; only
  affects first init

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- Buggy condition from `f465d10cd7318` (Sep 2, 2024, "ASoC: rt1320: Add
  support for version C")
- That commit **removed** `|| (!rt1320->first_hw_init)` that existed
  since `bad0a07a7e61a` (May 21, 2024)
- Regression present since v6.12 (first tag containing `f465d10`)

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Regression commit is `f465d10cd7318`,
confirmed in this tree.

### Step 3.3: Related file history
**Record:**
- Part of a 3-patch series: "ASoC: fix audio on the Microsoft Surface
  Pro 11 (Intel)"
- Patches 2/3 and 3/3 address phantom ACPI entries; **this patch is
  standalone** for RT1320 init
- Recent rt1320 fixes in tree: mute issue, speaker noise, RT1321 support
  — unrelated

### Step 3.4: Author context
**Record:** Sergey Lebedev — Surface Pro 11 reporter/fixer; no prior
sound commits in this tree. Mark Brown committed upstream.

### Step 3.5: Dependencies
**Record:** None for this change. `first_hw_init` already exists in
`rt1320_sdw_priv` and is initialized to `false` at probe. Applies
standalone.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:**
- **URL:** https://patch.msgid.link/20260804225853.31585-2-lsa.uz@pm.me
- **Series:** v1 only (no v2/v3)
- Cover letter: full Surface Pro 11 audio needs all 3 patches; patch 1/3
  is codec-specific and one line
- No explicit stable nomination in thread
- No NAKs found in mbox

### Step 4.2: Reviewers
**Record:** CC'd to Mark Brown, Liam Girdwood, Jaroslav Kysela, Takashi
Iwai, Realtek/Intel SOF maintainers, `linux-sound@`, `sound-open-
firmware@`, `linux-kernel@`

### Step 4.3: Bug report
**Record:** Hardware testing on Surface Pro 11 for Business (Intel Core
Ultra 7 268V, Lunar Lake). Symptom: silent speakers despite successful
probe. Severity: complete audio failure on affected hardware.

### Step 4.4: Related patches
**Record:** Patches 2/3 (`sdw_utils`) and 3/3 (SOF Intel HDA amp
indexing) are separate; needed for full SP11 fix but not prerequisites
for this one-line driver fix.

### Step 4.5: Stable list
**Record:** No stable-specific discussion found in mbox.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `rt1320_io_init()`, `rt1320_vc_preset()`,
`rt1320_update_status()`

### Step 5.2: Callers
**Record:**
- `rt1320_update_status()` — SoundWire slave status callback
  (`.update_status` in `rt1320_sdw_slave_driver`)
- Triggered on `SDW_SLAVE_ATTACHED` during SoundWire enumeration
- Common device probe path for RT1320-equipped Intel SOF machines

### Step 5.3: Callees
**Record:** `rt1320_vab_preset()`, `rt1320_vc_preset()`,
`rt1321_preset()`, `regmap_read/write`, `rt1320_load_mcu_patch()`
(inside `rt1320_vc_preset()`)

### Step 5.4: Reachability
**Record:** Reachable on every boot for RT1320 SoundWire devices when
`CONFIG_SND_SOC_RT1320_SDW` is enabled (implied by Intel SOF ACPI
matches). Not userspace-triggered, but affects all audio on affected
machines.

### Step 5.5: Similar patterns
**Record:** Identical `first_hw_init` fallback in `rt712-sdca.c:1837`
and `rt722-sdca.c:1400`. Original `rt1320` driver at
`bad0a07a7e61a:1699` had the same pattern.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy code exists?
**Record:**
- **Tree:** `stable/linux-6.18.y` at `v6.18.44`
- **Buggy line present:** `sound/soc/codecs/rt1320-sdw.c:941` — `if
  ((amp_func_status & FUNCTION_NEEDS_INITIALIZATION))`
- RT1320 driver (`bad0a07a7e61a`) and version C support
  (`f465d10cd7318`) are both ancestors of HEAD
- Fix (`9b30521074f01` / `4ff3319b43e07`) is **not** in this tree

### Step 6.2: Backport complications
**Record:** Clean one-line apply at line 941; no conflicts expected.
Stable tree file matches autosel backport diff base.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix found. Other rt1320 fixes (mute, noise)
address different issues.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem criticality
**Record:** `sound/soc/codecs` — ASoC codec driver. **IMPORTANT** for
Intel SOF + SoundWire laptop users (LNL/PTL/ARL platforms with RT1320).

### Step 7.2: Subsystem activity
**Record:** Actively maintained; multiple rt1320 ACPI machine entries
and driver fixes in 6.18.y.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users with RT1320 amplifiers on Intel SOF SoundWire
platforms where the chip does not set `FUNCTION_NEEDS_INITIALIZATION` —
confirmed on Surface Pro 11; potentially any RT1320 since the v6.12
regression. Config-specific: `CONFIG_SND_SOC_RT1320_SDW`.

### Step 8.2: Trigger conditions
**Record:** Every cold/warm boot on affected hardware. Not timing-
dependent. Unprivileged users cannot trigger directly, but all users on
affected machines lose speaker output.

### Step 8.3: Failure mode severity
**Record:** Amplifier never initialized → **silent speakers** (complete
audio failure on affected machines). Severity: **HIGH** for affected
hardware (not a kernel crash, but total loss of primary audio output).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for RT1320 users — restores working audio
- **Risk:** VERY LOW — one-line restoration of original + sibling-driver
  pattern
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real regression introduced by `f465d10` (removed `first_hw_init`
  fallback present since driver introduction)
- Confirmed hardware impact (Surface Pro 11 — silent speakers)
- One-line fix matching proven rt712/rt722 pattern
- Self-contained, no dependencies
- ASoC maintainer sign-off
- RT1320 driver and platform ACPI support present in 6.18.y

**AGAINST backport:**
- Full Surface Pro 11 audio may also need patches 2/3 and 3/3 (separate
  commits)
- No explicit stable nomination or `Fixes:` tag (expected for manual
  review)

**Unresolved:** Whether other RT1320 platforms besides Surface Pro 11
hit this path (likely, given regression since v6.12).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — restores original logic;
   tested on real hardware per cover letter
2. Fixes a real bug? **PASS** — amplifier left unprogrammed
3. Important issue? **PASS** — complete audio failure on affected
   laptops
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features/APIs? **PASS** — behavior restoration only
6. Can apply to local tree? **PASS** — buggy code present, clean apply

### Step 9.3: Exception category
**Record:** Hardware workaround / quirk — RT1320 does not set
`FUNCTION_NEEDS_INITIALIZATION`; driver must initialize on first hw init
regardless.

### Step 9.4: Decision rationale

For **linux-6.18.y** (`v6.18.44`): this is a regression fix restoring
driver behavior accidentally removed in v6.12. The RT1320 driver, the
buggy code, and affected platform support are all present. The fix is
one line, matches sibling drivers, and fixes silent speakers on real
hardware. It is self-contained and low risk.

---

## Verification

- [Phase 1] Parsed subject, tags, body from commit `9b30521074f01` /
  `4ff3319b43e07`
- [Phase 2] Diff: 1-line change in `rt1320_io_init()` at line 941
- [Phase 3] `git blame`: regression in `f465d10cd7318`; original
  fallback in `bad0a07a7e61a`
- [Phase 3] `git show f465d10`: confirmed removal of `||
  (!rt1320->first_hw_init)`
- [Phase 3] `git show bad0a07a7e61a`: confirmed original driver had
  fallback
- [Phase 3] `git merge-base --is-ancestor`: driver, version C, and fix
  presence verified
- [Phase 4] `b4 dig -c 4ff3319b43e07`: found lore thread; v1 series;
  cover letter read from mbox
- [Phase 4] `b4 dig -w`: Mark Brown and sound maintainers CC'd
- [Phase 4] No stable/Reviewed-by/Tested-by in mbox
- [Phase 5] `grep rt1320_io_init`: called from `rt1320_update_status()`
  on attach
- [Phase 5] Compared with `rt712-sdca.c:1837` and `rt722-sdca.c:1400`
  patterns
- [Phase 6] `git describe HEAD`: `v6.18.44` on `stable/linux-6.18.y`
- [Phase 6] Buggy code at `rt1320-sdw.c:941`; fix not in tree
- [Phase 6] `git show 4ff3319b43e07 -p`: clean apply to current tree
- [Phase 7] RT1320 ACPI matches present in `soc-acpi-intel-lnl-match.c`,
  `ptl-match.c`, `arl-match.c`
- [Phase 8] Failure mode: unprogrammed amplifier → silent speakers

**YES**The analysis is complete for **linux-6.18.y** (`v6.18.44`).

This is a one-line regression fix: `f465d10` ("Add support for version
C") dropped the `first_hw_init` fallback that existed since the RT1320
driver was introduced. On hardware like the Surface Pro 11, the amp
never sets `FUNCTION_NEEDS_INITIALIZATION`, so the preset and MCU patch
load are skipped and speakers stay silent. The fix restores the same
pattern already used in `rt712-sdca` and `rt722-sdca`.

The buggy code is present in this tree, the patch applies cleanly, and
it is self-contained (patches 2/3 and 3/3 in the series are separate
Surface Pro 11 ACPI issues).

**YES**

 sound/soc/codecs/rt1320-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt1320-sdw.c b/sound/soc/codecs/rt1320-sdw.c
index e1bd991a823a4..a08e20bfe9c86 100644
--- a/sound/soc/codecs/rt1320-sdw.c
+++ b/sound/soc/codecs/rt1320-sdw.c
@@ -938,7 +938,7 @@ static int rt1320_io_init(struct device *dev, struct sdw_slave *slave)
 	dev_dbg(dev, "%s amp func_status=0x%x\n", __func__, amp_func_status);
 
 	/* initialization write */
-	if ((amp_func_status & FUNCTION_NEEDS_INITIALIZATION)) {
+	if ((amp_func_status & FUNCTION_NEEDS_INITIALIZATION) || !rt1320->first_hw_init) {
 		switch (rt1320->dev_id) {
 		case RT1320_DEV_ID:
 			if (rt1320->version_id < RT1320_VC)
-- 
2.53.0

