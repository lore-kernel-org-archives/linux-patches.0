Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86103EF0C2;
	Mon, 20 Apr 2026 13:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691523; cv=none; b=L5Ghpm0RZwXHjdSoxSCwS6mebvqTqCSX2OaQAuXKzv29PZ7PK7bOahwMKb8GiFKc06p+zNOeBtzevXu0WcqZedIjfzPWPD66p9GpAP3p/5Eq6/WJbPR9fsyktsK2ntxp2g0GL7C/g4dGpr04D3zZmpdw+gfDbKL+DbpvL88ZMhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691523; c=relaxed/simple;
	bh=y71kcRYQpao/17pO/wcWPCws9upPBl1PHmX/t/RFhHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ewcGFGQH0O49w0T7B+fVwQg10eUhoDqJYK42CcW7b0WRoo2xW5Q83CYtK76np+grMFDSMxzj34d8l6zKQIkirmo9ty93CMbERGqEzIJBqxLOm2OnmrDB5ywErQrCxno2YKiYC71vlVmnk0JAUsSnK3L57TY9xU847F3kVMx4wwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZG4eQ2ZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZG4eQ2ZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2C4C19425;
	Mon, 20 Apr 2026 13:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691523;
	bh=y71kcRYQpao/17pO/wcWPCws9upPBl1PHmX/t/RFhHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZG4eQ2ZFrYCB+xyUSv+QOrQjX5A34SgK0qtnr+5mwXUnVxv0tlLelpy/cIIvw1Ko/
	 XqB4F/3oXX3VqKFKMYhEbzNllZUGvez+Lqa4eKu6+WbY9YIIOsbB3RD7kiPVJrJOox
	 OBOLoZnvmoLKEoXIZ4LXtGWwPz+dUow4T6OisZeMbEb7bndx2KS2z5uSM6Z8h2cYDu
	 L1V9eM61GdTllroPMG0yM549FXxSVdCDDu3en8UEYQMrRsoMy8FSipTtZpTUGGa0cR
	 k6PwYWLt4glu6wCz+PImIEWRL006wgdjfewoD1JG8egIhzKdT1tQ3BIG5Tzs3ttbMH
	 oe+hCzbtSxLrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aaron Tomlin <atomlin@atomlin.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ronak.doshi@broadcom.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] vmxnet3: Suppress page allocation warning for massive Rx Data ring
Date: Mon, 20 Apr 2026 09:17:53 -0400
Message-ID: <20260420132314.1023554-79-sashal@kernel.org>
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

From: Aaron Tomlin <atomlin@atomlin.com>

[ Upstream commit c31770c49348fb019167fa95119f330597c99193 ]

The vmxnet3 driver supports an Rx Data ring (rx-mini) to optimise the
processing of small packets. The size of this ring's DMA-coherent memory
allocation is determined by the product of the primary Rx ring size and
the data ring descriptor size:

    sz = rq->rx_ring[0].size * rq->data_ring.desc_size;

When a user configures the maximum supported parameters via ethtool
(rx_ring[0].size = 4096, data_ring.desc_size = 2048), the required
contiguous memory allocation reaches 8 MB (8,388,608 bytes).

In environments lacking Contiguous Memory Allocator (CMA),
dma_alloc_coherent() falls back to the standard zone buddy allocator. An
8 MB allocation translates to a page order of 11, which strictly exceeds
the default MAX_PAGE_ORDER (10) on most architectures.

Consequently, __alloc_pages_noprof() catches the oversize request and
triggers a loud kernel warning stack trace:

    WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp)

This warning is unnecessary and alarming to system administrators because
the vmxnet3 driver already handles this allocation failure gracefully.
If dma_alloc_coherent() returns NULL, the driver safely disables the
Rx Data ring (adapter->rxdataring_enabled = false) and falls back to
standard, streaming DMA packet processing.

To resolve this, append the __GFP_NOWARN flag to the dma_alloc_coherent()
gfp_mask. This instructs the page allocator to silently fail the
allocation if it exceeds order limits or memory is too fragmented,
preventing the spurious warning stack trace.

Furthermore, enhance the subsequent netdev_err() fallback message to
include the requested allocation size. This provides critical debugging
context to the administrator (e.g., revealing that an 8 MB allocation
was attempted and failed) without making hardcoded assumptions about
the state of the system's configurations.

Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Link: https://patch.msgid.link/20260226163121.4045808-1-atomlin@atomlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the evidence needed for a comprehensive analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: [vmxnet3] [Suppress] Suppress page allocation warning for
massive Rx Data ring allocation that exceeds MAX_PAGE_ORDER. The verb
"Suppress" indicates removing a spurious warning, not adding a new
feature.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Reviewed-by:** Jijie Shao <shaojijie@huawei.com> - a networking
  contributor (hns3 driver)
