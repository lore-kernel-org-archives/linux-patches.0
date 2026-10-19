Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AD8513BD8;
	Mon, 19 Oct 2026 13:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418223; cv=none; b=MztxnoOqKzvFazLlYQt2q3m3lHan9xzJfpnw8DCVrxXz/mTsZ9pBxwbrQLr6WNmWxTkCv+Tu5KkbvJxRtvH8h8m5ku+OJ2T4FhteMCoowAxykCZYPr/5bP9fRoBwEYCm9BPygo6v1kFJQZ4gRH9ugkAOcPZhyVpFcYDbnMK1OVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418223; c=relaxed/simple;
	bh=3es7n51+Q0LGQP9Wl8jErystEOS50uO+n0RsPoVOa/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A+q8KW/5H9eFkIYZNKLEpe8Kamk92HDtEynOvLKomDACbhBX+wtx9yK6DB96qZwNCR59trLhY3VGK1gVjfNb0liQpxVkVs3SyKOd1o45iqg5FUp7OHvlRws3dj/SowFIorYqHQayxo8crZwy/5oy5Yg9n/iV3tBIQYeWVXuMNZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SqhhAzln; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SqhhAzln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB28E1F000C8;
	Mon, 19 Oct 2026 13:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418220;
	bh=M70VlpRT59EjCQshNMw662ftj9w+gKoHqn8i5U7vYRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SqhhAzlnEgEbmwNvIynxDhckMQ00g+PFO9Mj2MmKKX71v9ETKlZvpdFx6yKYlTTrv
	 cdFnRSyYnkwD/HTnqvBjXJiv0YTBEOsO5ZzPzwdjy58gjpBuvwgIzkW25HWOBehJba
	 Rku6kSZoqNDJwq3ZjckIv4eq+/AmkCgzRSny9KqcZsK+KuCdVXcor83nNhaubdch+M
	 ndD9t66CRnfdznT/vz+G3fi35BBNXiDLCgYx5t/LOuGMsQwa7cgqonk1ER+8mTcLuC
	 z7WGovfvaz1NMOhTiroh1rGCX4mBGqetiPh5CmaY8FMsoN7Va0iZPocklV9QOhPdqc
	 taHn9mFFdyBxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: William Hansen-Baird <william.hansen.baird@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: rtlwifi: rtl8723be: Remove unnecessary irq save/restore in hw_init()
Date: Mon, 19 Oct 2026 09:46:29 -0400
Message-ID: <20261019135441.1420968-98-sashal@kernel.org>
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

From: William Hansen-Baird <william.hansen.baird@gmail.com>

[ Upstream commit 1b4cd55626b6ffa93d18848412afb912a4add585 ]

rtl8723be hw_init() calls local_save_flags(flags) followed by
local_irq_enable(). Later, local_irq_restore(flags) is called.

This causes warnings from Lockdep on boot and modprobe,
as local_irq_restore(flags) should only be called while irqs are disabled.
The warning was introduced to detect this class of bug in [1].

With testing I found that all paths which call hw_init() have irqs
already enabled for rtl8723be.

Furthermore, the calls were originally added for the rtl8192ce
in commit f78bccd79ba3 ("rtlwifi: rtl8192ce: Fix too long disable of IRQs")
before later being added to most other rtlwifi drivers.

Commit d3feae41a347 ("rtlwifi: Update power-save routines for 062814 driver")
then replaces the call to spin_lock_irqsave() before hw_init(),
and thus the codepath which caused irqs to be disabled in hw_init and
prompted the original commit has been removed.

The same irq save/restore pattern is also present in the hw_init() of
rtl8192ce, rtl8723ae, rtl8188ee, rtl8192se and rtl8192cu,
however I don't have the hardware to test them,
so I did not include them in my changes.

Tested on a Razer Blade 14 2017.

Example of output from Lockdep prior to fix:

raw_local_irq_restore() called with IRQs enabled

...

Call Trace:
<TASK>
rtl8723be_hw_init+0x5992/0x7220 [rtl8723be]
? static_obj+0x61/0xa0
rtl_pci_start+0x222/0x5c0 [rtl_pci]
rtl_op_start+0x128/0x1a0 [rtlwifi]
? __kasan_check_read+0x11/0x20
drv_start+0x16c/0x550 [mac80211]

...

