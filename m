Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBC154A7C9;
	Mon, 31 Aug 2026 13:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183994; cv=none; b=YVFR3jn66N5q4vMRomAEyohLZ1oWyttgHIbkvwBTXugiXpFP6b2VR/mIA2wd56m4uNYQ3MWGi1Zh/2isg0Y2+5eolI6WxlH3HxaJ/ldrKk0tcGtiuC4iNTMt8uhd8TjvGyhqYIqTWun6BRHNCbewaGXFyT379YI44RBVxL1d9UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183994; c=relaxed/simple;
	bh=1xBuQ0gZEAHbXJOSDdQNZveaw4f/7BN3YmUO2jb/O/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ME3cd9YxIzogobku5CaBgfQpIk/2e6kCLKi2eIZsbH7SaMPF8iGVlTgTF2Ny/hyj0Fztc+UCC8/4LsFEa4xUIRAPA8Ma1mb7qLwC8AicEu/FOijz+oiNBCHrWnNb9sOUNHPkutbpru0vQ6XuctBRRaHErBh45QCiP2UViaOzrFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QnFF4pZj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QnFF4pZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11BB1F0155C;
	Mon, 31 Aug 2026 13:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183987;
	bh=YKmxevGAZUKI12EUFAQGXeRQsENzcOVvija/FDY1ez4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QnFF4pZjJ+cKgQf/fdH5wI6qHobC31482L4JRiUk0unHITAmYLK6ICKL9rcmb0c9K
	 wu3xXdxStx7zX7AlZuvfijuy7ulWonXSv4BVu/eUxmQLbnFEFtaJQHrXR3yNvbQPmg
	 qIrAzBlUv78lrOl7Gc+9awp4yiCqpa9SjDxIwQJ+gKblk6cOTGVfBuDhjIkHsAJmgn
	 uCPYcHENtLu93UVJwHCvoHPYctyVMbmq8excYhkdFXdkCTBiGfAKq2HVeBnMI1hkPl
	 GYL+2I7zrvHo1L0/Q3l1Lcf/FEPPrxGprbbMmQ31+hKT8vN3Vj1yLr0bywSN/rO+It
	 rD2W4BcrPTgoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Adriana Stancu <adriana@arista.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-rtc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] rtc: bq32000: add delay between RTC reads
Date: Mon, 31 Aug 2026 09:27:31 -0400
Message-ID: <20260831133314.4125787-423-sashal@kernel.org>
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

From: Adriana Stancu <adriana@arista.com>

[ Upstream commit d4992b7050a10079bc760bdc5b8688e05a09dfc2 ]

When the RTC is used on systems without a interrupt line, userspace
tools like `hwclock` fall back to a frequent polling loop to synchronize
with the edge of the next second.

On the BQ32000, this aggressive polling can temporarly lock the register
refresh cycle, because the continuous transfers prevent the hardware from
updating the buffer. This results in stale data reads or select() timeouts
in userspace.

This patch introduces a delay before reading the RTC registers in order to
provide a sufficient idle time for the hardware to sync with the register
buffer.

Signed-off-by: Adriana Stancu <adriana@arista.com>
Link: https://patch.msgid.link/20260416142151.3385827-1-adriana@arista.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[rtc: bq32000]` `[add]` — add a delay between RTC register
reads in the BQ32000 driver.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Link:**
  `https://patch.msgid.link/20260416142151.3385827-1-adriana@arista.com`
