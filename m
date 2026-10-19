Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9B66178A6;
	Mon, 19 Oct 2026 14:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418655; cv=none; b=efwgAP+HtejfWgSM+OVArA0lvohrBWzCeHL1gma2z/4POdXUr7VK4Ac2z8iOUr2EINrTf0eBTdKVcm/TJ8ML3KVIehg7PdXX/Km3DRh6Mf8n4yW4tVwaMPjOrvvzP+6HELeQ52Ie8RVgpFJ0yiUDB2O21+zVrTrQVLsSZLs2no0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418655; c=relaxed/simple;
	bh=vb1BrXPAXRZGl2+QbSVhGabov/4ozl/PA7uJrJGmsW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FyATzkwDPejpR0xepWu8nmZfo0wj9Nt54GY1zLr87di2teBZMa1mHRQkGfy81pbM6KLBQQgXE5CsjrPMqFGutIXI9005kP1dkhFlYUn46jqm1OJf9VUE5NUHc3sEaoppSuXDVM+ik4Gr/TKfuOZC4k7EBy64hgBtKag3RBV9O1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hi73eNEs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hi73eNEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2141F000C6;
	Mon, 19 Oct 2026 14:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418652;
	bh=1X3walW0UzjWCIBQnJ9vLvCPTV6HOoKNhQC6AF6gz4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hi73eNEs13IvjEaavfbwCduP/wbb5EgRVB8H4JuLwY1vghitkDziqjI43L3/q2qbD
	 nc7m/pa4CYqmWSqqdgSG7eunL9lDCh2hiOH8/P709kCYJ6z5X4SLygzlv0BmoywBxJ
	 CJMyef/xz5uM6u+IZnG2fm+bTSjl5161hHPm6iyxHLBJRePYpPU1hGX9u2SHzwna3O
	 p7n0h7rcpq8WT5kFq2NnGxJbfMZ/yM3Wz7wooXySrgAke5XM0X8Hs45bgjEncQs2Re
	 M4Jpj9Bk+H0xW/jAoWJy0S3kdifnt5mGywMfRa/UaoCrCLJGXwvlgMgIxONEKZ2Zxf
	 6pAbMdT7HAbtQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	dsahern@kernel.org,
	idosch@nvidia.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] gre: fix ERSPAN o_flags race/corruption in xmit and fill_info
Date: Mon, 19 Oct 2026 09:51:32 -0400
Message-ID: <20261019135441.1420968-401-sashal@kernel.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9958e69b98930834a576e156f6458166d1db1c02 ]

For IPv4 ERSPAN:
In erspan_xmit(), the driver clears IP_TUNNEL_SEQ_BIT (for version 0)
and IP_TUNNEL_KEY_BIT directly in the shared tunnel->parms.o_flags
structure. Since transmit paths can run locklessly and concurrently,
this leads to a data race.

Furthermore, modifying tunnel->parms.o_flags permanently alters the
tunnel configuration. To work around this, erspan_fill_info() (which
reports config to userspace) was setting IP_TUNNEL_KEY_BIT back. If
erspan_fill_info (running under RTNL) and erspan_xmit (running locklessly)
race, erspan_xmit might see IP_TUNNEL_KEY_BIT set when it shouldn't,
leading to GRE header corruption (injecting a key field into the ERSPAN
GRE header).

Fix this by:
1) Passing flags as an argument to __gre_xmit().
2) Using local stack flags in ipgre_xmit(), gre_tap_xmit(), and erspan_xmit()
   to prevent TOCTOU data races with concurrent configuration updates,
   and passing them to __gre_xmit().
3) Removing the racy modification of t->parms.o_flags in erspan_fill_info().
4) Forcing IP_TUNNEL_KEY_BIT in the reported flags for ERSPAN locally
   in ipgre_fill_info().

For IPv6 ERSPAN:
ip6erspan_tunnel_xmit() was locklessly clearing IP_TUNNEL_KEY_BIT in
t->parms.o_flags even though it does not use these flags for building
the GRE header (it uses local flags). This permanently corrupts the
configuration and races with ip6gre_fill_info() which reads it.

Remove the redundant and racy modification.
This should remove false sharing in a fast path.

