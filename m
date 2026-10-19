Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AC5544D28;
	Mon, 19 Oct 2026 14:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418790; cv=none; b=Aq3zbpV97q5+nvmDbxfPgk+cNpjnwwGItBTAPcFz4y/EjBZD6E3gObmJxP0btjjedBpVaUbi39RZYxluXBl/b9A37rOAd5CaR4hv3D2zmuaF4q1zmSAbERsw+bDtJaeQG+57MPwlrj7KGNjF/aPQoxtI0gqaj0qLobb8Xp7/1Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418790; c=relaxed/simple;
	bh=fJkha6LmVu5H1yOlJ6i3ErBwlIkdlgBqVadbQbV8ue0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tbo1yu7LlE/mkhyi1QN4xl6zGR1IcH2K+iXP4WB4bsNOQSeVzho70hlTpqLq5ZdVNcXEPEhIfZTVl5O39kN5PFyWDgNlhqaPRPSjjIng924U4lBMYfC+S21O2dUASPOynp/jaHk4nIrlgGQWLBuy4vxYLwudkq0eNF6YdULXCl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zr+1J2Tc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zr+1J2Tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628C71F000C4;
	Mon, 19 Oct 2026 14:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418787;
	bh=Mn8rlLN/UqIMZ9eBAzfdjMCtR985Ve3IyGFbKAbplhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zr+1J2Tc4zduqbpJXRAB3XzWj1fVVlTtiF1ZrIsIRa8x9bx5X9lZR+KCOPdRrT0aS
	 MW6FgrAEQTPCUyrB/0sMq22ltzlFsO6RA/0wZBeRdh/GLd/lb65OqxyXT5zsKfAv0M
	 1HF5tjohdXPv1WG4MfdCKKr1xzacqwTd7+UqmLnxf/iu4SZ9Q2JWXNOHjgZOgSiV/y
	 qvHaEBxhLcstZwWujZZn+vIt5lHE/fzF3vxcxbsJp6fnqhLk2wb3ZG7rWYC5sjwYEX
	 2/MzSt49DT2mN7KsEhBFihzBZFvroM0QQyhu4kW9WFUkJBKlAvWiqVQmIrAeKJ8PFe
	 yBClqJU8HwC4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>,
	sre@kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] power: supply: cros_pchg: unregister EC notifier
Date: Mon, 19 Oct 2026 09:53:07 -0400
Message-ID: <20261019135441.1420968-496-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 631adfa03595c63b2a621cdc62db60bb1ce5f91c ]

cros_pchg_probe() registers an EC event notifier whose callback uses the
devm-allocated charger_data via container_of().  The driver has no
remove callback and does not unregister the notifier, so the notifier
chain can retain a pointer to freed driver state after unbind or probe
cleanup.

Register a devm cleanup action immediately after the notifier is
installed so the notifier is unregistered before the driver state is
released.  Also fail probe if the notifier cannot be registered, instead
of leaving a charger device that cannot receive EC events.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260615063105.39152-1-pengpeng@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[power: supply: cros_pchg]` `[unregister]` `[stop leaving an EC
event notifier pointing at freed charger state]`

**Step 1.2: Tags**
Record:
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>` (Chrome OS platform
  maintainer)
- `Link:
  https://patch.msgid.link/20260615063105.39152-1-pengpeng@iscas.ac.cn`
- `Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>`
  (power-supply maintainer; applied the patch)
- No `Fixes:`, no `Cc: stable`, no `Reported-by`, no `Tested-by`, no
  syzbot/CVE tags (absence is expected)

**Step 1.3: Body**
Record:
- **Bug:** `cros_pchg_probe()` registers `charger->notifier` on the
  parent Chrome OS EC `event_notifier` chain. The callback uses
  `container_of()` to recover `struct charger_data`, which is
  `devm_kzalloc()`’d. The platform driver has no `.remove` and never
  unregisters the notifier.
- **Symptom:** After unbind/module unload (and, as claimed, probe
  unwind), the parent EC chain still holds a pointer into freed driver
  state. The next EC MKBP event can call into that freed object.
- **Root cause:** Notifier lifetime is tied to the parent
  `cros_ec_device`, not to the child pchg platform device.
- **Fix:** `devm_add_action_or_reset()` immediately after successful
  register; also fail probe if register fails instead of leaving a
  charger that cannot receive events.
