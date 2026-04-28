Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533C8427A13;
	Tue, 28 Apr 2026 10:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372996; cv=none; b=qeKKhknVhkMHLnqqQWxCWOR2A1unlbXZKyJfQHbjH+6ahrPWt8kI6nWb3DmMqOufgjquVaKHC6RYt4YYCt4Ick37OsZvK0qs4FS4WsQ+1PQ1jGRWCnEokkXs5Xj12Ra+1xd54bt9Ud8ZHRmkiXzny9HkcBjwT5X4cwQ0pm2GY3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372996; c=relaxed/simple;
	bh=qP+aiH73KAS9rGA/suTGV6A/5fjfYgjPpjuIMd0CXG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sPPk5m9+7KVIMv5Se4F1cdKnBWpB0ZFQvm94OGatbeDhu4WGsJ+BM3cDDv+bfDMwaJKR5Aqyxm/3BwrCLoQ2VQ4mJJkWTWPpiHuIwxGusJuwBFiqh7H1WX3BjFi5m42hCxuNPDS6KcivylDyNrdVcT477u1sI48I7WP/06DtST0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SBuZ0dhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SBuZ0dhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2A3C2BCB8;
	Tue, 28 Apr 2026 10:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372996;
	bh=qP+aiH73KAS9rGA/suTGV6A/5fjfYgjPpjuIMd0CXG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBuZ0dhKeI4Tu7WBT+IZQ9oP1oQIE9H01QnAPyebtY0s6tYKCCwcsI6VoKT/mqm7H
	 iek47dE8W/olyPVkk1cmYPRUAC495h8+LZe8y25dnXFH5OD+rZRQI46HGEGdiF6u1a
	 NNGUQo8qfzuLknKiGLZXT+M4U7ntsuDbOFHNbLcHVUNXJO9zr60d6moLsVHNvhdF/m
	 KT2Hg9rbREw6CepTk/BCZ/QE51TzNJ8uurK03i0TwoAijyTguceGFCuU5WC7MUXO9t
	 vTZAPYd9jAiCvY0RgIWoA5HPXT9KXu/DLru2pmHmNHYy0tdbDKsLs1vNjdcw01iKnZ
	 o7lCjoU3J60Xw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>,
	Ido Schimmel <idosch@nvidia.com>,
	Justin Iurman <justin.iurman@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ipv6: Cap TLV scan in ip6_tnl_parse_tlv_enc_lim
Date: Tue, 28 Apr 2026 06:41:22 -0400
Message-ID: <20260428104133.2858589-71-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 076b8cad77aa96557719fb5effe8703bfb64df00 ]

