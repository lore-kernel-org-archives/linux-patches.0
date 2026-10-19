Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89B4592B9C;
	Mon, 19 Oct 2026 14:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418432; cv=none; b=kjFIAOShmfTzLcKyiJAIAPDwNyljOZ/eHQraWRnlRLsv2yNPrMIUH3fmAvT9aCBQq5II28UysqbN+soJhcKyaWpJciy5y4CtNYFjUrRl1kHidwFqIjeqnJ60FdRaBVyQrQHJK0hDwuKCxwRrK6Qfee/Irb0j+YMsdARkCUWwGmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418432; c=relaxed/simple;
	bh=WnxwSPc8s16lhYkGd43X9zXf2oelxmshoGx9gD0OxtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E4XCvkxyKiZsYocVMLRgb4ecnmlcwoNRdFHnydGVGEwh7+AJdXDqpg/3bTT+ScRePSwcxsPQQy4RovhtZfol3Zc/71gWbF1awdZfedT3MFTwu/Zrt/kRPwvUCsddQ2YaTUilm2u4b1ef3vON41qF9DnhVrYw6yk46dNl2cWD1Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AS3cPPvj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AS3cPPvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF18A1F000C9;
	Mon, 19 Oct 2026 14:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418429;
	bh=gf8VJGWZVl7DfK3j/RXnIBKvodMwt9/QQ5qkXKkTVdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AS3cPPvj9rhY1Ceyh6PDyQ+IQTgh8McUal5bY6+t9mdkGPLx4d9bi6WhEbl8jWBsb
	 Y51iMche+H1D27hICwSVSNoF5kAI+wyUu87aO9fmJTUMA0u/987aKRTCe/yZ0WRrkw
	 c1SId9wLh79DTL28M4lGa+M9k48I34jqyZ2XgaraqOP5ZgPcAYOyPkaC5NtluB4F04
	 Uj+ffipi/UEj2qsAjLeXXbHy/mlbgGPWLKXZKEqwnAjdVtWZZs558nEn3+V4KR6qhh
	 VEp9hPY5Snwl33QZI7B2WE88w3KggvzYw0ZDIARwmhGueffRFf9zXB2PGv3wkXYys2
	 5tb0vDLKNQfYg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sean Rhodes <sean@starlabs.systems>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] mmc: rtsx_usb_sdmmc: suppress false CD after init timeout
Date: Mon, 19 Oct 2026 09:48:54 -0400
Message-ID: <20261019135441.1420968-243-sashal@kernel.org>
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

From: Sean Rhodes <sean@starlabs.systems>

[ Upstream commit 7185b6d33b170cae54fb562ead44452810b6c231 ]

Some Realtek USB SD readers with a tray keep raw SD_CD asserted
when an empty tray is inserted. The MMC core then repeatedly tries to
initialize non-existent media, sees command timeouts, calls ->get_cd()
again, and starts the same detect cycle over.

Do not qualify media by open-coding MMC commands in ->get_cd().
Instead, let the normal MMC rescan path probe the card. If an
initialization command times out before a card has been attached,
suppress the raw SD_CD signal so the host can settle and the USB
parent can autosuspend.

Clear the suppression only when raw SD_CD drops. On the affected tray
reader, changing media requires removing and reinserting the tray, so
a low CD transition is the signal that a new insertion attempt can be
trusted again.

Signed-off-by: Sean Rhodes <sean@starlabs.systems>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The change
is a hardware quirk in `drivers/mmc/host/rtsx_usb_sdmmc.c`: tray-style
Realtek USB readers can keep `SD_CD` asserted with no media, so MMC init
times out, `->get_cd()` still says present, and the detect cycle never
stops.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[mmc/rtsx_usb_sdmmc] [suppress] [stop false card-detect after
init timeout]**
- Subsystem: `mmc: rtsx_usb_sdmmc`
- Verb: “suppress” (workaround / prevent a false-positive CD loop)
- Intent: do not keep reporting media present after an init timeout

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Fixes:** none (expected for this review)
- **Reported-by / Tested-by / Reviewed-by / Cc: stable:** none in the
  commit
- **Acked-by:** Greg Kroah-Hartman `<gregkh@linuxfoundation.org>`
- **Signed-off-by:** Sean Rhodes `<sean@starlabs.systems>` (author); Ulf
  Hansson `<ulfh@kernel.org>` (MMC maintainer)
- **Link:** none on the commit; mailing-list thread recovered via `b4
  dig` (Phase 4)
