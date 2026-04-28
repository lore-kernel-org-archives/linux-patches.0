Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1033F1665;
	Tue, 28 Apr 2026 10:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372900; cv=none; b=tXZPbGmFcbgskFlW9CevILSe7ZZad63MXMsnA1eD92xYNb7kiM62bRGSfwSOrz4UGeMBmISAxvsHlCIM9TfySA5QluLg1RDlU3gOb8pYbIJi5vKQJiBagrqvvWotSycyQlb8KMVP9nFeG2h+OxbTV0aJCR7ZSvBEnz0JADWUsL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372900; c=relaxed/simple;
	bh=XqbsiVK0KBKK6O0As9X7I3v62lye36ydH31AYNfkuQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gw2mF9QSs/n6oGlxNW1uzvcHTQxm62xL9S7ln9JdIkquEIzJUFayTkRZ4H9XZqpdKZ9S5rj1s7oQRD/JcVpVhY1MvnudR+D2JJnv/Xt3W3me9ezuPDsaZD8RokOYIH+oMTfT9Wbv5scGI7fZ32tKgxfqWQkqfoKyvY4VMLvCImg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMu+XiRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMu+XiRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC8DC2BCB5;
	Tue, 28 Apr 2026 10:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372900;
	bh=XqbsiVK0KBKK6O0As9X7I3v62lye36ydH31AYNfkuQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMu+XiRxWFWzZfXn+sIUF/3jIpajMjWJLIIHN5U8b8io4rl9CTNS2ttIXc3o2nugL
	 +FZubxcSZh7typyiQFuzem0y0lb+WgTgISZqRr0Wlk28EeAtcjZll5UrS3ev1y/34C
	 K7ept8OyaFea2H5E1EMlVCfnmArXhV59C2pwxCGvEYC5yyTt4nMmcfUEOoMPX7S6Vu
	 3B5TiKbQIUyvq7ZyVd53+q29rHYDF2ikSOR/rKttI7rnUBHa0Cx44R/F8rzsaNJCKR
	 PzN/Az3RrkZNMyFkaQwG0PHS5ICpyxZamTP72fZkHkDkVz0CGPZLUsYbObr1N5YYXs
	 94bjtN9/0aEeg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alyssa Milburn <amilburn@zall.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	krzysztof.kozlowski@linaro.org,
	jirislaby@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] tty: serial: samsung_tty: avoid dev_dbg deadlock
Date: Tue, 28 Apr 2026 06:40:15 -0400
Message-ID: <20260428104133.2858589-4-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alyssa Milburn <amilburn@zall.org>

[ Upstream commit 43c2b86ff633c34831c8430925ba73d7c20da1ad ]

