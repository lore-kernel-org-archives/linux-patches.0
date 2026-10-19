Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60E05AA68A;
	Mon, 19 Oct 2026 14:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418436; cv=none; b=LO3j13YALZZSDj5PL8GueIR8+mTfuAR6YHVgLCLsdsQzCaenxemkY+gV6A3GkE5QWT+jCIqCkvVaa92LS0oS0pqWVn+DHo+cXDGYC0p1QtqjuVvQfCWcJTX2oFm2QHJNOKp85vdVJC9j6YA0L+TnRX/hb+QFArUpaa26XPxr5Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418436; c=relaxed/simple;
	bh=pRdL3eeVH4nJXPcyPGW0LeZ1SRCE9MRWIMjuU1PvaEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kLHsS0wr8lo3WTKFwCB6ZAlLEAb/zZJcq6YpX1aZtj6vJcl3rLhvqPrZeAjRCfzi1zd9Yc3CFdtNIlF4DIPCz66xPLYHDM1t/ceE6r1hJ/J1xK7wWd0/oFFnNMhIzjTmnwuqmb/rTpX2K7OwxPaKZDUb/xTlCCkamrYQkwNeylc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/ZwjNUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/ZwjNUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBD81F000C4;
	Mon, 19 Oct 2026 14:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418433;
	bh=GIhegACar7qq6FyDZloFTRjPXKaowz8sFORDAk9qvW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g/ZwjNUqxexixvcuAO97cbxYc1MjsfI7zpe2frsi3/TiTRi45w94Fiw2OFzyZurbH
	 I+BuS+WLG533HICJwEs7KFmVPCGV6Axd9aOz/UL6IWqVdP9mgz+bSGqE7uxfjHCWhC
	 Ynx7/nBsZru41cGP1dMqvtQe3Aoooq+jxaj7IRkrWlOXnY96C+93gqEmWxBOLzxn5B
	 bFdjOsEJyYv2D/TXt2GvNFzPDtlTCGzKfUD5loniCkPM+kSMQuYEnvnQNmo8hwIClw
	 x4xe/m/LDZe0kPjnddPL5TlH4az1wjsQld4oBCEjeRpwKVdjacwkF0XyowlNWoQB+a
	 kRvVwN/hrB0+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kate Hsuan <hpa@redhat.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ACPI: battery: Sanitise model_number by dropping unprintable characters
Date: Mon, 19 Oct 2026 09:48:57 -0400
Message-ID: <20261019135441.1420968-246-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Kate Hsuan <hpa@redhat.com>

[ Upstream commit 6587dd87595cfae6bf1304cd0cd1df2274424e42 ]

The battery Embedded Controller (EC) may return the model name with
trailing unprintable or non-ASCII characters. For example, on some
systems:

$ cat /sys/class/power_supply/BAT0/model_name
LNV-5B10W51864��

If a non-ASCII or an unprintable character is found, it will be
replaced with '\0' to ensure the model_number is a valid string.

If left intact, the malformed string prevents udev rules and hwdb
working correctly.

Link: https://gitlab.freedesktop.org/upower/upower/-/work_items/345
Signed-off-by: Kate Hsuan <hpa@redhat.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
[ rjw: Subject tweak ]
Link: https://patch.msgid.link/20260710125122.1621877-1-hpa@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ACPI battery model_number sanitization

Local tree: **v7.3-rc4** (`7.3.0-rc4`, HEAD `f0100363d8c37`). Commit
under review: `6587dd87595cfae6bf1304cd0cd1df2274424e42`.

This is a mainline 7.3-rc checkout. The verdict is whether this fix has
the technical merit to be backported from this tree into stable, given
that the ACPI battery driver and the unsanitized `model_number` path
exist here.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[ACPI battery] [Sanitise] [drop unprintable/non-ASCII bytes
from `model_number` so sysfs `model_name` is a usable C string]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected for this review)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Mark Pearson `<mpearson-lenovo@squebb.ca>` (Lenovo)
- **Acked-by:** none
- **Link:**
  https://gitlab.freedesktop.org/upower/upower/-/work_items/345 (UPower
  work item)
- **Link:**
  https://patch.msgid.link/20260710125122.1621877-1-hpa@redhat.com (v2
  submission)
