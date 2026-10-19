Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9914452F98C;
	Mon, 19 Oct 2026 14:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418647; cv=none; b=BCjjw2untDkeGqygEwEYJxoXbDBv5fOqfS/hf4kFml0m5/MeeEk4zzNFFQQDNEfD6+5qRSAHu4XWuzXiRPtFRnoJZNGNgGlRGMjdWO1e7YRDfuB4WIEhgBeJbsiBS0W0jYr/BGR5nnbbFWh+QUhRBMXcCGyAyxGvrEUUYUO7CJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418647; c=relaxed/simple;
	bh=6ZoqQm8Fl4ljfELKoFhXuaLxczt4zZ9SBBnOt//pKMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CoaV0zAgOtQtlLax0QSXTI0UIOs2rkHVi3dWBhwLkAL8ckqZAvhY7rlyH/S4CvKV5xqQUo4zEWFcN1O1akjVcj8VbgGf22biag0Enx3fjJaaWvtSodJvIYEcRAZyBue2B66YusFrcdhv6apP0aSHz0LVFhBMWm4vFCN0bviTViU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z91CjFN9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z91CjFN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C401F000C4;
	Mon, 19 Oct 2026 14:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418645;
	bh=dha6GLY45Au1RUJLsfxVfDqWBBDF+BSXoNjnCqVGCpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z91CjFN91S3b7frQXjRjcobWvC95iF7rKDPBaIykjrzkT1w2C2ryH4w5unVvdPPUy
	 xz2JbAgCaP+zhOolwTPHvbetpZ7OXaxKh1MuTQzo2s07WrrC0cfAlliCJy43C0hsGO
	 HhSjr1ocWvQlKMBqTxNkzofQqQ204zzbx5B1R+eLgwja6g6JUAKnMD/SQTfB388sAL
	 sVnwX62NLNr37m24ZUBhSUEaX8dorFOebgjLnnwbjpQsIy0PTPB853zwbYfVdjLL8K
	 5wOeLuqf9S9CeFxLUdiONrmB54E5lFO9GIU3nldOiGCs8LIiM1XjllFJyejZzR4W9l
	 0QLgTSnHt1vlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	amitkumar.karwar@nxp.com,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] Bluetooth: btnxpuart: Fix use-after-free in probe error path
Date: Mon, 19 Oct 2026 09:51:27 -0400
Message-ID: <20261019135441.1420968-396-sashal@kernel.org>
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

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

[ Upstream commit a2b3b4f00403a3a40c5627d1bf537c8fb166e221 ]

In nxp_serdev_probe(), if hci_register_dev() succeeds but ps_setup()
fails, the error path jumps to 'probe_fail' which only calls
hci_free_dev() and asserts the reset GPIO, but does NOT call
hci_unregister_dev() first.

This leaves the HCI device registered in the system with its backing
memory freed, leading to a use-after-free when userspace subsequently
accesses the device (e.g. via hciconfig or bluetoothd).

Fix by adding a 'probe_fail_unregister' label that calls
hci_unregister_dev() before falling through to the existing
'probe_fail' label. The original 'probe_fail' label is preserved
for the case where hci_register_dev() itself fails (device was
never registered, so no unregister is needed).

Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Reviewed-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53** (`pending-6.18`). The probe-path UAF is
present here, the fix is a 3-line unregister-before-free, and it should
be backported.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[Bluetooth / btnxpuart] [Fix] [use-after-free in
`nxp_serdev_probe()` when `ps_setup()` fails after a successful
`hci_register_dev()`]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Neeraj Sanjay Kale `<neeraj.sanjaykale@nxp.com>`
  (listed `MAINTAINERS` co-maintainer of NXP Bluetooth)
- **Acked-by:** none
- **Link:** none
- **Cc: stable:** none (expected; not a negative)
- **Signed-off-by:** Zhao Dongdong `<zhaodongdong@kylinos.cn>` (author);
  Luiz Augusto von Dentz `<luiz.von.dentz@intel.com>` (Bluetooth
  maintainer)
- Pipeline SOBs (Sasha Levin / Upstream commit markers): ignored per
  instructions

