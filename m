Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91444A0EF4;
	Mon, 31 Aug 2026 13:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183697; cv=none; b=ZuvO3M6cCjFhrxYl5vgxyFfW0A10ZnVfBz6tyDhmqPFE9ryG2e47IEd65vXdf0aXKzrEybzycy5G/umxotSu7Ndx5DKhK+IXfmAMHW//sFvzoALmsb9YQ8AvFh+PfaQNTT+e7GhgEIbmYO7rz2IpkLUbxQk73IvI0jevUR4IGzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183697; c=relaxed/simple;
	bh=DvVYIa6XHfFGk5xz1GNwQ0b62seIBYUgOSMzfiRGL8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hXbAyeh+pPkJz42yFy9nXt9Oq/3urOoifQe+AFHOQqIuKFtZw4HcxhAzixE/nBp0vWI+R7FylnmARY4q1Yd/2gqeV/FspNLXiiN3tj1shabquTubjhn53udOKi4vXKZ7OSX+UKGSFozrpqOsPLe3f+ZJVYEtSQ8INrCIL+z+de8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mqhxRlVG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mqhxRlVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547AA1F000E9;
	Mon, 31 Aug 2026 13:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183694;
	bh=peNhPP3wjy3UUT0USk5sWo3K5yqQeatO03tTDXSpSEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mqhxRlVGFoGyzndoulZ7BSzcSM5Q8QFzwQRCPEZzEYMl4L0YQWk9Lrj2wCFJfZ5C7
	 Gzxbq4JITjmmpQ3Qr5Bxm1eEJdjTAaFAOU9l2+xXoSDR291oH97YWMGU5kgepcrO2P
	 qpOCXC+Idsup3FiZqCig0m4BKARk1fdCLw+b5EW1EdiKAn2JR8Qr8D8Hb/F1/X+85m
	 1uys+/1TI2394KXTZICee9DBIhq8gLfsOLm1Zi0tEiZEoWWJ0ej37279KpkWrGw81H
	 +0d7uQ4T3BhwmJIH4XIETdxnpRY9WnG6TgAmPQibPGeTdpb9zxohZvx2CX5hCJS8YK
	 oLpV3somx1rvA==
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
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: seq: oss: Reject reads that cannot fit the next event
Date: Mon, 31 Aug 2026 09:24:37 -0400
Message-ID: <20260831133314.4125787-249-sashal@kernel.org>
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

[ Upstream commit 611f538253d970f4d152003841544e875828d015 ]

snd_seq_oss_read() checks whether the next queued OSS sequencer event
fits in the remaining userspace buffer before removing it from the read
queue.

The check is inverted. It currently stops when the event is smaller than
the remaining buffer, so a normal 4-byte event is not copied for an
8-byte read buffer. Conversely, an 8-byte event can be copied for a
smaller read count.

Break only when the remaining userspace buffer is smaller than the next
event, and report -EINVAL if no complete event has been copied. This
prevents an undersized read from looking like end-of-file while leaving
the event queued for a later read with a large enough buffer.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260602-alsa-seq-oss-read-size-check-v1-1-10e59b1742e0@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA seq OSS read size check

**Local tree:** Linux **6.18.44** (`v6.18.44-1-gef4bf62bccf3c`, detached
from `stable/linux-6.18.y`)

