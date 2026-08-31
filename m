Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F18F41B8CC;
	Mon, 31 Aug 2026 13:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183704; cv=none; b=kOFTaW052MsuoGMPAVnQLHMr7RCH60Bl4zREM4B1PTxGJO+jsdRY1eC1dAnwnpwE407tPWjB6E9fMZHt2D+0T/obTnvqVam+y+u5e4XaH05QvzLmHDEUBAZR4X6qIAGWT4fobG6Gw0bGZJHMUwvND4H3W1SJnV10LFEHGOZkmBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183704; c=relaxed/simple;
	bh=JcsdypabhS5u7Uxp14jzHmkJHSoB85fU96ZblxPHXAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ttBoJFubObfztkOcxILvkbhol6J2kM5qFZcZDKCUgnD++Mr8waRk/g72rDwPMU9dySvCzcOOLgUmMkKtoRCiol9OP7xhsW1m5//6dHXNzuqM5p1t4M0DthDbSMZyY2UGtJn0UetWz1OVTWse6vuk3Mc3z53RFasFs7C3LzC15Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TRaDXPxE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TRaDXPxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EA51F00A3D;
	Mon, 31 Aug 2026 13:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183701;
	bh=NTan6q6BI6UUhLFy481Ayds1+P+hC+mfU0yIue9buS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TRaDXPxE67bCGBRy8LbM4LL0dwYJlQj/QvPzP5i8WkdDdMjInZSKOkWvycymJLzZj
	 6D+68VF+U9zWqrqrbFOIy6+fVudr7+DpWGUcgYy2oKfyrtvyb8kZbzmkoXh5beHSEf
	 6dwtN9CYMyqnAf9w3ILq7AWeTnfmVhxL0v5TRDFn0JkEnWzgpghRA+snclQHuJB8Ok
	 F/SHQvtzupWJLUAr90pzoBh5GCv2F+sYfdB/zkPrxkO+VIj8aZIEsnSWp7+mE3Umbd
	 N7PoI5zzF8kw9IoAws5FHHMQOYlGM3wk+4v0ZIJfEc7lPTlMUr5DY6D3otcDvczuGL
	 3CVm8t4+v3RyQ==
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
Subject: [PATCH AUTOSEL 6.18] ALSA: ice1724: Fix blocking open for independent surround PCMs
Date: Mon, 31 Aug 2026 09:24:41 -0400
Message-ID: <20260831133314.4125787-253-sashal@kernel.org>
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

[ Upstream commit 1ab8e422dc779a91acba2d0aafc47b0db6680b4b ]

The independent surround playback open path rejects a substream when the
matching PDMA channel is reserved by the multi-channel PDMA0 stream. It
currently returns -EBUSY for that case, although the driver has carried a
FIXME noting that blocking mode is not handled properly.

ALSA PCM open waits and retries only when the low-level open callback
returns -EAGAIN. Returning -EBUSY therefore makes blocking opens fail
immediately, the same as nonblocking opens.

Return -EAGAIN for the temporary PDMA0 reservation conflict. The PCM core
continues to report -EBUSY for O_NONBLOCK callers, while blocking callers
sleep and retry.

Also wake the independent surround PCM wait queue when hw_free releases a
PDMA reservation. The reservation can be released by the pro PCM, while
waiters are sleeping on the independent surround PCM, so waking the current
substream PCM is not sufficient for this cross-PCM reservation.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260518-ice1724-blocking-open-v1-1-1bfa3e5aa7cf@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: **[ALSA: ice1724]** **[Fix]** **blocking open for independent
surround PCMs when PDMA channels are temporarily reserved by the pro
multi-channel stream.**

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Signed-off-by:** Cássio Gabriel \<cassiogabrielcontato@gmail.com\>
  (author)
- **Link:** https://patch.msgid.link/20260518-ice1724-blocking-
  open-v1-1-1bfa3e5aa7cf@gmail.com
- **Signed-off-by:** Takashi Iwai \<tiwai@suse.de\> (ALSA maintainer
  merge sign-off)
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or
  Cc: stable@vger.kernel.org tags
