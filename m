Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225D4538741;
	Mon, 19 Oct 2026 13:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418174; cv=none; b=bSQnM+y61uD8r7nmpzUC3vKzJxOY03A6n4IPUgebeXUjXMBPHqtTT5u6pmB+cEnbZgJ2bZHmRimcSmXm0BjYf0DbuAU4dEG1yRtUGSsBG1L2R0yK996IhUxBJXtdhtaDxfFCHra8tWf5gUuG0ILoEdXzJlFh0cLuC/zEBKWrhJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418174; c=relaxed/simple;
	bh=MsYuuonF+t8Vet8Hd4vyBkQ3hI11jrb+4rAv2QYnZqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j9Do1o1NzxqjVhaZKwrEZ4ROoZi3fUlJh1nh4hgIc1bofaGtKTtv9wEFLVRNcKd0/O4BwhmEj91/I4LL3zFsp0t7mde9MpwDGUhRDgA799Er1sHNMR95s5VdDN/pMyVJnvscveQ+SzFDreMRdQ5QvB45Gbst42QT+GnyN4a9rQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UsTrLdsx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UsTrLdsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316751F000C7;
	Mon, 19 Oct 2026 13:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418172;
	bh=ICmoUyCunv4E8CECVZGCjgTclZEh1+4vusTPYfelhOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UsTrLdsxW02tzARaXeYSf9ITYP3vxgIuhNsy+PswKSfYwaZ1CkwF5JYicbvcxrahp
	 QnFkpdzUh5jnjSij2QkMbofFaudm1jFxDoLUhmCXeEvipD93YejGI/h+OfldHD0u2X
	 qBU5EP9htVXEsf6gRoyV6fQijcoTSFg+xZOZ9sT4SpGAHiXWGYKQLXgbdfe0Sgl3j4
	 C4fRYkmIcG/wGOd4k2Nm0eZViPgpuGucN3sB0eAcML5nzK1aMW1rLbBrxn9LN2i862
	 MgWWx+KwSrke/z9FZvplLOkqO43Ig1i6GAe/MfkhH5sGwG8xU2XCNOtt1ZuxLHallP
	 +Nzw8FC4paTcQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rahul Bukte <rahul.bukte@sony.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	jirislaby@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] serial: 8250: force synchronous probe for the ISA and PNP drivers
Date: Mon, 19 Oct 2026 09:45:54 -0400
Message-ID: <20261019135441.1420968-63-sashal@kernel.org>
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

From: Rahul Bukte <rahul.bukte@sony.com>

[ Upstream commit 31e11af34e2c7cc61e25533ab877b1f9cc3eb528 ]

On x86_64 defconfig, booting with driver_async_probe=serial hangs in early
init. The 8250 PNP driver is put onto the async probe pool.
serial8250_register_8250_port() runs in a kworker concurrently with the
ISA registration done from the serial8250_init() initcall resulting in a
deadlock or NULL dereference.

  - Deadlock: serial_core_register_port() holds port_mutex across
    serial_core_add_one_port()
        uart_configure_port()
            autoconfig_irq()
                probe_irq_on()
                    async_synchronize_full(),
    which waits for the async probe pool to drain.

    The async PNP worker reaches the "port already in use" check and
    tries to unregister it.
    serial8250_register_8250_port()
        uart_remove_one_port()
            serial_core_unregister_port()
    This blocks on port_mutex.
    The init thread waits for the worker and the worker waits for the
    init thread.

  - NULL deref: when the worker instead observes a slot whose port.dev
    is set but whose port_dev has not yet been populated, it hits the
    null pointer on the call to serial_core_get_ctrl_dev() in
    serial_core_unregister_port().

