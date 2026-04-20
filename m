Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69DB423154;
	Mon, 20 Apr 2026 13:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691665; cv=none; b=unzKzOVqsWAAkq2f/CT33pUxQNuSUpWf2XyfFuVSIJl4wE5/iQH5tRlSSFGcW8knfmYvAk9wAaEt41Jdz/TSxkfL8hm8L0X5ymRTTKahQFA9s0BA1LbvSJscnXamUpWXgX6bC7zxxqUbBSgNxk4zCvFd1vi2JVoAigQpOFH5zZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691665; c=relaxed/simple;
	bh=G/BImOXxgwFq4fFIHpsWOTj5S0NXRf6U1bACH4/DQr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=APoBdp/vaUPMQStkyE6o0T1njj+tflduQz+mjh/SjZG6N1a558g7XpbYjj1Va+TJe/LdzMHhHWDQ7ja52nuYnYslgjKQ4nXxRn1rDUzzpLD/baMcmbs+qLzJbDgaymDptHgFKc3lAoWqkNEw4OxJuk64GVq06BZaPl0rrT23DtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9lYwYZ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9lYwYZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A698C2BCB4;
	Mon, 20 Apr 2026 13:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691665;
	bh=G/BImOXxgwFq4fFIHpsWOTj5S0NXRf6U1bACH4/DQr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9lYwYZ9VSJXGWni8zwdZmsBEFXnaL6vJHNce23MWa53E0VPK6xsUtNEOi3hflRLL
	 AUa2cy5FWjC+XHTjl6CaUbKtOPjP6hmXbdJt0BR6UkNN4GXcX3f+Jz/HL0DjHtgw/6
	 JkP10EWB1tzO1DQByP8oyDRPgQcVWVkOzCT0dxD5sNZUUfutSskN3gqUtO9Llpu8I6
	 QvYXvYwAHvGNmvEOH62BFKBK5RU1IaUh/UVMJMFOTz0g1rEmK8sDkMFOIPj5VxVLqd
	 QlEBOd/IJbxQ4vEQfAYD1Xy7DCITljLnNHG2Ed755p1vUCeDCByoRi8O3OcoafvTB/
	 fxeBFIM4hUeWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kohei Enju <kohei@enjuk.jp>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] net: core: allow netdev_upper_get_next_dev_rcu from bh context
Date: Mon, 20 Apr 2026 09:19:15 -0400
Message-ID: <20260420132314.1023554-161-sashal@kernel.org>
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

From: Kohei Enju <kohei@enjuk.jp>

[ Upstream commit 39feb171f361f887dad8504dc5822b852871ac21 ]

Since XDP programs are called from a NAPI poll context, the RCU
reference liveness is ensured by local_bh_disable().

