Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86A064C3E8;
	Mon, 19 Oct 2026 14:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418819; cv=none; b=BgwcuSm9joGWBiVWrzbuZxOUNChGrrqb145rFpjUvNO228LKrV0nXHAaIvPUKTPxq38TbdpSOravy/tn7GGT9paOutjPFbshnMYRSFRgwKuwgDdZhG384rGWEM8nlVCTu7Yao3TiB0O9N7Fe0q5FCyh2qi3TAEkPqFrR68BejdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418819; c=relaxed/simple;
	bh=5kkmdwrMH/wmy6jpesq6gVlly04q2jPYFmDF5eOpHuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ehMIvbZgd49hA4FLKrrOAddUqF8lITTqMr5dNCy6vLz9Ew8g0nSLqXEUWU2gZZta8DdcPCfSO9nCPZs9e07KeScUfLUaAdAMiE6z7TOn9sobLDoKyU6mSolD+CqWBbbXYHH8coP/j1s36eD0OT+c3v++sATOEf2bpQQmc7nZfxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jm50UZU4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jm50UZU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9905D1F000C5;
	Mon, 19 Oct 2026 14:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418813;
	bh=/Mc3j2iQZfPdOdiww2LD2SO549DpyjThkyyyKQ+ulRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jm50UZU4Ye2HI3mIozRfXbPz6uyb3YsA5amyKgDeC9u01kG1dgKHNnGPPgML5GnGk
	 WdMkF0WWORPZpvjv51/SiPUV4YtRsm4nyRWtKAo5YZ+0LrKjkphouf6x0OL2KjjScA
	 zFCk214Nmc3QWywp3kzOakvdRbCBzx4ZSIiKMkaVUVLn6LBlIPV0KYubne/MnZ2/pM
	 M1M6aVL6MM17HItKf0NbfadI8WHWKjmhn81IoHnJy7Obg/Om+5NNe5E6cTKe8IA5/L
	 qeD4QHNrTrLhAFEgaD0G3/8iL90l8Yz5A4uPem+0OE7blnaaAlP4UfmmJr+TT+HXGc
	 A/t136Hd7djJw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aniket Randive <aniket.randive@oss.qualcomm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	jirislaby@kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] serial: qcom_geni: Disable closing_wait for console to prevent shutdown timeout
Date: Mon, 19 Oct 2026 09:53:26 -0400
Message-ID: <20261019135441.1420968-515-sashal@kernel.org>
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

From: Aniket Randive <aniket.randive@oss.qualcomm.com>

[ Upstream commit acba38e675dd66f52925cb9edf9ed8db16335875 ]

During system power-off, systemd closes the console UART and blocks in
tty_wait_until_sent() waiting for pending TX completion before
uart_shutdown() can cancel pending TX operations. With the default
closing_wait of 30s, this causes a watchdog reset when systemd is
responsible for watchdog feeding.

Set closing_wait to ASYNC_CLOSING_WAIT_NONE in startup() for console
ports to bypass tty_wait_until_sent() on close, allowing uart_shutdown()
to cancel TX commands cleanly. This change doesn't impact regular ports
functionality.

Signed-off-by: Aniket Randive <aniket.randive@oss.qualcomm.com>
Link: https://patch.msgid.link/20260706093749.836121-1-aniket.randive@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This checkout is **v7.3-rc4** (`7.3.0-rc4`). The candidate is a small
Qualcomm GENI UART console workaround for a 30s close-time TX drain that
can watchdog-reset the box on power-off. The driver, `startup()`, and
`closing_wait` path are all present here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[serial/qcom_geni] [Disable] [skip console `closing_wait` so
UART close does not stall shutdown]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by / Tested-by / Reviewed-by / Acked-by:** none
- **Cc: stable:** none (expected)
- **Link:** https://patch.msgid.link/20260706093749.836121-1-
  aniket.randive@oss.qualcomm.com
- **Signed-off-by:** Aniket Randive (author); Greg Kroah-Hartman (TTY
  maintainer). Ignore any Sasha Levin SOB — not on this commit.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** On power-off, systemd closes the console UART. Close blocks
  in `tty_wait_until_sent()` for pending TX before the UART can cancel
  that TX.
- **Symptom:** Default `closing_wait` is 30s (`tty_port_init`: `(3000 *
  HZ) / 100`). If systemd is the watchdog feeder, that stall causes a
  **watchdog reset** instead of a clean power-off.
- **Root cause (author):** GENI TX is command-based; drain waits for
  completion, but cancel happens only later in `uart_shutdown()` /
  driver shutdown. Chicken-and-egg.