- Notable: maintainer (Iwai) sign-off is a quality signal; no user or
  fuzzer reports

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** Independent surround PCM `.open` returns `-EBUSY` when the
  matching PDMA channel is reserved by the pro (PDMA0) multi-channel
  stream.
- **Symptom:** Blocking PCM opens fail immediately instead of sleeping
  and retrying; behavior is identical to `O_NONBLOCK` opens.
- **Root cause:** ALSA PCM core (`snd_pcm_open`) only retries when the
  driver `.open` callback returns `-EAGAIN`; `-EBUSY` is propagated
  straight to userspace.
- **Fix part 1:** Return `-EAGAIN` for the temporary reservation
  conflict.
- **Fix part 2:** Wake `ice->pcm_ds->open_wait` from `hw_free` when a
  PDMA reservation is released, because the pro PCM can release a
  reservation while waiters sleep on the independent surround PCM wait
  queue (cross-PCM reservation).
- **Version info:** None stated in the message.

### Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not disguised cleanup — this is an explicit functional bug
fix.** The in-tree `FIXME: should handle blocking mode properly` comment
confirms the authors knew open semantics were wrong. The `wake_up()`
addition is required companion logic: without it, switching to `-EAGAIN`
would leave blocking openers sleeping on `pcm_ds->open_wait` with no
wakeup when the pro stream releases the reservation via `hw_free`.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
Record:
- **Files:** `sound/pci/ice1712/ice1724.c` only (+~15 / -~6 net)
- **Functions modified:** `snd_vt1724_pcm_hw_free()`,
  `snd_vt1724_playback_indep_open()`
- **Scope:** Single-file, surgical driver fix

### Step 2.2: CODE FLOW CHANGE (per hunk)

**Hunk 1 — `snd_vt1724_pcm_hw_free()`:**
- **Before:** Under `open_mutex`, clears matching `pcm_reserved[i]`
  entries; no wakeup.
- **After:** Tracks whether any reservation was released; after dropping
  the mutex, calls `wake_up(&ice->pcm_ds->open_wait)` if a reservation
  was cleared and `pcm_ds` exists.
- **Path affected:** `hw_free` on pro or independent streams that had
  reserved surround PDMA slots.

**Hunk 2 — `snd_vt1724_playback_indep_open()`:**
- **Before:** Returns `-EBUSY` when `pcm_reserved[substream->number]` is
  set.
- **After:** Returns `-EAGAIN` for the same condition.
- **Path affected:** Independent surround PCM open when pro stream holds
  the PDMA channel.

### Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **[Logic / correctness fix + ALSA API contract violation]**
- Wrong errno breaks ALSA PCM blocking-open retry contract.
- Missing cross-PCM `wake_up()` would leave blocking waiters stuck after
  a pro-stream `hw_free` releases the reservation.

### Step 2.4: ASSESS FIX QUALITY
Record:
- **Obviously correct:** Yes — matches ALSA core behavior in
  `snd_pcm_open()` and patterns used elsewhere (e.g. trident, echoaudio
  drivers return `-EAGAIN` when a resource is temporarily unavailable).
- **Minimal:** Yes.
- **Regression risk:** Very low. `O_NONBLOCK` callers still receive
  `-EBUSY` via PCM-core conversion of `-EAGAIN`. The `wake_up()` is
  conditional on an actual reservation release.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
Record: In this checkout, `git blame` attributes the buggy
`-EBUSY`/`FIXME` line to commit `a112b91dd6349`, but that commit is a
squashed stable import (the entire tree history is flattened). The
`FIXME` text itself shows the blocking-mode mishandling has been a known
issue in this driver code for a long time. **Exact introduction commit
cannot be determined in this tree's flattened history.**

