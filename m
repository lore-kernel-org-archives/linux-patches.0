Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797534E234F;
	Mon, 31 Aug 2026 13:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183590; cv=none; b=FeiPW+ZMyL9adWUT7pemqsbPgMRu7dzJ3ODJsrA3DuilSJwyeJb1CWdpdASje11LxfnSbKQl/9LKBvP7iiZ0rIaP6hVCwELiOGxzGr//jBdobBaj/yAyJKhDnK10ggg8g9APnBGR3uE714d9zdQVKaNuHcbDKG+YAkTjfAcidho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183590; c=relaxed/simple;
	bh=uoYboPMNu0NQlTMw2oKumGmLfNOfVnp7lSBe7IgabHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D7oXaug/IruxZBaZAP1ot1H5OKmqVTnnjcuNguIYA/dv9SQSGzYA8SoGzZD0SeWIRRJdhAEhsabL2oRuMCbV8PCZWn4npuLZg8t53Zlkk7cUEOFX3hqBdY+VGu3ZCzPbfDk23z2M0u4aRwoQ+v2KIXpzr6MbQUh1y379gQex5tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nnHVxNLP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nnHVxNLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99EC1F000E9;
	Mon, 31 Aug 2026 13:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183588;
	bh=jXOkA/Fi8buvhzvrTfdENg0DewuUgO2Qi/Xbe+doZJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnHVxNLPD9/GeB2HE2AnZmTfdlg76q4huWgIepoLMaYfGQ8En7MpwYMSt4sjmNERQ
	 QX/VxDRtjYiLbRB+8N2BWkQ9ekZmK0iXOpIqp6+P56CqkdECGISqlAbTyiLzZ5s72b
	 5ack8mxk7IZ4JjLiPruXT9EfGr3Wid2VrNjZPl/5dFEnIXYGn+bSkopHvvO/9+d8aj
	 QZGprleZJur23mqYeljRQHn4Y9YghLBHE47PjRBrsGiSRGpyldyrKyj2ZHKGiFuCzr
	 9elb9IRL/byhKzwVXPVpWzh1Uk2PY+ykLFIMpBkR6DNnKvxExSmxnTNuBu3/4zfBdE
	 ZH2R2N476PTRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Yang <mmyangfl@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: dsa: sja1105: flower: reject cross-chip redirect
Date: Mon, 31 Aug 2026 09:23:32 -0400
Message-ID: <20260831133314.4125787-184-sashal@kernel.org>
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

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit cfa5274a5dc2a23b957da5dc806d2ac0c7a66af0 ]

dsa_port_from_netdev() may return a valid port from a different switch
chip. Programming another chip's port index into the local hardware
causes redirection to the wrong port, or an out-of-bounds access if the
index exceeds the local chip's port count.

Apply a minimal fix that adds a check to catch this case and adjusts the
extack message. When cls->common.skip_sw is not set, the operation could
instead redirect to the upstream port and let the software or upstream
switch(es) handle the forward, but that is not addressed here.

Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20260530003940.2000994-1-mmyangfl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: dsa: sja1105: flower: reject cross-
chip redirect`

**Local tree:** `v6.18.44-2-gc2044b1939218` (kernel version **6.18.44**)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[net: dsa: sja1105: flower]` `[reject]` — reject invalid
cross-chip TC flower redirect destinations in the sja1105 flower offload
path.

### Step 1.2: Parse all commit message tags
**Record:**
- **Signed-off-by:** David Yang `<mmyangfl@gmail.com>` (author)
- **Reviewed-by:** Vladimir Oltean `<olteanv@gmail.com>` (sja1105/DSA
  maintainer)
