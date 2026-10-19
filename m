Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D259E47085A;
	Mon, 19 Oct 2026 13:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418151; cv=none; b=iLzhoqZsjoctEP7eLLy25Tx0gW91Tb+1dgAxKKQItKdDjjaBxQnJ/DvFYSHgpPGTo+k1a0YEBSjyJkqp1V+7WK5ehlgJ0KMu1uLAtt5czWUyvhubGB46J6X2hYMdBnZ/HQbgp7bd4t6xj3mP2kUYQE5aIIDySdcThxZKlQ1UXic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418151; c=relaxed/simple;
	bh=4LrwTIoNSvDtLKjEpkLrO88y71xXFjc20Wh8/L0H7no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DF7yBOUSF+BjITfLjJr/JjMspVFDXeZCJim468IfabtxYPXIo3XBT94eWq3z69OGNQQRjuniF7aFWWh+wNfn0Q9spzOL8yw3gtwhv9qSs/n/k8drwE+i3i1iaD/DSWzrRe3C7BWB/3JWvSDgkQ98P/UN3LjovJ7t5iM3+McZZ1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5+4TQ+6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5+4TQ+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A92D1F000C4;
	Mon, 19 Oct 2026 13:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418149;
	bh=eHnefyVOo/AiBg1cwJ3voQDManzSQqGf5DOxZLbPmmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5+4TQ+6q/GgW4uacWRZ9vsxn0MluTWKcwgPGCzydLu73h01tM2WLXKEQCguXSBYl
	 UFabz1BsYwbcvONJxmSUNd9mnPfJVMYSevPtl5W0GYvLq9JqDzDlp90W94m0XFWUDy
	 z4FNrQS9FfRrPGxkAihplrlWwVBd9rEym76RRcGowe/TJezDU1lYIJ3pZ28SU840eU
	 NqI8UFFfQTslVUlXWZZa2/S6PAo8F/bQVV/jNq1sZQqVK081XF9F0miq8eh8vs56/J
	 0MMxl38nHd3ZKRBvCnfbvvw4Kv670sC+EyN53ygQQ7M4/fYwUI9oS/Mrdw0GWbW0Eh
	 vuLVZWchwbZ9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Md Rabbani <rabbanyhmm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	maxime.chevallier@bootlin.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] net: stmmac: fix device node reference leaks in stmmac_mtl_setup()
Date: Mon, 19 Oct 2026 09:45:38 -0400
Message-ID: <20261019135441.1420968-47-sashal@kernel.org>
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

From: Md Rabbani <rabbanyhmm@gmail.com>

[ Upstream commit 317fe168f4c0fc30e5c375c22d9c8911940aea9b ]

In stmmac_mtl_setup(), q_node is shared across the RX and TX queue
parsing loops. When the RX queue loop breaks early because the number
of parsed queues reaches plat->rx_queues_to_use, q_node retains an
acquired reference count. If the error check passes
(queue == plat->rx_queues_to_use), execution proceeds directly to the
TX queue loop, where of_get_next_child() immediately overwrites q_node
with the first TX child, permanently leaking the retained RX child
device node reference.

Switch both loops to for_each_child_of_node_scoped() so child node
references are automatically dropped upon loop exit or early break,
and remove the now-unnecessary function-scoped q_node variable and
its manual of_node_put() at the exit label.

Signed-off-by: Md Rabbani <rabbanyhmm@gmail.com>
Link: https://patch.msgid.link/20260821055718.57-1-rabbanyhmm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The leak is real in this 6.12 tree: `stmmac_mtl_setup()` can drop an OF
child reference when RX queue parsing breaks early, and in-tree DTs
actually hit that path.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: `[net: stmmac:] [fix] [OF device-node reference leaks in
  stmmac_mtl_setup()]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Record:
  - `Signed-off-by: Md Rabbani <rabbanyhmm@gmail.com>` (author)
  - `Link:
    https://patch.msgid.link/20260821055718.57-1-rabbanyhmm@gmail.com`
  - `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (netdev
    maintainer; applied to `netdev/net`)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
    by:`, or `Cc: stable` (absence of Fixes/Cc-stable is expected for
    this review)
  - Upstream SHA (from patchwork bot):
    `317fe168f4c0fc30e5c375c22d9c8911940aea9b`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record: [Bug] Shared `q_node` is used by both RX and TX
  `for_each_child_of_node()` loops. An early `break` in the RX loop
  leaves `q_node` holding a live OF reference. If `queue ==
  plat->rx_queues_to_use`, the function continues into the TX loop,
  which calls `of_get_next_child(tx_node, NULL)` and overwrites `q_node`
  without putting the RX child.