- **Fix:** In `qcom_geni_serial_startup()`, if `uart_console(uport)`,
  set `tport->closing_wait = ASYNC_CLOSING_WAIT_NONE`. Regular UARTs
  unchanged.
- **Versions:** none named.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit hang/watchdog fix
using an existing tty_port flag.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/tty/serial/qcom_geni_serial.c` — **+8 / −0**
- Function: `qcom_geni_serial_startup()`
- Scope: single-file, surgical, console-only

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** Console ports keep default 30s `closing_wait`. Last close
  → `tty_port_close_start()` → `tty_wait_until_sent(tty, 30s)` if the
  software TX buffer or UART FIFO is not empty.
- **After:** Console ports skip that drain. Close proceeds immediately
  so shutdown can continue.
- **Path:** close/power-off of the console tty, not the hot TX path, not
  non-console ports.

Verified close chain:
1. `tty_release()` → `uart_close()` → `tty_port_close()`
2. `tty_port_close_start()` (tty_port.c:638-643) waits if `closing_wait
   != ASYNC_CLOSING_WAIT_NONE`
3. `tty_wait_until_sent()` waits on `!tty_chars_in_buffer(tty)`, then
   `uart_wait_until_sent()` polls `ops->tx_empty`

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Logic / hardware workaround]** GENI TX uses a sequencer
command (`UART_START_TX`). If that command is still active, `tx_empty`
(`SE_GENI_TX_FIFO_STATUS`) and the xmit fifo stay non-empty, so close
waits the full 30s. Setting `ASYNC_CLOSING_WAIT_NONE` is the documented
way to skip that wait (`tty_port.c:642-643`).

Nuance (verified, not assumed): `tty_port_shutdown()` returns
immediately when `port->console` is set, so **console close does not
call driver `shutdown()`**. Hangup (`uart_hangup()` → `uart_shutdown()`)
*does* shut the port down and does *not* use `closing_wait`. The 30s
stall is the close-time wait itself. Skipping it still fixes the
watchdog; the “so shutdown can cancel TX” wording is only partly
accurate for the close path.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Quality: **obviously correct** for the stated goal.
  `ASYNC_CLOSING_WAIT_NONE` is the uapi sentinel (`65535`).
  `uport->state` is valid in `startup()` because `uart_port_startup()`
  calls `ops->startup()` only after the port is bound.
- Risk: last few console bytes on last close may not drain. That is
  acceptable at power-off versus a watchdog reboot. Non-console ports
  unchanged. No API/ABI change. Userspace can still override via
  `TIOCSSERIAL`.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `qcom_geni_serial_startup()` introduced in **c4f528795d1ad**
  (2018-03-20, “Add serial driver support for GENI based QUP”).
- Default 30s `closing_wait` is in `tty_port_init()` and is old.
- Bug is long-standing in this driver, not a last-month regression.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Standalone, not “patch X/Y”. Nearby later work (`dbe2afb952bdb`
reboot quiesce, panic notifier) is a different problem (DMA/SMMU on
reboot/panic), not a prerequisite. `a699213d4e6ef` “Fix blocked task” is
an unrelated PM-runtime hang revert.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Aniket Randive has a few qcom-geni commits (this one; debug-
console probe). Qualcomm platform engineer, not the TTY maintainer. Greg
KH applied it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: **None.** Uses `uart_console()`, `tty_port.closing_wait`, and
`ASYNC_CLOSING_WAIT_NONE`, all older than this driver. Applies
standalone. In this tree, later PM-runtime lines sit around the same
function; the closing_wait hunk does not depend on them.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c acba38e675dd`: **[PATCH V1]** https://patch.msgid.link/2026
  0706093749.836121-1-aniket.randive@oss.qualcomm.com
- `b4 dig -a`: **v1 only**; that is what was applied (2026-07-06 submit,
  2026-07-10 by Greg).
- Saved mbox: **patch only, no replies, no NAK, no Cc: stable from
  reviewers.**
- lore.kernel.org fetches returned 403; thread confirmed via b4 mbox +
  Openwall/LKML mirrors.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To Greg Kroah-Hartman, Jiri Slaby (TTY
maintainers). Cc: linux-serial, linux-arm-msm, Krzysztof Kozlowski,
Qualcomm/Linaro GENI people. No extra Reviewed-by; maintainer SOB is the
review signal.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot, bugzilla, or public user report. Description matches
an internal Qualcomm power-off/watchdog failure. No independent repro in
the thread.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Single patch, not a series. Later “quiesce on reboot/panic”
series is independent.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned 403. No stable discussion
found via web search. **UNVERIFIED** whether anyone already requested or
rejected this for -stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

