Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3327524B0D;
	Mon, 31 Aug 2026 13:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183861; cv=none; b=aNE16RRD60MyD96OQ35PXv+vBxuZIn6GhIdXF1bpSfJse+Zpryi2vDRFA1JiGulizAvhabDwiLnpTaT78j9XTl2Q9dLcfA4cziXSDqjBiY5pMgBJxhrGbleecP08DCkYWHmPbMMrucpHYiMPsiFfSvaWpAYHtM2m0e8HjuTYkHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183861; c=relaxed/simple;
	bh=OZseUKhZwRVlbj1/1OsmDOimzc7BCHLoRTaWQt1CYXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HCUqtbMRZHO14NErNaIp6A8pPY0XzDYmnymG7EByho+3yBZsG2zOKno/vlhZrQW15Mi+iG7SxLy3GRwqwTtFWcdU9hu46Iq/caRade3WR3h9UdMxMkjxE558szEk52WUbjRe9rXtaqGNV23vXZlnfnNlFOeRE9GIuEpX3bA32HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ihp/Ma7J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ihp/Ma7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E671F00ADB;
	Mon, 31 Aug 2026 13:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183858;
	bh=SjSB3VUQZ+aGSf3a9gQmCHoW8bUyI2z57BnBPQlXIF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ihp/Ma7J05v3G+Bnoa1CQpGcUXCeTtKeuejPd3MZd/Ldu0wZagZETZI/cxAv1/m+/
	 07DZTOpvd/xdjKHhan4C2pg7Q4MdcsW/gOZ1p+u6rsDLLoBwwpEE34pqxtGDyrL+7w
	 FLINvPvtp5owJdWIWMcDry95pcXS99RKcdLQeL79ZbGWpog9ZjWZMY2WIXGzPQt6QV
	 1JsXUhLHSk3AlIdRdZcf8QCLNexOlu8WqTrrU0ycyaJliPCc03GOWiLp5WEpn9Tj0+
	 7EJ1PHAETMI72IjmuilZg3kKAgpR8UUW/93yv+Dn17o7WKeryxUhQ16KGzjJ8YB91w
	 yBJ8EyBVf1RJQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: au1000: move free_irq out of the close-time spinlocked section
Date: Mon, 31 Aug 2026 09:26:14 -0400
Message-ID: <20260831133314.4125787-346-sashal@kernel.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit f48763beab4eea41fc480c9702ec6eebe8d75e4f ]

au1000_close() calls free_irq() while aup->lock is still held with
spin_lock_irqsave(). free_irq() can sleep because it takes the IRQ
descriptor request mutex, so it does not belong inside the close-time
spinlocked section.

This was found by our static analysis tool and then confirmed by manual
review of the in-tree au1000_close() .ndo_stop path. The reviewed path
keeps aup->lock held across the MAC reset, queue stop and
free_irq(dev->irq, dev).

A directed runtime validation kept that ndo_stop carrier and the same
free_irq(dev->irq, dev) operation under the driver lock. Lockdep reported
"BUG: sleeping function called from invalid context" and "Invalid wait
context" while free_irq() was taking desc->request_mutex, with
au1000_close() and free_irq() on the stack.

Drop aup->lock before freeing the IRQ. The protected close-time work still
stops the device and queue before IRQ teardown, but the sleepable IRQ core
path now runs outside the spinlocked section.

Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260619151816.1144289-1-runyu.xiao@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: au1000: move free_irq out of the
close-time spinlocked section`

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[net: au1000]` `[move]` — relocate `free_irq()` out of a
spinlocked section in `au1000_close()`.

### Step 1.2: Commit message tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Runyu Xiao `<runyu.xiao@seu.edu.cn>` |
| Reviewed-by | Simon Horman `<horms@kernel.org>` |
| Link |
https://patch.msgid.link/20260619151816.1144289-1-runyu.xiao@seu.edu.cn
|
| Signed-off-by | Jakub Kicinski `<kuba@kernel.org>` (committer) |
| Fixes: | Not in final commit message (present in lore submission:
`Fixes: 1da177e4c3f4`) |
| Cc: stable | Present in lore submission (`Cc: stable@vger.kernel.org`)
|
| Reported-by / Tested-by | None |
| syzbot | None |

**Notable:** Author nominated for stable in lore; subsystem reviewer
approved.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `au1000_close()` calls `free_irq()` while holding `aup->lock`
  via `spin_lock_irqsave()`.
- **Symptom:** Lockdep reports `"BUG: sleeping function called from
  invalid context"` and `"Invalid wait context"` because `free_irq()`
  takes `desc->request_mutex`.
- **Trigger:** `ndo_stop` / netdev close path (`ifconfig down`, driver
  unload).
- **Root cause:** Sleepable IRQ teardown inside an atomic (spinlocked)
  context.
- **Fix:** Drop `aup->lock` before `free_irq()`; MAC reset and queue
  stop remain protected.

### Step 1.4: Hidden bug fix detection
**Record:** Not disguised — this is an explicit locking-context bug fix,
even though the subject uses "move" rather than "fix".

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change inventory
**Record:**
- **File:** `drivers/net/ethernet/amd/au1000_eth.c` (+1 line moved, net
  ~2 lines changed)