Notable: maintainer review + Bluetooth maintainer SOB. No syzbot tag.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** After `hci_register_dev()` succeeds, `ps_setup()` failure
  jumps to `probe_fail`, which asserts reset and calls `hci_free_dev()`
  without `hci_unregister_dev()`.
- **Symptom:** HCI device stays registered after its driver backing is
  torn down; userspace (`hciconfig`, bluetoothd) can then UAF.
- **Version info:** none in the message.
- **Root cause (author):** missing unregister on the post-register error
  path; `probe_fail` is correct only when registration itself failed.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not a hidden fix.** Subject and body explicitly describe a
UAF. The code change matches that description.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/bluetooth/btnxpuart.c` only
- **Scope:** +3 / −1 (one function)
- **Function:** `nxp_serdev_probe()`
- **Classification:** single-file surgical error-path fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record (verified against this tree at `nxp_serdev_probe()`):

**Before** (local `drivers/bluetooth/btnxpuart.c` lines 1919–1935):
```
if (hci_register_dev(hdev) < 0)
    goto probe_fail;
if (ps_setup(hdev))
    goto probe_fail;          // registered, but treated as never-
registered
...
probe_fail:
    reset_control_assert(nxpdev->pdn);
    hci_free_dev(hdev);
    return -ENODEV;
```

**After:**
- `ps_setup()` failure → `probe_fail_unregister` →
  `hci_unregister_dev(hdev)` then fall through
- `hci_register_dev()` failure still goes to `probe_fail` only (never
  registered)

**Path affected:** probe error path only, after successful HCI
registration.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** use-after-free / lifetime bug (error-path cleanup)
- **Mechanism:** `hci_register_dev()` (`net/bluetooth/hci_core.c`) does
  `device_add()`, `hci_dev_hold()`, and `queue_work(...,
  &hdev->power_on)`. `hci_free_dev()` is only `put_device()`. Skipping
  unregister leaves `hdev` on `hci_dev_list` and in sysfs.
- **Worse than the message states (verified):** `nxpdev` is
  `devm_kzalloc()` at probe start. Probe returning `-ENODEV` releases
  managed resources, so `nxpdev` is freed while a still-registered
  `hdev` has `hci_set_drvdata(hdev, nxpdev)`. HCI callbacks
  (`btnxpuart_open`, `nxp_setup`, power-on work) then dereference freed
  driver state.
- **Fix:** same unregister-then-free order as `nxp_serdev_remove()`
  (local lines 1959–1962).

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: pairs register with unregister; preserves the
  never-registered path.
- Minimal: 3 insertions, 1 deletion, no API/struct changes.
- Regression risk: low. `hci_unregister_dev()` is the designed teardown
  (cancels `power_on` via `disable_work_sync`). Probe failure means
  `remove()` is not called, so no double-unregister.
- Does not call `ps_cleanup()` on this path: correct, because
  `ps_setup()`’s only error return is `devm_gpiod_get_optional()`
  failure **before** `INIT_WORK` / `timer_setup` / `mutex_init` (local
  lines 511–517 vs 557–561). Calling `ps_cleanup()` there would operate
  on uninitialized state.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Buggy `if (ps_setup(hdev)) goto probe_fail;` introduced by
  **`c135a5bc34a89a75a739d07964ff3d1c4fa1b154`** (“Bluetooth: btnxpuart:
  Add GPIO support to power save feature”, Neeraj Sanjay Kale, committer
  date 2024-11-14).
- That commit changed `ps_setup()` from `void` to `int` and added the
  `probe_fail` label that frees without unregister.
- `git merge-base --is-ancestor c135a5bc34a89a HEAD` → **yes**. Makefile
  at that commit is **6.12.0-rc6**; this 6.18.53 tree contains the bug.
- Driver itself: `689ca16e523278` (2023-04-23). Original probe had
  `ps_setup()` as void after register, so it could not fail after
  register until `c135a5bc34a89`.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The real introducer is `c135a5bc34a89`, not the
original driver add. A later duplicate patch (Myeonghun Pak) incorrectly
tagged `Fixes: 689ca16e5232`. Absence of Fixes here does not change the
local-tree fact: the buggy goto is in this checkout.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Recent `btnxpuart.c` work is firmware dump, OOB, IRQ, baudrate,
  coredump — none of it unregisters on the `ps_setup()` fail path.
- `git log --grep="use-after-free" -- drivers/bluetooth/btnxpuart.c` →
  empty.
- `probe_fail_unregister` is **not** in this tree.
- Standalone; not “patch X/Y”. v2 changelog was SubjectPrefix; v3 was
  gitlint. Same 3-line diff.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: `git log --author="Zhao Dongdong" -- drivers/bluetooth/` in this
tree has no btnxpuart commits (author is not the NXP driver maintainer).
Weight comes from **Reviewed-by: Neeraj** (NXP maintainer) and **SOB:
Luiz** (Bluetooth maintainer). Neeraj is the author of the introducing
commit and of most later btnxpuart work.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: No new helpers. Uses existing `hci_unregister_dev()`. Local
probe matches the hunk (same `ps_setup` / `hci_devcd_register` /
`probe_fail` sequence). **Can apply standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c <msgid>` for v1 msgid
  `tencent_05373BA21CEEB5195F2ECCED0C77D0C57108@qq.com` → no matching
  **commit** in this tree (expected: candidate not merged here).