Add const qualifiers in ipgre_fill_info(), erspan_fill_info()
and ip6gre_fill_info() to clarify that these methods are not
supposed to write any live parameters.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260812142257.21283-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: the buggy shared `o_flags` mutation is in this
6.12 tree, the APIs match, and the failure mode is GRE header
corruption. Compiling the full analysis.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [gre] [fix] [ERSPAN o_flags race/corruption in xmit and
fill_info]
Subsystem: GRE/ERSPAN tunnels (`net/ipv4/ip_gre.c`,
`net/ipv6/ip6_gre.c`). Action verb is explicitly **fix**.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record (from the candidate text and from the original mailing-list
submission):
- Signed-off-by: Eric Dumazet <edumazet@google.com> (author; networking
  core maintainer)
- Reviewed-by: Simon Horman <horms@kernel.org>
- Link:
  https://patch.msgid.link/20260812142257.21283-1-edumazet@google.com
- Signed-off-by: Jakub Kicinski <kuba@kernel.org> (netdev maintainer,
  applied to net-next)
- Ignore: pipeline "Signed-off-by: Sasha Levin" / "[Upstream commit
  ...]" if present

Original v4 submission (verified in `/tmp/erspan_thread.mbox`) also had:
- Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for
  ERSPAN")
- Fixes: ee496694b9ee ("ip_gre: do not report erspan version on GRE
  interface")
- Fixes: 5a963eb61b7c ("ip6_gre: Add ERSPAN native tunnel support")

v2 was sent to **net** with **Cc: stable@vger.kernel.org**. v4 dropped
Cc: stable and went to net-next after review. Absence of Cc: stable on
the committed v4 is expected for this review pipeline and is not a
negative signal.

No Reported-by / syzbot / Tested-by on this specific patch. Author found
it while working on RTNL-less fill_info.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: IPv4 `erspan_xmit()` locklessly clears `IP_TUNNEL_SEQ_BIT` (v0)
  and `IP_TUNNEL_KEY_BIT` in the **shared** `tunnel->parms.o_flags`.
  That permanently mutates tunnel config. `erspan_fill_info()` then
  writes `IP_TUNNEL_KEY_BIT` back so userspace dumps look correct.
- Symptom: TOCTOU data race between lockless xmit and RTNL fill_info. If
  xmit observes KEY_BIT set, `gre_build_header()` injects a GRE key
  field into the ERSPAN header (malformed GRE / header corruption).
- IPv6: `ip6erspan_tunnel_xmit()` also locklessly clears KEY_BIT on
  shared `t->parms.o_flags` even though it builds the GRE header from
  **local** flags. That is redundant, races with `ip6gre_fill_info()`,
  and causes false sharing on a fast path.
- Root cause: treating per-tunnel `o_flags` as scratch space from
  ndo_start_xmit.
- Versions: Fixes tags point at ERSPAN introduction (2017) and the
  fill_info KEY_BIT workaround (2022). All three are ancestors of this
  6.12 tree.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. This is an explicit race + packet-corruption fix.
Extra `const` on fill_info is documentation-only. Snapshotting flags in
`ipgre_xmit()`/`gre_tap_xmit()` is extra TOCTOU hardening requested by
Ido Schimmel, still a correctness fix, not a feature.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- `net/ipv4/ip_gre.c`: ~+23/-19 in `__gre_xmit`, `ipgre_xmit`,
  `erspan_xmit`, `gre_tap_xmit`, `ipgre_fill_info`, `erspan_fill_info`
- `net/ipv6/ip6_gre.c`: ~+2/-3 in `ip6erspan_tunnel_xmit`,
  `ip6gre_fill_info`
- Scope: single-purpose, two-file surgical fix. `__gre_xmit` is file-
  static; no public API.

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- `__gre_xmit`: no longer copies `tunnel->parms.o_flags` itself; callers
  pass a local flags snapshot.
- `ipgre_xmit` / `gre_tap_xmit`: copy `o_flags` once, use that copy for
  CSUM offload check and header build (closes TOCTOU vs concurrent
  changelink).
- `erspan_xmit`: copy flags, then `__clear_bit` KEY (and SEQ for v0) on
  the **stack copy**, pass that to `__gre_xmit`. Shared `parms.o_flags`
  is no longer written from xmit.
- `erspan_fill_info`: stop writing KEY_BIT into live `t->parms.o_flags`.
- `ipgre_fill_info`: if `erspan_ver != 0 && !collect_md`, set KEY_BIT on
  a **local** dump copy. Regular GRE/GRETAP keep `erspan_ver == 0`
  (`erspan_setup()` is the only path that sets it to 1).
- `ip6erspan_tunnel_xmit`: delete the unused shared
  `__clear_bit(IP_TUNNEL_KEY_BIT, t->parms.o_flags)`.
- fill_info functions: `const` on tunnel/parm pointers.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Race + packet corruption + config corruption]
Mechanism: RMW of a shared bitmap from xmit (`__clear_bit`) vs fill_info
(`__set_bit`). `gre_build_header()` then uses `tun_hlen` (8 for ERSPAN
v1/v2) **and** the flags word. If KEY_BIT is set with SEQ, it writes key
then seq into an 8-byte push, and the key write lands on the GRE
flags/protocol word:

