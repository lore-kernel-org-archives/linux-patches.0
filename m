Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F69559E321;
	Mon, 31 Aug 2026 13:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184312; cv=none; b=DzPD7MgnT2vMWiY7MM+b5TmINryv5X3DLSgS/Ixp8B/YFUtUzqQIJs8x9Eu7aR22nGvWZqF0L7pKS6uAuhTuvjaPyGotG/cSvqTPcG9D4LUQbs3EzThXN0dusnu8Q6X5sO3BcUu/Fb341JN7Z1lPqyOmBfLZc+Ua+4riC+5Q1XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184312; c=relaxed/simple;
	bh=ygCvytm3562N3Cc9b/Syye97edGOp6TLZ2ob6ssN+/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ifkt2SJgvbDV95EWU1ateKXQ9Vs3e1QRKzh/Xl/p7H1oQUa/rHxWEzi0Uafo057nL+ISjbkA2771q7146kDmxNrbnkdV6KGZbY4Sq7hOYrEbyIXLezoI36MHPfS/vV7zQiSsJayuCActncaXEpS41dwJgo4q/Obd2SQt7PKB9+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AaXEyfzy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AaXEyfzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DAD1F00A3D;
	Mon, 31 Aug 2026 13:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184309;
	bh=lKLM2OQ00SJcVK0Teqbvw6uSu3wkEfo88rjPxpxBCQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AaXEyfzyHdvhumbCRLUDYj7dsGZjMcMOkzPNTOzJCEpDWcALTLfA9fe90J3vWmzFR
	 8oSve45+mAWFVNs1XFsH4RcBn6vej+xX9KZ9mqEePRfMlHz1FqLi+GkSh38qRL0Rsh
	 TNO0GmGEiLp9/XQeC4iocz5bfH+zY+Hv4Ggwxz0aI/Pk2PdOybtambqOOk67EtJuNp
	 NGWBADz5VrNglckPthUz2+ZK8fOysDutlFSrKsxYFevFw0dNziXOrIavBVhkMFh9VZ
	 FCzHa7ovrsakLSskywzxg5K73GtYtGCngFnfvgwKgxuTx7oX8MFfhgr0zJryrdIMMi
	 pKnqAkFR6zpjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	linux-omap@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: cpsw_new: unregister devlink on port registration failure
Date: Mon, 31 Aug 2026 09:30:43 -0400
Message-ID: <20260831133314.4125787-615-sashal@kernel.org>
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

[ Upstream commit b64f763b607426ac97e44b114f0b8844ac3b86dd ]

cpsw_probe() registers devlink before registering the CPSW ports.

If cpsw_register_ports() fails, the error path only unregisters the
notifiers and then releases the lower level resources. It does not undo
the successful cpsw_register_devlink() call, leaving the devlink instance
and its parameters registered after probe has failed.

Add a devlink cleanup label for the path where devlink registration has
already succeeded, and use it when port registration fails.

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260604043115.1409134-1-lgs201920130244@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: cpsw_new: unregister devlink on port
registration failure`

**Local tree:** `v6.18.44` (6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[net: cpsw_new]` `[unregister]` — On
`cpsw_register_ports()` failure after successful devlink registration,
unregister the devlink instance instead of leaking it.

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Aleksandr Loktionov \<aleksandr.loktionov@intel.com\>
- **Reviewed-by:** Alexander Sverdlin \<alexander.sverdlin@siemens.com\>
  (reviewed prior stable-nominated error-path fixes in this driver)
- **Signed-off-by:** Guangshuo Li \<lgs201920130244@gmail.com\>
- **Link:** https://patch.msgid.link/20260604043115.1409134-1-
  lgs201920130244@gmail.com
- **Signed-off-by:** Jakub Kicinski \<kuba@kernel.org\>
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org, or
  syzbot references
- v2 notes: subject updated for net-next; Fixes tag dropped

### Step 1.3: Body analysis
**Record:**
- **Bug:** `cpsw_probe()` registers devlink before ports. If
  `cpsw_register_ports()` fails, the error path unregisters notifiers
  but not devlink.
- **Symptom:** Orphaned devlink instance and registered devlink
  parameters after a failed probe.
- **Root cause:** Missing `cpsw_unregister_devlink()` on the port-
  registration failure path.
- **Version info:** None in the message; bug dates to devlink
  introduction in 2019.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Described as cleanup, but it fixes a real resource-