**Mainline fix commit:** `611f538253d97` (not yet in this stable tree;
`git apply --check` passes cleanly)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ALSA: seq: oss]` `[Reject]` — fixes inverted buffer-size
check in `snd_seq_oss_read()` so reads that cannot hold the next
complete event are rejected instead of mishandled.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Cássio Gabriel \<cassiogabrielcontato@gmail.com\> |
| Link | https://patch.msgid.link/20260602-alsa-seq-oss-read-size-
check-v1-1-10e59b1742e0@gmail.com |
| Signed-off-by | Takashi Iwai \<tiwai@suse.de\> (committer) |

**Notable patterns:** No Fixes:, Reported-by:, Tested-by:, Reviewed-by:,
or Cc: stable. Maintainer (Iwai) committed the patch. No syzbot report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `snd_seq_oss_read()` uses `if (ev_len < count)` instead of
  `if (count < ev_len)` to decide whether the next queued event fits in
  the remaining userspace buffer.
- **Symptom 1:** A normal 4-byte short event is **not** copied when the
  read buffer is larger (e.g. 8 bytes); loop breaks with `result == 0`
  and `err == 0` → `read()` returns 0 (EOF semantics).
- **Symptom 2:** An 8-byte long event **can** be copied when `count` is
  smaller (e.g. 4), writing past the bytes the user requested for this
  read.
- **Fix:** Break only when `count < ev_len`; set `err = -EINVAL` so
  undersized reads return an error instead of false EOF, leaving the
  event queued.
- **Root cause:** Inverted comparison operator.

### Step 1.4: Hidden bug fix?
**Record:** Yes — described as a size-check correction, but it fixes
both functional breakage (reads never succeed when buffer > event size)
and a userspace buffer overrun on undersized reads for long events.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `sound/core/seq/oss/seq_oss_rw.c` (+2 / −1)
- **Function:** `snd_seq_oss_read()`
- **Scope:** Single-file, surgical fix (3 net lines)

### Step 2.2: Code flow per hunk
**Record:**
| Before | After |
|--------|-------|
| `if (ev_len < count)` → break when event is **smaller** than buffer |
`if (count < ev_len)` → break when buffer is **smaller** than event |
| On break: `err` unchanged (stays 0) | On break: `err = -EINVAL` |
| Event dequeued and copied even when `count < ev_len` | Event stays
queued; no copy attempted |

**Affected path:** Normal blocking/non-blocking `read()` on OSS
sequencer device (`odev_read()` → `snd_seq_oss_read()`).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness bug + userspace buffer overrun
- **Mechanism:** With `ev_len=4, count=8`: `4 < 8` is true → break
  without copying → returns 0 (false EOF). With `ev_len=8, count=4`: `8
  < 4` is false → `copy_to_user(buf, &rec, 8)` writes 8 bytes when only
  4 were requested — userspace overrun.

### Step 2.4: Fix quality
**Record:** Obviously correct — flips the comparison to match the stated
intent and matches the write-side pattern (`if (count < ev_size) break;`
at line 116). Minimal regression risk; `-EINVAL` is appropriate for
invalid read size.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy lines introduced in `1da177e4c3f41` (Linux-2.6.12-rc2
import, April 2005). Present unchanged in this 6.18.44 tree at lines
60–62.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: File history
**Record:** Recent stable-tree changes to this file include UAF fix
(`6dc781778b595`), SEQ_FULLSIZE write fix (`33074b1e6c18f`). No prior
fix for this read-size issue. Standalone single-patch submission (v1
only per `b4 dig -a`).

### Step 3.4: Author context
**Record:** Cássio Gabriel has one prior OSS seq commit in this tree
(`33074b1e6c18f`). Patch committed by ALSA maintainer Takashi Iwai.

### Step 3.5: Dependencies
**Record:** None. Self-contained; no prerequisite commits or series
dependencies.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** https://patch.msgid.link/20260602-alsa-seq-oss-read-size-
  check-v1-1-10e59b1742e0@gmail.com
- **Series:** v1 only (no revisions)
- **Reviewer feedback:** Takashi Iwai replied "Applied to for-next
  branch now. Thanks." No NAKs, no stable nomination in thread.

### Step 4.2: Reviewers (b4 dig -w)
**Record:** CC'd: Takashi Iwai, Jaroslav Kysela, linux-
sound@vger.kernel.org, linux-kernel@vger.kernel.org. Appropriate
subsystem coverage; maintainer applied.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot link, or user Reported-by.
Author discovered via code review.

### Step 4.4: Related patches
**Record:** Standalone; not part of a multi-patch series.

### Step 4.5: Stable list
**Record:** Not searched separately; no stable discussion found in the
patch thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `snd_seq_oss_read()` (modified); helpers: `ev_length()`,
`snd_seq_oss_readq_pick()`, `snd_seq_oss_readq_free()`,
`copy_to_user()`.

### Step 5.2: Callers
**Record:** `odev_read()` in `sound/core/seq/oss/seq_oss.c:152` —
standard `read()` file operation on `/dev/sequencer` and `/dev/music`
(OSS sequencer minors). Reachable from any userspace process with device
access.

### Step 5.3: Callees
**Record:** Queue lock/pick/free/wait, `ev_length()` (4 or 8 bytes via
`SHORT_EVENT_SIZE`/`LONG_EVENT_SIZE`), `copy_to_user()`.

### Step 5.4: Call chain / reachability
**Record:** `read(2)` → `odev_read()` → `snd_seq_oss_read()` → queue
pick + `copy_to_user()`. **Userspace-reachable** when
`CONFIG_SND_SEQUENCER_OSS` is enabled (tristate module `snd-seq-oss`).

### Step 5.5: Similar patterns
**Record:** Write path in the same file correctly uses `if (count <
ev_size) break;` (line 116). Read path was the lone inverted check.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree at
`sound/core/seq/oss/seq_oss_rw.c:60`:

```60:62:sound/core/seq/oss/seq_oss_rw.c
                if (ev_len < count) {
                        snd_seq_oss_readq_unlock(readq, flags);
                        break;
```

Bug present since 2.6.12 import; not introduced after 6.18 branch point.

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git show 611f538253d97 | git apply
--check` succeeds with no conflicts. No refactoring divergence in this
hunk between stable and mainline.

### Step 6.3: Related fixes already present?
**Record:** No. `git log stable/linux-6.18.y --grep="Reject reads"`
returns nothing. Fix exists on `master` (`611f538253d97`) but not on
`stable/linux-6.18.y`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **ALSA / sound** — OSS sequencer emulation
(`CONFIG_SND_SEQUENCER_OSS`). **PERIPHERAL** (legacy API), but syscall-
reachable for users of `/dev/sequencer`.

### Step 7.2: Subsystem activity
**Record:** Actively maintained in 6.18.y — recent stable backports
include UAF fix (`6dc781778b595`), readq locking (`287d506d4e086` on
mainline).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of OSS sequencer API (`snd-seq-oss` module): legacy
MIDI/sequencer applications reading from `/dev/sequencer` or
`/dev/music`. Config-specific (`CONFIG_SND_SEQUENCER_OSS`), but commonly
enabled on desktop distros.

### Step 8.2: Trigger conditions
**Record:**
- **Common case:** `read()` with `count > 4` and a 4-byte short event
  queued → always returns 0 (broken).
- **Overflow case:** `read()` with `count == 4` and an 8-byte long event
  (`code >= 128`) queued → copies 8 bytes into a 4-byte read window.
- Any unprivileged user with read access to the device node can trigger.

### Step 8.3: Failure mode severity
**Record:**
- False EOF (return 0): **HIGH** functional breakage — OSS sequencer
  input effectively unusable for typical read buffer sizes.
- Userspace buffer overrun on long events: **MEDIUM-HIGH** — kernel
  writes past userspace buffer bounds (userspace corruption; potential
  security impact for setuid readers).
- No kernel oops/panic.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores working read path; prevents userspace overrun;
  fixes 20-year-old logic error.
- **Risk:** Very low — 2-line logic flip + explicit `-EINVAL`; mirrors
  existing write-side logic.
- **Ratio:** Clear benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Objectively inverted comparison (verified in tree and since 2.6.12)
- Breaks normal reads when buffer > event size (returns false EOF)
- Allows `copy_to_user()` beyond requested read size for long events
- Minimal, maintainer-committed fix; applies cleanly to 6.18.44
- Buggy code confirmed present; fix not yet in stable branch

**AGAINST backport:**
- Legacy OSS API with limited user base
- No user reports or fuzzer findings
- Bug latent since 2005 (apps may use exact 4-byte reads)
- Failure is userspace corruption, not kernel crash

**Unresolved:** No runtime test results or user bug reports beyond
author analysis.

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — logic fix is self-
evident; maintainer applied; no formal Tested-by |
| 2. Fixes a real bug affecting users? | **PASS** — breaks OSS sequencer
reads; userspace overrun on long events |
| 3. Important issue? | **PASS** — HIGH functional breakage; MEDIUM-HIGH
userspace safety |
| 4. Small and contained? | **PASS** — 3 lines, one file |
| 5. No new features/APIs? | **PASS** — corrects existing behavior only
|
| 6. Can apply to local tree? | **PASS** — clean apply verified |

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs fix).

