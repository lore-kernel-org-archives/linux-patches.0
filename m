Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767D049E5CB;
	Mon, 31 Aug 2026 13:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183640; cv=none; b=fNOAVxvjyHq162XoYU0fwdE7eMSNVPo2v6k8dmfiHeGmKCWdnyJtu7JqkQ3iM204QZAY9whl7vagp7zY4J4WNFUaPcdTi4BdPmirKtjjLXHCM9PK+aOuti3bv4M3RL/y0vhzp262IwLN1w4jULRG8sV8Z6YPbhfATNJZM6+9cN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183640; c=relaxed/simple;
	bh=2H75Q5WTF1kCro2MfHiy5dOsmOgvGOwONkC21k1X3ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uxfX9DLT2at4183tW5DtiY2mEZQ8mw5OthGRvdMkQk+3lTptKWITvJ9WTUYksEzb6sHAeMAkvuS2+9XbMdHZwW7sVTLik4c015nUVxzV1MIXbZzmLGbb5iTEfgSQ2vC0SoO52aJ0i3oVGV2o4Lgp15sm7uHIedUoN/yZbLI5OHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K63XpL49; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K63XpL49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9461F00A3D;
	Mon, 31 Aug 2026 13:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183637;
	bh=mLH1mFgEoCag+jhcQrJJ6P7irHV75VnN7u7Kj0YD7V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K63XpL49IRnNMvPAxxKxIDGM0eAGgsJYE/6nfX9sd7bIx7zTKkVN64HU5Wt7vCg+R
	 urY7zynlHUuoI7kFaUwx3hNJW6lDf4G/3Dm5G4Dy5tesCuhRM4w51cxrAhJLG+g3qS
	 0hhF+XyJIf6k9kqemhkajhjTV0eK1oladiKxI9SBMZZGPnwo/6c1mE7BniD7SRqZsL
	 7I2HDkJErr2UzFeFHzdU8pl5qntbEaAeVv8YuGN6Y6cprgPh0W5lNjzSqGiqTHD05W
	 TqPOESptjytJ3JxOy8V1IN0E/xbz6K5DgSX66jtvHtaPEA/W5+3pYJlKHsPN2PBSUg
	 rqF+4pbchahLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	=?UTF-8?q?=C5=81ukasz=20Stelmach?= <steelman@post.pl>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	dsahern@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ipv6: addrconf: fix temp address generation after prefix deprecation
Date: Mon, 31 Aug 2026 09:24:00 -0400
Message-ID: <20260831133314.4125787-212-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit e20d8922aa8fe441d291364c96c2179a005b79ea ]

When a router temporarily deprecates an IPv6 prefix (either by sending a
Router Advertisement with Preferred Lifetime = 0 or by letting the
lifetime expire) and later restores it, the kernel permanently loses its
ability to generate temporary privacy addresses (RFC 8981) for that
prefix.

This happens because the address worker attempts to generate a
replacement temporary address when the current one nears expiration. As
the base prefix is deprecated already, the generation fails after
marking the temporary address as already having spawned a replacement
(ifp->regen_count++).

When the router eventually restores the prefix, the temporary address
becomes active again. However, once it naturally expires, the address
worker sees this temporary address already tried to generate one and
skips the regeneration.

Fix the issue by resetting the regen_count check of the latest temp
address generated for the prefix updated by the incoming RA.

Reported-by: Łukasz Stelmach <steelman@post.pl>
Closes: https://lore.kernel.org/netdev/87340td30q.fsf%25steelman@post.pl/
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260523103811.3790-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
# Stable Backport Analysis: `ipv6: addrconf: fix temp address generation
after prefix deprecation`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, detached HEAD)
**Mainline commit:** `e20d8922aa8fe` (not yet in this tree; `git merge-
base --is-ancestor` returned 1)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ipv6: addrconf]` `[fix]` — restores temporary IPv6 privacy
address generation after a prefix is deprecated and later restored via
Router Advertisement.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Reported-by | Łukasz Stelmach \<steelman@post.pl\> |
| Closes |
https://lore.kernel.org/netdev/87340td30q.fsf%25steelman@post.pl/ |
| Suggested-by | Ido Schimmel \<idosch@nvidia.com\> |
| Reviewed-by | Ido Schimmel \<idosch@nvidia.com\> |
| Link | https://patch.msgid.link/20260523103811.3790-1-fmancera@suse.de
|
| Signed-off-by | Fernando Fernandez Mancera, Jakub Kicinski |

**Notable patterns:** Real user report; subsystem expert review; no
`Fixes:` tag (expected for manual review); no `Cc: stable` (expected).

### Step 1.3: Body analysis
**Record:**
- **Bug:** After a router temporarily deprecates an IPv6 prefix (RA with
  Preferred Lifetime = 0, or natural expiry) and later restores it, the
  kernel permanently stops generating RFC 8981 temporary privacy
  addresses for that prefix.
