Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75E014388C;
	Wed, 19 Jun 2024 12:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801942; cv=none; b=TcLctpv5W3e++7NuJnyjWBWzIIMLpRQ83Qn8sXjLk3Fyl5pKNaJFV6atsFhzi0k+UuxN2lOUbv/3XMrgG3y/76r5adtPVHCKGwhty1vE3CFXQsqrF8K1UhFI2e4WicrQ/T6BHCRPLUya4xkWjPCb/pQxYaiTEoPmtVoOKdYAQhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801942; c=relaxed/simple;
	bh=GYYAmfIwdQ5TiglQsxUpqj5I8hWjgiRw/0jHeM7hp9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOKkEq0NUFGvN8BWcTi/SA/iDEIisORIuTkE9XUjWH2abxz9baT193VU9y6nwQfwL8213a6ppXU/PRDoiJ/E+Gsel/SZZxhw+sBZBuQacPhn25+C06oaIIgot/xl1rBIYX7gE9xW4miJ5HE+ug7jZKHrHVwhCFx9k1e+qSicCmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khSvqrlx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khSvqrlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE07C2BBFC;
	Wed, 19 Jun 2024 12:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801942;
	bh=GYYAmfIwdQ5TiglQsxUpqj5I8hWjgiRw/0jHeM7hp9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khSvqrlx7Awe5d1nczauERSZE/jANqXNKbga+d+rpnJa0sZCNZnpDE9t/wri0PjWJ
	 YdnpdaPC9Y4ahy/9UZuKphNs+k6f5JW+jb/FHNhS55znx0yFIbez85KrPOhd3Tag5y
	 klhmTZEu5YJ7DrSW8z9K5I9xfb14kN7s8xqRpB8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Lebrun <dlebrun@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/267] ipv6: sr: block BH in seg6_output_core() and seg6_input_core()
Date: Wed, 19 Jun 2024 14:53:00 +0200
Message-ID: <20240619125607.483149848@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c0b98ac1cc104f48763cdb27b1e9ac25fd81fc90 ]

As explained in commit 1378817486d6 ("tipc: block BH
before using dst_cache"), net/core/dst_cache.c
helpers need to be called with BH disabled.

Disabling preemption in seg6_output_core() is not good enough,
because seg6_output_core() is called from process context,
lwtunnel_output() only uses rcu_read_lock().

We might be interrupted by a softirq, re-enter seg6_output_core()
and corrupt dst_cache data structures.

Fix the race by using local_bh_disable() instead of
preempt_disable().

Apply a similar change in seg6_input_core().

Fixes: fa79581ea66c ("ipv6: sr: fix several BUGs when preemption is enabled")
Fixes: 6c8702c60b88 ("ipv6: sr: add support for SRH encapsulation and injection with lwtunnels")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Lebrun <dlebrun@google.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240531132636.2637995-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_iptunnel.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index a75df2ec8db0d..098632adc9b5a 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -464,23 +464,21 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 
 	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
 
-	preempt_disable();
+	local_bh_disable();
 	dst = dst_cache_get(&slwt->cache);
-	preempt_enable();
 
 	if (!dst) {
 		ip6_route_input(skb);
 		dst = skb_dst(skb);
 		if (!dst->error) {
-			preempt_disable();
 			dst_cache_set_ip6(&slwt->cache, dst,
 					  &ipv6_hdr(skb)->saddr);
-			preempt_enable();
 		}
 	} else {
 		skb_dst_drop(skb);
 		skb_dst_set(skb, dst);
 	}
+	local_bh_enable();
 
 	err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
 	if (unlikely(err))
@@ -536,9 +534,9 @@ static int seg6_output_core(struct net *net, struct sock *sk,
 
 	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
 
-	preempt_disable();
+	local_bh_disable();
 	dst = dst_cache_get(&slwt->cache);
-	preempt_enable();
+	local_bh_enable();
 
 	if (unlikely(!dst)) {
 		struct ipv6hdr *hdr = ipv6_hdr(skb);
@@ -558,9 +556,9 @@ static int seg6_output_core(struct net *net, struct sock *sk,
 			goto drop;
 		}
 
-		preempt_disable();
+		local_bh_disable();
 		dst_cache_set_ip6(&slwt->cache, dst, &fl6.saddr);
-		preempt_enable();
+		local_bh_enable();
 	}
 
 	skb_dst_drop(skb);
-- 
2.43.0



