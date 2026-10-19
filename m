Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7131B6479B7;
	Mon, 19 Oct 2026 14:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418796; cv=none; b=OzBBpbPRlQCMxdwu+3lTOIOtU0azGaNKEL3e/J1H0UfUFY+PMispS/ekhzTwvuLL+heHETVVy5GguTCu7u7Z4XfaUVDAX/4uoi/bPQuXNiGZff/FFks07oGsC/ptt181YyBm4ekUwgdBCFYL61xCzU91x9JpHiriYd467ZjvjdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418796; c=relaxed/simple;
	bh=qzzqFHduJFPJ3gjpN3AgNQSdcp8ZATdEGKLZFid2SzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iqEF4Qubet846ds0Y9SP+wp5/ie1TaWjYrGx/gE4n7U4INSVaIqjvyU27TNZZMDMCq6Xbh/0oFKYgN1ZTmWL2lfulqiAr8gTcdS+wWrWMonXzXS4v2BU7MdK5bk0G6MpvYN3wzzvkRVinAOfg1CaU1uHUUSnGla5Lom+bSP2ibg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SVsT+lpS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVsT+lpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87381F000C7;
	Mon, 19 Oct 2026 14:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418794;
	bh=3O7F2X6+k4YoUAU2Oxwl9vtYL6fJyRW+Z7I2RKsPELI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SVsT+lpSO4UhuZZin3de5iOCnl7r8MI5SpJg6+BlEprYTj1X30qaM6bgJDmUlUZi7
	 ACiKIipiJOdIDOFHgHldozO7FMqgo/Bs6AZtmO/A44In4IO5PqL1rS9lUc/Wvisrmr
	 vpR3W9TUSZfh4tCf09kpnQenL/DJTbaehW6HYXLuihNkJwCh9ixX/IM0odhfV223wK
	 sbIn1h556jGx7TxK4w1yRyoUEFof21MeH2CiNFP/jIUpkgdbZioAz4xvwCbaLH9X8+
	 WTy9tC0pHKUaWv0dA7oc2wd1+iE2YlAlBX60km1u/jouJg4tE6cO3W/xSG6AvfSb3E
	 OeTBlFAJZiQBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sboyd@kernel.org,
	bmasney+clk@redhat.com,
	jbrunet+clk@baylibre.com,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	linux-clk@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] clk: sunxi-ng: fix ccu probe clock unregister on error
Date: Mon, 19 Oct 2026 09:53:12 -0400
Message-ID: <20261019135441.1420968-501-sashal@kernel.org>
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

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 81f4ddc9f7e0c11d3e9d24d0f30023845a02f7ee ]

When registering clocks with sunxi_ccu_probe(), the number of ccu_clocks
and the number of hw clocks might be different, eventhough they usually are
the same.

If they are different, it could lead to out-of-bound access or registered
clock left behind on error.

Use a different variable when iterating on hw clocks so every registered
clock, and only those, gets unregistered on error.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260629131254.7E34C1F00A3A@smtp.kernel.org
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://patch.msgid.link/20260706-a733-rtc-v4-3-f330728db3d3@baylibre.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[clk: sunxi-ng]** **[fix]** unregister the right set of CCU
`clk_hw` objects when `sunxi_ccu_probe()` fails.

**Step 1.2: Tags**
Record:
- `Reported-by: Sashiko <sashiko-bot@kernel.org>` — static-analysis bot,
  not syzbot
- `Closes:
  https://lore.kernel.org/r/20260629131254.7E34C1F00A3A@smtp.kernel.org`
- `Reviewed-by: Chen-Yu Tsai <wens@kernel.org>` — sunxi/clk maintainer
- `Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>` (author)
- `Link: https://patch.msgid.link/20260706-a733-rtc-v4-3-
  f330728db3d3@baylibre.com` — **v4 3/9** of the A733 RTC series
- `Signed-off-by: Chen-Yu Tsai <wens@kernel.org>` (applied to sunxi clk
  tree)
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected; not treated as a negative)

**Step 1.3: Body**
Record:
[Bug] `sunxi_ccu_probe()` uses one index for both `desc->ccu_clks`
(`num_ccu_clks`) and `desc->hw_clks` (`hw_clks->num`). Those lengths are
not always equal.
[Symptom] On probe error: **out-of-bounds** `hws[i]` access, or
**registered clocks left behind**.
[Version] None stated.
[Root cause] Error-path unregister walks the leftover loop index instead
of the hw-clock index.