- [Symptom] Permanent `device_node` refcount leak (kobject/`device_node`
  never released).
- [Version info] None in the message. The loops date to 2017
  (`d976a525c37127`, v4.12-rc1).
- [Root cause] Early-break + reused iterator; `of_get_next_child(parent,
  NULL)` does not drop the previous pointer.

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: Not hidden. Subject/body explicitly describe a refcount leak.
  The `_scoped` conversion is the fix mechanism, not a style-only
  cleanup.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- Record: Single file
  `drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c`. Actual commit
  is **+2 / -4**. Functions: `stmmac_mtl_setup()` only. Surgical,
  single-file.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Record:
  - RX loop: `for_each_child_of_node(rx_node, q_node)` →
    `for_each_child_of_node_scoped(...)`. Early `break` now auto-drops
    the current child via `__free(device_node)`.
  - TX loop: same conversion.
  - Function-scope `struct device_node *q_node` removed;
    `of_node_put(q_node)` at `out:` removed (would not compile with the
    loop-scoped iterator).
  - Probe/DT parse path only; no datapath change.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record: [Category] Reference counting / resource leak.
- [Mechanism] `for_each_child_of_node` is `of_get_next_child()`, which
  gets `next` and puts `prev`. `break` skips the put of the current
  node. Reusing the same pointer in the TX loop with `prev=NULL` leaks
  that RX child. TX extra children were previously dropped by the
  trailing `of_node_put(q_node)`; RX extra children were not.

