Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AE85A5120;
	Mon, 31 Aug 2026 13:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184337; cv=none; b=rdzpOFyL17xn/0C/48dQQXqIb9N35YQ4fFvIj/qjv7P0/6KBo1SCOLHzqIDV7JGMlQLJYacus+1iFMpzwscyRDnpBdS4ikvy2jvhdlo84Ky5FF1DZuogplmisaEI6BR2Sk5j6TUpccYnkkZ+OpVk/6tuFzulYgKw9YtEKTZW9oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184337; c=relaxed/simple;
	bh=FxQ6nVZ4YoyxEkQbWtAhM8UOOYbiFoZNH1wXzlUa/XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UPN+XhTR/9hIJHGT2tok3U2hstYmwAo5GPpB2M3wYI1iyXfKIOtuEn8Fhy5MUr+kxoKcHo+l/E/9MerAB2MUgbXGyrEjD/7iqY3TAocS65gA6JvbsdTYPEOQ2/rJqWwLZ/bmxdy5DwNpvgEXcs0SF/Z6pqNnrMtZW90PLqI+dgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gpuGlnII; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gpuGlnII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CDD1F00A3D;
	Mon, 31 Aug 2026 13:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184334;
	bh=LiC5preUXJ6GSBz7xSKt4+QPU8ODGRCx8zv11LGbr7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpuGlnIIoVDmWOYw4ygF2Cgp63GViMcyh+nUvt32dSCoj2LbxY4T4h/BiRn1DSbJh
	 Lx8BVt1ebRBq1eMl23BUmV0LncDPPt3IEuIf40CbwmFMFaoknnVJwmY6/pFcsrEwoF
	 dXLaXyMpU8zfZCke9bCZ1ogPRnaUJtrNuO0CEVp8F9Xm1vMSK+RIAekiAzTgXbLKqg
	 7ye4rElbBwZoAzlwdq+CJJSL6ACzueqIJwySaix67UZwvKyAxMBpa8FoDi4TwlIhEm
	 Mx4OTc0zpjwl2WstKtjbY0jSe1pgUoZDbPPNAd0efFjeKvZmqvg3wyfI91ul2ZBtzf
	 jsbAk3IY3KTmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: ibm: emac: mal: fix potential system hang in mal_remove()
Date: Mon, 31 Aug 2026 09:31:00 -0400
Message-ID: <20260831133314.4125787-632-sashal@kernel.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 7c5d41f87f079990bf241359e3c1332d8d10fe87 ]

napi_disable() is not idempotent and calling it on an already-disabled
or unenabled NAPI context will cause the kernel to spin indefinitely
waiting for the NAPI_STATE_SCHED bit to clear.

In mal_remove(), napi_disable() is called unconditionally. If no MACs were
registered, NAPI was never enabled. Also, if they were registered but
subsequently unregistered, NAPI was already disabled in
mal_unregister_commac(). In either case, calling napi_disable() causes
the kernel to hang upon module removal.

Fix this by only calling napi_disable() in mal_remove() if the commac list
is not empty (which implies NAPI is enabled).

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20260603230821.5619-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[net: ibm: emac: mal]` `[fix]` — fix potential system hang
in `mal_remove()`.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Rosen Penev `<rosenp@gmail.com>` (author)
- **Link:**
  https://patch.msgid.link/20260603230821.5619-1-rosenp@gmail.com
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (net maintainer
  merge)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: maintainer merge SOB; no syzbot or user reports in the
  message

### Step 1.3: Body analysis
**Record:**
- **Bug:** `napi_disable()` is called unconditionally in `mal_remove()`,
  but NAPI is only enabled when the first commac registers
  (`mal_register_commac()`), and is disabled when the last commac
  unregisters (`mal_unregister_commac()`).
- **Symptom:** Kernel spins indefinitely in `napi_disable()` waiting for
  `NAPI_STATE_SCHED` to clear → system hang on MAL device removal.
- **Trigger paths:** (1) No MAC ever registered → NAPI never enabled;
  (2) MACs registered then unregistered → NAPI already disabled.
- **Root cause:** `napi_disable()` is not idempotent on an unenabled or
  already-disabled NAPI context.
- **Fix approach:** Only call `napi_disable()` in `mal_remove()` when
  `mal->list` is non-empty (abnormal leftover commacs).

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit bug fix for a hang, not disguised
cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/ethernet/ibm/emac/mal.c` (+2 net lines,
  structural brace change)
