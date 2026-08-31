Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5F8472777;
	Mon, 31 Aug 2026 13:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183321; cv=none; b=rcCB/IXUCe9+kmmvx3d3a83rnE7G1fuqxUhJoP+8Bs/7orqRar0RHJVbeIUxjHQr9S3W2RANLHai7K6eJXzWD7acLBKXpiYoAsvtPNcq3YhM6HZ0F2fBtGVQfurWC3g+Frn4a9rt3sn8ZutCQMiPsDxI484uAM3IvS/BN5qQtCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183321; c=relaxed/simple;
	bh=6oewQ0h6Hf5SGpiDG2VaY6peLC/WBY0g8CumFH2C0mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BbsTr8wA17BPxuIse2W+GnBiV0o1SZ5ko6kHpCTXCeaz4inKzte8SGwJaYqcehcxvmH7R3XA5jgkKWonrS3vAIQViR/Mcp+VlxZB0Fn4l9wRH2LmhDC6xz6yXhGKRGhjlZfJ8yWf6DZ/abIkkbrq49aMRx2mAvW0GK02K8wbRgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O9PTW+0A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O9PTW+0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A417A1F00A3F;
	Mon, 31 Aug 2026 13:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183318;
	bh=yhQEC2Id9T9LDJ0IGm0KqWIs1kvH1BA2r+doMmDJ20M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9PTW+0AHHcXrbc2/vCokrz5MrS/8xlueovGrxEX5Y4xmc61Cw0QCou1B3LuVSTYq
	 5XvcE4ooAEKXY8fsgMGXjzHL6VX4HVIxLpcvt7SJ7Nd0TmZEppLPLBtqhM3vQOmYQh
	 U5Z8R/4eW3Lx1tNgckg0RbsCwhxAUZpxlqYaGq215LlpHpeLNEkkRRoFlC3JH7bWgE
	 vDbtQ9Wr1mj+NLKbzANS4s+lY25EzkVhIOGcrAokTfWdh6ood2jxgOHPLSMYnqQD1/
	 t4+81UB7PxdsOcj/UXXj5fZR4DrtVhpD3AW/kcCmLZGyWbXvR6Mm7B2sriYF+noZpO
	 JDSAThRSJeQsQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stepan Ionichev <sozdayvek@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	jirislaby@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] tty: serial: 8250: protect against NULL uart->port.dev in register
Date: Mon, 31 Aug 2026 09:21:45 -0400
Message-ID: <20260831133314.4125787-77-sashal@kernel.org>
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

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit 941c9f84c9b6310f7aaa1c8c785dcc634ee33050 ]

serial8250_register_8250_port() conditionally copies uart->port.dev
from up->port.dev only when up->port.dev is non-NULL:

	if (up->port.dev) {
		uart->port.dev = up->port.dev;
		...
	}

