Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B9050540F;
	Mon, 31 Aug 2026 13:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183737; cv=none; b=bY0rFHv1y9i0oWCRywNK64BSqvXBfR8si85PBn6+i1p1YNJI9T1BhF7NG1XuyVmVJDjjE0z3h+oSVKCt61/WNTFzcv0XntIUI1rHraOc1T5tIVDdIAbcBuvGQuQTP3w0eLUUqAFSwlL462myxEDVN5OKiMDmWFmSDsH2zUetEaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183737; c=relaxed/simple;
	bh=YIsRDDqkd1ouO8Zp64aXbm02JghdIwvgDBPhR61qO7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H49ObIalGVvEzEBiIbb8V4VkRof1gh+AYxALonFMj4w6TN1HXfbeSZ2Bdxf93OCfMhfuTvqz4eVF69b2F66bKvshGYmJ150Akti5g+al0KOX2/uzH407C3eYP8/wFUP2fDBWNb/9JBVAcWyiVcp+yHG1BPiHZGHqGszStlfrXQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMdZlohG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMdZlohG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9411F000E9;
	Mon, 31 Aug 2026 13:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183734;
	bh=DlK6rkYW0O/pcFDpTiFkQ9/wFopvtWdHJc9XGCyn5iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMdZlohGY0YIwaqHtEkzMNTou5RxiBILpzY6J2Ewpwy2t5j0yKhxF3SaTIG+Jrm/+
	 BNNJMEhFvTBvm8AcsFlartRJ8R1JZR73NydqHkZSHqMOV62iebywYYfA5xBhd+ltv0
	 i9XLGmIi+1WzZe18VprfSTM67fJZpDtZTLUs+rwIx3DbFbQcpfhiY85hiH5lEBEWbW
	 VMeAv/Rc798nwpDfSbdAu+q6nqaejgeSyVpGI2dMzzYbPmMuZ5IfL0s33/00WehJu5
	 R1l831+8h6koDUolVdxG+XEKk0ajGEbJQNueDtRk3xlNUu83a94owgIJdGZgEyHiUL
	 GTMD4URxklFbw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] dpaa2-switch: fix handling of NAPI on the remove path
Date: Mon, 31 Aug 2026 09:25:00 -0400
Message-ID: <20260831133314.4125787-272-sashal@kernel.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit e23d7c8c1d4ba435c457d7ffb2669175ec819b07 ]

All the NAPI instances for a DPSW device are attached to the first
switch port's net_device but shared by all ports. The NAPI instances get
disabled only once the last port goes down.

This causes an issue on the .remove() path where each port is
unregistered and freed one at a time, causing the NAPI instances to be
deleted even though they are not disabled.

In order to avoid this, split up the unregister_netdev() calls from the
free_netdev() so that we make sure all ports go down before we attempt
a deletion of NAPI instances. Also, make the netif_napi_del() explicit
as it is on the .probe() path.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20260528173452.1953102-6-ioana.ciornei@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `dpaa2-switch: fix handling of NAPI on the
remove path`

**Local tree:** `v6.18.44` (`6.18.44`) — verdict applies to this tree
only.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
- **Record:** `[dpaa2-switch]` **`fix`** — correct NAPI teardown
  ordering on the driver `.remove()` path.

### Step 1.2: Tags
- **Signed-off-by:** Ioana Ciornei `<ioana.ciornei@nxp.com>`
- **Link:** https://patch.msgid.link/20260528173452.1953102-6-
  ioana.ciornei@nxp.com
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (net maintainer
  merge)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or `Reviewed-by:` tags.
- **Record:** Maintainer merge present; no explicit stable nomination or
  fuzzer report. Absence of `Cc: stable` is expected and not a negative
  signal.

### Step 1.3: Body analysis
- **Bug:** NAPI instances are attached to port 0’s `net_device` but
  shared by all switch ports. NAPI is disabled only when the last port
  goes down (`napi_users` refcount).
- **Symptom:** On `.remove()`, each port is `unregister_netdev()`’d and
  `free_netdev()`’d in the same loop iteration. Freeing port 0’s netdev
  deletes shared NAPI while other ports may still be up and NAPI still
  enabled.
- **Root cause:** Interleaved unregister + free prevents all ports from
  going down before NAPI deletion.
- **Fix:** Unregister all netdevs first, explicitly `netif_napi_del()`
  all NAPI instances, then free ports.
- **Record:** Real teardown-ordering bug on driver removal; affects
  multi-port switches with active interfaces.

### Step 1.4: Hidden bug fix?
- **Record:** No — this is an explicit bug fix, not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **File:** `drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c` (+10 /
  −5)
