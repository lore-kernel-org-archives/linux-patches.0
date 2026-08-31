Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7A159574E;
	Mon, 31 Aug 2026 13:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184281; cv=none; b=EVhesl7P1gici0jKHA6lZdMiMO1X7ehRIFLRsTNQtypE9D6Q4+fbzwebrFFDSh0ByW6o3VtJnlxX73xDjd7dGG/EnAsDRcDgs5lc0wuJom49fd1c0tqCRbTFwGB4GHSS/SkwLKpE+TUK1pXrvBZ4J7nKlwlf99+2Bcu8Cb+uDnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184281; c=relaxed/simple;
	bh=2VnykGLAaTq3NmHbTo8yf39NEBAlwFnYk88Ex+S6818=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GkL8QnW3ffJmRmfN7HdHeVl8BuHWRQD8R2QBGhNI+xpzrnGd0SM/vHcFXHnjzQHDxhcb9+y0pm9Vp2WyD1VloBe/xPjC3cpk8HKqWSHCFZ5hN9tK4xs+40XpoQfQcgprRLewRwLaaO5g7D8MmsnhYb6VFaf+93sxLW8eEPcUxo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JyAFe/r7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JyAFe/r7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D21F1F00ACA;
	Mon, 31 Aug 2026 13:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184278;
	bh=J4oO259tuoV01/frj/ivMvVejS6VZATMw8s9mtMpVYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyAFe/r7DnFcyF8Z4okDofG1JBWaAx/J3dN0qHNII1vcOXuFG4WUDQbmLALg0p0RQ
	 b5tVK92dDx3F/3zybKm8fuG7l+CvusgML4UiTkGMCkOt8tj65oOwpWXpeyUPA4W3u9
	 aIeU4XckQEGJpdRchKtYuDF8AeEu1len4wbnpRtUmj/s1yuOufhkC1TtkEQlQpn2oh
	 NshaltISebtotLZfkDk6ck8F/2Xaj2LG9bUYZzk3gaC/WFRyj0qP0DYiDq/mPg3+l3
	 jtpO33aw34peKO6AlVOQjgrR6iKyVJCX/NapTOccbnQ4ZYkzX6LUQ8jwe2qCXDk3o9
	 0BWFpSD5ldRjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Herve Codina <herve.codina@bootlin.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	dakr@kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] driver core: Avoid warning when removing a device while its supplier is unbinding
Date: Mon, 31 Aug 2026 09:30:25 -0400
Message-ID: <20260831133314.4125787-597-sashal@kernel.org>
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

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 36d74f17e03f7e60e1b08fbe16cfad6e69cc3aa9 ]

During driver removal, the following warning can appear:
   WARNING: CPU: 1 PID: 139 at drivers/base/core.c:1497 __device_links_no_driver+0xcc/0xfc
   ...
   Call trace:
     __device_links_no_driver+0xcc/0xfc (P)
     device_links_driver_cleanup+0xa8/0xf0
     device_release_driver_internal+0x208/0x23c
     device_links_unbind_consumers+0xe0/0x108
     device_release_driver_internal+0xec/0x23c
     device_links_unbind_consumers+0xe0/0x108
     device_release_driver_internal+0xec/0x23c
     device_links_unbind_consumers+0xe0/0x108
     device_release_driver_internal+0xec/0x23c
     driver_detach+0xa0/0x12c
     bus_remove_driver+0x6c/0xbc
     driver_unregister+0x30/0x60
     pci_unregister_driver+0x20/0x9c
     lan966x_pci_driver_exit+0x18/0xa90 [lan966x_pci]

This warning is triggered when a consumer is removed because the links
status of its supplier is not DL_DEV_DRIVER_BOUND and the link flag
DL_FLAG_SYNC_STATE_ONLY is not set.

The topology in terms of consumers/suppliers used was the following
(consumer ---> supplier):

      i2c -----------> OIC ----> PCI device
       |                ^
       |                |
       +---> pinctrl ---+

