Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210891;
	b=xQQjZ/ziqlgzV2xEqCF8Lbes5L8lP6lDoYi8DeoYvIPpDDzzWSfehfmn1nNORqeUKink
	 xJdEsLjlOZT4clRS/U5+AMZ0KRC2skxp5vKN+z0HqLwVfU5N3nQAoQHjJBsgTkdd9FiyU
	 KrL07YSCLJN/U10Tw7e6KEayMXunuxj1qVgdvdJG0WXsELRTkW0bEBmjPKdXltD8Kj21o
	 hIMBtma3mMrF/eZWWjkFYb7Duf5dKPmO4ivr3FuvpFgx7GpcM5FyhpXKh5kG9VrxAQ4B5
	 Fa1iR436Nsn0kVb0acbRq8pIxNP2wzib1WCvWoiW3N85wHLpYiart3gT1Et5JfwjCJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G6CZvj/Qqb+HxPJFGCrx0rZ35cJ31MmJvpYuY3+auZ0=;
	b=mMa1RmqnHOpvqNNOHq0p+J3nMnQKnt2NVFn3sKZXJj8lp6qVw2c+MSPhttwug2UqPBor
	 lvQ+oltF74DAsrO3Ce8zzF2PVGqfD4BD6myLucbifU2nIlZUkUUboheg6MSiUUKMz42fY
	 U9r0IaJUGrNZ8cbcQq4XR5Q7Qn4COnDeWjnLOFl8xKPutVzZExM4yNGkBKK6bekXe/LaW
	 QiqGW+BLK+hr18XsdI8p3uzqRQQocQ3twXWSCcbGLFTXcRQFSHqmw1WR9PNJgm9f0fuEq
	 YeAfaCLCIB3r99gcmsVY70+girFqNNm6JS0MtENh5sEQnPANxx+QgfNrjgpPPCWUtzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Afv/6unc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1D3606A31A;
	Wed, 28 Oct 2026 18:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Afv/6unc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520C31F01825;
	Wed, 28 Oct 2026 18:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210890;
	bh=G6CZvj/Qqb+HxPJFGCrx0rZ35cJ31MmJvpYuY3+auZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Afv/6uncWxiedK7fAhAyAmI33A0fdtbne+vbVizxNvmquYSBFvoAhA02VrmsRlh8f
	 SJrPKjAqPQ809SQbtyiQX9biSJwS24MNUzqwKu3SK7atNnMiQh6qtwRoap56wJ1bvr
	 jne6jgYwgvQ7PwobPm7izBZzUDbXmdiwf7iE/63k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Willem de Bruijn <willemb@google.com>,
	Florian Westphal <fw@strlen.de>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 186/571] net: add and use skb_get_hash_net
Date: Wed, 28 Oct 2026 17:55:33 +0100
Message-ID: <20261028170012.424462288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b975d3ee5962237c1e2f5d5aeeaaf0dc2173486c ]

Years ago flow dissector gained ability to delegate flow dissection
to a bpf program, scoped per netns.

Unfortunately, skb_get_hash() only gets an sk_buff argument instead
of both net+skb.  This means the flow dissector needs to obtain the
netns pointer from somewhere else.

The netns is derived from skb->dev, and if that is not available, from
skb->sk.  If neither is set, we hit a (benign) WARN_ON_ONCE().

Trying both dev and sk covers most cases, but not all, as recently
reported by Christoph Paasch.

In case of nf-generated tcp reset, both sk and dev are NULL:

WARNING: .. net/core/flow_dissector.c:1104
 skb_flow_dissect_flow_keys include/linux/skbuff.h:1536 [inline]
 skb_get_hash include/linux/skbuff.h:1578 [inline]
 nft_trace_init+0x7d/0x120 net/netfilter/nf_tables_trace.c:320
 nft_do_chain+0xb26/0xb90 net/netfilter/nf_tables_core.c:268
 nft_do_chain_ipv4+0x7a/0xa0 net/netfilter/nft_chain_filter.c:23
 nf_hook_slow+0x57/0x160 net/netfilter/core.c:626
 __ip_local_out+0x21d/0x260 net/ipv4/ip_output.c:118
 ip_local_out+0x26/0x1e0 net/ipv4/ip_output.c:127
 nf_send_reset+0x58c/0x700 net/ipv4/netfilter/nf_reject_ipv4.c:308
 nft_reject_ipv4_eval+0x53/0x90 net/ipv4/netfilter/nft_reject_ipv4.c:30
 [..]

