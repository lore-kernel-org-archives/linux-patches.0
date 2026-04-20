Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33BC3D413C;
	Mon, 20 Apr 2026 13:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691419; cv=none; b=kt7S8S0B9Y5VFf9HzPI6zhPY0MVfDFha1pRIJ0l6aJGIlf57Fpg0Uwjcz2OCpJmBnGJhfCJFK/wme+kiDrJy2p3CbPpityWdRXMhSDVTDwTSNEJ3oU3TW5Ds5ccpN+Xv58Z6asDaGXDtmyHqEk26Lbh/X3kgAEdj5SU0Uwnocms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691419; c=relaxed/simple;
	bh=tn6kix7pzSCA8qfRs5qKPBWVdHTu2MB5RaBMY2HOXms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mNNRuj3YXezNfZ1bEXdfOs/ThIGFeHrtsXz+wK5IUNhdB4b36gB/Skm1yChkg2XsX33jy1+FuYkUi5VhVGFLdVH8EQAsFXVjjd1Q4qd9Az/rAgFdP6SCNXA0I1e2tsgDjdccGbQB23AL5OeTM9b38dyMCWigo+oJA7s/gBRAOg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iScWhOPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iScWhOPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B13C2BCB4;
	Mon, 20 Apr 2026 13:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691419;
	bh=tn6kix7pzSCA8qfRs5qKPBWVdHTu2MB5RaBMY2HOXms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iScWhOPe8Ffegrlrn5jKG+jaztj/J1Ge0efkepz+oKcaAsVGJlX0hAa3wxKJz91ld
	 l2HIuZPwXFtB24Dzjd7bjB6LWe2eSNpexlQX0UbvovwgaGCGHQKol1xapBignlvSVo
	 BGMwG7g3tpsYeNmQ1mvi0j9BrCCJE6J7k1NmDbdkPa/hDpXTa+9ui+A8f3tL/JunM7
	 wFXIEiMLM4yOx7QQ7mlIgrPrl+ZTiXSP4w3JkldfxO3ntgE5kWIWcAbA6JsxKI5g8j
	 vZL80qsRNoKnojWPp4Q4eVKyzAqCkJznr4fjUNSWGG8VNGiKSmFReGwt3uFZDdttaV
	 uDXOwVyPr0Aig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] FDDI: defxx: Rate-limit memory allocation errors
Date: Mon, 20 Apr 2026 09:16:49 -0400
Message-ID: <20260420132314.1023554-15-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Maciej W. Rozycki" <macro@orcam.me.uk>

[ Upstream commit 7fae6616704a17c64438ad4b73a6effa6c03ffda ]

Prevent the system from becoming unstable or unusable due to a flood of
memory allocation error messages under memory pressure, e.g.:

[...]
fddi0: Could not allocate receive buffer.  Dropping packet.
fddi0: Could not allocate receive buffer.  Dropping packet.
fddi0: Could not allocate receive buffer.  Dropping packet.
fddi0: Could not allocate receive buffer.  Dropping packet.
rcu: INFO: rcu_sched self-detected stall on CPU
rcu: 	0-...!: (332 ticks this GP) idle=255c/1/0x40000000 softirq=16420123/16420123 fqs=0
rcu: 	(t=2103 jiffies g=35680089 q=4 ncpus=1)
rcu: rcu_sched kthread timer wakeup didn't happen for 2102 jiffies! g35680089 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402
rcu: 	Possible timer handling issue on cpu=0 timer-softirq=12779658
rcu: rcu_sched kthread starved for 2103 jiffies! g35680089 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=0
rcu: 	Unless rcu_sched kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_sched       state:I stack:0     pid:14    tgid:14    ppid:2      flags:0x00004000
Call Trace:
 __schedule+0x258/0x580
 schedule+0x19/0xa0
 schedule_timeout+0x4a/0xb0
 ? hrtimers_cpu_dying+0x1b0/0x1b0
 rcu_gp_fqs_loop+0xb1/0x450
 rcu_gp_kthread+0x9d/0x130
 kthread+0xb2/0xe0
 ? rcu_gp_init+0x4a0/0x4a0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x2d/0x50
 ? kthread_park+0x90/0x90
 ret_from_fork_asm+0x12/0x20
 entry_INT80_32+0x10d/0x10d
CPU: 0 UID: 500 PID: 21895 Comm: 31370.exe Not tainted 6.13.0-dirty #2

(here running the libstdc++-v3 testsuite).

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/alpine.DEB.2.21.2603291236590.60268@angie.orcam.me.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** `FDDI: defxx:` (FDDI network driver, DEC FDDI
  controllers)
- **Action verb:** "Rate-limit" — this implies controlling the frequency
  of something
- **Summary:** Rate-limit memory allocation error messages to prevent
  system instability

### Step 1.2: Tags
- **Signed-off-by:** Maciej W. Rozycki `<macro@orcam.me.uk>` — **the
  driver maintainer** (verified from line 24 of defxx.c)
- **Reviewed-by:** Andrew Lunn `<andrew@lunn.ch>` — well-known
  networking reviewer