**Step 2.4: ASSESS THE FIX QUALITY**
- Record: Obviously correct. `for_each_child_of_node_scoped` exists in
  this tree and is already used widely. `__free(device_node)` is `if
  (_T) of_node_put(_T)`, so NULL at loop end is safe. Regression risk is
  very low: no locking, no ABI, no behavior change besides dropping the
  leaked ref. The `_scoped` form is stronger than a one-off
  `of_node_put()` before the TX loop because it also covers TX early-
  break without a manual put.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record: Buggy loops introduced by `d976a525c37127` ("net: stmmac:
  multiple queues dt configuration", Joao Pinto, 2017-03-10), first in
  **v4.12-rc1**. Present for many years. `goto out` / extra
  `of_node_put(q_node)` added by `2ee2132ffb83e` (2018), which still
  leaves the RX-then-TX overwrite leak.

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: No `Fixes:` tag. Introducer is `d976a525c37127`, and `git
  merge-base --is-ancestor d976a525c37127 HEAD` succeeds. That code is
  in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
- Record: Recent `stmmac_platform.c` work is unrelated (bus_id, probe
  error path, IRQ). Historical OF leak fixes in this driver:
  `a249708bc2aa1`, `d2ed0a7755fe1`, `4613b279bee79`. Standalone
  `[PATCH]`, not `X/Y`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: `git log --author="Md Rabbani"` on this path is empty in this
  tree (new contributor). Applied by Jakub Kicinski to `netdev/net.git`
  (fixes tree), which is a strong maintainer signal.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record: Depends on `for_each_child_of_node_scoped` /
  `DEFINE_FREE(device_node)` (`34af4554fb0ce1` / `9448e55d032d99`,
  2024-02-25). Both are already in this 6.12 tree (`git merge-base --is-
  ancestor` succeeded). Can apply standalone. `stmmac_platform.c`
  already includes `<linux/of.h>`, which includes `<linux/cleanup.h>`.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record: `b4 dig -c <sha>` cannot match because `317fe168f4c0` is not
  an ancestor of HEAD. Used msgid instead. Lore thread: `https://lore.ke
  rnel.org/netdev/20260821055718.57-1-rabbanyhmm@gmail.com/`
- Series: single v1 `[PATCH]` (2 messages: submission + patchwork-bot).
  Applied to `netdev/net.git (main)` as
  `https://git.kernel.org/netdev/net/c/317fe168f4c0`. No v2, no NAK.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record: To/Cc included STMMAC maintainers (Torgue, Coquelin,
  Chevallier), netdev maintainers (Miller, Dumazet, Kicinski, Abeni),
  `netdev@`, `linux-stm32@`, `linux-arm-kernel@`. No written review
  comments; Kicinski applied it to the **net fixes** tree.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: No syzbot/bugzilla. Bug is from code inspection. Real in-tree
  DTs trigger it (see Phase 6/8).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: Standalone. No other patches required.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: lore.kernel.org/stable search for `stmmac_mtl_setup` shows
  older stmmac stable backports (probe error-path, MDIO, Tx COE), not
  this leak. No prior rejection of this fix.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
- Record: `stmmac_mtl_setup()` (modified). Helpers:
  `for_each_child_of_node_scoped`, `of_get_next_child` /
  `__of_get_next_child`, `of_node_put`.

**Step 5.2: TRACE CALLERS**
- Record: Only caller is `stmmac_probe_config_dt()` in the same file
  (line 603). That is used via `devm_stmmac_probe_config_dt()` from many
  glue drivers: `dwmac-rk`, `dwmac-qcom-ethqos`, `dwmac-imx`, `dwmac-
  stm32`, `dwmac-sun8i`, `dwmac-mediatek`, `dwmac-generic`, and others.
  Probe/init context, not IRQ/hot path.

**Step 5.3: TRACE CALLEES**
- Record: `of_parse_phandle`, `of_property_read_*`, `of_get_next_child`,
  `of_node_put`. DT parse only.

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: Userspace cannot trigger it directly. It runs on every DT-
  based stmmac probe. Reachable on common ARM/ARM64 SoCs (Rockchip,
  i.MX, STM32, Qualcomm, MediaTek). Leak fires when the RX config node
  has more children than `snps,rx-queues-to-use`.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: Same file still has `for_each_child_of_node(np, mdio_node)` in
  `stmmac_of_get_mdio()` (line 324); not the same shared-iterator bug.
  In-tree DTs with extra RX children:
  `arch/arm64/boot/dts/qcom/sa8540p-ride.dts` uses `snps,rx-queues-to-
  use = <1>` with `queue0`–`queue3` on both ethernet0 and ethernet1.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record: Yes. This tree is **6.12.111** (`pending-6.12`,
  `p-6.12-3-gc504cf0baa3d8`). Current code at `stmmac_platform.c:177` /
  `:240` still uses unscoped loops and `of_node_put(q_node)` at `:293`.
  `317fe168f4c0` is **not** an ancestor of HEAD. Bug present since
  v4.12.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: Expected difficulty: **minor context conflicts**. Upstream
  context has later `stmmac_axi_blen_to_mask` / `MTL_MAX_*` clamping
  that 6.12 does not have. The three functional edits (two loop macros,
  drop `q_node` + trailing put) match 6.12 1:1. Needs a small context-
  adjusted backport, not a rewrite.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: No commit with this subject in this tree. Older stmmac
  `of_node_put` fixes do not cover this iterator reuse.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- Record: [Subsystem] `drivers/net/ethernet/stmicro/stmmac` (Synopsys
  DWMAC). [Criticality] **IMPORTANT** — common platform Ethernet on many
  SoCs, not core mm/VFS, not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
- Record: Actively maintained (many recent stmmac fixes on this branch).
  The leak itself is old (2017), not a new-feature bug.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
- Record: Driver/config-specific: `CONFIG_STMMAC_ETH` +
  `CONFIG_STMMAC_PLATFORM` + DT `snps,mtl-rx-config` with extra child
  nodes. Confirmed affected in-tree board: Qualcomm SA8540P Ride
  (`sa8540p-ride.dts`). Many other boards have matching child counts and
  do not leak.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
- Record: Device probe (and every unbind/rebind). Common on boards whose
  DT lists more queue children than `snps,rx-queues-to-use`. Not a
  userspace syscall; not a race. Extra TX children were already put at
  `out:`; extra RX children leak.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
- Record: [Failure] One `device_node` ref leak per probe when extra RX
  children exist. [Severity] **MEDIUM** — not oops/deadlock/corruption,
  but a real lifetime leak of an OF kobject. Repeatable on module
  reload. Can pin overlay/node teardown.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Record: Benefit: medium (fixes a real, DT-triggered leak on a widely
  used NIC driver, including an in-tree Qualcomm board). Risk: **very
  low** (2 insertions / 4 deletions, existing helper, probe-only). Ratio
  favors backport.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real OF refcount leak, mechanism verified against
  `of_get_next_child()` / `__of_get_next_child()`.
- Buggy code is in this 6.12 tree and has been since v4.12.
- In-tree DT `sa8540p-ride.dts` has 4 RX queue children with `rx-queues-
  to-use = <1>` — the leak path is not theoretical.
- Tiny, obviously correct fix; helper already in 6.12.
- Applied to `netdev/net` (fixes) by Kicinski.
- Same class of bug as prior stmmac `of_node_put` fixes already in
  history.
- No new API/feature; no series dependency.

AGAINST:
- Probe-time leak of a single node, not a crash/UAF/security issue.
- Surrounding file context differs slightly from mainline, so `git am`
  of the raw mainline diff may need a trivial refresh.
- No user crash report / syzbot.

UNRESOLVED:
- No written mailing-list review beyond maintainer application (v1
  accepted as-is).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — scoped put on break/exit is
   the intended helper; applied to netdev/net.
2. Fixes a real bug that affects users? **PASS** — leak on probe;
   triggered by in-tree Qualcomm DT.
3. Important issue? **PASS** at medium importance — resource leak, not
   panic, but a genuine lifetime bug in a common Ethernet driver.
4. Small and contained? **PASS** — +2/-4, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — same loops exist; scoped
   macro exists; minor context tweak only.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
- Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary small
  bugfix.

**Step 9.4: DECISION**
Backport to this 6.12 tree. The bug exists here, the helper exists here,
the fix is surgical, and at least one in-tree board hits it.

---

### What the commit solves and why it matters here
`stmmac_mtl_setup()` parses `snps,mtl-rx-config` / `snps,mtl-tx-config`
at probe. The RX iterator `break`s once `queue >=
plat->rx_queues_to_use`, leaving `q_node` referenced. The TX loop then
starts with `of_get_next_child(tx_node, NULL)`, which never puts that RX
child. That is a permanent OF node leak.
`arch/arm64/boot/dts/qcom/sa8540p-ride.dts` is written exactly that way
(1 queue in use, 4 queue child nodes).

### Stable rules / risk
Meets the rules: small, obviously correct, no new API, real leak, helper
already in 6.12. Risk is a possible trivial context conflict around
later mainline-only `stmmac_platform.c` edits; the functional change
does not depend on those.

### Verification
- [Phase 1] Parsed tags: author SOB, msgid Link, Kicinski SOB; no
  Fixes/Reported-by; upstream `317fe168f4c0`
- [Phase 2] Diff: +2/-4 in `stmmac_mtl_setup()`; two loops to `_scoped`;
  drop `q_node` + `of_node_put(q_node)`
- [Phase 2] `__of_get_next_child()` does `of_node_get(next);
  of_node_put(prev)` (`drivers/of/base.c:600-603`); `prev=NULL` does not
  put the overwritten pointer
- [Phase 3] Blame: loops from `d976a525c37127` (v4.12-rc1); ancestor of
  HEAD
- [Phase 3] `34af4554fb0ce1` / `DEFINE_FREE(device_node)` are ancestors
  of HEAD
- [Phase 3] `git merge-base --is-ancestor 317fe168f4c0 HEAD` failed (fix
  not in this tree)
- [Phase 4] `b4 mbox` msgid: 2-message thread; applied to netdev/net; no
  NAK
- [Phase 4] stable lore search: no discussion of this leak
- [Phase 5] Caller: `stmmac_probe_config_dt()` → many `dwmac-*` platform
  probes
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.12.111
  `pending-6.12`; buggy loops still present at lines 177 and 240
- [Phase 6] `sa8540p-ride.dts` `ethernet0_mtl_rx_setup` /
  `ethernet1_mtl_rx_setup`: `rx-queues-to-use = <1>` with queue0–queue3
- [Phase 8] Failure mode: OF `device_node` leak at probe, severity
  MEDIUM
- UNVERIFIED: Could not use `b4 dig -c` against HEAD (commit not in this
  checkout); lore HTML fetch returned 403, raw/mbox succeeded

**YES**

 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 0cb51935c4056..ceb913a3a6c69 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -131,7 +131,6 @@ static struct stmmac_axi *stmmac_axi_setup(struct platform_device *pdev)
 static int stmmac_mtl_setup(struct platform_device *pdev,
 			    struct plat_stmmacenet_data *plat)
 {
-	struct device_node *q_node;
 	struct device_node *rx_node;
 	struct device_node *tx_node;
 	u8 queue = 0;
@@ -174,7 +173,7 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 		plat->rx_sched_algorithm = MTL_RX_ALGORITHM_SP;
 
 	/* Processing individual RX queue config */
-	for_each_child_of_node(rx_node, q_node) {
+	for_each_child_of_node_scoped(rx_node, q_node) {
 		if (queue >= plat->rx_queues_to_use)
 			break;
 
@@ -237,7 +236,7 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 	queue = 0;
 
 	/* Processing individual TX queue config */
-	for_each_child_of_node(tx_node, q_node) {
+	for_each_child_of_node_scoped(tx_node, q_node) {
 		if (queue >= plat->tx_queues_to_use)
 			break;
 
@@ -290,7 +289,6 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 out:
 	of_node_put(rx_node);
 	of_node_put(tx_node);
-	of_node_put(q_node);
 
 	return ret;
 }
-- 
2.53.0

