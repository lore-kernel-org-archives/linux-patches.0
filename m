Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CD95D8C8E;
	Mon, 19 Oct 2026 14:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418518; cv=none; b=sKf1vDdSZMQMexx+XOcgJ3IgPWifkKAvYmsdmc6GwY8qH4WaIO44IU37akSfTZMIqLA3X7Ak3nLZTTI5W/zQxzAn+qUcCTOMIxr9DvRe2L4GWdQYqJbCmSYvfnnhBKzVQz9gNngwZcNnzaa8hYQ0RS9Ch8//dJonxMciFEFZh4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418518; c=relaxed/simple;
	bh=XZ1DQhAoE9PMJ0oJ1VLxRMseKp+0fnZUW8nGW8XSnWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rWhcx4qwiz55+j+N+m/5t/ywmMKS/PtIWSCH50Kv6i+DvIqZxs3OspFo72Gw/jixxYchWq7JUFBvCWFI731nAPQW347F09bMRGLzqxXGV+laqB5lE1jpD1tyFjo4RL2yj+NZ7MAmnlJ+JTZz4EEIn31Z+wI8HNcJIrwcGElTz3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLDLbiOZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLDLbiOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31631F000C9;
	Mon, 19 Oct 2026 14:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418516;
	bh=Jk6QeDP3er7oJrzie6h/aR641WmY6fsxB8wBz8frDWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLDLbiOZTnR66taWzBOMVQeAV9EhS6xttqVYpAkN3aMtdzOBt3dnKVbuI4Pw8mg8E
	 Qa/G18GF8jyN1CF9FpZFLI+OTxk/quQ29CBVRyz6p7OHsAgR79WPfov2MrDOcmkfJw
	 sMQrZhNe6Z/yDBW4/EbYmJ1n14q5zwKBj+fjs68OK7F97da06usYfvdHi/0wm3w6Gj
	 4d6vHzx7CJTwgoBUHGaPjc1nu/WYVZZtgkiLnyRJFhFG9AiqXoWPAYIpxdSJmqSj1p
	 Ps5gBQUUAwX48+oKk84yzmpk5pGmYbP+AgwLg0h1bVqcieZVhwwi+jpuw2q76J0/1C
	 Nw98OgSw8gt9Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: William Theesfeld <william@theesfeld.net>,
	Brian Masney <bmasney@redhat.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	sboyd@kernel.org,
	bmasney+clk@redhat.com,
	jbrunet+clk@baylibre.com,
	linux-clk@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] clk: zynq: handle kasprintf() failure in periph_clk registration
Date: Mon, 19 Oct 2026 09:49:54 -0400
Message-ID: <20261019135441.1420968-303-sashal@kernel.org>
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

From: William Theesfeld <william@theesfeld.net>

[ Upstream commit d4d0d335e8d37c6c7e1c5664c7664288eca5a09b ]

zynq_clk_register_periph_clk() ignores the return value of the two
kasprintf() calls used to build the mux and divider clock names, and
passes the resulting (possibly NULL) pointers straight into
clk_register_mux(), clk_register_divider() and clk_register_gate() as
the clock '"'name'"' argument.  On allocation failure that name later
gets dereferenced by the clock framework (e.g. in debugfs name
formatting), causing a NULL-pointer dereference.

Check both kasprintf() returns.  On failure unwind any allocated name
buffer and the spinlock, then fall through to the existing err label
which sets clks[] to ERR_PTR(-ENOMEM).  Freeing the spinlock on the
error path is correct here because no clk_register_*() call has had
a chance to take ownership of it; the success path intentionally
hands it off to the registered clocks.

The neighbouring zynq_clk_register_fclk() in the same file already
uses this per-allocation goto-label cleanup pattern; this change
brings periph_clk into line with it.

Signed-off-by: William Theesfeld <william@theesfeld.net>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53**. The buggy
`zynq_clk_register_periph_clk()` path is present here, and the patch is
an 8-line error-path fix. Full nine-phase analysis follows.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `clk: zynq`
- Action verb: **handle** (bug-fix verb: missing failure handling)
- Intent: check `kasprintf()` in peripheral clock registration so a NULL
  name is not passed into the clock framework