- Lore.kernel.org fetches returned **403**.
- Discussion reconstructed from ratatoskr / spinics / lkml.iu.edu:
  - v1/v2/v3 by Zhao Dongdong, mid-May 2026, linux-bluetooth
  - v3: https://ratatoskr.run/linux-bluetooth/2026/05/9706550
  - Luiz replied 2026-05-15; Neeraj reviewed 2026-06-03
  - Revisions were cosmetic (prefix, gitlint), not logic changes
- **UNVERIFIED:** exact text of Luiz’s review comment (patchwork
  presented a bot wall; lore 403)

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: Recipients/maintainers from public threads: Luiz von Dentz,
Marcel Holtmann, Amitkumar Karwar, Neeraj Kale, linux-bluetooth.
Committed form has Neeraj `Reviewed-by` and Luiz SOB. No NAK found.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot/bugzilla link. Independent second patch (Myeonghun Pak
/ Ijae Kim, 2026-06-26, “unregister HCI device on probe failure”)
describes the same bug. Neeraj told them Zhao’s patch was already
approved and waiting on Luiz. Two independent submissions = real issue,
not one-off theory.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone. Duplicate later patch is the same 3-line change with
a different label name (`unregister_dev` vs `probe_fail_unregister`). No
series dependency.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: `WebFetch` of lore.kernel.org/stable returned 403.
**UNVERIFIED:** whether stable@ already discussed this specific commit.
No evidence it was rejected for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `nxp_serdev_probe()` only. Calls added: `hci_unregister_dev()`.

**Step 5.2: TRACE CALLERS**

Record: `.probe = nxp_serdev_probe` in the serdev driver (local ~line
2030). Invoked on UART child-device bind (`compatible =
"nxp,88w8987-bt"` / `"nxp,88w8997-bt"`), not a syscall. Userspace
reaches the **aftermath** via HCI (`bluetoothd`, `hciconfig`) once the
device is left registered.

**Step 5.3: TRACE CALLEES**

Record:
- `hci_register_dev()`: `device_add`, list insert, `hci_dev_hold`,
  `queue_work(power_on)`
- `hci_unregister_dev()`: `HCI_UNREGISTER`, `list_del`,
  `disable_work_sync(power_on)`, close, mgmt removal
- `hci_free_dev()`: `put_device`
- `ps_setup()`: optional GPIO; only hard-fail is
  `IS_ERR(devm_gpiod_get_optional(...))`

**Step 5.4: FOLLOW THE CALL CHAIN**

Record:
1. Serdev probe for NXP UART BT
2. `hci_register_dev` → `hci0` visible; `power_on` queued
3. `ps_setup` fails
4. Probe returns error without unregister → `devm` frees `nxpdev`
5. HCI core / userspace / leftover `power_on` uses `hdev` callbacks →
   UAF