- **Cc: stable:** none (expected; not a negative)
- **Signed-off-by:** Kate Hsuan `<hpa@redhat.com>` (author, Red Hat);
  Rafael J. Wysocki `<rafael.j.wysocki@intel.com>` (ACPI maintainer)
- **Other:** `[ rjw: Subject tweak ]`

Notable: Lenovo Reviewed-by plus a Red Hat author. No syzbot/KASAN.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** Battery EC/`_BIF`/`_BIX` returns a model string with trailing
  unprintable or non-ASCII bytes. Example: `LNV-5B10W51864` plus
  replacement characters in sysfs.
- **Symptom:** `/sys/class/power_supply/BAT0/model_name` is not a clean
  ASCII string; **udev rules and hwdb cannot match** it.
- **Failure mode:** Userspace battery identification fails (UPower, hwdb
  quirks, udev `ATTR{model_name}` rules). Not a kernel oops.
- **Version info:** none in the message. Driver and field are old (see
  Phase 3).
- **Root cause (author):** firmware/EC returns garbage; kernel copies it
  into `model_number` unchanged.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not a disguised cleanup.** The subject/body describe a
firmware-string sanitization so userspace matching works. It is a
**hardware quirk / firmware workaround**, not a crash fix.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/acpi/battery.c` only — **+14 / −0**
- **Functions:** new `acpi_battery_clean_unprintable_chars()`; call
  added at the end of `extract_battery_info()`
- **Also:** `#include <linux/ctype.h>`
- **Scope:** single-file surgical change

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `extract_package()` `strscpy()`s ACPI string/buffer into
  `battery->model_number`. That value is exported as
  `POWER_SUPPLY_PROP_MODEL_NAME` (`val->strval =
  battery->model_number`). Trailing non-ASCII/unprintable bytes stay in
  the sysfs string.
- **After:** On successful extract (`!result`), walk `model_number` and
  replace the first non-ASCII or non-printable byte with `'\0'`
  (truncate). `isprint('\0')` is false, so an existing terminator also
  stops the loop.
- **Path:** initialization/update when `_BIF`/`_BIX` is parsed
  (`acpi_battery_get_info()` → `extract_battery_info()`), not a hot I/O
  path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** **hardware workaround / firmware string sanitization**
  (logic/correctness of exported sysfs string)
- **Mechanism:** EC returns trailing garbage; kernel treated it as a C
  string and exported it. Truncating at the first bad byte makes
  `model_name` matchable by udev/hwdb.
- **Not:** UAF, leak, race, NULL deref, overflow, deadlock.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** Small and easy to verify. Loop is bounded by
  `ARRAY_SIZE(battery->model_number)` (64). Stops at NUL or first bad
  byte. Matches the “trailing garbage” report.
- **Regression risk:** Low. Sysfs `model_name` changes from a garbage-
  suffixed string to the printable prefix — that is the intended ABI
  cleanup. Unlikely udev rules match the unprintable suffix. Theoretical
  risk: a legitimate non-ASCII model name would be truncated; ACPI
  `_BIF`/`_BIX` model strings in practice are ASCII (Lenovo example
  `LNV-5B10W51864`). Only `model_number` is cleaned, not
  `serial_number`/`oem_info` — incomplete vs a full sanitizer, but
  matches the reported bug.
- **v1 vs v2:** v1 stripped unprintables in the middle and kept the
  rest; v2 truncates. v2 is what landed; Lenovo reviewed it as good.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- New helper is entirely this commit (`6587dd87595cfa`).
- `extract_battery_info()` exists since **Dave Lambley, 2016**
  (`2d09af4a88d99a`).
- `model_number[]` and copy-from-ACPI go back to the old ACPI battery
  driver (**~2007–2009**; `c67fcd670b55e` added `_BIX` in 2009).
  Unsanitized export has been present for many LTS generations.
- String copy uses `strscpy` from Armin Wolf, 2023 (`a1a32ded2887fd`) —
  that only changed copy safety, not sanitization.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Nothing to follow. Bug is long-standing