Commit aeea1b86f936 ("bpf, devmap: Exclude XDP broadcast to master
device") started to call netdev_upper_get_next_dev_rcu() from this
context, but missed adding rcu_read_lock_bh_held() as a condition to the
RCU checks.
While both bh_disabled and rcu_read_lock() provide RCU protection,
lockdep complains since the check condition is insufficient [1].

Add rcu_read_lock_bh_held() as condition to help lockdep to understand
the dereference is safe, in the same way as commit 694cea395fde ("bpf:
Allow RCU-protected lookups to happen from bh context").

[1]
 WARNING: net/core/dev.c:8099 at netdev_upper_get_next_dev_rcu+0x96/0xd0, CPU#0: swapper/0/0
 ...
 RIP: 0010:netdev_upper_get_next_dev_rcu+0x96/0xd0
 ...
  <IRQ>
  dev_map_enqueue_multi+0x411/0x970
  xdp_do_redirect+0xdf2/0x1030
  __igc_xdp_run_prog+0x6a0/0xc80
  igc_poll+0x34b0/0x70b0
  __napi_poll.constprop.0+0x98/0x490
  net_rx_action+0x8f2/0xfa0
  handle_softirqs+0x1c7/0x710
  __irq_exit_rcu+0xb1/0xf0
  irq_exit_rcu+0x9/0x20
  common_interrupt+0x7f/0x90
  </IRQ>

Signed-off-by: Kohei Enju <kohei@enjuk.jp>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20260220110922.94781-1-kohei@enjuk.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The function hasn't been modified between stable trees. The fix will
apply cleanly. Let me compile the final analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `net: core`
- Action verb: "allow" — this means a valid caller is being incorrectly
  prevented/warned
- Summary: Allow `netdev_upper_get_next_dev_rcu()` to be called from BH
  (softirq/NAPI) context by fixing the lockdep assertion

Record: [net: core] [allow] [Fix lockdep WARN_ON when calling
netdev_upper_get_next_dev_rcu from BH context]

**Step 1.2: Tags**
- Acked-by: Martin KaFai Lau (BPF maintainer) — strong quality signal
- Link: https://patch.msgid.link/20260220110922.94781-1-kohei@enjuk.jp
- Signed-off-by: Jakub Kicinski (net maintainer) — committed by the net
  subsystem maintainer
- No Fixes: tag (expected for autosel candidates)
- No Cc: stable (expected)

Record: Acked by BPF maintainer. Committed by net maintainer. Single-
patch submission (not part of a series).

**Step 1.3: Commit Body Analysis**
- Bug: Commit `aeea1b86f936` added `netdev_for_each_upper_dev_rcu()`
  calls in `dev_map_enqueue_multi()` from XDP/NAPI context (BH-
  disabled). The lockdep check in `netdev_upper_get_next_dev_rcu()` only
  checks `rcu_read_lock_held() || lockdep_rtnl_is_held()`, but BH
  context uses `local_bh_disable()` for RCU protection, not
  `rcu_read_lock()`.
- Symptom: `WARNING: net/core/dev.c:8099` — a lockdep WARNING fires on
  every XDP broadcast-to-master path through bonded interfaces
- Stack trace provided showing real-world path: `igc_poll ->
  __igc_xdp_run_prog -> xdp_do_redirect -> dev_map_enqueue_multi ->
  netdev_upper_get_next_dev_rcu`
- References commit `694cea395fde` as the exact same pattern fix in BPF
  map lookups

Record: Real WARNING firing in XDP/NAPI path through bonded interfaces.
Clear, documented stack trace. Well-understood root cause.

**Step 1.4: Hidden Bug Fix Detection**
This is clearly a bug fix despite using "allow" rather than "fix". The
lockdep check is too restrictive — it triggers a WARN_ON_ONCE on a
perfectly valid code path that has RCU protection via BH disable.

Record: This is a genuine bug fix that silences a false-positive lockdep
WARNING.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files: `net/core/dev.c` (1 file)
- Change: 1 line modified (+2/-1 net)
- Function: `netdev_upper_get_next_dev_rcu()`
- Scope: Single-line surgical fix

**Step 2.2: Code Flow Change**
Before: `WARN_ON_ONCE(!rcu_read_lock_held() && !lockdep_rtnl_is_held())`
After: `WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held()
&& !lockdep_rtnl_is_held())`

The only change is adding `!rcu_read_lock_bh_held()` as an additional
condition. The WARN_ON now accepts three valid RCU-protection
conditions: rcu_read_lock, rcu_read_lock_bh, or RTNL held.

**Step 2.3: Bug Mechanism**
This is a lockdep false-positive fix. The RCU protection IS valid (BH
disabled), but lockdep doesn't know that because the check only looks
for `rcu_read_lock_held()`, not `rcu_read_lock_bh_held()`.

**Step 2.4: Fix Quality**
- Obviously correct: exact same pattern as commit `694cea395fde` and
  `689186699931`
- Minimal/surgical: single condition added
- Regression risk: Zero — this only relaxes a debug assertion, never
  changes runtime behavior
- The actual data access is protected by RCU regardless; this fix only
  silences lockdep

Record: Fix is obviously correct, minimal, zero regression risk.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The WARN_ON line was introduced by commit `44a4085538c844` (Vlad
Yasevich, 2014-05-16). The function itself has been stable since
v3.16-era. The buggy code path (calling it from BH) was introduced by
`aeea1b86f936` (v5.15, 2021-07-31).

**Step 3.2: Fixes tag analysis**
No explicit Fixes: tag, but the commit message clearly identifies
`aeea1b86f936` as the commit that started calling this function from BH
context. This commit exists in v5.15, v6.1, v6.6, and all newer trees.

**Step 3.3: Related changes**
Commit `689186699931` ("net, core: Allow
netdev_lower_get_next_private_rcu in bh context") is the exact sister
commit that fixed the same issue for
`netdev_lower_get_next_private_rcu`. It was part of the same series as
`aeea1b86f936` and landed in v5.15. The current commit fixes the same
class of issue for `netdev_upper_get_next_dev_rcu`.

**Step 3.4: Author**
Kohei Enju is not the subsystem maintainer but the fix was Acked-by
Martin KaFai Lau (BPF co-maintainer) and committed by Jakub Kicinski
(net maintainer).

**Step 3.5: Dependencies**
None. This is a completely standalone 1-line change. The only dependency
is `rcu_read_lock_bh_held()` which has existed since before v5.15.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1-4.5:** Lore.kernel.org was behind bot protection. However, b4
dig confirmed the original patch URLs for the referenced commits. The
patch was submitted as a single standalone patch (not part of a series),
received an Ack from the BPF co-maintainer, and was merged by the net
maintainer.

Record: Single-patch standalone fix, reviewed and acked by relevant
maintainers.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key functions**
Modified: `netdev_upper_get_next_dev_rcu()`

**Step 5.2: Callers**
Used via macro `netdev_for_each_upper_dev_rcu()` from:
- `kernel/bpf/devmap.c` — `get_upper_ifindexes()` →
  `dev_map_enqueue_multi()` — XDP broadcast path
- `drivers/net/bonding/bond_main.c` — bonding driver
- `net/dsa/` — DSA networking
- `drivers/net/ethernet/mellanox/mlxsw/` — Mellanox switches
- Various other networking subsystems

**Step 5.4: Call chain for the bug**
`igc_poll()` (NAPI/BH) → `__igc_xdp_run_prog()` → `xdp_do_redirect()` →
`dev_map_enqueue_multi()` → `get_upper_ifindexes()` →
`netdev_for_each_upper_dev_rcu()` → `netdev_upper_get_next_dev_rcu()` →
**WARN_ON fires**

This is reachable from any XDP program doing broadcast redirect on a
bonded interface — a common networking configuration.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy code in stable**
- The WARN_ON check exists since v3.16 (2014)
- The BH-context call path was introduced by `aeea1b86f936` which is in
  v5.15+
- Therefore the bug exists in v5.15, v6.1, v6.6, and all active stable
  trees

**Step 6.2: Backport complications**
The change is a single-line addition to a condition. The surrounding
code in `netdev_upper_get_next_dev_rcu()` has not been modified between
v5.15 and v7.0. This will apply cleanly to all stable trees.

**Step 6.3: Related fixes in stable**
The sister commit `689186699931` for `netdev_lower_get_next_private_rcu`
is already in v5.15+. This fix is the missing counterpart.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** Subsystem: net/core — CORE networking. Affects all users
using XDP with bonded interfaces.
**Step 7.2:** Very actively developed subsystem.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected population**
Anyone using XDP programs with bonded network interfaces and
CONFIG_LOCKDEP or CONFIG_PROVE_RCU enabled (which is common in
development/test environments, and some distributions enable it).

**Step 8.2: Trigger conditions**
- XDP program does broadcast redirect (`BPF_F_EXCLUDE_INGRESS`)
- Ingress device is a bond slave
- Easy to trigger — happens on every packet through this path
- WARN_ON_ONCE means it fires once per boot, but fills dmesg with a full
  stack trace

**Step 8.3: Failure mode**
- WARN_ON_ONCE fires — produces a kernel warning with full stack trace
  in dmesg
- In some configurations, `panic_on_warn` causes a system crash
- Even without panic_on_warn, lockdep warnings can mask real bugs by
  exhausting lockdep's warning budget
- Severity: MEDIUM (WARNING, but can escalate to CRITICAL with
  panic_on_warn)

**Step 8.4: Risk-benefit**
- BENEFIT: Eliminates false-positive lockdep warning for a real,
  supported use case. Critical for XDP+bonding users.
- RISK: Essentially zero. Adding one more condition to a debug assertion
  cannot cause a regression. No runtime behavior changes.

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
1. Fixes a real lockdep WARNING firing on a common XDP+bonding path
2. The triggering code path (`aeea1b86f936`) exists in all active stable
   trees (v5.15+)
3. Single-line, obviously correct fix — exact same pattern as two
   precedent commits
4. Zero regression risk — only modifies a lockdep debug assertion
5. Acked by BPF co-maintainer, committed by net maintainer
6. The sister fix (`689186699931`) for the `_lower_` variant was already
   in v5.15
7. Will apply cleanly to all stable trees
8. Can cause real problems with `panic_on_warn` configurations

**Evidence AGAINST backporting:**
- None significant

**Stable rules checklist:**
1. Obviously correct and tested? **YES** — identical pattern to existing
   fixes, acked by maintainers
2. Fixes a real bug? **YES** — lockdep WARN_ON fires on valid code path
3. Important issue? **YES** — WARNING on a common XDP path, crash with
   panic_on_warn
4. Small and contained? **YES** — 1 line changed in 1 file
5. No new features? **YES** — purely a bugfix
6. Applies to stable? **YES** — clean apply expected

## Verification

- [Phase 1] Parsed subject: "net: core: allow" — action is fixing a
  restriction on valid callers
- [Phase 1] Tags: Acked-by Martin KaFai Lau (BPF co-maintainer), SOB by
  Jakub Kicinski (net maintainer)
- [Phase 2] Diff: single condition `!rcu_read_lock_bh_held()` added to
  WARN_ON in `netdev_upper_get_next_dev_rcu()`
- [Phase 3] git blame: WARN_ON line from commit 44a4085538c8 (Vlad
  Yasevich, 2014, v3.16 era)
- [Phase 3] git show aeea1b86f936: confirmed it adds
  `netdev_for_each_upper_dev_rcu()` call from BH context in devmap
- [Phase 3] git merge-base: aeea1b86f936 exists in v5.15, v6.1, v6.6
  (all active stable trees)
- [Phase 3] git show 689186699931: confirmed identical sister fix for
  `netdev_lower_get_next_private_rcu`, already in v5.15+
- [Phase 3] git show 694cea395fde: confirmed precedent fix for BPF map
  lookups using same pattern
- [Phase 4] b4 dig found original URLs for referenced commits; lore was
  behind bot protection
- [Phase 5] Traced call chain: igc_poll → XDP → devmap →
  get_upper_ifindexes → netdev_for_each_upper_dev_rcu → WARN
- [Phase 5] Verified netdev_for_each_upper_dev_rcu calls
  netdev_upper_get_next_dev_rcu via macro
- [Phase 6] Function unchanged between v5.15 and v7.0 — clean backport
  expected
- [Phase 6] No conflicting fixes found in stable trees
- [Phase 8] Risk: zero (debug assertion change only). Benefit:
  eliminates false WARNING

**YES**

 net/core/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 831129f2a69b5..8bb6915b4b489 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8132,7 +8132,8 @@ struct net_device *netdev_upper_get_next_dev_rcu(struct net_device *dev,
 {
 	struct netdev_adjacent *upper;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !lockdep_rtnl_is_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held() &&
+		     !lockdep_rtnl_is_held());
 
 	upper = list_entry_rcu((*iter)->next, struct netdev_adjacent, list);
 
-- 
2.53.0