Commit 47d3d7ac656a ("ipv6: Implement limits on Hop-by-Hop and
Destination options") added net.ipv6.max_{hbh,dst}_opts_{cnt,len}
and applied them in ip6_parse_tlv(), the generic TLV walker
invoked from ipv6_destopt_rcv() and ipv6_parse_hopopts().

ip6_tnl_parse_tlv_enc_lim() does not go through ip6_parse_tlv();
it has its own hand-rolled TLV scanner inside its NEXTHDR_DEST
branch which looks for IPV6_TLV_TNL_ENCAP_LIMIT. That inner
loop is bounded only by optlen, which can be up to 2048 bytes.
Stuffing the Destination Options header with 2046 Pad1 (type=0)
entries advances the scanner a single byte at a time, yielding
~2000 TLV iterations per extension header.

Reusing max_dst_opts_cnt to bound the TLV iterations, matching
the semantics from 47d3d7ac656a, would require duplicating
ip6_parse_tlv() to also validate Pad1/PadN payload. It would
also mandate enforcing max_dst_opts_len, since otherwise an
attacker shifts the axis to few options with a giant PadN and
recovers the original DoS. Allowing up to 8 options before the
tunnel encapsulation limit TLV is liberal enough; in practice
encap limit is the first TLV. Thus, go with a hard-coded limit
IP6_TUNNEL_MAX_DEST_TLVS (8).

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information I need. Let me compile the comprehensive
analysis.

# Phase-by-Phase Analysis

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 - Subject Line Parse:**
- Subsystem prefix: `ipv6:`
- Action verb: "Cap" (limit/bound) — implicit bug fix verb
- Summary: Add a hard cap on TLV iterations in
  `ip6_tnl_parse_tlv_enc_lim()`
- Record: `[ipv6] [Cap] [Bound the TLV scan loop to prevent excessive
  iterations]`

**Step 1.2 - Tag Parsing:**
- Signed-off-by: Daniel Borkmann <daniel@iogearbox.net> (author)
- Reviewed-by: Ido Schimmel <idosch@nvidia.com>
- Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
- Signed-off-by: Jakub Kicinski <kuba@kernel.org> (netdev maintainer)
- No explicit Fixes: tag, no Cc: stable, no Reported-by, no Link:
- References commit `47d3d7ac656a` ("ipv6: Implement limits on Hop-by-
  Hop and Destination options") in message body
- Record: Two independent Reviewed-by tags, applied by subsystem
  maintainer Kicinski. Pedigree is strong.

**Step 1.3 - Commit Body Analysis:**
- Describes bug: `ip6_tnl_parse_tlv_enc_lim()` has a hand-rolled TLV
  scanner in its `NEXTHDR_DEST` branch, bounded only by `optlen` (up to
  2048 bytes)
- Attack: "Stuffing the Destination Options header with 2046 Pad1
  (type=0) entries advances the scanner a single byte at a time,
  yielding ~2000 TLV iterations per extension header"
- Symptom: CPU-consuming DoS — an attacker can force ~2000 iterations
  per IPv6 extension header in a received packet
- Mentions that commit `47d3d7ac656a` already fixed the same class of
  bug in `ip6_parse_tlv()` (the generic TLV walker), but this separate
  hand-rolled scanner was missed
- Record: Clear DoS vector description, author's understanding of the
  bug mechanism is thorough

**Step 1.4 - Hidden Bug Fix Detection:**
- Subject says "Cap" rather than "Fix" but body makes explicit that this
  is a DoS fix
- This is NOT a hidden fix — the DoS mechanism is described openly
- Record: Commit is a clear bug fix despite neutral-sounding subject
  verb

## PHASE 2: DIFF ANALYSIS

**Step 2.1 - Inventory:**
- Single file: `net/ipv6/ip6_tunnel.c`
- +6 lines, 0 removed
- Function modified: `ip6_tnl_parse_tlv_enc_lim()`
- Scope: single-file surgical fix
- Record: 6 lines in 1 file, 1 function — minimal scope

**Step 2.2 - Code Flow:**
- Before: `while (1)` loop with break only when `i + sizeof(*tel) >
  optlen` — can iterate up to ~optlen/1 times when all entries are Pad1
  (type=0 advances `i` by 1 byte)
- After: new local `int tlv_cnt = 0;` declared; `if (unlikely(tlv_cnt++
  >= IP6_TUNNEL_MAX_DEST_TLVS)) break;` added at top of loop
- New macro `#define IP6_TUNNEL_MAX_DEST_TLVS 8` at file scope
- Record: Loop now breaks after at most 8 TLVs scanned per extension
  header

**Step 2.3 - Bug Mechanism Classification:**
- Category: (h) Hardware workarounds? No. This is category close to
  "bounds check" / DoS prevention — fits between logic/correctness (g)
  and memory safety (d)
- Specific: A counter-based upper bound on a while loop prevents
  attacker-controlled iteration count from causing excessive CPU use per
  received packet
- Record: DoS/CPU-exhaustion fix via iteration bound

**Step 2.4 - Fix Quality:**
- Obviously correct: the counter is incremented unconditionally,
  compared with constant 8
- Minimal: 6 lines, self-contained inside existing function
- Regression risk: In practice the encap limit TLV is the first TLV. 8
  is generous. Legitimate traffic never hits this cap. Extremely low
  risk.
- Record: High-quality, obviously-correct, minimal fix

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 - Git Blame:**
- Ran `git blame -L 430,456 net/ipv6/ip6_tunnel.c`
- Core `while (1)` loop and TLV scanning logic attributed to
  `1da177e4c3f4` ("Linux-2.6.12-rc2", 2005-04-16) — the very beginning
  of git history
- Surrounding `nexthdr == NEXTHDR_DEST` check modified by
  `d375b98e024898` (Eric Dumazet, 2024-01-05)
- Earlier pointer-math/bounds fixes: `fbfa743a9d2a0f` (2017),
  `63117f09c768be` (2017)
- Record: **Buggy code present since git epoch (2005). Bug exists in all
  supported stable trees.**

**Step 3.2 - Follow Fixes: Tag:**
- No Fixes: tag. In the lore discussion, Ido Schimmel explicitly
  suggested: "Fixes: 1da177e4c3f4 ('Linux-2.6.12-rc2')"
- Referenced commit `47d3d7ac656a` (Tom Herbert, 2017-10-30) addressed
  the same DoS in `ip6_parse_tlv()` by adding
  `max_dst_opts_cnt`/`max_dst_opts_len` sysctls. It did not cover this
  hand-rolled scanner.
- Record: Bug is as old as git history; the analogous fix for the
  generic path is already in stable.

**Step 3.3 - File History:**
- Recent changes in this file are unrelated (DSCP handling, netns
  conversion, GRO fixes, skb_vlan_inet_prepare, etc.) — no prerequisite
  or competing fix
- `d375b98e024898` ("ip6_tunnel: fix NEXTHDR_FRAGMENT handling in
  ip6_tnl_parse_tlv_enc_lim()", 2024) is the most recent change in this
  function — itself a fix that went to stable
- Record: Standalone fix; no dependencies identified

**Step 3.4 - Author's Background:**
- Daniel Borkmann: networking/BPF maintainer, extensive
  ipv6/netfilter/BPF history
- Not a new contributor
- Record: Author has deep kernel/networking expertise

**Step 3.5 - Dependencies:**
- Patch only adds a local counter and a new macro — no external symbol
  dependencies
- Applies to the existing while loop that has been stable for decades
- Record: Standalone, self-contained

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1 - b4 dig:**
- `b4 dig -c 076b8cad77aa9` found the original submission at `https://lo
  re.kernel.org/all/20260421202406.717885-1-daniel@iogearbox.net/`
- Subject: **[PATCH net v3]** — "net" tree tag signals this is a bug fix
  targeting the current release cycle (not "net-next"), which is where
  stable-candidate fixes go
- `b4 dig -a`: the v3 that was applied is the latest revision; changelog
  in the patch shows v1->v2 (use abs(), remove unlikely), v2->v3 (hard
  code limit of 8 vs max_dst_opts_cnt, per Ido)
- Record: Three-revision evolution; reviewers addressed; applied version
  is final

**Step 4.2 - Reviewers (b4 dig -w):**
- To: kuba@kernel.org (Jakub Kicinski — netdev maintainer)
- Cc: edumazet@google.com (Eric Dumazet — networking maintainer),
  dsahern@kernel.org (David Ahern — ipv6 maintainer),
  tom@herbertland.com (Tom Herbert — author of the related 2017 fix),
  willemdebruijn.kernel@gmail.com, idosch@nvidia.com,
  justin.iurman@gmail.com, pabeni@redhat.com (Paolo Abeni — networking
  maintainer), netdev@vger.kernel.org
- Record: All major networking maintainers included. Reviewed by Ido
  Schimmel and Justin Iurman (IPv6 extension header reviewer)

**Step 4.3 - Bug Report:**
- No Reported-by/Link: tag — the DoS was likely identified by the author
  through code review (he explicitly analyzed the disparity with the
  already-patched `ip6_parse_tlv()`)
- Record: Proactive DoS discovery rather than user-reported

**Step 4.4 - Related Patches:**
- Single patch, not a series
- Record: Standalone

**Step 4.5 - Stable Discussion:**
- In the lore mbox: Ido Schimmel said "Given that you are targeting net
  and that the issue was always present, I would use: Fixes:
  1da177e4c3f4 ('Linux-2.6.12-rc2')"
- This strongly implies the fix is intended for stable (Fixes: tag is
  the trigger for stable-autoselect)
- Record: Reviewer explicitly suggested adding a Fixes: tag pointing to
  kernel epoch — a clear stable-backport signal

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 - Key Functions:** `ip6_tnl_parse_tlv_enc_lim()` — the only
function modified.

**Step 5.2 - Callers (via `git grep`):**
- `net/ipv6/ip6_tunnel.c`:
  - `ip6_tnl_err()` — ICMPv6 error handler for IPv6-over-IPv6 tunnels
  - `__ip6_tnl_xmit()` — the transmit path (when protocol ==
    IPPROTO_IPV6)
- `net/ipv6/ip6_gre.c`:
  - `ip6gre_err()` — ICMPv6 error handler for GRE-over-IPv6
  - `prepare_ip6gre_xmit_ipv6()` — GRE transmit path
- Record: Called from both transmit path and ICMPv6 error handling for
  ip6 and ip6gre tunnels — network-reachable data paths on any system
  using IPv6 tunnels

**Step 5.3 - Callees:** Reads `skb->data`, uses `pskb_may_pull`. No
external state changes inside the scanner.

**Step 5.4 - Call Chain / Reachability:**
- `__ip6_tnl_xmit()` is part of `ip6_tnl_start_xmit` / `ip6_tnl_rcv_ctl`
  infrastructure — runs on every packet sent over an IPv6 tunnel when
  the inner packet has Destination Options
- `ip6_tnl_err()` is invoked from `ip6_tnl_err_proto`, called by icmpv6
  when an IPv6 tunnel packet triggers an error
- An attacker over the network can craft packets to exploit this as long
  as the target has an IPv6 tunnel configured (ip6tnl, ip6gre modules)
- Record: Data path function, reachable from remote attacker when IPv6
  tunnel is configured

**Step 5.5 - Similar Patterns:**
- The generic `ip6_parse_tlv()` in `net/ipv6/exthdrs.c` already has this
  protection via `max_hbh_opts_cnt/max_dst_opts_cnt` (commit
  47d3d7ac656a, 2017)
- This commit closes the last remaining scanner that didn't have such a
  cap
- Record: This is the final instance; other instances already protected

## PHASE 6: CROSS-REFERENCING STABLE TREES

**Step 6.1 - Buggy code in stable trees?**
- The loop structure is in the codebase since `1da177e4c3f4`
  (2.6.12-rc2)
- Present in 5.4, 5.10, 5.15, 6.1, 6.6, 6.12 and every other supported
  stable tree
- Record: All supported stable trees contain the vulnerable code

**Step 6.2 - Backport Complications:**
- The function is modified by `d375b98e024898` (Jan 2024) — this is in
  6.7+; older stable trees (5.4, 5.10, 5.15, 6.1) may have a slightly
  different surrounding context (no `nexthdr ==
  NEXTHDR_FRAGMENT`/`NEXTHDR_AUTH` branching exactly as today)
- However, the key hunk — the `if (nexthdr == NEXTHDR_DEST) { ...
  while(1) { ... }}` block — is structurally unchanged since 2005
- The patch adds a new local variable and a new `if` inside the while
  loop; this should apply cleanly or with trivial offset fuzzing
- Record: Expected to apply cleanly to all active stable trees; at worst
  a trivial context adjustment

**Step 6.3 - Related fixes already in stable?**
- `47d3d7ac656a` is in stable trees (it was the original DoS hardening,
  merged 2017)
- No previous fix for this specific hand-rolled scanner exists
- Record: No overlap; this closes a gap left by the 2017 fix

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 - Subsystem:** `net/ipv6/` — core IPv6 networking. Affects
users of IPv6 tunnels (ip6tnl, ip6gre). IMPORTANT criticality.

**Step 7.2 - Activity:** Very active subsystem, but the specific scanner
has been stable for 20+ years. Record: Mature code, long-lived bug.

## PHASE 8: IMPACT AND RISK

**Step 8.1 - Affected Users:** All users running IPv6 tunnel drivers
(ip6tnl, ip6gre modules loaded) — common on IPv6 dual-stack routers,
tunnel endpoints, mobile backhauls, cloud overlay networks.

**Step 8.2 - Trigger Conditions:**
- Attacker sends IPv6 packet with Destination Options header containing
  2046 Pad1 entries
- Per extension header, ~2000 CPU iterations in the scanner
- Can be triggered remotely without authentication — any reachable IPv6
  tunnel endpoint
- Record: Unprivileged remote attacker can trigger; realistic DoS

**Step 8.3 - Failure Mode Severity:**
- CPU exhaustion in softirq context — affects packet processing
  throughput
- With pipelined attack traffic, can starve other network processing
- Not a crash but a performance DoS — **MEDIUM-HIGH** severity
- Record: Remote DoS / CPU exhaustion, medium-high severity

**Step 8.4 - Risk-Benefit:**
- Benefit: Closes a 20-year-old remote DoS vector on IPv6 tunnel
  endpoints; completes the hardening started by the 2017 fix
- Risk: Very low — 6-line cap at value 8, legitimate traffic never
  approaches this limit (encap limit is typically the first TLV)
- Record: Strongly favorable benefit/risk ratio

## PHASE 9: SYNTHESIS

**Step 9.1 - Evidence:**
- FOR backport:
  - Closes a known class of remote DoS (same class as 47d3d7ac656a,
    which is in stable)
  - Bug present since 2.6.12-rc2 (2005) — affects every supported stable
    tree
  - 6-line surgical fix, no new APIs, no functional change for
    legitimate traffic
  - Reviewed by two independent reviewers (Ido Schimmel, Justin Iurman),
    applied by netdev maintainer to the `net` tree
  - Reviewer explicitly suggested Fixes: 1da177e4c3f4 (signaling stable
    relevance)
  - Reachable from remote unauthenticated attacker on any IPv6 tunnel
    endpoint
  - Author (Borkmann) is a senior networking developer, patch went
    through 3 review iterations
- AGAINST backport:
  - No Fixes: tag in the applied commit (reviewer suggested one but it
    was not added)
  - No Cc: stable tag — but absence is expected per the prompt
  - No user-filed bug report / CVE — the DoS is based on code analysis
    of an analogous, already-fixed vector

**Step 9.2 - Stable Rules Checklist:**
1. Obviously correct and tested? YES — trivial counter, 2 Reviewed-by,
   merged to net
2. Fixes a real bug? YES — remote DoS via crafted IPv6 Destination
   Options
3. Important issue? YES — remote CPU exhaustion in softirq path
   (security-relevant)
4. Small and contained? YES — 6 lines in one function, one file
5. No new features/APIs? YES — purely defensive counter
6. Applies to stable? YES (likely clean; minor context fuzz possible on
   very old trees)

**Step 9.3 - Exception Category:** Not applicable by name, but fits the
spirit of "security hardening for known DoS class" — a strong stable
candidate on its own merits.

**Step 9.4 - Decision:** YES.

# Verification

- [Phase 1] Parsed tags: Reviewed-by: Ido Schimmel, Reviewed-by: Justin
  Iurman, Signed-off-by: Daniel Borkmann, Signed-off-by: Jakub Kicinski.
  No Fixes:, no Cc: stable, no Reported-by, no Link: — verified from
  commit message and `git show 076b8cad77aa9 --format=fuller`
- [Phase 2] Diff analysis: `git diff 076b8cad77aa9^ 076b8cad77aa9` —
  confirmed +6 lines (1 macro, 1 local var, 1 conditional break) in
  `net/ipv6/ip6_tunnel.c`
- [Phase 3] `git blame -L 430,456 net/ipv6/ip6_tunnel.c`: core loop
  attributed to `1da177e4c3f4` (2.6.12-rc2, 2005); surrounding context
  modified by `d375b98e024898` (2024)
- [Phase 3] `git show 47d3d7ac656a`: confirmed the referenced prior
  commit added `max_hbh/dst_opts_cnt/len` to `ip6_parse_tlv()` for an
  identical DoS class in 2017
- [Phase 3] `git log --oneline --author="Daniel Borkmann" -- net/ipv6/`:
  confirmed author has prior ipv6 work (e.g., `47e27d5e92c46`,
  `e41b0bedba029`, `a824d0b83109e`)
- [Phase 4] `b4 dig -c 076b8cad77aa9`: found lore thread `https://lore.k
  ernel.org/all/20260421202406.717885-1-daniel@iogearbox.net/`
- [Phase 4] `b4 dig -a`: confirmed v3 is the applied/final revision;
  changelog shows v1->v2 dropping unlikely and using abs(), v2->v3 hard-
  coding 8 instead of max_dst_opts_cnt per Ido's suggestion
- [Phase 4] `b4 dig -w`: confirmed Kicinski, Dumazet, Ahern, Herbert,
  Abeni and netdev were recipients — proper maintainer review
- [Phase 4] mbox content (`/tmp/tlv_thread.mbox`) lines 340-347: Ido
  Schimmel wrote "Given that you are targeting net and that the issue
  was always present, I would use: Fixes: 1da177e4c3f4
  ('Linux-2.6.12-rc2')" — confirms bug is as old as git history and
  stable-worthy
- [Phase 4] mbox lines 53-80: patchwork bot confirms patch was applied
  to netdev/net.git (main) by Kicinski
- [Phase 5] `git grep "ip6_tnl_parse_tlv_enc_lim"`: confirmed 4 call
  sites (ip6_tnl_err, __ip6_tnl_xmit, ip6gre_err,
  prepare_ip6gre_xmit_ipv6) — all in data/error paths
- [Phase 6] Code since 2.6.12-rc2 → present in all active stable trees
  (5.4, 5.10, 5.15, 6.1, 6.6, 6.12)
- [Phase 8] Failure mode: remote-triggerable CPU exhaustion (~2000
  scanner iterations per extension header) — severity medium-high (DoS),
  quoted directly from the commit message's documented attack
- UNVERIFIED: Exact patch-apply cleanliness on pre-6.7 stable branches
  (the function body was restructured by d375b98e024898 in early 2024).
  The hunk target is the inner `if (nexthdr == NEXTHDR_DEST)` block
  which has been structurally unchanged since 2005, so clean apply is
  expected, but I did not run `git apply` against the individual stable
  branches.
- UNVERIFIED: Whether a CVE has been assigned for this specific scanner
  (no public CVE reference in the commit message or lore thread).

The fix is small, surgical, fixes a real remote DoS, is well-reviewed,
affects a long-present bug in all stable trees, and was applied to the
`net` (bug-fix) tree by the netdev maintainer.

**YES**

 net/ipv6/ip6_tunnel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 0b53488a92290..b9d41b5d1853b 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -62,6 +62,8 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_RTNL_LINK("ip6tnl");
 MODULE_ALIAS_NETDEV("ip6tnl0");
 
+#define IP6_TUNNEL_MAX_DEST_TLVS    8
+
 #define IP6_TUNNEL_HASH_SIZE_SHIFT  5
 #define IP6_TUNNEL_HASH_SIZE (1 << IP6_TUNNEL_HASH_SIZE_SHIFT)
 
@@ -428,11 +430,15 @@ __u16 ip6_tnl_parse_tlv_enc_lim(struct sk_buff *skb, __u8 *raw)
 				break;
 		}
 		if (nexthdr == NEXTHDR_DEST) {
+			int tlv_cnt = 0;
 			u16 i = 2;
 
 			while (1) {
 				struct ipv6_tlv_tnl_enc_lim *tel;
 
+				if (unlikely(tlv_cnt++ >= IP6_TUNNEL_MAX_DEST_TLVS))
+					break;
+
 				/* No more room for encapsulation limit */
 				if (i + sizeof(*tel) > optlen)
 					break;
-- 
2.53.0

