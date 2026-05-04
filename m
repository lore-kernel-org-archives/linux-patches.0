Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1583DE450;
	Mon,  4 May 2026 14:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903626; cv=none; b=ngF1nnNxFIVgNQRXZJC2PAy/eAg9YLTstxni5o8MRdxNA//JeOkKSM6wLtz5Y/z7H5p/5x/3NfZ0MnBkhk8QLNGtObmlEf8a6ZIJXlBBnozI+ChmSQrhiyxAO1fNh3iLBeqAQgKKpfEyo400O8Xb+ff+uNVrE4KTE6JN7YWEKn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903626; c=relaxed/simple;
	bh=Mx7nBonAZIoaGkesUgj3ney8A7fNJZwvlFzSZt9mu2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elvPA0ti7Jv6FhWGDYnlxG6MDB0zJLFW3iNpMFDr4JpLPT8sDNohgBqnxQYMPBojp8GWNaEUHsFQWp5JIyhPZZWaH3dWwXvOhzkubaEV0X3JcDxcF2bTaOvPpFoE86nEG1anOyT/ccR57v6V7l79Q4rne/xVXibRHUN+1XdMWUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EEpkg01U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EEpkg01U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41045C2BCB8;
	Mon,  4 May 2026 14:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903626;
	bh=Mx7nBonAZIoaGkesUgj3ney8A7fNJZwvlFzSZt9mu2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEpkg01UsrZwInj/WdmYxT/eUzdIeZkUmor32HIdGPhr3Xoi3eUOVFTojZFnUCAcy
	 mF1fiCjws6tZgeDcxclLPs3SeBi93FzYSR6t7DFnPcbn++6yswLDZvgtVi8bvlqC92
	 lGMbWOpTSu28A7ZQLy/uSsSfI6UsX9Zf+ANcMRAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Simon Horman <horms@kernel.org>,
	Justin Iurman <justin.iurman@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.0 306/307] net: ipv6: fix NOREF dst use in seg6 and rpl lwtunnels
Date: Mon,  4 May 2026 15:53:11 +0200
Message-ID: <20260504135154.285950715@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Mayer <andrea.mayer@uniroma2.it>

commit f9c52a6ba9780bd27e0bf4c044fd91c13c778b6e upstream.

seg6_input_core() and rpl_input() call ip6_route_input() which sets a
NOREF dst on the skb, then pass it to dst_cache_set_ip6() invoking
dst_hold() unconditionally.
On PREEMPT_RT, ksoftirqd is preemptible and a higher-priority task can
release the underlying pcpu_rt between the lookup and the caching
through a concurrent FIB lookup on a shared nexthop.
Simplified race sequence:

  ksoftirqd/X                       higher-prio task (same CPU X)
  -----------                       --------------------------------
  seg6_input_core(,skb)/rpl_input(skb)
    dst_cache_get()
      -> miss
    ip6_route_input(skb)
      -> ip6_pol_route(,skb,flags)
         [RT6_LOOKUP_F_DST_NOREF in flags]
        -> FIB lookup resolves fib6_nh
           [nhid=N route]
        -> rt6_make_pcpu_route()
           [creates pcpu_rt, refcount=1]
             pcpu_rt->sernum = fib6_sernum
             [fib6_sernum=W]
           -> cmpxchg(fib6_nh.rt6i_pcpu,
                      NULL, pcpu_rt)
              [slot was empty, store succeeds]
      -> skb_dst_set_noref(skb, dst)
         [dst is pcpu_rt, refcount still 1]

                                    rt_genid_bump_ipv6()
                                      -> bumps fib6_sernum
                                         [fib6_sernum from W to Z]
                                    ip6_route_output()
                                      -> ip6_pol_route()
                                        -> FIB lookup resolves fib6_nh
                                           [nhid=N]
                                        -> rt6_get_pcpu_route()
                                             pcpu_rt->sernum != fib6_sernum
                                             [W <> Z, stale]
                                          -> prev = xchg(rt6i_pcpu, NULL)
                                          -> dst_release(prev)
                                             [prev is pcpu_rt,
                                              refcount 1->0, dead]

    dst = skb_dst(skb)
    [dst is the dead pcpu_rt]
    dst_cache_set_ip6(dst)
      -> dst_hold() on dead dst
      -> WARN / use-after-free

For the race to occur, ksoftirqd must be preemptible (PREEMPT_RT without
PREEMPT_RT_NEEDS_BH_LOCK) and a concurrent task must be able to release
the pcpu_rt. Shared nexthop objects provide such a path, as two routes
pointing to the same nhid share the same fib6_nh and its rt6i_pcpu
entry.

Fix seg6_input_core() and rpl_input() by calling skb_dst_force() after
ip6_route_input() to force the NOREF dst into a refcounted one before
caching.
The output path is not affected as ip6_route_output() already returns a
refcounted dst.

Fixes: af4a2209b134 ("ipv6: sr: use dst_cache in seg6_input")
Fixes: a7a29f9c361f ("net: ipv6: add rpl sr tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Link: https://patch.msgid.link/20260421094735.20997-1-andrea.mayer@uniroma2.it
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/rpl_iptunnel.c  |    9 +++++++++
 net/ipv6/seg6_iptunnel.c |    9 +++++++++
 2 files changed, 18 insertions(+)

--- a/net/ipv6/rpl_iptunnel.c
+++ b/net/ipv6/rpl_iptunnel.c
@@ -287,7 +287,16 @@ static int rpl_input(struct sk_buff *skb
 
 	if (!dst) {
 		ip6_route_input(skb);
+
+		/* ip6_route_input() sets a NOREF dst; force a refcount on it
+		 * before caching or further use.
+		 */
+		skb_dst_force(skb);
 		dst = skb_dst(skb);
+		if (unlikely(!dst)) {
+			err = -ENETUNREACH;
+			goto drop;
+		}
 
 		/* cache only if we don't create a dst reference loop */
 		if (!dst->error && lwtst != dst->lwtstate) {
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -500,7 +500,16 @@ static int seg6_input_core(struct net *n
 
 	if (!dst) {
 		ip6_route_input(skb);
+
+		/* ip6_route_input() sets a NOREF dst; force a refcount on it
+		 * before caching or further use.
+		 */
+		skb_dst_force(skb);
 		dst = skb_dst(skb);
+		if (unlikely(!dst)) {
+			err = -ENETUNREACH;
+			goto drop;
+		}
 
 		/* cache only if we don't create a dst reference loop */
 		if (!dst->error && lwtst != dst->lwtstate) {