```102:144:include/net/gre.h
static inline void gre_build_header(struct sk_buff *skb, int hdr_len,
                                    const unsigned long *flags, __be16
proto,
                                    __be32 key, __be32 seq)
{
        ...
        skb_push(skb, hdr_len);
        ...
        if (ip_tunnel_flags_intersect(flags, cond)) {
                __be32 *ptr = (__be32 *)(((u8 *)greh) + hdr_len - 4);
                if (test_bit(IP_TUNNEL_SEQ_BIT, flags)) {
                        *ptr = seq;
                        ptr--;
                }
                if (test_bit(IP_TUNNEL_KEY_BIT, flags)) {
                        *ptr = key;
                        ptr--;
                }
```

With `hdr_len == 8` and both SEQ and KEY, KEY overwrites the GRE base
header. That is real on-wire corruption of mirrored traffic.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct. Local snapshot + mutate the copy is the
standard pattern (IPv6 xmit already used local flags). v4 dropped v2's
`gre_calc_hlen(flags)` substitution after review showed it could emit a
4-byte GRE header when SEQ was absent from o_flags; v4 keeps
`tunnel->tun_hlen`, which is the safer stable-friendly approach.
Regression risk is low: no new locks, no API change, fill_info dump
semantics preserved for ERSPAN KEY reporting.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Shared-flag mutation dates to ERSPAN introduction:
- `f551c91de262ba` (2017-12-13) / `84e54fe0a5ea` (2017-08-22): IPv4
  ERSPAN xmit
- `5a963eb61b7c` / `e41c7c68ea7716` (2017): IPv6 ERSPAN
- `ee496694b9ee` (2022-12-03): `erspan_fill_info` KEY_BIT restore
  workaround
- `5832c4a77d693` (2024-03-27): `__be16` flags → bitmaps
  (`__clear_bit`/`__set_bit`); **in this tree**

Bug has been in the driver since 2017; bitmap conversion only changed
the accessor.

Step 3.2: FOLLOW THE FIXES: TAG
Record: All three Fixes SHAs **are ancestors of HEAD**:
- `84e54fe0a5ea` IS ancestor
- `ee496694b9ee` IS ancestor
- `5a963eb61b7c` IS ancestor
Mainline commit `9958e69b9893` is **not** an ancestor of this checkout.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent GRE work in this tree includes `9f948e9aede96` (restore
GRE/GRETAP `lltx`) and capability checks. No prior fix of this o_flags
xmit/fill_info race. Standalone commit (not patch X/Y). v1–v4 were
revisions of the **same** patch.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Eric Dumazet is a net core maintainer with many GRE/tunnel
commits here (`erspan: make sure erspan_base_hdr is present`, header
robustness, etc.). High-confidence author.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Needs `IP_TUNNEL_DECLARE_FLAGS` / `ip_tunnel_flags_copy` /
`ip_tunnel_parm_kern` — all present (`5832c4a77d693`, `117aef12a7b1b`).
`__gre_xmit` is static to `ip_gre.c`. Can apply standalone.

Later mainline discussion (Sept 2026, `net: erspan: set lltx to avoid
sch_direct_xmit deadlock`) names **this commit as a stable
prerequisite** before enabling ERSPAN `lltx`. That later patch is not in
this tree (`erspan_tunnel_init` still does not set `dev->lltx`). This
fix is still valuable on its own because fill_info (RTNL) vs xmit (TX
lock) already race.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- b4 dig matched v4:
  https://patch.msgid.link/20260812142257.21283-1-edumazet@google.com
