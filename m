Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32274FFA23;
	Mon, 19 Oct 2026 13:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418250; cv=none; b=kGHqx3EzMQ8mZRQ4pcX9bz4eO/X7Rb4ht24jbwcy8rcI79ZnI7x3/rwK4tpV8L+ekxDzXpcsW+e+A7evmzusO5PF09tfDjJyEWWuDWbmXxFAMNVcaJqUbnCsmeo8FK+e4Eald6n5YS/YZRhJ7TXTHYzU9qT2NfdmA7+3dPrRr6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418250; c=relaxed/simple;
	bh=O3LaxiIuL0cy7v6sHAR1GYWghevGkkV2CcWLonf89oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pt1NASJXjsioHYfAocwCPqw2WiVlNGtLKDoXmIeqD/fsjOMl8saSL+aRRN4MYG6SpbYA52YhM7UW9lPOsqhjLD1uRPhS6xWckaE+dgLTv0EtKHz+6/row4YhwbiR5UxrikbOWykZUqN+tgJ5PJqgTc/L0WwoJkyytO/3oBOfHPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DL57TVDN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DL57TVDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D2B1F000C5;
	Mon, 19 Oct 2026 13:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418247;
	bh=kakytPNLY+AAC3VufQx8vQdmpbFyKM5AqZpi8YYg6KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DL57TVDNCQKYrHfaRTcoTBGaZwp3IVsxOK2mkcggezVONOUNML6CkjODs/d5hsqSC
	 wr5wGTS3PCpmNyye+vJoFrrQsJH7s/n+l7/UpneJ+bxvqshVKD0GTfD3D9Ejwq92Ab
	 rea7Bfvzgzn6+reR7fhL46cbHYvKk8jrdVfByLw2oBgcXAT9JES+ojjzhn3bQgzpeb
	 VKzrI/0xiQdoaIY9PZMFmOMLjWZCBgCaWrY/dCIV9XwQt5BjiAwrL3a462hFi31m6I
	 fwHlxmhScyAcQYffn59JwX3vn1qesgkGtFUFy0hl2FtVfpC7l09tXkBGYMYiW68/df
	 9zFrgQcOPZorw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	sashiko-bot@kernel.org,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] mfd: ipaq-micro: Fix out-of-bounds stack read in ipaq_micro_str
Date: Mon, 19 Oct 2026 09:46:48 -0400
Message-ID: <20261019135441.1420968-117-sashal@kernel.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit da3a98c941753255418616d249e5b40db0927c26 ]

ipaq_micro_str() decodes a UTF-16LE string into an ASCII string.
It copies characters to a stack buffer retstr, but fails to
null-terminate it. When kstrdup() is called on retstr, it can read past
the buffer into uninitialized stack memory, potentially leaking stack
contents.

Fix this by initializing retstr to zero.

Reported-by: sashiko-bot@kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://patch.msgid.link/aintJF4X5tWDW-Ej@google.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (`7.3.0-rc4`). The bug is in
`ipaq_micro_str()`: it copies UTF-16LE bytes into an uninitialized
256-byte stack buffer and then `kstrdup()`/`strlen()` can walk off the
end of that buffer. That is a real out-of-bounds stack read and a
kernel-stack leak into dmesg, introduced in 2014, with a one-line zero-
init fix that applies here with no prerequisites.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[mfd / ipaq-micro] [Fix] out-of-bounds stack read in
ipaq_micro_str**
- Subsystem prefix: `mfd: ipaq-micro:`
- Action verb: **Fix** (explicit bug-fix language)
- Claimed intent: stop `ipaq_micro_str()` from reading past a stack
  buffer

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Reported-by:** `sashiko-bot@kernel.org` (automated analysis bot, not
  syzbot, not a user crash report)
- **Assisted-by:** `Antigravity:gemini-3.5-flash` (LLM-assisted)
- **Signed-off-by:** Dmitry Torokhov (author)
- **Link:** https://patch.msgid.link/aintJF4X5tWDW-Ej@google.com
- **Signed-off-by:** Lee Jones (MFD maintainer)
- **No Fixes:** tag (expected for this review pipeline)
- **No Cc: stable@vger.kernel.org** (expected; not treated as a
  negative)
- **No Tested-by / Reviewed-by / Acked-by**
- No Sasha Levin SOB and no `[Upstream commit ...]` marker on the commit
  itself

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** `ipaq_micro_str()` decodes UTF-16LE into ASCII in stack
  buffer `retstr` and never NUL-terminates it.
- **Symptom/failure mode:** `kstrdup(retstr)` uses `strlen()`, which can
  read past `retstr` into uninitialized stack, **leaking stack
  contents**.