irq event stamp: 887679
hardirqs last  enabled at (887689): [<ffffffff96511170>] __up_console_sem+0x90/0xa0
hardirqs last disabled at (887698): [<ffffffff96511155>] __up_console_sem+0x75/0xa0
softirqs last  enabled at (887670): [<ffffffff962f4675>] __irq_exit_rcu+0x175/0x2f0
softirqs last disabled at (887649): [<ffffffff962f4675>] __irq_exit_rcu+0x175/0x2f0
---[ end trace 0000000000000000 ]---

[1] https://lore.kernel.org/all/20210111153707.10071-1-mark.rutland@arm.com/

Signed-off-by: William Hansen-Baird <william.hansen.baird@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260609095359.2964193-1-william.hansen.baird@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (mainline 7.3). The candidate is a six-
line IRQ API fix in `rtl8723be_hw_init()` that stops a real `WARN_ONCE`
on boot. Full phase walkthrough follows.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[wifi: rtlwifi: rtl8723be]** **[Remove]** unnecessary irq
save/restore in `hw_init()`. Intent: drop a leftover `local_save_flags`
/ `local_irq_enable` / `local_irq_restore` sequence that is no longer
valid.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Acked-by:** Ping-Ke Shih `<pkshih@realtek.com>` (rtlwifi maintainer)
- **Signed-off-by:** William Hansen-Baird (author); Ping-Ke Shih
  (maintainer)
- **Link:** https://patch.msgid.link/20260609095359.2964193-1-
  william.hansen.baird@gmail.com
- No Fixes:, Reported-by:, Tested-by:, Cc: stable (absence expected)
- Ignore pipeline SOBs

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `rtl8723be_hw_init()` does `local_save_flags(flags);
  local_irq_enable();` … `local_irq_restore(flags)` while IRQs are
  already enabled.
- **Symptom:** `WARN_ONCE` from `warn_bogus_irq_restore()`:
  `raw_local_irq_restore() called with IRQs enabled`, on boot and
  `modprobe`. Stack: `rtl8723be_hw_init` → `rtl_pci_start` →
  `rtl_op_start` → `drv_start`.
- **Root cause:** The save/enable/restore was copied from rtl8192ce
  (`f78bccd79ba3`, 2014) to keep IRQs enabled during a long `hw_init()`
  that used to run under `spin_lock_irqsave()`. `d3feae41a347` (2014)
  removed that irqsave around the power-save/`hw_init` path, so callers
  now enter with IRQs enabled. Restore of already-enabled flags is
  forbidden.
- **Version info:** Pattern present since the rtl8723be driver was added
  (`a619d1abe20cc`, 2014-02-28). Warning added in `997acaf6b4b59`
  (2021).
- **Author explanation:** All current rtl8723be `hw_init()` callers have
  IRQs enabled (tested on a Razer Blade 14 2017). Sibling chips still
  have the pattern but were left alone for lack of hardware.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not hidden. Explicit lockdep/IRQ-restore warning fix. “Remove
unnecessary” is accurate: the sequence became a no-op plus a warning
after the 2014 caller change.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c` — **6
  deletions, 0 additions**
- Function: `rtl8723be_hw_init()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** Save flags, force IRQs on for the whole init, restore
  flags at the `exit:` label (success and error).
- **After:** Init runs in the caller’s IRQ state; `exit:` only clears
  `being_init_adapter`.
- **Path:** Normal and error `hw_init()` (boot, `modprobe`, interface
  start, IPS nic-on).

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Logic / IRQ-flag API misuse** (WARN_ON class).
`local_irq_restore()` must be called with IRQs disabled
(`raw_check_bogus_irq_restore()` in `include/linux/irqflags.h`). Callers
already have IRQs enabled, so restore trips `WARN_ONCE`. Same class as
`8b144dedb928e` (“rtlwifi: rtl8192cu: Fix WARNING when calling
local_irq_restore() with interrupts enabled”), which used
`local_irq_disable()` before restore and was **Cc: stable**. Here the
save/enable/restore is removed because it is no longer needed.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct if all callers have IRQs enabled (author tested;
  maintainer agreed; `rtl_pci_start` / `rtl_op_start` /
  `rtl_ps_enable_nic` are process-context, mutex/work, not
  `spin_lock_irqsave`).