firmware/EC behavior, not a recent regression from a specific commit.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent `drivers/acpi/battery.c` commits after this one (mutex
split, notification merge, charging-status check) are **independent**.
No prerequisite series. Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Kate Hsuan (Red Hat) has this one ACPI battery commit plus other
hardware-enablement work (Lenovo cameras, power-supply LEDs). Not the
ACPI maintainer. ACPI maintainer (Rafael) applied it. Lenovo’s Mark
Pearson reviewed it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Uses `isascii`/`isprint` from `linux/ctype.h` (long-standing).
`extract_battery_info()` and `model_number[MAX_STRING_LENGTH]` exist in
this tree and in old kernels. **Standalone; no extra commits required.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **b4 dig:**
  https://patch.msgid.link/20260710125122.1621877-1-hpa@redhat.com
- **Revisions:** v1 `20260708070732.578046-1-hpa@redhat.com`
  (2026-07-08); **v2** (committed) 2026-07-10. v1 compacted by dropping
  unprintables; v2 truncates at first bad byte.
- **Review:** Mark Pearson: “this impacts a few of our platforms”;
  “Implementation looks good to me.” **Reviewed-by** given.
- **Maintainer:** Rafael: **“Applied as 7.3 material, thanks!”** No NAK.
  No `Cc: stable` request in the v2 thread (mbox).
- lore.kernel.org HTTP **403**; thread recovered via **b4 mbox** and
  openwall.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (b4 -w): Kate Hsuan, Mark Pearson (Lenovo), Rafael J. Wysocki,
Len Brown, linux-acpi@, linux-kernel@. Right maintainers were on Cc.
Rafael applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: UPower work item
https://gitlab.freedesktop.org/upower/upower/-/work_items/345 — **GitLab
returned 403; body UNVERIFIED**. Commit + Lenovo review still establish
real udev/hwdb/UPower impact on some Lenovo platforms.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone (not N/M). No follow-up in this tree extending
sanitization to serial/oem.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search **403**. **UNVERIFIED** whether
stable@ discussed this. No evidence in the ACPI thread of a stable
nomination or a rejection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

semcode MCP was **not available**. Used `rg` and file reads.

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `acpi_battery_clean_unprintable_chars()` (new);
`extract_battery_info()` (caller added).

**Step 5.2: TRACE CALLERS**

Record:
- `extract_battery_info()` ← `acpi_battery_get_info()`
- `acpi_battery_get_info()` ← `acpi_battery_update()` (probe/update when
  `!update_time`), `acpi_battery_refresh()`, `battery_notify()` post-
  suspend path
- `model_number` read in `acpi_battery_get_property()` for
  `POWER_SUPPLY_PROP_MODEL_NAME` → sysfs `model_name`

Calling context: ACPI battery probe/update/resume, process context with
`property_lock`. Not IRQ. Userspace reads sysfs (udev, UPower, desktop
power applets).

**Step 5.3: TRACE CALLEES**

Record: `isascii()`, `isprint()` only. No alloc, no locks, no I/O.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Firmware `_BIF`/`_BIX` → extract → sysfs `model_name` →
udev/hwdb/UPower. **Reachable on any ACPI-battery laptop at boot.**
Trigger is broken EC data on affected Lenovo (and similar) machines.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same `!isascii || !isprint` pattern in ath10k/11k/12k SMBIOS
BDF, ipw2100/2200, sound/ump. Kernel already sanitizes firmware strings
this way. This patch does **not** sanitize
`serial_number`/`type`/`oem_info` in the same driver.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `drivers/acpi/battery.c` has
`model_number[MAX_STRING_LENGTH]` (64), `extract_package()` `strscpy`
into it, and sysfs export via `POWER_SUPPLY_PROP_MODEL_NAME`. The bug is
unsanitized firmware text; that behavior is ancient. Approximate
introduction: ACPI battery driver **2.6 era (~2007)**. This 7.3 tree
already contains the fix (`git merge-base --is-ancestor 6587dd87595cfa
HEAD` → yes). Evaluation is still whether the **fix itself** belongs on
stable, not whether it is already applied here.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean/minor.** The hunk is a new helper + 4-line call +
include. `extract_battery_info()` surrounding quirk code
(`ACPI_BATTERY_QUIRK_*`) has been stable for years. Later 7.3-only
changes (`property_lock`, kfifo notify) sit **elsewhere** and are not
required. `for (unsigned int i = 0; ...)` is valid in current kernel C;
very old compilers on ancient LTS could need `unsigned int i;` moved out
— not an issue for this 7.3-based evaluation.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: This is the only `model_number` sanitization in `battery.c`. No
earlier equivalent fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **ACPI battery driver** (`drivers/acpi/battery.c`).
**IMPORTANT** for ACPI laptops (power sysfs, udev, UPower), not core
mm/VFS. Not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Moderately active (locking, notify coalescing, charge-status).
Mature driver; this is a firmware quirk, not a new subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver/hardware-specific.** ACPI battery users whose EC
returns garbage in the model string. Confirmed: **some Lenovo
platforms** (Mark Pearson). Red Hat authored it, so it showed up on a
distro kernel. Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Every boot on affected hardware (sysfs populated from
`_BIF`/`_BIX`). Unprivileged users can **read** `model_name`; they
cannot trigger a kernel crash. udev runs as root and fails to match.
Common on those machines, rare globally.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **Failure mode:** udev/hwdb/UPower cannot match `model_name` →
battery quirks, identification, and distro rules do not apply.
**Severity: MEDIUM** (functional userspace integration, not
oops/corruption/deadlock). Official stable rules explicitly include
**hardware quirks**.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** High for affected Lenovo/ACPI laptops on stable/LTS: hwdb
  and udev start working. Matches the hardware-quirk exception.
