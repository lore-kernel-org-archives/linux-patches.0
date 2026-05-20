Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B853DD538;
	Wed, 20 May 2026 11:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276016; cv=none; b=ZO5I8/Bpmd5SriwwEhVMG30wCTOX3+Tc45Uxp7GNWUqC5xWVqwJURXLQe19G1EfQmcgs9icRYsThtAEjJRMSe8vbgn3IsYZV1iGDFnaHyGGOUmJTi3xDiTMoglSIgDpsLD9O1v/Tf2q3WZtU9NYxkEC1QSnG3bIe8fvveT4h9oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276016; c=relaxed/simple;
	bh=FWsT6Yc/EVkU3tMWDeSo15/ZB5regyWNgHN7XRZLyl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+sDC8iGj1yaMDTvF839uiyJZYNR1ZfGbQ6vF0oDkwQ4p2JkYILRZZNYXa4NqduxgL1ULYZ+31CLgHpyBuES+bdwMjA54q2cZEv3dJOXBAVgQBeMkTv1sMDhemY4zqiAlQrpbmDMT52Cn0xsctGvdXLX1iFnVAOGFtLREF2BGmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xd/VeaBx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xd/VeaBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2BE1F00897;
	Wed, 20 May 2026 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276010;
	bh=xMgtOFONSiE9sCxTbzj5oq9sEYekYwDjn2mOoCFmkls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xd/VeaBxubOtpEkPPxWDeTg9Ir9zvTe4pLosUoSqCGbL66oZlkoYeiqFDSsmhwgyY
	 20sTGK5PF2m5hsi71k+q8Kn8FntjaNiyxD46a21tyUX3STmAeDAfE3NuwUBYF7cj44
	 Vns72r4LC1S9XMKllYL/xkErF6kaD+O6tjN/KG79MLxnXBMl3EKnT0fiAiScsfsz/9
	 ee2XmwJ3ZA9b+Ad7BwSggS/YJwYQ9+8jC8YcVpEjHCCNileKu88KUzbqXUTUFATzlQ
	 A3dEKEm1u7953084LDMhDj8nUtNl7Psmfg6z1mhTFLSaN+fPWa+AsynvpylUWb8l+3
	 4NRH41ETyWYRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Justin Iurman <justin.iurman@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	pabeni@redhat.com,
	dsahern@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] ipv6: Implement limits on extension header parsing
Date: Wed, 20 May 2026 07:18:50 -0400
Message-ID: <20260520111944.3424570-18-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Transfer-Encoding: 8bit

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 3744b0964d5267c0b651bcd8f8c25db6bf4ccbac ]

ipv6_{skip_exthdr,find_hdr}() and ip6_{tnl_parse_tlv_enc_lim,
protocol_deliver_rcu}() iterate over IPv6 extension headers until they
find a non-extension-header protocol or run out of packet data. The
loops have no iteration counter, relying solely on the packet length
to bound them. For a crafted packet with 8-byte extension headers
filling a 64KB jumbogram, this means a worst case of up to ~8k
iterations with a skb_header_pointer call each. ipv6_skip_exthdr(),
for example, is used where it parses the inner quoted packet inside
an incoming ICMPv6 error:

  - icmpv6_rcv
    - checksum validation
    - case ICMPV6_DEST_UNREACH
      - icmpv6_notify
        - pskb_may_pull()       <- pull inner IPv6 header
        - ipv6_skip_exthdr()    <- iterates here
        - pskb_may_pull()
        - ipprot->err_handler() <- sk lookup

The per-iteration cost of ipv6_skip_exthdr itself is generally
light, but skb_header_pointer becomes more costly on reassembled
packets: the first ~1232 bytes of the inner packet are in the skb's
linear area, but the remaining ~63KB are in the frag_list where
skb_copy_bits is needed to read data.

