Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5ACC4218A2;
	Mon, 20 Apr 2026 13:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691657; cv=none; b=M4CIzynOn6ykrBoLU7LYHX5PyZGvUiawTJ34g+ppgmXzFvYsxojb+EW+19bVlfqY+TbKXdseeH1bHeqeA5o1SSidZBL5bMAdgdl5u5g/s8xL9GzPQcVW8pye/O4futalYLzWbhuieP+4DDA7iGOxup602vxx6+qzsdb78esUxu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691657; c=relaxed/simple;
	bh=0HBnHGMO/SednIxioApgmmoYthCJijda6FX6aCko9Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzxTYzTN8W2BXhH01BBXcRNKUe4A9y1qFWLiJeEZrAiTvBqOWerHbN68eynq8kpaeU1ukKFutZZnHO54GG1UIeNbudVf76N4XiziLXIKsxBhEc97ZIOb1jdmPY9C2yOcmKBfrniMe/JPjBSrsF5h1Bs/olRQ23+JvNH/w9fX/ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B74u/HEm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B74u/HEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7660CC2BCB6;
	Mon, 20 Apr 2026 13:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691656;
	bh=0HBnHGMO/SednIxioApgmmoYthCJijda6FX6aCko9Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B74u/HEmRw/G4TO4jEgrVhycy9lYvOnhkkR8Q/X7yGYWxssK+Yw6qpbZ9iJj3AwB6
	 stZ2ETIHOTi3hN6336/uZDD7HtRyxjoz/yNbVDCe5UaPVWhbXCDPH1IGKrAHXqLMr2
	 bCZWtiDA7GW2QWPwGRSY8kuAjXIcZ+v9Z0H/kYqB1ESpCIYBRUqR5hm0VN3A6AsxDT
	 64sLpPtLnW9wa26Vm0PPRIyjDZbrE6fFhqan5c0Y+jaYNnu+4vPxsEhCA/hPMQPXU7
	 22c/Lbzk04t9XHSryyLBIf4A1cJlCJ7M/jClTFbOu7JzBmJbvnp56ZanRqni2N/+LC
	 RLaGezl86E4OQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] ipv4: validate IPV4_DEVCONF attributes properly
Date: Mon, 20 Apr 2026 09:19:10 -0400
Message-ID: <20260420132314.1023554-156-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit fa8fca88714c3a4a74f972ed37328e2f0bbef9fa ]

As the IPV4_DEVCONF netlink attributes are not being validated, it is
possible to use netlink to set read-only values like mc_forwarding. In
addition, valid ranges are not being validated neither but that is less
relevant as they aren't in sysctl.

To avoid similar situations in the future, define a NLA policy for
IPV4_DEVCONF attributes which are nested in IFLA_INET_CONF.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260312142637.5704-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good - confirmed that v6.12 has the same vulnerable code. The
RTM_SETLINK path requires `CAP_NET_ADMIN`, but this is available within
network namespaces (an unprivileged user can create a network namespace
and get CAP_NET_ADMIN there).

Now I have all the information I need to complete my analysis. Let me
compile the full assessment.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: [subsystem: ipv4] [action verb: validate] [Summary: Add proper
NLA validation policy for IPV4_DEVCONF netlink attributes nested in
IFLA_INET_CONF]

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Signed-off-by**: Fernando Fernandez Mancera <fmancera@suse.de>
  (author)
- **Link**:
  https://patch.msgid.link/20260312142637.5704-1-fmancera@suse.de
- **Signed-off-by**: Jakub Kicinski <kuba@kernel.org> (net subsystem
  maintainer, applied it)
- No Fixes: tag (expected)
- No Cc: stable tag (expected)
- No Reported-by (the author found the issue themselves)

Record: Patch applied by Jakub Kicinski (net maintainer). No explicit
stable nomination. No Fixes tag (the bug exists since the original 2010
code, commit 9f0f7272ac95).

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit message clearly describes:
- **Bug**: IPV4_DEVCONF netlink attributes are not being validated
- **Consequence 1**: Read-only values like `mc_forwarding` can be set
  via netlink - this is a security bypass
- **Consequence 2**: Valid ranges are not enforced (less critical)
- **Fix approach**: Define a NLA policy for IPV4_DEVCONF attributes