semcode MCP is not available (only the `cursor` namespace).
Callers/callees traced with grep/read.

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `qcom_geni_serial_startup` (modified). Related:
`tty_port_close_start`, `tty_wait_until_sent`, `uart_wait_until_sent`,
`qcom_geni_serial_tx_empty`, `qcom_geni_serial_shutdown`.

**Step 5.2: TRACE CALLERS**
Record: `.startup = qcom_geni_serial_startup` is in both FIFO and DMA
`uart_ops`. Called from `uart_port_startup()` on open (and
`uart_set_info` / console re-init). Reachable from userspace open of the
console tty and from console registration.

**Step 5.3: TRACE CALLEES**
Record: `uart_console()`, assignment to `tport->closing_wait`. No
alloc/lock in the new code.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace (systemd) close of `/dev/ttyMSM*` / console →
`tty_release` → `uart_close` → `tty_port_close_start` → 30s wait. **Yes,
reachable from userspace.** Trigger is power-off/getty stop with GENI as
console, not an obscure debug path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: No other serial driver sets `closing_wait =
ASYNC_CLOSING_WAIT_NONE` at startup. USB-serial/cdc-acm/mxser only
expose it via ioctl. This is GENI-specific policy, not a tree-wide tty
change.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.**
- Tree: `v7.3-rc4-27-gf0100363d8c37`, Makefile `VERSION=7 PATCHLEVEL=3
  SUBLEVEL=0 EXTRAVERSION=-rc4`
- Driver: `drivers/tty/serial/qcom_geni_serial.c` since 2018
- `qcom_geni_serial_startup()` present
- `tty_port_close_start()` still waits on `closing_wait`
- Commit **acba38e675dd** is an ancestor of HEAD (already applied here).
  That is not used as “already selected”; it confirms the surrounding
  code matches.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean in this tree** (already applied). Context in this tree
has later PM-runtime/`tx_kick_enabled` lines around startup; the hunk
itself is still the same 8 lines.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This *is* the fix. No alternate fix for console `closing_wait`.
Reboot/panic quiesce commits do not replace it.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **serial / qcom_geni** (`CONFIG_SERIAL_QCOM_GENI`, optional
`CONFIG_SERIAL_QCOM_GENI_CONSOLE`). **IMPORTANT** (not core mm/VFS):
Snapdragon phones, laptops, and embedded boards. Console + watchdog is a
production path on those platforms.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively developed in 7.x (DMA, nbcon, runtime PM, SA8255p). The
wait-on-close bug is still in the old 2018 startup/close design, not a
new-feature-only issue.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific + config-specific:** `ARCH_QCOM` (or
`COMPILE_TEST`) with GENI UART used as **console**. Non-console GENI
ports unchanged.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Power-off/reboot (or last close of the console tty) while TX is
still pending. Common on Android/embedded with systemd feeding the
watchdog. Unprivileged users do not typically close the system console;
**root/systemd** does. Not a local-priv-esc, still a production shutdown
failure.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Watchdog reset / failed power-off.** **HIGH** (hang then
reset). Can interrupt an otherwise orderly shutdown (unmount/sync still
in progress). Not a KASAN/UAF class bug.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** High for GENI-console devices: avoids 30s stall /
  watchdog reboot on power-off.
- **Risk:** Very low: 8 lines, console-only, existing flag, no locking
  change.
- **Ratio:** Benefit clearly outweighs risk.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real user-visible failure: shutdown blocked 30s → watchdog reset on
  Qualcomm GENI console.
- Small, obviously correct use of `ASYNC_CLOSING_WAIT_NONE`.
- Console-only; non-console ports unchanged.
- No new APIs/features.
- Driver and bug path exist in this tree since the 2018 GENI UART
  driver.
- Applied by TTY maintainer (Greg KH) as v1 with no NAK.
- Matches stable “hardware workaround / hang fix” practice.

AGAINST:
- No public Reported-by / Tested-by / syzbot.
- Workaround, not a hardware TX-stuck root-cause fix; last console bytes
  on close may be dropped.
- Author’s “shutdown can cancel TX” claim is imprecise for console
  *close* (`tty_port_shutdown` skips consoles).
- Affects one SoC UART family, not all machines.

UNRESOLVED:
- Stable list discussion (lore.kernel.org/stable 403).
- Independent reproducer beyond the commit text.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — mechanism matches tty_port;
   merged by maintainer. Internal Qualcomm testing implied, not
   independently reproduced here.