- Notable: Greg’s Ack is on the series, not a `Cc: stable` tag. Absence
  of `Fixes:` / `Cc: stable` is not treated as a negative.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** Some Realtek USB SD readers with a tray leave raw `SD_CD`
  asserted when the tray is empty.
- **Symptom:** MMC core keeps initializing non-existent media, hits
  command timeouts, calls `->get_cd()` again, and repeats. Cover letter
  (Phase 4) also reports USB reset churn and the USB parent never
  autosuspending.
- **Root cause:** `->get_cd()` trusts raw `SD_CD` and does not
  distinguish “tray in, no card” from real media.
- **Fix approach:** Do not probe from `->get_cd()`. After an init
  timeout with no attached `mmc->card`, suppress raw `SD_CD` until it
  actually drops (tray remove/reinsert).
- **Version info in the message:** none. Cover letter tested on Linux
  7.0.0-27-generic, RTS5129 `0bda:0129`, StarLite Mk V.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not hidden.** It is an explicit hardware-quirk / detect-loop
fix. “Do not qualify media by open-coding MMC commands in `->get_cd()`”
refers to dropping an RFC approach, not cleanup-for-its-own-sake.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/mmc/host/rtsx_usb_sdmmc.c` only
- **Scope:** +12 / −1, single-file surgical change
- **Functions / sites:**
  - `struct rtsx_usb_sdmmc`: add `bool suppress_cd`
  - `sdmmc_get_cd()`: honor/clear suppression
  - `sdmmc_request()`: set suppression on pre-attach `-ETIMEDOUT`
  - `rtsx_usb_init_host()`: initialize the flag

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
1. **`sdmmc_get_cd()`:** Before: `val & SD_CD` → `card_exist = true`,
   return 1. After: if CD is low, clear `suppress_cd` and report no
   card; if CD is high but `suppress_cd` is set, fall through to
   `no_card` (return 0).
2. **`sdmmc_request()` error path:** Before: any `cmd->error` re-ran
   `sdmmc_get_cd()`. After: if `!mmc->card && cmd->error == -ETIMEDOUT`,
   set `suppress_cd` first, then re-run `get_cd()` so the next detect
   sees no media.
3. **Init:** `suppress_cd = false` in `rtsx_usb_init_host()`.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **[Hardware workaround + logic/correctness]**
- Broken: raw `SD_CD` is a false present signal on empty-tray
  RTS5129-class readers.
- MMC core (`mmc_rescan`) treats `get_cd()==1` as “probe now”; init
  times out; `sdmmc_request` calls `get_cd()` again; still 1; with
  `MMC_CAP_NEEDS_POLL` set from `runtime_resume`, detect is rescheduled
  every `HZ` (`drivers/mmc/core/core.c` `out:` path).
- Fix: after a timeout before `mmc->card` exists, lie about CD until the
  line drops, so rescan takes the `get_cd()==0` power-off path instead
  of retrying init.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Quality:** Minimal and readable. `WRITE_ONCE`/`READ_ONCE` are
  justified: `sdmmc_get_cd()` is also called from `mmc_rescan` and
  `rtsx_usb_sdmmc_runtime_resume`, not only from `sdmmc_request`.
- **Regression risk (low–medium, contained):** a real card that times
  out on first init with `SD_CD` still high is hidden until CD drops.
  That matches tray hardware (remove/reinsert tray). For slot readers,
  CD normally drops on removal, so a retry is still “pull and reinsert.”
- **Not** a new API, not a new driver, no userspace ABI.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Buggy `if (val & SD_CD)` / `sdmmc_request` timeout→`sdmmc_get_cd()`
  path: **c7f6558d84afe** (“mmc: Add realtek USB sdmmc host driver”,
  2014), first in **v3.16-rc1**.
- Nearby OCP updates (`d2e6fb2c31a07`, `6fb942b85a1ab`, 2025) are
  unrelated to CD polarity; this tree has them.

Step 3.2: FOLLOW THE FIXES: TAG
Record: **No `Fixes:` tag on this commit.** Companion series patch 1/2
(`483c948324a38`) has `Fixes: bb400d2120bd` (“mfd: rtsx_usb: Defer
autosuspend while card exists”); `bb400d2120bd` **is** an ancestor of
this tree. This commit does not depend on that `Fixes:` target in its
own diff.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- **4dad599b8b5d1** — drop always-on poll; set `MMC_CAP_NEEDS_POLL` only
  while runtime-resumed. That is why a stuck-high CD becomes a permanent
  rescan loop.
- **235b630eda072** — same author, earlier `rtsx_usb` interrupt-detect
  restore, **`Cc: stable`**, S3 delay from `mmc_rescan`. Same hardware
  family.
- **No follow-ups** on `rtsx_usb_sdmmc.c` / `rtsx_usb.c` after
  `7185b6d33b170` in this tree.
- This is **patch 2/2** of “rtsx_usb: fix tray-reader false card detect
  and autosuspend”. Companion **1/2** is `483c948324a38` and is already
  in this tree.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Sean Rhodes (Star Labs) is a regular contributor for this laptop
hardware, not the MMC maintainer. Related work: `483c948324a38` (series
1/2), `235b630eda072` (stable-bound detect/PM). Maintainer weight is
Ulf’s application + Greg’s Ack.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Diff is self-contained in `rtsx_usb_sdmmc.c` (`suppress_cd` only).
- Full “USB parent autosuspends with empty tray” behavior is the
  **matched pair** with 1/2; this commit alone still stops the init-
  timeout storm.
- In **this** checkout both patches are present. No missing helper/API.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 7185b6d33b170`: **[PATCH v2 2/2]**
  https://patch.msgid.link/1d6f22a3777e78d6232cbe7dc3aa17ded8fc32e2.1783
  352430.git.sean@starlabs.systems
