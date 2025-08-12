Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6405268C73;
	Tue, 12 Aug 2025 17:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021112; cv=none; b=MbEl8fGLhWzsFAdKBOwVDd671Yh3DaDzslyqchy+pOr5G6fqbp08hG9/H9t+B8A9X/7SqlyLJQSB3Oc/uGUrleSoSYvH7XMdJlJfI/2f+zddVLoN+Roa/08lWNKe4Br8uitlG6lT7AqePMmgggZvM37ZuICBmNNTq6kjPPM5D2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021112; c=relaxed/simple;
	bh=TxE9UeQhmfJyFG0uhkZqseaCQaDbdPs6yOyK5wOcIgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gv5BrvYvL0Mz97thNdJxyOyQ5Yq7pdqY/+MTzoOBJcyq6cAUbvRnznMuh96oLiJxEX7Kd82HZFVlPj3Ef4eeC0uBx0Khbkvm0QFFdSYyNCMpa2vyoc99+Lv1uFJArkXdt2qkhH6b9t72TX8+oH3knsfJq22an6ZiojJ/m3k88bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpmxr//r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpmxr//r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530E5C4CEF0;
	Tue, 12 Aug 2025 17:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021111;
	bh=TxE9UeQhmfJyFG0uhkZqseaCQaDbdPs6yOyK5wOcIgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpmxr//r5MM9eEQk7rt6wHV2KBC5RHBSRseC+LIe7oNDrXr8f7e0tgVDQhyfHe4M5
	 ExV9bDRsTRu+HCrMFDzRXA2ASDVuPp9kw5MW3MCX85iECqfHIO27hrDCdrZMv2ofeo
	 VduhIJTqmCJwX37kg+v4y0ClMHN9PjcqHnNGsNfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/262] net: dst: annotate data-races around dst->input
Date: Tue, 12 Aug 2025 19:27:31 +0200
Message-ID: <20250812172955.670642353@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit f1c5fd34891a1c242885f48c2e4dc52df180f311 ]

dst_dev_put() can overwrite dst->input while other
cpus might read this field (for instance from dst_input())

Add READ_ONCE()/WRITE_ONCE() annotations to suppress
potential issues.

We will likely need full RCU protection later.

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250630121934.3399505-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst.h      | 2 +-
 include/net/lwtunnel.h | 4 ++--
 net/core/dst.c         | 2 +-
 net/ipv4/route.c       | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 16b7b99b5f30..ef7f88f01881 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -474,7 +474,7 @@ INDIRECT_CALLABLE_DECLARE(int ip_local_deliver(struct sk_buff *));
 /* Input packet from network to transport.  */
 static inline int dst_input(struct sk_buff *skb)
 {
-	return INDIRECT_CALL_INET(skb_dst(skb)->input,
+	return INDIRECT_CALL_INET(READ_ONCE(skb_dst(skb)->input),
 				  ip6_input, ip_local_deliver, skb);
 }
 
diff --git a/include/net/lwtunnel.h b/include/net/lwtunnel.h
index 53bd2d02a4f0..a4632a64daae 100644
--- a/include/net/lwtunnel.h
+++ b/include/net/lwtunnel.h
@@ -142,8 +142,8 @@ static inline void lwtunnel_set_redirect(struct dst_entry *dst)
 		dst->output = lwtunnel_output;
 	}
 	if (lwtunnel_input_redirect(dst->lwtstate)) {
-		dst->lwtstate->orig_input = dst->input;
-		dst->input = lwtunnel_input;
+		dst->lwtstate->orig_input = READ_ONCE(dst->input);
+		WRITE_ONCE(dst->input, lwtunnel_input);
 	}
 }
 #else
diff --git a/net/core/dst.c b/net/core/dst.c
index aad197e761cb..def3dbbd37e3 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -150,7 +150,7 @@ void dst_dev_put(struct dst_entry *dst)
 	dst->obsolete = DST_OBSOLETE_DEAD;
 	if (dst->ops->ifdown)
 		dst->ops->ifdown(dst, dev);
-	dst->input = dst_discard;
+	WRITE_ONCE(dst->input, dst_discard);
 	dst->output = dst_discard_out;
 	dst->dev = blackhole_netdev;
 	netdev_ref_replace(dev, blackhole_netdev, &dst->dev_tracker,
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 8ee1ad2d8c13..f8538507ce3f 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1699,7 +1699,7 @@ struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt)
 		else if (rt->rt_gw_family == AF_INET6)
 			new_rt->rt_gw6 = rt->rt_gw6;
 
-		new_rt->dst.input = rt->dst.input;
+		new_rt->dst.input = READ_ONCE(rt->dst.input);
 		new_rt->dst.output = rt->dst.output;
 		new_rt->dst.error = rt->dst.error;
 		new_rt->dst.lastuse = jiffies;
-- 
2.39.5