Reachable on any board using this driver with `device-wakeup-gpios` that
fails to resolve (property present, GPIO unavailable / `-EPROBE_DEFER`
converted to `-ENODEV`). Binding:
`Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml`
documents that GPIO. In-tree users of the compatible include i.MX
91/93/95 EVKs, i.MX8MP, TI Verdin AM62, Kobo Clara 2E.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Other Bluetooth UART drivers typically only `hci_free_dev()`
when **register** fails. This driver’s bug is specifically “work after
register that can fail.” Remove path already had the correct
unregister/free order.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `pending-6.18`, `make kernelversion` = **6.18.53**.
Exact snippet at lines 1924–1935 of `drivers/bluetooth/btnxpuart.c`.
Introduced in `c135a5bc34a89` (~6.13 era); present here. Candidate fix
**not** an ancestor of HEAD.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** Surrounding code matches the supplied hunk
(`hci_register_dev` / `ps_setup` / `hci_devcd_register` / `probe_fail` +
`reset_control_assert`). Line numbers differ slightly from the candidate
blob; context is the same. No conflicting refactor.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No unregister-on-`ps_setup`-fail fix. Other btnxpuart stable-
style fixes in this tree (OOB firmware read, FW dump header length) are
unrelated.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record:
- **Subsystem:** Bluetooth device driver
  (`drivers/bluetooth/btnxpuart.c`)
- **Criticality:** **IMPORTANT** (not core mm/VFS). Real shipping
  hardware (NXP 88W8987/8997 on i.MX and TI K3). `CONFIG_BT_NXPUART`
  depends on `BT_HCIUART` and `SERIAL_DEV_BUS`.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively maintained (many 2025 btnxpuart commits in this tree).
Bug is in a 2024 error-path addition that has sat unfixed.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver-specific / config-specific:** `CONFIG_BT_NXPUART` users
with NXP UART Bluetooth, especially DTs that include `device-wakeup-
gpios`.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- Trigger: `ps_setup()` returns non-zero after successful
  `hci_register_dev()`.
- In this tree that is `devm_gpiod_get_optional("device-wakeup")`
  returning `IS_ERR` (GPIO specified but cannot be acquired). IRQ setup
  failures are ignored, not a probe fail.
- Not every boot. GPIO probe deferral / missing controller / bad DT are
  realistic.
- Unprivileged userspace does not need to *cause* the probe fail; once
  it happens, bluetoothd/hciconfig can trip the UAF. Concurrent
  `power_on` work can trip it without userspace.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- **Failure mode:** UAF of `btnxpuart_dev` (devm-freed) and/or HCI
  object lifetime violation while `hciX` remains registered; possible
  oops; `power_on` work not cancelled.
- **Severity: HIGH** (UAF / crash). Not a panic on every boot, but
  classically stable-worthy.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** HIGH for affected hardware — prevents UAF/oops on a real
  probe failure.
- **Risk:** VERY LOW — 3 lines, existing API, same order as `remove()`,
  error path only.
- **Ratio:** strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Confirmed UAF / lifetime bug in this 6.18.53 tree
- Small, obviously correct unregister-before-free
- Matches `nxp_serdev_remove()`
- Cancels `power_on` work that `hci_register_dev()` queued
- NXP driver maintainer Reviewed-by; Bluetooth maintainer SOB
- Independent duplicate patch
- Clean apply; no prerequisites
- Real in-tree hardware (i.MX, TI K3)

**AGAINST:**
- Driver-specific, not core kernel
- Trigger is an error path (`ps_setup` GPIO get fail), not every probe
- No syzbot/CVE/Reported-by
- No Fixes tag (not a reason to reject)

**UNRESOLVED (do not drive the verdict):**
- Exact Luiz review comment text
- Mainline SHA of the candidate (not in this tree)
- stable@ discussion (lore 403)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — pairing is the documented
   HCI lifetime; reviewed by driver + Bluetooth maintainers.
2. Fixes a real bug that affects users? **PASS** — registered HCI left
   after probe fail; UAF via callbacks/userspace.
3. Important issue? **PASS** — UAF / crash, HIGH (not
   deadlock/corruption, still stable-class).
4. Small and contained? **PASS** — 3 lines, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — buggy code present; hunk
   matches.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not ID/quirk/DT/build/docs. It is a **normal UAF bugfix**, which
