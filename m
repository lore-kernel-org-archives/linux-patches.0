Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15219406263;
	Tue, 28 Apr 2026 10:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372956; cv=none; b=DM68Se5uxlnrhBRxHkMtvjMFko3HFnXkNADV835s1fC13vNeCXmKCMlAo1iRwCRvt6AAiLXH/VfTB0QACGdG5m2gJ7uFflu6TKyjGH64Dk1r5dLCmGh+2Z1n0zW6JdisrJ6VcnzXXjd15b7XnxY1N4QY9xyREF+RdhvmMvnYPik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372956; c=relaxed/simple;
	bh=l8QWHbBPzKwGDe11zpw//Wb5TUPZCWp0EWKeU/dRgZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzNNI0Dm26oMMRQLG1M1uhAkOLLJnMnzv/nsdFZKyeCwydH3FY0vmDK/OhxCCwZjx4F2gVRLUSTfJn7wakOuiYfWppPwLRMGd+mbXg17VbUrfWOFyCV5YMMxjjnGyAJao5DnPJVHgc7uRlOpxpPCppToRGzwI/axONzfcjICQkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4o+sEhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4o+sEhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0055C4AF0D;
	Tue, 28 Apr 2026 10:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372955;
	bh=l8QWHbBPzKwGDe11zpw//Wb5TUPZCWp0EWKeU/dRgZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4o+sEhNmapsdomH07al+HhS6Rm/SXKYtpsJlb2NW6yvZk4FeMHPY4CRULWJSoSiZ
	 n8HtjpBXsruMhTQDx+L4FbfmWweKBfo7A7iNGgWINzzadTstm4xpQhYtpPgX3L7mtu
	 Fv/i2OsvRW06ASAzIzNAUUWg77QiZd719Y64iskE2eSowT/xsGGNxGIVLKSYEUV2U6
	 kE0lj2Tw4ZF4QGrnpj5oCoX98o4M9s/O089vZvoSUoAJy5j7nklHLFY0+/Jm3yUKDV
	 1uVlFWpelQCkyqkfgFeZso/cJACFVgPG6Gg49JV5+AgNMZf9jpJomTA4H4s/ovGxSC
	 lZQTkvra9t0cg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yuvraj Singh Chauhan <ysinghcin@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-staging@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] staging: octeon: fix free_irq dev_id mismatch in cvm_oct_rx_shutdown
Date: Tue, 28 Apr 2026 06:40:55 -0400
Message-ID: <20260428104133.2858589-44-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Transfer-Encoding: 8bit

From: Yuvraj Singh Chauhan <ysinghcin@gmail.com>

[ Upstream commit 41db5b76eeb4cc11a1097384caba7cfc659f7293 ]

In cvm_oct_rx_initialize(), request_irq() is called with
&oct_rx_group[i].napi as the dev_id:

	request_irq(oct_rx_group[i].irq, cvm_oct_do_interrupt, 0, "Ethernet",
							&oct_rx_group[i].napi);

However, cvm_oct_rx_shutdown() passes cvm_oct_device (an array of
struct net_device pointers) as the dev_id to free_irq():

  free_irq(oct_rx_group[i].irq, cvm_oct_device);

Since __free_irq() matches the action to remove by comparing
dev_id pointers, the mismatched cookie means the IRQ handler is
never found, triggering a WARN and leaving the IRQ line permanently
allocated. This prevents proper driver cleanup on module removal.

Fix the mismatch by passing &oct_rx_group[i].napi as the dev_id
to free_irq(), matching what was used during request_irq().

Signed-off-by: Yuvraj Singh Chauhan <ysinghcin@gmail.com>
Link: https://patch.msgid.link/20260212171903.1417804-1-ysinghcin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to provide a comprehensive analysis.

## Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1:** Parse subject line
- Record: Subsystem `staging: octeon:`, verb `fix`, summary: "free_irq
  dev_id mismatch in cvm_oct_rx_shutdown"

**Step 1.2:** Parse commit message tags
- Record: `Signed-off-by: Yuvraj Singh Chauhan`; `Link:` to
  patch.msgid.link; `Signed-off-by: Greg Kroah-Hartman`. No Fixes:,
  Reported-by:, Reviewed-by:, or Tested-by: tags. No syzbot reporter. No
  Cc: stable.