- Revisions: v1 net-next (2026-06-15), v2 **net + Cc: stable**
  (2026-07-20), v3 net-next (2026-08-11), v4 net-next (2026-08-12,
  applied)
- v1 was sent to net-next because “7.1 was just released” (merge-window
  timing), not because it was considered a feature.
- v2 review (Sashiko): using `gre_calc_hlen(flags)` could emit a 4-byte
  GRE header when SEQ is missing from o_flags; `tun_hlen` previously
  forced 8 bytes. Eric marked CR (“What a mess”).
- v4 dropped that `gre_calc_hlen` change and kept `tun_hlen`.
- No NAK. Horman Reviewed-by. Jakub applied to netdev/net-next as
  `9958e69b9893`.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Recipients: davem, kuba, pabeni, horms, idosch, netdev. Ido
asked v1 to snapshot flags in ipgre/gretap too (done in v4). Horman
reviewed v4. Appropriate maintainers.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla for this race. Author discovered it while
working on RTNL-less fill_info. Trigger is ordinary: ERSPAN TX plus `ip
-d link show` / RTNL dump.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Single-patch series. Follow-up ERSPAN `lltx` deadlock fix
depends on this for “no shared mutable o_flags in xmit.” Author agreed
to list this as a stable prerequisite for that later patch.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No lore.kernel.org/stable thread found that rejected this fix.
v2 was explicitly Cc'd to stable. The later lltx discussion notes this
commit was **not auto-queued** because v4 lacked Cc: stable — which is
why it is in this evaluation pipeline.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `__gre_xmit`, `ipgre_xmit`, `erspan_xmit`, `gre_tap_xmit`,
`ipgre_fill_info`, `erspan_fill_info`, `ip6erspan_tunnel_xmit`,
`ip6gre_fill_info`.

Step 5.2: TRACE CALLERS
Record:
- `erspan_xmit` / `ipgre_xmit` / `gre_tap_xmit` /
  `ip6erspan_tunnel_xmit`: `ndo_start_xmit` (hot path).
- `ipgre_fill_info`: GRE and GRETAP `rtnl_link_ops.fill_info`; also
  called from `erspan_fill_info`.
- `erspan_fill_info` / `ip6gre_fill_info`: netlink dump.

Step 5.3: TRACE CALLEES
Record: `gre_build_header`, `gre_handle_offloads` →
`iptunnel_handle_offloads`, `ip_tunnel_xmit` / `ip6_tnl_xmit`,
`ip_tunnel_flags_copy`, `__clear_bit`/`__set_bit`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace-reachable: send on an ERSPAN/GRE/GRETAP netdev; dump
via RTNL (`ip link`). Unprivileged users typically cannot create tunnels
(needs CAP_NET_ADMIN), but once created, TX is a normal data path. Not
theoretical.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: IPv6 native GRE already snapshots flags in `__gre6_xmit`. IPv6
fill_info already set KEY_BIT on a **local** copy. IPv4 ERSPAN was the
inconsistent leftover that mutated live parms.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** Local tree is **6.12.111** (`pending-6.12`,
`p-6.12-3-gc504cf0baa3d8`).
Verified present:
```746:747:net/ipv4/ip_gre.c
        __clear_bit(IP_TUNNEL_KEY_BIT, tunnel->parms.o_flags);
        __gre_xmit(skb, dev, &tunnel->parms.iph, proto);
```
```1603:1604:net/ipv4/ip_gre.c
                if (t->erspan_ver != 0 && !t->collect_md)
                        __set_bit(IP_TUNNEL_KEY_BIT, t->parms.o_flags);
```
```999:999:net/ipv6/ip6_gre.c
        __clear_bit(IP_TUNNEL_KEY_BIT, t->parms.o_flags);
```
Bug introduced 2017; fill_info KEY restore 2022. Both long before 6.12.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Expected apply: **minor context fuzz**, not a rewrite.
This tree’s `gre_rcv` drop path lacks `dev_core_stats_rx_dropped_inc()`
that appears as context in the mainline hunk; `__gre_xmit` itself
matches. All other hunks match current 6.12 code
(`IP_TUNNEL_DECLARE_FLAGS`, `ip_tunnel_parm_kern`, function layout). No
conflicting refactor.