**Step 1.4: Hidden bug fix?**
Record: **No disguise.** This is an explicit error-path OOB/leak fix.
Sashiko rated the pre-existing issue **High**.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record: `drivers/clk/sunxi-ng/ccu_common.c` only; **+6 / −6**. Function:
`sunxi_ccu_probe()`. Surgical, single-file.

**Step 2.2: Code-flow change**
Before: one `i` for (1) `ccu_clks` setup, (2) `hw_clks` register, (3)
rate-range on `ccu_clks`, then `err_clk_unreg` does `while (--i)` over
`hw_clks->hws[i]`. After loop (3), `i == num_ccu_clks`, so
provider/reset failures use the wrong bound.
After: hw-clock register/unregister uses `j`; `i` stays for `ccu_clks`.

**Step 2.3: Bug mechanism**
Record: **[memory safety / error-path leak]**
- `num_ccu_clks > hw_clks->num` → OOB read of `hws[]`
- `num_ccu_clks < hw_clks->num` → incomplete `clk_hw_unregister()`
  (leak)
`clk_hw_register()` failure already used the hw index; the clobber is
the **rate-range loop** added later, then `of_clk_add_hw_provider()` /
`reset_controller_register()` failures.

**Step 2.4: Fix quality**
Record: Obviously correct (separate index). Minimal. Regression risk
**very low** (`j` is always set by `for (j = 0; …)` before any `goto
err_clk_unreg`). No API/locking changes.

---

## Phase 3: Git history

**Step 3.1: Blame**
Record: Probe helper from `1d80c14248d608` (2016). Error unregister from
`5d806f9fc8e63d` / `9bec2b9c61340` (v5.16 era). The **clobber** is
`ea977d742507e` (“Don't call hw_to_ccu_common on hw without common”,
**v6.10-rc7**), which inserted a `num_ccu_clks` loop after hw
registration and reused `i`.

**Step 3.2: Fixes: tag**
Record: **None.** Introducer is `ea977d742507e` (ancestor of HEAD). That
commit was itself `Cc: stable` / `Fixes: b914ec33b391e`.

**Step 3.3: File history**
Record: Candidate `81f4ddc9f7e0c`. Nearby Jerome commits are A733 RTC
**features** after this fix. This patch is **standalone**; later series
patches are not prerequisites.

**Step 3.4: Author**
Record: Jerome Brunet (BayLibre, regular clk/sunxi contributor).
Maintainer Chen-Yu Tsai reviewed and applied it.

**Step 3.5: Dependencies**
Record: Needs the three-loop `sunxi_ccu_probe()` from `ea977d742507e`.
That is in this tree. No new helpers. **Can apply standalone.**

---

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
Record: `b4 dig -c 81f4ddc9f7e0c` → https://patch.msgid.link/20260706-
a733-rtc-v4-3-f330728db3d3@baylibre.com
Series: v1 (Junhui Liu, Jan 2026) → v2/v3/v4 (Jerome). This fix first
appears in **v3** (“Fix ccu probe helper to properly unregister clocks
on error”), applied as **v4 3/9**.
No NAK. Chen-Yu applied it to `sunxi/clk-for-7.3`. No reviewer `Cc:
stable`.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Chen-Yu Tsai, Jernej Skrabec, Samuel Holland, Stephen Boyd,
Maxime Ripard, linux-clk, linux-sunxi. Right maintainers.

**Step 4.3: Bug report**
Record: Sashiko on **v2 5/6** (msgid
`20260629131254.7E34C1F00A3A@smtp.kernel.org`), severity **High**: error
path uses `i == num_ccu_clks` as the `hws[]` bound → leak or OOB
depending on driver sizes. Pre-existing, not introduced by the A733
patch.

**Step 4.4: Series**
Record: 9-patch A733 RTC enablement. This hunk only touches
`ccu_common.c` and does not need A733. Later patches make RTC
`num_ccu_clks` vs `hw_clks->num` diverge more; the common-probe bug
already exists.

**Step 4.5: Stable list**
Record: lore.kernel.org/stable search for this subject returned **no**
dedicated stable-thread discussion. WebFetch to lore.html returned 403;
raw mbox via curl/`b4 dig -m` succeeded.

---

## Phase 5: Semantic / impact

**Step 5.1: Functions**
Record: `sunxi_ccu_probe()` only (plus log index).

**Step 5.2: Callers**
Record: `devm_sunxi_ccu_probe()` and `of_sunxi_ccu_probe()` in the same
file. Called from **all** sunxi-ng CCU drivers (H6, A64, H3, D1, A10,
RTC, …) at SoC clock probe/boot.