**Step 1.3:** Analyze commit body
- Record: Bug is a mismatch between the dev_id cookie passed to
  `request_irq()` (`&oct_rx_group[i].napi`) vs. `free_irq()`
  (`cvm_oct_device`). `__free_irq()` matches the action to remove by
  comparing dev_id pointers. With the mismatch, the action is never
  found, triggering `WARN(1, "Trying to free already-free IRQ %d\n",
  irq)` and leaving the IRQ line permanently allocated.
- Failure mode: WARN splat on module remove; IRQ handler stays
  registered; driver cleanup is incomplete.

**Step 1.4:** Hidden bug fix check
- Record: This is an explicit "fix" - not hidden. The description
  clearly explains the mechanism.

### PHASE 2: DIFF ANALYSIS

**Step 2.1:** Inventory
- Record: 1 file (`drivers/staging/octeon/ethernet-rx.c`), +1/-1 = 1
  line effective change inside `cvm_oct_rx_shutdown()`. Scope
  classification: single-file surgical one-liner.

**Step 2.2:** Code flow
- Record: Before: `free_irq(oct_rx_group[i].irq, cvm_oct_device)` -
  wrong cookie. After: `free_irq(oct_rx_group[i].irq,
  &oct_rx_group[i].napi)` - matches the `request_irq()` cookie used in
  `cvm_oct_rx_initialize()` at line 481.

**Step 2.3:** Bug mechanism
- Record: Category: logic/correctness (mismatched function-pair
  parameter). Specifically, the request_irq() is called with
  `&oct_rx_group[i].napi` and `free_irq()` must pass the same pointer.
  Verified in kernel/irq/manage.c:1886 (`if (action->dev_id ==
  dev_id)`).

