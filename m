Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E844A1DE4;
	Mon, 31 Aug 2026 13:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183711; cv=none; b=as6Ehv/ZEZS4dOplZWjpfAo0+m1G4lZR7vyGzwdchCEoD/BcP8zCBik2lNnhTop/9vei7wnctl6X3Spp3YgFy4hXIoKabCiUKB79JFMceBSiYNz1g90R2wqwLVpBP+00gefbGKLLY5PECT4MJf3A2FkGLipLJFkJSrO4qdyU0sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183711; c=relaxed/simple;
	bh=Mf+XDQmJ3GLD0O3FWsW1HEApNS8tZ8lipo0pn9jz9JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f9y+XBUeSx6JppPHZTb41qLOv/wLVIk4/ghR2NL/q4h4OY82JG7FygPW92OIKAtSg7VIhCHJBS867VIfEvvxVDRgEpTHQgqF9fsOvusw1Q+c1CSwthv9M35ejvFebUaN/L1IxJGicC6BXjG3Aek0+La7RFN4PXy9q6beRMU6JLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5wGLTVD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5wGLTVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6361F00A3D;
	Mon, 31 Aug 2026 13:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183708;
	bh=0puI6AC2zi7ajm0bcycLnHdreti5gQNocxx6GAoqLLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5wGLTVDUaIk+7XWkZxpN42Zn+uAR5mZw737S5+en0jyKWeizYKwWARec1rmtZ/xP
	 5r3vPncfIvWfuRiDp1yvtlR15IpwixgraAkM4c7sutfwVHe6AAM47cdBz91pOA3qWd
	 16TIxpfOHUTKCLVT9wsOG7EfKbB7Cb/rwcEGSepUBb+WyHEPTxmja7z5DuYSNXR3bw
	 aNF82ujSmTdTdMyYlvmP/F6y74E7jGcJ4kwe0iO4ZAd0xg10jt7MSaI5YYXN6nomb4
	 +p/LnFIn5SPpopW92uVMMU7gLimTPaJYvVPWv3TmzA9+g1j9oyPZ4+u21PGymoNn2F
	 10HVg/JXHmlOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Marco Scardovi <scardracs@disroot.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	westeri@kernel.org,
	andriy.shevchenko@linux.intel.com,
	linusw@kernel.org,
	brgl@kernel.org,
	linux-gpio@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] gpiolib: acpi: Add robust bounds-checking for GPIO pin resources
Date: Mon, 31 Aug 2026 09:24:45 -0400
Message-ID: <20260831133314.4125787-257-sashal@kernel.org>
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

From: Marco Scardovi <scardracs@disroot.org>

[ Upstream commit dece79032f529d2c9fdbf63a9f2fc32244722775 ]

Ensure that GPIO pin resource arrays are safely bounded before accessing
indices. Add explicit bounds checking in acpi_request_own_gpiod(),
acpi_gpio_irq_is_wake(), and acpi_gpiochip_alloc_event() to prevent
out-of-bounds array reads if the ACPI namespace provides malformed or empty
pin tables.

This change addresses potential safety issues arising from
inconsistent or invalid ACPI pin tables. It does not alter functional
behavior in well-formed tables.

Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Marco Scardovi <scardracs@disroot.org>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/20260610154204.110379-2-scardracs@disroot.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[gpiolib: acpi] [add] Add robust bounds-checking for GPIO
pin resources` — defensive hardening in the ACPI GPIO core to validate
`pin_table` indices before array access.

### Step 1.2: Commit Message Tags
**Record:**
- **Acked-by:** Mika Westerberg `<mika.westerberg@linux.intel.com>`
  (GPIO/ACPI maintainer)
- **Link:**
  https://patch.msgid.link/20260610154204.110379-2-scardracs@disroot.org
- **Signed-off-by:** Marco Scardovi, Bartosz Golaszewski (gpiolib
  maintainer)
- **Assisted-by:** Antigravity:gemini-3.5-flash
- **No** Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org,
  syzbot links

Notable: maintainer ack, but no fuzzer report or explicit stable
nomination.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** Three functions access `agpio->pin_table[]` without verifying
  `pin_table_length` first.
- **Symptom:** Out-of-bounds array reads when ACPI firmware provides
  empty or malformed GPIO pin tables.
- **Failure mode:** OOB read of `pin_table`; no change for well-formed
  tables.
- **Root cause:** Missing bounds checks in helper functions
  extracted/consolidated over years; one lookup path (line 719) already
  checks, but event/wakeup helpers do not.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — labeled as “robust bounds-checking” but is a real
memory-safety fix (out-of-bounds read prevention), not cosmetic cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/gpio/gpiolib-acpi-core.c` (+19 / -4, ~23 lines
  touched)