- **Signed-off-by:** Aaron Tomlin <atomlin@atomlin.com> - the author, a
  kernel contributor (modules, tracing subsystems)
- **Link:**
  https://patch.msgid.link/20260226163121.4045808-1-atomlin@atomlin.com
- **Signed-off-by:** Jakub Kicinski <kuba@kernel.org> - the net tree
  maintainer, committed it
- No Fixes: tag (expected for candidates)
- No Reported-by: tag
- No Cc: stable tag

Record: Committed by the net maintainer (Jakub Kicinski). Reviewed by a
networking contributor.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit explains in detail:
- When max ethtool parameters are set (rx_ring[0].size=4096,
  data_ring.desc_size=2048), the DMA allocation is 8 MB
- 8 MB requires page order 11, which exceeds MAX_PAGE_ORDER (10)
- This triggers `WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp)` in
  page_alloc.c
- The driver already gracefully handles the failure (disables data ring
  and falls back)
- The warning is "unnecessary and alarming to system administrators"

Record: Bug is a spurious WARN_ON_ONCE kernel stack trace when VMware
users configure max ring parameters. Symptom is an alarming stack trace
in dmesg. Driver handles the failure fine. Root cause: missing
`__GFP_NOWARN` flag.

### Step 1.4: DETECT HIDDEN BUG FIXES
This is a real bug fix disguised with "suppress" language. The
`WARN_ON_ONCE_GFP` macro at line 5226 of `mm/page_alloc.c` was
specifically designed to be suppressed by `__GFP_NOWARN`. The vmxnet3
driver was missing this flag, causing the allocator to emit a warning
the driver was designed to tolerate. This is a legitimate fix for an
incorrect warning.

Record: Yes, this is a real bug fix. The warning is spurious because the
driver handles the failure gracefully.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
- **File:** `drivers/net/vmxnet3/vmxnet3_drv.c`
- **Lines changed:** 2 lines modified (net change: 0 added, 0 removed -
  just modifications)
- **Function modified:** `vmxnet3_rq_create()`
- **Scope:** Single-file, surgical fix

Record: 1 file, 2 lines changed, in `vmxnet3_rq_create()`. Extremely
small scope.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
- **Line 2271:** `GFP_KERNEL` → `GFP_KERNEL | __GFP_NOWARN` for the data
  ring DMA allocation
- **Line 2274:** `"rx data ring will be disabled\n"` → `"failed to
  allocate %zu bytes, rx data ring will be disabled\n", sz` to include
  the allocation size in the error message

Before: allocation failure triggers WARN_ON_ONCE + generic log message.
After: allocation failure is silent (no WARN) + informative log message
with size.

Record: Two hunks: (1) Add __GFP_NOWARN to suppress spurious warning;
(2) Improve error message with allocation size.

### Step 2.3: IDENTIFY THE BUG MECHANISM
Category: **Logic/correctness fix** - The allocator's `WARN_ON_ONCE_GFP`
macro at `mm/page_alloc.c:5226` is designed to suppress warnings when
`__GFP_NOWARN` is passed. The vmxnet3 driver was missing this flag for
an allocation that is expected to fail on systems without CMA, producing
a scary but meaningless kernel warning.

Record: Missing __GFP_NOWARN flag on an allocation expected to fail. The
WARN_ON_ONCE_GFP macro specifically checks for this flag (verified in
mm/internal.h:92-96).

### Step 2.4: ASSESS THE FIX QUALITY
- Obviously correct: `__GFP_NOWARN` is the standard kernel mechanism for
  this exact purpose
- Minimal: 2 lines changed
- Regression risk: Zero - `__GFP_NOWARN` only affects the warning, not
  allocation behavior
- Pattern precedent: Same fix applied to r8152 (5cc33f139e11b), gtp
  (bd5cd35b782ab), netdevsim (83cf4213bafc4)

