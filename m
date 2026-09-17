Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598393DCD9C;
	Thu, 17 Sep 2026 18:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671526; cv=none; b=nKH7q8Xgli7RjeGGjECVp/v7FO/GCRGHQ8hMVdwcZjtPY0JB7PN3hrx+nOu6hquH3fCIBRyjWqZL34VHVuslO6PfD958QNXVfdYkhBFKZ//XW7/xomsaWB4nSIdWyhyQ2jLATb9aeVuT/fawV3Thv2EFQ+3Vau82Owv663242PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671526; c=relaxed/simple;
	bh=T1C6tKpOVQBhxnSupapg80VdahK0zgqyCCRGLHCkGho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3NNFX+qPE5ON8/0nRXvbE8Nn2Kjso4b3bpofRRmBDxr7VGM1j7hSlmTLuWx0w+NeSXMUvjbt6VrIXuujJHDhv2q6nuopCNlHYRZR/JX/ps1oVX+07HnFrAhaS3B0Erns/s1idw4U+xCyUmN1/FY/0XV3ISuINZQiB8L6CaTzDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wg2ND0qe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wg2ND0qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609F01F000FF;
	Thu, 17 Sep 2026 18:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671524;
	bh=sa8sFX1kcI3fI1htA0SbMUsWdAcS66GB+/6h6ThHbro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wg2ND0qeq9EYH5mY7deKPU01c9clotwvQyCdeiFtwenpAyZEc/zpyfInN+x8Qclvw
	 n8MXziCoY2PYWmVtdV4K/orQAoqASzUbwfAtDwJ6JrYck5DXi1CUnobmajrZtvFq89
	 3RL/yUBxV3kn1X8jPVQPLzTxHHBZL+4DGiw39W2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0967/1102] ipv6: use dst6_mtu() instead of dst_mtu()
Date: Thu, 17 Sep 2026 16:15:10 +0100
Message-ID: <20260917151604.958919776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b40f0130a23b6bab8b359e158a40af81f11f14be ]

When we expect an IPv6 dst, use dst6_mtu() instead of dst_mtu()
to save some code space.

Due to current dst6_mtu() implementation, only convert
users in IPv6 stack.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260130210303.3888261-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

[ Adapted the net/ipv6/route.c hunk in ip6_default_advmss(): this
  tree already refactors that function to pull dst_dev(dst) into a
  local `dev` variable ahead of the mtu line, a shape upstream's
  hunk context didn't anticipate. Kept that `dev` line as-is and
  applied the dst_mtu() -> dst6_mtu() conversion to the mtu line,
  same as upstream. ]