When the PCI device is removed, the OIC (interrupt controller) has to be
removed. In order to remove the OIC, pinctrl and i2c need to be removed
and to remove pinctrl, i2c need to be removed. The removal order is:
  1) i2c
  2) pinctrl
  3) OIC
  4) PCI device

In details, the removal sequence is the following (with 0000:01:00.0 the
PCI device):
  driver_detach: call device_release_driver_internal(0000:01:00.0)...
    device_links_busy(0000:01:00.0):
      links->status = DL_DEV_UNBINDING
    device_links_unbind_consumers(0000:01:00.0):
      0000:01:00.0--oic link->status = DL_STATE_SUPPLIER_UNBIND
      call device_release_driver_internal(oic)...
        device_links_busy(oic):
          links->status = DL_DEV_UNBINDING
        device_links_unbind_consumers(oic):
          oic--pinctrl link->status = DL_STATE_SUPPLIER_UNBIND
          call device_release_driver_internal(pinctrl)...
            device_links_busy(pinctrl):
              links->status = DL_DEV_UNBINDING
            device_links_unbind_consumers(pinctrl):
              pinctrl--i2c link->status = DL_STATE_SUPPLIER_UNBIND
              call device_release_driver_internal(i2c)...
                device_links_busy(i2c): links->status = DL_DEV_UNBINDING
                __device_links_no_driver(i2c)...
                  pinctrl--i2c link->status is DL_STATE_SUPPLIER_UNBIND
                  oic--i2c link->status is DL_STATE_ACTIVE
                  oic--i2c link->supplier->links.status is DL_DEV_UNBINDING

The warning is triggered by the i2c removal because the OIC (supplier)
links status is not DL_DEV_DRIVER_BOUND. Its links status is indeed set
to DL_DEV_UNBINDING.

It is perfectly legit to have the links status set to DL_DEV_UNBINDING
in that case. Indeed we had started to unbind the OIC which triggered
the consumer unbinding and didn't finish yet when the i2c is unbound.

Avoid the warning when the supplier links status is set to
DL_DEV_UNBINDING and thus support this removal sequence without any
warnings.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Link: https://patch.msgid.link/20260511155755.34428-4-herve.codina@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis

**Local tree:** Linux 6.18.44 (`v6.18.44`, `make kernelversion` =
6.18.44)
**Commit under review:** `36d74f17e03f7` — *driver core: Avoid warning
when removing a device while its supplier is unbinding*
**Status in this tree:** Buggy code present; fix **not** yet applied
(`git apply --check` passes cleanly)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[driver core] [avoid] [false WARN_ON during cascading
device-link teardown when supplier is DL_DEV_UNBINDING]`

### Step 1.2: Parse all commit message tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none on this commit
- **Reviewed-by:** Rafael J. Wysocki `<rafael@kernel.org>`, Saravana
  Kannan `<saravanak@google.com>` (both driver-core/PM maintainers)
- **Acked-by:** — none
- **Link:** https://patch.msgid.link/20260511155755.34428-4-
  herve.codina@bootlin.com
- **Cc: stable:** — absent (not a negative signal)
- **Signed-off-by:** Herve Codina (author), Greg Kroah-Hartman
  (committer); ignore pipeline-added SOBs

**Notable:** Reviewed by both primary driver-core maintainers; no
syzbot/fuzzer report.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** `WARN_ON` fires in `__device_links_no_driver()` when a
  consumer (i2c) is torn down while its supplier (OIC) is mid-unbind
  (`DL_DEV_UNBINDING`), during PCI driver removal.
- **Symptom:** Kernel warning at `drivers/base/core.c:1497`, stack
  through `device_links_driver_cleanup` →
  `device_release_driver_internal` → `device_links_unbind_consumers` →
  `pci_unregister_driver` → `lan966x_pci_driver_exit`.
- **Topology:** `i2c → OIC → PCI`, `i2c → pinctrl → OIC`.
- **Root cause:** `WARN_ON` only exempts `DL_FLAG_SYNC_STATE_ONLY` links
  when supplier status ≠ `DL_DEV_DRIVER_BOUND`; `DL_DEV_UNBINDING` is
  also legitimate during cascading unbind.
- **Version info:** None explicit; trigger hardware (`lan966x_pci`) is
  in this tree since Oct 2024.

### Step 1.4: Detect hidden bug fixes
**Record:** Yes — disguised as “avoid warning,” but it corrects overly
strict validation in core driver-link teardown. Runtime behavior is
unchanged (`DL_STATE_DORMANT` still set); only a false-positive
`WARN_ON` is suppressed. With `panic_on_warn` or `CONFIG_BUG_ON_WARN`,
the spurious WARN can escalate to panic on module unload.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `drivers/base/core.c` (+2 / −1)
- **Function:** `__device_links_no_driver()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk (lines ~1500–1505):**
  - **Before:** If supplier not `DL_DEV_DRIVER_BOUND`,
    `WARN_ON(!DL_FLAG_SYNC_STATE_ONLY)` then set link
    `DL_STATE_DORMANT`.
  - **After:** Same, but skip WARN when supplier status is
    `DL_DEV_UNBINDING`.
