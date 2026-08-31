Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AA04483AB;
	Mon, 31 Aug 2026 13:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183247; cv=none; b=GipukJ/dMCjiUaMJytmP3+jYaJhAXvSj0VyJbyAlvVnlbV7xA3uXlVpd+OGBej7oGAuLUava1t6vTkzMUbc07cJecWKtg1BshB/Bjkh0j1sT6LKFOor/BqibVA396K9s30L9m3pfrg3WseOyYsyZCEQ8wEnqjvIz7v7LDGA4x/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183247; c=relaxed/simple;
	bh=6t5XOUyIMbWGOOvlv5e/onn57DhshHv9bNX/QZz896I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tHePmVVWgLgDL78vTZSVF5WbUfQ6ux9cu1Ho9ZbOR+NCmu1/G6vvkJDA6wNuj3AmsFIHO9v86ic+E45d8XkwSOutb3KtRV88YYJZZPvTXPYEbvC1PM/0XMdtI/Cc8YdKbEpTcg7nOcZVnNWHVcVcOed7aaEblmlEeghGVDGehw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g2jpei/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g2jpei/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05821F00A3D;
	Mon, 31 Aug 2026 13:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183245;
	bh=bGLi8cWVQ5WvUPoi1yj2jO7mi90RrKqBFc6uQi+9uCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2jpei/jVoUq4Gab9WfQng9DQ2p7jmIUUYYfSrhVDT7ePW4pIhaSfkYqxYnGmY3Rk
	 vorcEh/u8cwYhrX1Rxn8t7u7T9KS6fzwaLMHQnj9t8XMUrEclWbyjJHK0y7gtqihnt
	 Mpaw8drDHm6EjZrxUFLk/8Cs7RGi12sRQTazPHmYKfJ1wwKaJTmGg6tvLcsQlJk1n2
	 xLrxYZQ7sl1QJc1vvzVotMGuuuF7GBKbse3FN3NCn61hH1NoDmTduWhza+wfdbAfXV
	 01fICx/C+ScMdogIoh+x7qDRE3BAxzZ7DcTl0iblqq0s8OsGhZRF0bHqUpu6m+PFl+
	 dnyj5RCXHom8g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ruoyu Wang <ruoyuw560@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: es18xx: check control allocation before private data setup
Date: Mon, 31 Aug 2026 09:21:00 -0400
Message-ID: <20260831133314.4125787-32-sashal@kernel.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 422e42b7c2b882ba1d16d4afc8891bcea7c4de93 ]

snd_es18xx_mixer() creates controls with snd_ctl_new1() and then stores
bookkeeping pointers or sets private_free before calling snd_ctl_add().
snd_ctl_new1() can return NULL on allocation failure, so those writes
can dereference a NULL control pointer.

Check the returned control pointers before using them and return -ENOMEM
on allocation failure.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://patch.msgid.link/20260607074219.3-1-ruoyuw560@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA: es18xx: check control allocation
before private data setup

