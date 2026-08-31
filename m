Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1DA5A9863;
	Mon, 31 Aug 2026 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184357; cv=none; b=qC66OVL1SYvM9+mwMbp6foQpgJmO2jcIiGHLze5T0sfQCPnKN3HCoWOZZ9R72UZ5KZgMEOD44L7BlUgP54A8ApW9BGyAkF5l50uOix3FDW40bjMvRHnHApjQYnndBEsDg29z+2qxTYV78ZTlUgjm5UowhF+xCJqEH1k8a4gqAEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184357; c=relaxed/simple;
	bh=e5NWV2lVHPe31HAmSegpbuRCDj+ks/W1pbfMn3crol8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ya/G0Q+h1X1XQzDRfEWCxtm+YNY20QiyXQMM8Om3g6yCT2+XMTvYPDmnxMXjrGFsNlqaLX83vWbmV8Aw1Mi1RBS8YziCtX6TH+bW5KQarpGdZP4/0qNt+DyM+xUd6OIvSXrez3KhRihq7Fl/nitMjB0i34huljevA5AB41OgPCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ooeoN+kj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ooeoN+kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF6D1F000E9;
	Mon, 31 Aug 2026 13:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184355;
	bh=m+J7GktUYJ8sch1IMbeEsWpp+FPWHxVGIcuswDtlVtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooeoN+kjx/457ltvxssav/NkUao40IWBoj8FRPQIpjTA20CVPJeoYP70B3vdipRIl
	 PUIugXKJhUZm2+ep5PZfuQhI7gSv4nAf/lKmfZHNh4WcUcS7CC7lmly4Ku5tOWtbyu
	 ZUCzjnXVJzwukyU5kMTGjRzy378CKvfNdHS0KYfpUUAbZkp1383lvs0P6uSoo/hfFQ
	 qqwlgfYRr7iLJ8/i5JocQU4qXIf98zZdeWmO1HCPjW+qTIteeFwADdiGZ59/B6gOaR
	 7CoOi4x0s+pv1FjLiGOyB7OHGu4oo5n1ZhqMyyxRpllN/2M3bx9VKZScjILa25ubv0
	 d6Chb1LXfGoyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Titouan Ameline de Cadeville <titouan.ameline@gmail.com>,
	Julius Werner <jwerner@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	chrome-platform@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] firmware: google: Add bounds checks in coreboot_table_populate()
Date: Mon, 31 Aug 2026 09:31:12 -0400
Message-ID: <20260831133314.4125787-644-sashal@kernel.org>
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

From: Titouan Ameline de Cadeville <titouan.ameline@gmail.com>

[ Upstream commit 7b1a1af4556a4f95ef273e91435fe804cbfcd223 ]

coreboot_table_populate() iterates over firmware-provided table entries
with no validation that the entries stay within the mapped memory
region.  A corrupt table with a large `entry->size` advances `ptr_entry`
past the mapped region, causing an out-of-bounds read on the next
iteration.

Add a check before dereferencing `ptr_entry` to ensure the entry header
is readable, and a second check after reading `entry->size` to ensure
the full entry stays within the mapped region.

Pass `len` from coreboot_table_probe() into coreboot_table_populate() to
make the mapped region size available for validation.