Signed-off-by: Rahul Bukte <rahul.bukte@sony.com>
Link: https://patch.msgid.link/20260610054130.2825182-1-rahul.bukte@sony.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4**. The two-line `PROBE_FORCE_SYNCHRONOUS`
change is a real deadlock/NULL-deref fix on the 8250 ISA vs PNP probe
path, and the affected code is present here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[serial/8250] [force] force synchronous probe for the ISA and
PNP drivers`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Rahul Bukte <rahul.bukte@sony.com>` (author)
- `Link: https://patch.msgid.link/20260610054130.2825182-1-
  rahul.bukte@sony.com`
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>` (tty
  maintainer applied it)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence of Fixes/Cc-stable is expected for this
  review)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** On x86_64 defconfig, `driver_async_probe=serial` hangs in
  early init. The 8250 PNP driver (`name = "serial"`) is queued for
  async probe while `serial8250_init()` still registers ISA ports.
- **Symptom/failure mode:**
  1. **Deadlock:** ISA `serial_core_register_port()` holds `port_mutex`
     through `autoconfig_irq()` → `probe_irq_on()` →
     `async_synchronize_full()`. The async PNP worker hits the in-use
     port path and blocks in `serial_core_unregister_port()` on the same
     mutex.
  2. **NULL deref:** The worker sees `port.dev` set but `port_dev` still
     NULL, then `serial_core_get_ctrl_dev(port_dev)` oopses.
- **Version information:** None beyond “x86_64 defconfig”.
- **Root cause:** Concurrent ISA initcall registration vs async PNP
  probe of the same 8250 port slots.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit deadlock/oops fix.
The in-thread note “Found while experimenting with
`driver_async_probe=*` to improve boot time” only explains how it was
found, not that it is theoretical.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `drivers/tty/serial/8250/8250_platform.c`: +1
  (`serial8250_isa_driver.driver.probe_type`)
- `drivers/tty/serial/8250/8250_pnp.c`: +1
  (`serial_pnp_driver.driver.probe_type`)
- Two insertions total. Surgical, two-file, same subsystem.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** Both drivers use default `PROBE_DEFAULT_STRATEGY`.
  `driver_allows_async_probing()` then honors `driver_async_probe=` /
  module async-probe, so PNP probe can run in a kworker while
  `serial8250_init()` is still in the initcall.
- **After:** `PROBE_FORCE_SYNCHRONOUS` makes
  `driver_allows_async_probing()` return false, so probe stays on the
  registration thread and cannot overlap ISA `uart_add_one_port()`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** Race → deadlock and NULL dereference.
- **Mechanism verified in this tree:**
  - `serial8250_init()` calls `serial8250_pnp_init()` then later
    `serial8250_register_ports()` which sets `up->port.dev` and calls
    `uart_add_one_port()`.
  - `serial_core_register_port()` holds `port_mutex` across
    `serial_core_add_one_port()` → `uart_configure_port()` →
    `config_port()`. With `UPF_AUTO_IRQ` (x86 `STD_COM*_FLAGS` when
    `CONFIG_SERIAL_8250_DETECT_IRQ`), that reaches `autoconfig_irq()` →
    `probe_irq_on()` → `async_synchronize_full()`.
  - Concurrent PNP: `serial_pnp_probe()` →
    `serial8250_register_8250_port()`. If `uart->port.dev` is already
    set: `uart_remove_one_port()` → `serial_core_unregister_port()`.
  - `serial_core_unregister_port()` reads `port->port_dev` and calls
    `serial_core_get_ctrl_dev(port_dev)` **before** taking `port_mutex`.
    NULL `port_dev` is an oops. Non-NULL `port_dev` waits on
    `port_mutex` while the init thread waits for async probe → deadlock.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: `PROBE_FORCE_SYNCHRONOUS` exists specifically so
  drivers that cannot tolerate async probe stay synchronous, including
  against `driver_async_probe=`. Same pattern as i8042 PNP.
- Minimal: two field initializers, no API/behavior change for the
  default (already synchronous) boot path.
- Regression risk is very low. The only cost is that these two drivers
  cannot be async-probed, which is the intended workaround.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- ISA `platform_driver` struct: `ffd8e8bd26e94` (“serial: 8250: Extract
  platform driver”, 2024).
- PNP `pnp_driver` struct: original tree (`1da177e4c3f41`, 2005).
- The race is not in newly added probe_type lines; those are the fix.
  The overlapping register/unregister design is long-standing. The NULL
  deref specifically needs `port_dev` / `serial_core_get_ctrl_dev()`,
  introduced by `84a9582fd2030` (“serial: core: Start managing serial
  controllers to enable runtime PM”, in v6.5-rc1).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. The deadlock ingredients
(`probe_irq_on()` → `async_synchronize_full()` in `22a9d645677fe`;
`driver_async_probe=` in `1ea61b68d0f86`) and the serial-core `port_dev`
path are all in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Recent 8250_platform/pnp work is refactoring, not a hidden
  prerequisite series.
- This is standalone (not `patch X/Y`).
- Follow-up on these files after this commit is only `4f643bef0984b`
  (named initializers in the PNP ID table), unrelated.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Rahul Bukte is not a serial maintainer. This is their only
serial commit here; other listed commits are i915 NULL checks. Weight
comes from Greg Kroah-Hartman applying it to tty, not from author
tenure.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Standalone. It only needs `struct device_driver.probe_type` and
`PROBE_FORCE_SYNCHRONOUS`, both present in
`include/linux/device/driver.h` and `drivers/base/dd.c` in this tree.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 31e11af34e2c7`:
  https://patch.msgid.link/20260610054130.2825182-1-rahul.bukte@sony.com