- **Link:** patch.msgid.link URL (lore.kernel.org was blocked by Anubis)
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` — **the net
  subsystem maintainer** (applied by him)
- No Fixes: tag, no Cc: stable, no Reported-by — expected for manual
  review candidates

### Step 1.3: Commit Body
The commit describes a **real observed problem**: under memory pressure,
the unlimited `printk()` in the receive path floods the console so badly
that it causes:
- RCU stall (`rcu_sched self-detected stall on CPU`)
- RCU kthread starvation (`rcu_sched kthread starved for 2103 jiffies!`)
- System becoming "unstable or unusable"
- The message "Unless rcu_sched kthread gets sufficient CPU time, OOM is
  now expected behavior"

A full stack trace is provided showing the real crash scenario. The
trigger was running the libstdc++-v3 testsuite, causing memory pressure
leading to allocation failures in the receive path.

### Step 1.4: Hidden Bug Fix Detection
This IS a bug fix, not a cosmetic change. The unlimited printk in a hot
interrupt-driven receive path causes:
1. Console flooding → CPU time consumed by printk
2. RCU stalls → system instability
3. Potential OOM due to RCU kthread starvation

The fix prevents a **soft lockup/RCU stall** which is a serious system
stability issue.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed:** 1 (`drivers/net/fddi/defxx.c`)
- **Lines changed:** 1 line modified (`printk` → `printk_ratelimited`)
- **Function modified:** `dfx_rcv_queue_process()`
- **Scope:** Single-file, single-line, surgical fix

### Step 2.2: Code Flow Change
- **Before:** Every failed `netdev_alloc_skb()` in the receive path
  prints an unrestricted message via `printk()`
- **After:** The same message is printed via `printk_ratelimited()`,
  which limits output to
  DEFAULT_RATELIMIT_INTERVAL/DEFAULT_RATELIMIT_BURST (typically 5
  seconds/10 messages)
- **Execution path affected:** The error/failure path within the
  interrupt-driven packet receive handler

### Step 2.3: Bug Mechanism
This is a **system stability fix** — the unlimited printk in a hot path
(interrupt handler → receive queue processing) causes:
- Console output flooding
- CPU starvation for other kernel threads (RCU)
- RCU stalls leading to system hang

Category: **Performance/stability fix that prevents soft lockups and RCU
stalls** — this is a CRITICAL stability issue, not a mere optimization.

### Step 2.4: Fix Quality
- **Obviously correct:** Yes. `printk_ratelimited()` is a drop-in
  replacement for `printk()` with rate limiting. It's a well-established
  kernel API.
- **Minimal/surgical:** Yes — exactly 1 line changed, same format
  string, same arguments.
- **Regression risk:** Virtually none. The only behavioral difference is
  fewer log messages under sustained failure, which is the desired
  behavior.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
The buggy `printk` line dates back to commit `1da177e4c3f41` — the
**initial Linux git import** (April 2005, Linux 2.6.12-rc2). This code
has been present in every kernel version since the beginning of git
history, meaning **all active stable trees** contain this bug.

### Step 3.2: Fixes Tag
No Fixes: tag present (expected for manual review candidates).

### Step 3.3: File History
The file has had very few changes in recent history (only 1 change since
v6.1 — `HAS_IOPORT` dependencies). This means the fix will apply cleanly
to all stable trees.

### Step 3.4: Author
Maciej W. Rozycki is the **listed maintainer** of the defxx driver (line
24: "Maintainers: macro Maciej W. Rozycki <macro@orcam.me.uk>"). This is
a fix from the subsystem maintainer who encountered the issue firsthand.

### Step 3.5: Dependencies
None. `printk_ratelimited` has been available in the kernel since ~2010.
No prerequisites needed.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.5
The lore.kernel.org and patch.msgid.link URLs were blocked by Anubis
anti-bot protection. However:
- The patch was **reviewed by Andrew Lunn** (well-known net reviewer)
- The patch was **applied by Jakub Kicinski** (net subsystem maintainer)
- The commit message includes a detailed real-world reproduction
  scenario

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
- `dfx_rcv_queue_process()` — the function where the change is made

### Step 5.2: Callers
- Called from `dfx_int_common()` (line 1889), which is the interrupt
  service routine
- `dfx_int_common()` is called from `dfx_interrupt()` (lines 1972, 1998,
  2023) — the hardware IRQ handler
- This is called on **every received packet interrupt**, making it a hot
  path

### Step 5.3-5.4: Call Chain
The call chain is: `Hardware IRQ → dfx_interrupt() → dfx_int_common() →
dfx_rcv_queue_process() → [allocation failure] → printk()`

Under memory pressure, every incoming packet that fails allocation
triggers the printk. On an active FDDI network (100 Mbit/s), this could
be thousands of packets per second, each generating a printk call —
overwhelming the system.

### Step 5.5: Similar Patterns
There are many other `printk("Could not...")` calls in the driver (11
total), but only this one is in a hot interrupt-driven path where rapid
repetition is possible.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable Trees
The buggy code has been present since the initial git import (2005). It
exists in **all stable trees** (5.4.y, 5.10.y, 5.15.y, 6.1.y, 6.6.y,
6.12.y, etc.).

### Step 6.2: Backport Complications
The file has had minimal changes. The printk line is unchanged since
2005. The patch will apply **cleanly** to all active stable trees.

### Step 6.3: Related Fixes
No related fixes for this specific issue found in stable.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Path:** `drivers/net/fddi/` — FDDI networking driver
- **Criticality:** PERIPHERAL — FDDI is a legacy technology, but there
  are real users (the maintainer himself encountered this bug while
  testing)

### Step 7.2: Activity
Very low activity — the file has had only a handful of changes in recent
years. This is mature, stable code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Population
Users of DEC FDDI controllers (DEFTA/DEFEA/DEFPA) under memory pressure.
While this is a niche user base, the fix is risk-free for everyone.

### Step 8.2: Trigger Conditions
- System must be under memory pressure (allocation failures)
- FDDI interface must be receiving packets
- The combination causes printk flooding → RCU stalls → system hang
- Triggered in real life (libstdc++ testsuite causing memory pressure)

### Step 8.3: Failure Mode Severity
- **RCU stall / soft lockup → CRITICAL** (system becomes
  unusable/unstable)
- Can lead to OOM as stated in the RCU warning
- Data loss risk from system hang

### Step 8.4: Risk-Benefit Ratio
- **Benefit:** Prevents system hang/RCU stall under memory pressure —
  HIGH
- **Risk:** 1 line change, `printk` → `printk_ratelimited`, well-
  established API — VERY LOW
- **Ratio:** Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Compilation

**FOR backporting:**
- Fixes a real RCU stall / system instability issue with concrete
  reproduction
- Single-line, obviously correct change (`printk` →
  `printk_ratelimited`)
- Fix is from the driver maintainer who observed the bug firsthand
- Reviewed by Andrew Lunn, applied by Jakub Kicinski (net maintainer)
- Buggy code exists in all stable trees since 2005
- Patch applies cleanly — no dependencies, no conflicts expected
- Zero regression risk

**AGAINST backporting:**
- FDDI is a legacy/niche technology with a small user base
- The trigger requires specific conditions (memory pressure + active
  FDDI traffic)

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — author encountered and
   reproduced it; 1-line drop-in replacement
2. **Fixes a real bug?** YES — RCU stall / system hang under memory
   pressure
3. **Important issue?** YES — system instability, RCU stalls, potential
   OOM
4. **Small and contained?** YES — single line change in a single file
5. **No new features or APIs?** YES — no new features
6. **Can apply to stable trees?** YES — code unchanged since 2005, clean
   apply expected

### Step 9.3: Exception Categories
Not an exception category — this is a straightforward bug fix.

### Step 9.4: Decision
This is a minimal, zero-risk fix for a real system stability issue (RCU
stalls). It meets all stable kernel criteria.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Andrew Lunn, applied by Jakub
  Kicinski (net maintainer SOB)
- [Phase 1] Commit body includes full RCU stall stack trace
  demonstrating the real-world bug
- [Phase 2] Diff: exactly 1 line changed in `dfx_rcv_queue_process()`,
  `printk` → `printk_ratelimited`
- [Phase 3] git blame: buggy printk line from `1da177e4c3f41` (initial
  git import, 2005), present in all stable trees
- [Phase 3] git log --author: Maciej W. Rozycki is the driver maintainer
  (confirmed from file header line 24)
- [Phase 3] git log v6.6../v6.1../v5.15.. -- defxx.c: minimal changes,
  patch will apply cleanly
- [Phase 4] b4 dig and WebFetch: lore blocked by Anubis; could not
  verify mailing list discussion directly
- [Phase 5] Callers traced: `dfx_interrupt()` → `dfx_int_common()` →
  `dfx_rcv_queue_process()` — this is a hardware IRQ path, hot path for
  every received packet
- [Phase 5] Grep confirmed: `printk_ratelimited` is a well-established
  macro in `include/linux/printk.h`
- [Phase 6] Code present in all stable trees (unchanged since 2005)
- [Phase 8] Failure mode: RCU stall → system hang, severity CRITICAL
- UNVERIFIED: Could not access lore.kernel.org discussion due to Anubis
  protection; however, the commit message and review tags provide
  sufficient evidence

**YES**

 drivers/net/fddi/defxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/fddi/defxx.c b/drivers/net/fddi/defxx.c
index 0fbbb7286008d..6b8cfbee3b9d6 100644
--- a/drivers/net/fddi/defxx.c
+++ b/drivers/net/fddi/defxx.c
@@ -3182,7 +3182,7 @@ static void dfx_rcv_queue_process(
 							       pkt_len + 3);
 				if (skb == NULL)
 					{
-					printk("%s: Could not allocate receive buffer.  Dropping packet.\n", bp->dev->name);
+					printk_ratelimited("%s: Could not allocate receive buffer.  Dropping packet.\n", bp->dev->name);
 					bp->rcv_discards++;
 					break;
 					}
-- 
2.53.0

