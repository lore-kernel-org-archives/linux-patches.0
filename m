Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD64221FAC;
	Tue, 12 Aug 2025 17:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021203; cv=none; b=NDHLegNCQMYIQNg4/S/rzqHL69xgPa05ZzPfx7jibS3dEbM6G+N8cxmkjfOg0ZWKfy08/97/4zDe6FjhXOtQYv8qFKTJ3BKrjnuwePDCzFb02hxrGhy1G+UYTLeIFIL5+ZzP7iLoH933InrO7U8Oe4RP8ptfKBJz5xwvb7asLDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021203; c=relaxed/simple;
	bh=5xJBha7vIrdnOqvRHY0FKcHe7NuKEfWH04cETb0qr10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMroZ9rp6V85xdi7si0nQiD2z7PuHIatxMmKW9WzEtlEigN3UW09INbdK2+RVDHrrVX0jNxcjUTQOzcIWZiAQn2ZDimdXogTenCDAXCxydaaduhIVMs5ffIecO6Ss++/wL4KxQ+0GF0BtdlLcnH6hgdA0ZpAUVAEh+Vsghq5lao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODzYfgpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODzYfgpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE55DC4CEF0;
	Tue, 12 Aug 2025 17:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021203;
	bh=5xJBha7vIrdnOqvRHY0FKcHe7NuKEfWH04cETb0qr10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODzYfgpDn+kyMd8dART0fat5owoQCL//VA2XVX0IBM0uTFWkuxW13YLk6buOq9zEO
	 rV6+/BkqVJX0UexSH2/eD/oGYqTwNfQvfO7ShW7j87cQZ7BB+xAQG+Pi7VtMayurDl
	 Od4POzU9x1DRQbm6jXWXtulAXsIPZqv+OFiV63EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/262] net: dst: annotate data-races around dst->output
Date: Tue, 12 Aug 2025 19:27:32 +0200
Message-ID: <20250812172955.713852206@linuxfoundation.org>
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

[ Upstream commit 2dce8c52a98995c4719def6f88629ab1581c0b82 ]

dst_dev_put() can overwrite dst->output while other
cpus might read this field (for instance from dst_output())

Add READ_ONCE()/WRITE_ONCE() annotations to suppress
potential issues.

We will likely need RCU protection in the future.

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250630121934.3399505-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst.h      | 2 +-
 include/net/lwtunnel.h | 4 ++--
 net/core/dst.c         | 2 +-
 net/ipv4/route.c       | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index ef7f88f01881..60fb5d2faf43 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -464,7 +464,7 @@ INDIRECT_CALLABLE_DECLARE(int ip_output(struct net *, struct sock *,
 /* Output packet to network from transport.  */
 static inline int dst_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	return INDIRECT_CALL_INET(skb_dst(skb)->output,
+	return INDIRECT_CALL_INET(READ_ONCE(skb_dst(skb)->output),
 				  ip6_output, ip_output,
 				  net, sk, skb);
 }
diff --git a/include/net/lwtunnel.h b/include/net/lwtunnel.h
index a4632a64daae..09791f5d9b6e 100644
--- a/include/net/lwtunnel.h
+++ b/include/net/lwtunnel.h
@@ -138,8 +138,8 @@ int bpf_lwt_push_ip_encap(struct sk_buff *skb, void *hdr, u32 len,
 static inline void lwtunnel_set_redirect(struct dst_entry *dst)
 {
 	if (lwtunnel_output_redirect(dst->lwtstate)) {
-		dst->lwtstate->orig_output = dst->output;
-		dst->output = lwtunnel_output;
+		dst->lwtstate->orig_output = READ_ONCE(dst->output);
+		WRITE_ONCE(dst->output, lwtunnel_output);
 	}
 	if (lwtunnel_input_redirect(dst->lwtstate)) {
 		dst->lwtstate->orig_input = READ_ONCE(dst->input);
diff --git a/net/core/dst.c b/net/core/dst.c
index def3dbbd37e3..2513665696f6 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -151,7 +151,7 @@ void dst_dev_put(struct dst_entry *dst)
 	if (dst->ops->ifdown)
 		dst->ops->ifdown(dst, dev);
 	WRITE_ONCE(dst->input, dst_discard);
-	dst->output = dst_discard_out;
+	WRITE_ONCE(dst->output, dst_discard_out);
 	dst->dev = blackhole_netdev;
 	netdev_ref_replace(dev, blackhole_netdev, &dst->dev_tracker,
 			   GFP_ATOMIC);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f8538507ce3f..6ee77f7f9114 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1700,7 +1700,7 @@ struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt)
 			new_rt->rt_gw6 = rt->rt_gw6;
 
 		new_rt->dst.input = READ_ONCE(rt->dst.input);
-		new_rt->dst.output = rt->dst.output;
+		new_rt->dst.output = READ_ONCE(rt->dst.output);
 		new_rt->dst.error = rt->dst.error;
 		new_rt->dst.lastuse = jiffies;
 		new_rt->dst.lwtstate = lwtstate_get(rt->dst.lwtstate);
-- 
2.39.5