Note: IPv4/IPv6 ERSPAN **do not** set `dev->lltx` here
(`erspan_tunnel_init` / `ip6erspan_tap_init`). Concurrent xmit on one
ERSPAN device is still serialized by `_xmit_lock`. The **fill_info
(RTNL) vs xmit (TX lock)** race remains, and any future ERSPAN lltx
backport would make concurrent xmit racy without this patch.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: `git log --grep="fix ERSPAN o_flags race"` on these files:
empty. No equivalent fix in this tree.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [net/ipv4 GRE + net/ipv6 GRE ERSPAN] [IMPORTANT]
Not core mm/VFS, but a widely used tunnel type (SPAN/ERSPAN mirroring,
cloud TAP, Kubernetes). Packet corruption on the mirror path is user-
visible.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature GRE/ERSPAN (since 4.x). Still receiving correctness fixes
(lltx, headroom, capability checks). This is a long-standing bug, not
churn from new code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver/config-specific: IPv4 ERSPAN (primary), IPv6 ERSPAN
(shared o_flags clear), plus GRE/GRETAP get a small TOCTOU snapshot.
Anyone running ERSPAN mirrors plus netlink dumps.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Trigger: ERSPAN transmit concurrent with RTNL dump (`ip -d link
show`, monitoring agents). Common in production TAP setups. Creating the
tunnel needs CAP_NET_ADMIN; TX after that is the normal data path.
Timing-dependent, but the window is every dump-vs-packet overlap, not a
one-in-a-billion theoretical race.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [GRE header corruption / wrong optional fields / overwrite of
GRE flags+protocol when KEY is injected into an 8-byte header] [HIGH]
Also: permanent clear of KEY_BIT in live config until fill_info writes
it back; data race on a bitmap word (KCSAN-class). Not a panic by
itself, but corrupted mirrored packets and broken GRE layout. Stable
rules treat this class of correctness bugs as important.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: HIGH for ERSPAN users (stops header corruption and config
  clobber; unblocks a correct lltx backport later).
- Risk: LOW (~25 net lines, local stack flags, no locking change, no
  uAPI change, reviewed by Horman/Ido, written by Dumazet).
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real race: xmit mutates shared `o_flags`; fill_info writes KEY_BIT
  back under a different lock (RTNL vs TX lock).
- Concrete failure: KEY_BIT observed in `gre_build_header()` with
  `tun_hlen==8` overwrites the GRE base header.
- Buggy code is in this 6.12 tree; Fixes commits are ancestors.
- Small, obviously correct, no new APIs.
- Author is a net maintainer; Horman Reviewed-by; Ido requested the
  GRE/GRETAP snapshot.
- v2 was Cc: stable; later ERSPAN lltx work calls this a stable
  prerequisite.
- v4 kept `tun_hlen` after review found v2’s `gre_calc_hlen` unsafe.

AGAINST:
- v4 landed in net-next without Cc: stable (timing/review, not a NAK).
- IPv4 ERSPAN is not yet lltx here, so concurrent xmit is serialized;
  the remaining race is dump vs TX (still real).
- First hunk may need trivial context adjustment around `gre_rcv`.
- Extra snapshots in `ipgre_xmit`/`gre_tap_xmit` are slightly broader
  than the ERSPAN-only bug, but they are the same pattern and low risk.

UNRESOLVED: none that affect the verdict. Could not fetch
lore.kernel.org HTML (403); used b4 mbox + openwall mirrors instead.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — local snapshot, reviewed,
   applied upstream.
2. Fixes a real bug that affects users? **PASS** — ERSPAN GRE
   header/config corruption.
3. Important issue? **PASS** — HIGH: on-wire header corruption (not a
   panic, but not cosmetic).
4. Small and contained? **PASS** — ~25 lines, two files, static helper
   signature only.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — buggy code and bitmap APIs
   present; minor gre_rcv context at most.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary
networking correctness fix.

Step 9.4: MAKE YOUR DECISION
This belongs in **this** 6.12 tree. The bug is here, the fix is small
and correct, and it prevents GRE header corruption on ERSPAN plus
shared-state races that a later lltx change would make worse.

What the commit solves for stable users: ERSPAN xmit must not clear
KEY/SEQ in the live tunnel parms. Doing so races with netlink fill_info
and can inject a GRE key into an 8-byte ERSPAN GRE header, corrupting
mirrored packets. Snapshot flags on the stack and report KEY only on the
dump copy.

