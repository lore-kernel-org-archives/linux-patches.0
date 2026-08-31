Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3025D46EF98;
	Mon, 31 Aug 2026 13:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183306; cv=none; b=Mkqv4WSqARIznsR3PKxERmNQJb8VAPvEmOANeTtAXwmRDKGC+TZItb/YVL/0nbB+qPjw++hX/bLl+QO0uU7BliJr8BZL5PxL3YR8W0CVcygzKNvm8EZeddJjt0YWCPxmlahOARd0SSJxuHbM0qPfT8y6MZCsJpFyAI2GatY5AuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183306; c=relaxed/simple;
	bh=IIJJnT5rq24O4eQc43ogTdi47H7LtfQXMj6dsHdaS8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dJGonHryyAOcDAHEohsMH53P7NkND6F4MYDZfYzPfvLar6FGtr95mzoca3b28/UGpo9P4BysbMHkY8sRB9vYAQ4jbJQg/hN6m5633ndybaoHae6YJqwxEjEBq/2q//AYZMfjs7rPQu65Tttoz7Qo++n5kO3K0Mi2Q1IlxpjV3KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b3MsK+SC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b3MsK+SC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868421F000E9;
	Mon, 31 Aug 2026 13:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183303;
	bh=0Pt20Ngb6iAONZKq2t2fx67wf1zvZDiz2qMZDURnkOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b3MsK+SC2yZ1ojLcAL5v8nqFq5d8ppS9KFe2C2Vckps6Jqey+s9Kg5zBUQlvT0NiU
	 p4x8bX+BQ8Afo1uIA8tDH8tWG20GBGeP17JeBxaAH6LLjn6eaCdSU4xZPDnG6JsVr+
	 DwfbPvwxxyv6IVws5ngq1JaUUd6Q56FDykTklrZ64bI5VHUFE1gZM1QBUF7OYbw8Jv
	 YtuwUwRVRDix4MFiA0bh4vVqE4DwPAb0LsUYM4sEcubMzbA19ZWSmjbUQYpb0XXHWu
	 bCq8bBkf4m1lLypQS3QOpAOcSOf6QKNdPFWCzgB+2FB8N+jDn+mwyh/eGSsXZuXmQ5
	 W3cmRpHiO/Gng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: usb-audio: Propagate write errors in generic mixer put callbacks
Date: Mon, 31 Aug 2026 09:21:36 -0400
Message-ID: <20260831133314.4125787-68-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 87a6f2fa6e6c69bb649fa327635a0bd977724603 ]

mixer_ctl_feature_put(), mixer_ctl_procunit_put(), and
mixer_ctl_selector_put() ignore failures from their SET_CUR helper
routines and report the control as changed whenever the requested
value differs from the current one.

If the device rejects the write, userspace still sees success although
the hardware state did not change. Propagate write failures instead,
using filter_error() so ignore_ctl_error keeps the same semantics as
the existing get paths.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260419-usb-write-error-propagation-v1-1-5a3bd4a673ae@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA usb-audio generic mixer put error
propagation

**Local tree:** Linux **6.18.43** (`git describe HEAD` → `v6.18.43`,
Makefile `6.18.43`)