- `b4 dig -a`: v2 series “rtsx_usb: fix tray-reader false card detect
  and autosuspend” (2026-07-06). RFC (not in this mbox) open-coded MMC
  commands from `->get_cd()`; v2 dropped that.
- Thread saved to mbox (5 messages). lore.kernel.org WebFetch returned
  **403**; discussion taken from `b4 dig -m`.
- **Ulf Hansson (2026-07-10):** queued for -next for more testing;
  *“Potentially we should also tag these for stable kernels, but let's
  get it tested a bit more in next first.”* No NAK.
- **Greg KH:** “No objection from me” + Acked-by. No stable NAK.
- Applied version is v2 (latest matching patch-id). No later unapplied
  revision found.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To Ulf Hansson; Cc Greg KH, Arnd, Ricky Wu
(Realtek), Lee Jones, Roger Tseng, Dan Carpenter, Jisheng Zhang, linux-
mmc, linux-kernel. MMC maintainer picked it; Greg acked the series.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Author is a hardware vendor. Cover letter
gives a concrete repro (empty tray vs card vs S3) and three minutes of
empty-tray soak with no timeout/reset churn. Severity from reporter:
detect livelock, USB reset churn, autosuspend never happens.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone as a CD-suppression fix; series 1/2 is the parent
autosuspend/cache change. This tree has both. No later fixup series
found.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: `lore.kernel.org/stable/` fetch **403 (UNVERIFIED via lore)**.
In-tree/mbox: Ulf deferred `Cc: stable` until -next soak. Commit landed
in **mmc-v7.3** (pulled to Linus for 7.3). From July -next through
**7.3-rc4** (this HEAD) there are **no follow-up fixes**. That is the
soak Ulf asked for.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `sdmmc_get_cd()`, `sdmmc_request()`, `rtsx_usb_init_host()`;
field `suppress_cd`.

Step 5.2: TRACE CALLERS
Record:
- `sdmmc_get_cd` ← `rtsx_usb_sdmmc_ops.get_cd` ← `mmc_rescan()` /
  `_mmc_detect_card_removed()`; also `sdmmc_request()` on command error;
  also `rtsx_usb_sdmmc_runtime_resume()`.
- `sdmmc_request` ← `mmc_host_ops.request` (MMC I/O / init commands).
- Reachable from USB card-reader use (plug, tray insert, rescan work),
  not a dead path.

Step 5.3: TRACE CALLEES
Record: `rtsx_usb_get_card_status()`, `rtsx_usb_write_register()` on OCP
clear, `mmc_request_done()`. No new allocations or locks.