- **Path:** Driver removal cascade — `device_links_busy()` sets
  `DL_DEV_UNBINDING`, consumers unbound recursively,
  `device_links_driver_cleanup()` → `__device_links_no_driver()`.

### Step 2.3: Bug mechanism
**Record:** **Logic / correctness fix** — false-positive `WARN_ON`
during legitimate teardown. Category: incorrect validation in driver-
core device-link state machine (not UAF, leak, or race).

### Step 2.4: Fix quality
**Record:**
- Obviously correct: `DL_DEV_UNBINDING` is set in `device_links_busy()`
  at line 1622 before consumer unbind begins.
- Minimal change; no API/struct changes.
- **Regression risk:** Very low — only suppresses WARN for an already-
  handled state; link still goes to `DL_STATE_DORMANT`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:**
- `WARN_ON` line: `b29929b819f35` (Jun 2025, Rafael) — refactor to
  `device_link_test()`; no semantic change.
- Original `WARN_ON(!(link->flags & DL_FLAG_SYNC_STATE_ONLY))`:
  `8c3e315d42964` (May 2020, Saravana Kannan).
- Surrounding logic: `8c3e315d429642` (May 2020).
- `DL_DEV_UNBINDING`: `9ed9895370aed` (2016).
- **Both buggy WARN and `DL_DEV_UNBINDING` are in 6.18.44.**

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: File history / related changes
**Record:**
- Related in-tree precedent: `74b84d1be0220` — *driver core: fw_devlink:
  Don't warn about sync_state() pending* (reduced false driver-core
  warnings).
- `b29929b819f35` — `device_link_test()` refactor; in tree.
- Fix commit `36d74f17e03f7` — on `master`, not in `HEAD`.
- Part of v7 lan966x series (patch 3/3), but this hunk is self-contained
  in `core.c`.

### Step 3.4: Author context
**Record:** Herve Codina — lan966x_pci author (`185686beb4649`, Oct
2024); limited prior driver-core work (`0462c56c290a9`,
`3b62449da4445`).