- **Risk:** Very low — 14 lines, no locking/alloc, truncates a firmware
  string already copied with `strscpy`.
- **Ratio:** Benefit outweighs risk for stable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real firmware bug on shipping Lenovo platforms (Lenovo Reviewed-by; “a
  few of our platforms”).
- Documented UPower/udev/hwdb breakage.
- Official stable rules: *“hardware quirk”* is an accepted class
  (`Documentation/process/stable-kernel-rules.rst`).
- 14 lines, single file, obviously correct, no new API.
- ACPI maintainer applied it; Lenovo reviewed it; Red Hat authored it.
- Driver and unsanitized `model_number` exist far back; no missing
  prerequisites.
- Same sanitization pattern as other firmware-string handling in-tree.

**AGAINST:**
- Not a crash, UAF, deadlock, or CVE.
- Changes userspace-visible `model_name` (intentional).
- Rafael labeled it “7.3 material,” not an explicit stable nomination.
- Userspace *could* strip the bytes (kernel is still the right place, as
  with other firmware sanitizers).
- Only `model_number` is cleaned.

**UNRESOLVED:**
- UPower work item body (GitLab 403).
- v1 review text beyond the v1/v2 diff (lore 403).
- Whether stable@ already discussed it (lore 403).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — bounded truncate; Lenovo
   review; maintainer applied.
2. Fixes a real bug that affects users? **PASS** — udev/hwdb/UPower fail
   on real Lenovo batteries.
3. Important issue? **PASS** as **hardware quirk** (explicitly listed in
   stable-kernel-rules.rst). Severity MEDIUM, not oops-level.
4. Small and contained? **PASS** — +14 lines, one file.
5. No new features or APIs? **PASS** — sanitizes an existing sysfs
   string.
6. Can apply to the local tree? **PASS** — driver and
   `extract_battery_info()` are present; hunk is self-contained.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **Hardware quirk / firmware workaround** (sanitize broken EC
model string). Analogous to USB/PCI/codec quirks: small, device-
specific, makes existing userspace matching work.

**Step 9.4: MAKE YOUR DECISION**

This is a small, reviewed firmware sanitization that fixes a real
udev/hwdb failure on Lenovo ACPI batteries. It is not a kernel crash,
but stable rules treat hardware quirks as in-scope, and the risk is very
low. It should be backported.

---

## What the commit solves and why it matters to stable users

On some systems the battery EC returns a model name with trailing non-
ASCII/unprintable bytes. That string is exported as
`/sys/class/power_supply/BAT0/model_name`. udev rules and hwdb match on
that attribute; garbage bytes prevent matches, so UPower and distro
battery quirks do not apply. Stable/LTS laptop users (enterprise,
Fedora, Ubuntu) stay on these kernels for years; they need the same
identification to work.

## Stable rules, risk vs benefit, concerns

Meets the written rules: obviously correct, real user-visible bug,
hardware quirk, 14 lines, no new API. Benefit is restored udev/hwdb
matching on affected machines; risk is a one-time sysfs string cleanup
with no locking or allocation. No extra commits are required. Later 7.3
battery locking/notify work is unrelated.

---