### Step 3.2: FOLLOW THE FIXES: TAG
Record: **N/A — no Fixes: tag present.**

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: `git log --oneline -- sound/pci/ice1712/ice1724.c` shows only
the squashed stable import commit in this checkout. No related fix
series or prerequisites visible locally. **Standalone one-commit fix.**

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: No other commits by this author found in this tree (`git log
--author="Cássio"` / `--grep="ice1724"` returned empty). Author
relationship to subsystem unverified beyond this patch; **Takashi Iwai
maintainer sign-off** is the relevant endorsement.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: **No dependencies identified.** Uses existing fields
`ice->pcm_reserved[]`, `ice->pcm_ds`, and `pcm_ds->open_wait`, all
present in this tree. `git apply --check` confirms the patch applies
cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record: **UNVERIFIED — could not retrieve discussion.**
- `b4 dig` requires a commit hash not present in this tree; search
  attempt failed/hung.
- `WebFetch` of the Link: URL and lore.kernel.org returned bot-
  protection pages (Anubis), not thread content.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: **UNVERIFIED via b4 dig -w.** Commit message shows Takashi Iwai
merge sign-off only.

### Step 4.3: SEARCH FOR THE BUG REPORT
Record: **No Reported-by: or bugzilla/syzbot links.** No external bug
report retrieved.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: **UNVERIFIED.** Link subject suggests `v1`; no evidence of
multi-patch dependency from local tree.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: **UNVERIFIED** — lore.kernel.org inaccessible via WebFetch.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS IN THE DIFF
Record: `snd_vt1724_pcm_hw_free()`, `snd_vt1724_playback_indep_open()`

### Step 5.2: TRACE CALLERS
Record:
- `snd_vt1724_playback_indep_open` is the `.open` op for independent
  surround playback (`snd_vt1724_playback_indep_ops`).
- Called from ALSA PCM core open path (`snd_pcm_open` →
  `snd_pcm_open_file` → driver `.open`).
- Reachable from userspace via standard PCM device open
  (`/dev/snd/pcmC*D*p`).

### Step 5.3: TRACE CALLEES
Record: `scoped_guard(mutex, ...)`, `wake_up(&ice->pcm_ds->open_wait)`;
open path also sets runtime constraints and stores substream pointers.

### Step 5.4: FOLLOW THE CALL CHAIN
Record:
1. Userspace `open()` on surround PCM device
2. `snd_pcm_open()` loops on `-EAGAIN`, sleeping on `pcm->open_wait`
3. Driver `snd_vt1724_playback_indep_open()` checks `pcm_reserved[]`
4. Pro stream `hw_free` clears reservations and must wake
   `pcm_ds->open_wait`

**Reachable from userspace:** Yes, on VT1724/ICE1724 hardware with
independent surround PCM enabled.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Multiple ALSA drivers return `-EAGAIN` for temporarily
unavailable resources (e.g. `sound/pci/trident/trident_main.c`,
`sound/pci/echoaudio/*`). PCM core retry logic confirmed in
`sound/core/pcm_native.c` lines 2887–2897.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **YES.**
- Tree: **6.18.43** (`git describe HEAD` → `v6.18.43-1-gc7f0dac02d232`,
  `make kernelversion` → `6.18.43`)
- Buggy line confirmed at `ice1724.c:1367`: `return -EBUSY; /* FIXME:
  should handle blocking mode properly */`
- `ice->pcm_ds` assigned at `ice1724.c:1425`
- `hw_free` at `ice1724.c:730-740` clears reservations but does not wake
  `pcm_ds->open_wait`

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply expected** — `git apply --check` succeeded with
exit code 0. Minor style change (`guard(mutex)` → `scoped_guard`)
matches surrounding code already using `scoped_guard` in the open path.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: **No** — `git log --grep="blocking open"` and `--grep="ice1724"`
found nothing; FIXME still present.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM AND CRITICALITY
Record: **sound/pci/ice1712 (ALSA PCI audio driver)** — **PERIPHERAL**
(legacy VT1724/ICE1724 PCI sound hardware; narrow hardware population).

### Step 7.2: SUBSYSTEM ACTIVITY
Record: File history in this checkout is not informative (squashed
import). Driver is mature/legacy code with long-lived reservation logic.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
Record: **Driver-specific / hardware-specific** — users of ICE1724 cards
that use both the pro multi-channel PCM and independent surround PCMs
concurrently or in quick succession.