management bug: devlink allocated with `devlink_alloc()` (not devm) is
never freed on this error path, and `dl_priv->cpsw` can dangle once devm
frees `cpsw`.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/ethernet/ti/cpsw_new.c` (+3 / -1)
- **Function:** `cpsw_probe()`
- **Scope:** Single-file surgical fix in one error path

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (line 2051):** `cpsw_register_ports()` failure: `goto
  clean_unregister_notifiers` → `goto clean_unregister_devlink`
- **Hunk 2 (lines 2063–2064):** New label `clean_unregister_devlink:`
  calling `cpsw_unregister_devlink(cpsw)` before the existing notifier
  cleanup chain

**Before:** Port registration failure skipped devlink teardown.
**After:** Port registration failure runs the same devlink cleanup as
`cpsw_remove()`.

### Step 2.3: Bug mechanism
**Record:** **Category:** Error-path resource leak (and potential UAF).
**Mechanism:** `cpsw_register_devlink()` calls `devlink_alloc()`,
`devlink_params_register()`, and `devlink_register()`. On port failure,
only notifiers were torn down. `cpsw` (devm) is freed on probe failure
while devlink (non-devm) remains registered with `dl_priv->cpsw`
pointing at freed memory.

### Step 2.4: Fix quality
**Record:** Obviously correct — mirrors `cpsw_remove()`. Minimal, no API
changes. Very low regression risk; only affects the
`cpsw_register_ports()` failure path.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy `goto clean_unregister_notifiers` after
`cpsw_register_ports()` introduced in `ed3525eda4c49` (2019-11-20,
"introduce cpsw switchdev based driver part 1 - dual-emac"). Present in
this tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag (dropped in v2).

### Step 3.3: Related file history
**Record:** Recent related stable-nominated error-path fixes already in
this tree:
- `299b825716b82` — unnecessary netdev unregistration in `cpsw_probe()`
  error path (Cc: stable)
- `29739ec197ed6` — unregister of netdev not yet registered (Cc: stable)

Both fix `cpsw_probe()` error handling from the same original commit
(`Fixes: ed3525eda4c49`). This patch is a third, complementary error-
path fix.

### Step 3.4: Author context
**Record:** Guangshuo Li has no prior commits in `cpsw_new.c` in this
tree. Reviewer Alexander Sverdlin reviewed the Kevin Hao stable fixes
and this patch.

### Step 3.5: Dependencies
**Record:** Standalone. No series dependencies. Applies cleanly to this
tree (verified with `git apply --check`).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 am 20260604043115.1409134-1-lgs201920130244@gmail.com`
found v2 patch thread. Lore/patch.msgid.link blocked by bot protection;
content retrieved from local mbox. No replies in mbox; b4 reported 14
code-review trailers on lore (content not directly readable). No
explicit stable nomination in the patch.

### Step 4.2: Reviewers
**Record:** Reviewed-by from Aleksandr Loktionov (Intel) and Alexander
Sverdlin (Siemens, prior reviewer of stable-nominated cpsw error-path
fixes).

### Step 4.3: Bug reports
**Record:** None. No syzbot, bugzilla, or user reports.

### Step 4.4: Related patches
**Record:** Part of ongoing `cpsw_probe()` error-path hardening
alongside Kevin Hao's v1 series (Feb 2026). Those fixes are already in
6.18.44; this one is not yet.

### Step 4.5: Stable list history
**Record:** Could not search lore stable list (bot protection).
Precedent: related fixes in the same function were explicitly `Cc:
stable@vger.kernel.org`.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `cpsw_probe()`, `cpsw_register_devlink()`,
`cpsw_unregister_devlink()`, `cpsw_register_ports()`

### Step 5.2: Callers
**Record:** `cpsw_probe()` is the `platform_driver.probe` callback for
`cpsw_new` (TI CPSW on AM335x, AM4372, DRA7, etc.). Called during
platform device enumeration / module load.

### Step 5.3: Callees
**Record:** On failure path, fix adds `devlink_unregister()`,
`devlink_params_unregister()`, `devlink_free()` via
`cpsw_unregister_devlink()`.

### Step 5.4: Reachability
**Record:** Triggered when `register_netdev()` fails inside
`cpsw_register_ports()` during probe — uncommon but reachable on
boot/module load (ENOMEM, registration failure, etc.). Not userspace-
triggerable directly, but affects device bring-up.

### Step 5.5: Similar patterns
**Record:** `am65-cpsw-nuss.c` has its own devlink registration with
proper cleanup in remove; this fix addresses the parallel gap in
`cpsw_new.c` only.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** In `cpsw_new.c` at lines 2049–2051:

```2049:2051:drivers/net/ethernet/ti/cpsw_new.c
        ret = cpsw_register_ports(cpsw);
        if (ret)
                goto clean_unregister_notifiers;
```

`clean_unregister_devlink` does not exist; devlink is not unregistered
on this path.

### Step 6.2: Backport complications
**Record:** Clean apply expected — `git apply --check` passed with no
conflicts.

### Step 6.3: Related fixes already present?
**Record:** Kevin Hao's netdev error-path fixes (`299b825716b82`,
`29739ec197ed6`) are in tree. This devlink cleanup fix is **not** yet
applied.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/net/ethernet/ti** — IMPORTANT for embedded TI
platforms (AM33xx, AM4372, DRA7). `CONFIG_TI_CPSW_SWITCHDEV` / module
`cpsw_new`.

### Step 7.2: Subsystem activity
**Record:** Active — multiple 2026 commits including error-path fixes
for this same probe function.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of TI CPSW (`cpsw_new`) on OMAP/AM33xx/AM4372/DRA7
platforms with `CONFIG_TI_CPSW_SWITCHDEV` enabled.