Initially, the idea was to add a configurable limit via a new
sysctl knob with default 8, in line with knobs from commit
47d3d7ac656a ("ipv6: Implement limits on Hop-by-Hop and Destination
options"), but two reasons eventually argued against it:

- It adds to UAPI that needs to be maintained forever, and
  upcoming work is restricting extension header ordering anyway,
  leaving little reason for another sysctl knob
- exthdrs_core.c is always built-in even when CONFIG_IPV6=n,
  where struct net has no .ipv6 member, so the read site would
  need an ifdef'd fallback to a constant anyway

Therefore, just use a constant (IP6_MAX_EXT_HDRS_CNT). All four
extension header walking functions are now bound by this limit.

Note that the check in ip6_protocol_deliver_rcu() happens right
before the goto resubmit, such that we don't have to have a test
for ipv6_ext_hdr() in the fast-path.

There's an ongoing IETF draft-iurman-6man-eh-occurrences to enforce
IPv6 extension headers ordering and occurrence. The latter also
discusses security implications. As per RFC8200 section 4.1, the
occurrence rules for extension headers provide a practical upper
bound which is 8. In order to be conservative, let's define
IP6_MAX_EXT_HDRS_CNT as 12 to leave enough room for quirky setups.
In the unlikely event that this is still not enough, then we might
need to reconsider a sysctl.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Link: https://patch.msgid.link/20260429154648.809751-1-daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Decision Summary
This should be backported. It is a small IPv6 networking hardening/fix
for a reachable CPU-exhaustion path: several IPv6 extension-header
walkers were bounded only by packet length, allowing crafted packets
with many minimal 8-byte extension headers to force thousands of
iterations. The patch caps traversal at 12 headers, avoids new UAPI, and
was reviewed by IPv6/networking reviewers. Risk is mainly dropping
extremely exotic packets with more than 12 extension headers; the review
discussion explicitly considered that and settled on 12 as a
conservative compromise.

## Phase Walkthrough
Phase 1: Commit Message Forensics

Record 1.1: Subsystem `ipv6`; action verb `Implement limits`; claimed
intent is to bound IPv6 extension-header parsing loops.

Record 1.2: Tags found: `Signed-off-by: Daniel Borkmann`, `Reviewed-by:
Ido Schimmel`, `Reviewed-by: Eric Dumazet`, `Reviewed-by: Justin
Iurman`, `Link:
https://patch.msgid.link/20260429154648.809751-1-daniel@iogearbox.net`,
`Signed-off-by: Jakub Kicinski`. No `Fixes:`, no `Reported-by:`, no `Cc:
stable`.

Record 1.3: The body describes crafted 64KB packets with 8-byte
extension headers causing up to about 8k iterations, with costly
`skb_header_pointer()`/`skb_copy_bits()` on reassembled packets. Symptom
is CPU work amplification/DoS potential, not memory corruption or crash.
It identifies `icmpv6_rcv -> icmpv6_notify -> ipv6_skip_exthdr()` as a
concrete path.

Record 1.4: This is not disguised cleanup. It is a direct
correctness/security hardening fix: add a bound to previously unbounded
loops.

Phase 2: Diff Analysis

Record 2.1: Five files changed, 25 insertions: `include/net/dropreason-
core.h` +6, `include/net/ipv6.h` +3, `net/ipv6/exthdrs_core.c` +7,
`net/ipv6/ip6_input.c` +5, `net/ipv6/ip6_tunnel.c` +4. Modified
functions: `ipv6_skip_exthdr()`, `ipv6_find_hdr()`,
`ip6_protocol_deliver_rcu()`, `ip6_tnl_parse_tlv_enc_lim()`.

Record 2.2: Before, these loops stopped only at non-extension-header,
`NEXTHDR_NONE`, malformed/truncated packet data, fragment handling, or
protocol handler completion. After, each loop also stops/drops once
`IP6_MAX_EXT_HDRS_CNT` is exceeded.

Record 2.3: Bug category is logic/performance DoS hardening: missing
iteration bound in packet parser. It does not fix UAF/leak/race, but it
prevents attacker-controlled excessive parsing work.

Record 2.4: Fix quality is good: small, local counters, no locking or
lifetime changes, no new sysctl/API. Regression risk is limited to
rejecting packets with more than 12 traversed extension headers.

Phase 3: Git History Investigation

Record 3.1: `git blame` shows the relevant loops are old:
`ipv6_skip_exthdr()` loop traces to initial/early history with later
signature changes; `ipv6_find_hdr()` to v3.8-era code;
`ip6_protocol_deliver_rcu()` resubmit logic to v4.x/v5.0-era changes;
`ip6_tnl_parse_tlv_enc_lim()` exists from initial/older tunnel code with
later cleanups.

Record 3.2: No `Fixes:` tag, so no introducing commit to follow. I did
inspect referenced commit `47d3d7ac656a`, which added limits for Hop-by-
Hop/Destination TLV parsing and described similar DoS behavior.

Record 3.3: Recent file history shows related commit `076b8cad77aa9`
capped TLV scanning in `ip6_tnl_parse_tlv_enc_lim()`. This commit is
related but not a hard dependency for the outer extension-header-count
limit.

Record 3.4: Daniel Borkmann has recent related IPv6 limit work in the
same area. Commit was applied by Jakub Kicinski, and reviewed by Eric
Dumazet, Ido Schimmel, and Justin Iurman.

Record 3.5: No functional prerequisite was found for the core idea.
Older stable trees before `dropreason-core.h` will need a small backport
adjustment for the new drop reason, or can use an existing generic
reason.

Phase 4: Mailing List And External Research

Record 4.1: `b4 dig -c 3744b0964d5267c0b651bcd8f8c25db6bf4ccbac` found
`[PATCH net v5]` at the provided lore/patch.msgid link.

Record 4.2: `b4 dig -a` found v1 through v5. v1 added a sysctl and was
NAKed by Justin Iurman; v4 switched to a hard-coded limit; v5 reduced
the limit from 32 to 12.

Record 4.3: No `Reported-by` or bug-report link exists. Web/lore stable
search did not find a stable-specific request or objection.

Record 4.4: Related series context: review discussion referenced IETF
extension-header occurrence work; v5 was the latest and accepted
version.

Record 4.5: No stable mailing-list-specific discussion found. WebFetch
to lore was blocked/timed out, but `b4` successfully retrieved the
thread.

Phase 5: Code Semantic Analysis

Record 5.1: Key functions are `ipv6_skip_exthdr()`, `ipv6_find_hdr()`,
`ip6_protocol_deliver_rcu()`, `ip6_tnl_parse_tlv_enc_lim()`.

Record 5.2: `git grep` found many callers of `ipv6_skip_exthdr()` across
netfilter, XFRM/ESP, drivers, audit/security hooks, ICMPv6, and tunnel
code. `ipv6_find_hdr()` is used by netfilter/nftables, BPF, OVS, IPVS,
SRv6, drivers, and TC. `ip6_protocol_deliver_rcu()` is called from IPv6
input and UDP encapsulation resubmission. `ip6_tnl_parse_tlv_enc_lim()`
is called from GRE/tunnel paths.

Record 5.3: Key callees are `skb_header_pointer()`, `pskb_pull()`,
`pskb_may_pull()`, `raw6_local_deliver()`, `inet6_protos[]` dispatch,
and protocol handlers.

Record 5.4: Reachability is verified from IPv6 receive paths:
`ip6_input_finish()` calls `ip6_protocol_deliver_rcu()`, and
`icmpv6_notify()` calls `ipv6_skip_exthdr()` on quoted inner packets.
These are network packet processing paths.

Record 5.5: Similar prior pattern exists in `47d3d7ac656a` for TLV
count/length limits and in `076b8cad77aa9` for tunnel TLV scanning.

Phase 6: Stable Tree Analysis

Record 6.1: The four key functions exist in checked tags `v5.10`,
`v5.15`, `v6.1`, `v6.6`, `v6.12`, and `v6.19`. Thus the affected code
shape exists across active LTS/stable ranges.

Record 6.2: Expected backport difficulty: clean or minor for newer
trees; minor rework for pre-`dropreason-core.h` trees because
`include/net/dropreason-core.h` is absent in `v5.10`, `v5.15`, and
`v6.1`.

Record 6.3: No alternate stable-specific fix for this exact extension-
header traversal count was found. Related TLV-limiting commits address
adjacent, not identical, loops.

Phase 7: Subsystem Context

Record 7.1: Subsystem is IPv6 networking, criticality IMPORTANT to CORE
for IPv6-enabled systems because packet receive, ICMPv6, netfilter,
tunnel, and driver offload paths call these helpers.

Record 7.2: Subsystem is active; recent history shows multiple
IPv6/tunnel/drop-reason changes, but the unbounded parsing loops
themselves are longstanding.

Phase 8: Impact And Risk

Record 8.1: Affected users are IPv6-enabled systems, especially systems
exposed to crafted IPv6 traffic or using IPv6 tunnels/netfilter paths.

Record 8.2: Trigger is a crafted IPv6 packet chain with many small
extension headers, especially costly when parsed from
fragmented/reassembled skb data. Network reachability depends on
filtering and IPv6 deployment.

Record 8.3: Failure mode is CPU work amplification/DoS risk, not crash
or corruption. Severity: HIGH for exposed IPv6 hosts because it is
remote packet-triggered parser amplification; not CRITICAL because no
verified panic, data loss, or privilege escalation was found.

Record 8.4: Benefit is high: caps an attacker-controlled loop in common
networking code. Risk is low-to-medium: packets with more than 12
traversed extension headers may now be rejected, but reviewers
explicitly judged 12 conservative relative to RFC/IETF occurrence
expectations.

Phase 9: Final Synthesis

Record 9.1: Evidence for backporting: small 25-line fix; real attacker-
controlled parser amplification; network receive reachability verified;
reviewed by networking experts; v1 concerns were resolved; no new UAPI.
Evidence against: behavior change for extreme extension-header chains;
older trees need minor drop-reason backport adjustment; no syzbot/user
report/CVE. Unresolved: no benchmark for this exact v5 patch was found,
and no stable-specific discussion was found.

Record 9.2: Stable rules: obviously correct and reviewed, yes; fixes a
real bug, yes; important issue, yes as network DoS/performance
amplification; small and contained, yes; no new feature/API, yes; stable
apply, likely clean for newer trees and minor adjustment for older
trees.

Record 9.3: No automatic exception category applies. This is not a
device ID, quirk, DT, build, or documentation fix.

Record 9.4: The risk-benefit balance favors backporting.

## Verification
- [Phase 1] Parsed `git show 3744b0964d5267c0b651bcd8f8c25db6bf4ccbac`:
  verified subject, tags, message, and 25-line diff.
- [Phase 2] Read local code in `net/ipv6/exthdrs_core.c`,
  `net/ipv6/ip6_input.c`, `net/ipv6/ip6_tunnel.c`, and
  `include/net/ipv6.h`: verified loops were unbounded before the patch.
- [Phase 3] Ran `git blame` on changed regions: verified long-lived code
  and relevant commit ancestry.
- [Phase 3] Inspected `47d3d7ac656a` and `076b8cad77aa9`: verified
  similar prior DoS-limit work.
- [Phase 4] Ran `b4 dig -c`, `b4 dig -a`, `b4 dig -w`, and `b4 mbox`:
  verified v1-v5 history, reviewers, NAK of sysctl approach, and v5
  acceptance.
- [Phase 5] Ran caller searches for all four functions: verified broad
  IPv6/netfilter/tunnel/driver call surface.
- [Phase 6] Checked `v5.10`, `v5.15`, `v6.1`, `v6.6`, `v6.12`, `v6.19`:
  verified the affected functions exist; verified `dropreason-core.h` is
  absent before v6.6.
- [Phase 8] Verified reachable call paths in `icmpv6_notify()`,
  `ip6_input_finish()`, `udpv6_queue_rcv_skb()`, and `ip6_gre` tunnel
  code.
- UNVERIFIED: exact exploitability impact across real networks and exact
  CPU-cost benchmark for this specific v5 patch.
- UNVERIFIED: clean application to every currently maintained stable
  branch; older trees likely need minor drop-reason context adjustment.

**YES**

 include/net/dropreason-core.h | 6 ++++++
 include/net/ipv6.h            | 3 +++
 net/ipv6/exthdrs_core.c       | 7 +++++++
 net/ipv6/ip6_input.c          | 5 +++++
 net/ipv6/ip6_tunnel.c         | 4 ++++
 5 files changed, 25 insertions(+)

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index a7b7abd66e215..0b674a02665ab 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -102,6 +102,7 @@
 	FN(FRAG_TOO_FAR)		\
 	FN(TCP_MINTTL)			\
 	FN(IPV6_BAD_EXTHDR)		\
+	FN(IPV6_TOO_MANY_EXTHDRS)	\
 	FN(IPV6_NDISC_FRAG)		\
 	FN(IPV6_NDISC_HOP_LIMIT)	\
 	FN(IPV6_NDISC_BAD_CODE)		\
@@ -513,6 +514,11 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_MINTTL,
 	/** @SKB_DROP_REASON_IPV6_BAD_EXTHDR: Bad IPv6 extension header. */
 	SKB_DROP_REASON_IPV6_BAD_EXTHDR,
+	/**
+	 * @SKB_DROP_REASON_IPV6_TOO_MANY_EXTHDRS: Number of IPv6 extension
+	 * headers in the packet exceeds IP6_MAX_EXT_HDRS_CNT.
+	 */
+	SKB_DROP_REASON_IPV6_TOO_MANY_EXTHDRS,
 	/** @SKB_DROP_REASON_IPV6_NDISC_FRAG: invalid frag (suppress_frag_ndisc). */
 	SKB_DROP_REASON_IPV6_NDISC_FRAG,
 	/** @SKB_DROP_REASON_IPV6_NDISC_HOP_LIMIT: invalid hop limit. */
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 53c5056508be5..ec95c11b8e434 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -90,6 +90,9 @@ struct ip_tunnel_info;
 #define IP6_DEFAULT_MAX_DST_OPTS_LEN	 INT_MAX /* No limit */
 #define IP6_DEFAULT_MAX_HBH_OPTS_LEN	 INT_MAX /* No limit */
 
+/* Hard limit on traversed IPv6 extension headers */
+#define IP6_MAX_EXT_HDRS_CNT		 12
+
 /*
  *	Addr type
  *	
diff --git a/net/ipv6/exthdrs_core.c b/net/ipv6/exthdrs_core.c
index 49e31e4ae7b7f..9d06d487e8b10 100644
--- a/net/ipv6/exthdrs_core.c
+++ b/net/ipv6/exthdrs_core.c
@@ -73,6 +73,7 @@ int ipv6_skip_exthdr(const struct sk_buff *skb, int start, u8 *nexthdrp,
 		     __be16 *frag_offp)
 {
 	u8 nexthdr = *nexthdrp;
+	int exthdr_cnt = 0;
 
 	*frag_offp = 0;
 
@@ -82,6 +83,8 @@ int ipv6_skip_exthdr(const struct sk_buff *skb, int start, u8 *nexthdrp,
 
 		if (nexthdr == NEXTHDR_NONE)
 			return -1;
+		if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT))
+			return -1;
 		hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
 		if (!hp)
 			return -1;
@@ -190,6 +193,7 @@ int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
 {
 	unsigned int start = skb_network_offset(skb) + sizeof(struct ipv6hdr);
 	u8 nexthdr = ipv6_hdr(skb)->nexthdr;
+	int exthdr_cnt = 0;
 	bool found;
 
 	if (fragoff)
@@ -216,6 +220,9 @@ int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
 			return -ENOENT;
 		}
 
+		if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT))
+			return -EBADMSG;
+
 		hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
 		if (!hp)
 			return -EBADMSG;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 2bcb981c91aa8..bbad1d4e6b854 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -363,6 +363,7 @@ INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struct sk_buff *));
 void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 			      bool have_final)
 {
+	int exthdr_cnt = IP6CB(skb)->flags & IP6SKB_HOPBYHOP ? 1 : 0;
 	const struct inet6_protocol *ipprot;
 	struct inet6_dev *idev;
 	unsigned int nhoff;
@@ -447,6 +448,10 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 				nexthdr = ret;
 				goto resubmit_final;
 			} else {
+				if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT)) {
+					SKB_DR_SET(reason, IPV6_TOO_MANY_EXTHDRS);
+					goto discard;
+				}
 				goto resubmit;
 			}
 		} else if (ret == 0) {
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 0b53488a92290..c1ca9b2806359 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -400,11 +400,15 @@ __u16 ip6_tnl_parse_tlv_enc_lim(struct sk_buff *skb, __u8 *raw)
 	unsigned int nhoff = raw - skb->data;
 	unsigned int off = nhoff + sizeof(*ipv6h);
 	u8 nexthdr = ipv6h->nexthdr;
+	int exthdr_cnt = 0;
 
 	while (ipv6_ext_hdr(nexthdr) && nexthdr != NEXTHDR_NONE) {
 		struct ipv6_opt_hdr *hdr;
 		u16 optlen;
 
+		if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT))
+			break;
+
 		if (!pskb_may_pull(skb, off + sizeof(*hdr)))
 			break;
 
-- 
2.53.0