### Step 8.2: TRIGGER CONDITIONS
Record:
- Pro PCM stream reserves surround PDMA channels via
  `__snd_vt1724_pcm_hw_params()` (`pcm_reserved[]` set when pro uses >2
  channels).
- User/application opens independent surround PCM for the same PDMA
  slot.
- **Likelihood:** Uncommon but realistic on multi-stream VT1724 setups.
- **Unprivileged users:** Yes — any process with access to the PCM
  device node can trigger this.

### Step 8.3: FAILURE MODE SEVERITY
Record:
- **Current behavior:** Blocking open returns `-EBUSY` immediately —
  surround output open fails even though the conflict is temporary.
  **Severity: MEDIUM (functional breakage, not kernel crash).**
- **After errno fix alone (without wake):** Blocking open would sleep
  indefinitely until signaled — **potential hang. Severity: HIGH for
  that incomplete scenario.**
- **Full commit:** Blocking open waits and succeeds when the reservation
  is released. Correct behavior restored.
- **Not:** oops, memory corruption, or security vulnerability.

### Step 8.4: RISK-BENEFIT RATIO
Record:
- **Benefit:** Restores correct ALSA blocking-open semantics for
  surround PCM on VT1724; prevents stuck blocking opens once `-EAGAIN`
  retry is enabled.
- **Risk:** Very low — ~20 lines, one file, maintainer-signed, follows
  established ALSA patterns.
- **Ratio:** Moderate benefit for a small user population vs. very low
  regression risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Real, acknowledged bug (`FIXME` in source).
- Buggy code confirmed present in **6.18.43** tree.
- Small, surgical, applies cleanly.
- Takashi Iwai (ALSA maintainer) sign-off.
- Matches ALSA PCM core contract (`-EAGAIN` retry in `snd_pcm_open`).
- `wake_up()` fix is necessary companion to avoid indefinite blocking-
  open sleeps.
- Userspace-reachable on affected hardware.

**AGAINST backport:**
- Niche legacy hardware (VT1724 PCI).
- No user reports, syzbot, or Tested-by in the commit message.
- Current code fails fast with `-EBUSY`; no kernel crash/corruption in
  today's tree.
- Mailing list review thread not verified (lore inaccessible).
- Does not meet the highest-priority stable categories (security,
  corruption, oops).

**UNRESOLVED:**
- Original mailing list discussion and any explicit stable nominations.
- When the FIXME was first introduced (flattened git history).

### Step 9.2: STABLE RULES CHECKLIST
1. **Obviously correct and tested?** **PASS** — logic is clear and
   matches ALSA conventions; maintainer sign-off, but no Tested-by.
2. **Fixes a real bug that affects users?** **PASS** — real functional
   bug on VT1724 multi-PCM setups; no user reports documented.
3. **Important issue?** **PASS (borderline)** — functional breakage and
   potential blocking-open hang with incomplete fix; not
   crash/corruption/security.
4. **Small and contained?** **PASS** — one file, well under 100 lines.
5. **No new features or APIs?** **PASS** — errno correction and missing
   wakeup only.
6. **Can apply to the local tree?** **PASS** — `git apply --check`
   succeeded; all symbols exist.

### Step 9.3: EXCEPTION CATEGORIES
Record: **None directly** (not device ID, DT, build fix, or
documentation). Closest analog: driver correctness fix for hardware
resource sharing.

### Step 9.4: DECISION RATIONALE

This is a legitimate, maintainer-reviewed driver bug fix for the locally
checked-out **6.18.43** tree. The buggy code is present, the patch
applies cleanly, and the fix restores documented ALSA blocking-open
behavior for VT1724 surround PCMs. Impact is limited to legacy hardware,
but the change is low-risk and addresses a long-standing `FIXME`. The
missing `wake_up()` is not optional — it is required for the `-EAGAIN`
path to make forward progress when the pro stream releases PDMA
reservations.