Signed-off-by: Titouan Ameline de Cadeville <titouan.ameline@gmail.com>
Reviewed-by: Julius Werner <jwerner@chromium.org>
Link: https://lore.kernel.org/r/20260426214739.117131-1-titouan.ameline@gmail.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `firmware: google: Add bounds checks in
coreboot_table_populate()`

**Local tree:** Linux **6.18.43** (`git describe HEAD` → `v6.18.43`,
Makefile `6.18.43`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse Subject Line
**Record:** `[firmware: google]` `[add]` — Add bounds checks in
`coreboot_table_populate()` to validate firmware table entries stay
within the mapped region.

### Step 1.2: Parse All Commit Message Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Titouan Ameline de Cadeville
\<titouan.ameline@gmail.com\> (author) |
| Reviewed-by | Julius Werner \<jwerner@chromium.org\> (Chromium/Google
firmware maintainer) |
| Link | https://lore.kernel.org/r/20260426214739.117131-1-
titouan.ameline@gmail.com |
| Signed-off-by | Tzung-Bi Shih \<tzungbi@kernel.org\> (firmware
maintainer) |

**Notable patterns:** Reviewed by a Chromium firmware maintainer. No
`Fixes:`, `Reported-by:`, `Cc: stable`, or syzbot tags. Absence of
stable tags is expected per pipeline rules.

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** `coreboot_table_populate()` walks firmware-provided table
  entries without verifying each entry fits inside the memremapped
  region.
- **Symptom:** A corrupt entry with a large `entry->size` advances
  `ptr_entry` past the mapped end; the next iteration dereferences past
  the mapping → out-of-bounds read. `memcpy(device->raw, ptr_entry,
  entry->size)` can also read past the mapping on the current entry.
- **Root cause:** No upper-bound validation against mapped length; only
  a minimum-size check (`entry->size < sizeof(*entry)`) existed.
- **Fix approach:** Pass `len` from `coreboot_table_probe()` into
  `coreboot_table_populate()`; check header readability and full entry
  containment before use.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised — explicitly an OOB-read / memory-safety fix,
though described as "add bounds checks" rather than "fix OOB read."

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory Changes
**Record:**
- **File:** `drivers/firmware/google/coreboot_table.c` only
- **Scope:** ~10 lines added, 2 signature lines changed — single-file
  surgical fix
- **Functions modified:** `coreboot_table_populate()`,
  `coreboot_table_probe()` (call site only)

### Step 2.2: Code Flow Change (per hunk)

**Hunk 1 — `coreboot_table_populate()`:**
- **Before:** Loop over `header->table_entries`; dereference `entry =
  ptr_entry` with no end-of-region check; advance `ptr_entry +=
  entry->size` unconditionally.
- **After:** Compute `ptr_end = ptr + len`; before dereferencing, verify
  `ptr_entry + sizeof(*entry) <= ptr_end`; after reading `entry->size`,
  verify `ptr_entry + entry->size <= ptr_end`; return `-EINVAL` on
  violation.

**Hunk 2 — `coreboot_table_probe()`:**
- **Before:** `coreboot_table_populate(dev, ptr)`
- **After:** `coreboot_table_populate(dev, ptr, len)` where `len =
  header->header_bytes + header->table_bytes`

**Record:** Normal boot probe path and error path both affected; no
change to remove/teardown paths.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds access (memory safety)
- **Mechanism:** Firmware-controlled `entry->size` and
  `header->table_entries` can describe a layout larger than the
  memremapped `[ptr, ptr+len)` region. The loop trusts per-entry sizes
  without summing or bounding against `len`. Corrupt or malicious table
  data causes reads past the mapping on `entry` dereference and in
  `memcpy()`. A very large `entry->size` also drives
  `kzalloc(sizeof(device->dev) + entry->size)` before the bounds check
  in the unpatched code.

### Step 2.4: Fix Quality
**Record:**
- Fix is minimal and obviously correct: standard `ptr_end` bounds
  pattern.
- Returns `-EINVAL` on bad data — consistent with existing `entry->size
  < sizeof(*entry)` handling.
- **Regression risk:** Very low. Only adds validation on a firmware-
  parsing path; no locking, no API changes.
- **Minor note:** `header->header_bytes + header->table_bytes` is still
  trusted from firmware (pre-existing); this fix bounds entry iteration
  within that self-reported length, which is the right scope.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame Changed Lines
**Record:** `git blame` on `coreboot_table_populate()` attributes all
lines to `19eef1d98eeda` (an unrelated AFS commit) due to history
squashing in this stable tree — not reliable for origin dating. `git log
--follow` shows the vulnerable function present at `ac3fd01e4c1ef`
("Linux 6.18-rc7") with identical logic. **Buggy code exists throughout
the 6.18.y series in this checkout.**

### Step 3.2: Follow Fixes: Tag
**Record:** No `Fixes:` tag present — step N/A.

### Step 3.3: File History for Related Changes
**Record:** Recent `drivers/firmware/google/` history in this tree:
- `75d40ccf38ca7` — framebuffer probe cleanup
- `ecb3e4fa31ffa` — framebuffer busy flag fix
- No prior bounds-check fix for `coreboot_table.c`. **Standalone fix,
  not part of a series.**

### Step 3.4: Author's Other Commits
**Record:** No commits by Titouan Ameline in `drivers/firmware/google/`
in this tree. Author appears to be a new contributor to this subsystem;
patch was reviewed by Julius Werner (Chromium).

### Step 3.5: Prerequisites / Dependencies
**Record:** No dependencies. The patch only needs `coreboot_table.c` as
it exists in this tree. `resource_size_t len` is already used in
`coreboot_table_probe()`. **Applies standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig -c <commit>` not possible — commit is not in this
checkout. `WebFetch` and `curl` to lore.kernel.org returned 403/bot-
wall. **Lore thread content UNVERIFIED.** Commit message provides Link
and `Reviewed-by: Julius Werner`.