- **Function:** `au1000_close()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
| Hunk | Before | After |
|------|--------|-------|
| `au1000_close()` | Hold `aup->lock` → reset MAC → stop queue →
`free_irq()` → unlock | Hold lock → reset MAC → stop queue → **unlock**
→ `free_irq()` |

Affected path: netdev `.ndo_stop` error/teardown path.

### Step 2.3: Bug mechanism
**Record:** **Category:** Synchronization / invalid context (sleeping
while holding spinlock).

`free_irq()` → `__free_irq()` → `mutex_lock(&desc->request_mutex)` in
`kernel/irq/manage.c`. That is illegal while
`spin_lock_irqsave(&aup->lock)` is held.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Yes — matches established netdev driver
  pattern.
- **Minimal:** Two-line reorder.
- **Regression risk:** Low. MAC reset and `netif_stop_queue()` still run
  under the lock. IRQ handler (`au1000_interrupt`) does not take
  `aup->lock`; `au1000_rx()` / `au1000_tx_ack()` also do not use it.
- **Precedent:** `net: macb: Move devm_{free,request}_irq() out of spin
  lock area` (99405131d6edd) — same class of fix, backported to stable
  with `Cc: stable@vger.kernel.org`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy `free_irq()` under spinlock dates to **2005**
(`1da177e4c3f4`, Linux 2.6.12-rc2). Present in this 6.18.44 tree at
lines 939–948.

### Step 3.2: Fixes: tag
**Record:** Lore submission has `Fixes: 1da177e4c3f4` — original import
of this driver code. Bug has existed since driver introduction; fix is
relevant to all trees that contain this driver.

### Step 3.3: Related file history
**Record:** Recent `au1000_eth.c` changes are cleanups (static
annotations, platform remove callback). No related fix already applied.
Fix is standalone (not part of a series).

### Step 3.4: Author context
**Record:** Runyu Xiao has submitted similar lock-context fixes (e.g.,
`misc: nsm`, `mmc: vub300`). Simon Horman (Reviewed-by) is a networking
maintainer.

### Step 3.5: Dependencies
**Record:** No prerequisites. Patch is self-contained and structurally
identical to current tree code.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Lore thread fetched via `curl` from `https://lore.kernel.org
/netdev/20260619151816.1144289-1-runyu.xiao@seu.edu.cn/t.mbox.gz`. `b4
dig -c` could not be used (commit not in this checkout). Patch includes
lockdep stack trace and `Cc: stable@vger.kernel.org`.

### Step 4.2: Reviewers
**Record:** To: netdev maintainers (Lunn, Miller, Dumazet, Kicinski,
Abeni). Cc: `netdev@vger.kernel.org`, `stable@vger.kernel.org`.
**Reviewed-by: Simon Horman**.

### Step 4.3: Bug report
**Record:** Static analysis discovery, confirmed by manual review and
runtime lockdep validation with reproduced stack trace in patch
submission.

### Step 4.4: Related patches
**Record:** macb IRQ-out-of-spinlock fix (99405131d6edd) is directly
analogous and was stable-backported.

### Step 4.5: Stable list history
**Record:** Author explicitly nominated `Cc: stable@vger.kernel.org` in
submission. No objection found in fetched thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `au1000_close()` (modified); related: `au1000_interrupt()`,
`au1000_open()`, `au1000_reset_mac_unlocked()`.

### Step 5.2: Callers
**Record:** `au1000_close` is registered as `.ndo_stop` in
`au1000_netdev_ops` (line 1051). Called from generic netdev core on
interface down — user-reachable via `ioctl(SIOCSIFFLAGS)` / `ip link set
down`.

### Step 5.3: Callees
**Record:** `phy_stop()`, `spin_lock_irqsave()`,
`au1000_reset_mac_unlocked()`, `netif_stop_queue()`, `free_irq()`,
`spin_unlock_irqrestore()`.

### Step 5.4: Reachability
**Record:** **Userspace-reachable** on systems with
`CONFIG_MIPS_AU1X00_ENET` (depends on `MIPS_ALCHEMY`). Trigger: bringing
interface down.

### Step 5.5: Similar patterns
**Record:** `au1000_open()` already calls `free_irq()` **without**
holding `aup->lock` on init failure (line 915) — the close path was
inconsistent.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code in tree?
**Record:** **YES.** Current `au1000_close()` at lines 939–948 still
calls `free_irq()` before `spin_unlock_irqrestore()`.

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — only reordering unlock vs.
`free_irq()` in unchanged function structure. No conflicting recent
churn in this function.

### Step 6.3: Related fixes already present?
**Record:** **No.** Grep and `git log` show no prior au1000 free_irq
lock-context fix in this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/net/ethernet/amd** — **PERIPHERAL** (MIPS Alchemy
embedded Ethernet). Niche hardware, but netdev close is a standard
operational path.

### Step 7.2: Subsystem activity
**Record:** Low activity; driver is mature/legacy. Bug is long-standing,
not recently introduced.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of **MIPS Alchemy (AU1X00) boards** with
`CONFIG_MIPS_AU1X00_ENET=y/m`. Small population, but real embedded
deployments.

### Step 8.2: Trigger conditions
**Record:** Netdev close (`ifconfig down`, `ip link set down`, driver
remove). **Common** operational action, not a rare init-only path.
Unprivileged users can trigger if they can manage the interface.

### Step 8.3: Failure mode severity
**Record:**
- With lockdep / `CONFIG_DEBUG_ATOMIC_SLEEP`: **BUG splat** on every
  interface down.
- Without debug: sleeping (`mutex_lock`) while holding spinlock risks
  **deadlock / soft lockup** if the mutex blocks.
- **Severity: MEDIUM-HIGH** (locking violation with realistic hang
  potential; lockdep-confirmed).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Eliminates invalid sleep-in-atomic on standard teardown
  path; aligns with stable precedent (macb).
- **Risk:** Very low — 2-line reorder, reviewed by maintainer, MAC/queue
  still quiesced under lock before IRQ free.
- **Ratio:** Favorable for backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verified locking bug (`free_irq` under spinlock)
- Lockdep stack trace in lore submission
- Small, surgical, obviously correct fix
- Reviewed-by subsystem maintainer
- Author nominated `Cc: stable`
- Bug present since 2005, confirmed in 6.18.44 tree
- Identical macb fix was stable-backported
- User-triggerable netdev close path

**AGAINST backport:**
- Obscure hardware (MIPS Alchemy only)
- May only produce visible splats on debug kernels (though production
  deadlock risk remains)

**Unresolved:** None material to the decision.

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — lockdep-validated;
Reviewed-by maintainer |
| 2. Fixes real bug? | **PASS** — invalid sleep context in
`au1000_close()` |
| 3. Important issue? | **PASS** — lockdep BUG / potential deadlock on
netdev close |
| 4. Small and contained? | **PASS** — 1 file, ~2 lines |
| 5. No new features/APIs? | **PASS** |
| 6. Can apply to local tree? | **PASS** — buggy code present; clean
apply |

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision rationale
This commit fixes a long-standing invalid-context bug in the AU1000
Ethernet driver's netdev close path. `free_irq()` takes a mutex and must
not run while holding a spinlock. The fix is minimal, reviewed, lockdep-
confirmed, and follows the same pattern as the macb fix already accepted
into stable. The buggy code is present in this 6.18.44 tree, the driver
is built for MIPS Alchemy platforms, and the trigger (interface down) is
routine. Benefit outweighs risk.

---

## Verification

- **[Phase 1]** `git describe HEAD` + Makefile: tree is 6.18.44
- **[Phase 1]** Parsed tags from commit message and lore mbox
- **[Phase 2]** Read diff and `au1000_close()` in tree (lines 929–951)
- **[Phase 2]** Confirmed `free_irq()` →
  `mutex_lock(&desc->request_mutex)` in `kernel/irq/manage.c:1826`
- **[Phase 3]** `git blame -L 939,948`: bug since `1da177e4c3f4` (2005)
- **[Phase 3]** `git log --oneline -20 --
  drivers/net/ethernet/amd/au1000_eth.c`: no prior fix
- **[Phase 4]** `curl` lore mbox: found `Cc: stable`, lockdep trace,
  `Reviewed-by: Simon Horman`
- **[Phase 4]** `b4 dig -c`: N/A — commit not in checkout; used lore
  curl instead
- **[Phase 4]** `git show 99405131d6edd`: macb analogous fix stable-
  backported
- **[Phase 5]** Grep `aup->lock` in `au1000_eth.c`: IRQ path does not
  use driver lock
- **[Phase 5]** Confirmed `.ndo_stop = au1000_close` at line 1051
- **[Phase 6]** Buggy code confirmed present at lines 946–948
- **[Phase 6]** `CONFIG_MIPS_AU1X00_ENET` in
  `drivers/net/ethernet/amd/Kconfig:104-111`
- **[Phase 8]** Assessed severity from lockdep report and mutex-under-
  spinlock semantics

**YES**The background git search finished. It didn’t find this
`free_irq` fix in the tree yet, and there’s no earlier au1000-specific
backport for it.

What did turn up:
- `d04455fba3777` — unrelated `au1000_eth` cleanup
- Several other `free_irq`/locking fixes from Runyu Xiao, but in other
  drivers (nsm, brcmfmac, rt2x00, etc.)

That matches the earlier conclusion: the bug is still present in
6.18.44, and this patch should be backported.

**YES**

 drivers/net/ethernet/amd/au1000_eth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index 9d35ac348ebe3..5a04056e38fa3 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -943,9 +943,10 @@ static int au1000_close(struct net_device *dev)
 	/* stop the device */
 	netif_stop_queue(dev);
 
+	spin_unlock_irqrestore(&aup->lock, flags);
+
 	/* disable the interrupt */
 	free_irq(dev->irq, dev);
-	spin_unlock_irqrestore(&aup->lock, flags);
 
 	return 0;
 }
-- 
2.53.0

