Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB1749364E;
	Mon, 31 Aug 2026 13:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183517; cv=none; b=slrazVZ2xcZ+4uzB7f2OcIyV3drxFvvWWshPX8eL7TJ+rKVyBWCNOstmWvLn/p9trTChUASHfNL0NFjb/q1UwdJX54kJJQ7uWh+nV3STW2h3EvrWQCZ9iTnxiadZk6bYWxK84Ha68o3asApvXkQjRNlTaF+iE5ki1/BUVI1iGbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183517; c=relaxed/simple;
	bh=X0S9VJPYgomhuh6NDT9ui5Te4gjngORA+t8bRFTWkhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dR3nyLZsAcOt8Zy1FiRHbGnh91a9eJmB+p+cMGa6QtL5NDYcYco8N2BaTpV9uAKZ4iUEyAdbiUl44HPtfNiPeg5nKs8uZsgz4q0oK0gi2OsT6k9Lt6mkPRc1WJMRdCrJ2mUJGBbNBIDdURWZ4U2BjCM8bsPrUtxAcMOYujND2Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QEUm8Hw2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QEUm8Hw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDA11F00A3E;
	Mon, 31 Aug 2026 13:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183514;
	bh=5W1QbP1606Aoj/2vjYKdbhDUtcNQ3Przr2ELO5Ow46Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QEUm8Hw2RgZ0LWOaCB4W2M2oz1pjNOQi+ClBTejq/wu9dNhhEF+pvCs45aApTTGyN
	 gjSr0Jwh57yZO+WrrHrBQDwMPX3eIdvdpOAlFHcXItKje5URvqW77UQc4+n/nmeNLC
	 RTM/NwV6+0QjlHHmyPOaY+L4vJuKf/SZy2VnFXNvT2GJXFN3tpGlsPRZeRJXOuBRUt
	 A5Di5JyVk2RWnH0yMLlC8DaFYvNKy/2XIE7j8XIrgYt1kKHpRjsk4s6+YHY4rGW5d2
	 lCLCSFyy/7c3PL+gZMdgMk36PwL3LK2M9LhfdknJwHcJz8/MNvT629gep8Bsg6V3bG
	 uTT6+C/5xII3Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	David Carlier <devnexen@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	horatiu.vultur@microchip.com,
	UNGLinuxDriver@microchip.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] net: lan966x: restore RX state on reload failure
Date: Mon, 31 Aug 2026 09:22:50 -0400
Message-ID: <20260831133314.4125787-142-sashal@kernel.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit aa97f11a76e545ed73cc455bcdd1ece4b480b507 ]

lan966x_fdma_reload() backs up rx->page_pool and rx->fdma before
reallocating the RX resources for the new MTU. If the allocation fails,
the restore path puts these fields back before restarting RX.

However, the reload path also updates rx->page_order and rx->max_mtu
before calling lan966x_fdma_rx_alloc(). These fields are not restored on
failure, so RX can be restarted with the old pages, old FDMA state and
old page pool, but with the page geometry from the failed new MTU.

This can make the XDP path advertise a frame size derived from the new
page_order while the actual RX pages still come from the old allocation.
For example, after a failed reload to a jumbo MTU, xdp_init_buff() may be
called with a frame size larger than the restored RX pages.

lan966x_fdma_rx_alloc_page_pool() also registers the newly allocated page
pool with each port's XDP RXQ before fdma_alloc_coherent() is called. If
fdma_alloc_coherent() fails, the new page pool is destroyed, but the
rollback path does not restore the per-port XDP RXQ mem model
registration either.

Save and restore rx->page_order and rx->max_mtu, and restore the old page
pool registration for each port's XDP RXQ before RX is started again.
This keeps the restored RX state consistent after a failed reload.

Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260607145747.1494514-1-lgs201920130244@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[net: lan966x] [restore] RX state on reload failure` —
Microchip LAN966x Ethernet driver; restores incomplete RX state on
failed buffer reload.

**Step 1.2 — Tags**

Record:
- **Signed-off-by:** Guangshuo Li `<lgs201920130244@gmail.com>` (author)
- **Reviewed-by:** David Carlier `<devnexen@gmail.com>` (reviewed
  related lan966x stable fixes in this tree)
- **Link:** https://patch.msgid.link/20260607145747.1494514-1-
  lgs201920130244@gmail.com
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (netdev
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org
  (absence expected per review pipeline)

**Step 1.3 — Body analysis**

Record:
- **Bug:** `lan966x_fdma_reload()` updates `rx->page_order` and
  `rx->max_mtu` before allocation, but the failure restore path only
  restores `page_pool` and `fdma`.
- **Symptom:** RX restarts with old pages/pool/FDMA but new page
  geometry metadata.
- **XDP impact:** `xdp_init_buff()` may use a frame size (`PAGE_SIZE <<
  page_order`) larger than the restored RX pages → out-of-bounds access.
- **Second bug:** `lan966x_fdma_rx_alloc_page_pool()` registers a new
  page pool with each port's XDP RXQ before `fdma_alloc_coherent()`. On
  coherent alloc failure, the new pool is destroyed but XDP RXQ still
  references it.
- **Root cause:** Incomplete rollback of all fields modified during
  reload.
- **Version info:** None in message.

**Step 1.4 — Hidden bug fix?**

Record: Yes. Despite "restore" wording, this fixes real memory-safety
bugs: XDP buffer size mismatch (OOB) and stale XDP page-pool
registration (UAF).

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c` (+20
  lines, 0 removed)
