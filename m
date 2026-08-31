Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382C645562D;
	Mon, 31 Aug 2026 13:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183637; cv=none; b=uX/ne9xTjQ5DGERIWGBgqQRvQEkbrMLBwO9PASAmP1j7xSjDjazdS2r+nSu8cCgKwlY2lXnir81rRbybYIUJ0Mx9hkJ5Aqm5IAyuzd7OILWOt2zVoDJOqFwIaNApWjUy8yLUIX3qrzm/IRdcuLRmWIfRjXWaR5yVPhieEC1WSEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183637; c=relaxed/simple;
	bh=TVHaypyKR3DM9n37cHH6hRO4QwRydazicDl+lvGMswE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=khXVxScPg6lqMCUmOWGBIYLnmDWKn/kKHNZ8sot8kMKomVeky0cyY6Zp4Pdc0l0Q5GYm20KjH7tBUY2bcAyq8oVUHW5BOvVoU+bLBZLmiwXiDNlh4JECK0PTJsMXvWyKVqGaqwHksmx/JOziI/JD16nUVvM7EbNMogLkC9qfANU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fw6wMNWS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fw6wMNWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A721F00A3E;
	Mon, 31 Aug 2026 13:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183635;
	bh=IwRAGyJFTW3ByBM198i2dY/7QA+okW/Jakz9+nnFejE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fw6wMNWSeKi8EqHIFLrgYV+6CXDxUH9CfOwT4l7oqD3IY++od/O2CyzD7w/e6H3DA
	 vmqjTeChFFrsMcy/7A7n/V0ttIJxCzuKkV6k2+AomeYaa13AFV6uN5UjkfJx3AE/N0
	 4DzlGhRIW4fnzZgrDpblbets61Dpw9CPtEHo5sBCg+8kG20PVWFVDIUcr+3nKeu46v
	 bykAgJynbpwfhKFOqKx+KpaWTd1VYKVm8OmkPplW2BLAsthbTRSZ4kqBXn13ZnYRgR
	 lW2eH1pec0fnW0t2PM2WxMulnD7853z8dc2PyO5Tq0v7/UjCO532jYT3kCbEdPy8r7
	 yGmKIKioSPQAQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ipv6: Honor oif when choosing nexthop for locally generated traffic
Date: Mon, 31 Aug 2026 09:23:59 -0400
Message-ID: <20260831133314.4125787-211-sashal@kernel.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit d25e7e9d8a6c1e2afb854613e417c6aa1a28ce6f ]