### Step 9.4: Decision rationale

For **Linux 6.18.y**, this commit should be backported. The inverted
comparison is an unambiguous logic error that makes the OSS sequencer
read path fail for the common case (read buffer larger than a 4-byte
event) and permits writing more data to userspace than the read
requested for 8-byte events. The fix is tiny, obviously correct, matches
the write-side pattern in the same file, was committed by the ALSA
maintainer, and applies cleanly to the checked-out 6.18.44 tree where
the buggy code is still present.

---

## Verification

- **[Phase 1]** Parsed commit message from user query and `git show
  611f538253d97`
- **[Phase 1]** Tags: Signed-off-by (author + Iwai), Link to lore; no
  Fixes/Reported-by/syzbot
- **[Phase 2]** Diff: 3-line change in `snd_seq_oss_read()`; inverted
  `ev_len < count` → `count < ev_len` + `err = -EINVAL`
- **[Phase 2]** Read current buggy code at `seq_oss_rw.c:60-62`;
  verified return path `return result > 0 ? result : err` yields 0 on
  buggy break
- **[Phase 2]** `ev_length()` macro: 4 or 8 bytes
  (`seq_oss_event.h:92`); `SHORT_EVENT_SIZE=4`, `LONG_EVENT_SIZE=8`
- **[Phase 3]** `git blame -L 59,63`: bug since `1da177e4c3f41`
  (Linux-2.6.12-rc2)