- **Function:** `lan966x_fdma_reload()`
- **Scope:** Single-file, surgical error-path fix

**Step 2.2 — Code flow per hunk**

Record:
- **Hunk 1 (backup):** Before reload, save `page_order` and `max_mtu`
  alongside existing `page_pool`/`fdma` backups.
  - Before: only `page_pool` and `fdma` saved.
  - After: all four fields saved.
- **Hunk 2 (restore):** On `lan966x_fdma_rx_alloc()` failure:
  - Before: restore `page_pool` + `fdma`, restart RX.
  - After: also restore `page_order` + `max_mtu`, re-register old page
    pool with each port's XDP RXQ via `xdp_rxq_info_unreg_mem_model()` /
    `xdp_rxq_info_reg_mem_model()`, then restart RX.

**Step 2.3 — Bug mechanism**

Record:
- **Category:** Memory safety / state consistency on error path.
- **Mechanism 1:** Metadata mismatch — `page_order`/`max_mtu` reflect
  failed (larger) MTU while hardware uses old (smaller) pages. XDP path
  reads `page_order` directly in `lan966x_xdp_run()`.
- **Mechanism 2:** Reference counting / UAF — XDP RXQ mem model points
  to destroyed page pool after partial alloc failure.

**Step 2.4 — Fix quality**

Record:
- Fix is minimal and mirrors existing backup/restore pattern.
- Low regression risk: only runs on allocation failure, restores
  previously valid state.
- No API or behavioral changes on success path.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record:
- `lan966x_fdma_reload()` core logic from Horatiu Vultur (2022-04-08,
  commit `2ea1cbac267e2a`).
- `page_order`/`max_mtu` updates in reload from 2022 (`2ea1cbac`,
  `11871aba`).
- Recent UAF fix `92a6730199437` (David Carlier, Apr 2026) reworked
  restore path but did not restore `page_order`/`max_mtu`.
- Bug in reload restore has existed since 2022; XDP mem-model issue
  since `77ddda44411c3` (Nov 2022).

**Step 3.2 — Fixes: tag**

Record: No Fixes: tag. N/A.

**Step 3.3 — Related file history**

Record:
- `92a6730199437` — fix UAF/leak in `lan966x_fdma_reload()` — **already
  in 6.18.44**
- `22e1ee9f22b5c` — page pool leak in error paths — **in tree**
- `b5dcb41ba891b` — page_pool IS_ERR check — **in tree**
- `89ba464fcf548` — refactor buffer reload — **in tree**
- This commit is a follow-up completing the restore path after the UAF
  fix.

**Step 3.4 — Author context**

Record: Guangshuo Li is a contributor; David Carlier (reviewer) authored
the three Apr 2026 lan966x stable fixes already in this tree.

**Step 3.5 — Dependencies**

Record: Standalone. Requires `xdp_rxq_info_reg_mem_model()` (from
`77ddda44411c3`, in tree) and post-UAF reload structure (from
`92a6730199437`, in tree). No series dependencies.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- **URL:** https://patch.msgid.link/20260607145747.1494514-1-
  lgs201920130244@gmail.com
- **Series:** v2 only (b4 dig -a)
- **Review:** David Carlier ACK'd code, provided Reviewed-by. No NAKs.
- **Stable nomination:** None in thread.

**Step 4.2 — Reviewers**

Record: CC'd netdev/bpf maintainers (Kicinski, Abeni, Miller, Dumazet,
Starovoitov, Borkmann, Brouer). David Carlier reviewed.

**Step 4.3 — Bug report**

Record: No external bug report or syzbot link. Bug identified via code
analysis of incomplete restore.

**Step 4.4 — Related patches**

Record: Follow-up to David Carlier's Apr 2026 lan966x reload fixes
already backported to 6.18.y.