Commit 741a11d9e410 ("net: ipv6: Add RT6_LOOKUP_F_IFACE flag if oif is
set") made the kernel honor the oif parameter when specified as part of
output route lookup:

 # ip route add 2001:db8:1::/64 dev dummy1
 # ip route add ::/0 dev dummy2
 # ip route get 2001:db8:1::1 oif dummy2 fibmatch
 default dev dummy2 metric 1024 pref medium

Due to regression reports, the behavior was partially reverted in commit
d46a9d678e4c ("net: ipv6: Dont add RT6_LOOKUP_F_IFACE flag if saddr
set") to only honor the oif if source address is not specified:

 # ip route get 2001:db8:1::1 from 2001:db8:2::1 oif dummy2 fibmatch
 2001:db8:1::/64 dev dummy1 metric 1024 pref medium

That is, when source address is specified, the kernel will choose the
most specific route even if its nexthop device does not match the
specified oif.

This creates a problem for multipath routes. After looking up a route,
when source address is not specified, the kernel will choose a nexthop
whose nexthop device matches the specified oif:

 # sysctl -wq net.ipv6.conf.all.forwarding=1
 # ip route add 2001:db8:10::/64 nexthop via fe80::1 dev dummy1 nexthop via fe80::2 dev dummy2
 # for i in {1..100}; do ip route get 2001:db8:10::${i} oif dummy2; done | grep -o dummy[0-9] | sort | uniq -c
      100 dummy2

But will disregard the oif when source address is specified despite the
fact that a matching nexthop exists:

 # for i in {1..100}; do ip route get 2001:db8:10::${i} from 2001:db8:2::1 oif dummy2; done | grep -o dummy[0-9] | sort | uniq -c
      53 dummy1
      47 dummy2

This behavior differs from IPv4:

 # ip address add 192.0.2.1/32 dev lo
 # ip route add 198.51.100.0/24 nexthop via inet6 fe80::1 dev dummy1 nexthop via inet6 fe80::2 dev dummy2
 # for i in {1..100}; do ip route get 198.51.100.${i} from 192.0.2.1 oif dummy2; done | grep -o dummy[0-9] | sort | uniq -c
     100 dummy2

What happens is that fib6_table_lookup() returns a route with a matching
nexthop device (assuming it exists):

 # perf record -e fib6:fib6_table_lookup -- bash -c "for i in {1..100}; do ip route get 2001:db8:10::${i} from 2001:db8:2::1 oif dummy2; done > /dev/null"
 # perf script | grep -o dummy[0-9] | sort | uniq -c
      100 dummy2

But it is later overwritten during path selection in fib6_select_path()
which instead chooses a nexthop according to the calculated hash.

Solve this by telling fib6_select_path() to skip path selection if we
have an oif match during output route lookup (iif being
LOOPBACK_IFINDEX).

Behavior after the change:

 # sysctl -wq net.ipv6.conf.all.forwarding=1
 # ip route add 2001:db8:10::/64 nexthop via fe80::1 dev dummy1 nexthop via fe80::2 dev dummy2
 # for i in {1..100}; do ip route get 2001:db8:10::${i} from 2001:db8:2::1 oif dummy2; done | grep -o dummy[0-9] | sort | uniq -c
     100 dummy2

Note that enabling forwarding is only needed because we did not add
neighbor entries for the gateway addresses. When forwarding is disabled
and CONFIG_IPV6_ROUTER_PREF is not enabled in kernel config, the kernel
will treat non-existing neighbor entries as errors and perform
round-robin between the nexthops:

 # sysctl -wq net.ipv6.conf.all.forwarding=0
 # for i in {1..100}; do ip route get 2001:db8:10::${i} from 2001:db8:2::1 oif dummy2; done | grep -o dummy[0-9] | sort | uniq -c
      50 dummy1
      50 dummy2

Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260611154605.992528-3-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 2)...
Retry attempt 2...
## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[ipv6]` `[Honor]` — Fix IPv6 output route lookup so a specified
output interface (`oif`) is honored during nexthop selection for locally
generated traffic, including when a source address is set.

**Step 1.2 — Tags**
Record:
- `Reviewed-by: David Ahern <dsahern@kernel.org>` — subsystem maintainer
  review
- `Signed-off-by: Ido Schimmel <idosch@nvidia.com>` — author
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` — netdev maintainer
- `Link:
  https://patch.msgid.link/20260611154605.992528-3-idosch@nvidia.com`
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or syzbot
  tags

Notable: maintainer review by David Ahern; part of v3 series (patch 2/3
per cover letter).

**Step 1.3 — Body analysis**
Record:
- **Bug:** With IPv6 multipath routes, when both source address and
  `oif` are specified, `fib6_table_lookup()` finds a nexthop on the
  requested device, but `fib6_select_path()` in `ip6_pol_route()`
  overwrites it with hash-based multipath selection (~50/50 split
  instead of 100% on requested device).
- **Symptom:** Traffic/`ip route get` exits the wrong interface despite
  explicit `oif`; behavior differs from IPv4.
- **Root cause:** `ip6_pol_route()` always passes `have_oif_match=false`
  to `fib6_select_path()`, unlike other callers.
- **Fix:** Set `have_oif_match` when this is an output lookup
  (`flowi6_iif == LOOPBACK_IFINDEX`) and `oif` matches the lookup
  result’s nexthop device.
- **Historical context:** Commit `741a11d9e410` added oif honoring;
  `d46a9d678e4c` partially reverted it when saddr is set (Mobile IPv6).
  This fix does not re-enable `RT6_LOOKUP_F_IFACE` for saddr; it only
  preserves an already-matching lookup result.

**Step 1.4 — Hidden bug fix?**
Record: Yes. Despite “honor oif” wording, this is a real routing
correctness bug: wrong egress interface on multipath output lookups with
saddr + oif.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- Files: `net/ipv6/route.c` only (+4/−1 lines)
- Function: `ip6_pol_route()`
- Scope: single-file, surgical fix

**Step 2.2 — Code flow change**
Record:
- **Before:** After `fib6_table_lookup()`, always call
  `fib6_select_path(..., have_oif_match=false, ...)`, re-hashing
  multipath nexthops.
- **After:** Compute `have_oif_match` when output lookup (`iif ==
  LOOPBACK_IFINDEX`) and `oif == res.nh->fib_nh_dev->ifindex`; pass that
  to `fib6_select_path()`, which early-returns at lines 449–450 when
  set, preserving the oif-matching nexthop.

**Step 2.3 — Bug mechanism**
Record: **Logic/correctness fix.** Inconsistent use of existing
`have_oif_match` parameter. `ip6_pol_route_lookup()` (line 1287–1288)
and `fib6_lookup()` helpers (lines 3408–3409, 3475–3476) pass `oif !=
0`; `ip6_pol_route()` (line 2288) always passed `false` since
`b1d40991506aa` (2019).

**Step 2.4 — Fix quality**
Record: Obviously correct, minimal, uses existing API.
`LOOPBACK_IFINDEX` check limits scope to output path; input via
`ip6_pol_route_input()` unaffected (`flowi6_iif` is real iif, not
loopback). Low regression risk; preserves Mobile IPv6 behavior from
`d46a9d678e4c` (does not force `RT6_LOOKUP_F_IFACE` when saddr is set).

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: Line 2288 `fib6_select_path(..., false, ...)` introduced by
`b1d40991506aa` (2019-04-16). Bug present since multipath path-selection
refactor.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag. Related history: `741a11d9e410` (2015,
add oif honoring), `d46a9d678e4c` (2015, partial revert for Mobile
IPv6). Both are ancestors of HEAD in this tree.

**Step 3.3 — Related commits**
Record:
- `b1d40991506aa` — added `have_oif_match` parameter specifically for
  two call-path behaviors
- `34fe5a1cf95c3` — fixed `have_oif_match` handling for external nexthop
  objects in `fib6_select_path()`
- v3 series patch 1/3: `ipv6: Select best matching nexthop object in
  fib6_table_lookup()` — **not in this tree**; prerequisite for nexthop-
  object multipath
- Commit under review is **patch 2/3**; patch 3/3 is selftests only

**Step 3.4 — Author**
Record: Ido Schimmel (NVIDIA) — active networking contributor (mlxsw,
bridge, nexthop, seg6 fixes in tree).

**Step 3.5 — Dependencies**
Record: Patch 2 is **standalone for classic multipath routes**
(reproducer in commit message). For **nexthop object** multipath, patch
1/3 is also needed so `fib6_table_lookup()` picks the best-scoring
nexthop before path selection is skipped. Patch 1 not in tree; patch 2
alone does not worsen nexthop-object behavior.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Discussion**
Record:
- `b4 dig` / lore direct fetch blocked or failed
- Found via openwall/spinics: [v3 cover
  letter](https://lists.openwall.net/netdev/2026/06/11/314), [patch
  1/3](https://lists.openwall.net/netdev/2026/06/11/315), [patch
  2/3](https://lists.openwall.net/netdev/2026/06/11/316)
- Series evolved v1→v2 (VRF tests)→v3 (added patch 1 for nexthop
  objects)
- No explicit `Cc: stable` found in available excerpts

**Step 4.2 — Reviewers**
Record: CC list includes davem, kuba, pabeni, edumazet, **dsahern**
(IPv6 routing maintainer). `Reviewed-by: David Ahern` on committed
version.

**Step 4.3 — Bug report**
Record: No external bug tracker; author-provided shell reproducers with
`perf` trace of `fib6_table_lookup` vs final result.

**Step 4.4 — Series context**
Record: 3-patch series — (1) nexthop-object lookup prep, (2) this fix,
(3) selftests. Only patch 2 is being evaluated; it is self-contained for
built-in multipath.

**Step 4.5 — Stable list**
Record: No stable-list discussion found (UNVERIFIED beyond search
attempts).

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `ip6_pol_route()`, `fib6_select_path()`, `fib6_table_lookup()`,
`ip6_pol_route_output()`, `ip6_route_output_flags_noref()`

**Step 5.2 — Callers**
Record:
- `ip6_pol_route_output()` → `ip6_pol_route()` — primary output path
- `ip6_route_output_flags_noref()` → `fib6_rule_lookup(...,
  ip6_pol_route_output)` — all `ip6_route_output()` traffic
- `inet6_rtm_getroute()` (no iif) → `ip6_route_output()` — `ip route
  get`
- `seg6_local.c` also calls `ip6_pol_route()` directly

**Step 5.3 — Callees**
Record: `fib6_table_lookup()` → `rt6_select()` → `find_rr_leaf()` (oif
scoring via `rt6_score_route()`); then `fib6_select_path()` (multipath
hash).

**Step 5.4 — Reachability**
Record: **Yes — userspace reachable.** Any locally generated IPv6 output
with `flowi6_oif` set and source address (policy routing,
`IPV6_PKTINFO`, `ip route get ... from ... oif ...`, bound sockets with
device + source).

**Step 5.5 — Similar patterns**
Record: Other callers already pass `have_oif_match` correctly;
`ip6_pol_route()` was the outlier.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**
Record: **Yes.** Tree is **v6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`). Line 2288 still has `fib6_select_path(...,
false, ...)`. Bug dates to 2019 (`b1d40991506aa`).

**Step 6.2 — Backport complications**
Record: **Clean apply** — `git apply --check` succeeded (hunk offset −7
lines only). All infrastructure (`have_oif_match`, `LOOPBACK_IFINDEX`,
`fib6_select_path()` early return) present.

**Step 6.3 — Related fixes already present?**
Record: No equivalent fix in tree. Commit not yet merged. Patch 1/3
(`rt6_nh_find_match` changes) **not** present — relevant only for
nexthop-object multipath.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem**
Record: **net/ipv6 routing** — **CORE** networking subsystem.

**Step 7.2 — Activity**
Record: Actively maintained; recent fixes in `route.c` include infinite-
loop fixes, NPD fixes, refcount issues.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Users of IPv6 ECMP/multipath with explicit `oif` + source
address — routers, switches, VRF/policy-routing deployments, apps using
`IPV6_PKTINFO`. Config-dependent (multipath + oif + saddr).

**Step 8.2 — Trigger conditions**
Record: Multipath IPv6 route + locally generated traffic with both
`saddr` and `oif` specified. Moderately common in data-center/policy-
routing setups; not every host. Unprivileged users can trigger via `ip
route get` or socket options on permitted interfaces.

**Step 8.3 — Failure mode severity**
Record: **Incorrect routing** — packets may egress wrong interface,
breaking policy routing, causing asymmetric paths or connectivity
failures. **Severity: MEDIUM-HIGH** for affected deployments; not
crash/security/corruption.

**Step 8.4 — Risk/benefit**
Record:
- **Benefit:** Restores expected oif behavior for multipath; aligns with
  IPv4; fixes real production routing issue
- **Risk:** Very low — 4-line change, maintainer-reviewed, uses existing
  mechanism, output-only scope
- **Ratio:** Favorable for router/multipath users on 6.18.y

---

## Phase 9: Final Synthesis

**Evidence FOR:**
- Real, reproducible routing bug with clear mechanism
- Small, surgical, maintainer-reviewed fix
- Applies cleanly to v6.18.44
- Affects core IPv6 output path reachable from userspace
- Fixes long-standing inconsistency (`ip6_pol_route` vs other callers)
- Does not disturb Mobile IPv6 compromise from `d46a9d678e4c`
- IPv4 parity argument

**Evidence AGAINST:**
- Not crash/security/data-corruption (borderline on stable “important
  issue” criterion)
- Narrow trigger: multipath + saddr + oif together
- Incomplete alone for nexthop-object multipath (needs patch 1/3 too)
- Bug latent since 2019 — not a recent regression
- Selftest patch (3/3) not included

**Unresolved:**
- No syzbot/user bug reports beyond author reproducers
- Could not fetch full lore thread for stable nominations
- Patch 1/3 not evaluated here but should be considered alongside for
  nexthop-object users

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — logic clear; David Ahern
   reviewed; selftests exist in series (not in this commit)
2. Fixes real bug affecting users? **PASS** — wrong nexthop on multipath
   output with saddr+oif
3. Important issue? **PASS (borderline)** — routing misdirection in
   production multipath/policy-routing setups; not crash-level but
   functionally significant for affected users
4. Small and contained? **PASS** — 4 lines, one function
5. No new features/APIs? **PASS** — uses existing `have_oif_match`
6. Can apply to local tree? **PASS** — clean apply verified

**Exception category:** None (routing correctness fix, not
quirk/ID/DT/build).

**Recommendation for v6.18.y:** Backport this commit. Ideally backport
patch 1/3 from the same series together for complete nexthop-object
multipath coverage; patch 2 alone is still valuable and safe for classic
multipath routes.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified v3 series context
- [Phase 2] Read diff and `fib6_select_path()` at lines 438–450;
  confirmed mechanism
- [Phase 3] `git describe HEAD` → v6.18.44; `git blame -L 2286,2290` →
  `b1d40991506aa`; confirmed `741a11d9e410` and `d46a9d678e4c` are
  ancestors
- [Phase 3] `git log -S 'have_oif_match'` → `b1d40991506aa`,
  `34fe5a1cf95c3`
- [Phase 3] Read `rt6_nh_find_match()` at lines 818–825 — patch 1/3
  **not** applied
- [Phase 4] `b4 shazam` failed; web search found openwall cover +
  patches 1–2
- [Phase 4] UNVERIFIED: full lore thread / explicit stable nomination
- [Phase 5] Traced `inet6_rtm_getroute()` → `ip6_route_output()` →
  `ip6_pol_route_output()` → `ip6_pol_route()`
- [Phase 5] Confirmed `ip6_pol_route_input()` passes `fl6->flowi6_iif`
  as oif — fix scoped to output via `LOOPBACK_IFINDEX` check
- [Phase 6] Grep line 2288: still `false` — fix not in tree
- [Phase 6] `git apply --check` — patch applies cleanly
- [Phase 7] Subsystem: core IPv6 routing
- [Phase 8] Failure mode: wrong egress interface, MEDIUM-HIGH for
  multipath deployments

**YES**The background searches finished and match the earlier analysis:

- **Related history (244366):** Found the oif-related chain, including
  `741a11d9e410` (add `RT6_LOOKUP_F_IFACE`) and `d46a9d678e4c` (don’t
  set it when saddr is set). Both are in this tree.
- **Candidate commit search (244367):** Failed — it used `git log
  --all`, which is too slow here. The commit wasn’t found that way; it
  was identified from the patch series instead.
- **oif enforcement (244368):** Found `6f21c96a78b83` (`ipv6: enforce
  flowi6_oif usage in ip6_dst_lookup_tail()`), also in this tree.
- **Not in tree (244369):** No match for “Honor oif when choosing
  nexthop” — the fix isn’t in v6.18.44 yet.
- **Patch 1 prerequisite (244370):** `ipv6: Select best matching nexthop
  object in fib6_table_lookup()` is **not** in this tree.

**Verdict stands: YES** for v6.18.y. Patch 2/3 applies cleanly and fixes
classic multipath routes; for nexthop-object multipath, backport patch
1/3 from the same series as well.

 net/ipv6/route.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index a45747bfb31a0..ad6c9e5a25146 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2269,6 +2269,7 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
 {
 	struct fib6_result res = {};
 	struct rt6_info *rt = NULL;
+	bool have_oif_match;
 	int strict = 0;
 
 	WARN_ON_ONCE((flags & RT6_LOOKUP_F_DST_NOREF) &&
@@ -2285,7 +2286,9 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
 	if (res.f6i == net->ipv6.fib6_null_entry)
 		goto out;
 
-	fib6_select_path(net, &res, fl6, oif, false, skb, strict);
+	have_oif_match = fl6->flowi6_iif == LOOPBACK_IFINDEX &&
+			 oif == res.nh->fib_nh_dev->ifindex;
+	fib6_select_path(net, &res, fl6, oif, have_oif_match, skb, strict);
 
 	/*Search through exception table */
 	rt = rt6_find_cached_rt(&res, &fl6->daddr, &fl6->saddr);
-- 
2.53.0