Verification:
- [Phase 1] Parsed tags: Reviewed-by Mark Pearson (Lenovo); SOB Kate
  Hsuan (Red Hat) and Rafael J. Wysocki; Link to UPower work item 345
  and patch.msgid v2; no Fixes:/Reported-by/Cc:stable
- [Phase 1] Body: example `LNV-5B10W51864` plus unprintable suffix;
  udev/hwdb matching failure
- [Phase 2] Diff: +14 `drivers/acpi/battery.c`; new
  `acpi_battery_clean_unprintable_chars()`; call in
  `extract_battery_info()` when `!result`; `#include <linux/ctype.h>`
- [Phase 2] Confirmed `isprint`/`isascii` in `include/linux/ctype.h`;
  `isprint('\0')` is false so loop stops at NUL
- [Phase 2] `MAX_STRING_LENGTH` is 64;
  `ARRAY_SIZE(battery->model_number)` matches
- [Phase 3] Blame: helper is 6587dd87595cfa; `extract_battery_info` from
  2d09af4a88d99a (2016); `strscpy` from a1a32ded2887fd (2023);
  model_number field long-standing
- [Phase 3] No Fixes: tag; git log on `drivers/acpi/battery.c` shows no
  prerequisite series
- [Phase 3] `git merge-base --is-ancestor 6587dd87595cfa HEAD` succeeded
  (commit is in this tree)
- [Phase 4] `b4 dig -c 6587dd87595cfa`: v2 at
  patch.msgid.link/20260710125122.1621877-1-hpa@redhat.com
- [Phase 4] `b4 dig -a`: v1 2026-07-08 (strip-in-place), v2 2026-07-10
  (truncate) — committed version is v2
- [Phase 4] `b4 dig -w`: Rafael, Len Brown, linux-acpi, Mark Pearson on
  the original To/Cc
- [Phase 4] b4 mbox: Pearson “impacts a few of our platforms”; Rafael
  “Applied as 7.3 material”; no NAK, no Cc:stable in thread
- [Phase 4] lore.kernel.org and GitLab 403 — UPower issue body and
  stable@ history UNVERIFIED
- [Phase 5] Callers: `acpi_battery_get_info` from `acpi_battery_update`,
  `acpi_battery_refresh`, `battery_notify`; property
  `POWER_SUPPLY_PROP_MODEL_NAME` → sysfs
- [Phase 5] Similar isascii/isprint sanitization in ath1x k SMBIOS and
  ipw2x00
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4
- [Phase 6] Parent of fix still copies `model_number` via `strscpy` with
  no sanitization
- [Phase 7] Subsystem ACPI battery; official rules quote: hardware quirk
  is in-scope
- [Phase 8] Failure mode: udev/hwdb mismatch, severity MEDIUM; not
  oops/UAF
- UNVERIFIED: UPower work item 345 details; v1 mailing-list review
  comments; any prior stable@ discussion

The patch is a 14-line firmware quirk that restores battery `model_name`
matching for real Lenovo hardware, with negligible regression risk.

**YES**

 drivers/acpi/battery.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 296c2981b1a73..0b922aceb28d1 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -10,6 +10,7 @@
 
 #define pr_fmt(fmt) "ACPI: battery: " fmt
 
+#include <linux/ctype.h>
 #include <linux/delay.h>
 #include <linux/dmi.h>
 #include <linux/jiffies.h>
@@ -486,6 +487,15 @@ static int acpi_battery_get_status(struct acpi_battery *battery)
 	return 0;
 }
 
+static void acpi_battery_clean_unprintable_chars(char *str, size_t length)
+{
+	for (unsigned int i = 0; i < length; i++) {
+		if (!isascii(str[i]) || !isprint(str[i])) {
+			str[i] = '\0';
+			break;
+		}
+	}
+}
 
 static int extract_battery_info(const int use_bix,
 			 struct acpi_battery *battery,
@@ -527,6 +537,10 @@ static int extract_battery_info(const int use_bix,
 	    battery->capacity_now > battery->full_charge_capacity)
 		battery->capacity_now = battery->full_charge_capacity;
 
+	if (!result)
+		acpi_battery_clean_unprintable_chars(battery->model_number,
+					ARRAY_SIZE(battery->model_number));
+
 	return result;
 }
 
-- 
2.53.0