**Upstream commit:** `87a6f2fa6e6c6` (exists in mainline; **not** yet in
this 6.18.y tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ALSA: usb-audio]` `[Propagate]` — propagate SET_CUR write
failures from generic mixer put callbacks to userspace.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Cássio Gabriel `<cassiogabrielcontato@gmail.com>`
  (author)
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA maintainer)
- **Link:** `https://patch.msgid.link/20260419-usb-write-error-
  propagation-v1-1-5a3bd4a673ae@gmail.com` (patch series v1, part 1)
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or
  Cc: stable in the upstream commit message
- Notable pattern: this is **patch 1/3** of a write-error-propagation
  series; parts 2 and 3 are already in this tree (see Phase 6)

### Step 1.3: Body analysis
**Record:**
- **Bug:** `mixer_ctl_feature_put()`, `mixer_ctl_procunit_put()`, and
  `mixer_ctl_selector_put()` call SET_CUR helpers but ignore their
  return values. If the requested value differs from current, they
  report success (`changed=1`) even when the USB write failed.
- **Symptom:** Userspace (alsamixer, PipeWire, PulseAudio) believes a
  mixer control was applied; hardware state is unchanged.
- **Root cause:** Asymmetric error handling — get paths already use
  `filter_error()` on read failures; put paths did not check write
  failures.
- **Version info:** None in message.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit correctness bug fix, not disguised
cleanup. The commit message clearly describes incorrect success
reporting on failed hardware writes.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `sound/usb/mixer.c` only (+13 / -4 lines)
- **Functions modified:** `mixer_ctl_feature_put()`,
  `mixer_ctl_procunit_put()`, `mixer_ctl_selector_put()`
- **Scope:** Single-file, surgical fix (3 call sites, 4 error-check
  blocks)

### Step 2.2: Code flow per hunk

| Hunk | Before | After |
|------|--------|-------|
| `mixer_ctl_feature_put` (per-channel + master) |
`snd_usb_set_cur_mix_value(...)` called, return ignored; `changed=1`
always set | Capture `err`; on `err < 0`, `return filter_error(cval,
err)`; only set `changed=1` on success |
| `mixer_ctl_procunit_put` | `set_cur_ctl_value(...)` ignored; always
`return 1` | Check `err`; propagate via `filter_error()` on failure |
| `mixer_ctl_selector_put` | Same as procunit | Same fix |

**Record:** Affects the normal userspace write path for generic USB
Audio Class mixer controls (feature, processing/extension, selector
units).

### Step 2.3: Bug mechanism
**Record:** **Logic/correctness fix** — ignored error return from USB
control URB path (`snd_usb_mixer_set_ctl_value()` can return `-EINVAL`,
`-ETIMEDOUT`, `-EIO`). Put callbacks violated ALSA semantics by
reporting change on failure.

`filter_error()` preserves `ignore_ctl_error` quirk semantics matching
get paths:

```129:130:sound/usb/mixer.c
#define filter_error(cval, err) \
        ((cval)->head.mixer->ignore_ctl_error ? 0 : (err))
```

On write failure with `ignore_ctl_error`, returning 0 ("no change") is
consistent — hardware did not change.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Mirrors existing get-path pattern and already-
  backported sibling fixes in this tree.
- **Minimal:** Only adds error checks; no structural changes.
- **Regression risk:** Very low. Worst case: userspace now sees errors
  it previously missed — intended behavior.
  `snd_usb_set_cur_mix_value()` only updates cache on success (lines
  528–532), so no new cache corruption.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy put-path code in `mixer_ctl_feature_put` dates to
long-standing code in this tree (blame shows `19eef1d98eeda` as tip-of-
history marker — bulk history import, not the bug introduction). The
asymmetry (get checks errors, put does not) has been present since
generic mixer support existed in this file.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** Same author recently landed a coordinated write-error fix
series in this tree:
- `bfd28b07541e5` — Scarlett enum put (series v1-2, **already in
  6.18.43**)
- `3061b6c114458` — US-16x08 put callbacks (series v1-3, **already in
  6.18.43**)
- `f3e8a6cca15b8` — quirk cache rollback on write errors (related
  follow-up, **already in 6.18.43**)
- `54c448e4f26a7`, `afc90150551dd` — further cache-shadow fixes after
  successful writes

**This commit (series v1-1) is the missing piece** of an already-
partially-backported series.

### Step 3.4: Author context
**Record:** Cássio Gabriel is an active ALSA/usb-audio contributor with
multiple stable backports already merged into this tree by Greg Kroah-
Hartman. Takashi Iwai (maintainer) signed off.

### Step 3.5: Dependencies
**Record:** **Standalone.** No prerequisite commits. Uses existing
`filter_error()` macro and existing SET_CUR helpers. `git apply --check`
of upstream patch against current tree: **applies cleanly**.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c` could not be used (commit not in HEAD).
Lore/patch.msgid.link fetch blocked by Anubis bot protection. Patch
identified as **v1-1** of `usb-write-error-propagation` series from Link
tag. Sibling patches v1-2/v1-3 were backported with explicit `Cc:
stable@vger.kernel.org`.

### Step 4.2: Reviewers
**Record:** UNVERIFIED for full thread. Verified: Takashi Iwai merged
upstream; Greg K-H backported siblings to this tree.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Bug identified by
code review / series author.

### Step 4.4: Series context
**Record:** 3-patch series from 2026-04-19:
1. **v1-1** — generic mixer put (this commit) — **NOT in 6.18.43**
2. **v1-2** — Scarlett — **IN 6.18.43**
3. **v1-3** — US-16x08 — **IN 6.18.43**