syzkaller did something like this:
table inet filter {
  chain input {
    type filter hook input priority filter; policy accept;
    meta nftrace set 1
    tcp dport 42 reject with tcp reset
   }
   chain output {
    type filter hook output priority filter; policy accept;
    # empty chain is enough
   }
}

... then sends a tcp packet to port 42.

Initial attempt to simply set skb->dev from nf_reject_ipv4 doesn't cover
all cases: skbs generated via ipv4 igmp_send_report trigger similar splat.

Moreover, Pablo Neira found that nft_hash.c uses __skb_get_hash_symmetric()
which would trigger same warn splat for such skbs.

Lets allow callers to pass the current netns explicitly.
The nf_trace infrastructure is adjusted to use the new helper.

__skb_get_hash_symmetric is handled in the next patch.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/494
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240608221057.16070-2-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8ec454dcd00c ("ipv6: sr: use skb_get_hash_net() in seg6_make_flowlabel()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h          | 12 ++++++++++--
 net/core/flow_dissector.c       | 15 +++++++++++----
 net/netfilter/nf_tables_trace.c |  2 +-
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 24ceeab1b509f..e2483ac59382c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1346,7 +1346,7 @@ __skb_set_sw_hash(struct sk_buff *skb, __u32 hash, bool is_l4)
 	__skb_set_hash(skb, hash, true, is_l4);
 }
 
-void __skb_get_hash(struct sk_buff *skb);
+void __skb_get_hash_net(const struct net *net, struct sk_buff *skb);
 u32 __skb_get_hash_symmetric(const struct sk_buff *skb);
 u32 skb_get_poff(const struct sk_buff *skb);
 u32 __skb_get_poff(const struct sk_buff *skb, const void *data,
@@ -1426,10 +1426,18 @@ void skb_flow_dissect_hash(const struct sk_buff *skb,
 			   struct flow_dissector *flow_dissector,
 			   void *target_container);
 
+static inline __u32 skb_get_hash_net(const struct net *net, struct sk_buff *skb)
+{
+	if (!skb->l4_hash && !skb->sw_hash)
+		__skb_get_hash_net(net, skb);
+
+	return skb->hash;
+}
+
 static inline __u32 skb_get_hash(struct sk_buff *skb)
 {
 	if (!skb->l4_hash && !skb->sw_hash)
-		__skb_get_hash(skb);
+		__skb_get_hash_net(NULL, skb);
 
 	return skb->hash;
 }
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index db5677fbf81d3..b02348f5a4f82 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1685,7 +1685,8 @@ u32 __skb_get_hash_symmetric(const struct sk_buff *skb)
 EXPORT_SYMBOL_GPL(__skb_get_hash_symmetric);
 
 /**
- * __skb_get_hash: calculate a flow hash
+ * __skb_get_hash_net: calculate a flow hash
+ * @net: associated network namespace, derived from @skb if NULL
  * @skb: sk_buff to calculate flow hash from
  *
  * This function calculates a flow hash based on src/dst addresses
@@ -1693,18 +1694,24 @@ EXPORT_SYMBOL_GPL(__skb_get_hash_symmetric);
  * on success, zero indicates no valid hash.  Also, sets l4_hash in skb
  * if hash is a canonical 4-tuple hash over transport ports.
  */
-void __skb_get_hash(struct sk_buff *skb)
+void __skb_get_hash_net(const struct net *net, struct sk_buff *skb)
 {
 	struct flow_keys keys;
 	u32 hash;
 
+	memset(&keys, 0, sizeof(keys));
+
+	__skb_flow_dissect(net, skb, &flow_keys_dissector,
+			   &keys, NULL, 0, 0, 0,
+			   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
+
 	__flow_hash_secret_init();
 
-	hash = ___skb_get_hash(skb, &keys, &hashrnd);
+	hash = __flow_hash_from_keys(&keys, &hashrnd);
 
 	__skb_set_sw_hash(skb, hash, flow_keys_have_l4(&keys));
 }
-EXPORT_SYMBOL(__skb_get_hash);
+EXPORT_SYMBOL(__skb_get_hash_net);
 
 __u32 skb_get_hash_perturb(const struct sk_buff *skb,
 			   const siphash_key_t *perturb)
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index ed4b067bfb6af..1d28ce62c3372 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -289,7 +289,7 @@ void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
 	net_get_random_once(&trace_key, sizeof(trace_key));
 
 	info->skbid = (u32)siphash_3u32(hash32_ptr(skb),
-					skb_get_hash(skb),
+					skb_get_hash_net(nft_net(pkt), skb),
 					skb->skb_iif,
 					&trace_key);
 }
-- 
2.53.0