Stable-dep-of: 870a9e42ecc6 ("tcp: clamp route advmss to TCP_MIN_MSS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c       |    2 +-
 net/ipv6/ip6_output.c    |    6 +++---
 net/ipv6/ip6_tunnel.c    |    4 ++--
 net/ipv6/ipv6_sockglue.c |    4 ++--
 net/ipv6/route.c         |   10 ++++++----
 net/ipv6/tcp_ipv6.c      |    9 +++++----
 6 files changed, 19 insertions(+), 16 deletions(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1090,7 +1090,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit
 	/* TooBig packet may have updated dst->dev's mtu */
 	if (!t->parms.collect_md && dst) {
 		mtu = READ_ONCE(dst_dev(dst)->mtu);
-		if (dst_mtu(dst) > mtu)
+		if (dst6_mtu(dst) > mtu)
 			dst->ops->update_pmtu(dst, NULL, skb, mtu, false);
 	}
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -353,7 +353,7 @@ int ip6_xmit(const struct sock *sk, stru
 	skb->priority = priority;
 	skb->mark = mark;
 
-	mtu = dst_mtu(dst);
+	mtu = dst6_mtu(dst);
 	if (likely((skb->len <= mtu) || skb->ignore_df || skb_is_gso(skb))) {
 		IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTREQUESTS);
 
@@ -1400,10 +1400,10 @@ static int ip6_setup_cork(struct sock *s
 	v6_cork->dontfrag = ipc6->dontfrag;
 	if (rt->dst.flags & DST_XFRM_TUNNEL)
 		mtu = READ_ONCE(np->pmtudisc) >= IPV6_PMTUDISC_PROBE ?
-		      READ_ONCE(rt->dst.dev->mtu) : dst_mtu(&rt->dst);
+		      READ_ONCE(rt->dst.dev->mtu) : dst6_mtu(&rt->dst);
 	else
 		mtu = READ_ONCE(np->pmtudisc) >= IPV6_PMTUDISC_PROBE ?
-			READ_ONCE(rt->dst.dev->mtu) : dst_mtu(xfrm_dst_path(&rt->dst));
+			READ_ONCE(rt->dst.dev->mtu) : dst6_mtu(xfrm_dst_path(&rt->dst));
 
 	frag_size = READ_ONCE(np->frag_size);
 	if (frag_size && frag_size < mtu)
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -643,7 +643,7 @@ ip4ip6_err(struct sk_buff *skb, struct i
 
 	/* change mtu on this route */
 	if (rel_type == ICMP_DEST_UNREACH && rel_code == ICMP_FRAG_NEEDED) {
-		if (rel_info > dst_mtu(skb_dst(skb2)))
+		if (rel_info > dst6_mtu(skb_dst(skb2)))
 			goto out;
 
 		skb_dst_update_pmtu_no_confirm(skb2, rel_info);
@@ -1195,7 +1195,7 @@ route_lookup:
 				     t->parms.name);
 		goto tx_err_dst_release;
 	}
-	mtu = dst_mtu(dst) - eth_hlen - psh_hlen - t->tun_hlen;
+	mtu = dst6_mtu(dst) - eth_hlen - psh_hlen - t->tun_hlen;
 	if (encap_limit >= 0) {
 		max_headroom += 8;
 		mtu -= 8;
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -1195,7 +1195,7 @@ int do_ipv6_getsockopt(struct sock *sk,
 		rcu_read_lock();
 		dst = __sk_dst_get(sk);
 		if (dst)
-			val = dst_mtu(dst);
+			val = dst6_mtu(dst);
 		rcu_read_unlock();
 		if (!val)
 			return -ENOTCONN;
@@ -1294,7 +1294,7 @@ int do_ipv6_getsockopt(struct sock *sk,
 		rcu_read_lock();
 		dst = __sk_dst_get(sk);
 		if (dst)
-			mtuinfo.ip6m_mtu = dst_mtu(dst);
+			mtuinfo.ip6m_mtu = dst6_mtu(dst);
 		rcu_read_unlock();
 		if (!mtuinfo.ip6m_mtu)
 			return -ENOTCONN;
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2051,6 +2051,8 @@ unlock:
 static bool rt6_mtu_change_route_allowed(struct inet6_dev *idev,
 					 struct rt6_info *rt, int mtu)
 {
+	u32 dmtu = dst6_mtu(&rt->dst);
+
 	/* If the new MTU is lower than the route PMTU, this new MTU will be the
 	 * lowest MTU in the path: always allow updating the route PMTU to
 	 * reflect PMTU decreases.
@@ -2061,10 +2063,10 @@ static bool rt6_mtu_change_route_allowed
 	 * handle this.
 	 */
 
-	if (dst_mtu(&rt->dst) >= mtu)
+	if (dmtu >= mtu)
 		return true;
 
-	if (dst_mtu(&rt->dst) == idev->cnf.mtu6)
+	if (dmtu == idev->cnf.mtu6)
 		return true;
 
 	return false;
@@ -2930,7 +2932,7 @@ static void __ip6_rt_update_pmtu(struct
 
 	if (mtu < IPV6_MIN_MTU)
 		return;
-	if (mtu >= dst_mtu(dst))
+	if (mtu >= dst6_mtu(dst))
 		return;
 
 	if (!rt6_cache_allowed_for_pmtu(rt6)) {
@@ -3248,7 +3250,7 @@ EXPORT_SYMBOL_GPL(ip6_sk_redirect);
 static unsigned int ip6_default_advmss(const struct dst_entry *dst)
 {
 	struct net_device *dev = dst_dev(dst);
-	unsigned int mtu = dst_mtu(dst);
+	unsigned int mtu = dst6_mtu(dst);
 	struct net *net;
 
 	mtu -= sizeof(struct ipv6hdr) + sizeof(struct tcphdr);
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -347,7 +347,7 @@ failure:
 static void tcp_v6_mtu_reduced(struct sock *sk)
 {
 	struct dst_entry *dst;
-	u32 mtu;
+	u32 mtu, dmtu;
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
 		return;
@@ -364,8 +364,9 @@ static void tcp_v6_mtu_reduced(struct so
 	if (!dst)
 		return;
 
-	if (inet_csk(sk)->icsk_pmtu_cookie > dst_mtu(dst)) {
-		tcp_sync_mss(sk, dst_mtu(dst));
+	dmtu = dst6_mtu(dst);
+	if (inet_csk(sk)->icsk_pmtu_cookie > dmtu) {
+		tcp_sync_mss(sk, dmtu);
 		tcp_simple_retransmit(sk);
 	}
 }
@@ -1487,7 +1488,7 @@ static struct sock *tcp_v6_syn_recv_sock
 
 	tcp_ca_openreq_child(newsk, dst);
 
-	tcp_sync_mss(newsk, dst_mtu(dst));
+	tcp_sync_mss(newsk, dst6_mtu(dst));
 	newtp->advmss = tcp_mss_clamp(tcp_sk(sk), dst_metric_advmss(dst));
 
 	tcp_initialize_rcv_mss(newsk);