### Step 4.5: Stable list history
**Record:** UNVERIFIED (lore blocked). Strong indirect evidence:
siblings explicitly `Cc: stable` and merged by stable maintainer.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `mixer_ctl_feature_put`, `mixer_ctl_procunit_put`,
`mixer_ctl_selector_put`

### Step 5.2: Callers / registration
**Record:** Registered as `.put` handlers in:
- `usb_feature_unit_ctl` / `usb_feature_unit_ctl_ro` — used for standard
  UAC feature-unit mixer controls on essentially all USB audio devices
- `mixer_procunit_ctl` — processing/extension unit controls
- `mixer_selectunit_ctl` — selector unit controls

Created via `snd_ctl_new1()` at lines ~1730, 2207, 2601, 2830 in
`mixer.c`.

### Step 5.3: Callees
**Record:**
- `snd_usb_set_cur_mix_value()` → `snd_usb_mixer_set_ctl_value()` → USB
  control URB (`snd_usb_ctl_msg`)
- `set_cur_ctl_value()` → same URB path
- `filter_error()` for quirk-aware error suppression

### Step 5.4: Reachability
**Record:** Userspace → `SNDRV_CTL_IOCTL_ELEM_WRITE` → ALSA core →
kcontrol `.put` callback. **Reachable by any unprivileged user** with
access to the audio device. Triggered on every mixer
volume/route/selector change for generic UAC controls. Very common path.

### Step 5.5: Similar patterns
**Record:** Scarlett fix in this tree already does the same for
`snd_usb_set_cur_mix_value()`:

```442:444:sound/usb/mixer_scarlett.c
                err = snd_usb_set_cur_mix_value(elem, 0, 0, val);
                if (err < 0)
                        return err;
```