- **Functions:** `acpi_request_own_gpiod()`, `acpi_gpio_irq_is_wake()`,
  `acpi_gpiochip_alloc_event()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Changes
**Record:**
1. **`acpi_request_own_gpiod()`:** Before → directly indexed
   `agpio->pin_table[index]`. After → returns `ERR_PTR(-EINVAL)` if
   `index >= pin_table_length`, then accesses table.
2. **`acpi_gpio_irq_is_wake()`:** Before → read `pin_table[0]`
   unconditionally. After → returns `false` if `pin_table_length == 0`.
3. **`acpi_gpiochip_alloc_event()`:** Before → read `pin_table[0]` after
   IRQ-resource check. After → returns `AE_OK` early if
   `pin_table_length == 0`.

### Step 2.3: Bug Mechanism
**Record:** **Category:** Buffer overflow / out-of-bounds read.
**Mechanism:** `pin_table_length` can be 0 (or `index` can be out of
range) while code still indexes `pin_table[]`, reading memory past the
allocated ACPI resource buffer.

### Step 2.4: Fix Quality
**Record:** Obviously correct, minimal, matches existing pattern at line
719 in the same file. Low regression risk — only affects malformed/empty
tables; well-formed tables unchanged. `acpi_gpiochip_alloc_event()`
already treats most failures as non-fatal (`AE_OK`), consistent with new
early return.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- `acpi_request_own_gpiod()` unbounded access since `2e2b496cebefb` (Nov
  2020)
- `acpi_gpio_irq_is_wake()` unbounded `[0]` access since
  `0c2cae09a765b1` (Mar 2022)
- `acpi_gpiochip_alloc_event()` unbounded `[0]` access since
  `6072b9dcf97870` (Mar 2014)
- All present in this 6.18.y tree

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related File History
**Record:** Recent related fix in same file: `f749b366b8e79` “Fix
potential out-of-boundary left shift” (backported to stable with `Cc:
stable`). This commit is patch 1/2 of a v6 series; patch 2/2 hardens the
OperationRegion handler separately and is **not** required for this
patch to apply or function.

### Step 3.4: Author Context
**Record:** Marco Scardovi is a contributor (Rockchip GPIO fixes); not
the subsystem maintainer. Patch was acked by Mika Westerberg.

### Step 3.5: Dependencies
**Record:** Standalone. No prerequisite commits. Patch 2/2 is
complementary but independent. Applies cleanly to current `gpiolib-acpi-
core.c` in this tree.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** Part of `[PATCH v6 0/2]` series submitted June 10, 2026.
Patch 1/2 is this commit. `b4 shazam` could not find it on lore (likely
too new for index). Web search found lkml/spinics archives confirming
content and v6 cover letter. lore.kernel.org direct fetch blocked by bot
protection.

### Step 4.2: Reviewers
**Record:** v6 cover letter CCs Mika Westerberg, Andy Shevchenko, Linus
Walleij, Bartosz Golaszewski, linux-gpio@, linux-acpi@. Acked-by from
Mika Westerberg in committed version.

### Step 4.3: Bug Reports
**Record:** No syzbot, bugzilla, or user crash reports. Issue identified
by code review / defensive analysis of ACPI edge cases.

### Step 4.4: Series Context
**Record:** 2-patch series. This patch covers
event/wakeup/`acpi_request_own_gpiod` paths. Patch 2/2 covers
OperationRegion handler bounds (not in this tree yet). This patch is
self-contained.

### Step 4.5: Stable List History
**Record:** No stable-list discussion found. Absence of `Cc: stable` is
expected per review instructions.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `acpi_request_own_gpiod`, `acpi_gpio_irq_is_wake`,
`acpi_gpiochip_alloc_event`

### Step 5.2: Callers
**Record:**
- `acpi_gpiochip_alloc_event` → called from
  `acpi_gpiochip_request_interrupts()` via `acpi_walk_resources()` on
  `_AEI`
- `acpi_gpiochip_request_interrupts()` → called from
  `gpiochip_irqchip_add()` in `gpiolib.c` during every GPIO chip IRQ
  setup
- `acpi_request_own_gpiod` → called from `acpi_gpiochip_alloc_event()`
  (index 0) and OpRegion handler (index `i` in bounded loop at line
  1113)
- `acpi_gpio_irq_is_wake` → called from `acpi_gpiochip_alloc_event()`
  (line 445) and ACPI GPIO lookup callback (line 731, after existing
  bounds check at 719)

### Step 5.3: Callees
**Record:** `gpiochip_request_own_desc`, `acpi_gpio_in_ignore_list`,
`acpi_get_handle`, `gpiochip_lock_as_irq`, etc. — standard GPIO/ACPI
operations during probe and event registration.

### Step 5.4: Reachability
**Record:** Triggered during GPIO controller registration on **every
ACPI platform** at boot (`CONFIG_ACPI` + GPIO chip with IRQ support).
Not directly userspace-triggerable, but firmware ACPI tables are the
input. Malformed `_AEI` GPIO resources with `pin_table_length == 0` hit
`acpi_gpiochip_alloc_event` on every affected chip probe.

### Step 5.5: Similar Patterns
**Record:** Line 719 already has `if (pin_index >=
agpio->pin_table_length) return 1;` in the lookup path — this patch
closes the same gap in the event/wakeup helpers. OpRegion loop uses
`min_t(u16, agpio->pin_table_length, pin_index + bits)` but still calls
`acpi_request_own_gpiod` without its own index guard.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Local tree is **v6.18.44** (`VERSION=6,
PATCHLEVEL=18, SUBLEVEL=44`). All three functions lack the proposed
bounds checks (verified by reading current file). Bug dates to 2014–2020
code still present.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Single hunk in one file, no
structural divergence. No conflicting recent changes in these functions.

### Step 6.3: Related Fixes Already Present?
**Record:** Partial protection exists in ACPI GPIO lookup (line 719) and
OpRegion loop (line 1113), but **not** in the three functions this
commit fixes. The proposed fix is **not** already present.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/gpio/gpiolib-acpi-core.c` — **IMPORTANT**
subsystem. ACPI GPIO core used on x86 laptops/servers and ACPI-enabled
ARM platforms during device enumeration and interrupt setup.

