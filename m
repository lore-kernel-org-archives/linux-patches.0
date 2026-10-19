Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBD0491B2A;
	Mon, 19 Oct 2026 14:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418474; cv=none; b=UV/FPvEbj+XSyLpKAqXEI/3xBJBUYxmSrmKv7M10l0JBQT5zN1PKP6Cm9MuY1Wu6vuPVrUrDI71LtxL25y4AXr3fZAQ9d4caadBMHqAqh5Nu0BRDLx7McYUklsDXeGrjwsMaZ5wIL2S2b2ftROpXRYPXggb1xM/Nf45KUA9+fMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418474; c=relaxed/simple;
	bh=+IwJ1jIERnHKcn8mgK2ikzWrNJ05yPaQQ0V+6v6vJkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XDwHXinD0Dzyd6e/vmZBo/LFurBl5646sR1XxTKmt0JSnJgJoZ6nUXSItqmG7Y3fkL5eDOgnaSCz8wJlX+kvg4HbYUhbFs8ONlq+UBYvG657RhBYrQP4NWuV5AttWaailzL+cZevOMus9UiuJfJp9MmiEwpfTycVMo9VIXKTvpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dq8GVnHp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dq8GVnHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C5B1F000CD;
	Mon, 19 Oct 2026 14:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418471;
	bh=V+BpAgOcs4dx6jaCqlRDYOWuOtdLY5wLjAviSgNO1q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dq8GVnHp1W7Tn1lh9mr3WgLiR6ZzwKt8qY48//eUFDb/s23e4wV5fEJCojyAz2O+D
	 prR2JHw+1UM+zlYJk90a8uFD7jVjZjSE5kSI88qCoDT+klaBHkQdWnrrVOXzl6GcNO
	 3DfgHilfTyA3z8ZmfutqHFfhmIEl/KU4BSPLr67dtex0Wa1pu483N+LF8RC8aakDmL
	 mgtr5a9uYKruB7zENmMO7UYSRo4f3LHbA1WZLm7tn8o8O7eUg43PbpoHRYOfnQfJTe
	 NFpJ89lTAzTthOjMDc6CT1kce7sl/ZVlA6TlIMvWcXRCQkU4hyTUfdccD9kQAs9HiR
	 61KQy6woyzOww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] nvmem: brcm_nvram: reject empty NVRAM partition
Date: Mon, 19 Oct 2026 09:49:23 -0400
Message-ID: <20261019135441.1420968-272-sashal@kernel.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit fde46579cf8872138b296349c2bd8a3cd3f132e2 ]

If the partition is completely erased (all padding bytes), the trimming
loop reduces data_len to 0. devm_kzalloc(dev, 0, GFP_KERNEL) returns
ZERO_SIZE_PTR ((void *)16), which is non-NULL and bypasses the NULL
check. The subsequent cast of priv->data to struct brcm_nvram_header *
and dereference of header->magic causes a page fault on address 0x10.

Reject data_len smaller than the header before allocating.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260729094647.111468-13-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **6.6.157** (`pending-6.6`). The empty-NVRAM oops path is
present here and the 5-line guard is not. This is a real boot-time page
fault on Broadcom Northstar boards, and the patch applies cleanly.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[nvmem/brcm_nvram] [reject] reject empty NVRAM partition**
- Subsystem: `nvmem: brcm_nvram`
- Verb: **reject** — defensive check, not a feature
- Intent: refuse to probe when the cached NVRAM image is smaller than
  the on-flash header

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by / Tested-by / Reviewed-by / Acked-by:** none
- **Assisted-by:** `opencode:big-pickle`
- **Signed-off-by:** Rosen Penev (author); Srinivas Kandagatla (nvmem
  maintainer); Greg Kroah-Hartman (char-misc)
- **Link:**
  `https://patch.msgid.link/20260729094647.111468-13-srini@kernel.org` —
  this is patch 12/14 of Srinivas’s later char-misc pull, not a
  dependency series
- **Cc: stable:** none (not a negative signal)
- Original submission was a standalone `[PATCH]`
  (`20260703222830.408764-1-rosenp@gmail.com`), applied as mainline
  `5f75913830bc`

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** erased NVRAM (all padding bytes) makes the trim loop set
  `data_len = 0`
- **Symptom:** `devm_kzalloc(..., 0)` returns `ZERO_SIZE_PTR` (`(void
  *)16`), the `if (!priv->data)` check passes, then `brcm_nvram_parse()`
  dereferences `header->magic` and **page-faults at address 0x10**
