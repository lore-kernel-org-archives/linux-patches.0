Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69603B8BB1;
	Mon, 20 Apr 2026 13:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691018; cv=none; b=r9D8+oNmU0v83tcF+9CF8aFSYxtUwjbVFZTxYunJbY1XrKuG/ONyrZiKtE9eAeCvyfjjTnFMreav+VMQuFh/uOyfy8UJlDFfyn5PkS6pcpuD6mEWwspYjrHC7A8vF6puf9uQL9ReN/8TAAxqFA1SypoWW/Ruq8JqnIVTuzv8Mnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691018; c=relaxed/simple;
	bh=JstqvWirDuryhuf3EyWzGevVPhCeYRiqem/EiC9fIsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fs7zIkzNzbCy5mIFfcUfJxv1R8ODgVUdc2oxo+jQGqMPo1wxM/tQAXmygOJiyXxHj5fMQV+cULrRdfMdDDPqgxaDolLQByubvzh+pV6XzGNPRIxGSyJE4G2lUkaC8AJ8u0T1rO1KFG2uHHIFH7jXlPfZzZh5Nh57k4SRoxCJ2xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CruUGDRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CruUGDRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B123BC19425;
	Mon, 20 Apr 2026 13:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691018;
	bh=JstqvWirDuryhuf3EyWzGevVPhCeYRiqem/EiC9fIsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CruUGDRIBrWZg8J/vLYVrvj+eQBp07rhLPfCamJ8Hc6qN2Ye+qzm4sGsr0Tsqd4fl
	 apI2t+HFeuc8k2w/kBQujE0fY3bBk56lGSD1U/5AqPn2DZnFFotNLZIS/R40SUsEof
	 1i/DrAN20Ia1AjzXw/YTcexV08q/gw+dWsMKBkF3A7Wa4u56MRYJJgLcusiFB2Fi7n
	 3tQ0y7eqjheCzNofVbjpCV6WLiuvxSUcJUKXBIZDnf9HG4rgrjGQjrcNvgiELQuzHJ
	 jypgd3Ir+PgFvxZ4Y8OxHXEd3v5/kTcgsoHQ+NKDb4Ip4VpUUeU/KUch9q5V0K4ANW
	 0mDRCryF50QVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] ALSA: pcm: Serialize snd_pcm_suspend_all() with open_mutex
Date: Mon, 20 Apr 2026 09:08:32 -0400
Message-ID: <20260420131539.986432-46-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 1a56641b7ae4f19216774a59d68024be3e6197d0 ]

snd_pcm_suspend_all() walks all PCM substreams and uses a lockless
runtime check to skip closed streams. It then calls snd_pcm_suspend()
for each remaining substream and finally runs snd_pcm_sync_stop() in a
second pass.

The runtime lifetime is still controlled by pcm->open_mutex in the
open/release path. That means a concurrent close can clear or free
substream->runtime after the initial check in snd_pcm_suspend_all(),
leaving the later suspend or sync-stop path to dereference a stale or
NULL runtime pointer.

Serialize snd_pcm_suspend_all() with pcm->open_mutex so the runtime
pointer stays stable across both loops. This matches the existing PCM
runtime lifetime rule already used by other core paths that access
substream->runtime outside the stream lock.

Suggested-by: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260327-alsa-pcm-suspend-open-close-lock-v2-1-cc4baca4dcd6@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Here is my complete analysis:

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `ALSA: pcm:` (ALSA PCM core)
- **Action verb**: "Serialize" — implies fixing a synchronization issue
  (race condition)
- **Summary**: Serialize `snd_pcm_suspend_all()` with `open_mutex` to
  prevent concurrent access

Record: [ALSA PCM core] [Serialize] [Add mutex to prevent race between
suspend and open/close]

### Step 1.2: Tags
- **Suggested-by: Takashi Iwai `<tiwai@suse.com>`** — Takashi Iwai is
  the ALSA subsystem maintainer. He suggested this fix, which carries
  enormous weight.