### Step 3.5: Dependencies
**Record:** **Standalone.** No prerequisite commits; only adds
`DL_DEV_UNBINDING` exemption to existing WARN. Applies cleanly to
current `HEAD`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c 36d74f17e03f7`: https://patch.msgid.link/20260511155755.344
  28-4-herve.codina@bootlin.com
- Series: v1–v7; committed version is v7 patch 3/3.
- Thread saved to `/tmp/driver-core-warn.mbox`.

### Step 4.2: Reviewers
**Record:** CC'd: Greg Kroah-Hartman, Rafael J. Wysocki, Saravana
Kannan, driver-core@lists.linux.dev, linux-kernel; appropriate
maintainers included.

### Step 4.3: Bug report
**Record:** Reproduced by author during `lan966x_pci`
`pci_unregister_driver()`; stack trace in commit message. No external
bugzilla/syzbot link.

### Step 4.4: Series context
**Record:** v7 cover is “lan966x pci device: Add support for SFPs, core
part”; patches 1–2 are lan966x/i2c-specific. **Patch 3/3 is independent
driver-core fix** — no dependency on other series patches for
correctness.

### Step 4.5: Stable list
**Record:** No `Cc: stable` or stable-list discussion found in mbox
(`grep -i stable` returned empty).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `__device_links_no_driver()` (modified); callers
`device_links_no_driver()`, `device_links_driver_cleanup()`.

### Step 5.2: Callers
**Record:**
- `device_links_driver_cleanup()` ← `__device_release_driver()` in
  `drivers/base/dd.c:1359`
- Called during `device_release_driver_internal()` →
  `device_links_unbind_consumers()` cascade
- Reachable from `pci_unregister_driver()` / module unload — confirmed
  in commit stack trace

### Step 5.3: Callees
**Record:** `device_link_test()`, `WRITE_ONCE()` for link status; sets
`dev->links.status = DL_DEV_NO_DRIVER`.

### Step 5.4: Reachability
**Record:** Triggered on driver removal for devices with managed
supplier links in multi-level topologies. **Userspace-reachable** via
module unload / driver unbind. `lan966x_pci` in
`drivers/misc/lan966x_pci.c` is the documented trigger in this tree.

### Step 5.5: Similar patterns
**Record:** Same WARN pattern exists in
`device_links_missing_supplier()` (also from `8c3e315`); this fix
targets only `__device_links_no_driver()`. No other `DL_DEV_UNBINDING`
WARN exemptions in `core.c`.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **Yes.** Current `drivers/base/core.c:1503`:
```c
WARN_ON(!device_link_test(link, DL_FLAG_SYNC_STATE_ONLY));
```
Bug present since `8c3e315d42964` (2020); trigger topology possible
since `lan966x_pci` (`185686beb4649`, Oct 2024).

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git show 36d74f17e03f7 --
drivers/base/core.c | git apply --check` succeeded.

### Step 6.3: Related fixes already present?
**Record:** Fix `36d74f17e03f7` **not** in tree. Related warn-reduction
`74b84d1be0220` is present. No duplicate fix for this specific case.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **driver core** (`drivers/base/`) — **CORE** subsystem;
affects all device link teardown.

### Step 7.2: Activity
**Record:** Active — recent commits include `3e8fefd2997c8`,
`74b84d1be0220`, `b29929b819f35` on `core.c`.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of hardware with multi-level managed device links
during driver removal. **In this tree:** `lan966x_pci` users
unloading/reloading the module. Broader applicability for similar
topologies.

### Step 8.2: Trigger conditions
**Record:** PCI (or other) driver unregister with supplier→consumer
chain where supplier is `DL_DEV_UNBINDING` while consumer still has
active supplier links. **Uncommon but real** — reproduced on lan966x.
Unprivileged users can trigger via module unload if module is loadable.

### Step 8.3: Failure mode severity
**Record:** Spurious `WARN_ON` in dmesg on every affected teardown.
Default: **MEDIUM** (noise, possible monitoring alerts). With
`panic_on_warn=y`: **HIGH** (panic on module unload). No corruption,
UAF, or deadlock.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Eliminates false warnings on real hardware in this tree;
  corrects driver-core validation; very small diff.
- **Risk:** Very low — one additional legitimate state exempted from
  WARN.
- **Ratio:** Favorable for 6.18.44, which ships `lan966x_pci`.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real false-positive WARN on driver removal for hardware present in
  6.18.44 (`lan966x_pci`)
- Core subsystem fix, 2-line change, applies cleanly
- Reviewed by Rafael Wysocki and Saravana Kannan
- Buggy code has been in tree since 2020; trigger hardware since Oct
  2024
- Self-contained; no series dependencies
- Precedent: `74b84d1be0220` in same tree reduced driver-core false
  warnings

**AGAINST backport:**
- No functional/runtime behavior change beyond suppressing WARN
- Default severity is log noise, not crash/corruption
- Narrow topology; not syzbot-reported
- No explicit stable nomination in lore thread