commit a05025d0ce72 ("tty: serial: samsung_tty: use standard
debugging macros") changed the debug prints to dev_dbg, which can
result in deadlocks:

s3c24xx_serial_set_termios can be called with the port lock, and then
calls dev_dbg, which needs the console mutex. At the same time,
s3c24xx_serial_console_write can be called with the console lock
(e.g., inside console_unlock), and needs the port lock.

To avoid this, move one dev_dbg call and just delete the other.

Signed-off-by: Alyssa Milburn <amilburn@zall.org>
Link: https://patch.msgid.link/aXny9km6N1v9eoXU@zall.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me write up the full
analysis:

## Complete 9-Phase Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 - Subject line parsing:**
Record: Subsystem `tty: serial: samsung_tty:`, action verb `avoid`,
summary: avoid dev_dbg deadlock between port lock and console lock.

**Step 1.2 - Commit message tags:**
Record:
- `Signed-off-by: Alyssa Milburn <amilburn@zall.org>` (author)
- `Link: https://patch.msgid.link/aXny9km6N1v9eoXU@zall.org` (original
  submission)
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>` (TTY
  subsystem maintainer applied)
- No explicit `Fixes:` tag, but the commit body names `a05025d0ce72` as
  introducing the issue
- No `Cc: stable@vger.kernel.org` (expected, as the prompt notes)
- No Reviewed-by/Acked-by/Tested-by tags
- No syzbot/Reported-by

**Step 1.3 - Commit body:**
Record: Bug description: `s3c24xx_serial_set_termios` acquires port lock
then calls `dev_dbg`, which goes through printk and can require the
console mutex. Meanwhile `s3c24xx_serial_console_write` runs with the
console lock held (e.g., from `console_unlock`) and acquires the port
lock. Classic AB-BA deadlock (port_lock ↔ console_lock). Fix: move one
`dev_dbg` before the port lock acquisition and remove the second (post-
write register-dump `dev_dbg`).

**Step 1.4 - Hidden bug fix?** Not hidden - explicit "avoid deadlock".

### PHASE 2: DIFF ANALYSIS

**Step 2.1 - Inventory:**
Record: 1 file (`drivers/tty/serial/samsung_tty.c`), +2/-8 lines total
(6 net deletion). One function modified: `s3c24xx_serial_set_termios()`.
Scope: single-file, surgical.

**Step 2.2 - Code flow change:**
Record:
- Before: `uart_port_lock_irqsave(...)` → `dev_dbg("setting ulcon ...")`
  → reg writes → `dev_dbg("uart: ulcon = ... ")` (reading registers
  back)
- After: `dev_dbg("setting ulcon ...")` → `uart_port_lock_irqsave(...)`
  → reg writes → (second dev_dbg removed)

The first `dev_dbg` only prints local variables (`ulcon, quot,
udivslot`) so moving it before the lock is safe. The second `dev_dbg`
re-read registers to report actual written values - removing it loses
diagnostic info but avoids the deadlock (moving it outside the lock
would read values that could race with other writes).

**Step 2.3 - Bug mechanism:**
Record: Synchronization fix (category b): removes an AB-BA deadlock
potential between the UART port spinlock (`port->lock`) and the
printk/console locking chain.

Verified dead-lock mechanism:
- `set_termios` holds `port->lock` (uart_port_lock_irqsave)
- `dev_dbg()` expands (when dynamic debug is enabled) to a printk call
  that can enter `console_unlock()` → `console->write()` →
  `s3c24xx_serial_console_write()` → which calls
  `uart_port_lock_irqsave(cons_uart, &flags)` = same port lock. On the
  same CPU that would self-deadlock; across CPUs it forms the AB-BA
  pattern with another printk path.
- Confirmed `s3c24xx_serial_console_write` does
  `uart_port_lock_irqsave(cons_uart, &flags)` (samsung_tty.c lines
  2280-2283 in HEAD).

**Step 2.4 - Fix quality:**
Record: Fix is obvious - debug prints are diagnostic-only; moving one
out and removing the other cannot change functional behavior. Zero risk
of regression from the fix itself. Only downside: loss of one diagnostic
print.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 - Blame/introduction:**
Record: The problematic `dev_dbg` calls were introduced by `a05025d0ce72
"tty: serial: samsung_tty: use standard debugging macros"` (Greg KH, Dec
2019). `git describe --contains a05025d0ce72` → `v5.6-rc1~139^2~130`,
i.e. first released in v5.6 (March 2020).

**Step 3.2 - Fixes target:**
Record: Named `a05025d0ce72` is present in all current LTS stable trees
(5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y, and 7.0.y). Before
`a05025d0ce72`, the samsung_tty driver used a custom `dbg()` macro that
routed to `printascii()` (low-level ARM debug UART write, no locking) -
that's why the original code wasn't a deadlock. After `a05025d0ce72`,
the conversion to `dev_dbg()` introduced the deadlock potential.

**Step 3.3 - File history:**
Record: Recent changes to `drivers/tty/serial/samsung_tty.c` are a small
trickle (Exynos850 earlycon, 18 port support, cast cleanup, etc.). No
churn in the set_termios area since a05025d0ce72. Standalone patch (not
part of a series) - confirmed via `b4 dig -a` showing only v1.

**Step 3.4 - Author context:**
Record: Alyssa Milburn has submitted other kernel patches (media
subsystem from previous years). Not the samsung TTY maintainer, but the
patch was applied by Greg KH (TTY maintainer) after CC'ing the proper
subsystem maintainers.

**Step 3.5 - Dependencies:**
Record: None. Fix is self-contained and touches only local code within
one function.

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1 - Original thread:**
Record: `b4 dig -c 43c2b86ff633c` found match at
https://patch.msgid.link/aXny9km6N1v9eoXU@zall.org. Fetched via `b4 am`
to `/tmp/b4_samsung/`. No review replies found in the thread (the mbox
from b4 contained only the original patch - `b4 am` reported "Analyzing
0 code-review messages"). Single version - no v2/v3.

**Step 4.2 - Recipients (b4 dig -w):**
Record: Proper CC list: Krzysztof Kozlowski (samsung-soc maintainer),
Alim Akhtar (samsung platform maintainer), Greg Kroah-Hartman (TTY
maintainer), Jiri Slaby (TTY co-maintainer), Faraz Ata (samsung
contributor), linux-serial, linux-samsung-soc, linux-arm-kernel, linux-
kernel. Proper maintainer audience; Greg KH signed off, indicating the
TTY maintainer accepted it.

**Step 4.3 - Bug report:**
Record: No `Reported-by:`, no bug URL. The author appears to have
identified the issue through code review/lockdep analysis rather than
user report. Similar patterns have been found by lockdep in other serial
drivers.

**Step 4.4 - Related patches:**
Record: None (single patch).

**Step 4.5 - Stable list:**
Record: Not investigated further; lore.kernel.org fetching is blocked by
Anubis bot-protection. However, `b4` successfully retrieved the thread
without review feedback, so there was no stable-related discussion.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 - Key functions:**
Record: `s3c24xx_serial_set_termios` is the only function modified.

**Step 5.2 - Callers of set_termios:**
Record: Called via `uport->ops->set_termios(...)` from serial_core.c at
three sites: (1) `uart_change_line_settings` (normal termios change),
(2) `uart_configure_port` (probe path), (3) `uart_resume_port` (resume).
All are triggered by common operations (open, `tcsetattr`, resume).
Confirmed `set_termios` is called WITHOUT the port_lock held by
serial_core - the driver itself acquires it internally.

**Step 5.3 - The console-write side:**
Record: `s3c24xx_serial_console_write` is registered as
`s3c24xx_serial_console.write`. Called from the printk/console subsystem
when the samsung serial is the configured console. Takes
`cons_uart->lock` via `uart_port_lock_irqsave(cons_uart, &flags)` (lines
2278-2283). This forms the second half of the AB-BA.

**Step 5.4 - Reachability:**
Record: Deadlock trigger requires: (a) dynamic debug enabled for these
specific `dev_dbg` statements in samsung_tty.c, AND (b) samsung_tty
serves as a console, AND (c) a termios change happens (user
`tcsetattr()`, getty open, resume) while another CPU/task is doing a
printk that's flushing via this console. Practical trigger is uncommon
in production (dynamic debug is off by default) but clearly reachable
from unprivileged userspace when enabled.

**Step 5.5 - Similar patterns:**
Record: Confirmed similar fixes in other serial drivers: `436c979360017
"serial: stm32: fix a deadlock in set_termios"` (same AB-BA between
`&port_lock_key` and `console_owner`), `7fd6f640f2dd1 "serial: 8250_dw:
Fix deadlock in LCR workaround"`, `62b2caef400c1 "drivers: tty: serial:
Fix deadlock in sa1100_set_termios()"`. Well-established bug-class with
accepted fixes.

### PHASE 6: STABLE TREE ANALYSIS

**Step 6.1 - Buggy code in stable:**
Record: The buggy structure (port_lock acquired before `dev_dbg`) is
present in all stable trees ≥ 5.6 (where a05025d0ce72 first appeared).
Verified in 7.0.y HEAD (stable/linux-7.0.y) - the current checkout
contains exactly the pre-patch code. Stable trees 5.10, 5.15, 6.1, 6.6,
6.12, 7.0 are affected.

**Step 6.2 - Backport difficulty:**
Record: Very low difficulty. The hunk context is stable identifiers
(`ulcon, quot, udivslot` variables, `wr_regl(port, S3C2410_ULCON,
ulcon)`). Only complication: older stable trees used
`spin_lock_irqsave(&port->lock, flags)` instead of
`uart_port_lock_irqsave(port, &flags)` (the port-lock wrappers were
introduced by 97d7a9aeba1d4 "serial: samsung_tty: Use port lock
wrappers" which went to various stable trees). Still trivial to backport
by substituting the correct lock call; git will likely auto-apply with
minor context fuzz in old trees.

**Step 6.3 - Already in stable?**
Record: No prior fix for this deadlock in stable trees (confirmed by
file history).

### PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 - Criticality:**
Record: Subsystem = tty/serial driver for Samsung SoCs (Exynos family,
Apple A7-A11, S3C). Criticality: PERIPHERAL (specific-hardware), but
used extensively on Samsung/Exynos-based embedded systems, Chromebooks,
Google Pixel/development boards, and similar ARM platforms. These
devices often use the samsung_tty as their primary console, which is
exactly the configuration where the deadlock matters.

**Step 7.2 - Activity:**
Record: Mature driver, low-churn subsystem. Active maintenance by
Krzysztof Kozlowski and Greg KH. 20 commits over the last ~2 years per
file history.

### PHASE 8: IMPACT AND RISK

**Step 8.1 - Affected users:**
Record: Users of samsung_tty on Exynos, S3C, Apple Silicon (A7-A11 via
this driver), etc. ARM/ARM64 platforms with Samsung or Apple early SoCs.
Limited to systems where dynamic debug is enabled for this file AND the
UART is a console.

**Step 8.2 - Trigger:**
Record: Requires unusual runtime config (dynamic debug on), so not
common in stock distros. However, fully reachable from userspace
(`tcsetattr()`) once dynamic debug is enabled. Developers debugging on
these platforms can hit it.

**Step 8.3 - Failure mode severity:**
Record: Hard hang (deadlock) - system becomes unresponsive. Severity if
triggered: CRITICAL (system hang). Probability: LOW in production,
HIGHER during debugging sessions.

**Step 8.4 - Benefit/risk:**
Record: BENEFIT = correctness fix for a recognized deadlock class (same
pattern fixed in stm32, 8250_dw, sa1100). RISK = essentially zero: no
functional behavior change, only debug-print placement. 2 insertions, 8
deletions, all in one function. Obviously correct on inspection.
Risk/benefit strongly favors backport.

### PHASE 9: SYNTHESIS

**Step 9.1 - Evidence:**
FOR backport:
- Fixes a real AB-BA deadlock between `port_lock` and the console
  subsystem locking
- Extremely small, contained change (+2/-8 lines in a single function)
- Zero risk of behavior regression (only debug prints affected)
- Applied by the TTY subsystem maintainer (Greg KH)
- Proper maintainers and lists were CC'd
- Same bug class has been fixed in other serial drivers (stm32, sa1100,
  8250_dw) and those fixes reached stable
- Buggy code has existed since v5.6 (2019), in every LTS tree

AGAINST:
- Trigger requires dynamic debug to be enabled for this file; not a
  default-config hang
- No reporter, no lockdep report in the commit message (identified by
  code inspection)
- Second `dev_dbg` is deleted rather than relocated (minor loss of
  diagnostic info)

**Step 9.2 - Stable rules check:**
1. Obviously correct? YES - inspection-verifiable, no behavioral change
   beyond debug placement
2. Fixes a real bug? YES - AB-BA deadlock (class well-documented)
3. Important issue? YES - deadlock/hang
4. Small and contained? YES - 10 lines, one function
5. No new features/APIs? YES - only relocates/removes debug prints
6. Applies to stable? YES - trivial with minor wrapper-name substitution
   for older trees

**Step 9.3 - Exception category:** Not an exception case; it's a true
bug fix.

**Step 9.4 - Decision:** YES.

## Verification

- [Phase 1] Parsed tags: Link to patch.msgid.link, SOB author Alyssa
  Milburn, SOB Greg KH as committer; no Fixes tag but body names
  a05025d0ce72 as introducing commit.
- [Phase 2] Diff: 2 insertions, 8 deletions, single function
  `s3c24xx_serial_set_termios`.
- [Phase 2] Verified `s3c24xx_serial_console_write` takes
  `uart_port_lock_irqsave(cons_uart, &flags)` (samsung_tty.c lines
  2278-2283), confirming the port-lock half of the AB-BA.
- [Phase 3] `git show a05025d0ce72` confirmed it replaced `dbg()` (a
  `printascii`-based macro) with `dev_dbg()` - verifying the regression
  introduction.
- [Phase 3] `git describe --contains a05025d0ce72` →
  `v5.6-rc1~139^2~130`, so bug first appeared in v5.6.
- [Phase 3] `git log -- drivers/tty/serial/samsung_tty.c` shows no
  existing fix in tree; checked the 20 recent commits.
- [Phase 3] Found related file-history commit `97d7a9aeba1d4 "serial:
  samsung_tty: Use port lock wrappers"` that changed `spin_lock_irqsave`
  → `uart_port_lock_irqsave`; relevant for backport to older trees.
- [Phase 4] `b4 dig -c 43c2b86ff633c` matched the patch by patch-id to
  lore thread `aXny9km6N1v9eoXU@zall.org`.
- [Phase 4] `b4 dig -c 43c2b86ff633c -a` confirmed single revision (v1
  only).
- [Phase 4] `b4 dig -c 43c2b86ff633c -w` confirmed proper recipients
  (Krzysztof Kozlowski, Alim Akhtar, Greg KH, Jiri Slaby, linux-serial,
  linux-samsung-soc).
- [Phase 4] `b4 am` fetched the thread; only the original patch, no
  review replies.
- [Phase 5] Traced `->set_termios` callers in serial_core.c: three sites
  (`uart_change_line_settings`, `uart_configure_port`,
  `uart_resume_port`), all reachable from common userspace operations;
  confirmed serial_core does NOT hold port lock when calling
  set_termios.
- [Phase 5] Found similar accepted fixes for the same deadlock class:
  `436c979360017` (stm32), `7fd6f640f2dd1` (8250_dw), `62b2caef400c1`
  (sa1100).
- [Phase 6] Verified current stable/linux-7.0.y HEAD contains the pre-
  patch buggy structure in `s3c24xx_serial_set_termios` (samsung_tty.c
  lines 1562-1595).
- [Phase 6] Upstream commit SHA in origin/master:
  `43c2b86ff633c34831c8430925ba73d7c20da1ad`.
- [Phase 8] Confirmed trigger conditions require dynamic debug enabled
  (`dev_dbg` is no-op otherwise) AND samsung_tty serving as console -
  partially gating severity.
- UNVERIFIED: Could not fetch lore.kernel.org directly (Anubis bot-
  protection). Had to rely on `b4` tooling, which reported zero review
  replies - so there's likely no stable-relevant discussion I missed,
  but I cannot 100% guarantee it.
- UNVERIFIED: Did not enumerate every LTS tree's exact file contents;
  relied on (a) the described introduction in 2019 and (b) no file-
  history fix. Minor lock-wrapper adjustments may be needed for < 6.6.y
  backports (older trees use `spin_lock_irqsave(&port->lock, ...)`
  pre-97d7a9aeba1d4).

## Summary

This is a small (+2/-8 lines), surgical fix for an AB-BA deadlock
between the UART port lock and the console locking chain, introduced in
v5.6 (2019) when the driver's local `dbg()` macro - which routed to a
lock-free `printascii()` - was converted to `dev_dbg()` that enters the
full printk path. The fix moves one `dev_dbg` out of the critical
section and removes another redundant one. It meets all stable-kernel
criteria: obviously correct, fixes a real deadlock, small/contained, no
new features, and applies with at most trivial context adjustment. The
same bug class has precedent backports in stm32, sa1100, and 8250_dw
serial drivers.

**YES**

 drivers/tty/serial/samsung_tty.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/samsung_tty.c b/drivers/tty/serial/samsung_tty.c
index c1fabad6ba1fa..e27806bf2cf3e 100644
--- a/drivers/tty/serial/samsung_tty.c
+++ b/drivers/tty/serial/samsung_tty.c
@@ -1562,12 +1562,12 @@ static void s3c24xx_serial_set_termios(struct uart_port *port,
 		ulcon |= S3C2410_LCON_PNONE;
 	}
 
-	uart_port_lock_irqsave(port, &flags);
-
 	dev_dbg(port->dev,
 		"setting ulcon to %08x, brddiv to %d, udivslot %08x\n",
 		ulcon, quot, udivslot);
 
+	uart_port_lock_irqsave(port, &flags);
+
 	wr_regl(port, S3C2410_ULCON, ulcon);
 	wr_regl(port, S3C2410_UBRDIV, quot);
 
@@ -1587,12 +1587,6 @@ static void s3c24xx_serial_set_termios(struct uart_port *port,
 	if (ourport->info->has_divslot)
 		wr_regl(port, S3C2443_DIVSLOT, udivslot);
 
-	dev_dbg(port->dev,
-		"uart: ulcon = 0x%08x, ucon = 0x%08x, ufcon = 0x%08x\n",
-		rd_regl(port, S3C2410_ULCON),
-		rd_regl(port, S3C2410_UCON),
-		rd_regl(port, S3C2410_UFCON));
-
 	/*
 	 * Update the per-port timeout.
 	 */
-- 
2.53.0