- `b4 dig -a`: **v1 only**, no later revisions.
- Saved mbox (`b4 dig -m`) is the original patch only; **no review
  replies, NAKs, or Cc: stable comments**.
- Extra note in the mail (not in the committed message): “Found while
  experimenting with `driver_async_probe=*` … Tested on x86_64 defconfig
  under QEMU + KVM with `driver_async_probe=serial`.”
- lore.kernel.org HTTP fetch returned 403; LKML mirror matches the same
  v1 text.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Greg Kroah-Hartman, Jiri Slaby,
Ilpo Järvinen, linux-serial, linux-kernel. No `Reviewed-by` landed. Greg
applied it (tty maintainer SOB).

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Author reproduced a boot hang on x86_64
defconfig + QEMU. That is a concrete trigger, not a static guess.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone. Historical analogue: i8042 PNP
`PROBE_FORCE_SYNCHRONOUS` (same driver-core annotation for probes that
cannot run async). A 2018 attempt to mark 8250
`PROBE_PREFER_ASYNCHRONOUS` shows async 8250 probe has been known to be
delicate.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: `https://lore.kernel.org/stable/?q=...` returned 403. Web search
found no stable-thread discussion. **UNVERIFIED:** whether anyone
already asked for or rejected this on stable@.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: No function bodies changed. Annotations on
`serial8250_isa_driver` and `serial_pnp_driver`. Runtime effect is
through `driver_allows_async_probing()` → probe of `serial8250_probe` /
`serial_pnp_probe`.

**Step 5.2: TRACE CALLERS**
Record:
- `serial_pnp_probe`: PNP match during `pnp_register_driver()` from
  `serial8250_pnp_init()` inside `serial8250_init()` (module_init /
  boot).
- ISA path: `serial8250_register_ports()` from the same initcall;
  platform `serial8250_probe` from
  `platform_driver_register(&serial8250_isa_driver)`.
- Context: boot initcall, not a syscall hot path. Reachable on any x86
  box with 8250 + PNP (ACPI selects `PNP`; `SERIAL_8250_PNP` defaults to
  y).

