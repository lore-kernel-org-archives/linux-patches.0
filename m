Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ACB47AF4D;
	Thu, 20 Aug 2026 16:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243511; cv=none; b=sTLpcK4CybHE+TaY5XrRlXRfwbpLS0EDfR+WF6eq6saHRr4Gg6x1emyoLDWXXOIV5YPquIBfMJsCdWwtt1wpAzzxF5+ly9S2FBGjVM5fp1aHf+01sBu9vSwEvGPCX0gPPg3W+IFRbXa7d5LjQj0ppc+CUB48w3IhZJLmdDFz7Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243511; c=relaxed/simple;
	bh=Pus47+c/JybBOFEukFCxURuUVETmzooI10zLp/7a36w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5VO6qi+P+YOGIa9J28xbmXSWdGM5Jpn2/gmiPaLR9VWmk2TvJK2tp38apO6C8j/T6TpBGGorF7KSv0VGIJB/AFtUQBx47nHOgSCucqWk3EZcLHuaIjqxT43UdI9P5qaxJ1XtjbwhsCNq1ofOBJQftTc5ThEb9fq8o3YwJEHxxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBO2PmCc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBO2PmCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624131F00A3A;
	Thu, 20 Aug 2026 16:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243509;
	bh=xyVSn9DhhkroMpVoKbu9GLWrr6u1Cqp8JwvEbm19lj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBO2PmCc3+qfCxD3u8TCzazIMIMT7esUAocDa0I4kjo5sjRGyAVXJjzLtZJUWbxGD
	 MuEInoIM7c3WPm4DpYygSHbmM1BjdUH4lpJJetBotqrADgJInic/N9Imt9zbyv0I1V
	 n2as2SB3my0obdX1moac9U6Ot69QVSRSUifivwKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/272] net: dst: annotate data-races around dst->input
Date: Thu, 20 Aug 2026 16:54:24 +0200
Message-ID: <20260820145233.679528165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: c9c9b37f8c55 ("netfilter: nf_queue: pin bridge device while NFQUEUE holds fake dst")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst.h      |    2 +-
 include/net/lwtunnel.h |    4 ++--
 net/core/dst.c         |    2 +-
 net/ipv4/route.c       |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -459,7 +459,7 @@ INDIRECT_CALLABLE_DECLARE(int ip_local_d
 /* Input packet from network to transport.  */
 static inline int dst_input(struct sk_buff *skb)
 {
-	return INDIRECT_CALL_INET(skb_dst(skb)->input,
+	return INDIRECT_CALL_INET(READ_ONCE(skb_dst(skb)->input),
 				  ip6_input, ip_local_deliver, skb);
 }
 
--- a/include/net/lwtunnel.h
+++ b/include/net/lwtunnel.h
@@ -142,8 +142,8 @@ static inline void lwtunnel_set_redirect
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
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -149,7 +149,7 @@ void dst_dev_put(struct dst_entry *dst)
 	dst->obsolete = DST_OBSOLETE_DEAD;
 	if (dst->ops->ifdown)
 		dst->ops->ifdown(dst, dev, true);
-	dst->input = dst_discard;
+	WRITE_ONCE(dst->input, dst_discard);
 	dst->output = dst_discard_out;
 	dst->dev = blackhole_netdev;
 	dev_hold(dst->dev);
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1732,7 +1732,7 @@ struct rtable *rt_dst_clone(struct net_d
 			new_rt->rt_gw6 = rt->rt_gw6;
 		INIT_LIST_HEAD(&new_rt->rt_uncached);
 
-		new_rt->dst.input = rt->dst.input;
+		new_rt->dst.input = READ_ONCE(rt->dst.input);
 		new_rt->dst.output = rt->dst.output;
 		new_rt->dst.error = rt->dst.error;
 		new_rt->dst.lastuse = jiffies;