Risk vs benefit: low risk, high benefit for ERSPAN. Apply with at most a
small context tweak on the `__gre_xmit` hunk.

Verification:
- [Phase 1] Parsed subject/tags; original v4 mbox has Fixes:
  84e54fe0a5ea, ee496694b9ee, 5a963eb61b7c; v2 had Cc: stable
- [Phase 2] Diff: local flags to `__gre_xmit`; stop mutating
  `parms.o_flags` in erspan_xmit/fill_info and ip6erspan xmit
- [Phase 2] `gre_build_header()` with hdr_len=8 + KEY+SEQ overwrites GRE
  base header — verified in `include/net/gre.h`
- [Phase 3] blame: mutation since 2017 ERSPAN; bitmap conversion
  5832c4a77d693 in this tree
- [Phase 3] `git merge-base --is-ancestor` all three Fixes SHAs: yes;
  9958e69b9893: no
- [Phase 4] `b4 dig -c 9958e69b9893`: lore msgid 20260812142257.21283-1;
  v2/v3/v4; Horman Reviewed-by; no NAK
- [Phase 4] Ido asked for ipgre/gretap snapshots; Sashiko caught v2
  gre_calc_hlen malformation; v4 dropped that
- [Phase 4] Later lltx deadlock thread names this commit as stable
  prerequisite
- [Phase 5] Callers are ndo_start_xmit and RTNL fill_info
- [Phase 6] `git describe HEAD`: p-6.12-3-gc504cf0baa3d8; `make
  kernelversion`: 6.12.111; buggy `__clear_bit`/`__set_bit` present
- [Phase 6] ERSPAN init does not set lltx in this tree; fill_info vs
  xmit still races
- [Phase 8] Failure mode: GRE header corruption, severity HIGH
- UNVERIFIED: lore.kernel.org HTML 403 (used b4 + openwall); no stable-
  list rejection found

**YES**

 net/ipv4/ip_gre.c  | 42 +++++++++++++++++++++++-------------------
 net/ipv6/ip6_gre.c |  5 ++---
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index b15cc4ee0d920..b1ec4f92d3462 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -474,12 +474,9 @@ static int gre_rcv(struct sk_buff *skb)
 
 static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 		       const struct iphdr *tnl_params,
-		       __be16 proto)
+		       __be16 proto, const unsigned long *flags)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
-	IP_TUNNEL_DECLARE_FLAGS(flags);
-
-	ip_tunnel_flags_copy(flags, tunnel->parms.o_flags);
 
 	/* Push GRE header. */
 	gre_build_header(skb, tunnel->tun_hlen,
@@ -652,6 +649,7 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 			      struct net_device *dev)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
+	IP_TUNNEL_DECLARE_FLAGS(flags);
 	const struct iphdr *tnl_params;
 
 	if (!pskb_inet_may_pull(skb))
@@ -687,11 +685,12 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 		tnl_params = &tunnel->parms.iph;
 	}
 
-	if (gre_handle_offloads(skb, test_bit(IP_TUNNEL_CSUM_BIT,
-					      tunnel->parms.o_flags)))
+	ip_tunnel_flags_copy(flags, tunnel->parms.o_flags);
+
+	if (gre_handle_offloads(skb, test_bit(IP_TUNNEL_CSUM_BIT, flags)))
 		goto free_skb;
 
-	__gre_xmit(skb, dev, tnl_params, skb->protocol);
+	__gre_xmit(skb, dev, tnl_params, skb->protocol, flags);
 	return NETDEV_TX_OK;
 
 free_skb:
@@ -704,6 +703,7 @@ static netdev_tx_t erspan_xmit(struct sk_buff *skb,
 			       struct net_device *dev)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
+	IP_TUNNEL_DECLARE_FLAGS(flags);
 	bool truncate = false;
 	__be16 proto;
 
@@ -727,10 +727,12 @@ static netdev_tx_t erspan_xmit(struct sk_buff *skb,
 		truncate = true;
 	}
 