So if both the existing uart slot and up have a NULL ->dev,
uart->port.dev remains NULL. The very next ACPI companion check
then dereferences it unconditionally:

	if (!has_acpi_companion(uart->port.dev)) {

has_acpi_companion() reads dev->fwnode without a NULL guard
(include/linux/acpi.h), so this NULL-derefs the kernel for the
remaining no-dev case rather than just skipping the
mctrl_gpio_init() initialisation as intended.

smatch flags the inconsistency:

  drivers/tty/serial/8250/8250_core.c:767
  serial8250_register_8250_port() error: 'uart->port.dev' could be
  null (see line 719)

Guard the call with a NULL check so register continues to work
for callers that legitimately have no parent device (legacy
non-OF/non-ACPI registrations).

No functional change for callers that pass a non-NULL ->dev.

Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Link: https://patch.msgid.link/20260508181237.11146-1-sozdayvek@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[tty: serial: 8250]` `[protect]` — Guard
`has_acpi_companion()` against a NULL `uart->port.dev` in
`serial8250_register_8250_port()`.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Stepan Ionichev `<sozdayvek@gmail.com>` (author)
- **Signed-off-by:** Greg Kroah-Hartman `<gregkh@linuxfoundation.org>`
  (TTY maintainer)
- **Link:**
  `https://patch.msgid.link/20260508181237.11146-1-sozdayvek@gmail.com`
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: Greg Kroah-Hartman merged it; smatch static analysis cited in
  body

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `uart->port.dev` is only copied from `up->port.dev` when the
  latter is non-NULL. If both are NULL,
  `has_acpi_companion(uart->port.dev)` dereferences `dev->fwnode`
  unconditionally.
- **Symptom:** Kernel NULL pointer dereference (oops) during port
  registration.
- **Trigger:** Legacy callers that legitimately pass no parent `struct
  device` (non-OF/non-ACPI registration paths).
- **Root cause:** Missing NULL guard before `has_acpi_companion()`,
  which does not handle NULL internally.
- **Version info:** Not specified in message; analysis shows the ACPI
  check dates to 2019 in this tree.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit NULL-dereference fix, not disguised
cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/tty/serial/8250/8250_core.c` (+1/-1 line)
- **Function:** `serial8250_register_8250_port()`
- **Scope:** Single-file, single-line surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `if (!has_acpi_companion(uart->port.dev))` — always calls
  `has_acpi_companion()`, even when `uart->port.dev` is NULL.
- **After:** `if (uart->port.dev &&
  !has_acpi_companion(uart->port.dev))` — skips ACPI check and
  `mctrl_gpio_init()` when there is no device.
- **Path affected:** Port registration when `up->port.dev` is NULL and
  the target uart slot also has NULL `dev`.

### Step 2.3: Bug Mechanism
**Record:** **Category:** NULL pointer dereference (memory safety).
- `has_acpi_companion()` in `include/linux/acpi.h` does `return
  is_acpi_device_node(dev->fwnode);` with no NULL check.
- `uart->port.dev` is only assigned inside `if (up->port.dev) {
  uart->port.dev = up->port.dev; ... }`.
- When both are NULL, unconditional `has_acpi_companion()` crashes on
  CONFIG_ACPI builds.

### Step 2.4: Fix Quality
**Record:** Obviously correct and minimal. Matches the existing
conditional-copy pattern for `uart->port.dev`. No functional change when
`dev` is non-NULL. Very low regression risk.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- `has_acpi_companion()` check introduced in `4a96895f74c96`
  ("tty/serial/8250: use mctrl_gpio helpers", 2019-06-20).
- Conditional `up->port.dev` copy and ACPI check reorganized in
  `05b537a175442c` (2025-06-11 refactor); bug pattern unchanged.
- `4a96895f74c96` is an ancestor of HEAD in this tree — bug present
  since 2019 here.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag. Bug introduced by `4a96895f74c96`,
confirmed present in v6.18.44.

### Step 3.3: Related File History
**Record:** Recent `8250_core.c` changes are style/refactor (guard(),
hashtable, CIR condition). No prior fix for this NULL-deref. Standalone
one-liner.

### Step 3.4: Author Context
**Record:** Stepan Ionichev has other 8250 patches (e.g. `8250_dw` clk
notifier fix). Greg Kroah-Hartman merged this one.

### Step 3.5: Dependencies
**Record:** None. Self-contained; no prerequisite commits. `git apply
--check` succeeds cleanly on this tree.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig -c` could not be run (commit not in local tree).
Lore/patch.msgid.link blocked (403/Anubis). Could not retrieve thread
content.

### Step 4.2: Reviewers
**Record:** UNVERIFIED — `b4 dig -w` not possible without commit in
tree. Greg Kroah-Hartman Signed-off-by confirms maintainer acceptance.

### Step 4.3: Bug Report
**Record:** smatch static analysis cited in commit message. No syzbot or
user crash report. Real bug confirmed by code inspection.

### Step 4.4: Series Context
**Record:** Standalone patch, not part of a series.

### Step 4.5: Stable List History
**Record:** UNVERIFIED — lore.kernel.org inaccessible from this
environment.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `serial8250_register_8250_port()` modified.

### Step 5.2: Callers
**Record:** Called from 30+ drivers during probe/init. Callers that do
**not** set `port.dev`:
- `drivers/char/mwave/mwavedd.c` — `memset(&uart, 0, ...)`, no `dev`
- `drivers/misc/ibmasm/uart.c` — same pattern
- `drivers/tty/serial/8250/8250_hp300.c` — FRODO path (line ~262), no
  `dev`
- `drivers/tty/serial/8250/8250_men_mcb.c` — `memset`, no `dev`
- `drivers/tty/serial/8250/8250_dfl.c` — `uart = { }`, no `dev`

Also: `serial8250_unregister_port()` sets `uart->port.dev = NULL` when
no ISA devs (line 884), so re-registration without `dev` hits the bug
path.

### Step 5.3: Callees
**Record:** `has_acpi_companion()` → `is_acpi_device_node(dev->fwnode)`;
`mctrl_gpio_init()` for GPIO modem-control lines.

### Step 5.4: Reachability
**Record:** Triggered during driver probe/module init on CONFIG_ACPI
systems when legacy 8250 callers register ports without a `struct
device`. Not a syscall path, but real on ACPI x86/ARM servers using
those drivers.

### Step 5.5: Similar Patterns
**Record:** The `if (up->port.dev)` guard at line 749 already shows the
author knew `dev` can be NULL; the ACPI check was the inconsistent
omission smatch flagged.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code in Tree?
**Record:** **YES.** Local tree is **v6.18.44** (`git describe HEAD`,
`make kernelversion`). Buggy line at `8250_core.c:763`:
```763:763:drivers/tty/serial/8250/8250_core.c
        if (!has_acpi_companion(uart->port.dev)) {
```
Fix is **not** yet applied (`git log --grep` found nothing).

### Step 6.2: Backport Complications
**Record:** Clean apply verified (`git apply --check` exit 0). No
conflicts expected.

### Step 6.3: Related Fixes Already Present?
**Record:** None found for this issue.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem
**Record:** `drivers/tty/serial/8250` — IMPORTANT (widely used serial
core; many platform/PCI drivers depend on it).

### Step 7.2: Activity
**Record:** Actively maintained; recent refactors in 2025, but core
registration logic stable since 2019 ACPI check.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of legacy 8250 registration paths on **CONFIG_ACPI**
kernels — IBM mwave, IBM ASM service processor UART, MEN MCB, DFL UART,
HP300 FRODO, and similar callers without `port.dev`.

### Step 8.2: Trigger Conditions
**Record:** Port registration with both `up->port.dev` and
`uart->port.dev` NULL. Uncommon but legitimate. Requires CONFIG_ACPI
(non-ACPI stub returns `false` without dereferencing).

### Step 8.3: Failure Mode
**Record:** NULL pointer dereference in `has_acpi_companion()` → kernel
oops during driver probe. **Severity: HIGH** (system crash on affected
hardware/config).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Prevents kernel oops on ACPI systems using legacy 8250
  registration; fixes latent bug since 2019.
- **Risk:** Very low — one-line NULL guard, no behavior change when
  `dev` is set.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real NULL pointer dereference, confirmed by code and smatch
- Kernel oops on probe for legitimate legacy callers
- One-line, obviously correct fix
- Bug present in v6.18.44 since 2019 (`4a96895f74c96`)
- Applies cleanly
- Greg Kroah-Hartman merged
- No new APIs or features

**AGAINST backport:**
- Affects only CONFIG_ACPI + NULL-dev registration paths (narrower than
  universal crash)
- No user crash reports or syzbot hits in message
- Lore review thread not retrievable

**Unresolved:** Full mailing-list review discussion; explicit stable
nomination by reviewers.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is trivial; smatch-
   driven; maintainer merged.
2. Fixes a real bug? **PASS** — NULL deref on ACPI builds.
3. Important issue? **PASS** — kernel oops (HIGH severity).
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features/APIs? **PASS**.
6. Can apply to local tree? **PASS** — verified clean apply.

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not device-ID/quirk/build/doc
exception.

### Step 9.4: Decision Rationale
This is a textbook stable backport: a latent NULL-dereference in widely-
used 8250 core code, present in v6.18.44 since 2019, triggered by
legitimate legacy registration paths on ACPI systems, fixed by a single
obviously-correct NULL guard with no behavior change for normal callers.

---

## Verification

- [Phase 1] Parsed subject, tags, body from user-provided commit message
- [Phase 2] Read diff: 1-line change in
  `serial8250_register_8250_port()`
- [Phase 2] Read `has_acpi_companion()` at `include/linux/acpi.h:85-88`
  — no NULL guard
- [Phase 3] `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- [Phase 3] `git blame -L 750,770` — ACPI check from `05b537a175442c`,
  original from `4a96895f74c96`
- [Phase 3] `git show 4a96895f74c96` — introduced `has_acpi_companion()`
  without NULL guard (2019)
- [Phase 3] `git show 05b537a175442c^` — same bug pattern before
  refactor
- [Phase 3] `git merge-base --is-ancestor 4a96895f74c96 HEAD` → ancestor
  confirmed
- [Phase 3] `git log --grep` — fix not in tree
- [Phase 4] `b4 dig` — failed (commit not in tree; wrong args for
  search)
- [Phase 4] Lore/patch.msgid.link fetch — blocked (403/Anubis)
- [Phase 5] `grep serial8250_register_8250_port` — 30+ callers found
- [Phase 5] Verified NULL-dev callers: `mwavedd.c`, `ibmasm/uart.c`,
  `8250_hp300.c`, `8250_men_mcb.c`, `8250_dfl.c`
- [Phase 5] `serial8250_unregister_port()` sets `uart->port.dev = NULL`
  at line 884
- [Phase 6] Buggy code at `8250_core.c:763` without NULL guard —
  confirmed present
- [Phase 6] `git apply --check` — patch applies cleanly (exit 0)
- [Phase 8] Non-ACPI stub at `acpi.h:868-870` returns false without
  dereference — bug ACPI-only

**YES**The background `git log` lookup finished; it matched the rest of
the investigation.

**Summary:** For **v6.18.44**, this commit should be backported.

It fixes a real NULL pointer dereference in
`serial8250_register_8250_port()` on CONFIG_ACPI builds: when both
`up->port.dev` and `uart->port.dev` are NULL, `has_acpi_companion()`
dereferences `dev->fwnode`. That can oops during probe for legacy
callers (mwave, ibmasm, MEN MCB, DFL UART, etc.) that register without a
parent device. The bug has been present since the 2019 `mctrl_gpio` ACPI
check (`4a96895f74c96`); the fix is a one-line NULL guard and applies
cleanly to this tree.

**YES**

 drivers/tty/serial/8250/8250_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index bfa421ab32536..8c169756710b5 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -760,7 +760,7 @@ int serial8250_register_8250_port(const struct uart_8250_port *up)
 	 * Only call mctrl_gpio_init(), if the device has no ACPI
 	 * companion device
 	 */
-	if (!has_acpi_companion(uart->port.dev)) {
+	if (uart->port.dev && !has_acpi_companion(uart->port.dev)) {
 		struct mctrl_gpios *gpios = mctrl_gpio_init(&uart->port, 0);
 		if (IS_ERR(gpios)) {
 			ret = PTR_ERR(gpios);
-- 
2.53.0