- **Function:** `mal_remove()`
- **Scope:** Single-file, surgical (3-line logical change)

### Step 2.2: Code flow change
**Record:**
- **Before:** `mal_remove()` always called `napi_disable(&mal->napi)`,
  then checked if commac list was non-empty and WARNed.
- **After:** `napi_disable()` and the WARN are both inside `if
  (!list_empty(&mal->list))`.
- **Paths affected:** Platform device removal / module unload
  (`mal_exit()` → `platform_driver_unregister()`).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness — incorrect lifecycle pairing of
  `napi_enable()` / `napi_disable()`.
- **Mechanism:**
  - `netif_napi_add_weight()` sets `NAPI_STATE_SCHED | NAPI_STATE_NPSVC`
    at init.
  - `napi_enable()` clears those bits (NAPI active).
  - `napi_disable()` waits for those bits to clear, then sets them
    again.
  - If NAPI was never enabled, SCHED/NPSVC stay set → infinite spin in
    the wait loop.
  - If NAPI was already disabled by `mal_unregister_commac()`,
    SCHED/NPSVC are set again → second `napi_disable()` spins forever.

### Step 2.4: Fix quality
**Record:**
- Fix mirrors the existing register/unregister contract: list non-empty
  ⟺ NAPI enabled.
- Minimal, obviously correct, no API changes.
- **Regression risk:** Very low. Normal teardown (empty list) skips the
  redundant disable; abnormal teardown (non-empty list) still disables
  and warns.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- Unconditional `napi_disable()` in `mal_remove()` introduced in
  `59e90b2d22500f` (2007-10-09, Roland Dreier NAPI conversion).
- Conditional `napi_enable()`/`napi_disable()` in register/unregister
  added in `b3e441c6ed865` (2007-10-16, Benjamin Herrenschmidt).
- Mismatch between the two has existed since October 2007.
- Buggy code is present in this tree at lines 706–712 of `mal.c`.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:**
- Recent mal.c work by Rosen Penev: devm conversions, `dcr_unmap` in
  remove, IRQ map moves (2024).
- Related fix `c09c2e236eef6` — UAF during emac device removal (same
  driver, different bug).
- Standalone one-patch fix, not part of a series.

### Step 3.4: Author context
**Record:** Rosen Penev is an active contributor to ibm/emac driver
maintenance (multiple 2024 commits). Jakub Kicinski merged.

### Step 3.5: Dependencies
**Record:** No prerequisites. Fix applies to existing `mal_remove()` /
commac list logic with no new symbols or structures.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:** UNVERIFIED — `b4 dig -c` requires the commit in the local
tree (fix not merged here). WebFetch of patch.msgid.link blocked by bot
protection; lore.kernel.org raw fetch returned 403.

### Step 4.2: Reviewers
**Record:** UNVERIFIED — could not retrieve thread via b4 or lore.

### Step 4.3: Bug report
**Record:** No external bug report linked. Hang mechanism verified
directly from kernel NAPI code and driver lifecycle.

### Step 4.4: Related patches
**Record:** No series dependencies identified.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — could not search stable@ lore.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `mal_remove()`, `mal_register_commac()`,
`mal_unregister_commac()`, `napi_disable()`, `napi_enable()`.

### Step 5.2: Callers
**Record:**
- `mal_remove` — platform driver `.remove` via `mal_of_driver`
  registered in `mal_init()`.