- **Link:**
  `https://patch.msgid.link/20260530003940.2000994-1-mmyangfl@gmail.com`
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (net maintainer
  merge)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc:
  stable@vger.kernel.org`
- Notable: maintainer review present; no user/syzbot reports cited.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** `dsa_port_from_netdev()` can return a valid `dsa_port`
  belonging to a *different* switch chip in a multi-chip DSA tree. The
  code then programs `BIT(to_dp->index)` into the *local* chip's
  hardware.
- **Symptom:** Traffic redirected to the wrong local port, or (if
  `to_dp->index` exceeds the local chip's port count) invalid destport
  bits programmed into hardware.
- **Root cause:** Missing validation that the redirect destination
  belongs to the same `dsa_switch` (`ds`) being offloaded.
- **Version info:** None in the message.
- **Scope note:** Author explicitly defers proper cross-chip forwarding
  to software/upstream; this patch only rejects the invalid case.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised as cleanup — this is an explicit
correctness/validation bug fix. The `reject` verb and updated extack
message make intent clear.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory changes
**Record:**
- **File:** `drivers/net/dsa/sja1105/sja1105_flower.c` (+0/-0 net, 2
  lines changed semantically)
- **Function:** `sja1105_cls_flower_add()` — `FLOW_ACTION_REDIRECT` case
  only
- **Scope:** Single-file, surgical fix (~3 lines touched)

### Step 2.2: Code flow change
**Record:**
- **Hunk (FLOW_ACTION_REDIRECT):**
  - **Before:** Accept any netdev that `dsa_port_from_netdev()`
    resolves, even if `to_dp->ds != ds`; program `BIT(to_dp->index)`
    into local VL redirect rule.
  - **After:** Also reject when `to_dp->ds != ds` with `-EOPNOTSUPP` and
    message `"Destination not a local switch port"`.
- **Path affected:** TC flower rule add with redirect action, reachable
  from userspace `tc filter add ... action mirred egress redirect dev
  <other-chip-port>`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness fix — invalid hardware programming.
- **Mechanism:** Port indices are per-switch (`dsa_port->index` is local
  to `to_dp->ds`). Using a foreign chip's index as a destport bitmask on
  the local chip maps traffic to the wrong egress port(s). On chips with
  fewer ports (SJA1105: 5 ports) than the source chip's destination
  (SJA1110: up to 11 ports), indices ≥ local `num_ports` set destport
  bits with no valid local port — undefined hardware behavior per commit
  message.

### Step 2.4: Fix quality
**Record:**
- **Quality:** Obviously correct; mirrors existing cross-chip awareness
  in the same driver (`sja1105_main.c` already skips ports where `dp->ds
  != ds`).
- **Regression risk:** Very low — only rejects configurations that were
  already wrong; previously they were silently mis-programmed.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** `FLOW_ACTION_REDIRECT` block introduced in **dfacc5a23e227**
(Vladimir Oltean, 2020-05-05): *"net: dsa: sja1105: support flow-based
redirection via virtual links"*. Bug present since flower redirect
support landed (~kernel 5.7 era). Confirmed present in this 6.18.44 tree
(fix not yet applied).

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:** Recent related commits in this file:
- `4b762fee325b6` — flower: validate control flags
- `6f0d32509a92d` — fix error return code in `sja1105_cls_flower_add()`
- `dfacc5a23e227` — original redirect support

Standalone fix; not part of a multi-patch series.

### Step 3.4: Author's other commits
**Record:** David Yang (mmyangfl) is an active net contributor (data-
race fixes, DSA realtek leak fix, etc.) but not the sja1105 maintainer.
Vladimir Oltean (maintainer) reviewed the patch.

### Step 3.5: Prerequisites
**Record:** No dependencies. Uses only `to_dp->ds` and `ds` already in
scope. Applies cleanly to current tree code at lines 390–407.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 dig -c <commit>` could not run — commit hash not present
in local tree. `b4 dig` without `-c` requires stdin commit-ish.
**WebFetch/lore.kernel.org blocked** (Anubis bot protection). Link tag
points to msgid `20260530003940.2000994-1-mmyangfl@gmail.com` but thread
content **could not be retrieved**.

### Step 4.2: Reviewers
**Record:** **Reviewed-by: Vladimir Oltean** verified from commit
message. Full recipient list from `b4 dig -w` **UNVERIFIED** (no commit
hash available locally).

### Step 4.3: Bug reports
**Record:** No `Reported-by:` or syzbot links. No external bug report
found.

### Step 4.4: Related patches/series
**Record:** Appears standalone; no series indicators in subject or local
history.

### Step 4.5: Stable mailing list
**Record:** **UNVERIFIED** — lore stable search inaccessible.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `sja1105_cls_flower_add()` modified; calls
`dsa_port_from_netdev()`, `sja1105_vl_redirect()`.

