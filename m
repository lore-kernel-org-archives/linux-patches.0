Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AAE32FA17;
	Mon, 29 Dec 2025 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025061; cv=none; b=VIvhx4qSHJADkk34SYExJa754N1ZQ365tNUD5f62FhD0+YDctV9siZzgAYP830VoroI2AoO6pkpbJumJUNF0iIn3G1o/soQQ6dnZMWLrlkfdyRiIcyYRWFpx1S1SnpSjofO0B+OhzslBjF+jlFo9wslJzltXxpQoBD4ipZnN2ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025061; c=relaxed/simple;
	bh=fLqaYbRQJgNEiX6fe0rgCsTzqt/AEFNzcO34Pf7jS1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cA72Bba+lTjMw9NCjqZGxht22SPFNF360i8MfRnMPJaQopLqrR1oasoj7xCgy4MsjIaaPK4nlC06c8zp2aqcVcI9kBt9ol6QswXsoImGUjjNRexBgF8o5RCoSGlZmCcCKyCVqR3JAcXaoToKyaKgxX8vyCPxUP0HLPGWSFsWNAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tc0eoHqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tc0eoHqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D28FC4CEF7;
	Mon, 29 Dec 2025 16:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025061;
	bh=fLqaYbRQJgNEiX6fe0rgCsTzqt/AEFNzcO34Pf7jS1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tc0eoHqwP51rZ7+NIo+GshKfM4/pqTUX3UpCuOuO2hoR6Do5XD8UdcUd2gt2Tojxu
	 +HFbF3rbNUckYRPABoB6Pws6ZfpEZpJ6cxp/0JU3AQg21/HrrAdk1E+WPwclYytb2d
	 RizjTtbXVcn0z5a5p5AmfvVZ+MDBF8dhi9iM9s1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <slavin452@gmail.com>,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 080/430] ipvs: fix ipv4 null-ptr-deref in route error path
Date: Mon, 29 Dec 2025 17:08:02 +0100
Message-ID: <20251229160727.308678794@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slavin Liu <slavin452@gmail.com>

[ Upstream commit ad891bb3d079a46a821bf2b8867854645191bab0 ]

The IPv4 code path in __ip_vs_get_out_rt() calls dst_link_failure()
without ensuring skb->dev is set, leading to a NULL pointer dereference
in fib_compute_spec_dst() when ipv4_link_failure() attempts to send
ICMP destination unreachable messages.

The issue emerged after commit ed0de45a1008 ("ipv4: recompile ip options
in ipv4_link_failure") started calling __ip_options_compile() from
ipv4_link_failure(). This code path eventually calls fib_compute_spec_dst()
which dereferences skb->dev. An attempt was made to fix the NULL skb->dev
dereference in commit 0113d9c9d1cc ("ipv4: fix null-deref in
ipv4_link_failure"), but it only addressed the immediate dev_net(skb->dev)
dereference by using a fallback device. The fix was incomplete because
fib_compute_spec_dst() later in the call chain still accesses skb->dev
directly, which remains NULL when IPVS calls dst_link_failure().

The crash occurs when:
1. IPVS processes a packet in NAT mode with a misconfigured destination
2. Route lookup fails in __ip_vs_get_out_rt() before establishing a route
3. The error path calls dst_link_failure(skb) with skb->dev == NULL
4. ipv4_link_failure() → ipv4_send_dest_unreach() →
   __ip_options_compile() → fib_compute_spec_dst()
5. fib_compute_spec_dst() dereferences NULL skb->dev

Apply the same fix used for IPv6 in commit 326bf17ea5d4 ("ipvs: fix
ipv6 route unreach panic"): set skb->dev from skb_dst(skb)->dev before
calling dst_link_failure().

KASAN: null-ptr-deref in range [0x0000000000000328-0x000000000000032f]
CPU: 1 PID: 12732 Comm: syz.1.3469 Not tainted 6.6.114 #2
RIP: 0010:__in_dev_get_rcu include/linux/inetdevice.h:233
RIP: 0010:fib_compute_spec_dst+0x17a/0x9f0 net/ipv4/fib_frontend.c:285
Call Trace:
  <TASK>
  spec_dst_fill net/ipv4/ip_options.c:232
  spec_dst_fill net/ipv4/ip_options.c:229
  __ip_options_compile+0x13a1/0x17d0 net/ipv4/ip_options.c:330
  ipv4_send_dest_unreach net/ipv4/route.c:1252
  ipv4_link_failure+0x702/0xb80 net/ipv4/route.c:1265
  dst_link_failure include/net/dst.h:437
  __ip_vs_get_out_rt+0x15fd/0x19e0 net/netfilter/ipvs/ip_vs_xmit.c:412
  ip_vs_nat_xmit+0x1d8/0xc80 net/netfilter/ipvs/ip_vs_xmit.c:764

Fixes: ed0de45a1008 ("ipv4: recompile ip options in ipv4_link_failure")
Signed-off-by: Slavin Liu <slavin452@gmail.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 95af252b29397..618fbe1240b54 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -409,6 +409,9 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 	return -1;
 
 err_unreach:
+	if (!skb->dev)
+		skb->dev = skb_dst(skb)->dev;
+
 	dst_link_failure(skb);
 	return -1;
 }
-- 
2.51.0



