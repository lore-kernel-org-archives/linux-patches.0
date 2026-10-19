Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280EC639ADD;
	Mon, 19 Oct 2026 14:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418762; cv=none; b=na47uALtmIv0bS4myxEGgTBIsFUv12XguGzXhrxK2KDBqBmUzbsxz3mt+Knj9cQ2ZpWjDVvk33/z8SeKht16eYC/DdScTjsYBZwX6GKtubV8xaFxstWctkc7+SqUTAZTWQzwbl+p62MdFZLWqRLrtlW7Gqzva6oO0R5iBBXwJIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418762; c=relaxed/simple;
	bh=j2lsVuaDxLq5YGS39Mvy5V1cjHvzvJHn+jyxw/iAeXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PsaUAjjdWlqO0KN97ChMQIu/Y2hr8iudA7W05jC/m3NB0Nm6nldEY0yTJ9m6wrsh+/BkCuhMXASB/zA2Nuo4Kjg/fwdblWedeimTddZyCwt/on4l5hE4x7Qf9ULRsErLc911M7aU+KikJBSl2mSXz2c43QHLSJvDoPpWKb49BYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e19KtIR1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e19KtIR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F5B1F000C9;
	Mon, 19 Oct 2026 14:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418758;
	bh=iYeBBRAiwhPGPvkR6LZAXASAEAQRdSSyEbmen/nO2RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e19KtIR1PR1eGqDiVRZVPJMckDv1WopesfVPIjNstGWESgzMTvFqh1nbR5O+jou4R
	 0uoFNIk3IdaOOLUGNg82t+yJrjVOcQ4KTmL7TpBZe6V6Fkb8K7gn2FYeQ6nQg1YlLm
	 +jkzXwrAZkLfj4utFjFaVZcGBg2Q1aTVeeSsHhl12lj1mwwqSZnO5jLCZsXsQsGbMV
	 pOgF6V0NoV/xXXmGTSpOMzovpE3AH6dIhA2r0useZRppFC9kmv+eq2JrN854Np09fI
	 tC/6zoZ7gEs8Hx5w8JVQygXvhq78G+fXWgyYbAetz81OLQFoNuH3Gv0dU2PMlcVJLq
	 uEA0FFhrB8zhQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	richard.henderson@linaro.org,
	linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] alpha: run the remote RTC access in a worker, not an IPI callback
Date: Mon, 19 Oct 2026 09:52:46 -0400
Message-ID: <20261019135441.1420968-475-sashal@kernel.org>
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

From: Matt Turner <mattst88@gmail.com>

[ Upstream commit 6f45effbd74012f1715584ba51abaa3196a47c08 ]

On Marvel the CMOS clock is only reachable from the boot cpu, so
remote_read_time() and remote_set_time() bounce the access there with
smp_call_function_single(), whose callback runs in hard interrupt
context.

