Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B306C143757;
	Wed, 19 Jun 2024 13:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803527; cv=none; b=u2GnHLvmOlbBd733anJNKSP5OK1FKB41MCpfdcQsoKIeDvFSdJ+LGK8Fejs1m6TEjyI76lZx17cxMFuh3elFA20I0R7IU2SgwznIdduTnHnyTHyY4ypeC8Hu9HUqVn/UmwyJC1Kkcl9rjpPGsqw+gPDKyW61jepLs+M0YuPCakU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803527; c=relaxed/simple;
	bh=x0xtpMJzJ1xS/UWF0lxpouq82K64b35BqxjUHWaVZlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCaUeEPBgUag344WKwGfie0rlfx9fKDEc9EsCPXeqTde6zge0D5hD4EdHD2EtyGohj2dZtjbnwtV1MB2jAEvdFMdloQJdGfG+jjmOnIPUAXxUi6MTuyZNAjiSdfr8lvCxROCFexHNXaMaeuBn54kvfkBSryipvbtDdjTbG6y6t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n28XJWlp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n28XJWlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B8BC2BBFC;
	Wed, 19 Jun 2024 13:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803527;
	bh=x0xtpMJzJ1xS/UWF0lxpouq82K64b35BqxjUHWaVZlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n28XJWlpIF1aHCGAe5iHGBIsIJacD6Byx8IKX5xDtF5VyvqaLVerhD7fPEzRTo3/a
	 MqsxCCioSi41B/0yyCWliLFZJuyKQ87ubIw3rGkn2SF5rXmj9+MQfZHbwXh+HNWnOA
	 zmH1W+p/mn5hCEMbgHCFbud7MGLOFtZYuD+uKAkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Lebrun <dlebrun@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/217] ipv6: sr: block BH in seg6_output_core() and seg6_input_core()
Date: Wed, 19 Jun 2024 14:54:19 +0200
Message-ID: <20240619125557.269490599@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5924407b87b07..ae5299c277bcf 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -464,9 +464,8 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 
 	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
 
-	preempt_disable();
+	local_bh_disable();
 	dst = dst_cache_get(&slwt->cache);
-	preempt_enable();
 
 	skb_dst_drop(skb);
 
@@ -474,14 +473,13 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 		ip6_route_input(skb);
 		dst = skb_dst(skb);
 		if (!dst->error) {
-			preempt_disable();
 			dst_cache_set_ip6(&slwt->cache, dst,
 					  &ipv6_hdr(skb)->saddr);
-			preempt_enable();
 		}
 	} else {
 		skb_dst_set(skb, dst);
 	}
+	local_bh_enable();
 
 	err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
 	if (unlikely(err))
@@ -537,9 +535,9 @@ static int seg6_output_core(struct net *net, struct sock *sk,
 
 	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
 
-	preempt_disable();
+	local_bh_disable();
 	dst = dst_cache_get(&slwt->cache);
-	preempt_enable();
+	local_bh_enable();
 
 	if (unlikely(!dst)) {
 		struct ipv6hdr *hdr = ipv6_hdr(skb);
@@ -559,9 +557,9 @@ static int seg6_output_core(struct net *net, struct sock *sk,
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