- **Signed-off-by:** Adriana Stancu `<adriana@arista.com>` (author)
- **Signed-off-by:** Alexandre Belloni `<alexandre.belloni@bootlin.com>`
  (RTC maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`
- Notable: maintainer sign-off; no syzbot or external bug-report tags

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** On BQ32000 systems without an interrupt line, userspace tools
  (`hwclock`) poll aggressively waiting for the second rollover.
  Continuous I2C reads block the chip’s internal register-buffer
  refresh, yielding stale time data.
- **Symptom:** Stale RTC reads; `select()` timeouts in userspace during
  `hwclock` synchronization.
- **Root cause:** Hardware needs idle time between reads for the
  register buffer to sync; aggressive polling prevents that.
- **Version info:** None stated.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised as cleanup — explicitly a hardware timing
workaround. Functionally fixes incorrect RTC reads on affected hardware
(hardware quirk category).

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory the Changes
**Record:**
- **Files:** `drivers/rtc/rtc-bq32k.c` only (+9 lines net, including
  `#include <linux/delay.h>`)
- **Functions modified:** `bq32k_rtc_read_time()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (include):** Adds `<linux/delay.h>` for `usleep_range()`.
- **Hunk 2 (`bq32k_rtc_read_time`):**
  - **Before:** Read registers immediately via `bq32k_read()`.
  - **After:** If `client->irq <= 0`, sleep 2000–2500 µs, then read
    registers.
  - **Path affected:** Every `.read_time` call on devices without a
    connected IRQ.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Hardware quirk / timing workaround
- **Mechanism:** BQ32000 needs idle time between I2C accesses for its
  internal buffer to refresh. Polling (common when no IRQ is available)
  starves that refresh. A fixed settle delay gives the hardware time to
  update before each read.

### Step 2.4: Fix Quality Assessment
**Record:**
- Small, obviously motivated fix aligned with similar RTC driver
  patterns (`rtc-isl1208`, `rtc-rv3028`, `rtc-max8998`).
- **Regression risk:** Low. Adds ~2 ms latency only when `client->irq <=
  0`. `usleep_range()` is safe on the process-context paths that reach
  `.read_time`.
- **Concern:** Delay applies to every read without IRQ, not only
  aggressive polling — acceptable trade-off for correctness.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame Changed Lines
**Record:** `bq32k_rtc_read_time()` core logic dates to `1ce7c83fa91d2`
(2009, “rtc: add driver for BQ32000 I2C RTC”). The immediate-read path
without delay has been present since driver introduction.

### Step 3.2: Follow Fixes Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: File History for Related Changes
**Record:** Recent `rtc-bq32k.c` history is maintenance (i2c probe
conversion, SPDX, HTTPS links). No prior fix for this polling issue.
Patch evolved v1→v2 (DT property `ti,read-settle-us`) → v3 (hardcoded
delay when `irq <= 0`); committed form matches v3.

### Step 3.4: Author's Other Commits
**Record:** No prior commits from Adriana Stancu in this tree. Arista-
reported hardware issue.

### Step 3.5: Prerequisites
**Record:** Standalone. No series dependency. Uses existing
`client->irq` from I2C core; no new APIs or structures.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:**
- **URL:** https://yhbt.net/lore/linux-
  rtc/20260416142151.3385827-1-adriana@arista.com/T/
- **Series:** v1 (DT property) → v2 → v3 (final, hardcoded delay); v3 is
  the applied version
- **Review:** 0 replies in thread; Alexandre Belloni sign-off in commit
- **Stable nomination:** None found in thread

### Step 4.2: Reviewers
**Record:** CC’d: `alexandre.belloni`, `linux-rtc`, `devicetree`,
`linux-kernel`, `robh`, `krzk+dt`, `conor+dt`. RTC maintainer included.

### Step 4.3: Bug Report
**Record:** No external bug tracker or syzbot link. Issue described in
patch and commit message (Arista hardware, `hwclock` polling failure).

### Step 4.4: Related Patches
**Record:** v1/v2 added DT binding for `ti,read-settle-us`; v3 dropped
that in favor of `if (client->irq <= 0) usleep_range(2000, 2500)`. No
other patches required.

### Step 4.5: Stable Mailing List
**Record:** Not searched exhaustively; no stable nomination found in
available thread data.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `bq32k_rtc_read_time()` (modified)

### Step 5.2: Callers
**Record:** Via `rtc_class_ops.read_time` → `__rtc_read_time()` in
`drivers/rtc/interface.c` → callers include:
- `RTC_RD_TIME` ioctl in `drivers/rtc/dev.c` (userspace `hwclock`, etc.)
- `rtc_uie_task` workqueue (update-interrupt emulation polling)
- sysfs `date`/`time` attributes in `drivers/rtc/sysfs.c`
- Other in-kernel RTC consumers

### Step 5.3: Callees
**Record:** `to_i2c_client()`, `usleep_range()`, `bq32k_read()` (I2C
transfer)

### Step 5.4: Call Chain / Reachability
**Record:** Userspace → `/dev/rtc*` ioctl or sysfs → `rtc_read_time()` →
`bq32k_rtc_read_time()`. Reachable from unprivileged userspace with RTC
device access. Polling path (`rtc_uie_task`) is the scenario described
in the commit message.

### Step 5.5: Similar Patterns
**Record:** Multiple RTC drivers use read delays for hardware timing:
- `rtc-isl1208.c`: `msleep(250)` for alarm clearing
- `rtc-rv3028.c` / `rtc-rv3032.c`: `usleep_range()` for busy-wait
- `rtc-max8998.c`: `msleep(2000)` for LP3974 workaround
- `rtc-renesas-rtca3.c`, `rtc-ti-k3.c`, others: similar settle delays

---

## Phase 6: Cross-Referencing Against the Local Tree

### Step 6.1: Does the Buggy Code Exist?
**Record:** **Yes.** Local tree is **6.18.44**
(`v6.18.44-1-g2736c32da98b9`). `drivers/rtc/rtc-bq32k.c` exists;
`bq32k_rtc_read_time()` reads immediately with no delay (lines 90–116).
Driver present since 2009; bug present for the full lifetime of the
driver in this tree. Fix is **not** yet applied.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — add one include, a few lines in one
function. No structural conflicts with recent `rtc-bq32k.c` changes.

### Step 6.3: Related Fixes Already Present?
**Record:** None found for BQ32000 read-settle delay.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** **drivers/rtc** — IMPORTANT. RTC correctness affects system
time, logging, TLS, and boot synchronization.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; recent stable-worthy fixes (NULL deref,
refcount, alarm races) in this tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Systems with TI BQ32000 (`ti,bq32000`) and **no interrupt
line** (`client->irq <= 0`). DT example in binding shows RTC without
`interrupts`. Affects embedded/enterprise platforms using this chip
without IRQ wiring.

### Step 8.2: Trigger Conditions
**Record:** Userspace polling for second rollover (e.g. `hwclock
--systohc` without RTC update IRQ). Common on no-IRQ configurations.
Triggerable from userspace via RTC device node.

### Step 8.3: Failure Mode Severity
**Record:** Stale RTC data and `hwclock` `select()` timeouts —
**MEDIUM** severity. Not a kernel oops/UAF, but can leave system time
wrong or prevent time synchronization at boot. Operational impact on
affected hardware is real.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** MEDIUM-HIGH for affected BQ32000 users — restores
  reliable time reads and `hwclock` behavior
- **Risk:** LOW — ~12 lines, well-understood pattern, delay only when
  `irq <= 0`
- **Ratio:** Favorable; fits the hardware-quirk exception for stable

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real hardware bug on BQ32000 without IRQ
- Hardware quirk / timing workaround (explicit stable exception)
- Small, surgical, maintainer-reviewed fix
- Buggy code present in 6.18.44 since driver introduction (2009)
- Precedent in RTC subsystem (isl1208, rv3028, max8998 delays)
- Userspace-reachable via RTC ioctl/polling paths
- No new APIs, DT bindings, or feature additions in final form

**AGAINST backport:**
- No kernel crash, UAF, or security issue
- Niche hardware (BQ32000 without IRQ)
- No syzbot or multi-user bug reports
- Adds ~2 ms to every read on no-IRQ systems (minor latency)
- `client->irq <= 0` is a heuristic; IRQ in DT but unused by this driver
  would skip the delay

**Unresolved:**
- No independent test reports beyond author/maintainer
- b4 dig unavailable (commit not in local history)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — clear hardware rationale;
   maintainer sign-off; matches established RTC delay patterns
2. Fixes a real bug affecting users? **PASS** — stale RTC reads and
   `hwclock` failures on affected hardware
3. Important issue? **PASS (MEDIUM)** — not a crash, but broken RTC/time
   sync on real hardware; hardware-quirk category
4. Small and contained? **PASS** — single file, ~12 lines
5. No new features or APIs? **PASS** — no DT property, no new
   sysfs/module params
6. Can apply to local tree? **PASS** — driver and buggy code present;
   clean apply expected

### Step 9.3: Exception Categories
**Record:** **Hardware quirk/workaround** — BQ32000 requires idle time
between reads for register-buffer refresh. Same class as USB/PCI quirks
and other RTC settle-delay fixes.

### Step 9.4: Decision Rationale

For **linux 6.18.y** (this checkout): the BQ32000 driver has read the
RTC immediately since 2009. On systems without an interrupt line,
userspace polling can prevent the chip from refreshing its register
buffer, producing stale reads and `hwclock` timeouts. The fix is a
small, well-precedented hardware timing workaround that only affects no-
IRQ configurations. It does not add features or APIs, applies cleanly,
and addresses a real operational bug on affected hardware.

---

## Verification

- **[Phase 1]** Parsed subject, tags, and body from provided commit
  message
- **[Phase 1]** Confirmed no `Fixes:`, `Reported-by:`, or syzbot tags
- **[Phase 2]** Diff analysis: 1 file, `bq32k_rtc_read_time()` only,
  adds `usleep_range(2000, 2500)` when `client->irq <= 0`
- **[Phase 3]** `git blame -L 90,116 drivers/rtc/rtc-bq32k.c`: core read
  path from `1ce7c83fa91d2` (2009)
- **[Phase 3]** `git log --oneline -20 -- drivers/rtc/rtc-bq32k.c`: no
  prior settle-delay fix
- **[Phase 3]** `git log --grep='add delay between RTC reads'`: commit
  not in local tree
- **[Phase 4]** Web search: found v1→v3 series; v3 URL on yhbt.net/lore;
  0 thread replies
- **[Phase 4]** `b4 dig -c HEAD`: failed (commit not in tree); `b4 dig`
  requires `-c COMMITISH`
- **[Phase 4]** lore.kernel.org direct fetch blocked (Anubis bot
  protection)
- **[Phase 5]** Read `drivers/rtc/interface.c`: `__rtc_read_time()`
  calls `rtc->ops->read_time()`
- **[Phase 5]** Read `drivers/rtc/dev.c`: `RTC_RD_TIME` ioctl and
  `rtc_uie_task` call `rtc_read_time()`
- **[Phase 5]** `grep usleep_range/msleep` in `drivers/rtc/*.c`:
  multiple similar delay patterns confirmed
- **[Phase 6]** `git describe HEAD`: `v6.18.44-1-g2736c32da98b9`;
  Makefile confirms 6.18.44
- **[Phase 6]** Read `drivers/rtc/rtc-bq32k.c`: fix not present; no
  `linux/delay.h`, no `usleep_range`
- **[Phase 6]** Read
  `Documentation/devicetree/bindings/rtc/ti,bq32000.yaml`: `interrupts`
  optional; example has no IRQ
- **[Phase 7]** `git log --oneline -20 -- drivers/rtc/`: active
  subsystem with recent bug fixes
- **[Phase 8]** Read `drivers/i2c/i2c-core-base.c` lines 503–532:
  `client->irq` set to 0 when no IRQ from DT/ACPI
- **[Phase 8]** `grep irq` in `rtc-bq32k.c`: driver does not implement
  IRQ handling
- **[Phase 3]** `git show 0dbd610c426ed`: isl1208 delay fix precedent
  (13 lines, maintainer sign-off)

**YES**

 drivers/rtc/rtc-bq32k.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/rtc/rtc-bq32k.c b/drivers/rtc/rtc-bq32k.c
index 7ad34539be4d2..245e5e45d6a16 100644
--- a/drivers/rtc/rtc-bq32k.c
+++ b/drivers/rtc/rtc-bq32k.c
@@ -16,6 +16,7 @@
 #include <linux/kstrtox.h>
 #include <linux/errno.h>
 #include <linux/bcd.h>
+#include <linux/delay.h>
 
 #define BQ32K_SECONDS		0x00	/* Seconds register address */
 #define BQ32K_SECONDS_MASK	0x7F	/* Mask over seconds value */
@@ -89,9 +90,17 @@ static int bq32k_write(struct device *dev, void *data, uint8_t off, uint8_t len)
 
 static int bq32k_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct bq32k_regs regs;
 	int error;
 
+	/*
+	 * When the device doesn't have the interrupt connected, prevent
+	 * userpace from polling the RTC registers too frequently.
+	 */
+	if (client->irq <= 0)
+		usleep_range(2000, 2500);
+
 	error = bq32k_read(dev, &regs, 0, sizeof(regs));
 	if (error)
 		return error;
-- 
2.53.0