- `mal_register_commac` / `mal_unregister_commac` — called from
  `emac_probe()` / `emac_remove()` and error paths in `core.c`.
- `mal_exit()` called from `emac_exit()` after
  `platform_driver_unregister(&emac_driver)`.

### Step 5.3: Callees
**Record:** `napi_disable()`, `mal_reset()`, `free_netdev()`,
`dcr_unmap()`, `dma_free_coherent()`.

### Step 5.4: Call chain / reachability
**Record:**
```
module_exit(emac_exit)
  → platform_driver_unregister(emac_driver)  [each emac_remove →
mal_unregister_commac → napi_disable]
  → mal_exit()
    → platform_driver_unregister(mal_of_driver)  [mal_remove →
napi_disable → HANG]
```
Reachable on every `rmmod ibm_emac` (or built-in shutdown) on PowerPC
systems using this driver. Not a syscall path, but a standard driver
teardown path.

### Step 5.5: Similar patterns
**Record:** `mal_poll_disable()` uses `__napi_synchronize()` instead of
`napi_disable()` — shows prior awareness that blind `napi_disable()` is
unsafe in some contexts.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy code in tree?
**Record:** **YES.** Local tree is **v6.18.44** (`git describe HEAD`,
Makefile 6.18.44). `mal_remove()` at lines 706–712 still has
unconditional `napi_disable()`. Fix commit message not found in tree
(`git grep` returned no matches).

