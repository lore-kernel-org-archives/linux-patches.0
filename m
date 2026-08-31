Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED95566C58;
	Mon, 31 Aug 2026 13:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184095; cv=none; b=YMfMTUll878OUYTAEcNqj+aeCVCX4vPl3yrC8UgUdnPgf15ncMXZ2p2gJWUZqJS+FPpnRlXAaCKbGvuUMavmXneXE5xP4r+35+s0Q3++muW+HGOmaoendXPdJUT2aW2lO0Yf+vnFORc4x52EcAebImTnVTSsuPHXniXM6loRhQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184095; c=relaxed/simple;
	bh=d8iWgnIp6yXd9PebB7tlbj4DpHyFhBfco6h6XzfC+NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gXr8cPVJ3U/hxlP104UvYpzgRd3gBkSO0yFDEDLy5oPzDf4vKBSihexlN29P+xRzwcFinLU7vlvGxCblYsohaQldMmx5KQJoAquVNg6Ma/bTsBHnRlMCsE5QSPn4RUiGU1FjzolZBAbGeFuC6xgoWw0grD2U7yF+c29T9rtGeBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JxtE7QXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JxtE7QXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231001F00A3F;
	Mon, 31 Aug 2026 13:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184092;
	bh=gcUDc/YMYu8tt5GLt8IMZ7NcJOBB64p0HHW21MoPpMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JxtE7QXcOJqLWnhayzvKBTUstjKC4xbQprkAj3yX55nQSYZtGi11CqvOCebwSMOqT
	 mjAM1aaQIpWj5/n0iO3GHKDePoIJXzolt9Qcw2q8GRvh37I3tacLSllHqG2LWFLRK1
	 pXeoE58LckANFCHLyL3VZNbC2Dctxz3s337YNlaQ2W3Cqnhw7FID2Hh4jIMLnEphV6
	 iw2Msyz6WwKXbW8fQLP+Cr/n77esGzQ2UMbH4eVRm4ITUBd5McsAKlJkvH+ntG1jOj
	 Ar+mEToZRJdJD+oVTg1kc1mBzvqUsYWR2ego9+OhtvHsQI/Gtcv4nOvaciuZfaZAtA
	 td+HbQLz+7cfQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alice Mikityanska <alice@isovalent.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jhs@mojatatu.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net/sched: act_csum: don't mangle UDP tunnel GSO packets
Date: Mon, 31 Aug 2026 09:28:34 -0400
Message-ID: <20260831133314.4125787-486-sashal@kernel.org>
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

From: Alice Mikityanska <alice@isovalent.com>

[ Upstream commit 9bcb30b389ec5888590cb6ec58c7a3b80fe49a11 ]