Step 5.4: FOLLOW THE CALL CHAIN
Record: USB parent resumes child on apparent insert → `runtime_resume`
sets `MMC_CAP_NEEDS_POLL` and may `mmc_detect_change` → `mmc_rescan` →
`get_cd()==1` → init cmds → `sdmmc_request` timeout → without this patch
`get_cd` still 1 → rescan forever. Userspace does not need a syscall;
inserting an empty tray is enough.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: No other `suppress_cd` in-tree. PCI Realtek host
(`rtsx_pci_sdmmc.c`) has its own `sdmmc_get_cd`; this quirk is USB-tray-
specific. Same author’s prior `rtsx_usb` interrupt-detect restore is the
closest sibling.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** File and functions exist. Pre-fix logic (trust raw
`SD_CD`) has been in the driver since v3.16. This checkout is
**7.3.0-rc4**; commit `7185b6d33b170` is already an ancestor of HEAD
(merged via `mmc-v7.3`). The bug class is old; the fix is present here.
That does **not** substitute for a technical-merit decision.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply on this tree.** Hunks match current `sdmmc_get_cd`
/ `sdmmc_request` / `rtsx_usb_init_host`. OCP fields already exist.
`WRITE_ONCE`/`READ_ONCE` available. Companion 1/2 already here.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No alternate fix for empty-tray false CD. `4dad599b8b5d1` made
poll runtime-gated (necessary context, not a substitute). No later
revert.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **MMC host driver** (`CONFIG_MMC_REALTEK_USB`, RTS5129/39 USB
readers) on top of `MISC_RTSX_USB`. **IMPORTANT** for affected laptops
(very common Realtek USB readers), not core mm/VFS. Peripheral relative
to the whole kernel, but not staging.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature driver (2014) with occasional PM/detect/OCP work. Not a
newly added subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific / config-specific**
(`CONFIG_MMC_REALTEK_USB`). Strongest hit: tray-style RTS5129
(`0bda:0129`) as on Star Labs StarLite Mk V; other rtsx USB readers
share `get_cd`. Slot-only devices keep working as long as CD drops on
removal.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Insert empty tray (or leave tray in with no card) so `SD_CD`
stays high. Common on that hardware. Not a userspace exploit path.
Timing is deterministic, not a thin race.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Repeated MMC init + command timeouts
- `MMC_CAP_NEEDS_POLL` rescan every second
- USB reset churn (author, cover letter)
- USB parent stuck out of autosuspend (power)
- Related earlier bug: long S3 entry while `mmc_rescan` is frozen
- **Severity: HIGH** for affected machines (livelock of detect + USB
  churn + PM), not a panic/UAF. Not LOW: the host never settles.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** High for tray-reader laptops; stops detect storm and
  enables autosuspend (with 1/2, already here).
- **Risk:** Low. +12/−1, local flag, no locking change beyond
  `WRITE_ONCE`. Residual risk is “timeout on first init hides a present
  card until CD drops,” which is the intended tray semantics.
- **Ratio:** Benefit > risk.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR backporting to this tree:**
- Real hardware bug on shipping RTS5129 tray readers; vendor-tested
  (insert, empty tray soak, S3).
- Failure is a detect livelock plus USB reset churn / failed autosuspend
  — user-visible stability and power, not cosmetics.
- Hardware-quirk class (false CD), which stable explicitly takes.
- Tiny, obviously structured, no new API.
- Driver and buggy `get_cd` path have existed since v3.16; this tree has
  that code.
- Greg Ack; MMC maintainer applied; Ulf only delayed stable tagging for
  -next soak — now past -next and through 7.3-rc4 with **zero** follow-
  up fixes.
- Same author already got a related rtsx_usb detect/PM fix into stable
  (`235b630eda072`).

**AGAINST:**
- Not a KASAN/crash/CVE.
- Ulf did not `Cc: stable` at merge (wanted -next first).
- Series 2/2: full autosuspend story wants 1/2 (already in this tree).
- Possible hide-until-reinsert if a real card times out during first
  init.

**UNRESOLVED:**
- Could not query lore.kernel.org/stable (HTTP 403). Relied on `b4` mbox
  + git history instead.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — v2 after RFC, runtime log on
   StarLite Mk V, Acked by Greg, merged by Ulf, no regressing follow-ups
   through 7.3-rc4.
2. Fixes a real bug that affects users? **PASS** — empty-tray false CD,
   observed detect loop and USB churn.
3. Important issue? **PASS** — detect livelock / USB reset churn / PM
   stuck (HIGH), hardware quirk.
4. Small and contained? **PASS** — one file, +12/−1.
5. No new features or APIs? **PASS** — internal flag only.
6. Can apply to the local tree? **PASS** — file/functions present;
   companion 1/2 present; applies cleanly.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Hardware quirk / workaround** for broken CD on tray readers
(same bucket as USB/PCI quirks).

Step 9.4: MAKE YOUR DECISION
This tree is 7.3.0-rc4. The driver and false-CD loop exist here; the
patch is small, tested, and a real hardware workaround. Ulf’s “test in
-next first” condition has been met (no revert, no fixup). It belongs in
this tree on technical merit.

**What it solves for users of this tree:** empty-tray Realtek USB SD
readers no longer hammer MMC init and USB, so the host can settle and
autosuspend.