Record: Fix is trivially correct, minimal, and follows well-established
kernel patterns. No regression risk.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
The affected code was introduced in commit `50a5ce3e7116a7` by
Shrikrishna Khare on 2016-06-16 ("vmxnet3: add receive data ring
support"). This was first included in v4.8-rc1, meaning the buggy code
has been present since kernel 4.8 (~2016).

Record: Buggy code from commit 50a5ce3e7116a7 (v4.8-rc1, June 2016).
Present in ALL active stable trees.

### Step 3.2: FOLLOW THE FIXES TAG
No Fixes: tag present (expected).

### Step 3.3: CHECK FILE HISTORY
84 commits to vmxnet3_drv.c since the buggy code was introduced. The
file is actively maintained. A closely related commit is `ffbe335b8d471`
("vmxnet3: disable rx data ring on dma allocation failure") which fixed
a BUG crash when the same allocation fails. This shows the allocation
failure path is a known problem area.

Record: Active file. The data ring allocation failure path has had real
bugs before (ffbe335b8d471 fixed a BUG/crash).

### Step 3.4: CHECK AUTHOR
Aaron Tomlin is a kernel contributor (primarily in modules, tracing
subsystems). Jakub Kicinski (net maintainer) committed this.

Record: Not a vmxnet3 maintainer, but committed by the net tree
maintainer.

### Step 3.5: DEPENDENCIES
No dependencies. This is a standalone 2-line change that only adds a GFP
flag and improves a log message. The code context exists in all stable
trees since v4.8.

Record: Fully standalone, no prerequisites.

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.5
Lore.kernel.org was unavailable (Anubis protection). However:
- The Link: tag confirms submission via netdev mailing list
- Jakub Kicinski (net maintainer) accepted and committed it
- Jijie Shao provided a Reviewed-by

Record: Unable to fetch lore discussion due to anti-bot protection.
UNVERIFIED: detailed mailing list discussion content. However, the
commit was accepted by the net maintainer.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: FUNCTION ANALYSIS
`vmxnet3_rq_create()` is called from:
1. `vmxnet3_rq_create_all()` - called during adapter initialization
2. Directly at line 3472 during queue reset/resize
3. `vmxnet3_rq_create_all()` also called at line 3655 during MTU change

The affected allocation is on the normal path (not error-only),
triggered during device initialization and MTU changes. VMware vmxnet3
is ubiquitous in VMware virtual machines.

Record: The function is called during normal device initialization and
reconfiguration. Very common code path for VMware users.

### Step 5.5: SIMILAR PATTERNS
The vmxnet3 driver already uses `__GFP_NOWARN` in
`vmxnet3_pp_get_buff()` at line 1425 for page pool allocations. Multiple
other network drivers have applied the same fix pattern (r8152, gtp,
netdevsim).

Record: Pattern is already used elsewhere in vmxnet3 itself, and widely
across network drivers.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: BUGGY CODE IN STABLE
The buggy code (commit 50a5ce3e7116a7) has been present since v4.8. It
exists in ALL active stable trees (5.10, 5.15, 6.1, 6.6, 6.12, etc.).

Record: Code exists in all active stable trees.

### Step 6.2: BACKPORT COMPLICATIONS
The code at line 2271 in the current tree is still `GFP_KERNEL` (no
__GFP_NOWARN), and the context looks clean. The `%zu` format specifier
for size_t is standard. Should apply cleanly to all stable trees.

Record: Expected clean apply.

### Step 6.3: RELATED FIXES IN STABLE
No prior fix for this specific warning exists.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
- **Subsystem:** drivers/net/vmxnet3 - VMware virtual network driver
- **Criticality:** IMPORTANT - vmxnet3 is the standard NIC in VMware
  environments, which powers a vast number of enterprise servers

### Step 7.2: ACTIVITY
The subsystem is actively developed (v9 protocol support recently
added). 84 commits since the data ring feature.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
All VMware users running vmxnet3 who configure maximum ethtool ring
parameters. VMware is extremely widespread in enterprise.

### Step 8.2: TRIGGER CONDITIONS
Triggered when: (a) user sets ethtool `rx_ring[0].size=4096` and
`data_ring.desc_size=2048` (both maximum values), and (b) system lacks
CMA for large contiguous allocations. This is a realistic configuration
for performance-tuned VMs.

### Step 8.3: FAILURE MODE SEVERITY
The `WARN_ON_ONCE` produces a full kernel stack trace in dmesg that
looks like a kernel bug. While not a crash, it:
- Alarms system administrators
- Can trigger automated monitoring/alerting systems
- May generate unnecessary bug reports
- Severity: MEDIUM (no functional impact, but user-visible alarm)

### Step 8.4: RISK-BENEFIT RATIO
- **Benefit:** Eliminates spurious kernel warning in VMware
  environments, improves log message quality
- **Risk:** Essentially zero - `__GFP_NOWARN` only suppresses the
  warning, doesn't change allocation behavior
- **Size:** 2 lines, obviously correct
- **Ratio:** HIGH benefit / ZERO risk

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILATION

**FOR backporting:**
- Fixes a real user-visible issue (spurious WARN_ON_ONCE stack trace)
- Extremely small and obviously correct (2 lines)
- Zero regression risk
- Well-established pattern (r8152, gtp, netdevsim all did the same)
- vmxnet3 already uses `__GFP_NOWARN` elsewhere in the driver
- Buggy code has been present since v4.8, affects all stable trees
- VMware vmxnet3 is widely used in enterprise
- Accepted by net maintainer Jakub Kicinski
- Improved error message provides better diagnostic information
- Prior crash (ffbe335b8d471) shows this allocation failure path is a
  real concern

**AGAINST backporting:**
- Not a crash/security/corruption fix (it's a warning suppression)
- No Fixes: tag or explicit stable nomination
- WARN_ON_ONCE only fires once per boot (limited repeated impact)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** - trivial `__GFP_NOWARN`
   addition, standard pattern
2. Fixes a real bug? **YES** - spurious kernel warning that alarms
   admins
3. Important issue? **MEDIUM** - not a crash, but affects many VMware
   users
4. Small and contained? **YES** - 2 lines in 1 file
5. No new features? **YES** - no new features
6. Can apply to stable? **YES** - clean apply expected

### Step 9.3: EXCEPTION CATEGORIES
Not a standard exception category, but analogous to prior stable-
backported `__GFP_NOWARN` fixes.

### Step 9.4: DECISION
The fix is tiny, obviously correct, zero-risk, follows well-established
patterns, and eliminates a spurious kernel warning that can alarm VMware
administrators. While not a crash fix, the WARN_ON_ONCE stack trace is
user-visible and can trigger automated alerting systems. The bar is very
low for risk vs. benefit here.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Jijie Shao, committed by Jakub
  Kicinski (net maintainer)
- [Phase 2] Diff analysis: 2 lines changed in vmxnet3_rq_create(): adds
  __GFP_NOWARN, improves log message
- [Phase 2] Verified WARN_ON_ONCE_GFP at mm/internal.h:92-96
  specifically checks __GFP_NOWARN flag
- [Phase 2] Verified WARN_ON_ONCE_GFP at mm/page_alloc.c:5226 is
  triggered when order > MAX_PAGE_ORDER
- [Phase 3] git blame: buggy code introduced in commit 50a5ce3e7116a7
  (v4.8-rc1, 2016), present in all stable trees
- [Phase 3] git log: 84 commits to file since buggy code introduced;
  active file
- [Phase 3] Related fix ffbe335b8d471 confirms the data ring allocation
  failure path has had real bugs
- [Phase 4] UNVERIFIED: Full mailing list discussion (lore unavailable
  due to anti-bot)
- [Phase 5] Traced callers: vmxnet3_rq_create() called from
  vmxnet3_rq_create_all() during init, MTU change, and queue reset
- [Phase 5] Confirmed vmxnet3 already uses __GFP_NOWARN at line 1425
  (vmxnet3_pp_get_buff)
- [Phase 5] Similar pattern in r8152 (5cc33f139e11b), gtp
  (bd5cd35b782ab), netdevsim (83cf4213bafc4)
- [Phase 6] Code exists in all active stable trees (since v4.8)
- [Phase 6] Current tree still has GFP_KERNEL at line 2271 - clean apply
  expected
- [Phase 8] Failure mode: spurious WARN_ON_ONCE stack trace, severity
  MEDIUM

**YES**

 drivers/net/vmxnet3/vmxnet3_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 0572f6a9bdb62..40522afc05320 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2268,10 +2268,10 @@ vmxnet3_rq_create(struct vmxnet3_rx_queue *rq, struct vmxnet3_adapter *adapter)
 		rq->data_ring.base =
 			dma_alloc_coherent(&adapter->pdev->dev, sz,
 					   &rq->data_ring.basePA,
-					   GFP_KERNEL);
+					   GFP_KERNEL | __GFP_NOWARN);
 		if (!rq->data_ring.base) {
 			netdev_err(adapter->netdev,
-				   "rx data ring will be disabled\n");
+				   "failed to allocate %zu bytes, rx data ring will be disabled\n", sz);
 			adapter->rxdataring_enabled = false;
 		}
 	} else {
-- 
2.53.0