### Step 8.2: Trigger conditions
**Record:** `cpsw_register_ports()` → `register_netdev()` fails during
probe. Uncommon (boot/module-load error path). Not a normal runtime
path.

### Step 8.3: Failure mode severity
**Record:**
- **Primary:** Devlink memory leak; orphaned devlink registration and
  sysfs entries after failed probe
- **Secondary:** `dl_priv->cpsw` may point at devm-freed `cpsw` —
  potential UAF if devlink is accessed after failed probe
- **Severity:** **MEDIUM** — error-path only, rare trigger, but real
  resource bug with UAF potential; not a hot-path crash

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — completes error-path cleanup already being fixed
  in this driver for stable
- **Risk:** VERY LOW — 3-line change, mirrors existing remove path
- **Ratio:** Favorable for backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence

**FOR backport:**
- Real bug present since 2019 in this tree
- Missing devlink cleanup on probe error path
- Non-devm devlink allocation leaked; dangling pointer to devm-freed
  `cpsw`
- Trivial, obviously correct fix; applies cleanly
- Reviewed by driver maintainers
- Same `cpsw_probe()` error path already received stable-nominated fixes
  in 6.18.44
- Matches stable pattern for probe error-path resource leaks

**AGAINST backport:**
- Only triggers on rare `register_netdev()` failure during probe
- No user reports, syzbot, or CVE
- Not a normal-operation crash
- No explicit Cc: stable on this patch

**Unresolved:** Full lore review thread content (bot-blocked); exact
severity if devlink sysfs is accessed post-failed-probe is inferred from
code, not reproduced.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors `cpsw_remove()`;
   reviewed by two maintainers
2. Fixes a real bug? **PASS** — devlink leak on probe failure
3. Important issue? **PASS (MEDIUM)** — resource leak with UAF potential
   on error path; not critical hot-path crash
4. Small and contained? **PASS** — 3 lines, one file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — bug present; patch applies
   cleanly

### Step 9.3: Exception categories
**Record:** N/A — standard error-path bug fix, not device
ID/quirk/build/doc exception.

### Step 9.4: Decision rationale

For **6.18.44**, the buggy code exists and has since devlink support
landed in 2019. The fix is minimal, correct, and consistent with stable-
nominated error-path fixes already merged for the same `cpsw_probe()`
function. While the trigger is uncommon, leaving devlink registered
after probe failure leaks resources and leaves a dangling `cpsw` pointer
inside devlink private data. This is appropriate stable material for
this tree.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user query and mbox
  file
- **[Phase 1]** v2 changelog: Fixes tag dropped; subject updated for
  net-next
- **[Phase 2]** Diff: +3/-1 in `cpsw_probe()`; adds
  `clean_unregister_devlink` label
- **[Phase 2]** Read `cpsw_register_devlink()` /
  `cpsw_unregister_devlink()` — non-devm `devlink_alloc()` with
  `dl_priv->cpsw = cpsw`
- **[Phase 3]** `git describe HEAD`: v6.18.44
- **[Phase 3]** `git blame -L 2045,2051`: buggy path from
  `ed3525eda4c49` (2019-11-20)
- **[Phase 3]** `git log --oneline -20 -- cpsw_new.c`: related stable
  fixes `299b825716b82`, `29739ec197ed6` present
- **[Phase 3]** `git log -S cpsw_register_devlink`: introduced in
  `ed3525eda4c49`
- **[Phase 3]** `git apply --check`: patch applies cleanly
- **[Phase 4]** `b4 am 20260604043115...`: found v2 patch; Reviewed-by
  tags confirmed
- **[Phase 4]** Lore/patch.msgid.link fetch: blocked by Anubis bot
  protection
- **[Phase 5]** Read `cpsw_register_ports()` — fails on
  `register_netdev()` error
- **[Phase 5]** `cpsw_remove()` calls `cpsw_unregister_devlink()` — fix
  matches remove path
- **[Phase 6]** Confirmed buggy `goto clean_unregister_notifiers` at
  lines 2049–2051 in current tree
- **[Phase 6]** `grep clean_unregister_devlink`: not present — fix not
  yet applied
- **[Phase 7]** Kconfig: `TI_CPSW_SWITCHDEV` selects `NET_DEVLINK`,
  module `cpsw_new`
- **[Phase 8]** UAF potential inferred from non-devm devlink + devm
  `cpsw` — not runtime-tested

**YES**

 drivers/net/ethernet/ti/cpsw_new.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index c6cf7a0375e08..34c0e651e2da3 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -2048,7 +2048,7 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	ret = cpsw_register_ports(cpsw);
 	if (ret)
-		goto clean_unregister_notifiers;
+		goto clean_unregister_devlink;
 
 	dev_notice(dev, "initialized (regs %pa, pool size %d) hw_ver:%08X %d.%d (%d)\n",
 		   &ss_res->start, descs_pool_size,
@@ -2060,6 +2060,8 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	return 0;
 
+clean_unregister_devlink:
+	cpsw_unregister_devlink(cpsw);
 clean_unregister_notifiers:
 	cpsw_unregister_notifiers(cpsw);
 clean_cpts:
-- 
2.53.0