- **Symptom:** Privacy extensions silently stop working for the affected
  prefix until reboot or manual intervention.
- **Root cause:** `addrconf_verify_rtnl()` increments `regen_count` on
  the temporary address before attempting replacement generation. While
  the prefix is deprecated, `ipv6_create_tempaddr()` fails, but
  `regen_count` stays non-zero. When the prefix is restored,
  `manage_tempaddrs()` updates lifetimes but never clears `regen_count`,
  so future regeneration is permanently skipped (`!ifp->regen_count`
  guard).

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit, well-described functional bug fix,
not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `net/ipv6/addrconf.c` (+9 / −1 lines)
- **Functions:** `ipv6_add_addr()`, `manage_tempaddrs()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow per hunk

**Hunk 1 (`ipv6_add_addr`, ~line 1182):**
- **Before:** Temp addresses added to head of `tempaddr_list` with no
  comment.
- **After:** Documents that `manage_tempaddrs()` depends on head
  insertion order.
- **Path:** Address creation for temporary addresses.

**Hunk 2 (`manage_tempaddrs`, ~lines 2603–2648):**
- **Before:** On RA lifetime update, temp address lifetimes/flags
  updated; `regen_count` never reset.
- **After:** Saves `orig_prefered_lft`; on first matching temp address
  for the public prefix, if `orig_prefered_lft > 0`, resets
  `ift->regen_count = 0`.
- **Path:** Normal RA processing when prefix lifetimes are updated.

### Step 2.3: Bug mechanism
**Record:** **Logic / correctness fix** — stale `regen_count` state on
temporary addresses after a failed regeneration attempt during prefix
deprecation blocks all future regeneration. The fix clears that one-shot
flag when a positive preferred lifetime is received, indicating the
prefix is preferred again.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Yes — resets stale state at the exact point
  prefix restoration is signaled (incoming RA with `prefered_lft > 0`).
- **Minimal:** Yes — 9 lines of functional change plus 1 comment.
- **Regression risk:** Low — only resets `regen_count` on the most
  recent temp address (list head, first `ifpub` match); new temp
  addresses already have `regen_count == 0`; resetting `0 → 0` is a no-
  op on normal RAs.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `manage_tempaddrs()` introduced in `53bd674915379` (Dec
2013, IFA_F_MANAGETEMPADDR). `regen_count` logic dates to
`291d809ba5c8d` (2005). Buggy interaction between deprecation and
`regen_count` is in long-standing SLAAC/privacy code present since
privacy extensions were integrated.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Bug is architectural (missing state
reset), not introduced by a single recent commit.

### Step 3.3: Related file history
**Record:** Related prior fixes in this file:
- `a11a7f71cac20` — fix generation of new temporary addresses (2017)
- `778964f2fdf05` — fix timing bug in tempaddr regen
- `69172f0bcb6a0` — fix mngtmpaddr deletion creating unwanted temp
  addresses

This fix is in the same problem domain and is standalone.

### Step 3.4: Author context
**Record:** Fernando Fernandez Mancera is an active ipv6/addrconf
contributor (multiple recent sysctl and addrconf fixes in this tree).
Ido Schimmel (reviewer) is a networking expert at NVIDIA.

### Step 3.5: Dependencies
**Record:** Part of a 2-patch series (`[PATCH 1/2]` fix, `[PATCH 2/2]`
selftest). **The kernel fix is self-contained**; patch 2/2 is a
`fib_tests` selftest and is not required for the fix to work. No
structural or API prerequisites.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c e20d8922aa8fe`:
  https://patch.msgid.link/20260523103811.3790-1-fmancera@suse.de
- Series went through v1–v5; committed version is latest (v5).
- Applied to netdev/net-next by Jakub Kicinski (May 27, 2026).
- Reporter Łukasz Stelmach replied with `Reviewed-by: Ido Schimmel`
  confirmation in thread.
- **No explicit `Cc: stable` nomination found** in thread.
- **No NAKs found.**

### Step 4.2: Reviewers
**Record:** CC'd: netdev, linux-kselftest, Paolo Abeni, Eric Dumazet,
David Miller, Ido Schimmel, David Ahern — appropriate maintainer
coverage. Reviewed-by from Ido Schimmel.

### Step 4.3: Bug report
**Record:** Original report at `Closes:` URL (lore.kernel.org blocked by
bot protection in WebFetch). Reporter is also in-thread confirming the
fix. Severity from reporter's perspective: permanent loss of privacy
address capability — functional regression with privacy impact.