### Step 6.2: Backport complications
**Record:** Clean apply expected — 3-line change in one function, no
surrounding churn in that hunk.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix found. UAF fix `c09c2e236eef6` is
separate.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/ethernet/ibm/emac/` — PowerPC embedded Ethernet
(IBM EMAC on 4xx, Cell Axon). **PERIPHERAL** subsystem (platform-
specific), but teardown is on the critical shutdown path.

### Step 7.2: Subsystem activity
**Record:** Moderate recent activity (devm conversions, UAF fix, IRQ
handling). Mature driver with long-stable core logic.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users with `CONFIG_IBM_EMAC` on PowerPC (4xx embedded, some
Cell platforms). Not universal, but real production embedded hardware.

### Step 8.2: Trigger conditions
**Record:**
1. **Normal case:** Any system that had EMAC interfaces probed; on
   module unload/reboot, `emac_remove()` disables NAPI, then
   `mal_remove()` double-calls `napi_disable()` → hang. **Very common**
   on affected hardware.
2. **Edge case:** MAL probed but no EMAC registered → `napi_disable()`
   on never-enabled NAPI → hang. **Less common** but possible.

### Step 8.3: Failure mode severity
**Record:** **CRITICAL** — indefinite kernel hang (soft lockup) during
driver removal or shutdown. System becomes unresponsive; may require
hard reset.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected platforms — prevents hang on every
  driver unload/shutdown.
- **Risk:** VERY LOW — 3-line conditional, matches existing
  enable/disable contract.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real, reproducible hang on standard teardown path (double
  `napi_disable()`).
- Hang also on never-enabled NAPI path.
- Mechanism verified in `net/core/dev.c` `napi_disable_locked()` and
  driver lifecycle.
- Small, surgical, obviously correct fix.
- Bug present since 2007; latent in all stable trees carrying ibm/emac.
- Maintainer-merged fix.

**AGAINST backport:**
- Platform-specific driver (limited user base).
- No syzbot/user report in commit message.
- Mailing list discussion not retrieved.

**Unresolved:** Original lore thread content and any reviewer stable
nominations.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic matches
   register/unregister contract; compile-tested per submission norms
   (Tested-by not present).
2. Fixes a real bug affecting users? **PASS** — hang on driver removal.
3. Important issue? **PASS** — CRITICAL (system hang).
4. Small and contained? **PASS** — 3 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to local tree? **PASS** — buggy code confirmed present;
   clean apply expected.

### Step 9.3: Exception categories
**Record:** N/A — standard bug fix, not a quirk/DT/build/doc exception.

### Step 9.4: Decision rationale

This commit fixes a genuine system hang in the IBM EMAC/MAL driver that
triggers on every normal module unload when EMAC interfaces were ever
registered: `emac_exit()` unregisters EMAC devices (which calls
`napi_disable()` via `mal_unregister_commac()`), then `mal_exit()` calls
`mal_remove()` which unconditionally calls `napi_disable()` again.
Because `napi_disable()` waits for `NAPI_STATE_SCHED` to clear and then
sets it, a second call spins forever. The fix correctly gates
`napi_disable()` on a non-empty commac list, matching the enable/disable
logic in `mal_register_commac()` / `mal_unregister_commac()`. The local
v6.18.44 tree still contains the buggy code and the fix is not yet
applied.

---

## Verification

- **[Phase 1]** Parsed subject, tags, and body from provided commit
  message.
- **[Phase 2]** Read diff and current `mal.c` `mal_remove()` /
  register/unregister functions.
- **[Phase 2]** Read `napi_disable_locked()` and `napi_enable_locked()`
  in `net/core/dev.c` — confirmed non-idempotent behavior and SCHED-bit
  wait loop.
- **[Phase 2]** Read `netif_napi_add_weight_locked()` — confirmed
  SCHED/NPSVC set at init (lines 7496–7497).
- **[Phase 3]** `git describe HEAD` → v6.18.44; Makefile → 6.18.44.
- **[Phase 3]** `git blame -L 699,725 mal.c` → unconditional
  `napi_disable` from 2007.
- **[Phase 3]** `git show b3e441c6ed865` → conditional enable/disable
  added 2007-10-16.
- **[Phase 3]** `git log --oneline -20 -- mal.c` → recent history, no
  duplicate fix.
- **[Phase 4]** `b4 dig` — commit not in tree, could not run `-c`.
  UNVERIFIED.
- **[Phase 4]** WebFetch patch.msgid.link and lore raw — blocked
  (403/bot protection). UNVERIFIED.
- **[Phase 5]** Traced `emac_exit()` → `mal_exit()` → `mal_remove()` in
  `core.c` and `mal.c`.
- **[Phase 5]** Grep `mal_register_commac` / `mal_unregister_commac`
  call sites in `core.c`.
- **[Phase 6]** Confirmed buggy unconditional `napi_disable` at
  `mal.c:706` in local tree.
- **[Phase 6]** `git grep "potential system hang in mal_remove"` — no
  match; fix not applied.
- **[Phase 7]** Read `drivers/net/ethernet/ibm/emac/Kconfig` — depends
  on PPC_DCR, PowerPC embedded.
- **[Phase 8]** Verified module unload order: emac driver unregistered
  before mal driver in `emac_exit()`.

**YES**The background search finished: the fix commit is **not** in this
tree (`v6.18.44`). A grep for the commit subject returned nothing, and
`mal_remove()` still calls `napi_disable()` unconditionally.

That matches the earlier analysis — this is a real hang on driver
teardown for IBM EMAC on PowerPC, and the patch should be backported
here.

**YES**

 drivers/net/ethernet/ibm/emac/mal.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index 7d70056e90081..35b93e6bcdf9f 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -703,13 +703,13 @@ static void mal_remove(struct platform_device *ofdev)
 	MAL_DBG(mal, "remove" NL);
 
 	/* Synchronize with scheduled polling */
-	napi_disable(&mal->napi);
-
-	if (!list_empty(&mal->list))
+	if (!list_empty(&mal->list)) {
+		napi_disable(&mal->napi);
 		/* This is *very* bad */
 		WARN(1, KERN_EMERG
 		       "mal%d: commac list is not empty on remove!\n",
 		       mal->index);
+	}
 
 	mal_reset(mal);
 
-- 
2.53.0