- Minimal: six lines deleted, no unrelated edits.
- Regression risk: if some caller still had IRQs off, `hw_init()` could
  run ~hundreds of ms with IRQs disabled (the 2014 audio-underrun/clock-
  freeze bug). Verified not the case in this tree. Maintainer: “current
  `hw_init()` is not in scope of `spin_lock_irqsave()`, so irqs is not
  disabled.”

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record: IRQ save/restore was in rtl8723be from **`a619d1abe20cc`
(“rtlwifi: rtl8723be: Add new driver”, 2014-02-28)**. Pattern copied
from rtl8192ce `f78bccd79ba3` (2014-02-01). Present for ~12 years.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No Fixes: tag. Related history:
- `f78bccd79ba3` — **in this tree** — added save/enable/restore because
  `hw_init` ran too long with IRQs off.
- `d3feae41a347` — **in this tree** — replaced `spin_lock_irqsave`
  before `hw_init` with `spin_lock` / mutex; IRQ-disabled caller gone.
- `997acaf6b4b59` — **in this tree** — added the `WARN_ONCE`.
- `8b144dedb928e` (2021) — **in this tree** — same warning on rtl8192cu;
  **Cc: stable**.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent `rtl8723be/hw.c` commits are unrelated (stack size, const
arrays, LED, `kfree_skb`). Standalone; not patch X/Y in the committed
form (v2 was a single patch).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: William Hansen-Baird is a contributor, not the maintainer.
Nearby work is separate ASPM quirks for the same chip (June 30), not
prerequisites. Maintainer Ping-Ke Shih acked and applied it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: None. Deletes three API calls that have existed since 2014.
Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- Lore/msgid: https://patch.msgid.link/20260609095359.2964193-1-
  william.hansen.baird@gmail.com
- v1: https://patch.msgid.link/20260608135345.2526325-3-
  williamhb+k@fastmail.com
- v1 → v2: drop dmesg timestamps, `[1]` footnote, `rtw-next` subject
  prefix. **Code unchanged.**
- Maintainer: “I think removal is okay.” No NAK. No Cc: stable in
  review. Applied to rtw-next as `1b4cd55626b6`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: To/Cc: `pkshih@realtek.com`, linux-wireless, linux-kernel.
Subsystem maintainer reviewed and Acked.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot/bugzilla for this exact chip. Author reproduced on a
Razer Blade 14 2017 with a full lockdep-style trace. Same warning class
was syzbot+stable for rtl8192cu in 2021.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: v1 msgid `-3` looks like a series slot; v2 was sent standalone.
Other June 2026 Hansen-Baird rtlwifi patches are ASPM, independent.
Sibling drivers (rtl8192ce, rtl8723ae, rtl8188ee, rtl8192se, rtl8192cu)
still have the pattern; not required for this chip’s fix.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: No stable-thread discussion found for this subject. Precedent:
`8b144dedb928e` was explicitly Cc: stable for the same warning.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `rtl8723be_hw_init()` only.

**Step 5.2: TRACE CALLERS**

Record:
- `rtl_pci_start()` (`pci.c:1737`) ← `rtl_op_start()` (`core.c:129`,
  `conf_mutex`) ← mac80211 `drv_start`. Matches the reported stack.
  Process context, IRQs on.
- `rtl_ps_enable_nic()` (`ps.c:26`) ←
  `_rtl8723be_phy_set_rf_power_state()` IPS ERFON path (`phy.c:2534`) ←
  `rtl_ps_set_rf_state()` (plain `spin_lock`, not irqsave) ←
  `rtl_ips_nic_on()` (`ips_mutex`). Process/work context, IRQs on.
- USB `rtl_usb_start()` also calls `hw_init`; **RTL8723BE is PCIe-only**
  (`CONFIG_RTL8723BE`).

**Step 5.3: TRACE CALLEES**

Record: MAC/FW/PHY init, register I/O, `rtl8723be_dm_init`. Long-
running, sleepable. Must not run with IRQs off for hundreds of ms —
which is why 2014 added enable, and why it is safe to drop now that
callers already have IRQs on.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Userspace-reachable: interface up / module load / IPS wake.
Unprivileged users who can bring the interface up can hit it. Debug
kernels dump a warning on every start.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same save/enable/restore still in rtl8723ae, rtl8192ce,
rtl8188ee, rtl8192se, rtl8192cu. rtl8192cu already does
`local_irq_disable()` before restore (`8b144dedb928e`). Systematic
leftover; this patch only fixes the tested chip.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Local tree: **`v7.3-rc4-27-gf0100363d8c37`**, `VERSION=7 PATCHLEVEL=3`
  (7.3.0-rc4).
