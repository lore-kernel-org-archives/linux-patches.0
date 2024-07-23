Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE0E1586C4;
	Tue, 23 Jul 2024 18:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759540; cv=none; b=rRVukd338X4YhhemS/YfdRqLko1MgYGOrSCMiwzx19YUfg6vtfmj31xt60l0DxGXLmSFFxkOaCjPT6eNx8kOjpYqxEN/qRIZTFG62ayVcarrYJwiAXYeCSAaLlUTdyNyK/PQPHT1fj8cSLOQxELgGdEzPLRHzdmyUYptUVjvGtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759540; c=relaxed/simple;
	bh=+pv4NaMJzO+MQzjMjPX6eBDhxVIEpp9oL2FkH4udfzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KG5RvOh4YeNnaqDl8hli4UxkWPRsipeC7sJWf4I6YjQhq+ZGLZ8nNrMKMyauqhFp9VVOAMKqjO8/RL9DVacthKkHZthpqY0GcxO/oao0lWPHfEyyBGw/tPfR97RE1QVLIYxdTikQdWzjFyL8sKaqbukGiD+6tb+FuOP1Am/aVyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wTA6pvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wTA6pvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95EFC4AF0A;
	Tue, 23 Jul 2024 18:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759539;
	bh=+pv4NaMJzO+MQzjMjPX6eBDhxVIEpp9oL2FkH4udfzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1wTA6pvcIBmyTqfUuCN7CfJENuhk+crhRQZwExq1J2OujMgHUO8ODX2O6UbPGu65A
	 B8kRyj8KRI0yuZ6khF9HOSZnVGkD8qiPBFic0FyTxYgWtpL8WwSmOLx6xDr62BB6I3
	 0nEhm431GICBHmpAQcIuX6axSjCYXc6I0f8u0psY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Alexander Aring <aahringo@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/129] net: ipv6: rpl_iptunnel: block BH in rpl_output() and rpl_input()
Date: Tue, 23 Jul 2024 20:22:55 +0200
Message-ID: <20240723180405.840133128@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

[ Upstream commit db0090c6eb12c31246438b7fe2a8f1b833e7a653 ]

As explained in commit 1378817486d6 ("tipc: block BH
before using dst_cache"), net/core/dst_cache.c
helpers need to be called with BH disabled.

Disabling preemption in rpl_output() is not good enough,
because rpl_output() is called from process context,
lwtunnel_output() only uses rcu_read_lock().

We might be interrupted by a softirq, re-enter rpl_output()
and corrupt dst_cache data structures.

Fix the race by using local_bh_disable() instead of
preempt_disable().

Apply a similar change in rpl_input().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Aring <aahringo@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240531132636.2637995-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/rpl_iptunnel.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/rpl_iptunnel.c b/net/ipv6/rpl_iptunnel.c
index a013b92cbb860..2c83b7586422d 100644
--- a/net/ipv6/rpl_iptunnel.c
+++ b/net/ipv6/rpl_iptunnel.c
@@ -212,9 +212,9 @@ static int rpl_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	if (unlikely(err))
 		goto drop;
 
-	preempt_disable();
+	local_bh_disable();
 	dst = dst_cache_get(&rlwt->cache);
-	preempt_enable();
+	local_bh_enable();
 
 	if (unlikely(!dst)) {
 		struct ipv6hdr *hdr = ipv6_hdr(skb);
@@ -234,9 +234,9 @@ static int rpl_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 			goto drop;
 		}
 
-		preempt_disable();
+		local_bh_disable();
 		dst_cache_set_ip6(&rlwt->cache, dst, &fl6.saddr);
-		preempt_enable();
+		local_bh_enable();
 	}
 
 	skb_dst_drop(skb);
@@ -268,23 +268,21 @@ static int rpl_input(struct sk_buff *skb)
 		return err;
 	}
 
-	preempt_disable();
+	local_bh_disable();
 	dst = dst_cache_get(&rlwt->cache);
-	preempt_enable();
 
 	if (!dst) {
 		ip6_route_input(skb);
 		dst = skb_dst(skb);
 		if (!dst->error) {
-			preempt_disable();
 			dst_cache_set_ip6(&rlwt->cache, dst,
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
-- 
2.43.0



