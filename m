Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C443713AA2F;
	Tue, 27 Feb 2024 13:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042187; cv=none; b=oKL9mTku8bgUmkX9gsdATLCW5lO+4k1GKOayWwXjMzuZ7UwE2SQKejTLju5mFhzuBmIx1GbShTD3Nfi10IVBwlFfDzjkLlX/S9X/R9tRUarLt2Cu6sG7D7DjRpi5qKG4Z9g+57tL1s+jHCuPwWKi46YfmWoxZCRWYcW1X+ZLuGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042187; c=relaxed/simple;
	bh=l6nIM6mj1DfGg9g8h4HxaOc/OIljymxnEbiTyVhodiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jY5q6OhQcEz9VTs9jFbQQ8n1QfUwMfJtRUTfVpyN7lkEP8uiWo94/V6HZZ0rLEBrgf/WSahr2yyhUbHWkYaQ7DEbNizk9TJj1hkR7Fadf97uIUUFQNEqh4j8/Sd5sz2niWxrfg1vUMDIpCXcAg8+X7HX0aNDwY6a3osvjNgpCgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5zrsPeS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5zrsPeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF9FC433F1;
	Tue, 27 Feb 2024 13:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042187;
	bh=l6nIM6mj1DfGg9g8h4HxaOc/OIljymxnEbiTyVhodiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5zrsPeSai0O341eJZZsGKP3GbATYd474tqTyC7aDscUeOPyM4cHm++AugEWP7PPz
	 ngD5oM+H65sYZawYZgtxnwVltO2OVZaar1/k8H86QXS5Bgk3fNRD7rb6Oe4A8OXfyE
	 h0N0yziuqbzFR49T+cUFbQyGTKip62UBkDhDCsaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martynas Pumputis <m@lambda.lt>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.6 210/299] bpf: Derive source IP addr via bpf_*_fib_lookup()
Date: Tue, 27 Feb 2024 14:25:21 +0100
Message-ID: <20240227131632.550160131@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martynas Pumputis <m@lambda.lt>

commit dab4e1f06cabb6834de14264394ccab197007302 upstream.

Extend the bpf_fib_lookup() helper by making it to return the source
IPv4/IPv6 address if the BPF_FIB_LOOKUP_SRC flag is set.

For example, the following snippet can be used to derive the desired
source IP address:

    struct bpf_fib_lookup p = { .ipv4_dst = ip4->daddr };

    ret = bpf_skb_fib_lookup(skb, p, sizeof(p),
            BPF_FIB_LOOKUP_SRC | BPF_FIB_LOOKUP_SKIP_NEIGH);
    if (ret != BPF_FIB_LKUP_RET_SUCCESS)
        return TC_ACT_SHOT;

    /* the p.ipv4_src now contains the source address */

The inability to derive the proper source address may cause malfunctions
in BPF-based dataplanes for hosts containing netdevs with more than one
routable IP address or for multi-homed hosts.

For example, Cilium implements packet masquerading in BPF. If an
egressing netdev to which the Cilium's BPF prog is attached has
multiple IP addresses, then only one [hardcoded] IP address can be used for
masquerading. This breaks connectivity if any other IP address should have
been selected instead, for example, when a public and private addresses
are attached to the same egress interface.

The change was tested with Cilium [1].

Nikolay Aleksandrov helped to figure out the IPv6 addr selection.

[1]: https://github.com/cilium/cilium/pull/28283

Signed-off-by: Martynas Pumputis <m@lambda.lt>
Link: https://lore.kernel.org/r/20231007081415.33502-2-m@lambda.lt
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ipv6_stubs.h       |    5 +++++
 include/uapi/linux/bpf.h       |   10 ++++++++++
 net/core/filter.c              |   18 +++++++++++++++++-
 net/ipv6/af_inet6.c            |    1 +
 tools/include/uapi/linux/bpf.h |   10 ++++++++++
 5 files changed, 43 insertions(+), 1 deletion(-)

--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -85,6 +85,11 @@ struct ipv6_bpf_stub {
 			       sockptr_t optval, unsigned int optlen);
 	int (*ipv6_getsockopt)(struct sock *sk, int level, int optname,
 			       sockptr_t optval, sockptr_t optlen);