2. Fixes a real bug that affects users? **PASS** — power-off
   hang/watchdog on GENI console.
3. Important (crash/security/corruption/deadlock)? **PASS** — watchdog
   reset / failed shutdown is a serious hang/reset, not cosmetic.
4. Small and contained? **PASS** — +8 lines, one function, one file.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — `startup()`,
   `uart_console()`, `tty_port`, `ASYNC_CLOSING_WAIT_NONE` all exist
   here.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/DT/build/docs exception. It is a
**hardware/driver workaround** for a shutdown hang, which stable
routinely takes.

**Step 9.4: MAKE YOUR DECISION**
This tree has the GENI serial driver and the 30s close-wait path. The
patch is a small, console-only workaround that prevents a production
watchdog reset on power-off. That is within stable rules for this
checkout.

===============================================================
What the commit solves for this tree
===============================================================
Without the change, closing the GENI console tty waits up to 30s for TX
to drain. GENI TX can sit in an unfinished sequencer command, so the
wait often runs to the timeout. If systemd feeds the watchdog, the
machine resets instead of powering off. Setting `closing_wait` to
`ASYNC_CLOSING_WAIT_NONE` only for console ports skips that drain. Cost
is possible loss of the last console bytes on close; that is preferable
to a watchdog reboot.

===============================================================
Verification
===============================================================
- **[Phase 1]** Parsed tags: Link to msgid `20260706093749.836121-1`;
  SOB Aniket Randive + Greg KH; no Fixes/Reported-by/Cc:stable.
- **[Phase 2]** Diff: +8 in `qcom_geni_serial_startup()`; sets
  `tport->closing_wait` for `uart_console()`.
- **[Phase 2]** `tty_port_init`: default `closing_wait = (3000 * HZ) /
  100` (30s). `tty_port_close_start` waits unless
  `ASYNC_CLOSING_WAIT_NONE`.
- **[Phase 2]** `tty_port_shutdown`: returns early if `port->console` —
  console close does not call driver shutdown. Hangup *does* call
  `uart_shutdown()`.
- **[Phase 2]** `qcom_geni_serial_tx_empty` reads
  `SE_GENI_TX_FIFO_STATUS`; stuck TX keeps wait alive.
- **[Phase 3]** `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` → `7.3.0-rc4`.
- **[Phase 3]** `git merge-base --is-ancestor acba38e675dd HEAD` → yes
  (present; not used as “already selected”).
- **[Phase 3]** Blame: startup from c4f528795d1ad (2018); closing_wait
  lines from acba38e675dd.
- **[Phase 3]** `git merge-base --is-ancestor acba38e675dd v7.3-rc1` →
  yes; not in v7.2.
- **[Phase 4]** `b4 dig -c` → v1 lore URL; `-a` → only v1; `-w` →
  gregkh, jirislaby, linux-serial, linux-arm-msm; `-m` → no review
  replies.
- **[Phase 4]** WebFetch lore → 403; Openwall/LKML mirrors match the
  committed patch.
- **[Phase 5]** Callers: `uart_port_startup` → `ops->startup`; userspace
  close path confirmed.
- **[Phase 6]** File and `startup()` exist; Kconfig `SERIAL_QCOM_GENI` /
  `SERIAL_QCOM_GENI_CONSOLE`.
- **[Phase 8]** Failure: watchdog reset on power-off, severity HIGH,
  risk of fix very low.
- **UNVERIFIED:** stable@ discussion (lore/stable 403). Independent
  public reproducer.

**YES**

 drivers/tty/serial/qcom_geni_serial.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 5d59a2cfab3e2..0807ca83d8078 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1244,6 +1244,7 @@ static int qcom_geni_serial_startup(struct uart_port *uport)
 {
 	int ret;
 	struct qcom_geni_serial_port *port = to_dev_port(uport);
+	struct tty_port *tport = &uport->state->port;
 
 	if (!port->setup) {
 		ret = qcom_geni_serial_port_setup(uport);
@@ -1251,6 +1252,13 @@ static int qcom_geni_serial_startup(struct uart_port *uport)
 			return ret;
 	}
 
+	/*
+	 * Skip the close-time transmit drain for console ports so that
+	 * shutdown can proceed without waiting for pending TX completion.
+	 */
+	if (uart_console(uport))
+		tport->closing_wait = ASYNC_CLOSING_WAIT_NONE;
+
 	uart_port_lock_irq(uport);
 	qcom_geni_serial_start_rx(uport);
 	uart_port_unlock_irq(uport);
-- 
2.53.0