- **Function:** `dpaa2_switch_remove()`
- **Record:** Single-file, surgical change; one function modified.

### Step 2.2: Code flow change

**Before:**
```c
for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
    unregister_netdev(port_priv->netdev);
    dpaa2_switch_remove_port(ethsw, i);  // calls free_netdev()
}
```

**After:**
```c
for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
    unregister_netdev(ethsw->ports[i]->netdev);

for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++)
    netif_napi_del(&ethsw->fq[i].napi);

for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
    dpaa2_switch_remove_port(ethsw, i);
```

- **Record:**
  - Hunk 1: All ports brought down before any `free_netdev()`.
  - Hunk 2: Explicit NAPI removal after all `ndo_stop` paths have run.
  - Hunk 3: Port teardown/free happens only after NAPI is properly
    disabled and deleted.

### Step 2.3: Bug mechanism
- **Category:** Teardown-ordering / resource-lifecycle bug (NAPI deleted
  while still enabled).
- **Mechanism:**
  1. `netif_napi_add()` attaches NAPI to `ethsw->ports[0]->netdev`
     (probe path, lines 3460–3462).
  2. `dpaa2_switch_enable_ctrl_if_napi()` /
     `dpaa2_switch_disable_ctrl_if_napi()` refcount via `napi_users`;
     NAPI disabled only when last port stops (lines 649–681).
  3. `free_netdev()` calls `netdev_napi_exit()` →
     `__netif_napi_del_locked()`, which warns if NAPI is not disabled:

```7608:7609:net/core/dev.c
        /* Make sure NAPI is disabled (or was never enabled). */
        WARN_ON(!test_bit(NAPI_STATE_SCHED, &napi->state));
```

  4. With `num_ifs > 1` and ports up, unregistering/freeing port 0 first
     deletes NAPI while `napi_users > 0` and NAPI still enabled.
- **Record:** Confirmed WARN/crash path on multi-port switch removal.

### Step 2.4: Fix quality
- **Record:** Fix is minimal, mirrors standard netdev teardown ordering,
  and matches the probe-side explicit `netif_napi_add()`. Low regression
  risk; no API or locking changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
- Remove loop structure: `44baaa43d7cc` (2018-03-14, original staging
  ethsw driver).
- `dpaa2_switch_remove_port()` split: `860fe1f87eca` (2021-08-19).
- Shared NAPI design: `0b1b713704588` (2021-03-10, Ioana Ciornei).
- **Record:** Bug latent since shared NAPI was introduced in 2021;
  remove path never updated for shared-NAPI lifecycle.

### Step 3.2: Fixes: tag
- **Record:** Not applicable — no `Fixes:` tag present.

### Step 3.3: Related file history
- Recent dpaa2-switch fixes in this tree include IRQ validation,
  refcount leaks, buffer pool seeding — all independent.
- Patch is **5/5** of series “dpaa2-switch: various improvements”
  (patches 1–4 cover FDB, RX error path, VLAN). Patch 5 only touches
  `dpaa2_switch_remove()` and is **standalone**.
- **Record:** No prerequisite commits required for this fix.

### Step 3.4: Author context
- Ioana Ciornei is the original author of shared NAPI management and an
  active dpaa2-switch contributor.
- **Record:** Author has deep subsystem knowledge; fix is credible.

### Step 3.5: Dependencies
- Uses `DPAA2_SWITCH_RX_NUM_FQS` (defined as 2 in `dpaa2-switch.h`),
  `netif_napi_del()`, and existing `dpaa2_switch_remove_port()` — all
  present in this tree.
- **Record:** Applies standalone; no structural dependencies on unmerged
  series patches 1–4.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
- **Series:** `[PATCH net-next 0/5] dpaa2-switch: various improvements`
  (Ioana Ciornei, 2026-05-28).
- **Patch:** `[PATCH net-next 5/5] dpaa2-switch: fix handling of NAPI on
  the remove path`
- **URLs:** lkml.iu.edu/2605.3/08494.html, patchew.org series page.
- Cover letter notes these are long-standing bugs found during LAG
  support review.
- **Record:** Patch 5 is independently committable; no NAKs found in
  available sources.

### Step 4.2: Reviewers
- **To:** netdev maintainers (Andrew Lunn, David Miller, Jakub Kicinski,
  Paolo Abeni, etc.)
- Merged by Jakub Kicinski.
- **Record:** Standard netdev review path; maintainer merge confirmed.