- Driver and `rtl8723be_hw_init()` exist. Buggy sequence was here from
  2014 until **`1b4cd55626b6f`**, which is already in **v7.3-rc1** (not
  in v7.2).
- Current `hw.c` has no `local_save_flags` (grep empty). Evaluation is
  of the fix’s merit for this lineage, where the bug lived for years and
  the code still matches.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: Expected apply: **clean**. Six-line deletion of a pattern
unchanged since 2014. No structural dependency on later rtlwifi
refactors.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: This exact fix is in 7.3-rc1. No alternate fix for rtl8723be.
rtl8192cu’s 2021 workaround is a sibling, not a substitute.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **wifi / rtlwifi / rtl8723be** (Realtek RTL8723BE PCIe 802.11n).
**IMPORTANT** (common 2014–2018 laptop WiFi: ThinkPads, Razers, etc.),
not core mm/net.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature, low-churn vendor driver. Bug is old leftover, not a new-
feature regression.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver-specific**, `CONFIG_RTL8723BE`. Warning only with
**`CONFIG_DEBUG_IRQFLAGS`** (selected by `DEBUG_LOCKDEP`). Debug/lockdep
kernels, syzbot-style configs, `panic_on_warn`. Production distro
kernels usually omit lockdep, so they would not print it — the API
misuse is still present.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Every `hw_init()`: boot, `modprobe`, iface start. Not a race.
Unprivileged users can trigger via network start if the module is
loaded.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: `WARN_ONCE` in `warn_bogus_irq_restore()`. Not a panic/oops by
default. Can panic if `panic_on_warn`. Mark Rutland’s 2021 commit notes
restore-with-IRQs-enabled can desync IRQ-state tracing and break archs
whose `arch_local_irq_restore()` assumes IRQs are off. **Severity:
MEDIUM** (WARN_ON), with a documented arch/lockdep correctness angle.
Prompt lists WARN_ON triggers as a strong backport signal.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** Stops a boot-time warning on a common laptop chip;
  restores correct IRQ API use. Same class already taken into stable for
  rtl8192cu.
- **Risk:** Very low (6-line delete). Residual risk is long IRQ-off
  `hw_init` if some caller still had IRQs disabled — **not true in this
  tree**.
- **Ratio:** Favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real, reproduced `WARN_ONCE` on boot/`modprobe` (Razer Blade 14 2017).
- Incorrect `local_irq_restore()` usage; can confuse lockdep and some
  arch restore paths.
- Six-line deletion, obviously correct once callers have IRQs enabled
  (verified in `rtl_pci_start` / `rtl_op_start` / IPS).
- Tested on hardware; Acked and applied by Ping-Ke Shih.
- Same warning on rtl8192cu was **Cc: stable** in 2021.
- Driver present since 2014; no missing prerequisites.
- WARN_ON is listed as a strong stable signal.

**AGAINST:**
- Warning is gated on `CONFIG_DEBUG_IRQFLAGS`; typical production
  kernels never print it.
- Not a crash, deadlock, corruption, or security hole in the default
  config.
- Sibling chips left unfixed (incomplete family-wide cleanup, not a
  dependency).
- Removing enable-IRQs-during-init would be harmful if an IRQ-disabled
  caller still existed (none found here).

**UNRESOLVED:** Could not fetch lore HTML (403); used `b4 dig -m` mbox
instead. No stable@ thread found for this specific subject.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — hardware test + maintainer
   ack; callers have IRQs on.
2. Fixes a real bug that affects users? **PASS** — lockdep/debug warning
   on every start of this NIC.
3. Important issue? **PASS** (MEDIUM) — WARN_ONCE; same class previously
   shipped to stable; not a production panic.
4. Small and contained? **PASS** — 6 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — code exists; deletion applies
   cleanly to the pre-fix file.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: None (not a device ID, quirk table, DT, build, or docs-only
change). Qualifies as a normal small bugfix.

**Step 9.4: MAKE YOUR DECISION**