- **Versions:** none stated in the message.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. This is an explicit use-after-free / dangling-
notifier fix. The “fail probe on register failure” part is a real
correctness fix, not a feature.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/power/supply/cros_peripheral_charger.c` (`+11 / -2`)
- Functions: new `cros_pchg_unregister_notifier()`; `cros_pchg_probe()`
  changed
- Scope: single-file surgical fix

**Step 2.2: Code flow**
Record, from the pre-fix file (`631adfa03595c^`):
- **Before:** After registering ports, probe does
  `blocking_notifier_chain_register(&ec_dev->ec_dev->event_notifier,
  nb)`. On failure it only logs and still `return 0`. There is no
  `.remove`. `charger` is released by devm on unbind.
- **After:** Register failure returns `dev_err_probe(...)`. On success,
  `devm_add_action_or_reset(dev, cros_pchg_unregister_notifier,
  charger)` unregisters from `charger->ec_device->event_notifier` before
  other devm resources (including `charger`) are freed.
  `devm_add_action_or_reset()` also runs the unregister callback if
  adding the action itself fails.

**Step 2.3: Bug mechanism**
Record: **Use-after-free / dangling notifier (memory safety + ref-
lifetime).** Secondary logic fix: probe no longer succeeds without a
working notifier. Not a leak-only cleanup.

Verified mechanism:
- `cros_ec_notify()` does `container_of(nb, struct charger_data,
  notifier)` then `cros_pchg_event(charger)`.
- Parent EC IRQ path `cros_ec_handle_event()` /
  `cros_ec_report_events_during_suspend()` call
  `blocking_notifier_call_chain(&ec_dev->event_notifier, ..., ec_dev)`
  in `drivers/platform/chrome/cros_ec.c`.
- The pchg device is an MFD child (`cros-ec-pchg` in
  `drivers/mfd/cros_ec_dev.c`), added when `EC_CMD_PCHG_COUNT` reports
  ports. The chain lives on the parent `cros_ec_device`, which outlives
  a child unbind / `rmmod` of `CHARGER_CROS_PCHG`.

**Step 2.4: Fix quality**
Record: Obviously correct and the same pattern already used by
`cros_usbpd-charger.c`. Minimal. Regression risk is low: `devm` LIFO
order unregisters before `charger` is freed; unregister is only
scheduled after a successful register. Failing probe when notifier
registration fails is stricter but matches sibling Chrome EC drivers
(`rtc-cros-ec`, `cros_ec_keyb`, `extcon-usbc-cros-ec`).
`blocking_notifier_chain_register()` rarely fails.

## Phase 3: Git history

**Step 3.1: Blame**
Record: Notifier registration and the missing remove hook come from
`56d629af09b9d` (“power: supply: PCHG: Peripheral device charger”,
2021-07-16). That commit is an ancestor of `v5.15` (`git merge-base
--is-ancestor` exit 0 for v5.15, 1 for v5.14). The bug is old, not last-
month code.

**Step 3.2: Fixes: tag**
Record: None. Introducer is `56d629af09b9d`, present in this tree.

**Step 3.3: File history**
Record (recent, this file): `631adfa03595c` (this fix), `d6486a13665e9`
(ID table), `97dd69b1ade16` (resume sync). No prerequisite refactor.
Standalone, not `patch X/Y`.

**Step 3.4: Author**
Record: Pengpeng Hou has one other power-supply commit here
(`cw2015_battery` MODULE_DEVICE_TABLE). Not the subsystem maintainer.
Weight comes from reviewer Tzung-Bi Shih (Chrome platform) and applier
Sebastian Reichel (power-supply).

**Step 3.5: Dependencies**
Record: Uses `devm_add_action_or_reset()` and `dev_err_probe()`, both
long-standing. No new helpers. Can apply standalone. No revert of this
commit found.

## Phase 4: Mailing list

**Step 4.1: Original discussion**
Record: `b4 dig -c 631adfa03595c` matched
https://patch.msgid.link/20260615063105.39152-1-pengpeng@iscas.ac.cn
(v1 only; subject used `cros_peripheral_charger`, maintainer retitled to
`cros_pchg`). Thread saved via `b4 dig -m`.

**Step 4.2: Recipients / review**
Record (`b4 dig -w`): To/Cc included Sebastian Reichel, linux-pm, linux-
kernel, Benson Leung, Tzung-Bi Shih, Guenter Roeck, chrome-platform.
Tzung-Bi’s only comment was a subject-line nit; `Reviewed-by` “with or
without this”. Sebastian applied it (“Applied, thanks!”). No NAKs, no
stable nomination in-thread.

**Step 4.3: Bug report**
Record: No user crash/syzbot report. A later duplicate submission
(Hongyan Xu / Patchew) says the same hole was found by static analysis.
That still describes a real UAF, not a style nit.

**Step 4.4: Series**
Record: Single standalone patch (`[1/1]`).

**Step 4.5: Stable list**
Record: lore.kernel.org/stable search returned HTTP 403. UNVERIFIED
whether anyone already asked for this on stable@. No evidence it was
rejected.

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
Record: `cros_pchg_unregister_notifier` (new), `cros_pchg_probe`
(modified). Callback still `cros_ec_notify` → `cros_pchg_event`.

**Step 5.2: Callers**
Record: `cros_pchg_probe` is the platform `.probe` for `cros-ec-pchg`.
Instantiated from `ec_device_probe()` in `cros_ec_dev.c` when the EC
reports PCHG ports. `cros_ec_notify` is invoked from the parent EC
IRQ/event path (`cros_ec_irq_thread` → `cros_ec_handle_event` →
`blocking_notifier_call_chain`). That is a live interrupt/event path,
not init-only.

**Step 5.3: Callees**
Record: `blocking_notifier_chain_register/unregister`,
`devm_add_action_or_reset`, `dev_err_probe`. No new allocations or locks
beyond the notifier API.

**Step 5.4: Reachability**
Record: Userspace can trigger unbind (`/sys/bus/platform/drivers/cros-
ec-pchg/unbind`) or `rmmod` when `CONFIG_CHARGER_CROS_PCHG=m`. After
that, any EC MKBP event on the still-live parent walks the dangling
notifier. Unprivileged users cannot usually unbind, but module unload,
sysfs unbind, and parent teardown are real. After UAF,
`cros_pchg_event()` walks `charger->ports[]` and may call
`power_supply_changed()` — crash or memory corruption.

**Step 5.5: Similar patterns**
Record: Sibling `cros_usbpd-charger.c` already uses
`devm_add_action_or_reset(..., cros_usbpd_charger_unregister_notifier,
...)`. Other Chrome EC clients (`rtc-cros-ec`, `cros_ec_keyb`, `extcon-
usbc-cros-ec`) unregister in `.remove`. This driver was the outlier.

## Phase 6: This checkout

**Step 6.1: Buggy code in this tree?**
Record: Local tree is **v7.3-rc4** (`git describe HEAD` =
`v7.3-rc4-27-gf0100363d8c37`, `VERSION=7 PATCHLEVEL=3 SUBLEVEL=0
EXTRAVERSION=-rc4`). File exists. Driver introduced in v5.15; notifier
bug present from that introduction. Pre-fix probe (shown via `git show
631adfa03595c^`) matches the candidate diff. `git merge-base --is-
ancestor 631adfa03595c HEAD` succeeds (the fix is already on this
mainline branch, as expected for a candidate sourced from it).

**Step 6.2: Backport difficulty**
Record: Clean apply on this file. Surrounding probe logic is the
original 2021 structure plus later resume/ID-table work; this hunk does
not depend on those.

**Step 6.3: Related fixes already here**
Record: This is the fix. No earlier alternate fix on the file. No
revert.

## Phase 7: Subsystem context

**Step 7.1:**
Record: `drivers/power/supply/` Chrome OS EC peripheral charger.
**IMPORTANT** (not core mm/vfs, but default-on for
`CONFIG_MFD_CROS_EC_DEV` Chromebooks with stylus/WLC ports).

**Step 7.2:**
Record: File is mature; few commits since 2021. Not a newly landed
subsystem.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Chrome OS EC machines with peripheral charge ports
(`EC_CMD_PCHG_COUNT` > 0). `CONFIG_CHARGER_CROS_PCHG` defaults to
`MFD_CROS_EC_DEV`. Driver-specific, not universal.

**Step 8.2: Trigger**
Record: Successful probe, then unbind/rmmod/MFD child removal while the
parent EC device (and its IRQ) remain. Not every boot. Timing-dependent
once the dangling notifier is left on the chain: the next PCHG (or any)
EC event walks the chain. `cros_ec_notify` returns `NOTIFY_DONE` for
non-PCHG events but **after** `container_of()` — so *any* EC event after
unbind is already a UAF.

**Step 8.3: Failure mode**
Record: Use-after-free in notifier callback → kernel oops or memory
corruption. **Severity: HIGH.**

**Step 8.4: Risk/benefit**
Record: **Benefit: high** for Chromebooks that unbind or unload this
driver (and for teardown races). **Risk: very low** (13 lines,
established `devm` pattern, Chrome maintainer review). Ratio favors
backport.

## Phase 9: Synthesis

**Step 9.1: Evidence**

For:
- Real dangling-notifier UAF: parent EC chain keeps `notifier_block`
  inside `devm`-freed `charger_data`
- Any post-unbind EC event is UAF (even events this driver ignores)
- Small, obviously correct, matches `cros_usbpd-charger.c`
- Reviewed by Chrome platform maintainer; applied by power-supply
  maintainer
- Driver present since v5.15; no extra dependencies
- Fail-probe-on-register-failure avoids a half-working charger

Against:
- No `Reported-by` / syzbot / production crash (static analysis)
- Affects only Chrome OS PCHG hardware
- Unbind is not the common path on always-on Chromebooks
- Slightly stricter probe (register failure now fails the device)

Unresolved:
- Stable@ discussion (lore 403)
- How often users actually unbind this device in the field

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — pattern is standard;
   maintainer Reviewed-by + applied
2. Real bug affecting users? **PASS** — UAF after unbind/unload while
   parent EC is live
3. Important (crash/security/corruption)? **PASS** — UAF →
   oops/corruption, HIGH
4. Small and contained? **PASS** — 13 lines, one file
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — file and APIs exist; hunk is self-
   contained

**Step 9.3: Exception category**
Record: None needed; this is a normal UAF bugfix.

**Step 9.4: Decision**
This is a classic stable-worthy UAF: the child’s notifier is left on a
parent-owned chain. The local 7.3 tree has this driver; the fix is small
and matches existing Chrome EC practice. Trigger is unbind/teardown
rather than every boot, but the failure mode is a kernel UAF, which
stable takes.

What it solves for stable users: Chromebooks with peripheral chargers no
longer keep a freed `charger_data` on the EC event chain after driver
unbind, module unload, or MFD child removal, so a later EC interrupt
cannot oops or corrupt memory in `cros_ec_notify()`.

Risk vs benefit: very low risk, high benefit on the machines that hit
teardown. No prerequisites beyond the driver itself.

---

Verification:
- [Phase 1] Parsed tags: Reviewed-by Tzung-Bi Shih; Link to msgid; no
  Fixes/stable/syzbot
- [Phase 1] Body describes dangling notifier after unbind; verified
  against pre-fix source
- [Phase 2] Diff: +11/-2 in `cros_pchg_probe` plus
  `cros_pchg_unregister_notifier`; fail probe on register error
- [Phase 2] Pre-fix file from `git show 631adfa03595c^`: register then
  `return 0`; no `.remove`
- [Phase 2] Post-fix file: `devm_add_action_or_reset` after successful
  register
- [Phase 3] `git blame`: notifier register from `56d629af09b9d` (2021);
  `git merge-base --is-ancestor` → in v5.15, not v5.14
- [Phase 3] `git log --oneline -20 --
  drivers/power/supply/cros_peripheral_charger.c`: standalone, not a
  series
- [Phase 3] No revert of this commit
- [Phase 4] `b4 dig -c 631adfa03595c`: lore thread found; v1 only
- [Phase 4] `b4 dig -w`: Chrome/power-supply maintainers CC’d
- [Phase 4] `b4 dig -m`: Tzung-Bi Reviewed-by (subject nit only);
  Sebastian applied; no NAK
- [Phase 4] Duplicate later patch (Hongyan Xu) notes static-analysis
  origin
- [Phase 4] lore.kernel.org WebFetch 403 — stable@ history UNVERIFIED
- [Phase 5] `cros_ec_handle_event` / resume path call
  `blocking_notifier_call_chain` on the same `event_notifier`
- [Phase 5] MFD cell `cros-ec-pchg` in `drivers/mfd/cros_ec_dev.c` when
  `pchg_count.port_count != 0`
- [Phase 5] Sibling `cros_usbpd-charger.c` already uses the same `devm`
  unregister pattern
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] Driver and APIs present; fix is self-contained on this tree
- [Phase 8] UAF on any EC event after unbind: `container_of` happens
  before the PCHG event-type check
- UNVERIFIED: field frequency of unbind; whether stable@ already
  discussed it

The fix is small, surgical, and meets the stable criteria for a real
UAF.

**YES**

 drivers/power/supply/cros_peripheral_charger.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/cros_peripheral_charger.c b/drivers/power/supply/cros_peripheral_charger.c
index 962a6fd298323..48e10e872d1bd 100644
--- a/drivers/power/supply/cros_peripheral_charger.c
+++ b/drivers/power/supply/cros_peripheral_charger.c
@@ -259,6 +259,14 @@ static int cros_ec_notify(struct notifier_block *nb,
 	return cros_pchg_event(charger);
 }
 
+static void cros_pchg_unregister_notifier(void *data)
+{
+	struct charger_data *charger = data;
+
+	blocking_notifier_chain_unregister(&charger->ec_device->event_notifier,
+					   &charger->notifier);
+}
+
 static int cros_pchg_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -346,9 +354,10 @@ static int cros_pchg_probe(struct platform_device *pdev)
 	ret = blocking_notifier_chain_register(&ec_dev->ec_dev->event_notifier,
 					       nb);
 	if (ret < 0)
-		dev_err(dev, "Failed to register notifier (err:%d)\n", ret);
+		return dev_err_probe(dev, ret, "Failed to register notifier\n");
 
-	return 0;
+	return devm_add_action_or_reset(dev, cros_pchg_unregister_notifier,
+					charger);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.53.0