- Record: `[clk/zynq] [handle] [check kasprintf failure when registering
  periph clocks]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- `Reviewed-by: Brian Masney <bmasney@redhat.com>` — clk co-maintainer;
  also final `Signed-off-by` into clk tree
- `Reviewed-by: Michal Simek <michal.simek@amd.com>` — ARM/Zynq
  architecture maintainer
- `Signed-off-by: William Theesfeld <william@theesfeld.net>` — author
- `Signed-off-by: Brian Masney <bmasney@redhat.com>` — maintainer merge
- No `Fixes:` tag (expected for this review pipeline)
- No `Reported-by:`, `Tested-by:`, `Link:`, or `Cc: stable`
- Pipeline-added markers ignored per instructions: `[Upstream commit
  d4d0d335…]`, `Signed-off-by: Sasha Levin`
- Record: maintainer-reviewed, no syzbot/user report, no Fixes tag

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Bug: `zynq_clk_register_periph_clk()` ignores two `kasprintf()`
  results used as mux/divider names and passes them into
  `clk_register_mux/divider/gate`
- Claimed symptom: NULL name later dereferenced in CCF (commit cites
  debugfs name formatting) → NULL-pointer dereference
- Fix: check both returns; on failure free the other name buffer and the
  spinlock, then the existing `err` label sets `clks[] =
  ERR_PTR(-ENOMEM)`
- Author notes the sibling `zynq_clk_register_fclk()` already uses this
  goto-cleanup pattern
- Record: `[Bug: unchecked kasprintf] [Symptom: NPD / broken clock init]
  [No version info] [Root cause: missing NULL checks before
  clk_register_*]`

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Not disguised. Explicit error-path fix. Also closes a spinlock leak on
  the failure path (lock is allocated before `kasprintf`; success hands
  it to registered clocks, so failure must `kfree(lock)`).
- Record: `[Not hidden; allocation-failure / leak / NPD-class error-path
  fix]`

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
- File: `drivers/clk/zynq/clkc.c` — **+8 / -0**
- Function: `zynq_clk_register_periph_clk()`
- Scope: single-file surgical error-path fix
- Record: `[clkc.c +8] [zynq_clk_register_periph_clk] [surgical]`

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Verified against parent `e3b8b15ec6f0a^`:

Before:
```
mux_name = kasprintf(...);   /* unchecked */
div_name = kasprintf(...);   /* unchecked */
clk_register_mux(..., mux_name, ...);
clk_register_divider(..., div_name, mux_name, ...);
clks[clk0] = clk_register_gate(..., clk_name0, div_name, ...);
```
`err` was only used for `kmalloc(lock)` failure.

After: NULL `mux_name` → `err_mux_name` (`kfree(lock)`); NULL `div_name`
→ `err_div_name` (`kfree(mux_name)` then lock). Then `err` sets
`clks[clk0/clk1] = ERR_PTR(-ENOMEM)`. Success path unchanged.
- Record: `[error path only: skip clk_register_* on kasprintf failure
  and unwind]`

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category: **error path / resource leak** plus **memory safety** (NULL
name into CCF).

Verified CCF behavior in this tree (`drivers/clk/clk.c`):
- `kstrdup_const(NULL)` → `kstrdup(NULL)` returns NULL (`mm/util.c:84`)
- `__clk_register` then fails with `-ENOMEM` if `core->name` is NULL
  (`clk.c:4435-4438`)
- NULL **parent** name hits `WARN(!parent_names[i], ...)` then
  `clk_cpy_name(..., true)` returns `-EINVAL` (`clk.c:4347-4351,
  4307-4309`)
- `zynq_clk_setup()` then does `if (IS_ERR(clks[i])) BUG();`
  (`clkc.c:570-575`)

So a fully failed registration already `BUG()`s. The remaining hole is
mixed failure (mux `kasprintf` fails, div succeeds): mux/div
registration fails, gate may still register with a valid DT name and a
never-created parent → no `BUG()`, broken UART/SDIO/SPI/LQSPI/SMC/PCAP
clocks, and the spinlock can leak because `err` is not taken.
- Record: `[error-path leak + WARN + inconsistent clks[] / possible
  silent broken periph clocks]`

**Step 2.4: ASSESS THE FIX QUALITY**
- Matches the existing `zynq_clk_register_fclk()` pattern (present since
  `f8fe36f6083a70`, v3.13).
- `kfree(lock)` on this path is correct: no `clk_register_*` has run
  yet.
- Does not change the success path.
- Regression risk: very low. On failure, `clks[]` becomes
  `ERR_PTR(-ENOMEM)` and `zynq_clk_setup()` `BUG()`s — same policy this
  driver already uses for lock allocation / registration failure.
- Record: `[obviously correct, 8 lines, error-path only; risk very low]`

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
- Function introduced in `0ee52b157b8ed8` (“clk: zynq: Add clock
  controller driver”), 2013, contained in **v3.11-rc1**.
- `kasprintf` calls were unchecked from introduction until this fix.
- Record: `[0ee52b157b8ed8 / v3.11] [bug present for the life of this
  driver]`

**Step 3.2: FOLLOW THE FIXES: TAG**
- No `Fixes:` tag. Buggy commit is the original driver add, which **is**
  in this tree.
- Record: `[no Fixes tag; original driver commit is in this tree]`

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
- `f8fe36f6083a70` (v3.13): same goto-cleanup for
  `zynq_clk_register_fclk()` kasprintf/kmalloc
- `7938e9ce39d67` (2024, in this tree): “Prevent null pointer
  dereference caused by kmalloc failure” in `zynq_clk_setup()`
- `a6aa462c3efc1`: parameter update to this function — not a
  prerequisite for these checks
- Standalone; not patch N/M
- Record: `[standalone; sibling already had the pattern; related kmalloc
  NPD fix already here]`

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Only this clk/zynq commit from William Theesfeld in this tree
- Weight comes from reviewers: Michal Simek (Zynq) and Brian Masney
  (clk)
- Record: `[author not subsystem maintainer; both relevant maintainers
  reviewed]`

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Uses existing `kasprintf`, `kfree`, `goto err` — all present
- Mainline context uses `kmalloc_obj`; this tree still uses
  `kmalloc(sizeof(*lock), GFP_KERNEL)`. The hunk does not touch that
  line, so no `kmalloc_obj` dependency.
- Record: `[no prerequisites; applies standalone against this tree’s
  kmalloc() form]`

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- `b4 dig -c d4d0d335e8d37c6c7e1c5664c7664288eca5a09b` →
  https://patch.msgid.link/20260601203500.658135-1-william@theesfeld.net
- `b4 dig -a`: **v1 only** (2026-06-01)
- Thread saved to mbox: Michal Simek Reviewed-by (2026-06-02); Brian
  Masney Reviewed-by (2026-06-15). No NAK, no requested respin, no Cc:
  stable in review.
- Lore WebFetch returned 403; discussion read from `b4 dig -m` instead
- Record: `[lore msgid 20260601203500.658135-1-william@theesfeld.net]
  [v1 applied] [no NAKs] [no stable nomination in thread]`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- `b4 dig -w` recipients: Turquette, Boyd, Masney, Simek, linux-clk,
  linux-arm-kernel, linux-kernel
- Record: `[clk maintainers + Zynq maintainer were on To/Cc; both
  Reviewed-by]`

**Step 4.3: SEARCH FOR THE BUG REPORT**
- No Reported-by / Link / syzbot
- Record: `[no external bug report; found by code inspection]`

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Standalone v1 patch, not a series
- Record: `[standalone]`

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- `lore.kernel.org/stable/` fetch returned 403
- Record: `[UNVERIFIED: stable-list discussion; not used for the
  verdict]`

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
- Record: `[zynq_clk_register_periph_clk (modified); zynq_clk_setup
  (caller)]`

**Step 5.2: TRACE CALLERS**
Call sites in `zynq_clk_setup()` (CLK_OF_DECLARE `"xlnx,ps7-clkc"`,
every Zynq boot):
- lqspi, smc, pcap (single gate)
- sdio0/sdio1, uart0/uart1, spi0/spi1 (two gates)
- Record: `[boot-time OF clock init for Zynq PS peripherals]`

**Step 5.3: TRACE CALLEES**
- `kasprintf`, `kmalloc`/`kfree`, `clk_register_mux/divider/gate`
- Record: `[name alloc + CCF register; gate clocks stored in clks[]]`

**Step 5.4: FOLLOW THE CALL CHAIN**
- `CLK_OF_DECLARE` → `zynq_clk_setup` → `zynq_clk_register_periph_clk`
  during early boot on `CONFIG_ARCH_ZYNQ`
- `CONFIG_ARCH_ZYNQ=y` in `arch/arm/configs/multi_v7_defconfig`
- Not a syscall path; unprivileged users cannot trigger it except by
  booting the platform (possibly under memory pressure)
- Record: `[reachable on every Zynq boot; not userspace-triggerable
  later]`

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- `zynq_clk_register_fclk()` already checks every `kasprintf`
- After this patch, no remaining unchecked `kasprintf` in
  `drivers/clk/zynq/clkc.c`
- Record: `[sibling already fixed; this was the remaining hole]`

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- `git describe HEAD` → **v6.18.53-5049-g0f0bdc2b0dffb**
- `make kernelversion` → **6.18.53**
- Parent of the candidate still has unchecked `kasprintf` in
  `zynq_clk_register_periph_clk`
- Driver built as `obj-$(CONFIG_ARCH_ZYNQ) += zynq/`
- Record: `[yes, buggy code exists in 6.18.y zynq clkc; bug since
  v3.11]`

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Surrounding function matches; only the 8 check/label lines are needed
- `kmalloc_obj` in the mainline diff context is **not** used in this
  file here
- Record: `[clean apply / trivial context]`

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- `7938e9ce39d67` (kmalloc NPD in `zynq_clk_setup`) is already in this
  tree — different allocation
- fclk kasprintf checks already present
- No earlier equivalent of this periph_clk check besides the candidate
  itself
- Record: `[no substitute fix for this function’s kasprintf]`

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- `drivers/clk/zynq/` — platform clock provider for Xilinx Zynq-7000
- Criticality: **IMPORTANT** for Zynq (UART/SDIO/SPI clocks);
  **PERIPHERAL** vs core kernel
- Record: `[clk/zynq] [IMPORTANT for affected SoC, not universal]`

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
- File is mature (2013); recent commits are small correctness fixes, not
  refactors
- Record: `[mature/stable platform driver]`

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
- Record: `[platform-specific: CONFIG_ARCH_ZYNQ / xlnx,ps7-clkc]`

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
- `kasprintf(GFP_KERNEL, "%s_mux"/"%s_div", clk_name0)` during `__init`
  (~tens of bytes)
- Trigger: allocation failure at boot (rare, but same class this file
  already treats as fatal via `BUG()`)
- Not triggerable later from unprivileged userspace
- Record: `[rare boot OOM; not a syscall race]`

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Verified, not just the commit text:
- NULL clock **name**: CCF fails `-ENOMEM` (no debugfs NPD on that path
  in 6.18)
- NULL **parent** name: `WARN()` then `-EINVAL`
- Some combinations: `clks[i]` is `ERR_PTR` → existing `BUG()` in
  `zynq_clk_setup`
- Mixed success: possible boot with broken peripheral clocks + spinlock
  leak
- Author’s debugfs-NPD example is **overstated for this CCF**, but WARN
  / leak / inconsistent init are real
- Record: `[WARN + leak + possible BUG() or silently broken
  UART/SDIO/SPI] [severity HIGH on trigger, trigger rare]`

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Benefit: correct OOM handling for clocks used on every Zynq boot;
  closes leak; avoids WARN and half-registered trees
- Risk: 8 lines, error path only, same pattern already in-tree
- Record: `[benefit medium-high if it fires; risk very low; ratio favors
  backport]`

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real missing error handling on `kasprintf` in a boot clock path that
  already `BUG()`s on `IS_ERR(clks[i])`
- Also a spinlock leak and a `WARN()` on NULL parent names
- 8-line, obviously correct, mirrors in-tree sibling
- Code and bug exist in this 6.18 tree since v3.11
- Applies without `kmalloc_obj` or other prereqs
- Reviewed by Zynq maintainer and clk maintainer
- Same file already received a 2024 allocation-failure NPD fix

AGAINST:
- Trigger is a tiny boot-time allocation failure (rare)
- No user/syzbot report
- Debugfs NPD claim is not how 6.18 CCF handles a NULL `init.name`
  (fails `-ENOMEM` first)
- Platform-specific, not core

UNRESOLVED:
- Stable mailing list search (lore 403)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — matches existing fclk
   pattern; two maintainer Reviewed-by
2. Fixes a real bug that affects users? **PASS** — unchecked alloc,
   leak, WARN, inconsistent `clks[]` on Zynq boot
3. Important issue? **PASS** — boot `WARN`/`BUG()`/broken UART-SDIO-SPI
   clocks; same class as the in-tree kmalloc NPD fix
4. Small and contained? **PASS** — +8 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — function and bug present;
   context is `kmalloc(sizeof)`, not `kmalloc_obj`

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
- Not a device ID / quirk / DT / build / docs exception
- Record: `[none; qualifies as a normal small bugfix]`

**Step 9.4: MAKE YOUR DECISION**
The patch is a small, maintainer-reviewed error-path fix for code this
6.18 tree has had since v3.11. It does not add features. Risk is
confined to the allocation-failure path. That is appropriate for this
stable tree.

===============================================================
What problem it solves for this tree
===============================================================
`zynq_clk_register_periph_clk()` builds mux/divider names with
`kasprintf()` and, on failure, still calls into the clock framework.
That can `WARN` on a NULL parent, leak the per-clock spinlock, and
either `BUG()` in `zynq_clk_setup()` or leave UART/SDIO/SPI/LQSPI clocks
half-registered. The fix stops before `clk_register_*`, frees the
lock/name, and reports `-ENOMEM` the way lock allocation already does.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed tags: Reviewed-by Masney + Simek; no Fixes/Reported-
  by/Cc stable; ignored pipeline Upstream/Sasha SOB
- [Phase 1] Subject/body: handle kasprintf failure; claimed NPD; sibling
  fclk pattern
- [Phase 2] Diff: +8 in `zynq_clk_register_periph_clk`; parent still
  unchecked (git show e3b8b15^)
- [Phase 2] CCF: `kstrdup(NULL)` returns NULL (`mm/util.c:84`);
  `__clk_register` `-ENOMEM` on NULL name (`clk.c:4435-4438`); NULL
  parent `WARN` + `-EINVAL` (`clk.c:4347-4351`)
- [Phase 2] `zynq_clk_setup` `BUG()`s on `IS_ERR(clks[i])`
  (`clkc.c:570-575`)
- [Phase 3] blame: function from `0ee52b157b8ed8` (v3.11-rc1); fclk
  checks from `f8fe36f6083a70` (v3.13)
- [Phase 3] related `7938e9ce39d67` kmalloc NPD fix is ancestor of HEAD
- [Phase 3] no Fixes tag; original driver commit is in this tree
- [Phase 4] `b4 dig -c d4d0d335…`: lore msgid
  20260601203500.658135-1-william@theesfeld.net
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: clk + Zynq maintainers on Cc
- [Phase 4] mbox: Simek and Masney Reviewed-by; no NAK
- [Phase 4] lore WebFetch 403; stable-list search UNVERIFIED
- [Phase 5] callers: lqspi/smc/pcap/sdio/uart/spi from `zynq_clk_setup`;
  `CLK_OF_DECLARE(zynq_clkc, "xlnx,ps7-clkc")`
- [Phase 5] `CONFIG_ARCH_ZYNQ=y` in multi_v7_defconfig;
  `obj-$(CONFIG_ARCH_ZYNQ) += zynq/`
- [Phase 6] `git describe HEAD` = v6.18.53-5049-g0f0bdc2b0dffb;
  kernelversion 6.18.53
- [Phase 6] buggy kasprintf present without this patch; no kmalloc_obj
  in this file
- [Phase 8] failure mode verified against CCF (debugfs NPD overstated);
  WARN/leak/BUG/broken periph clocks verified
- UNVERIFIED: whether this hash was discussed on stable@ (lore 403)

The fix is small, surgical, present in the affected 6.18 code, and meets
the stable criteria.

**YES**

 drivers/clk/zynq/clkc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index c28d3dacf0fb2..db40a9e7dd3d9 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -186,7 +186,11 @@ static void __init zynq_clk_register_periph_clk(enum zynq_clk clk0,
 	spin_lock_init(lock);
 
 	mux_name = kasprintf(GFP_KERNEL, "%s_mux", clk_name0);
+	if (!mux_name)
+		goto err_mux_name;
 	div_name = kasprintf(GFP_KERNEL, "%s_div", clk_name0);
+	if (!div_name)
+		goto err_div_name;
 
 	clk_register_mux(NULL, mux_name, parents, 4,
 			CLK_SET_RATE_NO_REPARENT, clk_ctrl, 4, 2, 0, lock);
@@ -205,6 +209,10 @@ static void __init zynq_clk_register_periph_clk(enum zynq_clk clk0,
 
 	return;
 
+err_div_name:
+	kfree(mux_name);
+err_mux_name:
+	kfree(lock);
 err:
 	clks[clk0] = ERR_PTR(-ENOMEM);
 	if (two_gates)
-- 
2.53.0