is in-scope without an exception.

**Step 9.4: MAKE YOUR DECISION**

This 6.18.53 tree has the buggy `ps_setup()` → `probe_fail` path from
`c135a5bc34a89`. The fix is the missing `hci_unregister_dev()` before
`hci_free_dev()`. That is required HCI lifetime management, matches
remove(), and prevents UAF of `devm`-managed driver state while `hciX`
stays registered. Scope and risk are appropriate for stable.

---

### What the commit solves for this tree

On NXP UART Bluetooth probe, if HCI registration succeeds and then
power-save GPIO setup fails, 6.18.53 currently frees the HCI object
(and, via `devm`, the driver private data) without unregistering.
Userspace and the queued `power_on` work can then use freed memory. The
backport adds one unregister on that path only.

### Stable rules / risk vs benefit

Meets all six criteria. Benefit is preventing a UAF on a shipping
driver; risk is a 3-line error-path change that uses the existing
unregister helper.

### Concerns

None that block backport. Trigger is uncommon (GPIO get failure), but
the failure mode is severe enough. No extra commits needed.

---

### Verification

- **[Phase 1]** Parsed subject/tags/body: UAF fix; Reviewed-by Neeraj;
  SOB Luiz; no Fixes/syzbot/Cc-stable
- **[Phase 2]** Diff: +3/−1 in `nxp_serdev_probe()`; `ps_setup` fail now
  unregisters before free
- **[Phase 2]** Read local probe/remove/`ps_setup`: bug and GPIO-only
  fail return confirmed
- **[Phase 2]** Read
  `hci_register_dev`/`hci_unregister_dev`/`hci_free_dev`: register
  queues `power_on` and holds refs; free is `put_device` only
- **[Phase 3]** `git describe HEAD` / `make kernelversion`:
  `p-6.18-1-g03b85e06ca9bf`, **6.18.53**
- **[Phase 3]** `git blame -L 1915,1940`: buggy goto from
  `c135a5bc34a89`
- **[Phase 3]** `git merge-base --is-ancestor c135a5bc34a89a HEAD`: yes
- **[Phase 3]** `git show c135a5bc34a89a`: introduced int `ps_setup` +
  `goto probe_fail` without unregister
- **[Phase 3]** Original driver `689ca16e523278`: `ps_setup` could not
  fail after register
- **[Phase 3]** `git log --grep="use-after-free"` on this file: empty;
  fix not in tree
- **[Phase 4]** `b4 dig` on v1 msgid: no commit in this tree
- **[Phase 4]** lore.kernel.org: 403 — UNVERIFIED full thread body
- **[Phase 4]** ratatoskr v3 + lkml.iu.edu: v1–v3 standalone; Neeraj
  approved; duplicate June 2026 patch
- **[Phase 5]** Callers: serdev `.probe`; `nxpdev` is `devm_kzalloc`
- **[Phase 5]** DTS: `nxp,88w8987-bt` on i.MX and TI boards; binding
  documents `device-wakeup-gpios`
- **[Phase 6]** Exact buggy snippet present; `probe_fail_unregister`
  absent
- **[Phase 8]** Failure: UAF/oops on probe error after register;
  severity HIGH
- **UNVERIFIED:** Luiz comment text; candidate mainline SHA; stable@
  archive

The fix is small, surgical, already in the local probe shape, and
addresses a real UAF.

**YES**

 drivers/bluetooth/btnxpuart.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
index c7acf6c7efcf6..870ce16ad40b1 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -1924,13 +1924,15 @@ static int nxp_serdev_probe(struct serdev_device *serdev)
 	}
 
 	if (ps_setup(hdev))
-		goto probe_fail;
+		goto probe_fail_unregister;
 
 	hci_devcd_register(hdev, nxp_coredump, nxp_coredump_hdr,
 			   nxp_coredump_notify);
 
 	return 0;
 
+probe_fail_unregister:
+	hci_unregister_dev(hdev);
 probe_fail:
 	reset_control_assert(nxpdev->pdn);
 	hci_free_dev(hdev);
-- 
2.53.0