+	int (*ipv6_dev_get_saddr)(struct net *net,
+				  const struct net_device *dst_dev,
+				  const struct in6_addr *daddr,
+				  unsigned int prefs,
+				  struct in6_addr *saddr);
 };
 extern const struct ipv6_bpf_stub *ipv6_bpf_stub __read_mostly;
 
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3257,6 +3257,11 @@ union bpf_attr {
  *			and *params*->smac will not be set as output. A common
  *			use case is to call **bpf_redirect_neigh**\ () after
  *			doing **bpf_fib_lookup**\ ().
+ *		**BPF_FIB_LOOKUP_SRC**
+ *			Derive and set source IP addr in *params*->ipv{4,6}_src
+ *			for the nexthop. If the src addr cannot be derived,
+ *			**BPF_FIB_LKUP_RET_NO_SRC_ADDR** is returned. In this
+ *			case, *params*->dmac and *params*->smac are not set either.
  *
  *		*ctx* is either **struct xdp_md** for XDP programs or
  *		**struct sk_buff** tc cls_act programs.
@@ -6956,6 +6961,7 @@ enum {
 	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
 	BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
 	BPF_FIB_LOOKUP_TBID    = (1U << 3),
+	BPF_FIB_LOOKUP_SRC     = (1U << 4),
 };
 
 enum {
@@ -6968,6 +6974,7 @@ enum {
 	BPF_FIB_LKUP_RET_UNSUPP_LWT,   /* fwd requires encapsulation */
 	BPF_FIB_LKUP_RET_NO_NEIGH,     /* no neighbor entry for nh */
 	BPF_FIB_LKUP_RET_FRAG_NEEDED,  /* fragmentation required to fwd */
+	BPF_FIB_LKUP_RET_NO_SRC_ADDR,  /* failed to derive IP src addr */
 };
 
 struct bpf_fib_lookup {
@@ -7002,6 +7009,9 @@ struct bpf_fib_lookup {
 		__u32	rt_metric;
 	};
 
+	/* input: source address to consider for lookup
+	 * output: source address result from lookup
+	 */
 	union {
 		__be32		ipv4_src;
 		__u32		ipv6_src[4];  /* in6_addr; network order */
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5903,6 +5903,9 @@ static int bpf_ipv4_fib_lookup(struct ne
 	params->rt_metric = res.fi->fib_priority;
 	params->ifindex = dev->ifindex;
 
+	if (flags & BPF_FIB_LOOKUP_SRC)
+		params->ipv4_src = fib_result_prefsrc(net, &res);
+
 	/* xdp and cls_bpf programs are run in RCU-bh so
 	 * rcu_read_lock_bh is not needed here
 	 */
@@ -6045,6 +6048,18 @@ static int bpf_ipv6_fib_lookup(struct ne
 	params->rt_metric = res.f6i->fib6_metric;
 	params->ifindex = dev->ifindex;
 
+	if (flags & BPF_FIB_LOOKUP_SRC) {
+		if (res.f6i->fib6_prefsrc.plen) {
+			*src = res.f6i->fib6_prefsrc.addr;
+		} else {
+			err = ipv6_bpf_stub->ipv6_dev_get_saddr(net, dev,
+								&fl6.daddr, 0,
+								src);
+			if (err)
+				return BPF_FIB_LKUP_RET_NO_SRC_ADDR;
+		}
+	}
+
 	if (flags & BPF_FIB_LOOKUP_SKIP_NEIGH)
 		goto set_fwd_params;
 
@@ -6063,7 +6078,8 @@ set_fwd_params:
 #endif
 
 #define BPF_FIB_LOOKUP_MASK (BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT | \
-			     BPF_FIB_LOOKUP_SKIP_NEIGH | BPF_FIB_LOOKUP_TBID)
+			     BPF_FIB_LOOKUP_SKIP_NEIGH | BPF_FIB_LOOKUP_TBID | \
+			     BPF_FIB_LOOKUP_SRC)
 
 BPF_CALL_4(bpf_xdp_fib_lookup, struct xdp_buff *, ctx,
 	   struct bpf_fib_lookup *, params, int, plen, u32, flags)
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1064,6 +1064,7 @@ static const struct ipv6_bpf_stub ipv6_b
 	.udp6_lib_lookup = __udp6_lib_lookup,
 	.ipv6_setsockopt = do_ipv6_setsockopt,
 	.ipv6_getsockopt = do_ipv6_getsockopt,
+	.ipv6_dev_get_saddr = ipv6_dev_get_saddr,
 };
 
 static int __init inet6_init(void)
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3257,6 +3257,11 @@ union bpf_attr {
  *			and *params*->smac will not be set as output. A common
  *			use case is to call **bpf_redirect_neigh**\ () after
  *			doing **bpf_fib_lookup**\ ().
+ *		**BPF_FIB_LOOKUP_SRC**
+ *			Derive and set source IP addr in *params*->ipv{4,6}_src
+ *			for the nexthop. If the src addr cannot be derived,
+ *			**BPF_FIB_LKUP_RET_NO_SRC_ADDR** is returned. In this
+ *			case, *params*->dmac and *params*->smac are not set either.
  *
  *		*ctx* is either **struct xdp_md** for XDP programs or
  *		**struct sk_buff** tc cls_act programs.
@@ -6956,6 +6961,7 @@ enum {
 	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
 	BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
 	BPF_FIB_LOOKUP_TBID    = (1U << 3),
+	BPF_FIB_LOOKUP_SRC     = (1U << 4),
 };
 
 enum {
@@ -6968,6 +6974,7 @@ enum {
 	BPF_FIB_LKUP_RET_UNSUPP_LWT,   /* fwd requires encapsulation */
 	BPF_FIB_LKUP_RET_NO_NEIGH,     /* no neighbor entry for nh */
 	BPF_FIB_LKUP_RET_FRAG_NEEDED,  /* fragmentation required to fwd */
+	BPF_FIB_LKUP_RET_NO_SRC_ADDR,  /* failed to derive IP src addr */
 };
 
 struct bpf_fib_lookup {
@@ -7002,6 +7009,9 @@ struct bpf_fib_lookup {
 		__u32	rt_metric;
 	};
 
+	/* input: source address to consider for lookup
+	 * output: source address result from lookup
+	 */
 	union {
 		__be32		ipv4_src;
 		__u32		ipv6_src[4];  /* in6_addr; network order */


