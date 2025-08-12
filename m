Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6864F2FE59B;
	Tue, 12 Aug 2025 18:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023874; cv=none; b=CgFTdhzX9XUkktXME1+cz9lrT/VLjBu0K/67c+lnrJ93N1s6bNqrOeSymRzYyiIluYn3fe0+7MdFx92ZsX1A04njlacNSBL4L8Z+njY7dAclpK6UGrnFxL8YYaVUsS0aunad5SXynzLFNl34LNXP+kIBYhhJZInsGV7tx22FHJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023874; c=relaxed/simple;
	bh=BWSUqOXofZJ969UJwVA9aKAhSJ3T6nfQ1s433dIYaTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFLUxGMMgWxGXqPM/c1CYHs4FNJVMlqsApJ1rcmpdcqp3Avc/zabktOdi+DJqKv3dLX/6koAjiYQ6apPJWlAcbkQ9MrSCHFqmQfEei1gVLsp8Flp8VH1HJYXXWrpfnOLQ/inxq0S1w3nwkgSLwsmFn0DDnjrgs+eZbTa77Y0oAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAcIedCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAcIedCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA619C4CEF0;
	Tue, 12 Aug 2025 18:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023874;
	bh=BWSUqOXofZJ969UJwVA9aKAhSJ3T6nfQ1s433dIYaTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAcIedCpFjW9xFPRNSSTxMcSiQTY7yYiyWpRdZ9ZIXmcB7FiHHXZTqpN3Lf85cTCf
	 5+rvI5FGzzb6dG+teMW1gxy54jf4hg6Lrj+E8lSGJMigyKzfl2MbYxN2tHWOsFoNjD
	 GK5X7OjSJ6Al4rW8bGxhURVYWjR+grFKgsWc/ajA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 175/627] net: dst: annotate data-races around dst->output
Date: Tue, 12 Aug 2025 19:27:50 +0200
Message-ID: <20250812173425.934867221@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 65d81116d6bf..2caf85e2ce86 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -456,7 +456,7 @@ INDIRECT_CALLABLE_DECLARE(int ip_output(struct net *, struct sock *,
 /* Output packet to network from transport.  */
 static inline int dst_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	return INDIRECT_CALL_INET(skb_dst(skb)->output,
+	return INDIRECT_CALL_INET(READ_ONCE(skb_dst(skb)->output),
 				  ip6_output, ip_output,
 				  net, sk, skb);
 }
diff --git a/include/net/lwtunnel.h b/include/net/lwtunnel.h
index eaac07d50595..26232f603e33 100644
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
index b46f7722a1b6..e483daf17666 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -149,7 +149,7 @@ void dst_dev_put(struct dst_entry *dst)
 	if (dst->ops->ifdown)
 		dst->ops->ifdown(dst, dev);
 	WRITE_ONCE(dst->input, dst_discard);
-	dst->output = dst_discard_out;
+	WRITE_ONCE(dst->output, dst_discard_out);
 	dst->dev = blackhole_netdev;
 	netdev_ref_replace(dev, blackhole_netdev, &dst->dev_tracker,
 			   GFP_ATOMIC);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 2cc88f8c3bc6..bd5d48fdd62a 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1686,7 +1686,7 @@ struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt)
 			new_rt->rt_gw6 = rt->rt_gw6;
 
 		new_rt->dst.input = READ_ONCE(rt->dst.input);
-		new_rt->dst.output = rt->dst.output;
+		new_rt->dst.output = READ_ONCE(rt->dst.output);
 		new_rt->dst.error = rt->dst.error;
 		new_rt->dst.lastuse = jiffies;
 		new_rt->dst.lwtstate = lwtstate_get(rt->dst.lwtstate);
-- 
2.39.5