### Step 4.4: Series context
**Record:** Patch 2/2 adds selftest `fib_tests: add temporary IPv6
address renewal test` — optional for stable; not a dependency.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — could not search lore stable list (bot
protection). No stable nomination found in saved mbox thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ipv6_add_addr()`, `manage_tempaddrs()`, (bug trigger in)
`addrconf_verify_rtnl()`, `ipv6_create_tempaddr()`

### Step 5.2: Callers of `manage_tempaddrs()`
**Record:**
- `addrconf_prefix_rcv_add_addr()` — RA prefix processing (primary fix
  path, line 2779)
- Manual address add with `IFA_F_MANAGETEMPADDR` (line 3085)
- Address modification path (line 4953)

All are normal networking/SLAAC paths triggered by RAs or admin
configuration.

### Step 5.3: Key callees
**Record:** `manage_tempaddrs()` may call `ipv6_create_tempaddr()`; uses
`idev->lock`, per-address `ift->lock`; updates `valid_lft`,
`prefered_lft`, `flags`.

### Step 5.4: Reachability
**Record:**
```
Router Advertisement → addrconf_prefix_rcv() →
addrconf_prefix_rcv_add_addr()
  → manage_tempaddrs()  [fix resets regen_count here]

Periodic timer → addrconf_verify_work() → addrconf_verify_rtnl()
  → checks !ifp->regen_count → ipv6_create_tempaddr()  [bug: skips if
stale]
```
**Userspace trigger:** Any host receiving IPv6 RAs with changing prefix
lifetimes — common on enterprise/Wi-Fi/mobile networks. Requires
`use_tempaddr > 0` (privacy extensions enabled; default sysctl is 0, but
widely enabled by distributions).

### Step 5.5: Similar patterns
**Record:** `ifpub->regen_count = 0` is already reset in
`addrconf_verify_rtnl()` before calling `ipv6_create_tempaddr()` (line
4673), but the **temporary address's** `regen_count` was not reset on
prefix restoration — asymmetric handling that this patch corrects.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.y)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current `manage_tempaddrs()` at lines 2608–2659 has
no `regen_count` reset. `addrconf_verify_rtnl()` at line 4657 still
gates on `!ifp->regen_count`. `list_add()` at line 1183 still adds to
list head. Bug is present in v6.18.44.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Tested with `git cherry-pick --no-
commit e20d8922aa8fe` → `Auto-merging net/ipv6/addrconf.c` (no
conflicts).

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix in this tree. `git log --grep="prefix
deprecation"` on addrconf.c returned no match for this fix.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **net/ipv6/addrconf** — IMPORTANT (core IPv6 stack; affects
all IPv6-capable systems with privacy extensions enabled).

### Step 7.2: Activity
**Record:** Actively maintained; multiple addrconf fixes in recent
6.18.y history (sysctl error handling, UaF fixes, DAD fixes).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Systems with IPv6 privacy extensions enabled (`use_tempaddr
> 0`) using SLAAC-managed temporary addresses, on networks where routers
temporarily deprecate prefixes (maintenance, RA reconfiguration,
lifetime expiry). Not universal (requires privacy extensions), but
affects a meaningful production population.

### Step 8.2: Trigger conditions
**Record:**
1. Prefix deprecated (Preferred Lifetime = 0 or expires)
2. Temp address nears expiration → worker tries regeneration → fails →
   `regen_count` stuck
3. Prefix restored via RA with positive preferred lifetime
4. Temp address eventually expires → no new temp address generated

**Likelihood:** Realistic on managed networks. Not timing-dependent
race.

### Step 8.3: Failure severity
**Record:** **MEDIUM-HIGH** — no crash, panic, or data corruption, but
**permanent functional regression** of RFC 8981 privacy address
generation for the affected prefix. Privacy/security degradation;
outbound connections using temp addresses may fail after old addresses
expire. Workaround requires reboot or toggling `use_tempaddr`.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected users — restores correct privacy
  address behavior after a common network event
- **Risk:** LOW — 9-line surgical change, expert-reviewed, applies
  cleanly
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real user-reported bug with clear reproduction scenario
- Expert-reviewed (`Reviewed-by: Ido Schimmel`)
- Small, surgical, obviously correct fix
- Buggy code present in 6.18.y; patch applies cleanly
- Restores RFC 8981 compliance — privacy-relevant
- Similar temp-address generation fixes have historically been accepted
  for stable
- Standalone (selftest patch not required)

**AGAINST backport:**
- Not a crash/Oops/deadlock/CVE — functional regression only
- Requires privacy extensions enabled (`use_tempaddr > 0`)
- Prefix deprecation/restoration cycle is not every-boot common (but
  realistic)

**Unresolved:** Original bug-report email body not readable (lore bot
protection); no explicit stable nomination in thread.