### Step 7.2: Activity
**Record:** Actively maintained; recent stable-relevant fixes in same
file (e.g., `f749b366` OOB/UB fix backported to stable).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** ACPI systems with GPIO controllers (`CONFIG_ACPI` +
`CONFIG_GPIOLIB`). All such platforms traverse this code at GPIO chip
registration.

### Step 8.2: Trigger Conditions
**Record:** Malformed or empty ACPI GPIO pin tables in `_AEI` resources
or other GPIO resource descriptors. Uncommon but plausible with buggy
firmware. Not unprivileged-userspace-triggerable; firmware-dependent.

### Step 8.3: Failure Mode Severity
**Record:** Out-of-bounds kernel read → **MEDIUM-HIGH**. On KASAN
builds: detectable memory safety bug. On production: may read adjacent
memory (garbage pin number, possible mis-driven GPIO or further errors).
Unlikely to panic in all cases, but real safety defect in a core boot
path.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Closes longstanding OOB-read holes in ACPI GPIO
  event/wakeup path; aligns with existing bounds check at line 719;
  precedent from `f749b366` in same file.
- **Risk:** Very low — ~15 lines of early-return guards, no API/behavior
  change for valid tables.
- **Ratio:** Favorable for stable.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real out-of-bounds read bug in core ACPI GPIO code present since
  2014–2020
- Affects boot-time GPIO/ACPI event setup on all ACPI platforms
- Small, surgical, maintainer-acked fix
- Buggy code confirmed in v6.18.44 tree; fix applies cleanly
- Consistent with prior stable backport of OOB fix in same file
  (`f749b366`)
- Defense-in-depth where partial checks already exist but are incomplete

**AGAINST backport:**
- No syzbot/user crash reports
- Requires malformed ACPI firmware (uncommon trigger)
- Patch 1/2 of a series (though standalone)
- Impact on production kernels without KASAN may be limited to reading
  garbage rather than immediate crash

**Unresolved:** No direct lore thread review comments retrieved (lore
blocked); no runtime crash evidence.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — straightforward bounds
   checks; maintainer acked
2. Fixes a real bug? **PASS** — OOB array access on empty/malformed pin
   tables
3. Important issue? **PASS** — memory safety / OOB read in core boot
   path (MEDIUM-HIGH severity)
4. Small and contained? **PASS** — one file, ~19 lines added
5. No new features/APIs? **PASS** — pure defensive validation
6. Can apply to local tree? **PASS** — buggy code present, clean apply
   expected

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
memory-safety bug fix.

### Step 9.4: Decision Rationale