- **Root cause:** zero-size kmalloc is not NULL; the code treats it as a
  valid buffer
- **Fix:** return `-EINVAL` if `data_len < sizeof(struct
  brcm_nvram_header)` before allocating
- **Versions:** none named; the buggy trim-and-cache path was added by
  `nvmem: brcm_nvram: store a copy of NVRAM content`

Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not hidden.** This is an explicit crash fix. The wording
matches the code.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/nvmem/brcm_nvram.c` — **+5 / −0**
- **Function:** `brcm_nvram_copy_data()`
- **Scope:** single-file surgical error-path check

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** trim padding → `WARN` if huge → `devm_kzalloc(data_len)` →
  copy → parse
- **After:** same, but if `data_len` is smaller than the 20-byte header,
  log and return `-EINVAL`
- **Path:** probe/init only (`subsys_initcall_sync` → `brcm_nvram_probe`
  → `brcm_nvram_copy_data`)
- Probe already returns `copy_data` errors, so this fails the driver
  instead of oopsing

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** memory safety / NULL-check bypass (`ZERO_SIZE_PTR`)
  leading to a **NULL-ish deref / page fault**
- **Mechanism:** `devm_kmalloc()` returns `ZERO_SIZE_PTR` for size 0
  (verified in this tree). That pointer is non-NULL, so the allocation
  “succeeded.” `brcm_nvram_parse()` then does `memcmp(header->magic,
  ...)` at address `0x10`
- Also covers `1 <= data_len < sizeof(header)`, which would be a short
  buffer under the same parse

Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Obviously correct:** you cannot parse a header that is not there
- **Minimal:** 5 lines, no API/locking/structure change
- **Regression risk:** very low. Worst case: probe fails with `-EINVAL`
  and NVRAM cells are missing (MAC fallback), instead of a boot oops
- **Red flags:** none. The later sibling “malformed flash OOB” patch is
  independent

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Trim loop, `devm_kzalloc(priv->data_len)`, and parse were introduced
  by **`09283d60bc332`** (`nvmem: brcm_nvram: store a copy of NVRAM
  content`, upstream `1e37bf84afacd`)
- That landed in **this tree in v6.6.9** (`git describe --contains` →
  `v6.6.9~19`)
- Original v6.6 did **not** have this path (`git merge-base --is-
  ancestor 09283d60bc332 v6.6` failed)

Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** The buggy commit is nonetheless identified:
`09283d60bc332` / `1e37bf84afacd`, present in this tree. This is a
**stable-to-stable follow-up** to a 6.6.9 backport.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Last change to this file in *this* tree is the copy-data backport
  itself
- Rosen also sent a sibling patch the same day: `nvmem: brcm_nvram: fix
  out-of-bounds access on malformed flash data` (pull 13/14). That
  tightens `header->len` vs `data_len`. **Not a prerequisite** for this
  empty-partition check
- Original author series was **v1 standalone `[PATCH]`**, later batched
  as 12/14 in Srinivas→Greg pull

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Rosen Penev has no prior `drivers/nvmem/` commits in this tree
- Srinivas Kandagatla is the nvmem maintainer and applied it (`Applied,
  thanks!` / commit `5f75913830bc`)
- Original driver author Rafał Miłecki was CCed; no NAK in the thread

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Depends only on `brcm_nvram_copy_data()` + `struct brcm_nvram_header`,
  both in this tree
- **Can apply standalone.** Insertion context matches exactly

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- **b4 dig -c 5f75913830bc:**
  https://patch.msgid.link/20260703222830.408764-1-rosenp@gmail.com
- **b4 dig -a:** only **v1**; applied version is that v1
- Thread is 2 messages: patch + maintainer apply. **No NAK, no requested
  respin**
- lore.kernel.org WebFetch returned 403; thread recovered via b4 mbox +
  openwall/lkml mirrors

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (b4 dig -w):
- To: linux-kernel
- Cc: Srinivas Kandagatla (maintainer), rafal@milecki.pl (driver author)
- Applied by the subsystem maintainer; no extra Reviewed-by

Step 4.3: SEARCH FOR THE BUG REPORT
Record: **No Reported-by, no syzbot, no bugzilla.** The crash mechanism
is spelled out (fault at `0x10`) and matches the code. Trigger is an
erased NVRAM image (all `0xFF`/`0x00`), which is a real flash state.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record:
- Standalone v1 from Rosen
- Later 12/14 is only the maintainer pull batch
- Sibling OOB-length fix is related but **not required** for this patch
  to be correct

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No useful stable-list hit for this subject. Absence of Cc:
stable is expected for this review.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `brcm_nvram_copy_data()` (modified). Crash consumer:
`brcm_nvram_parse()`. Caller: `brcm_nvram_probe()`.

Step 5.2: TRACE CALLERS
Record:
- `brcm_nvram_copy_data` ← only `brcm_nvram_probe`
- `brcm_nvram_probe` ← platform driver, registered from
  `brcm_nvram_init` via **`subsys_initcall_sync`**
- Reachable at **boot** on DT nodes `compatible = "brcm,nvram"`

Step 5.3: TRACE CALLEES
Record: `devm_platform_get_and_ioremap_resource`, `readb` trim loop,
`devm_kzalloc`, `memcpy_fromio`, `bcm47xx_nvram_init_from_iomem` (return
value already ignored). `bcm47xx_nvram_is_valid()` reads **iomem**, not
`priv->data`, so it does not crash first; copy_data still returns 0 and
parse faults.

Step 5.4: FOLLOW THE CALL CHAIN
Record:
Boot → `brcm_nvram_init` → probe → copy_data (data_len=0, ZERO_SIZE_PTR)
→ parse → `memcmp(header->magic)` at `0x10` → **oops**
- Userspace syscall not required
- **Yes, reachable** on BCM5301X with an empty/erased NVRAM mapping

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: `devm_kmalloc()` in this tree explicitly `return ZERO_SIZE_PTR`
when `!size`. Same class of bug as other “kmalloc(0) is not NULL”
crashes. Sibling OOB check in parse is a related malformed-flash bug,
not a duplicate of this one.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** `drivers/nvmem/brcm_nvram.c` lines 78–89 (trim +
`devm_kzalloc`) and 177–187 (header deref). Introduced in **v6.6.9**.
Mainline fix `5f75913830bc` is **not** an ancestor of HEAD. Source has
no “NVRAM data too small” check.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply.** Context around the `WARN`/`devm_kzalloc` site
matches. `MAC_ADDR_STR_LEN` vs `3 * ETH_ALEN - 1` is a different
function and is not touched.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No “empty NVRAM” / “data too small” commit in this tree. No
alternate fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **nvmem / Broadcom NVRAM driver.** Criticality: **PERIPHERAL**
(ARCH_BCM_5301X routers), but real shipping hardware. 16 DT files in
this tree already have `compatible = "brcm,nvram"` (Luxul, Linksys,
D-Link, Asus, etc.). `CONFIG_NVMEM_BRCM_NVRAM` depends on
`ARCH_BCM_5301X || COMPILE_TEST`.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: This driver is mature; last local change is the 6.6.9 cache-copy
backport. The bug is in that long-lived path, not in brand-new mainline-
only code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific / platform-specific** — BCM5301X boards with a
`brcm,nvram` node (OpenWrt and similar). Not universal.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: NVRAM window is all padding (erased flash `0xFF`, or all
  zeros)
- Happens at **device probe / boot**, not a rare runtime race
- Not an unprivileged syscall exploit; it is a **boot oops** on those
  machines
- Realistic after wipe, bad flash, or empty factory partition

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: **Kernel oops / page fault during probe.** Severity: **HIGH**
(boot crash on affected boards). Not a silent corruption bug, but it
takes the kernel down instead of failing probe.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** high for BCM5301X users with empty/wiped NVRAM; converts
  oops → clean `-EINVAL`
- **Risk:** very low (5 lines, error path only, no locking)
- **Ratio:** strongly favors backport. This is also a fix for a bug
  **introduced by an earlier stable backport** (6.6.9)

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR:**
- Concrete oops: dereference of `ZERO_SIZE_PTR` at `0x10`
- Buggy path exists in this 6.6.157 tree (since 6.6.9)
- 5-line, obviously correct guard; probe already handles `-EINVAL`
- Maintainer-applied; no NAK
- Clean apply; no prerequisites
- Follow-up to a stable backport that added the trim-and-allocate logic

**AGAINST:**
- No public Reported-by / Tested-by
- Driver is platform-specific, not core
- Empty NVRAM is not every-boot on healthy devices

**UNRESOLVED:**
- Direct lore.kernel.org HTTP fetch was 403 (thread recovered via b4)
- No independent user report found beyond the author’s analysis

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — mechanism matches
   `devm_kmalloc(0)` and parse; maintainer applied v1
2. Fixes a real bug that affects users? **PASS** — oops on erased NVRAM;
   DT boards in this tree use the driver
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   boot-time page fault
4. Small and contained? **PASS** — +5 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — context identical

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary crash
fix.

Step 9.4: MAKE YOUR DECISION
Backport. The local tree has the 6.6.9 cache-copy code that created this
`kmalloc(0)` oops; the guard is tiny and fails probe instead of taking a
fault.

===============================================================
What this solves for stable users
===============================================================

On this 6.6.y tree, `brcm_nvram_copy_data()` trims trailing padding and
allocates `data_len` bytes. If the mapped NVRAM is fully erased,
`data_len` becomes 0. `devm_kzalloc(dev, 0)` returns `(void *)16`, parse
treats that as a header, and the kernel oopses at boot. The patch
rejects anything smaller than `struct brcm_nvram_header` (20 bytes) and
returns `-EINVAL`, which `brcm_nvram_probe()` already handles.

It meets the stable rules: real crash, tiny, no API change, applies
cleanly, and it closes a hole opened by a prior 6.6.9 stable backport.

Risk vs benefit: very low risk, high benefit on BCM5301X when NVRAM is
empty. The sibling malformed-length OOB patch is useful later but is not
required for this one.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed tags: no Fixes/Reported-by; SOBs Rosen/Srinivas/Greg;
  Link is Srinivas 12/14 pull of a standalone v1
- [Phase 2] Diff: +5 lines in `brcm_nvram_copy_data()` before
  `devm_kzalloc`
- [Phase 2] `include/linux/device.h`: `devm_kzalloc` → `devm_kmalloc`;
  `drivers/base/devres.c:833-834`: size 0 returns `ZERO_SIZE_PTR`;
  `include/linux/slab.h:175`: `((void *)16)`
- [Phase 2] `brcm_nvram_parse()` at lines 179–184 dereferences
  `header->magic` — matches “page fault on address 0x10”
- [Phase 3] `git blame`: trim/alloc from `09283d60bc332`; `git describe
  --contains` → `v6.6.9~19`; not in `v6.6`
- [Phase 3] `git merge-base --is-ancestor 5f75913830bc HEAD` → not
  ancestor (fix absent)
- [Phase 3] `git log --grep='empty NVRAM'` on `drivers/nvmem/` → empty
- [Phase 4] `b4 dig -c 5f75913830bc`: original URL
  `20260703222830.408764-1-rosenp@gmail.com`
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: linux-kernel, Srinivas, Rafał; mbox: patch +
  “Applied, thanks!”; no NAK
- [Phase 4] lore WebFetch 403; used b4 + openwall/lkml instead
- [Phase 5] Callers: only `brcm_nvram_probe`; `subsys_initcall_sync`
- [Phase 5] `bcm47xx_nvram_init_from_iomem` reads iomem magic; return
  ignored so parse still runs
- [Phase 6] `git describe HEAD` → `p-6.6-3-g04810563abb71`; `make
  kernelversion` → **6.6.157**
- [Phase 6] Patch context around WARN/kzalloc matches; clean apply
  expected
- [Phase 7] 16 `arch/arm/boot/dts/broadcom/*.dts*` files with
  `brcm,nvram`; Kconfig `NVMEM_BRCM_NVRAM` depends on `ARCH_BCM_5301X`
- [Phase 8] Failure mode: probe-time oops, severity HIGH
- UNVERIFIED: no independent end-user crash log; mechanism verified from
  code anyway

**YES**

 drivers/nvmem/brcm_nvram.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvmem/brcm_nvram.c b/drivers/nvmem/brcm_nvram.c
index b4cf245fb2467..4b3781a70222a 100644
--- a/drivers/nvmem/brcm_nvram.c
+++ b/drivers/nvmem/brcm_nvram.c
@@ -84,6 +84,11 @@ static int brcm_nvram_copy_data(struct brcm_nvram *priv, struct platform_device
 	}
 	WARN(priv->data_len > SZ_128K, "Unexpected (big) NVRAM size: %zu B\n", priv->data_len);
 
+	if (priv->data_len < sizeof(struct brcm_nvram_header)) {
+		dev_err(priv->dev, "NVRAM data too small (%zu)\n", priv->data_len);
+		return -EINVAL;
+	}
+
 	priv->data = devm_kzalloc(priv->dev, priv->data_len, GFP_KERNEL);
 	if (!priv->data)
 		return -ENOMEM;
-- 
2.53.0