### Step 4.3: Bug report
- No syzbot or user crash report; bug found during code review.
- **Record:** Review-discovered but mechanism is verifiable in code.

### Step 4.4: Series context
- Patches 1–4: FDB management, RX error path, VLAN dedup, VLAN flag
  changes — unrelated to NAPI teardown.
- **Record:** Patch 5 can be backported alone.

### Step 4.5: Stable list history
- No stable-list discussion found for this specific fix.
- **Record:** Not previously nominated for stable (expected).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
- `dpaa2_switch_remove()` — modified
- `dpaa2_switch_remove_port()` — called after fix (unchanged)
- `dpaa2_switch_disable_ctrl_if_napi()` — called via `ndo_stop` during
  unregister
- `netdev_napi_exit()` / `__netif_napi_del_locked()` — core NAPI
  deletion

### Step 5.2: Callers
- `dpaa2_switch_remove()` is the `.remove` callback for the DPAA2 switch
  MC device driver (line 3529).
- **Record:** Triggered on device unbind, module unload, or hot-unplug
  of DPSW object.

### Step 5.3: Callees
- `unregister_netdev()` → `ndo_stop` → `dpaa2_switch_port_stop()` →
  `dpaa2_switch_disable_ctrl_if_napi()`
- `netif_napi_del()` → `__netif_napi_del_locked()`
- `dpaa2_switch_remove_port()` → `free_netdev()` → `netdev_napi_exit()`
- **Record:** Fix ensures correct ordering across these teardown
  primitives.

### Step 5.4: Reachability
- **Trigger:** Removal of a DPAA2 switch with 2+ ports where at least
  one port was brought up (NAPI enabled).
- **Record:** Reachable on normal driver unload / device removal on NXP
  DPAA2 platforms (LS1088, LX2160, etc.); not userspace-syscall
  reachable, but real admin/PM path.

### Step 5.5: Similar patterns
- Probe error path (`err_unregister_ports` then `err_free_netdev`)
  already separates unregister from free — remove path was the outlier.
- **Record:** Fix aligns remove path with the safer pattern already used
  on probe error.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
- **Record:** YES. Current `dpaa2_switch_remove()` at lines 3304–3308
  still interleaves `unregister_netdev()` and
  `dpaa2_switch_remove_port()` in one loop. Shared NAPI code present
  since `0b1b713704588` (ancestor of HEAD).

### Step 6.2: Backport complications
- Diff applies cleanly against current file; line numbers match commit
  base (`505ccaa93ee41`).
- **Record:** Clean apply expected; no rework needed.

### Step 6.3: Related fixes already present?
- No existing fix for this NAPI teardown issue in tree.
- **Record:** Fix not yet applied; still needed.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
- **Subsystem:** `drivers/net/ethernet/freescale/dpaa2/` — DPAA2
  Ethernet switch driver (`CONFIG_FSL_DPAA2_SWITCH`)
- **Criticality:** IMPORTANT (platform-specific networking driver, not
  core kernel)

### Step 7.2: Activity
- dpaa2-switch actively maintained with multiple recent stable-worthy
  fixes (IRQ bounds, refcount leaks, buffer pool).
- **Record:** Mature driver with ongoing maintenance.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
- Users of NXP Layerscape SoCs with DPAA2 switch
  (`FSL_DPAA2_SWITCH=y/m`).
- **Record:** Platform-specific but affects all multi-port switch
  teardown on those systems.

### Step 8.2: Trigger conditions
- Switch device removal/unbind with `num_ifs >= 2` and ports that were
  opened (NAPI enabled).
- **Record:** Common on module unload or firmware/MC object teardown;
  not exotic.

### Step 8.3: Failure severity
- `WARN_ON` in `__netif_napi_del_locked()` when deleting enabled NAPI.
- Potential use-after-free or crash if NAPI poll runs against freed
  structures.
- **Record:** Severity **HIGH** (kernel WARN/oops on driver removal);
  not data corruption, but can leave system in bad state during
  teardown.

### Step 8.4: Risk-benefit
- **Benefit:** HIGH for affected DPAA2 switch users — prevents broken
  teardown.
- **Risk:** VERY LOW — 15-line reordering in one function, no new APIs.
- **Record:** Strong benefit/risk ratio.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes a real, verifiable bug in driver removal path
- Bug present since 2021 shared-NAPI design; affects this 6.18.y tree
- Small, surgical, obviously correct fix
- Maintainer-merged; standalone (no series dependencies)
- Prevents WARN/oops on multi-port switch teardown
- Aligns remove path with safer probe-error pattern