For **this v6.18.44 tree**, the unbounded `pin_table[]` accesses have
been present for years in code that runs during GPIO chip registration
on every ACPI machine. The fix is minimal, obviously correct,
maintainer-reviewed, and closes a real out-of-bounds read class that
partial existing checks do not cover (especially
`acpi_gpiochip_alloc_event` reading `pin_table[0]` before any length
validation). While no crash report was found, stable trees routinely
accept such defensive fixes in core subsystems — particularly when a
nearly identical class of fix was already backported in the same file.
Risk of regression is negligible.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
- **[Phase 1]** Confirmed no Fixes:/Reported-by:/Cc: stable tags
- **[Phase 2]** Analyzed diff: 3 functions, +19/-4 lines in `gpiolib-
  acpi-core.c`
- **[Phase 3]** `git describe HEAD` → `v6.18.44-1-g2736c32da98b9`;
  Makefile → 6.18.44
- **[Phase 3]** `git blame` on lines 318–372: buggy code from 2014–2022
  commits, all in tree
- **[Phase 3]** `git show f749b366b8e79`: related OOB fix in same file,
  Cc: stable, already in tree
- **[Phase 3]** `git log --oneline -20 -- drivers/gpio/gpiolib-acpi-
  core.c`: no duplicate fix present
- **[Phase 4]** `b4 shazam` / `b4 dig`: patch not indexed on lore yet
- **[Phase 4]** Web search: confirmed v6 0/2 series, patch 1/2 content,
  maintainer CC list
- **[Phase 4]** WebFetch lore/patch.msgid.link: blocked/timeout — review
  comments unverified
- **[Phase 5]** `grep acpi_gpio_irq_is_wake`: callers at lines 445, 731
- **[Phase 5]** `grep acpi_gpiochip_request_interrupts`: called from
  `gpiolib.c:2131` during IRQ chip add
- **[Phase 5]** Read `gpiolib-acpi-core.c` lines 280–460, 700–750,
  1095–1200: confirmed missing bounds checks and existing partial checks
  at 719/1113
- **[Phase 6]** Read current tree code: all three functions lack
  proposed guards
- **[Phase 6]** Confirmed patch 2/2 (OpRegion) not in tree; patch 1/2 is
  independent
- **[Phase 7]** Subsystem: ACPI GPIO core, IMPORTANT criticality
- **[Phase 8]** Failure mode: OOB read, MEDIUM-HIGH; trigger: malformed
  ACPI firmware at boot

**YES**

 drivers/gpio/gpiolib-acpi-core.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi-core.c b/drivers/gpio/gpiolib-acpi-core.c
index 8851e48669756..eb14351afef90 100644
--- a/drivers/gpio/gpiolib-acpi-core.c
+++ b/drivers/gpio/gpiolib-acpi-core.c
@@ -320,10 +320,17 @@ static struct gpio_desc *acpi_request_own_gpiod(struct gpio_chip *chip,
 						unsigned int index,
 						const char *label)
 {
-	int polarity = GPIO_ACTIVE_HIGH;
-	enum gpiod_flags flags = acpi_gpio_to_gpiod_flags(agpio, polarity);
-	unsigned int pin = agpio->pin_table[index];
+	enum gpiod_flags flags;
 	struct gpio_desc *desc;
+	unsigned int pin;
+	int polarity;
+
+	if (index >= agpio->pin_table_length)
+		return ERR_PTR(-EINVAL);
+
+	pin = agpio->pin_table[index];
+	polarity = GPIO_ACTIVE_HIGH;
+	flags = acpi_gpio_to_gpiod_flags(agpio, polarity);
 
 	desc = gpiochip_request_own_desc(chip, pin, label, polarity, flags);
 	if (IS_ERR(desc))
@@ -337,7 +344,12 @@ static struct gpio_desc *acpi_request_own_gpiod(struct gpio_chip *chip,
 static bool acpi_gpio_irq_is_wake(struct device *parent,
 				  const struct acpi_resource_gpio *agpio)
 {
-	unsigned int pin = agpio->pin_table[0];
+	unsigned int pin;
+
+	if (agpio->pin_table_length == 0)
+		return false;
+
+	pin = agpio->pin_table[0];
 
 	if (agpio->wake_capable != ACPI_WAKE_CAPABLE)
 		return false;
@@ -367,6 +379,9 @@ static acpi_status acpi_gpiochip_alloc_event(struct acpi_resource *ares,
 	if (!acpi_gpio_get_irq_resource(ares, &agpio))
 		return AE_OK;
 
+	if (agpio->pin_table_length == 0)
+		return AE_OK;
+
 	handle = ACPI_HANDLE(chip->parent);
 	pin = agpio->pin_table[0];
 
-- 
2.53.0