### Step 9.2: Stable rules checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — logic verified in code;
selftest exists in mainline series (patch 2/2) |
| 2. Fixes real bug affecting users? | **PASS** — user-reported,
reproducible scenario |
| 3. Important issue? | **PASS** — permanent privacy-address regression
(functional + privacy impact) |
| 4. Small and contained? | **PASS** — 10 lines, one file |
| 5. No new features/APIs? | **PASS** — state-reset bug fix only |
| 6. Can apply to local tree? | **PASS** — clean cherry-pick to v6.18.44
|

### Step 9.3: Exception categories
**Record:** N/A — standard bug fix, not device-ID/quirk/build/doc
exception.

### Step 9.4: Decision rationale

This commit fixes a longstanding logic error where a failed temporary-
address regeneration during prefix deprecation leaves `regen_count` set,
permanently blocking future regeneration after the prefix is restored.
For 6.18.y users running IPv6 privacy extensions, this is a real, user-
visible regression on a normal network event. The fix is minimal,
reviewed, applies cleanly, and matches the pattern of prior accepted
addrconf temp-address stable fixes.

---

## Verification

- **[Phase 1]** `git describe HEAD` → `v6.18.44`; parsed all commit
  message tags
- **[Phase 2]** Read `manage_tempaddrs()`, `addrconf_verify_rtnl()`,
  `ipv6_create_tempaddr()` in `/home/sasha/linux-
  autosel-7.0/net/ipv6/addrconf.c`; confirmed diff matches described
  behavior
- **[Phase 3]** `git blame -L 2608,2679` → `manage_tempaddrs` from 2013;
  `git log -S'regen_count'` → introduced 2005; related commits
  `a11a7f71cac20`, `778964f2fdf05` found
- **[Phase 3]** `git merge-base --is-ancestor e20d8922aa8fe HEAD` → exit
  1 (commit not in tree)
- **[Phase 4]** `b4 dig -c e20d8922aa8fe` → lore URL found; `-a` → v1–v5
  series; `-w` → netdev maintainers CC'd; `-m` → thread saved; no stable
  CC or NAK in mbox
- **[Phase 4]** WebFetch lore URLs → blocked by Anubis bot protection
  (UNVERIFIED for original bug-report body)
- **[Phase 5]** `grep manage_tempaddrs` → 3 call sites; traced RA →
  `addrconf_prefix_rcv_add_addr()` → `manage_tempaddrs()` path; verified
  `!ifp->regen_count` guard at line 4657 and `ifp->regen_count++` at
  line 4667
- **[Phase 5]** Verified `list_add()` at line 1183 adds to head
  (supports "first match = most recent" logic)
- **[Phase 6]** Confirmed buggy code present (no
  `reset_done`/`orig_prefered_lft` in current tree)
- **[Phase 6]** `git cherry-pick --no-commit e20d8922aa8fe` → auto-
  merges cleanly
- **[Phase 7]** `git log --oneline -15 -- net/ipv6/addrconf.c` → active
  subsystem
- **[Phase 8]** Assessed severity as MEDIUM-HIGH functional/privacy
  regression (not crash)

**YES**The background checks finished and line up with the earlier
analysis:

- **Commit not in 6.18.y** — `e20d8922aa8fe` is on `master` but not an
  ancestor of the current `v6.18.44` tree.
- **Buggy code is present** — no matching fix in this tree; related
  history only shows older temp-address work (`778964f2fdf05`,
  `00b5b7aab9e42`, etc.).
- **Verdict stands: YES** — small, reviewed fix for a real privacy-
  address regression; cherry-picks cleanly onto 6.18.y.

 net/ipv6/addrconf.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index c98b1b919f18c..80706368a303c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1180,6 +1180,7 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 	ipv6_link_dev_addr(idev, ifa);
 
 	if (ifa->flags&IFA_F_TEMPORARY) {
+		/* manage_tempaddrs() relies on addresses being added to the head */
 		list_add(&ifa->tmp_list, &idev->tempaddr_list);
 		in6_ifa_hold(ifa);
 	}
@@ -2610,8 +2611,10 @@ static void manage_tempaddrs(struct inet6_dev *idev,
 			     __u32 valid_lft, __u32 prefered_lft,
 			     bool create, unsigned long now)
 {
-	u32 flags;
+	u32 orig_prefered_lft = prefered_lft;
 	struct inet6_ifaddr *ift;
+	bool reset_done = false;
+	u32 flags;
 
 	read_lock_bh(&idev->lock);
 	/* update all temporary addresses in the list */
@@ -2646,6 +2649,11 @@ static void manage_tempaddrs(struct inet6_dev *idev,
 			prefered_lft = max_prefered;
 
 		spin_lock(&ift->lock);
+		/* the first match is the most recent temp address */
+		if (!reset_done && orig_prefered_lft > 0) {
+			ift->regen_count = 0;
+			reset_done = true;
+		}
 		flags = ift->flags;
 		ift->valid_lft = valid_lft;
 		ift->prefered_lft = prefered_lft;
-- 
2.53.0