**Step 5.3: TRACE CALLEES**
Record: `serial_pnp_probe` → `serial8250_register_8250_port` → possible
`uart_remove_one_port` → `serial_core_unregister_port`. ISA:
`uart_add_one_port` → `serial_core_register_port` →
`uart_configure_port` → `autoconfig_irq` → `probe_irq_on` →
`async_synchronize_full`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Triggered by the documented kernel parameter
`driver_async_probe=serial` or `=*`, not by an unprivileged syscall.
Still a real boot-time path: x86_64 defconfig sets
`CONFIG_SERIAL_8250=y`, `CONFIG_SERIAL_8250_CONSOLE=y`,
`CONFIG_SERIAL_8250_DETECT_IRQ=y`. Userspace cannot hit it after boot
unless the driver is re-probed.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Many drivers already set `PROBE_FORCE_SYNCHRONOUS` (i8042 PNP,
USB gadget UDC, PHY, Hyper-V, CXL, regulators, etc.). This is the
established way to opt a driver out of async probe.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD`: `v7.3-rc4-27-gf0100363d8c37`
- `make kernelversion` / Makefile: **7.3.0-rc4**
- Both files and both driver structs exist.
  `serial_core_unregister_port()` still dereferences `port_dev` before
  `port_mutex`. `serial8250_register_ports()` still sets `port.dev` then
  calls `uart_add_one_port()`. `probe_irq_on()` still calls
  `async_synchronize_full()`. `x86_64_defconfig` still enables
  `SERIAL_8250_DETECT_IRQ`.
- NULL-deref window exists since serial-core `port_dev` (v6.5). Deadlock
  window with `driver_async_probe` exists since that cmdline was added
  (2019) on kernels with IRQ autodetect.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply in this tree. `8250_platform.c` exists here (split
in `ffd8e8bd26e94`). `probe_type` field exists. No conflicting local
changes.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier alternate fix for this race. `git log
--grep='synchronous probe' -- drivers/tty/serial/` only shows this
commit.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/tty/serial/8250` — **IMPORTANT**. 8250 is the standard
PC UART/console driver, not staging/peripheral.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained (regular tty/serial 8250 cleanups). The bug
is in long-lived register/unregister interaction plus async probe, not
in brand-new 8250 code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Config/cmdline specific: `CONFIG_SERIAL_8250` + PNP 8250, and
`driver_async_probe=serial` or `=*`. Default boot (no that parameter)
stays synchronous and does not hit it. Population is everyone using that
documented parameter on x86 8250, including distro/OEM boot-time
experiments.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Trigger: boot with `driver_async_probe=serial` (PNP name) or `=*`.
- Not default, but documented in `kernel-parameters.txt` for boot-time
  optimization.
- Timing-dependent: deadlock vs NULL deref depends on whether `port_dev`
  is populated yet.
- Unprivileged users cannot set the cmdline after boot.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Deadlock during early init → **CRITICAL** (boot hang).
- NULL deref in `serial_core_get_ctrl_dev()` → **CRITICAL** (oops).
- Author reproduced the hang on x86_64 defconfig + QEMU.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** High for anyone using `driver_async_probe` on 8250;
  prevents boot hang/oops. Default path is unchanged.
- **Risk:** Very low (2 lines, existing driver-core flag, no locking/API
  change).
- **Ratio:** Strongly in favor of taking it.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR backporting:
- Real, reproduced boot hang and a NULL deref on a common x86_64
  defconfig.
- Failure modes are deadlock and oops (stable-class bugs).
- Two-line, obviously correct use of `PROBE_FORCE_SYNCHRONOUS`.
- Call paths verified in this 7.3-rc4 tree.
- Applied by the tty maintainer.
- Same annotation pattern as i8042 PNP.
- Default probe behavior is already synchronous; this only blocks a
  dangerous async override.

AGAINST:
- Trigger is a non-default cmdline, not everyday production boots.
- No `Reviewed-by`; mailing list had no discussion.
- Author is not a serial regular.
- No syzbot or multi-user reports.

UNRESOLVED:
- Stable@ discussion could not be fetched (HTTP 403).
- Whether a more invasive serial-core locking fix would be “more
  correct” long-term (not required for this self-contained workaround).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — two field sets; tested on
   QEMU x86_64 defconfig; Greg applied it.
2. Fixes a real bug that affects users? **PASS** — hang/oops with a
   documented kernel parameter.
3. Important issue? **PASS** — deadlock and NULL deref, severity
   CRITICAL when triggered.
4. Small and contained? **PASS** — +2 lines, two 8250 driver structs.
5. No new features or APIs? **PASS** — uses existing `probe_type`.
6. Can apply to the local tree? **PASS** — files, APIs, and buggy paths
   all exist on v7.3-rc4.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/DT/docs/build fix. Closest analogue is a
hardware/driver quirk: annotate a driver that cannot safely probe
asynchronously.