**Step 2.4:** Fix quality
- Record: Obviously correct - it literally makes the teardown mirror the
  setup. Zero regression risk - if the module were working with the
  "old" dev_id in free_irq (it wasn't, as shown by the WARN behavior),
  no user would depend on that behavior.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1:** Blame
- Record: The line `free_irq(oct_rx_group[i].irq, cvm_oct_device)` was
  touched by revert `422d97b8b05ed` (2020) but that was a mass revert
  restoring the driver. The actual bug was introduced earlier.

**Step 3.2:** Follow Fixes tag
- Record: No Fixes: tag present. Tracing manually: commit
  `08712f9de1013` ("staging: octeon: pass the NAPI instance reference to
  irq handler", Aug 2016) changed `request_irq()` from using
  `cvm_oct_device` to `&cvm_oct_napi` but did NOT update the matching
  `free_irq()` - introducing this mismatch. This went into v4.9. Commit
  `e971a119f713a` then extended it to multiple rx groups (also v4.9),
  still leaving `free_irq()` with `cvm_oct_device`.

**Step 3.3:** Related changes
- Record: No recent churn in this file's shutdown path. Last functional
  changes around napi/irq were in 2016. Related commit `60c85e23bed17`
  (switch to netif_napi_add_weight) did not touch free_irq.

**Step 3.4:** Author context
- Record: Yuvraj Singh Chauhan - first-time contributor to the kernel
  based on the lore thread (no Reviewed-by/Tested-by responses). Patch
  applied directly by Greg KH (staging maintainer).

**Step 3.5:** Dependencies
- Record: No dependencies. The code structure (`oct_rx_group[i].napi`)
  exists in all stable trees since v4.9. Standalone fix.

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1/4.2:** b4 dig results
- Record: Found single submission at https://lore.kernel.org/all/2026021
  2171903.1417804-1-ysinghcin@gmail.com/. Only v1, no revisions. Thread
  mbox contains only the original patch - no review replies, no NAKs, no
  stable suggestions. Applied by Greg KH without external review (common
  for trivial staging fixes).

**Step 4.3:** Bug report
- Record: No Reported-by: tag. No bug report linked. Appears to be
  discovered via code inspection.

**Step 4.4:** Related patches
- Record: Standalone patch, not part of a series.

**Step 4.5:** Stable mailing list
- Record: No prior discussion on stable@ for this specific bug found.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4:** Function impact
- Record: `cvm_oct_rx_shutdown()` is called only from `cvm_oct_remove()`
  in `drivers/staging/octeon/ethernet.c:936`, which is the
  platform_device remove callback. Trigger path: module unload or device
  unbind. Limited trigger frequency but reachable from standard module
  lifecycle.

**Step 5.5:** Similar patterns
- Record: `drivers/staging/octeon/ethernet-tx.c` uses `cvm_oct_device`
  consistently for BOTH its `request_irq()` (line 663) and `free_irq()`
  (line 672) - that pair is correctly matched. The bug is isolated to
  the rx path.

### PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1:** Buggy code in stable
- Record: Verified identical `free_irq(oct_rx_group[i].irq,
  cvm_oct_device);` in v6.1, v6.6, v6.12 at line 538. Bug exists in all
  active LTS trees. Bug introduced in v4.9 (2016).

**Step 6.2:** Backport complexity
- Record: The one-line change would apply cleanly to all stable trees
  since the surrounding code (the for-loop structure with
  `oct_rx_group[i].irq`) is stable since v4.9.

**Step 6.3:** Already in stable
- Record: No prior fix exists; the patch would be the first for this
  bug.

### PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** Criticality
- Record: `drivers/staging/octeon/` - staging driver for Cavium OCTEON
  MIPS SoCs. PERIPHERAL criticality - affects only OCTEON hardware users
  (real users exist per TODO file stating "functional and supports
  Ethernet on OCTEON+/OCTEON2/OCTEON3").

**Step 7.2:** Subsystem activity
- Record: Low activity - mostly cleanup/style commits over recent years.
  The driver is mature but still in staging.

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affected users
- Record: Driver-specific - users of Cavium OCTEON MIPS SoCs with
  `CONFIG_OCTEON_ETHERNET=m`.

**Step 8.2:** Trigger conditions
- Record: Triggered on module unload (`rmmod octeon_ethernet`) or driver
  unbind via sysfs. Not triggered during normal operation. Not
  triggerable by unprivileged users.

**Step 8.3:** Failure mode severity
- Record:
  - Immediate: WARN splat with stack trace (MEDIUM - no crash).
  - Persistent: IRQ line permanently allocated after module removal
    (MEDIUM - resource leak).
  - Potential: If module re-loaded, `request_irq()` could fail or re-
    register on the same IRQ unpredictably. More concerning, after
    module unload the IRQ handler function pointer in the irqaction
    still references unloaded module code - if an interrupt fires, it
    would be a kernel oops.
  - Overall severity: MEDIUM (resource leak + latent crash risk on
    unload+interrupt).

**Step 8.4:** Risk-benefit
- Record: Benefit: LOW-MEDIUM (narrow hardware audience, uncommon
  trigger). Risk: VERY LOW (1 line, trivially correct, mirrors well-
  understood request/free pair). Ratio: favorable for backport.

### PHASE 9: FINAL SYNTHESIS

**Step 9.1:** Evidence
- FOR: Obviously correct fix, minimal scope, bug present since v4.9 in
  all stable trees, clean application expected, mirrors existing pattern
  in ethernet-tx.c.
- AGAINST: Staging driver, narrow audience, no reviewer endorsement, no
  user bug report, WARN is typically considered medium severity.
- UNRESOLVED: Whether any real user has hit this WARN (no Reported-by).

**Step 9.2:** Stable rules checklist
1. Obviously correct and tested? YES (the patch mirrors the matching
   setup call; fix is trivially verifiable)
2. Fixes a real bug? YES (mismatch is real, `__free_irq` logic verified
   in kernel/irq/manage.c)
3. Important issue? BORDERLINE-YES (WARN + resource leak on module
   unload; latent crash potential)
4. Small and contained? YES (1 line)
5. No new features? YES
6. Applies to stable? YES

**Step 9.3:** Exception category
- Not an explicit exception category but qualifies as a "small, surgical
  bug fix" per stable rules.

**Step 9.4:** Decision
- The fix is obviously correct, one line, zero regression risk, and
  fixes a genuine kernel WARN plus IRQ leak on module unload in a driver
  with real hardware users. It applies to all active stable trees. Even
  though it's a staging driver and the trigger is module unload, stable
  routinely backports such clearly correct tiny fixes. The cost-benefit
  is clearly positive.

## Verification

- [Phase 1] Read commit 41db5b76eeb4c with `git show` - confirmed tags
  and body
- [Phase 2] Diff confirmed: one line change in `cvm_oct_rx_shutdown()`
  replacing `cvm_oct_device` with `&oct_rx_group[i].napi`
- [Phase 2] Read `drivers/staging/octeon/ethernet-rx.c` at HEAD and at
  41db5b76eeb4c to confirm before/after states
- [Phase 2] Verified `__free_irq()` semantics in
  `kernel/irq/manage.c:1858-1889` - WARN when action not found, returns
  NULL
- [Phase 2] Verified `action->dev_id = dev_id` stored at
  `kernel/irq/manage.c:2167` and `:2307`, matched at `:1886`
- [Phase 3] `git blame` on lines 530-545 - returned revert commit
  422d97b8b05ed3 (2020)
- [Phase 3] `git log --follow --diff-filter=A` traced first addition to
  80ff0fd3ab645 (v2.6.30) and revert
- [Phase 3] `git show 08712f9de1013` - confirmed this commit (v4.9, Aug
  2016) changed request_irq to `&cvm_oct_napi` but left free_irq
  unchanged (line 505 still used `cvm_oct_device`)
- [Phase 3] `git show e971a119f713a` - extended to per-group arrays in
  v4.9, still with mismatched free_irq
- [Phase 3] `git tag --contains 08712f9de1013` - showed v4.9 as first
  containing tag
- [Phase 4] `b4 dig -c 41db5b76eeb4c` - found original submission at
  patch.msgid.link
- [Phase 4] `b4 dig -c 41db5b76eeb4c -a` - only v1, no prior revisions
- [Phase 4] `b4 dig -c 41db5b76eeb4c -w` - only gregkh and staging/lkml
  mailing lists were CC'd
- [Phase 4] Thread mbox (117 lines) - only the original submission, no
  replies/reviews
- [Phase 4] lore.kernel.org direct fetch was blocked by Anubis; relied
  on mbox content instead
- [Phase 5] `git grep "cvm_oct_device\b"` showed tx.c uses it
  consistently for both request_irq and free_irq (correctly matched),
  confirming only rx.c is buggy
- [Phase 5] `git grep "cvm_oct_rx_shutdown"` - called from
  `cvm_oct_remove()` (platform_device remove callback only)
- [Phase 6] Verified bug exists in v6.1, v6.6, v6.12 with `git show
  vX.Y:drivers/staging/octeon/ethernet-rx.c | grep free_irq` - all show
  the buggy line at 538
- [Phase 7] Read `drivers/staging/octeon/TODO` - driver supports real
  hardware (OCTEON+/OCTEON2/OCTEON3 up to CN7030)
- [Phase 8] Trigger path confirmed via `cvm_oct_remove()` callchain in
  ethernet.c:936
- UNVERIFIED: Exact kernel version the bug was first introduced (v4.9
  per `git tag --contains`, but I did not check if v4.9.y was the oldest
  still-supported LTS)
- UNVERIFIED: Whether any user has actually reported hitting the WARN in
  production - no Reported-by in commit, no bug tracker link

The fix is a trivial, obviously-correct one-line change that corrects a
genuine bug present since v4.9, in a driver with real users, with zero
regression risk. It meets all stable kernel criteria.

**YES**

 drivers/staging/octeon/ethernet-rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 965330eec80a8..d0b43d50b83ce 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -535,7 +535,7 @@ void cvm_oct_rx_shutdown(void)
 			cvmx_write_csr(CVMX_POW_WQ_INT_THRX(i), 0);
 
 		/* Free the interrupt handler */
-		free_irq(oct_rx_group[i].irq, cvm_oct_device);
+		free_irq(oct_rx_group[i].irq, &oct_rx_group[i].napi);
 
 		netif_napi_del(&oct_rx_group[i].napi);
 	}
-- 
2.53.0