alpha_rtc_read_time() calls mc146818_get_time() with a 10 ms timeout.
That waits out the RTC update cycle in mc146818_avoid_UIP(), which drops
rtc_lock and udelay()s 100 us at a time until the update completes or
the timeout expires:

	for (i = 0; UIP_RECHECK_LOOPS_MS(i) < timeout; i++) {
		spin_lock_irqsave(&rtc_lock, flags);
		...
		if (CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP) {
			spin_unlock_irqrestore(&rtc_lock, flags);
			udelay(UIP_RECHECK_DELAY);
			continue;
		}

So a clock read from a non-boot cpu can spin for up to 10 ms in hard
interrupt context on the boot cpu, while the cpu that sent the request
spins in smp_call_function_single() waiting for it to finish.

mc146818_set_time() does not poll, but it takes rtc_lock too, and
rtc_lock is a spinlock_t.  Only raw spinlocks may be taken in hard
interrupt context, so lockdep reports the write path as soon as a
non-boot cpu sets the clock:

  [ BUG: Invalid wait context ]
  -----------------------------
  swapper/0/0 is trying to lock:
  fffffc0003690470 (rtc_lock){....}-{3:3}, at: mc146818_set_time+0x74/0x450
  other info that might help us debug this:
  context-{2:2}
  no locks held by swapper/0/0.
  stack backtrace:
  CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.2.0-rc1 #1 NONE
  Trace:
  [<fffffc000102ebb0>] dump_stack+0x28/0x44
  [<fffffc000110efcc>] __lock_acquire+0xb0c/0x1060
  [<fffffc000110f5f0>] lock_acquire.part.0+0xd0/0x300
  [...]
  [<fffffc0001b0d834>] mc146818_set_time+0x74/0x450
  [<fffffc0001f090cc>] _raw_spin_lock_irqsave+0x7c/0xc0
  [<fffffc0001042f90>] do_remote_set+0x90/0xc0
  [<fffffc000119c1a4>] __flush_smp_call_function_queue+0x314/0x5c0
  [<fffffc000119c474>] generic_smp_call_function_single_interrupt+0x24/0x40
  [<fffffc000103d984>] handle_ipi+0xa4/0x230
  [<fffffc0001037044>] do_entInt+0x1a4/0x2e0

The rtc class ops are always called from process context, so there is no
reason to run the access from an interrupt at all.  Use work_on_cpu() to
run it in a worker on the boot cpu.  Alpha does not support cpu hotplug,
so the boot cpu cannot go offline while the work is pending.

Tested on an AlphaServer ES47 (Marvel/EV7): hwclock read and write
pinned to a non-boot cpu, twenty times, with no splat.

Signed-off-by: Matt Turner <mattst88@gmail.com>
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20260810202835.3592833-1-mattst88@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **6.12.111** (`pending-6.12`). The Marvel remote-RTC IPI
path is in this checkout, `work_on_cpu()` is available, and the patch
applies cleanly. This is a real interrupt-context bug, not a feature.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[alpha]** **[run]** — Marvel CMOS access that today runs in an
IPI callback should run in a worker on the boot CPU instead.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Reviewed-by:** Magnus Lindholm `<linmag7@gmail.com>` (Alpha co-
  maintainer)
- **Link:** `https://lore.kernel.org/r/20260810202835.3592833-1-
  mattst88@gmail.com`
- **Signed-off-by:** Matt Turner `<mattst88@gmail.com>` (Alpha
  maintainer, author)
- **Signed-off-by:** Magnus Lindholm `<linmag7@gmail.com>` (maintainer
  merge)
- No **Fixes:** tag (expected)
- No **Cc: stable** on this committed revision (expected; not used as a
  negative)
- No **Reported-by:** / **Tested-by:** tags in the commit itself; the
  body reports hardware testing by the author
- Ignore pipeline markers (**Upstream commit**, Sasha Levin SOB) per
  instructions

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** On Marvel, CMOS is only reachable from the boot CPU.
  `remote_read_time()` / `remote_set_time()` bounce via
  `smp_call_function_single()`. That callback runs in **hardirq**.
- **Read path:** `alpha_rtc_read_time()` → `mc146818_get_time(tm, 10)` →
  `mc146818_avoid_UIP()` can drop `rtc_lock` and `udelay(100us)` in a
  loop for up to **10 ms**.
- **Write path:** `mc146818_set_time()` takes `rtc_lock` (`spinlock_t`).
  Lockdep reports **Invalid wait context** (`{3:3}` lock in `{2:2}`
  hardirq) on `7.2.0-rc1` when a non-boot CPU sets the clock. Stack:
  `do_remote_set` → `__flush_smp_call_function_queue` → `handle_ipi` →
  `do_entInt`.
- **Symptom:** lockdep BUG on RTC set from a non-boot CPU; boot CPU can
  spin up to 10 ms in IPI while the requester busy-waits in
  `smp_call_function_single()`.
- **Fix:** RTC class ops already run in process context; use
  `work_on_cpu(boot_cpuid, ...)`. Alpha has no CPU hotplug, so the boot
  CPU cannot go offline under the work.
- **Tested:** AlphaServer ES47 (Marvel/EV7); `hwclock` read/write pinned
  to a non-boot CPU, twenty times, no splat.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not hidden. Explicit interrupt-context / lockdep bug fix. Not
cleanup-only.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `arch/alpha/kernel/rtc.c` only (**+12 / −25**, net −13)
- **Functions:** `do_remote_read`, `remote_read_time`, `do_remote_set`,
  `remote_set_time`
- **Scope:** single-file surgical fix under `HAVE_REMOTE_RTC`
  (`CONFIG_SMP && (CONFIG_ALPHA_GENERIC || CONFIG_ALPHA_MARVEL)`)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** non-boot CPU packs `tm` into `union remote_data`, calls
  `smp_call_function_single(boot_cpuid, do_remote_*, &x, 1)` (wait=1).
  Callback in hardirq writes `x.retval`.
- **After:** `return work_on_cpu(boot_cpuid, do_remote_*, tm)`.
  Callbacks are `long (*)(void *)` and return
  `alpha_rtc_{read,set}_time()` directly. Boot-CPU fast path unchanged.
- **Path:** userspace RTC read/set (`hwclock`, sysfs, `/dev/rtc`) from a
  non-boot CPU on Marvel.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** interrupt-context abuse / invalid locking context (plus
  hardirq latency).
- **Mechanism:** IPI hardirq took `spinlock_t rtc_lock` and could
  `udelay()` up to 10 ms. Process-context worker can take `spinlock_t`
  and sleep/delay legally.
- Not a leak, UAF, or new API.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: same CMOS work, different execution context.
- Minimal; removes the `union remote_data` marshalling that IPI wait
  required.
- **Regression risk: low.** `work_on_cpu()` sleeps; RTC ops already run
  under `rtc->ops_lock` (mutex) in `drivers/rtc/interface.c`. Alpha has
  no hotplug, so `work_on_cpu()` (not `_safe`) is the right helper.
  `work_on_cpu_key()` in this tree uses on-stack work; it does not
  return `-ENOMEM`.
- Pre-existing `smp_processor_id() != boot_cpuid` race vs migration
  exists in both old and new code; not introduced here.
- Patch 2/2 in the series (IPL 7 `trace_hardirqs_off` annotation) is
  independent; this patch does not need it.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record: IPI marshalling is from **`85d0b3a573d8b`** (“alpha: Reorganize
rtc handling”, Richard Henderson, 2013, **v3.13-rc1**). Present for the
entire life of this LTS series.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The IPI design has been wrong relative to
`mc146818_*` locking/polling since that 2013 code; the 10 ms bound is
from **`120931db07b49`** (“rtc: Add support for configuring the UIP
timeout for RTC reads”, **v6.8-rc1**), which **is** an ancestor of this
HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent `arch/alpha/kernel/rtc.c` history is RTC-core API updates
(`mc146818_get_time()` return check, UIP timeout,
`devm_rtc_allocate_device`). No competing rewrite of the remote path.
Standalone vs later RTC core, not part of a required multi-patch RTC
series.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Matt Turner is an Alpha maintainer (commits across
`arch/alpha/`, including Marvel IRQ fixes). Magnus Lindholm is also
active on Alpha (memory compaction, etc.) and reviewed this.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Needs `work_on_cpu()` (`include/linux/workqueue.h` /
`kernel/workqueue.c`) — present. Needs `alpha_rtc_{read,set}_time` +
`HAVE_REMOTE_RTC` — present. No new helpers. **Applies standalone.**
Series patch 2/2 is a separate irqflags/lockdep issue in `do_entInt()`.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c <sha>` could not run: this commit is **not** in the local
  object database.
- `b4 mbox 20260810202835.3592833-1-mattst88@gmail.com` saved a
  **4-message** thread.
- Lore HTTP fetch returned 403; mbox contents were used instead.
- **This is patch 1/2** (v2-style rewrite). An earlier May 2026 patch
  (“Use work_on_cpu() for cross-CPU RTC access”) ignored
  `work_on_cpu()`’s return value; review asked to return it directly.
  The committed diff does that.
- Magnus: “The change looks good to me.” Built/booted on AlphaServer
  ES40 (does not hit Marvel remote-RTC). **Reviewed-by** granted. No
  NAK.
- No reviewer asked for `Cc: stable` on this revision. The May posting
  mentioned stable; that is author intent on an earlier revision, not
  used as the decision.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: To `linux-alpha@`; Cc Richard Henderson, Magnus Lindholm, LKML.
Reviewed by Magnus (Alpha). Author is Alpha maintainer.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: Author-found on ES47 with lockdep (`7.2.0-rc1`). Not syzbot.
Concrete trigger: `hwclock` on a non-boot CPU. Same class of access any
userspace RTC client can perform.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: 2-patch Alpha lockdep series. **1/2 = this RTC IPI fix (self-
contained). 2/2 = IPL 7 annotation in `irq_alpha.c` (not a
prerequisite).**

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: No stable@ thread found for this subject (lore.kernel.org 403;
web search showed the LKML/linux-alpha thread only). No known NAK
against backporting.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `do_remote_read`, `remote_read_time`, `do_remote_set`,
`remote_set_time`. Callees: `alpha_rtc_read_time` / `alpha_rtc_set_time`
→ `mc146818_get_time` / `mc146818_set_time`.

**Step 5.2: TRACE CALLERS**

Record: Only hooked as `remote_rtc_ops.{read,set}_time` when
`alpha_mv.rtc_boot_cpu_only` (set in `arch/alpha/kernel/sys_marvel.c`).
Core RTC calls them from `rtc_read_time()` / `rtc_set_time()` in
`drivers/rtc/interface.c` after
`mutex_lock_interruptible(&rtc->ops_lock)` — **process context**,
userspace-reachable (`hwclock`, sysfs, `/dev/rtc`).

**Step 5.3: TRACE CALLEES**

Record: `mc146818_avoid_UIP()` loops with `spin_lock_irqsave(&rtc_lock)`
and `udelay(UIP_RECHECK_DELAY)` (100 µs), timeout 10 ms from
`alpha_rtc_read_time()`. `mc146818_set_time()` uses
`spin_lock_irqsave(&rtc_lock, flags)` (verified around the CMOS write
setup). `rtc_lock` is `DEFINE_SPINLOCK(rtc_lock)` in
`arch/alpha/kernel/time.c`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Userspace ioctl/sysfs → `rtc_{read,set}_time` (mutex) →
`remote_*` → (old) IPI on boot CPU / (new) `work_on_cpu`. **Reachable
from unprivileged or time-admin userspace** depending on `/dev/rtc`
permissions; `hwclock` is the documented trigger. Not an obscure init-
only path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Other arches use `work_on_cpu()` for CPU-local work that cannot
run in IPI (`arch/x86/kernel/apm_32.c`, cpufreq, PCI probe). No other
Alpha IPI+RTC site. No duplicate of this bug in-tree.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `arch/alpha/kernel/rtc.c` still uses
`smp_call_function_single` for remote read/set (lines 165–194 in this
checkout). Kernel **6.12.111**. Bug introduced **v3.13**; UIP 10 ms
timeout in this file since **v6.8**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **`git apply --check` succeeded** on this tree (12 insertions,
25 deletions). Surrounding RTC file matches the hunks. Include of
`<linux/workqueue.h>` is appropriate; `work_on_cpu()` macro exists under
`CONFIG_SMP`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: `git log --grep='remote RTC' -- arch/alpha/` empty. No earlier
work_on_cpu conversion. **Not already fixed.**

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **arch/alpha RTC** (Marvel SMP CMOS). Criticality:
**PERIPHERAL** (Alpha Marvel only), but RTC time get/set is user-visible
and used at boot (`hctosys`) and by `hwclock`. Wrong context can stall
the **boot CPU** in hardirq.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Alpha is low-churn but still receiving correctness fixes in this
tree (Marvel IRQ, FPCR, PCI mmap). Mature platform; this IPI scheme is
old, not new experimental code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Platform-specific:** SMP Alpha Marvel (or `ALPHA_GENERIC` on
Marvel hardware) with `rtc_boot_cpu_only`. Not x86/arm. Population is
small but real (ES47 testers).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: RTC read or set from a **non-boot CPU**. Common for `hwclock` /
systemd time if the process is not pinned to CPU0. Unprivileged trigger
depends on device node policy; typically `hwclock` is admin. Timing:
every such access, not a rare race (the IPI path is deterministic).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- **This 6.12 tree, default configs:** Alpha does **not** select
  `HAVE_PREEMPT_RT`. `PROVE_RAW_LOCK_NESTING` is **default n**, so
  `LD_WAIT_CONFIG == LD_WAIT_SPIN` and the exact `{3:3}` vs `{2:2}`
  splat needs that debug option (as on the 7.2-rc1 report).
- **Always on this tree:** boot CPU IPI handler can **poll/udelay up to
  10 ms** in hardirq; requester busy-waits. That is illegal/unwanted in
  interrupt context (IRQ latency on the boot CPU, nested IRQ mess after
  `spin_unlock_irqrestore` inside the callback).
- **With lockdep + `PROVE_RAW_LOCK_NESTING`:** lockdep BUG on set-time
  (documented stack).
- Severity for this tree: **HIGH** for the interrupt-context/latency bug
  on Marvel SMP; **not** a universal panic on a stock distro defconfig
  without lockdep. Still a real correctness bug, not cosmetic.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** Marvel SMP users stop running CMOS poll/lock in IPI;
  lockdep-enabled kernels stop the wait-context BUG; `hwclock` from a
  secondary CPU is safe.
- **Risk:** very low — ~12 lines, process-context-only, no API change,
  applies cleanly, hardware-tested.
- **Ratio:** favorable. Niche hardware is not a reason to leave a
  hardirq-delay/lockdep bug in an LTS tree that still ships Alpha.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real bug: IPI hardirq does `udelay` + `spinlock_t rtc_lock`.
- Buggy code is in **this** 6.12 tree (since v3.13).
- Small, obviously correct, maintainer-authored and reviewed.
- Tested on ES47; Magnus reviewed.
- `work_on_cpu()` exists; no hotplug on Alpha.
- Applies cleanly (`git apply --check` exit 0).
- Userspace-reachable (`hwclock`).
- Independent of series patch 2/2.

**AGAINST:**
- Only Marvel SMP Alpha.
- Stock 6.12 without `PROVE_RAW_LOCK_NESTING` may not print the lockdep
  splat; production impact is primarily **up to 10 ms boot-CPU hardirq
  stall**, not a guaranteed oops.
- No `Fixes:` tag (not a negative per rules).

**UNRESOLVED:** Could not HTTP-fetch lore.kernel.org (403); thread
recovered via `b4 mbox`. Could not `b4 dig -c` a SHA that is not in this
repo.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — ES47 `hwclock` ×20; Magnus
   Reviewed-by.
2. Fixes a real bug that affects users? **PASS** — Marvel SMP RTC from a
   non-boot CPU.
3. Important issue? **PASS** — hardirq polling/locking is a serious
   context bug (lockdep BUG under prove-locking; IRQ latency otherwise).
   Not a style cleanup.
4. Small and contained? **PASS** — one file, −13 net lines.
5. No new features or APIs? **PASS** — context change only.
6. Can apply to the local tree? **PASS** — `git apply --check`
   succeeded; prerequisites present.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary small
arch bugfix.

**Step 9.4: MAKE YOUR DECISION**

Backport. The IPI callback is the wrong context for
`mc146818_get_time()`/`mc146818_set_time()` in this 6.12 tree, the
replacement is the existing `work_on_cpu()` helper, and the change is
tiny and already shown to apply.

===============================================================
What the commit solves for stable users
===============================================================

On Marvel, CMOS must run on the boot CPU. This tree still bounces that
work with `smp_call_function_single()`, so `mc146818_avoid_UIP()` can
spin in **hardirq for up to 10 ms** and `mc146818_set_time()` takes
`rtc_lock` in that IPI. `work_on_cpu(boot_cpuid, ...)` keeps the same
CMOS access but in a worker, which matches how RTC class ops are already
invoked (mutex, process context). Alpha has no CPU hotplug, so the boot
CPU stays online for the work.

It meets stable rules: real bug, small, no new API, clean apply, tested.
Risk is low relative to leaving interrupt-context RTC access in 6.12.

===============================================================
Verification
===============================================================

- **[Phase 1]** Subject/tags parsed from the candidate message;
  Reviewed-by Magnus; Link message-id
  `20260810202835.3592833-1-mattst88@gmail.com`; no Fixes; hardware test
  described in the body.
- **[Phase 2]** Diff is only `arch/alpha/kernel/rtc.c`; IPI →
  `work_on_cpu`; union marshalling removed.
- **[Phase 2]** Local `rtc.c` still has `smp_call_function_single` in
  `remote_read_time`/`remote_set_time`.
- **[Phase 2]** `mc146818_avoid_UIP()` in `drivers/rtc/rtc-
  mc146818-lib.c` confirmed: `spin_lock_irqsave` + `udelay(100)` loop;
  `alpha_rtc_read_time()` passes timeout **10**.
- **[Phase 2]** `mc146818_set_time()` takes `rtc_lock`;
  `DEFINE_SPINLOCK(rtc_lock)` in `arch/alpha/kernel/time.c`.
- **[Phase 2]** `rtc_read_time`/`rtc_set_time` take `rtc->ops_lock`
  mutex (`drivers/rtc/interface.c`) — process context.
- **[Phase 3]** `git blame` on remote RTC: `85d0b3a573d8b` (v3.13-rc1);
  `git merge-base --is-ancestor 85d0b3a573d8b HEAD` true.
- **[Phase 3]** Timeout commit `120931db07b49` is ancestor of HEAD
  (v6.8-rc1).
- **[Phase 3]** No HOTPLUG in `arch/alpha/Kconfig`; `work_on_cpu()`
  present in `include/linux/workqueue.h` / `kernel/workqueue.c` (on-
  stack work, no `-ENOMEM`).
- **[Phase 3]** `rtc_boot_cpu_only = 1` only in
  `arch/alpha/kernel/sys_marvel.c`.
- **[Phase 4]** `b4 mbox` thread: 4 messages; patch 1/2 this fix, patch
  2/2 independent; Magnus Reviewed-by; no NAK.
- **[Phase 4]** Earlier May patch had return-value review; committed
  version returns `work_on_cpu()`.
- **[Phase 4]** lore.kernel.org WebFetch: 403; contents recovered from
  mbox.
- **[Phase 5]** Callers limited to `remote_rtc_ops`; userspace RTC path.
- **[Phase 6]** `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → **6.12.111**.
- **[Phase 6]** `git apply --check` on extracted mbox diff: **exit 0**.
- **[Phase 6]** Fix not already in this tree (`git log --grep='remote
  RTC' -- arch/alpha/` empty).
- **[Phase 7]** Alpha Marvel RTC; peripheral but user-facing.
- **[Phase 8]** `PROVE_RAW_LOCK_NESTING` default n in this tree; Alpha
  has no `HAVE_PREEMPT_RT`. Lockdep splat needs that debug option; 10 ms
  IPI `udelay` does not.
- **UNVERIFIED:** Exact mainline SHA (not in this object db). Whether
  distro 6.12 Alpha configs enable `PROVE_RAW_LOCK_NESTING`.

The patch is a small, tested context fix for a bug that exists in this
tree and applies without prerequisites.

**YES**

 arch/alpha/kernel/rtc.c | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/arch/alpha/kernel/rtc.c b/arch/alpha/kernel/rtc.c
index cfdf90bc8b3f8..9e7d714ef6f85 100644
--- a/arch/alpha/kernel/rtc.c
+++ b/arch/alpha/kernel/rtc.c
@@ -15,6 +15,7 @@
 #include <linux/bcd.h>
 #include <linux/rtc.h>
 #include <linux/platform_device.h>
+#include <linux/workqueue.h>
 
 #include "proto.h"
 
@@ -142,54 +143,40 @@ static const struct rtc_class_ops alpha_rtc_ops = {
 };
 
 /*
- * Similarly, except do the actual CMOS access on the boot cpu only.
- * This requires marshalling the data across an interprocessor call.
+ * Similarly, except do the actual CMOS access on the boot cpu only.  The
+ * access polls for the RTC update cycle and takes rtc_lock, so run it in a
+ * worker on that cpu rather than from an interprocessor interrupt.
  */
 
 #if defined(CONFIG_SMP) && \
     (defined(CONFIG_ALPHA_GENERIC) || defined(CONFIG_ALPHA_MARVEL))
 # define HAVE_REMOTE_RTC 1
 
-union remote_data {
-	struct rtc_time *tm;
-	long retval;
-};
-
-static void
+static long
 do_remote_read(void *data)
 {
-	union remote_data *x = data;
-	x->retval = alpha_rtc_read_time(NULL, x->tm);
+	return alpha_rtc_read_time(NULL, data);
 }
 
 static int
 remote_read_time(struct device *dev, struct rtc_time *tm)
 {
-	union remote_data x;
-	if (smp_processor_id() != boot_cpuid) {
-		x.tm = tm;
-		smp_call_function_single(boot_cpuid, do_remote_read, &x, 1);
-		return x.retval;
-	}
+	if (smp_processor_id() != boot_cpuid)
+		return work_on_cpu(boot_cpuid, do_remote_read, tm);
 	return alpha_rtc_read_time(NULL, tm);
 }
 
-static void
+static long
 do_remote_set(void *data)
 {
-	union remote_data *x = data;
-	x->retval = alpha_rtc_set_time(NULL, x->tm);
+	return alpha_rtc_set_time(NULL, data);
 }
 
 static int
 remote_set_time(struct device *dev, struct rtc_time *tm)
 {
-	union remote_data x;
-	if (smp_processor_id() != boot_cpuid) {
-		x.tm = tm;
-		smp_call_function_single(boot_cpuid, do_remote_set, &x, 1);
-		return x.retval;
-	}
+	if (smp_processor_id() != boot_cpuid)
+		return work_on_cpu(boot_cpuid, do_remote_set, tm);
 	return alpha_rtc_set_time(NULL, tm);
 }
 
-- 
2.53.0