**Step 5.3: Callees**
Record: `clk_hw_register` / `of_clk_hw_register`,
`of_clk_add_hw_provider`, `reset_controller_register`,
`clk_hw_unregister`. Provider add can fail (`-ENOMEM`,
`of_clk_set_defaults()`).

**Step 5.4: Reachability**
Record: Boot-time CCU probe on Allwinner. Failure is error-path (OOM,
assigned-clock defaults). On failure, `of_sunxi_ccu_probe()` /
`devm_sunxi_ccu_probe()` **kfree** the `struct sunxi_ccu` whose `lock`
remaining clocks still point at (`cclk->lock = &ccu->lock`) if
unregister is incomplete.

**Step 5.5: Similar patterns**
Record: `devm_sunxi_ccu_release()` already walks `hw_clks->num`
correctly. Only the probe error path was wrong. Counts really differ,
e.g. H6: **127** `ccu_clks` vs **CLK_NUMBER 138**; A64: **104** vs
**115**. RTC in this tree: 12 `ccu_clks` vs `CLK_NUMBER_NO_GATES` **8**
on H616/R329 → **OOB** if probe fails after the rate-range loop.

---

## Phase 6: This checkout (v7.3-rc4)

**Step 6.1: Buggy code here?**
Record: **Yes.** `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`;
`VERSION=7 PATCHLEVEL=3`. `ea977d742507e` and `81f4ddc9f7e0c` are both
ancestors of HEAD. Pre-fix `sunxi_ccu_probe()` at `81f4ddc9f7e0c^` still
clobbers `i`. Bug since **v6.10**, long before 7.3.

**Step 6.2: Backport difficulty**
Record: **Clean apply** on this code (6-line index split). No refactor
between the buggy helper and this patch.

**Step 6.3: Other fixes already here?**
Record: This **is** the fix (`81f4ddc9f7e0c`). No earlier equivalent.
That does not mean “already selected for stable”; it is the mainline
commit being evaluated.

---

## Phase 7: Subsystem

**Step 7.1:** Record: **clk / Allwinner sunxi-ng CCU**. **IMPORTANT**
(every Allwinner platform’s clock controller), not core mm/net, not
staging.

**Step 7.2:** Record: Mature CCU core (2016) with ongoing SoC additions.
Helper is shared and stable; this is not churny experimental code.

---

## Phase 8: Impact and risk

**Step 8.1:** Record: **platform-specific** — `CONFIG_SUNXI_CCU` /
Allwinner boards (phones, SBCs, TVs). Many LTS users.

**Step 8.2:** Record: Trigger = CCU **probe failure** after clocks are
registered (`of_clk_add_hw_provider` / reset register). Not every boot.
Not a userspace syscall. `of_clk_set_defaults()` is a realistic DT
failure. Unprivileged users do not trigger it directly.

**Step 8.3:** Record: Incomplete unregister → leak; wrong bound →
**OOB**; leftover `clk_hw` plus `kfree(ccu)` → **UAF** on `cclk->lock`.
Severity **HIGH** on the error path (crash / memory safety), not a
normal-boot oops.

**Step 8.4:** Record: **Benefit high** for Allwinner error-path safety;
**risk very low** (6-line index fix). Ratio strongly favors backport.

---

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Real OOB/leak in shared CCU probe cleanup; counts differ on H6/A64/RTC
  in this tree
- Sashiko High; maintainer Reviewed-by + applied
- Tiny, obviously correct, no new API
- Bug from v6.10 (`ea977d742507e`) is in this tree
- No extra series patches required

AGAINST:
- Error-path only (not every boot)
- Nested in an A733 **feature** series (this patch is still self-
  contained)
- No live user oops; found by static review
- No `Fixes:` / `Cc: stable` (not a negative here)

UNRESOLVED:
- lore HTML 403 (mbox/raw used instead)
- Exact production hit rate of `of_clk_set_defaults()` failure on CCU
  nodes

**Step 9.2: Stable rules**
1. Obviously correct and tested — **PASS** (maintainer review; logic is
   local)
2. Real bug affecting users — **PASS** (Allwinner CCU probe fail →
   leak/OOB)
3. Important (crash/corruption/deadlock/security) — **PASS** (OOB;
   incomplete unwind + free of lock)
4. Small and contained — **PASS** (12 lines, one function)
5. No new features/APIs — **PASS**
6. Can apply to this tree — **PASS**

**Step 9.3: Exception category**
Record: None (not an ID/quirk/DT/build/doc exception). It is a normal
small bugfix.

**Step 9.4: Decision**
This tree is **7.3-rc4**. The helper and the v6.10 index-clobber exist
here. The patch is a surgical error-path memory-safety fix for every
sunxi-ng CCU, including OOB on RTC when `num_ccu_clks` (12) exceeds
`hw_clks->num` (8). It meets stable rules with very low regression risk.