---

## Verification

- **[Phase 1]** Parsed subject, tags, and body from provided commit
  message.
- **[Phase 2]** Analyzed diff: 2 functions, 1 file, ~20 lines;
  classified as logic/correctness fix.
- **[Phase 3]** `git describe HEAD` → v6.18.43; `git blame -L 1360,1370`
  → FIXME/-EBUSY line present.
- **[Phase 3]** `git log --oneline -- sound/pci/ice1712/ice1724.c` →
  squashed history only.
- **[Phase 3]** `git apply --check` on provided diff → exit 0 (clean
  apply).
- **[Phase 4]** `b4 dig` → failed/unavailable without commit hash;
  **UNVERIFIED**.
- **[Phase 4]** WebFetch of Link: and lore.kernel.org → bot protection,
  **UNVERIFIED**.
- **[Phase 5]** Read `sound/core/pcm_native.c:2868-2912` — confirmed
  `-EAGAIN` retry loop and `-EBUSY` for `O_NONBLOCK`.
- **[Phase 5]** Grep for `-EAGAIN` in sound/ — confirmed pattern in
  trident, echoaudio, etc.
- **[Phase 5]** Read `ice1724.c:678-713, 730-741, 1359-1425` — confirmed
  reservation logic and missing wakeup.
- **[Phase 6]** Confirmed buggy `-EBUSY` at `ice1724.c:1367` and
  `ice->pcm_ds` at line 1425 in 6.18.43 tree.
- **[Phase 6]** `git log --grep="blocking open"` / `--grep="ice1724"` →
  no existing fix.
- **[Phase 7]** Read `Documentation/process/stable-kernel-rules.rst` —
  confirmed criteria.
- **[Phase 8]** Traced failure mode: current `-EBUSY` → immediate open
  failure; full fix restores blocking semantics.

**YES**The `b4 dig` lookup for the ice1724 patch thread didn’t complete
— it was started with invalid arguments (`-q` isn’t supported by `b4
dig`, which needs `-c <commitish>`), then timed out and exited with code
2. Lore/patch.msgid.link also wasn’t reachable through WebFetch (bot
protection).

The backport analysis didn’t depend on that: the buggy code, ALSA
`-EAGAIN` contract, and clean apply were all verified directly in the
6.18.43 tree. Verdict remains **YES**.

 sound/pci/ice1712/ice1724.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index 7efb0bbcea550..851e7afb58142 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -730,13 +730,22 @@ static int snd_vt1724_pcm_hw_params(struct snd_pcm_substream *substream,
 static int snd_vt1724_pcm_hw_free(struct snd_pcm_substream *substream)
 {
 	struct snd_ice1712 *ice = snd_pcm_substream_chip(substream);
+	bool released = false;
 	int i;
 
-	guard(mutex)(&ice->open_mutex);
-	/* unmark surround channels */
-	for (i = 0; i < 3; i++)
-		if (ice->pcm_reserved[i] == substream)
+	scoped_guard(mutex, &ice->open_mutex) {
+		/* unmark surround channels */
+		for (i = 0; i < 3; i++) {
+			if (ice->pcm_reserved[i] != substream)
+				continue;
 			ice->pcm_reserved[i] = NULL;
+			released = true;
+		}
+	}
+
+	if (released && ice->pcm_ds)
+		wake_up(&ice->pcm_ds->open_wait);
+
 	return 0;
 }
 
@@ -1364,7 +1373,7 @@ static int snd_vt1724_playback_indep_open(struct snd_pcm_substream *substream)
 	scoped_guard(mutex, &ice->open_mutex) {
 		/* already used by PDMA0? */
 		if (ice->pcm_reserved[substream->number])
-			return -EBUSY; /* FIXME: should handle blocking mode properly */
+			return -EAGAIN;
 	}
 	runtime->private_data = (void *)&vt1724_playback_dma_regs[substream->number];
 	ice->playback_con_substream_ds[substream->number] = substream;
-- 
2.53.0