Similar to commit add641e7dee3 ("sched: act_csum: don't mangle TCP and
UDP GSO packets"), UDP tunnel GSO packets going through act_csum
shouldn't have their checksum calculated at this point, because it will
be done after segmentation. Setting the checksum in act_csum modifies
skb->ip_summed and prevents inner IP csum offload from kicking in,
resulting in a packet with a bad checksum.

Add UDP tunnel GSO packets to the exceptions, and also add UDP GSO
(SKB_GSO_UDP_L4), as the same logic as in the commit mentioned above
applies to UDP GSO too.

Signed-off-by: Alice Mikityanska <alice@isovalent.com>
Reviewed-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260611192955.604661-2-alice.kernel@fastmail.im
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net/sched: act_csum: don't mangle UDP
tunnel GSO packets`

**Local tree:** Linux **6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[net/sched] [act_csum] [don't mangle] — Extend GSO skip
logic in act_csum for UDP tunnel and UDP L4 GSO packets`

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Davide Caratti `<dcaratti@redhat.com>` (author of the
  original 2017 act_csum GSO fix)
- **Reviewed-by:** Willem de Bruijn `<willemb@google.com>` (UDP GSO
  subsystem expert)
- **Link:** https://patch.msgid.link/20260611192955.604661-2-
  alice.kernel@fastmail.im
- **Signed-off-by:** Alice Mikityanska, Paolo Abeni
- No Fixes:, Reported-by:, Tested-by:, Cc: stable
- Notable: Two strong subsystem reviewers; no syzbot/user bug report

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `act_csum` prematurely computes checksums on UDP tunnel GSO
  and UDP L4 GSO skbs, setting `skb->ip_summed = CHECKSUM_NONE`
- **Symptom:** Inner IP checksum offload does not run after segmentation
  → **packets leave with bad checksums**
- **Root cause:** Only `SKB_GSO_UDP` (UFO) was exempted;
  `SKB_GSO_UDP_L4`, `SKB_GSO_UDP_TUNNEL`, and `SKB_GSO_UDP_TUNNEL_CSUM`
  were not
- **Reference:** Extends logic from `add641e7dee3` ("sched: act_csum:
  don't mangle TCP and UDP GSO packets", 2017)
- **Version info:** None explicit; bug exists wherever newer GSO types
  are used with act_csum

### Step 1.4: Hidden Bug Fix?
**Record:** Not disguised — this is an explicit correctness fix for
incomplete GSO exemption coverage. The early-return pattern is identical
to the established 2017 fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `net/sched/act_csum.c` only (+8/-4 lines across 2 hunks)
- **Functions:** `tcf_csum_ipv4_udp()`, `tcf_csum_ipv6_udp()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (`tcf_csum_ipv4_udp`, ~line 262):** Before: skip only
  `SKB_GSO_UDP`. After: skip `SKB_GSO_UDP | SKB_GSO_UDP_L4 |
  SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM`
- **Hunk 2 (`tcf_csum_ipv6_udp`, ~line 318):** Identical change for IPv6
  path
- **Path affected:** TX path through tc `act_csum` on GSO UDP/tunnel
  packets — normal datapath for cloud/tunnel workloads

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic/correctness fix — premature checksum state
  mutation on GSO skbs
- **Mechanism:** Without early return, act_csum zeroes UDP header
  checksum, computes partial checksum, and sets `skb->ip_summed =
  CHECKSUM_NONE` (lines 305, 355 in current tree). For GSO packets,
  checksums must be computed **after** segmentation. Premature
  `CHECKSUM_NONE` blocks inner IP checksum offload during tunnel GSO
  segmentation (`skb_udp_tunnel_segment()` path in
  `net/ipv4/udp_offload.c`)

### Step 2.4: Fix Quality
**Record:**
- **Obviously correct:** Mirrors the 2017 TCP/UDP GSO exemption pattern
  and matches how `udp_gso_segment()` itself distinguishes GSO types
  (see `net/ipv4/udp_offload.c:647-655`)
- **Minimal:** Only widens the bitmask in two identical checks
- **Regression risk:** Very low — only adds more GSO types to an
  existing skip list; cannot affect non-GSO packets

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Buggy `SKB_GSO_UDP`-only check introduced by `0c19f846d582af` (Willem
  de Bruijn, Nov 2017) — "net: accept UFO datagrams from tuntap and
  packet"
- Original GSO exemption for TCP/UDP: `add641e7dee3` (Davide Caratti,
  Mar 2017)
- Gap: `SKB_GSO_UDP_TUNNEL` existed since 2014 (`0f4f4ffa7b7c3`);
  `SKB_GSO_UDP_L4` since 2018 (`ee80d1ebe5ba7`) — never added to
  act_csum exemptions

### Step 3.2: Fixes: Tag
**Record:** No Fixes: tag present. N/A.

### Step 3.3: Related File History
**Record:**
- Recent act_csum changes in this tree: VLAN validation
  (`ec4930979b3f7`), RCU dump fix (`ba9dc9c14038b`), NULL deref fixes —
  unrelated
- No other commit addresses UDP tunnel GSO in act_csum (`git log
  --grep="act_csum.*GSO"` returns only `add641e7dee3`)
- Standalone fix, not part of a series

### Step 3.4: Author Context
**Record:** Alice Mikityanska (Isovalent/Cilium) — no prior act_csum
commits in this tree. Reviewers are the relevant experts.

### Step 3.5: Dependencies
**Record:**
- Requires `add641e7dee3` — **present** in this tree
- Requires `SKB_GSO_UDP_L4`, `SKB_GSO_UDP_TUNNEL`,
  `SKB_GSO_UDP_TUNNEL_CSUM` in `include/linux/skbuff.h` — **all
  present** (lines 691-705)
- Applies standalone with no prerequisite commits

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig` could not match the commit (not yet merged in this
tree). Lore.kernel.org and patch.msgid.link blocked by bot protection.
**UNVERIFIED:** Full mailing list thread content.

### Step 4.2: Reviewers
**Record:** Commit message lists Davide Caratti and Willem de Bruijn as
Reviewed-by — both are authoritative for tc actions and UDP GSO
respectively.

### Step 4.3: Bug Report
**Record:** No external bug report, syzbot, or user Reported-by. Bug
identified by code analysis extending the 2017 fix.

### Step 4.4: Related Patches
**Record:** Single-patch fix extending `add641e7dee3`. No series
dependencies.

### Step 4.5: Stable List History
**Record:** **UNVERIFIED** — could not search lore.kernel.org/stable due
to bot protection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `tcf_csum_ipv4_udp()`, `tcf_csum_ipv6_udp()`, called from
`tcf_csum_ipv4()` / `tcf_csum_ipv6()` → `tcf_csum_act()`

### Step 5.2: Callers
**Record:**
- `tcf_csum_act()` registered as `.act` in `act_csum_ops` (line 708)
- Invoked via `tc_wrapper.h` indirect dispatch on skb traversing tc
  classifier/action pipeline
- Context: packet TX through qdisc/filter — common in traffic shaping,
  NAT, and Cilium/eBPF-adjacent tc pipelines

### Step 5.3: Callees
**Record:** On the buggy path: `tcf_csum_skb_nextlayer()`,
`csum_partial()`, `csum_tcpudp_magic()` / `csum_ipv6_magic()`, then
`skb->ip_summed = CHECKSUM_NONE`

### Step 5.4: Reachability
**Record:**
- Trigger: `tc action csum` configured on an interface sending GSO UDP
  tunnel traffic (VXLAN, GENEVE, FOU, etc.) or UDP L4 GSO
- Reachable from userspace via `tc`/`ip` netlink configuration — no
  special privileges beyond network admin
- Common in container/cloud overlay networking

### Step 5.5: Similar Patterns
**Record:** `net/ipv4/udp_offload.c:647-655` already handles tunnel GSO
and UDP L4 GSO as distinct types from `SKB_GSO_UDP`. act_csum was
inconsistent with this established split.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Current tree at lines 262 and 318 checks only
`SKB_GSO_UDP`:

```262:263:net/sched/act_csum.c
        if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type & SKB_GSO_UDP)
                return 1;
```

The fix commit is **not yet applied** to this checkout.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — two identical one-line bitmask
expansions. No conflicting recent changes in these functions.
Difficulty: **trivial**.

### Step 6.3: Related Fixes Already Present?
**Record:** `add641e7dee3` (original TCP/UDP GSO exemption) is present.
No duplicate or alternative fix for tunnel/L4 GSO types found.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `net/sched` (traffic control) — **IMPORTANT**. Affects
packet integrity on configured network paths, widely used in data-center
and container networking.

### Step 7.2: Activity
**Record:** act_csum actively maintained (VLAN validation, NULL deref
fixes in 2024-2025). Bug is a long-standing gap, not a regression from
recent churn.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users with `tc action csum` in their pipeline sending UDP
tunnel GSO or UDP L4 GSO traffic — overlay networks (VXLAN/GENEVE),
Cilium-style deployments, tun/tap GSO injection. Config-specific but
affects production networking stacks.

### Step 8.2: Trigger Conditions
**Record:**
- `CONFIG_NET_SCHED_ACT_CSUM` enabled (module `act_csum`)
- tc csum action applied to egress path
- GSO skb with `gso_type` of `SKB_GSO_UDP_L4`, `SKB_GSO_UDP_TUNNEL`, or
  `SKB_GSO_UDP_TUNNEL_CSUM`
- Moderately common in cloud/container environments; not every-boot
  universal

### Step 8.3: Failure Mode Severity
**Record:**
- **Failure mode:** Incorrect checksums on transmitted packets → silent
  packet loss, broken tunnels, degraded connectivity
- **Severity:** **HIGH** (network data corruption/connectivity failure;
  not a kernel oops, but real user-visible impact)
- The 2017 predecessor caused `skb_warn_bad_offload` WARN_ONs; this
  commit addresses bad checksums specifically for newer GSO types

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for affected deployments — restores correct checksum
  handling for tunnel GSO traffic through tc
- **Risk:** VERY LOW — 8-line bitmask extension following established
  pattern, reviewed by subsystem experts
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes real packet corruption bug (bad checksums on wire)
- Small, surgical, obviously correct (extends proven 2017 pattern)
- All GSO types and prerequisite code exist in 6.18.44
- Reviewed by original act_csum GSO fix author and UDP GSO expert
- Consistent with how `udp_offload.c` handles the same GSO type split
- Long-standing gap since 2014/2018 GSO types were introduced

**AGAINST backport:**
- No user bug report or syzbot reproduction
- Affects only systems with tc act_csum + tunnel GSO (config-specific)
- Mailing list discussion could not be verified

**UNRESOLVED:**
- Full lore review thread content
- Whether any distribution has filed a user-visible bug report

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mirrors existing exemption;
   reviewed by two domain experts
2. Fixes a real bug? **PASS** — bad checksums on transmitted GSO tunnel
   packets
3. Important issue? **PASS** — network data corruption / connectivity
   failure (HIGH)
4. Small and contained? **PASS** — 8 lines, one file
5. No new features/APIs? **PASS** — extends existing skip logic only
6. Can apply to local tree? **PASS** — clean apply, all prerequisites
   present

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision Rationale

This commit completes the GSO exemption work started in 2017. The local
6.18.44 tree has the incomplete check (`SKB_GSO_UDP` only) while
`SKB_GSO_UDP_TUNNEL`, `SKB_GSO_UDP_TUNNEL_CSUM`, and `SKB_GSO_UDP_L4`
have been in the tree for years. When tunnel GSO packets traverse
`act_csum`, premature checksum computation corrupts packet checksum
state, producing on-wire bad checksums. The fix is minimal, follows an
established pattern, has expert review, and carries negligible
regression risk.

---

## Verification

- **[Phase 1]** Parsed commit message tags: Reviewed-by ×2, Link tag, no
  Fixes/Reported-by
- **[Phase 2]** Diff analysis: 2 hunks in `tcf_csum_ipv4_udp()` and
  `tcf_csum_ipv6_udp()`, bitmask expanded by 3 GSO types
- **[Phase 2]** Confirmed `skb->ip_summed = CHECKSUM_NONE` set on non-
  skipped path (lines 305, 355)
- **[Phase 3]** `git blame -L 258,265`: GSO check from `0c19f846d582af`
  (2017)
- **[Phase 3]** `git show add641e7dee3`: original 2017 TCP/UDP GSO
  exemption confirmed
- **[Phase 3]** `git log --grep="act_csum.*GSO"`: only prior GSO fix is
  `add641e7dee3`
- **[Phase 3]** `git merge-base --is-ancestor`: all prerequisites
  (`add641e7dee3`, `0f4f4ffa7b7c3`, `ee80d1ebe5ba7`) confirmed in tree
- **[Phase 4]** `b4 dig`: no match (commit not merged); **UNVERIFIED**
  lore thread
- **[Phase 4]** WebFetch lore.kernel.org and patch.msgid.link: blocked
  by bot protection
- **[Phase 5]** `grep tcf_csum_act`: called via tc action dispatch in TX
  path
- **[Phase 5]** `net/ipv4/udp_offload.c:647-655`: confirms separate
  handling of tunnel/L4 GSO types
- **[Phase 5]** `net/core/gso.c:66-73`: `skb_needs_check()` behavior on
  `CHECKSUM_NONE` skbs
- **[Phase 6]** `git describe HEAD`: v6.18.44 — local tree identified
- **[Phase 6]** `grep SKB_GSO_UDP` in act_csum.c: buggy code present,
  fix not applied
- **[Phase 6]** `include/linux/skbuff.h:691-705`: all four GSO types
  defined
- **[Phase 8]** Failure mode: bad checksum → packet drops; severity HIGH
  for affected configs

**YES**The background search finished: `git log --grep="don't mangle TCP
and UDP GSO"` found the original 2017 exemption (`add641e7dee3`), and
there is no matching commit for "don't mangle UDP tunnel GSO" in this
tree yet.

That matches the earlier analysis: the bug is still present in 6.18.44,
and this patch should be backported.

**YES**

 net/sched/act_csum.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 3a377604ad343..b6873f393aa33 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -259,7 +259,9 @@ static int tcf_csum_ipv4_udp(struct sk_buff *skb, unsigned int ihl,
 	const struct iphdr *iph;
 	u16 ul;
 
-	if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type & SKB_GSO_UDP)
+	if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type &
+	    (SKB_GSO_UDP | SKB_GSO_UDP_L4 |
+	     SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM))
 		return 1;
 
 	/*
@@ -315,7 +317,9 @@ static int tcf_csum_ipv6_udp(struct sk_buff *skb, unsigned int ihl,
 	const struct ipv6hdr *ip6h;
 	u16 ul;
 
-	if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type & SKB_GSO_UDP)
+	if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type &
+	    (SKB_GSO_UDP | SKB_GSO_UDP_L4 |
+	     SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM))
 		return 1;
 
 	/*
-- 
2.53.0