**Risk vs benefit:** low code risk vs high impact on that hardware.

**Concerns:** none that block this tree; 1/2 is already here; no missing
prerequisites.

Verification:
- [Phase 1] Subject/tags: suppress false CD; Acked-by Greg KH; SOB Sean
  Rhodes + Ulf Hansson; no Fixes/Reported-by/Cc:stable
- [Phase 1] Body: empty-tray `SD_CD` stuck high → init timeout →
  `get_cd` loop
- [Phase 2] Diff: +12/−1 in `rtsx_usb_sdmmc.c`; `suppress_cd`; timeout
  in `sdmmc_request` when `!mmc->card`
- [Phase 2] Confirmed `mmc_rescan` uses `ops->get_cd` and reschedules on
  `MMC_CAP_NEEDS_POLL` (`core.c` ~2284 and 2334–2336)
- [Phase 2] Confirmed `runtime_resume` sets `MMC_CAP_NEEDS_POLL` and
  calls `sdmmc_get_cd`
- [Phase 3] `git blame` on parent: CD logic from c7f6558d84afe
  (v3.16-rc1)
- [Phase 3] `git merge-base --is-ancestor 7185b6d33b170 HEAD` → yes;
  companion `483c948324a38` is parent
- [Phase 3] No follow-ups on these files after the commit
- [Phase 3] Related stable-bound detect fix: 235b630eda072
- [Phase 3] `bb400d2120bd` is in this tree (companion Fixes target)
- [Phase 4] `b4 dig -c/-a/-w/-m`: v2 series, Ulf “potentially stable
  after -next”, Greg Ack, no NAK
- [Phase 4] lore WebFetch 403; used mbox + openwall/lkml snippets
  instead
- [Phase 4] Cover letter: RTS5129 0bda:0129, empty tray →
  `runtime_status=suspended`, no timeout/reset churn
- [Phase 5] Callers of `sdmmc_get_cd`: ops.get_cd, `sdmmc_request`,
  `runtime_resume`
- [Phase 6] `make kernelversion` / `git describe HEAD`: 7.3.0-rc4 /
  v7.3-rc4-27-gf0100363d8c37
- [Phase 6] Buggy `get_cd` present; patch applies; no alternate fix
- [Phase 7] `CONFIG_MMC_REALTEK_USB` — RTS5129/39 USB SD/MMC
- [Phase 8] Failure: detect livelock + USB churn + failed autosuspend,
  severity HIGH for that hardware
- UNVERIFIED: lore.kernel.org/stable search (HTTP 403)

**YES**

 drivers/mmc/host/rtsx_usb_sdmmc.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
index 84674659a84d4..bf37fab233cf0 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -44,6 +44,7 @@ struct rtsx_usb_sdmmc {
 	bool			double_clk;
 	bool			host_removal;
 	bool			card_exist;
+	bool			suppress_cd;
 	bool			initial_mode;
 	bool			ddr_mode;
 
@@ -774,6 +775,7 @@ static int sdmmc_get_cd(struct mmc_host *mmc)
 	struct rtsx_ucr *ucr = host->ucr;
 	int err;
 	u16 val;
+	bool cd;
 
 	if (host->host_removal)
 		return -ENOMEDIUM;
@@ -791,8 +793,14 @@ static int sdmmc_get_cd(struct mmc_host *mmc)
 
 	/* get OCP status */
 	host->ocp_stat = (val >> 4) & 0x03;
+	cd = val & SD_CD;
 
-	if (val & SD_CD) {
+	if (!cd) {
+		WRITE_ONCE(host->suppress_cd, false);
+		goto no_card;
+	}
+
+	if (!READ_ONCE(host->suppress_cd)) {
 		host->card_exist = true;
 		return 1;
 	}
@@ -874,6 +882,8 @@ static void sdmmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		 * detect card when fail to update card existence state and
 		 * speed up card removal when retry
 		 */
+		if (!mmc->card && cmd->error == -ETIMEDOUT)
+			WRITE_ONCE(host->suppress_cd, true);
 		sdmmc_get_cd(mmc);
 		dev_dbg(sdmmc_dev(host), "cmd->error = %d\n", cmd->error);
 	}
@@ -1359,6 +1369,7 @@ static void rtsx_usb_init_host(struct rtsx_usb_sdmmc *host)
 
 	host->power_mode = MMC_POWER_OFF;
 	host->ocp_stat = 0;
+	host->suppress_cd = false;
 }
 
 static int rtsx_usb_sdmmc_drv_probe(struct platform_device *pdev)
-- 
2.53.0