### Step 4.2: Reviewers
**Record:** Julius Werner (Chromium firmware) reviewed. Tzung-Bi Shih
committed. Appropriate subsystem coverage assumed from tags; full
recipient list UNVERIFIED.

### Step 4.3: Bug Report
**Record:** No `Reported-by:`, no syzbot link, no stack trace in commit
message. Bug identified by code review / defensive analysis, not a filed
crash report.

### Step 4.4: Related Patches / Series
**Record:** Single-patch fix. No series dependencies.

### Step 4.5: Stable Mailing List History
**Record:** UNVERIFIED — could not search lore stable list due to access
restrictions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `coreboot_table_populate()`, `coreboot_table_probe()`

### Step 5.2: Callers
**Record:**
- `coreboot_table_populate()` — called only from
  `coreboot_table_probe()` (verified via grep)
- `coreboot_table_probe()` — platform driver `.probe` for
  `coreboot_table_driver`, registered at module init

**Context:** Runs once at boot when `CONFIG_GOOGLE_COREBOOT_TABLE` is
enabled, on ACPI `GOOGCB00` / `BOOT0000` or OF `compatible = "coreboot"`
platforms (Chromebooks, Chromium embedded boards).

### Step 5.3: Callees
**Record:** `memremap()`, `memunmap()`, `kzalloc()`, `memcpy()`,
`device_register()`, `dev_warn()` — memory mapping and device
enumeration from firmware table.

### Step 5.4: Call Chain / Reachability
**Record:**
```
module_init → platform_driver_register → coreboot_table_probe (ACPI/OF
match)
  → memremap firmware table → coreboot_table_populate → iterate entries
```
- **Userspace trigger:** Not directly syscall-reachable.
- **Indirect trigger:** Corrupt or attacker-modified coreboot table in
  firmware flash or ACPI-described memory region.
- **Affected platforms:** Google Chromebooks and other coreboot/Chromium
  devices with `CONFIG_GOOGLE_FIRMWARE` / `CONFIG_GOOGLE_COREBOOT_TABLE`
  (e.g. `arch/arm64/configs/defconfig` has both enabled).

### Step 5.5: Similar Patterns
**Record:** This stable tree has already accepted similar firmware OOB
fixes:
- `cf5708c9d78c9` — `firmware: arm_ffa: Fix out-of-bound writes`
- `11daac2817dca` — `firmware: arm_scmi: Fix OOB in
  scmi_power_name_get()`

Precedent supports firmware-parser bounds-check backports to 6.18.y.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Does Buggy Code Exist?
**Record:** **YES.** Current `drivers/firmware/google/coreboot_table.c`
lines 104–147 contain the vulnerable loop with no `ptr_end` checks.
Identical logic confirmed at `ac3fd01e4c1ef` (6.18-rc7). Fix is **not**
already present (grep found no `ptr_end` or bounds-check commit).

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Local file matches the patch's
pre-change structure exactly (function signature, loop body, probe call
site). No conflicting refactors in recent history.