### Step 5.2: Callers
**Record:** Registered as `ds->ops->cls_flower_add` in
`sja1105_main.c:3234`. Invoked from `dsa_user_add_cls_flower()` in
`net/dsa/user.c:1603` when userspace adds a TC flower classifier on a
DSA user port.

### Step 5.3: Callees
**Record:** `dsa_port_from_netdev()` (`net/dsa/dsa.c:1703`) returns
`dsa_user_to_port(netdev)` for any DSA user port in the tree — **not**
restricted to the local switch. `sja1105_vl_redirect()` stores
`destports` bitmask into flow rules and programs hardware via
`sja1105_init_virtual_links()`.

### Step 5.4: Call chain / reachability
**Record:** `tc` (userspace, typically root) → netlink TC offload →
`dsa_user_add_cls_flower()` → `sja1105_cls_flower_add()` →
`FLOW_ACTION_REDIRECT` path. **Reachable from userspace** on systems
with `CONFIG_NET_DSA_SJA1105` and multi-chip cascade topology.

### Step 5.5: Similar patterns
**Record:** Same driver already uses `if (dp->ds != ds) continue;` in
`sja1105_main.c:223` and `:598` for cross-chip topology handling.
SJA1110 variants explicitly set `multiple_cascade_ports = true` in
`sja1105_spi.c`. No equivalent `to_dp->ds != ds` check found elsewhere
in DSA flower redirect paths in this tree.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** **YES.** Current tree at `sja1105_flower.c:393-397` only
checks `IS_ERR(to_dp)`, not `to_dp->ds != ds`. Bug has existed since
dfacc5a23e227 (2020).

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — only 2 logical lines change in an
unchanged code block. No recent refactoring conflicts in this hunk.