**Step 9.4: DECISION**
This belongs in this tree. The 8250 ISA/PNP overlap plus
`probe_irq_on()`’s `async_synchronize_full()` is a genuine boot deadlock
and oops once async probe is forced. The workaround is the smallest
correct change and does not alter the default synchronous boot path.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed tags: author SOB, Greg KH SOB, lore msgid link; no
  Fixes/Reported-by/Reviewed-by/Cc-stable.
- [Phase 2] Diff: +1 line each in `8250_platform.c` and `8250_pnp.c`;
  `probe_type = PROBE_FORCE_SYNCHRONOUS`.
- [Phase 2] `driver_allows_async_probing()`: `PROBE_FORCE_SYNCHRONOUS`
  returns false even when cmdline requests async.
- [Phase 2] `serial8250_init()` order: `serial8250_pnp_init()` then
  `serial8250_register_ports()` then `platform_driver_register()`.
- [Phase 2] `serial8250_register_8250_port()`: `if (uart->port.dev)
  uart_remove_one_port()`.
- [Phase 2] `serial_core_unregister_port()` calls
  `serial_core_get_ctrl_dev(port_dev)` before `port_mutex`.
- [Phase 2] `probe_irq_on()` calls `async_synchronize_full()`
  (`kernel/irq/autoprobe.c:39`).
- [Phase 2] x86 `STD_COM*_FLAGS` include `UPF_AUTO_IRQ` when
  `CONFIG_SERIAL_8250_DETECT_IRQ`; x86_64_defconfig sets that.
- [Phase 3] `git blame`: probe_type lines are this commit; surrounding
  structs are older.
- [Phase 3] `84a9582fd2030` introduced `serial_core_unregister_port`
  (contained in v6.5-rc1).
- [Phase 3] Author has no other 8250 commits; no prerequisite series.
- [Phase 4] `b4 dig -c 31e11af34e2c7`: original submission found; `-a`
  shows v1 only; `-w` lists Greg/Jiri/Ilpo/linux-serial; `-m` mbox has
  no replies.
- [Phase 4] lore.kernel.org WebFetch/curl: 403. LKML mirror confirms
  same v1 text.
- [Phase 4] UNVERIFIED: stable@ archive contents.
- [Phase 5] PNP driver `.name = "serial"` matches
  `driver_async_probe=serial`. ISA name is `serial8250`.
- [Phase 5] ACPI Kconfig `select PNP`; `SERIAL_8250_PNP` default y.
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; Makefile
  7.3.0-rc4.
- [Phase 6] `git merge-base --is-ancestor 31e11af34e2c7 HEAD`: ancestor
  (used only to confirm the code under review is this change).
- [Phase 8] Failure mode: early-init deadlock or NULL deref; severity
  CRITICAL when `driver_async_probe` is used.

The patch is small, correct, and prevents a boot hang/oops on a path
that exists in this 7.3-rc4 tree.

**YES**

 drivers/tty/serial/8250/8250_platform.c | 1 +
 drivers/tty/serial/8250/8250_pnp.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_platform.c b/drivers/tty/serial/8250/8250_platform.c
index fe7ec440ffa58..69d8720fb65bf 100644
--- a/drivers/tty/serial/8250/8250_platform.c
+++ b/drivers/tty/serial/8250/8250_platform.c
@@ -287,6 +287,7 @@ static struct platform_driver serial8250_isa_driver = {
 	.driver		= {
 		.name	= "serial8250",
 		.acpi_match_table = acpi_platform_serial_table,
+		.probe_type = PROBE_FORCE_SYNCHRONOUS,
 	},
 };
 
diff --git a/drivers/tty/serial/8250/8250_pnp.c b/drivers/tty/serial/8250/8250_pnp.c
index 7a837fdf9df13..3f41a9d6cb273 100644
--- a/drivers/tty/serial/8250/8250_pnp.c
+++ b/drivers/tty/serial/8250/8250_pnp.c
@@ -521,6 +521,7 @@ static struct pnp_driver serial_pnp_driver = {
 	.remove		= serial_pnp_remove,
 	.driver         = {
 		.pm     = pm_sleep_ptr(&serial_pnp_pm_ops),
+		.probe_type = PROBE_FORCE_SYNCHRONOUS,
 	},
 	.id_table	= pnp_dev_table,
 };
-- 
2.53.0