Record: Bug = missing input validation on netlink attributes. Allows
bypassing read-only restrictions (mc_forwarding). mc_forwarding is
kernel-managed and should only be set by the multicast routing daemon
via ip_mroute_setsockopt(). Setting it directly breaks multicast routing
assumptions.

### Step 1.4: DETECT HIDDEN BUG FIXES
This is explicitly described as a validation/security fix. The word
"validate" in the subject and the clear description of the bypass make
this obviously a bug fix.

Record: This is a direct security/correctness fix, not a hidden one.

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
- **File**: `net/ipv4/devinet.c` - single file modification
- **Added**: ~38 lines (new policy table `inet_devconf_policy`) + ~7
  lines (new validation code)
- **Removed**: ~10 lines (old manual validation loop)
- **Net change**: approximately +35 lines
- **Functions modified**: `inet_validate_link_af` (rewritten validation
  logic)
- **Scope**: Single-file, well-contained change

Record: 1 file changed, +45/-10 lines. Modified function:
`inet_validate_link_af`. New static const: `inet_devconf_policy`. Scope:
single-file surgical fix.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Before**: `inet_validate_link_af` only checked that each nested
attribute had length >= 4 and a valid cfgid in range [1,
IPV4_DEVCONF_MAX]. No per-attribute validation, no rejection of read-
only fields, no range checking.

**After**: Uses `nla_parse_nested()` with a proper policy table
(`inet_devconf_policy`) that:
1. **Rejects** `MC_FORWARDING` writes via `NLA_REJECT`
2. **Range-validates** boolean attributes to {0,1}
3. **Range-validates** multi-value attributes (RP_FILTER: 0-2,
   ARP_IGNORE: 0-8, etc.)
4. **Type-validates** all attributes as NLA_U32

Record: Before = minimal bounds check only. After = full NLA policy-
based validation with per-attribute type, range, and reject rules.
Critical change: MC_FORWARDING is now NLA_REJECT.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Category**: Logic/correctness fix + Security fix (missing input
validation)

The bug mechanism:
1. User sends RTM_SETLINK with IFLA_AF_SPEC containing AF_INET with
   IFLA_INET_CONF
2. `inet_validate_link_af` only checked length and range of attribute
   IDs
3. `inet_set_link_af` called `ipv4_devconf_set(in_dev, nla_type(a),
   nla_get_u32(a))` for ALL attributes
4. `ipv4_devconf_set` directly writes to `in_dev->cnf.data[]` with
   WRITE_ONCE - no per-attribute filtering
5. This means mc_forwarding (a read-only sysctl at 0444 permissions)
   could be set via netlink
6. mc_forwarding is managed by the kernel's multicast routing subsystem
   and manipulated by ipmr.c

Record: Missing input validation allows bypassing read-only restrictions
via netlink. The `ipv4_devconf_set` function blindly sets any config
value. The old validate function only checked bounds, not per-attribute
rules.

### Step 2.4: ASSESS THE FIX QUALITY
- The fix is obviously correct: it uses the standard NLA policy
  mechanism
- It is well-contained: single file, one function modified, one policy
  table added
- Regression risk is low: the policy table is conservative (allows all
  previously-allowed valid inputs)
- The `nla_parse_nested()` (non-deprecated) enforces NLA_F_NESTED flag,
  which is slightly stricter than the old code. This is intentional and
  correct for modern netlink.
- Jakub Kicinski reviewed and applied it (net subsystem maintainer)

Record: Fix is obviously correct, uses standard kernel NLA policy
infrastructure. Low regression risk. Applied by the net subsystem
maintainer.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
The vulnerable validation code was introduced in commit `9f0f7272ac9506`
(Thomas Graf, November 2010, v2.6.37-rc1). This code has been present in
the kernel for ~15 years and exists in ALL active stable trees.

Record: Buggy code from commit 9f0f7272ac95 (2010, v2.6.37-rc1). Present
in every stable tree.

### Step 3.2: FOLLOW THE FIXES TAG
No Fixes: tag present (the bug dates to the original 2010
implementation, so a Fixes tag would reference 9f0f7272ac95).