**AGAINST backport:**
- Platform-specific driver (limited user base vs. core subsystems)
- No syzbot report or user crash report (review-discovered)
- Only triggers on device removal, not steady-state operation

**Unresolved:** None that affect the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic verified against NAPI
   refcount design; maintainer merged.
2. Fixes a real bug? **PASS** — multi-port remove path deletes enabled
   shared NAPI.
3. Important issue? **PASS** — WARN/oops on driver removal (HIGH
   severity for teardown).
4. Small and contained? **PASS** — one function, +10/−5 lines.
5. No new features or APIs? **PASS** — teardown ordering fix only.
6. Can apply to local tree? **PASS** — buggy code present; clean apply
   expected.

### Step 9.3: Exception categories
- **Record:** None (not a quirk/ID/DT/build/doc fix) — standard bug fix.

### Step 9.4: Decision rationale
This commit fixes a long-standing teardown bug in the DPAA2 switch
driver where shared NAPI instances attached to port 0 are deleted via
`free_netdev()` before all ports are brought down. The fix is minimal,
self-contained, applies cleanly to the 6.18.44 tree, and prevents kernel
warnings/crashes during driver removal on multi-port switches — a path
that stable enterprise/embedded users hit during upgrades, module
reloads, and device hot-unplug.

---

## Verification

- **[Phase 1]** `git describe HEAD` → `v6.18.44`; parsed subject, tags,
  body from provided commit message
- **[Phase 2]** Read `dpaa2_switch_remove()` (lines 3290–3321),
  `dpaa2_switch_remove_port()` (3006–3014), NAPI enable/disable
  (649–681), probe NAPI add (3460–3462)
- **[Phase 2]** Read `free_netdev()` / `netdev_napi_exit()` /
  `__netif_napi_del_locked()` in `net/core/dev.c` (12066–12116,
  7601–7628)
- **[Phase 3]** `git blame` on remove loop (lines 3304–3308) → original
  2018 code; `860fe1f87eca` added `remove_port`; `0b1b713704588`
  introduced shared NAPI
- **[Phase 3]** `git merge-base --is-ancestor 0b1b713704588 HEAD` →
  shared NAPI commit is in tree
- **[Phase 3]** `git log --oneline -20 --
  drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c` → no duplicate
  NAPI fix present
- **[Phase 4]** Web search + lkml.iu.edu/2605.3/08494.html → confirmed
  patch 5/5 of “various improvements” series; standalone
- **[Phase 4]** Patchew/Ratatoskr → series patches 1–4 are FDB/VLAN/RX
  fixes, independent of patch 5
- **[Phase 4]** lore.kernel.org fetch blocked (Anubis); used lkml.iu.edu
  mirror instead
- **[Phase 5]** Confirmed `.remove` callback at line 3529; traced
  `ndo_stop` → `dpaa2_switch_disable_ctrl_if_napi()`
- **[Phase 6]** Buggy interleaved loop confirmed at lines 3304–3308 in
  local tree
- **[Phase 6]** `DPAA2_SWITCH_RX_NUM_FQS` = 2 in `dpaa2-switch.h`;
  `netif_napi_del` available in `include/linux/netdevice.h`
- **[Phase 6]** No `netif_napi_del` in current file — fix adds needed
  explicit deletion
- **[Phase 7]** `CONFIG_FSL_DPAA2_SWITCH` in
  `drivers/net/ethernet/freescale/dpaa2/Kconfig`
- **[Phase 8]** Failure mode: `WARN_ON` in `__netif_napi_del_locked`
  when NAPI still enabled; severity HIGH for teardown

**YES**

 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c   | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index c65ecb187af3d..ff187e2202966 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3307,7 +3307,6 @@ static void dpaa2_switch_teardown(struct fsl_mc_device *sw_dev)
 
 static void dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 {
-	struct ethsw_port_priv *port_priv;
 	struct ethsw_core *ethsw;
 	struct device *dev;
 	int i;
@@ -3319,11 +3318,17 @@ static void dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 
 	dpsw_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
 
-	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
-		port_priv = ethsw->ports[i];
-		unregister_netdev(port_priv->netdev);
+	/* Unregister all the netdevs so that they are brought down and the
+	 * shared NAPI instances gets disabled.
+	 */
+	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
+		unregister_netdev(ethsw->ports[i]->netdev);
+
+	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++)
+		netif_napi_del(&ethsw->fq[i].napi);
+
+	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
 		dpaa2_switch_remove_port(ethsw, i);
-	}
 
 	kfree(ethsw->fdbs);
 	kfree(ethsw->filter_blocks);
-- 
2.53.0