+	ip_tunnel_flags_copy(flags, tunnel->parms.o_flags);
+
 	/* Push ERSPAN header */
 	if (tunnel->erspan_ver == 0) {
 		proto = htons(ETH_P_ERSPAN);
-		__clear_bit(IP_TUNNEL_SEQ_BIT, tunnel->parms.o_flags);
+		__clear_bit(IP_TUNNEL_SEQ_BIT, flags);
 	} else if (tunnel->erspan_ver == 1) {
 		erspan_build_header(skb, ntohl(tunnel->parms.o_key),
 				    tunnel->index,
@@ -745,8 +747,8 @@ static netdev_tx_t erspan_xmit(struct sk_buff *skb,
 		goto free_skb;
 	}
 
-	__clear_bit(IP_TUNNEL_KEY_BIT, tunnel->parms.o_flags);
-	__gre_xmit(skb, dev, &tunnel->parms.iph, proto);
+	__clear_bit(IP_TUNNEL_KEY_BIT, flags);
+	__gre_xmit(skb, dev, &tunnel->parms.iph, proto, flags);
 	return NETDEV_TX_OK;
 
 free_skb:
@@ -759,6 +761,7 @@ static netdev_tx_t gre_tap_xmit(struct sk_buff *skb,
 				struct net_device *dev)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
+	IP_TUNNEL_DECLARE_FLAGS(flags);
 
 	if (!pskb_inet_may_pull(skb))
 		goto free_skb;
@@ -768,14 +771,15 @@ static netdev_tx_t gre_tap_xmit(struct sk_buff *skb,
 		return NETDEV_TX_OK;
 	}
 
-	if (gre_handle_offloads(skb, test_bit(IP_TUNNEL_CSUM_BIT,
-					      tunnel->parms.o_flags)))
+	ip_tunnel_flags_copy(flags, tunnel->parms.o_flags);
+
+	if (gre_handle_offloads(skb, test_bit(IP_TUNNEL_CSUM_BIT, flags)))
 		goto free_skb;
 
 	if (skb_cow_head(skb, dev->needed_headroom))
 		goto free_skb;
 
-	__gre_xmit(skb, dev, &tunnel->parms.iph, htons(ETH_P_TEB));
+	__gre_xmit(skb, dev, &tunnel->parms.iph, htons(ETH_P_TEB), flags);
 	return NETDEV_TX_OK;
 
 free_skb:
@@ -1571,12 +1575,15 @@ static size_t ipgre_get_size(const struct net_device *dev)
 
 static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
-	struct ip_tunnel *t = netdev_priv(dev);
-	struct ip_tunnel_parm_kern *p = &t->parms;
+	const struct ip_tunnel *t = netdev_priv(dev);
+	const struct ip_tunnel_parm_kern *p = &t->parms;
 	IP_TUNNEL_DECLARE_FLAGS(o_flags);
 
 	ip_tunnel_flags_copy(o_flags, p->o_flags);
 
+	if (t->erspan_ver != 0 && !t->collect_md)
+		__set_bit(IP_TUNNEL_KEY_BIT, o_flags);
+
 	if (nla_put_u32(skb, IFLA_GRE_LINK, p->link) ||
 	    nla_put_be16(skb, IFLA_GRE_IFLAGS,
 			 gre_tnl_flags_to_gre_flags(p->i_flags)) ||
@@ -1619,12 +1626,9 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 static int erspan_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
-	struct ip_tunnel *t = netdev_priv(dev);
+	const struct ip_tunnel *t = netdev_priv(dev);
 
 	if (t->erspan_ver <= 2) {
-		if (t->erspan_ver != 0 && !t->collect_md)
-			__set_bit(IP_TUNNEL_KEY_BIT, t->parms.o_flags);
-
 		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
 			goto nla_put_failure;
 
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index ebd0198458cd3..905c22e6990b8 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -967,7 +967,6 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	if (skb_cow_head(skb, dev->needed_headroom ?: t->hlen))
 		goto tx_err;
 
-	__clear_bit(IP_TUNNEL_KEY_BIT, t->parms.o_flags);
 	IPCB(skb)->flags = 0;
 
 	/* For collect_md mode, derive fl6 from the tunnel key,
@@ -2116,8 +2115,8 @@ static size_t ip6gre_get_size(const struct net_device *dev)
 
 static int ip6gre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
-	struct ip6_tnl *t = netdev_priv(dev);
-	struct __ip6_tnl_parm *p = &t->parms;
+	const struct ip6_tnl *t = netdev_priv(dev);
+	const struct __ip6_tnl_parm *p = &t->parms;
 	IP_TUNNEL_DECLARE_FLAGS(o_flags);
 
 	ip_tunnel_flags_copy(o_flags, p->o_flags);
-- 
2.53.0