Record: N/A - no Fixes tag. Bug originates from commit 9f0f7272ac95.

### Step 3.3: CHECK FILE HISTORY
The `inet_validate_link_af` function has not been significantly modified
since its creation. The only changes were the addition of the `extack`
parameter (2021, commit 8679c31e0284) and a minor check adjustment
(commit a100243d95a60d, 2021). The core validation logic was untouched
for 15 years.

Record: Standalone fix. No dependencies on other patches. The function
is identical across v6.1, v6.6, and v6.12.

### Step 3.4: CHECK THE AUTHOR
Fernando Fernandez Mancera is a contributor from SUSE. He submitted
follow-up patches to also centralize devconf post-set actions, showing
deep understanding of the subsystem.

Record: Author is an active contributor. Follow-up series planned.

### Step 3.5: CHECK FOR DEPENDENCIES
This patch is standalone. The follow-up patches (centralize devconf
handling, handle post-set actions) are separate and NOT required for
this fix to work. This patch only adds validation; it does not change
the set behavior.

Record: No dependencies. Standalone fix. Can apply independently.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: ORIGINAL PATCH DISCUSSION
Found at:
https://yhbt.net/lore/netdev/20260304180725.717a3f0d@kernel.org/T/

The patch went through v1 -> v2 (no changes) -> v3 (dropped Fixes tag,
adjusted MEDIUM_ID to NLA_S32) -> final applied version (addressed
Jakub's v3 review: NLA_POLICY_MIN for MEDIUM_ID, ARP_ACCEPT range 0-2).

Jakub Kicinski's v3 review asked two questions:
1. MEDIUM_ID validation type - fixed by using NLA_POLICY_MIN()
2. ARP_ACCEPT should accept 2 - fixed in final version

Record: Thread at yhbt.net mirror. Patch went v1->v3->applied. Jakub
reviewed v3, feedback addressed in applied version. Maintainer applied
it.

### Step 4.2: REVIEWER
Jakub Kicinski (net maintainer) reviewed and applied. All major net
maintainers were CC'd (horms, pabeni, edumazet, dsahern, davem).

Record: Net maintainer reviewed and applied. All relevant people were
CC'd.

### Step 4.3: BUG REPORT
No external bug report - author found the issue by code inspection.

### Step 4.4: RELATED PATCHES
Follow-up series (March 25, 2026): "centralize devconf sysctl handling"
+ "handle devconf post-set actions on netlink updates". These are NOT
required for this fix - they improve consistency of behavior when values
are set via netlink vs sysctl.

Record: Follow-up patches exist but are not prerequisites.

### Step 4.5: STABLE DISCUSSION
No specific stable mailing list discussion found. The v3 note says
"dropped the fixes tag" - suggesting the author initially considered
this a fix but removed the Fixes tag (perhaps because it traces back to
2010).

Record: No stable-specific discussion. Author initially had a Fixes tag
but dropped it.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS
- `inet_validate_link_af` - modified
- New: `inet_devconf_policy` static const policy table

### Step 5.2: TRACE CALLERS
`inet_validate_link_af` is called from `rtnetlink.c` via
`af_ops->validate_link_af(dev, af, extack)` at line 2752. This is in the
`do_validate_setlink` path, called during RTM_SETLINK processing.
RTM_SETLINK is a standard netlink message used by `ip link set`.

Record: Called from RTM_SETLINK path. Trigger: `ip link set dev <DEV>
...` with AF_INET options.

### Step 5.3: TRACE CALLEES
Uses `nla_parse_nested()` which validates against the policy and returns
error if validation fails. This is the standard kernel netlink
validation infrastructure.

### Step 5.4: CALL CHAIN
User space -> RTM_SETLINK -> rtnl_setlink() -> do_setlink() -> validate
loop -> inet_validate_link_af() -> if passes -> inet_set_link_af() ->
ipv4_devconf_set()

Reachable from: any process with CAP_NET_ADMIN (including unprivileged
users in a network namespace).

Record: Reachable from userspace via RTM_SETLINK. CAP_NET_ADMIN
required, but available in network namespaces.

### Step 5.5: SIMILAR PATTERNS
IPv6 has `inet6_validate_link_af` in `addrconf.c` which already has
proper validation.

Record: IPv6 equivalent already has proper validation. IPv4 was the
outlier.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: BUGGY CODE IN STABLE TREES
The vulnerable code (commit 9f0f7272ac95 from 2010) exists in ALL stable
trees: v5.4.y, v5.10.y, v5.15.y, v6.1.y, v6.6.y, v6.12.y, etc.

Verified: `inet_validate_link_af` is identical in v6.1, v6.6, and v6.12.

Record: Bug exists in all active stable trees.

### Step 6.2: BACKPORT COMPLICATIONS
- For v6.1+: Patch should apply cleanly (verified code is identical)
- For v5.15: Needs minor adjustment - `IPV4_DEVCONF_ARP_EVICT_NOCARRIER`
  doesn't exist (added in v5.16), so that policy entry must be removed
- `NLA_POLICY_RANGE`, `NLA_REJECT`, `NLA_POLICY_MIN`, `nla_parse_nested`
  all exist since v4.20+

Record: Clean apply for v6.1+. Minor adjustment for v5.15 (remove
ARP_EVICT_NOCARRIER). All infrastructure available.

### Step 6.3: RELATED FIXES IN STABLE
No related fixes found.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
**Subsystem**: net/ipv4 (core IPv4 networking)
**Criticality**: CORE - affects all users (IPv4 is used by virtually
every system)

Record: CORE subsystem. IPv4 networking affects all users.

### Step 7.2: SUBSYSTEM ACTIVITY
`net/ipv4/devinet.c` is actively maintained with regular commits.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
All users. IPv4 networking is universal. Any system with network
namespaces enabled is particularly at risk because unprivileged users
can create network namespaces and gain CAP_NET_ADMIN there.

Record: Universal impact. Especially relevant for containerized
environments.

### Step 8.2: TRIGGER CONDITIONS
- **Trigger**: Send RTM_SETLINK netlink message with IFLA_AF_SPEC /
  AF_INET / IFLA_INET_CONF containing MC_FORWARDING attribute
- **Privilege**: CAP_NET_ADMIN (available in network namespaces, so
  effectively unprivileged)
- **Ease**: Trivial to trigger programmatically with a simple netlink
  socket

Record: Easy to trigger. CAP_NET_ADMIN in netns = effectively
unprivileged. Deterministic trigger (not a race).

### Step 8.3: FAILURE MODE SEVERITY
- **mc_forwarding bypass**: This is a read-only sysctl (0444) that
  should only be managed by the kernel's multicast routing subsystem.
  Setting it externally can corrupt multicast routing state, potentially
  leading to unexpected multicast forwarding behavior or denial of
  multicast routing.
- **Range validation bypass**: Out-of-range values for other devconf
  settings could cause unexpected networking behavior.
- **Security classification**: This is an access control bypass - a
  value that should be read-only can be written. While it requires
  CAP_NET_ADMIN, in containerized environments this is available to
  unprivileged users.

Record: Severity HIGH. Access control bypass for read-only network
configuration. Potential for multicast routing state corruption.

### Step 8.4: RISK-BENEFIT RATIO
**BENEFIT**: HIGH - Fixes input validation gap in core IPv4 networking
code that has existed for 15 years. Prevents unauthorized modification
of read-only network configuration.

**RISK**: LOW - The fix uses standard kernel NLA policy infrastructure.
The policy table is a new static const (no runtime allocation). The
validation function replacement is straightforward. The only behavioral
change is rejecting previously-accepted-but-invalid inputs (which is the
desired behavior).

Record: HIGH benefit, LOW risk. Favorable ratio.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILATION

**FOR backporting:**
1. Fixes a real access control bypass (mc_forwarding writable despite
   being read-only sysctl)
2. Fixes missing input validation in core IPv4 networking code
3. Bug has existed since 2010 (v2.6.37-rc1), affects all stable trees
4. Small, contained fix - single file, uses standard NLA policy
   infrastructure
5. Applied by net subsystem maintainer (Jakub Kicinski)
6. Deterministic trigger, easy to exploit from network namespace
7. IPv4 networking is universal - affects all users
8. Patch applies cleanly to all recent stable trees (v6.1+)

**AGAINST backporting:**
1. No Fixes: tag (though author initially had one and dropped it since
   bug is from 2010)
2. No Cc: stable tag (expected)
3. Size is moderate (~45 lines added) due to the policy table
4. Submitted as net-next (not net), suggesting author didn't consider it
   urgent
5. Requires CAP_NET_ADMIN (though available in netns)

**UNRESOLVED:**
- Exact impact of writing mc_forwarding is limited (networking state
  corruption, not crash/security exploit per se)

### Step 9.2: STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES - uses standard NLA policy;
   reviewed by net maintainer
2. **Fixes a real bug?** YES - access control bypass for read-only
   devconf values
3. **Important issue?** YES - security-relevant input validation in core
   networking
4. **Small and contained?** YES - single file, well-understood change
5. **No new features or APIs?** YES - only adds validation, no new user-
   visible behavior
6. **Can apply to stable?** YES - cleanly to v6.1+ (minor adjustment for
   v5.15)

### Step 9.3: EXCEPTION CATEGORIES
Not an exception category - this is a standard bug fix.

### Step 9.4: DECISION
This commit fixes a real access control bypass in core IPv4 networking
that has existed since 2010. It prevents unauthorized modification of
read-only network configuration values (mc_forwarding) via netlink. The
fix is small, uses standard kernel infrastructure, was reviewed by the
net subsystem maintainer, and applies cleanly to all active stable
trees. While it requires CAP_NET_ADMIN, this is available in network
namespaces, making it relevant for containerized environments. The risk-
benefit ratio strongly favors backporting.

## Verification

- [Phase 1] Parsed tags: Signed-off-by Fernando Fernandez Mancera +
  Jakub Kicinski. Link to patch.msgid.link.
- [Phase 2] Diff analysis: +45/-10 lines in single file. Adds
  inet_devconf_policy static const with NLA_REJECT for MC_FORWARDING.
  Rewrites inet_validate_link_af to use nla_parse_nested with policy.
- [Phase 3] git blame: Buggy code introduced in commit 9f0f7272ac95
  (2010, v2.6.37-rc1), present in all stable trees.
- [Phase 3] git show v6.1/v6.6/v6.12: inet_validate_link_af is identical
  across all stable trees - patch applies cleanly.
- [Phase 3] git show v5.15 include/uapi/linux/ip.h:
  IPV4_DEVCONF_ARP_EVICT_NOCARRIER not present (added v5.16) - minor
  adjustment needed.
- [Phase 4] Found original discussion at yhbt.net mirror: patch went
  v1->v3->applied. Jakub reviewed v3 with two comments (MEDIUM_ID and
  ARP_ACCEPT), both addressed in final version.
- [Phase 4] Follow-up series (centralize devconf handling) exists but is
  not a dependency.
- [Phase 5] Traced call chain: userspace -> RTM_SETLINK ->
  rtnl_setlink() -> do_setlink() -> inet_validate_link_af() ->
  inet_set_link_af() -> ipv4_devconf_set(). CAP_NET_ADMIN required but
  available in network namespaces.
- [Phase 5] Verified ipv4_devconf_set() blindly writes to cnf.data[]
  with WRITE_ONCE (include/linux/inetdevice.h:67-73).
- [Phase 5] Verified MC_FORWARDING is managed by ipmr.c
  (IPV4_DEVCONF(in_dev->cnf, MC_FORWARDING)++ / --).
- [Phase 6] Verified NLA_POLICY_RANGE exists since v4.20 (commit
  3e48be05f3c7), NLA_REJECT since similar era. All infrastructure
  available in all stable trees.
- [Phase 6] RTM_SETLINK permission: line 6921 of rtnetlink.c checks
  `netlink_net_capable(skb, CAP_NET_ADMIN)`, confirmed userspace-
  reachable.
- [Phase 7] Subsystem: net/ipv4 = CORE, affects all users.
- [Phase 8] Failure mode: access control bypass, read-only value
  writable. Severity: HIGH.
- UNVERIFIED: Exact security implications of writing arbitrary
  mc_forwarding values (could not find CVE or explicit exploit
  analysis). However, the principle of read-only bypass is itself
  security-relevant.

**YES**

 net/ipv4/devinet.c | 55 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 537bb6c315d2e..58fe7cb69545c 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2063,12 +2063,50 @@ static const struct nla_policy inet_af_policy[IFLA_INET_MAX+1] = {
 	[IFLA_INET_CONF]	= { .type = NLA_NESTED },
 };
 
+static const struct nla_policy inet_devconf_policy[IPV4_DEVCONF_MAX + 1] = {
+	[IPV4_DEVCONF_FORWARDING]	= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_MC_FORWARDING]	= { .type = NLA_REJECT },
+	[IPV4_DEVCONF_PROXY_ARP]	= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_ACCEPT_REDIRECTS]	= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_SECURE_REDIRECTS]	= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_SEND_REDIRECTS]	= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_SHARED_MEDIA]	= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_RP_FILTER]	= NLA_POLICY_RANGE(NLA_U32, 0, 2),
+	[IPV4_DEVCONF_ACCEPT_SOURCE_ROUTE] = NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_BOOTP_RELAY]	= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_LOG_MARTIANS]	= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_TAG]		= { .type = NLA_U32 },
+	[IPV4_DEVCONF_ARPFILTER]	= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_MEDIUM_ID]	= NLA_POLICY_MIN(NLA_S32, -1),
+	[IPV4_DEVCONF_NOXFRM]		= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_NOPOLICY]		= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_FORCE_IGMP_VERSION] = NLA_POLICY_RANGE(NLA_U32, 0, 3),
+	[IPV4_DEVCONF_ARP_ANNOUNCE]	= NLA_POLICY_RANGE(NLA_U32, 0, 2),
+	[IPV4_DEVCONF_ARP_IGNORE]	= NLA_POLICY_RANGE(NLA_U32, 0, 8),
+	[IPV4_DEVCONF_PROMOTE_SECONDARIES] = NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_ARP_ACCEPT]	= NLA_POLICY_RANGE(NLA_U32, 0, 2),
+	[IPV4_DEVCONF_ARP_NOTIFY]	= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_ACCEPT_LOCAL]	= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_SRC_VMARK]	= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_PROXY_ARP_PVLAN]	= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_ROUTE_LOCALNET]	= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_BC_FORWARDING]	= NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_IGMPV2_UNSOLICITED_REPORT_INTERVAL] = { .type = NLA_U32 },
+	[IPV4_DEVCONF_IGMPV3_UNSOLICITED_REPORT_INTERVAL] = { .type = NLA_U32 },
+	[IPV4_DEVCONF_IGNORE_ROUTES_WITH_LINKDOWN] =
+		NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_DROP_UNICAST_IN_L2_MULTICAST] =
+		NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_DROP_GRATUITOUS_ARP] = NLA_POLICY_RANGE(NLA_U32, 0, 1),
+	[IPV4_DEVCONF_ARP_EVICT_NOCARRIER] = NLA_POLICY_RANGE(NLA_U32, 0, 1),
+};
+
 static int inet_validate_link_af(const struct net_device *dev,
 				 const struct nlattr *nla,
 				 struct netlink_ext_ack *extack)
 {
-	struct nlattr *a, *tb[IFLA_INET_MAX+1];
-	int err, rem;
+	struct nlattr *tb[IFLA_INET_MAX + 1], *nested_tb[IPV4_DEVCONF_MAX + 1];
+	int err;
 
 	if (dev && !__in_dev_get_rtnl(dev))
 		return -EAFNOSUPPORT;
@@ -2079,15 +2117,12 @@ static int inet_validate_link_af(const struct net_device *dev,
 		return err;
 
 	if (tb[IFLA_INET_CONF]) {
-		nla_for_each_nested(a, tb[IFLA_INET_CONF], rem) {
-			int cfgid = nla_type(a);
+		err = nla_parse_nested(nested_tb, IPV4_DEVCONF_MAX,
+				       tb[IFLA_INET_CONF], inet_devconf_policy,
+				       extack);
 
-			if (nla_len(a) < 4)
-				return -EINVAL;
-
-			if (cfgid <= 0 || cfgid > IPV4_DEVCONF_MAX)
-				return -EINVAL;
-		}
+		if (err < 0)
+			return err;
 	}
 
 	return 0;
-- 
2.53.0