### Step 6.3: Related Fixes Already Present?
**Record:** **None** for this bug. Grep for `coreboot_table_populate`
bounds fixes returned nothing.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/firmware/google/` — **PERIPHERAL** (platform-
specific Google/coreboot firmware driver). Not core kernel, but used on
production Chromebook fleet when enabled.

### Step 7.2: Subsystem Activity
**Record:** Moderate activity in this tree (recent framebuffer probe
fixes). `coreboot_table.c` itself has been stable since 6.18-rc7 with no
prior hardening.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** **Platform-specific, config-dependent** — systems with
`CONFIG_GOOGLE_COREBOOT_TABLE` (Chromebooks, Chromium ARM boards, some
x86 Google platforms). Not universal; significant within that fleet.

### Step 8.2: Trigger Conditions
**Record:**
- Corrupt coreboot table: flash wear/corruption, buggy coreboot build,
  or compromised firmware
- Mismatch between `table_entries`/per-entry `size` fields and actual
  mapped `len`
- **Likelihood:** Low in normal operation; non-zero with flash
  corruption or firmware bugs
- **Unprivileged userspace:** Cannot trigger directly; requires
  firmware-level corruption

### Step 8.3: Failure Mode Severity
**Record:**
- OOB read on `entry` dereference → possible page fault / kernel oops at
  boot
- OOB read in `memcpy()` → information leak from adjacent mapped memory
- Unchecked large `entry->size` → excessive `kzalloc()` attempt (boot-
  time DoS / OOM)
- **Severity: HIGH** for affected platforms (boot failure or memory-
  safety violation), **LOW** population-wide

### Step 8.4: Risk-Benefit Ratio
**Record:**
- **Benefit:** Prevents OOB reads and unbounded allocation on a firmware
  trust boundary; hardens boot on Chromebook/coreboot systems. Aligns
  with existing stable practice (arm_ffa, arm_scmi OOB backports in this
  tree).
- **Risk:** Very low — ~10 lines of validation, no behavior change on
  valid tables.
- **Ratio:** Favorable for backport to this tree.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, verifiable OOB-read bug in firmware table parser
- Small, surgical, obviously correct fix
- Buggy code present in Linux 6.18.43 checkout
- Clean apply, no dependencies
- Reviewed by Chromium firmware maintainer
- Precedent: similar `firmware:` OOB fixes already in this 6.18.y tree
- Prevents boot-time crash and unbounded allocation on corrupt firmware
  data

**AGAINST backport:**
- No syzbot report or user crash report
- Trigger requires corrupt/malicious firmware table (not common)
- Platform-specific driver behind `CONFIG_GOOGLE_COREBOOT_TABLE`
  (default N in Kconfig)
- Boot-only path, not directly userspace-exploitable
- Lore review thread content could not be fetched

**Unresolved:** Full lore discussion content; whether reviewers
explicitly nominated for stable.

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — standard bounds checks;
reviewed by subsystem expert |
| 2. Fixes a real bug affecting users? | **PASS** — OOB read on corrupt
firmware table on Chromebook/coreboot systems |
| 3. Important issue? | **PASS** — OOB access / potential boot crash
(HIGH on affected platforms) |
| 4. Small and contained? | **PASS** — one file, ~10 lines |
| 5. No new features/APIs? | **PASS** — validation only, static function
signature change |
| 6. Can apply to local tree? | **PASS** — code present, clean apply
expected |

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Qualifies
as a memory-safety / OOB fix on its own merits.

### Step 9.4: Decision Rationale

For **Linux 6.18.y** specifically: the vulnerable
`coreboot_table_populate()` loop exists in this checkout, the fix is
self-contained and low-risk, and it addresses a genuine out-of-bounds
read when parsing firmware-provided table entries. While the trigger
(corrupt coreboot table) is uncommon and the driver is platform-
specific, the fix matches stable-tree practice already established in
this same tree for firmware OOB issues, and failure modes include boot-
time kernel faults and unbounded allocation from attacker-influenced
firmware fields. The conservative stable choice here is to include the
hardening.

---

## Verification

- **[Phase 1]** Parsed commit message from user query: subsystem, tags,
  bug description recorded
- **[Phase 2]** Read `drivers/firmware/google/coreboot_table.c`:
  confirmed vulnerable loop at lines 104–147, no `ptr_end` checks
- **[Phase 2]** Diff analysis: two bounds checks + `len` parameter pass-
  through verified against local file
- **[Phase 3]** `git describe HEAD` → `v6.18.43`; Makefile → 6.18.43
- **[Phase 3]** `git blame` on `coreboot_table_populate()`: squashed
  history (unreliable origin)
- **[Phase 3]** `git log --follow` on file: vulnerable code at
  `ac3fd01e4c1ef` (Linux 6.18-rc7)
- **[Phase 3]** `git log --oneline -20 --
  drivers/firmware/google/coreboot_table.c`: limited history due to
  stable tree squash
- **[Phase 3]** No `Fixes:` tag; no prerequisite commits found
- **[Phase 4]** `b4 dig -c` failed — commit not in local repo
- **[Phase 4]** `WebFetch` lore URL → bot wall; `curl` raw lore → 403.
  **Lore content UNVERIFIED**
- **[Phase 5]** `grep coreboot_table_populate`: only caller is
  `coreboot_table_probe()`
- **[Phase 5]** Read Kconfig: `GOOGLE_COREBOOT_TABLE` depends on
  `HAS_IOMEM && (ACPI || OF)`
- **[Phase 5]** `arch/arm64/configs/defconfig`:
  `CONFIG_GOOGLE_FIRMWARE=y`, `CONFIG_GOOGLE_COREBOOT_TABLE=m`
- **[Phase 5]** Precedent: `cf5708c9d78c9`, `11daac2817dca` firmware OOB
  fixes in this tree
- **[Phase 6]** Buggy code confirmed present; fix not present (`grep
  ptr_end` → no match in coreboot_table.c)
- **[Phase 6]** Local file structure matches patch base — clean apply
  expected
- **[Phase 8]** Failure mode: OOB read / boot oops / kzalloc abuse —
  severity HIGH on affected platforms

**YES**

 drivers/firmware/google/coreboot_table.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/google/coreboot_table.c b/drivers/firmware/google/coreboot_table.c
index 882db32e51be9..f212b84ee2f93 100644
--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -101,16 +101,20 @@ void coreboot_driver_unregister(struct coreboot_driver *driver)
 }
 EXPORT_SYMBOL(coreboot_driver_unregister);
 
-static int coreboot_table_populate(struct device *dev, void *ptr)
+static int coreboot_table_populate(struct device *dev, void *ptr, resource_size_t len)
 {
 	int i, ret;
 	void *ptr_entry;
 	struct coreboot_device *device;
 	struct coreboot_table_entry *entry;
 	struct coreboot_table_header *header = ptr;
+	void *ptr_end;
 
+	ptr_end = ptr + len;
 	ptr_entry = ptr + header->header_bytes;
 	for (i = 0; i < header->table_entries; i++) {
+		if (ptr_entry + sizeof(*entry) > ptr_end)
+			return -EINVAL;
 		entry = ptr_entry;
 
 		if (entry->size < sizeof(*entry)) {
@@ -118,6 +122,9 @@ static int coreboot_table_populate(struct device *dev, void *ptr)
 			return -EINVAL;
 		}
 
+		if (ptr_entry + entry->size > ptr_end)
+			return -EINVAL;
+
 		device = kzalloc(sizeof(device->dev) + entry->size, GFP_KERNEL);
 		if (!device)
 			return -ENOMEM;
@@ -183,7 +190,7 @@ static int coreboot_table_probe(struct platform_device *pdev)
 	if (!ptr)
 		return -ENOMEM;
 
-	ret = coreboot_table_populate(dev, ptr);
+	ret = coreboot_table_populate(dev, ptr, len);
 
 	memunmap(ptr);
 
-- 
2.53.0