- **Version information:** none in the message.
- **Root cause (author):** missing terminator on a stack buffer before a
  C-string API.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not a hidden fix.** Subject and body state an OOB read / stack
leak. The one-line zero-init matches that claim.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/mfd/ipaq-micro.c` — 1 insertion, 1 deletion
- **Function:** `ipaq_micro_str()`
- **Scope:** single-file, single-line surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** `char retstr[256];` is uninitialized. Loop writes `len/2`
  ASCII bytes at `retstr[0 .. len/2-1]` and never writes a terminator.
  `kstrdup(retstr)` calls `strlen()` (verified in `mm/util.c`).
- **After:** `char retstr[256] = { 0 };` zero-fills the buffer, so the
  first unused byte is NUL and `kstrdup` stays inside the array.
- **Path:** `__init` probe dump only (`ipaq_micro_eeprom_dump()` →
  `ipaq_micro_str()`), not a hot path.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Categories:** uninitialized data **and** out-of-bounds stack read;
  possible kernel-stack leak to dmesg.
- **Mechanism:** C-string API on a non-terminated stack buffer. Callers
  pass `len` of 10/40/20/10, so 5–20 bytes are written and 236–251 bytes
  stay uninitialized. If those leftover bytes contain no NUL, `strlen()`
  reads **past** the 256-byte array.
- **Fix:** full zero-init; `len` is `u8` so `len/2 <= 127`, always room
  for a terminator.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Quality:** obviously correct. Equivalent to `retstr[i] = '\0'` after
  the loop; zero-init is simpler and covers every `len`.
- **Regression risk:** very low. Only this helper; no locking, APIs, or
  control-flow change. Extra zeros cannot make a well-formed EEPROM
  string worse; they only stop the over-read.
- **Red flags:** none (1 line, one driver, no public API).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- **Buggy function introduced by:** `dcc21cc09e3c22` — “mfd: Add driver
  for Atmel Microcontroller on iPaq h3xxx” (Linus Walleij, 2014-04-03;
  merged 2014-06-03).
- **First appeared:** `v3.16-rc1` (`git describe --contains
  dcc21cc09e3c22` → `v3.16-rc1~82^2~6^2~20`).
- The `char retstr[256];` / `kstrdup` pattern was unchanged from
  introduction until this fix.

Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** Introducer identified by blame:
`dcc21cc09e3c22`, present in this tree (`git merge-base --is-ancestor`
not needed for HEAD history; the file and function are here).

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Recent file commits are style/helpers (`str_enable_disable`, `%*ph`,
  missing `break`, etc.), not a competing terminator fix.
- **Standalone**, not `patch X/Y`. No follow-up on this helper after
  `da3a98c941753`.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Author **Dmitry Torokhov** is a long-time input/MFD contributor, not
  the iPAQ driver original author.
- Nearby MFD work is unrelated (rohm, ucb1x00, mt6397). This looks like
  a bot-found one-off, not a series.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- **No dependencies.** Changes only `char retstr[256];` → `= { 0 }`.
  Pre-fix function in this tree’s parent of the fix is identical to the
  candidate hunk. **Applies standalone.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- **b4 dig -c da3a98c941753:** https://patch.msgid.link/aintJF4X5tWDW-
  Ej@google.com
- **b4 dig -a:** single **v1** only (2026-06-10); no v2/v3.
- Thread (saved via `b4 dig -m`): Dmitry’s patch + Lee Jones “Applied,
  thanks!” (2026-06-18). **No NAK, no stable nomination, no risk
  discussion.**
- lore.kernel.org WebFetch returned **403**; discussion recovered from
  the mbox instead.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: **b4 dig -w** original recipients: Dmitry Torokhov, **Lee
Jones** (`lee@kernel.org`, MFD maintainer), `linux-
kernel@vger.kernel.org`. Maintainer applied it. No other review mail in
the thread.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: Reporter is **sashiko-bot**, not syzbot. No bugzilla/syzkaller
link. No user “I hit this on hardware” report found in the thread.
Severity from the author: stack OOB + possible stack leak.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: **Standalone v1.** Not part of a multi-patch series.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: **UNVERIFIED** for lore.kernel.org/stable (HTTP 403). No stable
discussion in the captured mbox.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: **`ipaq_micro_str()`** only.

Step 5.2: TRACE CALLERS
Record: (semcode unavailable; `git grep` / file read)
- Only caller: `ipaq_micro_eeprom_dump()` with `(dump, 10)`, `(dump+10,
  40)`, `(dump+50, 20)`, `(dump+70, 10)`.
- That dump is `__init` and is called from **`micro_probe()`** after MFD
  cells are added.
- Results go to `dev_info()` and, for the serial-number string,
  `add_device_randomness()`.

Step 5.3: TRACE CALLEES
Record: loop assignment; **`kstrdup()`** → `strlen()` + `kmalloc` +
`memcpy` (`mm/util.c`). That is what turns missing NUL into an over-read
and a heap copy of whatever `strlen` walked.

Step 5.4: FOLLOW THE CALL CHAIN
Record:
- `builtin_platform_driver_probe(..., micro_probe)` →
  `ipaq_micro_eeprom_dump` → `ipaq_micro_str`.
- **Reachable only when this platform device probes**, i.e. Compaq iPAQ
  h3xxx with `CONFIG_MFD_IPAQ_MICRO` / `SA1100_H3600`.
- Not a syscall-reachable path for unprivileged users on generic
  hardware. Requires that board.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: No other `ipaq_micro_str`-style helper in-tree. Sibling iPAQ
drivers (keys/ts/battery) do not duplicate this decoder.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- **Yes.** File and helper exist. Pre-fix form (`char retstr[256];` +
  `kstrdup`) is in this lineage from `dcc21cc09e3c22` (v3.16) through
  the parent of `da3a98c941753`.
- Current HEAD already contains the zero-init line (commit is an
  ancestor of HEAD). That is **not** used as “already selected for
  stable”; it only confirms the surrounding code is the same.
- Local version: **7.3.0-rc4** / `v7.3-rc4-27-gf0100363d8c37`.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply.** Hunk context (`ipaq_micro_eeprom_read` /
`ipaq_micro_str` / loop / `kstrdup`) is unchanged besides this one
initializer. No refactor of this function in this tree.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No earlier alternate terminator fix. `3d1c3272a8095` is an
unrelated missing-`break` change.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record:
- **Subsystem:** MFD driver `drivers/mfd/ipaq-micro.c` (Compaq iPAQ
  Atmel companion).
- **Criticality: PERIPHERAL.** `MFD_IPAQ_MICRO` depends on
  `SA1100_H3600` (StrongARM iPAQ H3100/H3600/H3700). `SA1100_H3600` is
  still a real board option (not `UNUSED_BOARD_FILES`, unlike several
  other sa1100 boards).

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: **Mature / low churn.** Driver added 2014; later commits are
small cleanups. Bug is long-standing, not a new-subsystem issue.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Platform-specific / config-specific** — only kernels built for
Compaq iPAQ H3xxx (`SA1100_H3600` selects `MFD_IPAQ_MICRO`). Not
universal, not enterprise-default hardware.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- **Trigger:** once per boot, in `__init` `micro_probe()`, when the
  microcontroller EEPROM is dumped.
- **How common:** every probe on that hardware; never on other machines.
- **Unprivileged userspace:** cannot trigger this without the device
  (not a syzbot-style syscall bug). If dmesg is readable, leaked stack
  bytes in `dev_info` lines are the exposure.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- **Failure mode:** `strlen`/`kstrdup` over-read of stack; copy of extra
  stack bytes into a heap string; print via `dev_info` (kernel log info
  leak); oversized `add_device_randomness()` on the serial path.
  Possible large `kmalloc` if no NUL is found soon; crash only if the
  scan hits an unmapped guard (possible, not demonstrated).
- **Severity: HIGH** for memory safety / info leak on that platform;
  **LOW population**. Not a guaranteed panic on every boot.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** stops a real OOB stack read and stack leak for every iPAQ
  micro probe. Code has been wrong since v3.16.
- **Risk:** very low (one initializer, no behavior change for terminated
  strings).
- **Ratio:** benefit modest in user count, risk near zero. For a 1-line
  memory-safety fix that is obviously correct, that still favors
  inclusion.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
**FOR backporting to this tree:**
- Real bug: missing NUL + `kstrdup`/`strlen` → OOB stack read; leftover-
  buffer chance of no NUL is high (~35–40% if leftover bytes are
  random), so this is not a purely theoretical race.
- Failure includes kernel-stack contents in dmesg (info leak) and a
  possibly oversized allocation.
- One-line, obviously correct, no new API/feature.
- Present in this tree’s code since v3.16; no missing prerequisites.
- MFD maintainer Lee Jones applied v1 with no objections.
- Matches stable patterns: uninitialized data, OOB, small surgical fix.

**AGAINST:**
- Extremely niche 2000-era PDA; not a core/enterprise path.
- Probe/`__init` only; not a hot-path leak or a syscall UAF.
- Reporter is sashiko-bot + LLM assist, not a hardware user or syzbot
  repro.
- No `Cc: stable` in review (not a negative per pipeline rules).

**UNRESOLVED:**
- Could not query lore.kernel.org/stable (403).
- No runtime crash log; analysis is from code + commit text.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — zero-init makes `kstrdup`
   well-defined; maintainer applied it. (No extra Tested-by; correctness
   is visible from the code.)
2. Fixes a real bug that affects users? **PASS** — OOB read + stack leak
   on this driver’s probe path. Affected users are iPAQ H3xxx owners
   only, but the bug is real.
3. Important issue? **PASS** — out-of-bounds stack read and kernel-stack
   leak, not a style cleanup. Severity HIGH on that platform, not a core
   panic.
4. Small and contained? **PASS** — 1 line, one static helper.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — same function, same callers,
   no refactor required.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **None** (not a device ID, quirk, DT, build, or docs exception).
It qualifies as a normal small memory-safety bug fix.

Step 9.4: MAKE YOUR DECISION
This tree contains the buggy helper and can take the one-line terminator
fix with essentially no regression risk. Niche hardware lowers the user
count; it does not make an OOB stack read + log leak ineligible. The
patch meets the stable-rule checklist for **this** 7.3-rc4 tree.

===============================================================
What the commit solves for this tree
===============================================================
`ipaq_micro_str()` fills a 256-byte stack buffer and then treats it as a
C string. Without a terminator, `kstrdup()` → `strlen()` can read off
the end of `retstr` and copy leftover stack into a heap string that is
printed (`dev_info`) and, for the serial number, passed to
`add_device_randomness()`. Zero-initializing `retstr` terminates the
string inside the array. That is the whole fix.

Risk vs benefit: benefit is limited to Compaq iPAQ H3xxx probe, but the
defect is a genuine memory-safety / info-leak bug present since v3.16.
Risk of the change is negligible. No series, no extra commits, no
backport rework.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed tags: Reported-by sashiko-bot; Assisted-by LLM; SOB
  Dmitry Torokhov + Lee Jones; Link patch.msgid.link/aintJF4X5tWDW-
  Ej@google.com; no Fixes/Cc-stable
- [Phase 2] Diff: 1 line in `ipaq_micro_str()`: `char retstr[256]` → `=
  { 0 }`
- [Phase 2] `kstrdup` in `mm/util.c` uses `strlen(s)+1` then `memcpy` —
  confirms OOB if unterminated
- [Phase 2] Callers in `ipaq_micro_eeprom_dump` pass len 10/40/20/10;
  `len` is `u8` so `len/2 <= 127`
- [Phase 3] `git blame`: function from `dcc21cc09e3c22` (2014);
  initializer from `da3a98c941753`
- [Phase 3] `git describe --contains dcc21cc09e3c22` → v3.16-rc1; bug
  long predates this tree
- [Phase 3] `git log -15 --author=Dmitry Torokhov -- drivers/mfd/`: this
  commit is an isolated ipaq-micro change
- [Phase 3] No related follow-up on `ipaq_micro_str`
- [Phase 4] `b4 dig -c da3a98c941753`: lore URL found; `-a` only v1;
  `-w` Lee Jones + lkml; `-m` thread is patch + “Applied, thanks!”
- [Phase 4] WebFetch lore/all and lore/stable: **403** — UNVERIFIED via
  HTTP
- [Phase 5] grep: only `ipaq_micro_eeprom_dump` / `micro_probe` call
  this helper; `__init` probe path
- [Phase 6] `git describe HEAD` / `make kernelversion`: **v7.3-rc4 /
  7.3.0-rc4**
- [Phase 6] `git merge-base --is-ancestor da3a98c941753 HEAD`: yes
  (commit is in this checkout; not used as circular “already selected”)
- [Phase 6] Pre-fix snippet from `da3a98c941753^` matches the candidate
  diff exactly
- [Phase 7] Kconfig: `MFD_IPAQ_MICRO depends on SA1100_H3600`; H3600 not
  under UNUSED_BOARD_FILES
- [Phase 8] Failure mode: stack OOB + dmesg leak on iPAQ probe, severity
  HIGH on that platform
- UNVERIFIED: whether anyone discussed this on stable@; whether strlen
  walking off-stack actually hits a guard page on SA1100

The fix is small, surgical, and meets the stable criteria for this tree.

**YES**

 drivers/mfd/ipaq-micro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ipaq-micro.c b/drivers/mfd/ipaq-micro.c
index 4b757d8472825..5146a6eb0e5a6 100644
--- a/drivers/mfd/ipaq-micro.c
+++ b/drivers/mfd/ipaq-micro.c
@@ -221,7 +221,7 @@ static void ipaq_micro_eeprom_read(struct ipaq_micro *micro,
 
 static char *ipaq_micro_str(u8 *wchar, u8 len)
 {
-	char retstr[256];
+	char retstr[256] = { 0 };
 	u8 i;
 
 	for (i = 0; i < len / 2; i++)
-- 
2.53.0