**Step 4.5 — Stable list**

Record: Not searched separately; no stable discussion found in patch
thread.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `lan966x_fdma_reload()`, `lan966x_fdma_rx_alloc()`,
`lan966x_fdma_rx_alloc_page_pool()`, `lan966x_xdp_run()`.

**Step 5.2 — Callers**

Record:
- `lan966x_fdma_reload()` ← `__lan966x_fdma_reload()` ←
  `lan966x_fdma_change_mtu()` / `lan966x_fdma_reload_page_pool()`
- `lan966x_fdma_change_mtu()` ← `lan966x_port_change_mtu()`
  (`.ndo_change_mtu`)
- `lan966x_fdma_reload_page_pool()` ← `lan966x_xdp_setup()` (XDP program
  attach/detach)
- `lan966x_xdp_run()` ← RX NAPI poll path when XDP program present

**Step 5.3 — Callees**

Record: `lan966x_fdma_rx_alloc()` → `lan966x_fdma_rx_alloc_page_pool()`
→ `page_pool_create()`, `xdp_rxq_info_reg_mem_model()`; then
`fdma_alloc_coherent()`. On failure, `page_pool_destroy()`.

**Step 5.4 — Reachability**

Record:
- Triggered by MTU change (`ip link set mtu`) or XDP program
  load/unload.
- Requires `CAP_NET_ADMIN`.
- Failure path needs allocation failure (typically ENOMEM under memory
  pressure during jumbo MTU or XDP reload).
- XDP OOB requires XDP program loaded (`CONFIG_LAN966X` + BPF/XDP).

**Step 5.5 — Similar patterns**

Record: Same incomplete-restore pattern partially fixed by
`92a6730199437` (pages/fdma/pool). This commit completes it for metadata
and XDP registration.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is **v6.18.44**. Current
`lan966x_fdma_reload()` restore path (lines 856–865) lacks
`page_order`/`max_mtu` restore and XDP mem-model re-registration. Commit
`aa97f11a76e54` is on `master` but **not** an ancestor of HEAD.

**Step 6.2 — Backport complications**

Record: `git apply --check` passes cleanly against current tree. No
conflicts expected.

**Step 6.3 — Related fixes already present?**

Record: UAF fix `92a6730199437` is present; this complementary fix is
not. No duplicate fix found.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: `drivers/net/ethernet/microchip/lan966x/` — network driver
(IMPORTANT, driver-specific).

**Step 7.2 — Activity**

Record: Active; three lan966x stable fixes landed in Apr 2026, plus
additional fixes in this tree.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: LAN966x switch users with FDMA enabled; XDP users for the
primary severity path; embedded/industrial networking deployments.

**Step 8.2 — Trigger conditions**

Record:
- Admin-initiated MTU increase (especially jumbo) or XDP program change.
- Allocation must fail mid-reload.
- Unprivileged users cannot trigger directly; requires `CAP_NET_ADMIN`.

**Step 8.3 — Failure mode severity**

Record:
- **XDP page_order mismatch:** `xdp_init_buff()` with oversized frame vs
  actual page → **HIGH** (OOB / memory corruption).
- **Stale XDP page pool:** use-after-free when XDP processes packets →
  **HIGH**.
- Non-XDP skb path uses restored `fdma->db_size`, so less directly
  affected.

**Step 8.4 — Risk-benefit**

Record:
- **Benefit:** Prevents memory corruption and UAF on a real error-
  recovery path; completes fix started by already-backported
  `92a6730199437`.
- **Risk:** Very low — 20 lines, error-path only, mirrors existing
  restore logic.
- **Ratio:** Strong benefit, minimal risk.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR:**
- Fixes real bugs (OOB in XDP, UAF from stale page pool registration).
- Small, surgical, applies cleanly.
- Reviewed by David Carlier (author of related stable fixes in this
  tree).
- Prerequisites present; buggy code confirmed in v6.18.44.
- Complements already-backported `92a6730199437`.

**AGAINST:**
- Driver-specific (LAN966x only).
- Requires allocation failure + admin action to trigger.
- No syzbot/user crash report.
- XDP path needed for worst-case OOB scenario.

**Unresolved:** No runtime crash report; severity inferred from code
analysis (credible given direct `page_order` use in
`lan966x_xdp_run()`).

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — straightforward
   save/restore; Reviewed-by from subsystem contributor.
2. Fixes real bug? **PASS** — incomplete error-path rollback.
3. Important issue? **PASS** — memory corruption / UAF (HIGH severity
   for XDP users).