Generic paths were the omission.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **YES.** All three functions in `sound/usb/mixer.c` ignore
write return values at lines 1472, 1487, 2353, 2717. Bug is long-
standing in this tree.

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` of upstream
`87a6f2fa6e6c6` patch succeeded with no conflicts. Line numbers differ
slightly from upstream (expected for stable tree) but hunks match.

### Step 6.3: Related fixes already present?
**Record:** Siblings v1-2 and v1-3 backported; **this generic fix is
NOT**. Leaving it out creates inconsistent behavior: device-specific put
callbacks report errors, generic ones still lie to userspace.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **sound/usb** (ALSA USB audio driver) — **IMPORTANT**. USB
audio is widely used on desktops, laptops, and pro-audio gear.

### Step 7.2: Activity
**Record:** Actively maintained; multiple usb-audio stable fixes landed
recently in this tree (write-error series, UAF fixes, quirk updates).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** All users of USB audio devices using standard UAC mixer
controls (feature units, selector units, processing units) — a large
fraction of USB sound cards, headsets, and DACs.

### Step 8.2: Trigger conditions
**Record:** Any mixer control write where the device rejects or fails
the SET_CUR URB (device disconnect mid-write, USB STALL, timeout, power-
management race, flaky firmware). Common during hot-unplug or device
errors.

### Step 8.3: Failure severity
**Record:** Userspace reports success when hardware unchanged →
volume/routing UI out of sync with actual audio path. **Severity:
MEDIUM** (not kernel oops/UAF, but real functional incorrectness;
qualifies as "oh, that's not good" per stable rules). No kernel crash or
data corruption.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for correctness — fixes the broadest code path in
  the series (generic mixer, all devices); completes an already-started
  stable backport series.
- **Risk:** VERY LOW — 13-line additive error checks, matches proven
  pattern.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: false success to userspace on failed hardware writes
- Upstream commit `87a6f2fa6e6c6` exists in mainline (stable rule
  satisfied)
- Tiny, obviously correct, applies cleanly
- Affects common userspace path for all generic USB mixer controls
- Series parts 2 and 3 already backported to **this** 6.18.43 tree with
  `Cc: stable`
- ALSA maintainer (Iwai) signed off; stable maintainer (Greg K-H) merged
  siblings
- Completes incomplete backport of a coordinated fix series

**AGAINST backport:**
- Not a crash/security/data-corruption issue
- No user bug report or fuzzer finding
- Upstream commit lacks explicit `Cc: stable` (siblings have it)

**Unresolved:**
- Full lore review thread (blocked by bot protection)
- No independent Tested-by

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors get-path and sibling
   fixes; maintainer-reviewed
2. Fixes real bug affecting users? **PASS** — userspace gets incorrect
   success on write failure
3. Important issue? **PASS (MEDIUM)** — functional correctness on
   widely-used path; "oh, that's not good"
4. Small and contained? **PASS** — 13 lines, one file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision rationale

This tree already backported two of three patches from the same April
2026 write-error-propagation series. The generic mixer fix is the
broadest of the three — it covers standard UAC controls used by nearly
every USB audio device — yet it is the only one still missing. Leaving
it out means Scarlett and US-16x08 users get correct error reporting
while everyone else on generic mixer controls still gets silent write
failures.

The fix is minimal, upstream-merged, applies cleanly, and follows
established patterns already present in this tree.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  `git show 87a6f2fa6e6c6`
- [Phase 2] Diff analysis: 3 functions, 4 error-check sites, +13/-4
  lines in `sound/usb/mixer.c`
- [Phase 2] Read `filter_error`, `snd_usb_set_cur_mix_value`,
  `set_cur_ctl_value` — cache only updated on success
- [Phase 3] `git blame` on lines 1470–1490: long-standing code
- [Phase 3] Found upstream commit `87a6f2fa6e6c6` adjacent to siblings
  `0f25cf1f02e3`, `3c06aec8abda6`
- [Phase 3] Siblings `bfd28b07541e5`, `3061b6c114458` confirmed in
  6.18.43 with `Cc: stable`
- [Phase 3] `git merge-base --is-ancestor 87a6f2fa6e6c6 HEAD` → exit 1
  (fix NOT in tree)
- [Phase 3] `git apply --check` of upstream patch → applies cleanly
- [Phase 4] UNVERIFIED: lore/patch.msgid.link blocked by Anubis; `b4 dig
  -c` N/A (commit not in HEAD)
- [Phase 4] Verified series structure via upstream commit ordering and
  sibling Link URLs
- [Phase 5] Grep: three `.put` handlers registered via `snd_ctl_new1`
  for feature/procunit/selector units
- [Phase 5] Read `scarlett_ctl_enum_put` — same error-propagation
  pattern already backported
- [Phase 6] `git describe HEAD` → v6.18.43; buggy code confirmed at
  lines 1472, 1487, 2353, 2717
- [Phase 6] No duplicate fix found in tree
- [Phase 8] Failure mode: false success to userspace, severity MEDIUM
- [Phase 8] Trigger: any failed SET_CUR on generic mixer controls,
  reachable from userspace

**YES**

 sound/usb/mixer.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 0765250f3a56d..871abd957c241 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1469,7 +1469,10 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
 				return -EINVAL;
 			val = get_abs_value(cval, val);
 			if (oval != val) {
-				snd_usb_set_cur_mix_value(cval, c + 1, cnt, val);
+				err = snd_usb_set_cur_mix_value(cval, c + 1,
+								cnt, val);
+				if (err < 0)
+					return filter_error(cval, err);
 				changed = 1;
 			}
 			cnt++;
@@ -1484,7 +1487,9 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
 			return -EINVAL;
 		val = get_abs_value(cval, val);
 		if (val != oval) {
-			snd_usb_set_cur_mix_value(cval, 0, 0, val);
+			err = snd_usb_set_cur_mix_value(cval, 0, 0, val);
+			if (err < 0)
+				return filter_error(cval, err);
 			changed = 1;
 		}
 	}
@@ -2350,7 +2355,9 @@ static int mixer_ctl_procunit_put(struct snd_kcontrol *kcontrol,
 		return -EINVAL;
 	val = get_abs_value(cval, val);
 	if (val != oval) {
-		set_cur_ctl_value(cval, cval->control << 8, val);
+		err = set_cur_ctl_value(cval, cval->control << 8, val);
+		if (err < 0)
+			return filter_error(cval, err);
 		return 1;
 	}
 	return 0;
@@ -2714,7 +2721,9 @@ static int mixer_ctl_selector_put(struct snd_kcontrol *kcontrol,
 		return -EINVAL;
 	val = get_abs_value(cval, val);
 	if (val != oval) {
-		set_cur_ctl_value(cval, cval->control << 8, val);
+		err = set_cur_ctl_value(cval, cval->control << 8, val);
+		if (err < 0)
+			return filter_error(cval, err);
 		return 1;
 	}
 	return 0;
-- 
2.53.0