- **Signed-off-by: Takashi Iwai `<tiwai@suse.de>`** — Maintainer also
  signed off (committed it).
- **Signed-off-by: Cássio Gabriel** — Author of the patch.
- **Link:** to patch.msgid.link (v2 of the patch).
- No Fixes: tag, no Reported-by, no Cc: stable — expected for autosel
  candidates.

Record: Fix suggested and committed by the subsystem maintainer (Takashi
Iwai). This is the highest trust signal possible.

### Step 1.3: Commit Body Analysis
The commit describes:
- **Bug**: `snd_pcm_suspend_all()` walks PCM substreams with a lockless
  runtime check, then calls `snd_pcm_suspend()` and
  `snd_pcm_sync_stop()`. A concurrent close can clear/free
  `substream->runtime` via the open/close path (which uses
  `pcm->open_mutex`).
- **Failure mode**: Stale or NULL runtime pointer dereference —
  crash/UAF.
- **Fix approach**: Take `pcm->open_mutex` in `snd_pcm_suspend_all()`,
  matching the existing PCM runtime lifetime rule.

Record: UAF/NULL deref race during system suspend. Author explains clear
mechanism.

### Step 1.4: Hidden Bug Fix Detection
This is NOT hidden — it's an explicit race condition fix. The code
itself had a `/* FIXME: the open/close code should lock this as well */`
comment acknowledging the bug.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 (`sound/core/pcm_native.c`)
- **Lines**: +5 (including comment update), -1 (removing FIXME comment).
  Net functional change: +1 line (`guard(mutex)(&pcm->open_mutex)`)
- **Functions modified**: `snd_pcm_suspend_all()`
- **Scope**: Single-file, single-function, surgical fix.

### Step 2.2: Code Flow Change
**Before**: `snd_pcm_suspend_all()` iterates substreams without any
lock, checking `substream->runtime` and calling `snd_pcm_suspend()` /
`snd_pcm_sync_stop()` unsynchronized with the open/close path.

**After**: `guard(mutex)(&pcm->open_mutex)` is taken at function entry,
serializing the entire function with the release path
(`snd_pcm_release()` at line 2941 holds `open_mutex` around
`snd_pcm_release_substream()`).

### Step 2.3: Bug Mechanism
**Category**: Race condition / Use-After-Free / NULL pointer dereference

The race:
1. Thread A (`snd_pcm_suspend_all`): checks `!substream->runtime` → sees
   non-NULL
2. Thread B (`snd_pcm_release`): under `open_mutex`, calls
   `snd_pcm_detach_substream()` → sets `substream->runtime = NULL` →
   `kfree(runtime)` (confirmed in `sound/core/pcm.c` lines 980-1003)
3. Thread A: calls `snd_pcm_suspend(substream)` → dereferences
   freed/NULL runtime → **CRASH**

Second race window: the second loop calls `snd_pcm_sync_stop()` on ALL
substreams, which accesses `substream->runtime` (line 641).

### Step 2.4: Fix Quality
- Obviously correct: takes the same mutex already used by open/close
  paths.