4. Small and contained? **PASS** — 20 lines, one file.
5. No new features/APIs? **PASS** — error-path state restoration only.
6. Can apply to local tree? **PASS** — clean apply, all prerequisites
   present.

**Step 9.3 — Exception categories**

Record: None (not device ID, quirk, DT, build, or docs). Standard bug
fix.

**Step 9.4 — Decision rationale**

This commit completes the error-recovery path in `lan966x_fdma_reload()`
for the 6.18.44 tree. After the already-backported UAF fix deferred page
freeing on failure, the remaining gap — unreverted
`page_order`/`max_mtu` and stale XDP page-pool registration — leaves RX
running in an inconsistent state that can cause XDP buffer overflows and
use-after-free. The fix is minimal, well-reviewed, and directly
applicable.

---

## Verification

- [Phase 1] Parsed commit `aa97f11a76e54` message and tags via `git
  show`
- [Phase 2] Diff analysis: +20 lines in `lan966x_fdma_reload()` restore
  path
- [Phase 3] `git blame -L 814,866`: reload from 2022, UAF fix
  `92a6730199437` in Apr 2026
- [Phase 3] `git log --oneline -20 -- lan966x_fdma.c`: related stable
  fixes present
- [Phase 3] `git merge-base --is-ancestor`: `89ba464fcf548`,
  `92a6730199437`, `77ddda44411c3` all in tree; `aa97f11a76e54` not in
  tree
- [Phase 4] `b4 dig -c aa97f11a76e54`: lore URL found
- [Phase 4] `b4 dig -a`: v2 only
- [Phase 4] `b4 dig -w`: netdev/bpf maintainers CC'd
- [Phase 4] `/tmp/lan966x_restore.mbx`: David Carlier Reviewed-by, ACK
  on code
- [Phase 5] `grep lan966x_xdp_run`: called from RX poll path line 422
- [Phase 5] Read `lan966x_xdp.c:82`: `xdp_init_buff()` uses
  `lan966x->rx.page_order`
- [Phase 5] Read `lan966x_fdma.c:75-110`: page pool registered before
  `fdma_alloc_coherent()`
- [Phase 5] Read `lan966x_main.c:402-423`: MTU change calls reload
- [Phase 5] Read `lan966x_xdp.c:30`: XDP setup calls reload
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] Read current restore path lines 856-865: missing fix
- [Phase 6] `git apply --check`: patch applies cleanly
- [Phase 8] Failure mode: OOB/UAF on failed reload with XDP — severity
  HIGH

**YES**

 .../ethernet/microchip/lan966x/lan966x_fdma.c | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 646f3d65274e3..b13c60438b978 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -816,6 +816,7 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 	struct page *(*old_pages)[FDMA_RX_DCB_MAX_DBS];
 	struct page_pool *page_pool;
 	struct fdma fdma_rx_old;
+	int page_order, max_mtu;
 	int err, i, j;
 
 	old_pages = kmemdup(lan966x->rx.page, sizeof(lan966x->rx.page),
@@ -826,6 +827,8 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 	/* Store these for later to free them */
 	memcpy(&fdma_rx_old, &lan966x->rx.fdma, sizeof(struct fdma));
 	page_pool = lan966x->rx.page_pool;
+	page_order = lan966x->rx.page_order;
+	max_mtu = lan966x->rx.max_mtu;
 
 	napi_synchronize(&lan966x->napi);
 	napi_disable(&lan966x->napi);
@@ -855,7 +858,24 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 	return 0;
 restore:
 	lan966x->rx.page_pool = page_pool;
+	lan966x->rx.page_order = page_order;
+	lan966x->rx.max_mtu = max_mtu;
 	memcpy(&lan966x->rx.fdma, &fdma_rx_old, sizeof(struct fdma));
+	/*
+	 * lan966x_fdma_rx_alloc_page_pool() registered the new pool with
+	 * each port's XDP RXQ before the allocation failed. The new pool is
+	 * destroyed by lan966x_fdma_rx_alloc(), so restore the old pool's
+	 * registration before restarting RX.
+	 */
+	for (i = 0; i < lan966x->num_phys_ports; i++) {
+		if (!lan966x->ports[i])
+			continue;
+
+		xdp_rxq_info_unreg_mem_model(&lan966x->ports[i]->xdp_rxq);
+		xdp_rxq_info_reg_mem_model(&lan966x->ports[i]->xdp_rxq,
+					   MEM_TYPE_PAGE_POOL, page_pool);
+	}
+
 	lan966x_fdma_rx_start(&lan966x->rx);
 
 	lan966x_fdma_wakeup_netdev(lan966x);
-- 
2.53.0