- **[Phase 3]** `git log -20 -- sound/core/seq/oss/seq_oss_rw.c`: no
  prior read-size fix
- **[Phase 3]** `git show 1da177e4c3f41:...`: original code had same
  inverted check
- **[Phase 4]** `b4 dig -c 611f538253d97`: found thread at
  patch.msgid.link URL
- **[Phase 4]** `b4 dig -a`: v1 only, no revisions
- **[Phase 4]** `b4 dig -w`: Iwai, Kysela, linux-sound CC'd
- **[Phase 4]** Read `/tmp/alsa_seq_oss_read_fix.mbx`: Iwai applied to
  for-next; no NAKs or stable CC
- **[Phase 5]** `grep snd_seq_oss_read`: caller is `odev_read()` in
  `seq_oss.c:152`
- **[Phase 5]** Write-side pattern at `seq_oss_rw.c:116`: `if (count <
  ev_size) break;` (correct)
- **[Phase 6]** `git describe HEAD`: v6.18.44-1-gef4bf62bccf3c; Makefile
  6.18.44
- **[Phase 6]** Buggy code present at lines 60-62 (verified by Read
  tool)
- **[Phase 6]** `git show 611f538253d97 | git apply --check`: clean
  apply
- **[Phase 6]** `git log stable/linux-6.18.y --grep="Reject reads"`:
  empty; fix not in stable
- **[Phase 6]** `git branch --contains 611f538253d97`: master/all-next
  only, not stable
- **[Phase 7]** `CONFIG_SND_SEQUENCER_OSS` in
  `sound/core/seq/Kconfig:29` (tristate OSS sequencer module)
- **[Phase 8]** Traced failure modes: false EOF (count=8, ev_len=4) and
  overrun (count=4, ev_len=8) from verified code paths

**YES**

 sound/core/seq/oss/seq_oss_rw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/core/seq/oss/seq_oss_rw.c b/sound/core/seq/oss/seq_oss_rw.c
index 111c792bc72ca..b7147ac78ee8b 100644
--- a/sound/core/seq/oss/seq_oss_rw.c
+++ b/sound/core/seq/oss/seq_oss_rw.c
@@ -57,7 +57,8 @@ snd_seq_oss_read(struct seq_oss_devinfo *dp, char __user *buf, int count)
 			break;
 		}
 		ev_len = ev_length(&rec);
-		if (ev_len < count) {
+		if (count < ev_len) {
+			err = -EINVAL;
 			snd_seq_oss_readq_unlock(readq, flags);
 			break;
 		}
-- 
2.53.0