- Minimal: one functional line added.
- Regression risk: Very low. The `open_mutex` is not taken in interrupt
  context; `snd_pcm_suspend()` internally uses
  `guard(pcm_stream_lock_irqsave)` which is a different lock, so no
  deadlock risk. The mutex merely serializes with open/close.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The FIXME comment (`/* FIXME: the open/close code should lock this as
well */`) was introduced in commit `8d19b4e0b377e2` (2021-02-06, "ALSA:
pcm: Use for_each_pcm_substream() macro") by Takashi Iwai himself. The
core `snd_pcm_suspend_all` function dates back to `1da177e4c3f41` (Linus
Torvalds, 2005-04-16, the initial Linux tree).

Record: The race has existed since v2.6.12 (original tree). It was made
worse in v5.12 when `snd_pcm_sync_stop` loop was added (commit
`2c87c1a49c9d`). The FIXME was planted by the maintainer acknowledging
the bug.

### Step 3.2: Fixes tag
No Fixes: tag present. The race effectively has existed since the
beginning.

### Step 3.3: File History
Recent changes to `pcm_native.c` include `guard()`-based locking
conversions and race fixes (e.g., `93a81ca065775` "Fix race of buffer
access at PCM OSS layer"). This shows the subsystem is actively being
hardened for concurrency.

### Step 3.4: Author
Cássio Gabriel has one other commit in the sound subsystem. However, the
fix was **suggested by Takashi Iwai** (ALSA maintainer) and **committed
by Takashi Iwai**, giving it the highest credibility.

### Step 3.5: Dependencies
The fix uses `guard(mutex)` which requires the cleanup.h infrastructure
(available since v6.5) and the guard conversions in pcm_native.c
(`dd0da75b9a276`, available since v6.12). For older stable trees, a
trivial adaptation to `mutex_lock`/`mutex_unlock` would be needed.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.2: Patch Discussion
b4 dig did not find the patch by commit hash (likely because this is on
a v7.0 tree). The Link: tag points to `patch.msgid.link`, which
redirected to lore.kernel.org but was blocked by anti-bot protection.
However, the commit subject says "v2", indicating the patch went through
at least two revisions. The maintainer (Takashi Iwai) suggested and
committed the fix — the highest form of endorsement.

### Step 4.3-4.5: Bug Report and Stable History
No explicit bug report (no Reported-by:). This is a proactive fix based
on code analysis (the FIXME comment). No prior stable discussion found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.2: Callers of `snd_pcm_suspend_all`
- `sound/core/pcm.c:do_pcm_suspend()` — PM callback, called during
  **system suspend**
- `sound/soc/soc-core.c` — ASoC suspend
- `sound/hda/common/codec.c` — HDA codec suspend
- `sound/usb/usx2y/us144mkii.c` — USB audio suspend

This is called on **every system suspend** for every PCM device. This
means every laptop, desktop, or embedded system with audio is affected.

### Step 5.3-5.4: Call Chain
System suspend → `do_pcm_suspend()` → `snd_pcm_suspend_all()` → race
with user-space closing audio fd → `snd_pcm_release()` → UAF/NULL deref.

Trigger: Closing a laptop lid while an audio application is running.
This is an extremely common scenario.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The buggy code (unsynchronized runtime access in `snd_pcm_suspend_all`)
has existed since v2.6.12. The `snd_pcm_sync_stop` second loop was added
around v5.12. All active stable trees contain the buggy code.

### Step 6.2: Backport Complications
For v7.0 and v6.12+: should apply cleanly (same `guard()`
infrastructure).
For v6.6 and older: would need trivial adaptation from `guard(mutex)` to
`mutex_lock`/`mutex_unlock`.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
- **Subsystem**: ALSA PCM core (`sound/core/`)
- **Criticality**: IMPORTANT — affects every system with audio hardware
  (virtually all Linux systems)

### Step 7.2: Activity
Very actively maintained by Takashi Iwai. Recent commits show ongoing
concurrency hardening.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
Every Linux system with audio hardware (virtually universal).

### Step 8.2: Trigger Conditions
System suspend while an audio stream is being closed. This is a common
scenario on laptops (lid close while music playing). The race window is
between checking `substream->runtime` and using it — a narrow but real
window.

### Step 8.3: Failure Mode Severity
NULL pointer dereference or use-after-free → **kernel oops/crash during
suspend**. Severity: **CRITICAL**.

### Step 8.4: Risk-Benefit
- **Benefit**: HIGH — prevents kernel crash during suspend for all
  audio-capable systems
- **Risk**: VERY LOW — one functional line, uses existing mutex already
  employed by the open/close paths, no deadlock risk, suggested and
  committed by the subsystem maintainer
- **Ratio**: Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real race condition (UAF / NULL deref) acknowledged by a FIXME
  comment from the subsystem maintainer
- Fix was suggested and committed by Takashi Iwai (ALSA maintainer)
- Minimal change: 1 functional line added
- Affects every system with audio during system suspend
- Failure mode is kernel crash (CRITICAL severity)
- Uses existing locking infrastructure already in use by the same code
  paths
- Second revision (v2), showing review iteration

**AGAINST backporting:**
- No user-reported crash (proactive fix based on code analysis)
- May need minor adaptation for older stable trees (guard →
  mutex_lock/unlock)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — suggested by maintainer, uses
   existing mutex pattern
2. Fixes a real bug? **YES** — race between suspend and release, FIXME
   acknowledged the issue
3. Important issue? **YES** — UAF/NULL deref → kernel crash during
   suspend
4. Small and contained? **YES** — 1 functional line in 1 function in 1
   file
5. No new features or APIs? **YES** — pure synchronization fix
6. Can apply to stable? **YES** — clean for 6.12+, trivial adaptation
   for older

### Step 9.3: Exception Categories
Not an exception — this is a standard race condition fix, a core stable
candidate.

### Step 9.4: Decision
This is a textbook stable fix: a single-line mutex acquisition that
prevents a UAF/NULL deref race during system suspend, suggested and
committed by the subsystem maintainer, fixing a longstanding FIXME.

---

## Verification

- [Phase 1] Parsed tags: Suggested-by and Signed-off-by from Takashi
  Iwai (ALSA maintainer)
- [Phase 2] Diff analysis: +1 functional line
  (`guard(mutex)(&pcm->open_mutex)`), removes 1-line FIXME comment
- [Phase 2] Verified `snd_pcm_sync_stop()` accesses `substream->runtime`
  at line 641 without lock
- [Phase 2] Verified `snd_pcm_detach_substream()` sets
  `substream->runtime = NULL` and `kfree(runtime)` at lines 997-1003 of
  `sound/core/pcm.c`
- [Phase 2] Verified `snd_pcm_release()` holds `open_mutex` around
  `snd_pcm_release_substream()` at line 2941
- [Phase 3] git blame: FIXME comment introduced by Takashi Iwai in
  `8d19b4e0b377e2` (2021-02-06), core function from `1da177e4c3f41`
  (2005)
- [Phase 3] `snd_pcm_sync_stop` loop added in `2c87c1a49c9d11` ("Assure
  sync with pending stop operation at suspend", 2021)
- [Phase 3] `guard()` infrastructure for pcm_native.c in `dd0da75b9a276`
  (v6.12+)
- [Phase 4] b4 dig: did not find match (this is a v7.0 tree). Link: in
  commit points to v2 of the patch.
- [Phase 5] Callers: `do_pcm_suspend()` (PM callback), soc-core, HDA
  codec, USB audio — called on every system suspend
- [Phase 6] Buggy code present in all active stable trees (since
  v2.6.12)
- [Phase 7] ALSA PCM core — affects virtually all Linux systems with
  audio
- [Phase 8] Failure mode: NULL deref or UAF during system suspend →
  kernel crash (CRITICAL)

**YES**

 sound/core/pcm_native.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 5a64453da7283..1ccc482a8dfd3 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1761,6 +1761,9 @@ static int snd_pcm_suspend(struct snd_pcm_substream *substream)
  * snd_pcm_suspend_all - trigger SUSPEND to all substreams in the given pcm
  * @pcm: the PCM instance
  *
+ * Takes and releases pcm->open_mutex to serialize against
+ * concurrent open/close while walking the substreams.
+ *
  * After this call, all streams are changed to SUSPENDED state.
  *
  * Return: Zero if successful (or @pcm is %NULL), or a negative error code.
@@ -1773,8 +1776,9 @@ int snd_pcm_suspend_all(struct snd_pcm *pcm)
 	if (! pcm)
 		return 0;
 
+	guard(mutex)(&pcm->open_mutex);
+
 	for_each_pcm_substream(pcm, stream, substream) {
-		/* FIXME: the open/close code should lock this as well */
 		if (!substream->runtime)
 			continue;
 
-- 
2.53.0