**Local tree:** `v6.18.44` (Makefile: 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[ALSA: es18xx]` `[check]` — Add NULL checks after
`snd_ctl_new1()` before using returned control pointers in
`snd_es18xx_mixer()`.

### Step 1.2: Parse all commit message tags
**Record:**
- **Signed-off-by:** Ruoyu Wang `<ruoyuw560@gmail.com>` (author)
- **Link:**
  https://patch.msgid.link/20260607074219.3-1-ruoyuw560@gmail.com
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA maintainer
  merge)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or `Reviewed-by:` tags
- Notable: absence of `Cc: stable` is expected for manual review; not a
  negative signal

### Step 1.3: Analyze commit body text
**Record:**
- **Bug:** `snd_es18xx_mixer()` calls `snd_ctl_new1()`, then stores
  bookkeeping pointers (`chip->master_volume`, etc.) and sets
  `kctl->private_free` before calling `snd_ctl_add()`. If allocation
  fails, `snd_ctl_new1()` returns NULL and those writes dereference
  NULL.
- **Symptom:** NULL pointer dereference (kernel oops) during driver
  probe/mixer setup.
- **Root cause:** Missing NULL check on `snd_ctl_new1()` return value in
  two loops that use `kctl` before `snd_ctl_add()`.
- **Fix:** Check `kctl` after allocation; return `-ENOMEM` on failure.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit NULL-dereference bug
fix, not cleanup or optimization.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `sound/isa/es18xx.c` only (+4 lines, 0 removed)
- **Functions modified:** `snd_es18xx_mixer()`
- **Scope:** Single-file, surgical fix (2 identical NULL-check
  additions)

### Step 2.2: Understand the code flow change

**Hunk 1 (base_controls loop, ~line 1764):**
- **Before:** `kctl = snd_ctl_new1(...)` → if `ES18XX_HWV`, assign
  `chip->master_volume`/`master_switch` and set `kctl->private_free` →
  `snd_ctl_add(card, kctl)`
- **After:** Same, but return `-ENOMEM` immediately if `kctl` is NULL
- **Path affected:** Mixer initialization for HWV-capable chips during
  probe

**Hunk 2 (hw_volume_controls loop, ~line 1825):**
- **Before:** `kctl = snd_ctl_new1(...)` → assign
  `chip->hw_volume`/`hw_switch`, set `kctl->private_free` →
  `snd_ctl_add()`
- **After:** Same, with NULL check added
- **Path affected:** Hardware volume control setup during probe

**Record:** Both hunks fix error-path NULL dereference before
`snd_ctl_add()` is reached.

### Step 2.3: Identify the bug mechanism
**Record:**
- **Category:** NULL pointer dereference (memory safety)
- **Mechanism:** `snd_ctl_new1()` documented to return NULL on
  allocation failure (`sound/core/control.c` line 258). In two loops,
  `kctl` is dereferenced (`kctl->private_free`, pointer assignments)
  before `snd_ctl_add()`, which does handle NULL but is never reached.
  Other `snd_ctl_new1()` calls in the same function pass the result
  directly to `snd_ctl_add()` and are already safe.

### Step 2.4: Assess fix quality
**Record:**
- Fix is obviously correct and minimal
- Matches the established pattern in `sound/pci/es1938.c` (lines
  1657–1659), which already has identical NULL checks
- No regression risk: only adds early return on allocation failure
- No API changes, no locking changes

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
**Record:**
- Buggy pattern present since `1da177e4c3f41` (Linux 2.6.12-rc2) —
  original import of es18xx driver
- HWV bookkeeping (`master_volume = kctl`, `private_free`) dates to the
  same original commit
- Bug has existed across all kernel versions including this tree

### Step 3.2: Follow Fixes: tag
**Record:** No `Fixes:` tag present. Not applicable.

### Step 3.3: Check file history for related changes
**Record:**
- Recent es18xx commits are cleanups (guard(), strscpy, spelling) —
  unrelated
- **Direct precedent:** `9e53e99b6fa3c` — "ALSA: es1938: check
  snd_ctl_new1() return value" — identical fix for sibling ESS driver,
  already in this tree as a stable backport (`Cc:
  stable@vger.kernel.org`, `Signed-off-by: Greg Kroah-Hartman`)
- Standalone fix; v2 resend notes other v1 patches were already in for-
  next

### Step 3.4: Check author's other commits
**Record:** Ruoyu Wang is an active contributor with multiple similar
NULL-check / allocation-safety fixes across subsystems (mtk, mt76, nfp,
RDMA, etc.). Not the es18xx maintainer, but fixes follow established
ALSA patterns.

### Step 3.5: Check for dependent/prerequisite commits
**Record:** No dependencies. Self-contained 4-line fix. Applies cleanly
to v6.18.44 (`git apply --check` succeeded).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Find original patch discussion
**Record:**
- **v1:** https://lkml.iu.edu/2606.0/12742.html (Jun 6, 2026)
- **v2:** https://lkml.iu.edu/2606.0/12836.html (Jun 7, 2026) — rebased
  on sound.git for-next
- **Maintainer reply:** https://lkml.iu.edu/2606.0/12904.html — Takashi
  Iwai: "Applied to for-next branch now. Thanks."
- No NAKs or objections found
- No explicit stable nomination in thread, but identical es1938 fix was
  stable-nominated

### Step 4.2: Check who reviewed the patch
**Record:** (from v2 headers via openwall mirror)
- **To:** Takashi Iwai, Jaroslav Kysela
- **Cc:** linux-sound@, linux-kernel@, alsa-devel@
- Takashi Iwai (ALSA maintainer) applied the patch

### Step 4.3: Search for bug report
**Record:** No user bug report, syzbot report, or sanitizer report. Bug
identified by code review (static analysis of allocation pattern).
Trigger requires ENOMEM during probe — rare but real.

### Step 4.4: Check for related patches and series
**Record:** v2 notes other v1 patches (for other drivers) were already
in for-next. This es18xx patch is standalone.

### Step 4.5: Check stable mailing list history
**Record:** No stable-list discussion found for this specific commit.
The es1938 sibling fix (`9e53e99b6fa3c`) was explicitly nominated for
stable and merged by Greg K-H.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Identify key functions
**Record:** `snd_es18xx_mixer()` — only function modified

### Step 5.2: Trace callers
**Record:**
- `snd_es18xx_mixer()` called from `snd_audiodrive_probe()` (line 2071)
- `snd_audiodrive_probe()` called from PnP probe paths
  (`snd_audiodrive_pnp_detect`, `snd_audiodrive_pnpc_detect`) and module
  init
- **Context:** Driver probe during module load / PnP enumeration —
  standard device initialization path

### Step 5.3: Trace callees
**Record:** `snd_ctl_new1()` (can return NULL), `snd_ctl_add()` (handles
NULL safely at line 515–516 of `sound/core/control.c`, but never reached
in buggy paths)

### Step 5.4: Follow call chain (bug reachability)
**Record:**
```
module load / PnP probe → snd_audiodrive_probe() → snd_es18xx_mixer() →
snd_ctl_new1() [ENOMEM] → NULL deref
```
- Reachable during driver probe on systems with ESS ES18xx hardware
- Bug only in HWV code paths (`chip->caps & ES18XX_HWV`), set for chip
  versions 0x1869 and 0x1879
- Trigger requires memory allocation failure — uncommon but possible
  under memory pressure

### Step 5.5: Search for similar patterns
**Record:** Identical pattern already fixed in `sound/pci/es1938.c`.
Multiple other ALSA drivers check `if (!kctl)` after `snd_ctl_new1()`.
es18xx was simply missed.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: Does the buggy code exist in this tree?
**Record:** **YES.** At lines 1764–1773 and 1825–1830 in
`sound/isa/es18xx.c`, the code uses `kctl` without NULL check before
`snd_ctl_add()`. Fix is not yet present in v6.18.44.

### Step 6.2: Check for backport complications
**Record:** **Clean apply** — `git apply --check` succeeded with zero
conflicts. No refactoring needed.

### Step 6.3: Check if related fixes are already here
**Record:** The es1938 sibling fix (`9e53e99b6fa3c`) is already in this
tree. No equivalent es18xx fix present.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Identify subsystem and criticality
**Record:** **ALSA / ISA sound driver** (`CONFIG_SND_ES18XX`) —
**PERIPHERAL** subsystem. Legacy ESS AudioDrive hardware (ISA/PnP).
Small user base but real hardware still exists.

### Step 7.2: Assess subsystem activity
**Record:** es18xx driver receives periodic maintenance (guard(),
strscpy, constification) but is mature/legacy code. Bug predates all
recent changes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with `CONFIG_SND_ES18XX` enabled and ESS ES18xx
hardware with HWV capability (chip versions 0x1869, 0x1879). Narrow but
real population.

### Step 8.2: Trigger conditions
**Record:**
- **When:** Driver probe, during mixer control creation
- **Condition:** `snd_ctl_new1()` allocation failure (ENOMEM) in HWV
  code paths
- **Likelihood:** Low (requires memory pressure during probe), but probe
  is a standard path
- **Unprivileged trigger:** No — requires hardware present and driver
  loading; not a syscall-level attack vector

### Step 8.3: Failure mode severity
**Record:**
- **Failure:** NULL pointer dereference → kernel oops during module
  probe
- **Severity:** **HIGH** when triggered (kernel crash during driver
  load); **LOW** likelihood of trigger

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** Prevents kernel oops on allocation failure; aligns es18xx
  with es1938 and ALSA conventions
- **Risk:** Very low — 4 lines, no behavior change on success path
- **Ratio:** Clear benefit outweighs risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Compile the evidence

**FOR backporting:**
- Real NULL pointer dereference bug in driver probe path
- Small (4 lines), obviously correct fix
- Identical fix for es1938 sibling driver already backported to stable
  in this tree
- Bug present since 2.6.12; code exists in v6.18.44
- Applies cleanly
- ALSA maintainer (Takashi Iwai) applied to for-next
- Follows established ALSA pattern (`if (!kctl) return -ENOMEM`)

**AGAINST backporting:**
- Legacy ISA driver with small user base
- Trigger requires ENOMEM during probe (rare)
- No user reports or fuzzer findings
- Only affects HWV-capable chip variants

**Unresolved:** None material to the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — pattern proven in es1938;
   maintainer merged
2. Fixes a real bug? **PASS** — documented NULL deref on allocation
   failure
3. Important issue? **PASS** — kernel oops (HIGH severity, low
   likelihood)
4. Small and contained? **PASS** — 4 lines, 1 file
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** Not applicable (standard bug fix, not device ID/quirk/build
fix).

### Step 9.4: Decision rationale

This commit fixes a genuine NULL pointer dereference in
`snd_es18xx_mixer()` where `snd_ctl_new1()` return values are used
before being validated. The identical pattern was already fixed and
backported for the closely related `es1938` driver in this same tree.
The fix is minimal, follows ALSA conventions, applies cleanly to
v6.18.44, and prevents a kernel oops during driver probe under memory
pressure. While the affected hardware is legacy and the trigger is
uncommon, stable trees routinely accept such probe-path NULL-deref fixes
— especially when a direct sibling precedent exists.

---

## Verification

- [Phase 1] `git describe HEAD` → v6.18.44; parsed subject, tags, body
  from provided commit message
- [Phase 1] Web search → found v1/v2 on lkml.iu.edu and maintainer
  acceptance reply
- [Phase 2] Read `sound/isa/es18xx.c` lines 1754–1845 → confirmed buggy
  code without NULL checks
- [Phase 2] Read `sound/core/control.c` lines 250–259, 515–516 →
  confirmed `snd_ctl_new1()` returns NULL on failure; `snd_ctl_add()`
  handles NULL but is bypassed in buggy paths
- [Phase 2] Read `sound/pci/es1938.c` lines 1655–1678 → confirmed
  identical fix pattern already present
- [Phase 3] `git blame -L 1755,1845 sound/isa/es18xx.c` → buggy code
  from 1da177e4c3f41 (2.6.12)
- [Phase 3] `git log -S 'master_volume = kctl' -- sound/isa/es18xx.c` →
  introduced in 1da177e4c3f41
- [Phase 3] `git show 9e53e99b6fa3c` → es1938 stable backport with Cc:
  stable, Fixes: 2.6.12
- [Phase 3] `git log --oneline -20 -- sound/isa/es18xx.c` → no
  conflicting recent changes
- [Phase 4] WebFetch lkml.iu.edu/2606.0/12904.html → Takashi Iwai
  applied to for-next
- [Phase 4] b4 dig unavailable (commit not in tree); used web search
  instead
- [Phase 5] `grep snd_es18xx_mixer(` → called from
  `snd_audiodrive_probe()` line 2071
- [Phase 5] Read es18xx.c lines 1597–1604 → ES18XX_HWV set for versions
  0x1869, 0x1879
- [Phase 6] `git apply --check` with provided diff → exit 0 (clean
  apply)
- [Phase 6] Confirmed fix not present in current tree (no `if (!kctl)`
  in es18xx.c)
- [Phase 7] Read `sound/isa/Kconfig` line 186 → CONFIG_SND_ES18XX
  tristate option
- [Phase 8] Assessed severity: oops on ENOMEM during probe, HWV chips
  only

**YES**

 sound/isa/es18xx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index 1da7b400a17b6..2f454f7797ce2 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -1762,6 +1762,8 @@ static int snd_es18xx_mixer(struct snd_card *card)
 	for (idx = 0; idx < ARRAY_SIZE(snd_es18xx_base_controls); idx++) {
 		struct snd_kcontrol *kctl;
 		kctl = snd_ctl_new1(&snd_es18xx_base_controls[idx], chip);
+		if (!kctl)
+			return -ENOMEM;
 		if (chip->caps & ES18XX_HWV) {
 			switch (idx) {
 			case 0:
@@ -1823,6 +1825,8 @@ static int snd_es18xx_mixer(struct snd_card *card)
 		for (idx = 0; idx < ARRAY_SIZE(snd_es18xx_hw_volume_controls); idx++) {
 			struct snd_kcontrol *kctl;
 			kctl = snd_ctl_new1(&snd_es18xx_hw_volume_controls[idx], chip);
+			if (!kctl)
+				return -ENOMEM;
 			if (idx == 0)
 				chip->hw_volume = kctl;
 			else
-- 
2.53.0