**Unresolved:** Whether production deployments use `panic_on_warn` for
lan966x systems (unverified).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; maintainer-
   reviewed; author tested on lan966x unload path.
2. Fixes a real bug affecting users? **PASS** — false WARN on
   `lan966x_pci` module unload in this tree.
3. Important issue? **PASS (borderline)** — MEDIUM by default; HIGH if
   `panic_on_warn`; affects real hardware teardown in 6.18.44.
4. Small and contained? **PASS** — 2 lines, one function.
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs).

### Step 9.4: Decision rationale
For **Linux 6.18.44 specifically**, this should be backported. The tree
contains both the longstanding overly strict WARN logic and the
`lan966x_pci` driver that reproduces it on every module unload. The fix
is minimal, maintainer-approved, self-contained, and applies cleanly.
While severity is moderate under default configs, it is a genuine
driver-core correctness fix for a real teardown path on shipped
hardware.

---

## Verification

- [Phase 1] Parsed commit message and tags from `git show 36d74f17e03f7`
- [Phase 2] Diff: 2-line WARN condition change in
  `__device_links_no_driver()`
- [Phase 3] `git blame -L 1500,1505`: WARN from `b29929b`/`8c3e315`;
  `git log -S`: original WARN in `8c3e315d42964`
- [Phase 3] `git merge-base --is-ancestor`: `8c3e315`, `b29929b`,
  `185686beb4649` in tree; fix `36d74f17e03f7` NOT in tree
- [Phase 3] `git show 8c3e315d42964`: confirmed WARN introduction in
  2020
- [Phase 4] `b4 dig -c 36d74f17e03f7`: lore URL found; v7 patch 3/3
- [Phase 4] `b4 dig -c 36d74f17e03f7 -a`: series v1–v7 listed
- [Phase 4] `b4 dig -c 36d74f17e03f7 -w`: maintainers CC'd
- [Phase 4] `/tmp/driver-core-warn.mbox`: no stable nomination found
- [Phase 4] WebFetch lore URL: blocked by Anubis (unverified via web;
  mbox via b4 succeeded)
- [Phase 5] Call chain verified: `dd.c:1359` →
  `device_links_driver_cleanup` → `__device_links_no_driver`
- [Phase 5] `device_links_busy()` sets `DL_DEV_UNBINDING` at
  `core.c:1622`
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.18.44
- [Phase 6] `git apply --check`: patch applies cleanly
- [Phase 6] `grep lan966x_pci`: `drivers/misc/lan966x_pci.c` present
- [Phase 6] `git show 185686beb4649`: lan966x_pci added Oct 2024
- [Phase 7] `git log -20 -- drivers/base/core.c`: active subsystem
- [Phase 8] Failure mode assessed as MEDIUM (WARN), HIGH with
  panic_on_warn (unverified in field)
- [UNVERIFIED] Exact panic_on_warn usage on lan966x deployments

**YES**Those background lookups finished and matched what the analysis
already used:

- **core.c history:** Recent driver-core commits are on this tree; the
  fix (`36d74f17e03f7`) is not.
- **Related fixes:** Older device-link commits turned up, but nothing
  that already covers this WARN case.
- **lan966x_pci:** Introduced in `185686beb4649` (Oct 2024) and present
  in 6.18.44 — the hardware that triggers the spurious warning on module
  unload.

Verdict from the full review: **YES** for backport to this 6.18.44 tree.

 drivers/base/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2b0179096c73d..5ba783e5055ae 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1500,7 +1500,8 @@ static void __device_links_no_driver(struct device *dev)
 		if (link->supplier->links.status == DL_DEV_DRIVER_BOUND) {
 			WRITE_ONCE(link->status, DL_STATE_AVAILABLE);
 		} else {
-			WARN_ON(!device_link_test(link, DL_FLAG_SYNC_STATE_ONLY));
+			WARN_ON(link->supplier->links.status != DL_DEV_UNBINDING &&
+				!device_link_test(link, DL_FLAG_SYNC_STATE_ONLY));
 			WRITE_ONCE(link->status, DL_STATE_DORMANT);
 		}
 	}
-- 
2.53.0