---

### Problem and why it matters

`sunxi_ccu_probe()` registered `hw_clks` with index `i`, then reused `i`
to walk `ccu_clks` for rate limits. On later failure it unregistered
with that leftover `i`. Those array lengths differ on real SoCs, so
cleanup either walks off `hws[]` or leaves clocks registered (and can
free the `ccu` lock those clocks still use). Stable Allwinner devices
share this helper.

### Stable rules / risk

Small, reviewed, no features, applies cleanly. Benefit is avoiding
OOB/UAF on CCU probe failure; risk is a loop-index change only.

### Concerns

Needs `ea977d742507e` (present here). Do not pull the rest of the A733
series. Trigger is probe-error, not hot-path, but the failure mode is
memory safety.

Verification:
- [Phase 1] Tags: Sashiko Reported-by/Closes, Chen-Yu Reviewed-by, msgid
  v4 3/9; no Fixes/Cc stable
- [Phase 2] Diff: `i` vs `j` in `sunxi_ccu_probe()`; +6/−6 in
  `ccu_common.c`
- [Phase 3] `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`; blame:
  bug from `ea977d742507e` (v6.10-rc7); `git merge-base --is-ancestor
  ea977d742507e HEAD` → yes
- [Phase 3] `git log --oneline -- drivers/clk/sunxi-ng/ccu_common.c`:
  candidate `81f4ddc9f7e0c`; later commits are A733 features, not
  prerequisites
- [Phase 4] `b4 dig -c 81f4ddc9f7e0c` → lore msgid; `-a` v1–v4; `-w`
  sunxi/clk maintainers; `-m` 25-message mbox; Chen-Yu applied 3/9; no
  NAK
- [Phase 4] Original Sashiko report (curl raw): High, wrong loop limit,
  leak or OOB
- [Phase 4] Stable lore search: no prior stable-thread hit
- [Phase 5] Callers: `devm_sunxi_ccu_probe` / `of_sunxi_ccu_probe` → all
  sunxi-ng CCU drivers
- [Phase 5] H6 127 vs 138; A64 104 vs 115; RTC 12 vs 8
  (`CLK_NUMBER_NO_GATES`) verified in tree
- [Phase 5] `of_clk_add_hw_provider` can return `-ENOMEM` or
  `of_clk_set_defaults` error
- [Phase 6] Pre-fix source at `81f4ddc9f7e0c^` still uses one `i`;
  current file already has `j`
- [Phase 7] MAINTAINERS: Chen-Yu Tsai maintains `drivers/clk/sunxi-ng/`
- [Phase 8] Failure mode: OOB / leak / possible lock UAF on probe error
  — HIGH, error-path
- UNVERIFIED: live user crash report beyond Sashiko; lore HTML pages
  (403)

**YES**

 drivers/clk/sunxi-ng/ccu_common.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu_common.c b/drivers/clk/sunxi-ng/ccu_common.c
index c7e00f0c29a55..bbda75c2bc461 100644
--- a/drivers/clk/sunxi-ng/ccu_common.c
+++ b/drivers/clk/sunxi-ng/ccu_common.c
@@ -114,7 +114,7 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 			   const struct sunxi_ccu_desc *desc)
 {
 	struct ccu_reset *reset;
-	int i, ret;
+	int i, j, ret;
 
 	ccu->desc = desc;
 
@@ -130,8 +130,8 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 		cclk->lock = &ccu->lock;
 	}
 
-	for (i = 0; i < desc->hw_clks->num ; i++) {
-		struct clk_hw *hw = desc->hw_clks->hws[i];
+	for (j = 0; j < desc->hw_clks->num ; j++) {
+		struct clk_hw *hw = desc->hw_clks->hws[j];
 		const char *name;
 
 		if (!hw)
@@ -143,7 +143,7 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 		else
 			ret = of_clk_hw_register(node, hw);
 		if (ret) {
-			pr_err("Couldn't register clock %d - %s\n", i, name);
+			pr_err("Couldn't register clock %d - %s\n", j, name);
 			goto err_clk_unreg;
 		}
 	}
@@ -186,8 +186,8 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 err_del_provider:
 	of_clk_del_provider(node);
 err_clk_unreg:
-	while (--i >= 0) {
-		struct clk_hw *hw = desc->hw_clks->hws[i];
+	while (--j >= 0) {
+		struct clk_hw *hw = desc->hw_clks->hws[j];
 
 		if (!hw)
 			continue;
-- 
2.53.0