### Step 6.3: Related fixes already present?
**Record:** **NO** — `grep` for `to_dp->ds != ds` and `"local switch
port"` in `drivers/net/dsa/` returns no matches. Fix not yet in this
tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/dsa/sja1105` — **PERIPHERAL** (niche
automotive/industrial Ethernet switch driver, `CONFIG_NET_DSA_SJA1105`,
SPI-managed). Critical for its users but not universal.

### Step 7.2: Subsystem activity
**Record:** Actively maintained — recent commits in 6.18 for SGMII, PTP,
DT bindings, flower flag validation.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of NXP SJA1105/SJA1110 in **multi-chip cascaded DSA
topologies** who install TC flower rules with `FLOW_ACTION_REDIRECT` to
a port on a different chip. Config-specific (`CONFIG_NET_DSA_SJA1105`).

### Step 8.2: Trigger conditions
**Record:** Requires multi-chip sja1105 deployment + TC flower redirect
to foreign-chip port. Uncommon globally, but **explicitly supported**
hardware topology (`multiple_cascade_ports`). Triggerable by root via
`tc`.

### Step 8.3: Failure mode severity
**Record:**
- **Primary:** Silent mis-programming — traffic steered to wrong local
  port(s). **HIGH** for affected deployments (network misdelivery in
  automotive TSN contexts).
- **Secondary:** Invalid destport bits when foreign index ≥ local
  `num_ports` (e.g., SJA1110 index on SJA1105 chip). Hardware undefined
  behavior; commit claims OOB — kernel memory OOB **not verified**
  (`destports` is `u64`, `BIT()` is safe for indices < 64), but invalid
  hardware destport mask is real.
- **Not:** kernel oops/panic (no evidence).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM-HIGH for sja1105 multi-chip users — prevents
  accepting rules that corrupt switch forwarding tables.
- **Risk:** VERY LOW — 2-line validation, maintainer-reviewed, matches
  existing driver pattern.
- **Ratio:** Favorable for backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Real, long-standing bug (since 2020) confirmed in 6.18.44 tree
- Minimal, obviously correct fix
- Reviewed by subsystem maintainer (Vladimir Oltean)
- Multi-chip cascade is an intended use case for SJA1110
- Same `dp->ds != ds` pattern already used elsewhere in driver
- Userspace-reachable via TC offload
- Wrong hardware programming → traffic misdelivery ("oh, that's not
  good" per stable rules)
- Changes silent misconfiguration to explicit, safe rejection

**AGAINST backport:**
- Niche driver / config (`CONFIG_NET_DSA_SJA1105`)
- No user reports, syzbot, or crash evidence
- Failure is forwarding misbehavior, not kernel crash/security
- Rare trigger (multi-chip + cross-chip redirect rule)

**UNRESOLVED:**
- Full lore review thread (blocked)
- Whether any reviewer nominated for stable
- Exact mainline commit SHA (not in local tree)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is trivial; maintainer
   reviewed; no Tested-by.
2. Fixes a real bug affecting users? **PASS** — confirmed code path bug
   in supported topology.
3. Important issue? **PASS (moderate)** — hardware misprogramming /
   traffic misdelivery, not kernel crash.
4. Small and contained? **PASS** — 2-line logic change, one file.
5. No new features/APIs? **PASS** — validation only.
6. Can apply to local tree? **PASS** — buggy code present; clean apply
   expected.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Qualifies
as a hardware-driver correctness fix.

### Step 9.4: Decision rationale
For **this 6.18.y tree**, the buggy code is present and has been since
flower redirect support landed. The driver explicitly supports multi-
chip cascade topologies, making this a realistic misconfiguration path
rather than a theoretical edge case. The fix is minimal, maintainer-
reviewed, and consistent with existing cross-chip checks in the same
driver. While the user population is small, silently programming wrong
switch forwarding rules is a serious functional defect for those users.
The fix only rejects invalid configurations that should never have been
accepted.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Read current `sja1105_flower.c:390-407` — buggy code
  confirmed (only `IS_ERR` check)
- **[Phase 2]** Read `sja1105_vl_redirect()` — `destports` bitmask
  programmed to hardware
- **[Phase 2]** Read `sja1105_static_config.h` — SJA1105_NUM_PORTS=5,
  SJA1110_NUM_PORTS=11
- **[Phase 3]** `git describe HEAD` → v6.18.44-2-gc2044b1939218 / kernel
  6.18.44
- **[Phase 3]** `git blame -L 390,408` → redirect code from
  dfacc5a23e227 (2020-05-05)
- **[Phase 3]** `git show dfacc5a23e227` — original flower redirect
  commit
- **[Phase 3]** `git log --oneline -20 --
  drivers/net/dsa/sja1105/sja1105_flower.c` — no prior cross-chip fix
- **[Phase 4]** `b4 dig -c HEAD` — wrong commit; **UNVERIFIED** for this
  patch
- **[Phase 4]** WebFetch lore.kernel.org and patch.msgid.link —
  **FAILED** (bot protection)
- **[Phase 5]** `grep sja1105_cls_flower_add` — called via
  `dsa_user_add_cls_flower()` in `net/dsa/user.c:1603`
- **[Phase 5]** Read `dsa_port_from_netdev()` in
  `net/dsa/dsa.c:1703-1709` — returns port for any DSA user netdev
- **[Phase 5]** `grep "dp->ds != ds"` in sja1105 — found at
  `sja1105_main.c:223,598`
- **[Phase 5]** `grep multiple_cascade_ports` — SJA1110 variants in
  `sja1105_spi.c`
- **[Phase 6]** `grep "local switch port"` / `to_dp->ds` in
  drivers/net/dsa — fix not present
- **[Phase 6]** Current tree lacks fix at lines 394-396
- **[Phase 7]** Read `drivers/net/dsa/sja1105/Kconfig` — driver scope
  confirmed
- **[Phase 8]** Assessed severity: forwarding misbehavior, not kernel
  crash
- **UNVERIFIED:** Lore discussion content, stable nomination, mainline
  commit hash, kernel-memory OOB (hardware destport misuse verified
  instead)

**YES**

 drivers/net/dsa/sja1105/sja1105_flower.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 05d8ed3121e7f..172fc163e1850 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -391,9 +391,9 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 			struct dsa_port *to_dp;
 
 			to_dp = dsa_port_from_netdev(act->dev);
-			if (IS_ERR(to_dp)) {
+			if (IS_ERR(to_dp) || to_dp->ds != ds) {
 				NL_SET_ERR_MSG_MOD(extack,
-						   "Destination not a switch port");
+						   "Destination not a local switch port");
 				return -EOPNOTSUPP;
 			}
 
-- 
2.53.0