This is a small, verified fix for a real IRQ-flag warning that fires on
a common PCIe WiFi chip whenever `hw_init()` runs under debug
IRQ/lockdep configs. Callers in this tree already have IRQs enabled, so
deleting the leftover save/enable/restore is the right fix and does not
reintroduce long IRQ-off init. Benefit clearly beats risk.

---

### What the commit solves for stable users

`rtl8723be_hw_init()` restored IRQ flags while IRQs were already
enabled, which `CONFIG_DEBUG_IRQFLAGS` treats as broken and warns on
every boot/`modprobe`. The enable/restore dance was only needed when
`hw_init()` ran under `spin_lock_irqsave()`; that path has been gone
since 2014. Users of RTL8723BE (many 2014–2018 laptops) on debug kernels
get a stack dump at start; `panic_on_warn` would panic.

### Stable rules / risk vs benefit

Meets all six rules: tiny, tested, no new API, applies cleanly. Risk is
a 6-line delete. Benefit is removing a boot-time WARN and illegal
restore. Same bug class was already backported for rtl8192cu.

### Concerns

None that block a backport here: no extra commits required; sibling
chips are independent; production kernels without `DEBUG_IRQFLAGS`
simply never print the warning, but the misuse is still worth fixing.

---

Verification:
- [Phase 1] Parsed tags: Acked-by Ping-Ke Shih; Link msgid
  20260609095359; no Fixes/Cc:stable/syzbot
- [Phase 1] Body: lockdep `raw_local_irq_restore() called with IRQs
  enabled`; stack `rtl8723be_hw_init` → `rtl_pci_start` → `rtl_op_start`
- [Phase 2] Diff: 6 deletions in `rtl8723be_hw_init()` only (`git show
  1b4cd55626b6f`)
- [Phase 3] `git merge-base --is-ancestor`: `f78bccd79ba3`,
  `d3feae41a347`, `997acaf6b4b59`, `8b144dedb928e` all in HEAD
- [Phase 3] `git log -S local_save_flags -- rtl8723be/hw.c`: introduced
  in `a619d1abe20cc` (2014), removed in `1b4cd55626b6f`
- [Phase 3] `8b144dedb928e`: same warning on rtl8192cu, Cc: stable,
  added `local_irq_disable()` before restore
- [Phase 4] `b4 dig -c 1b4cd55626b6f`: lore match; v1→v2 message-only;
  maintainer ack, no NAK
- [Phase 4] `b4 dig -m`: saved /tmp/rtl8723be-thread.mbox (721 lines);
  WebFetch lore HTML 403
- [Phase 5] Callers: `rtl_pci_start` under `conf_mutex`;
  `rtl_ps_enable_nic` from IPS via `spin_lock` not irqsave
- [Phase 5] Grep: sibling drivers still have `local_save_flags`;
  rtl8723be file has none after the fix
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` 7.3.0-rc4
- [Phase 6] Commit in v7.3-rc1, not v7.2; current hw.c already patched
- [Phase 7] `CONFIG_RTL8723BE` PCIe 802.11n; driver added 2014
- [Phase 8] `warn_bogus_irq_restore()` is `WARN_ONCE`; `DEBUG_LOCKDEP`
  selects `DEBUG_IRQFLAGS`
- UNVERIFIED: no stable@ mailing-list thread for this exact subject
  (search not exhaustive beyond b4/git)

The fix is small, surgical, and meets the stable criteria for this tree.

**YES**

 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index e1f8112188949..bf7b5a32adaaf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -1333,11 +1333,6 @@ int rtl8723be_hw_init(struct ieee80211_hw *hw)
 	bool rtstatus = true;
 	int err;
 	u8 tmp_u1b;
-	unsigned long flags;
-
-	/* reenable interrupts to not interfere with other devices */
-	local_save_flags(flags);
-	local_irq_enable();
 
 	rtlhal->fw_ready = false;
 	rtlpriv->rtlhal.being_init_adapter = true;
@@ -1443,7 +1438,6 @@ int rtl8723be_hw_init(struct ieee80211_hw *hw)
 
 	rtl8723be_dm_init(hw);
 exit:
-	local_irq_restore(flags);
 	rtlpriv->rtlhal.being_init_adapter = false;
 	return err;
 }
-- 
2.53.0

