Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B922A143757;
	Wed, 19 Jun 2024 13:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803524; cv=none; b=WcjL3ZmKCd+9IspCKYavOfdDNpLdplL3ze8T5ZuuC0+e2IrBOgZ+M4cxYvcLuC6X36rna/gx83UgiF2qZ3MVCLMuVoUnNMozto9biGqJGDQxk+8mJdj3OUe7Z6a46DkxyZDXU1zMnOiRNwlQZ2KSNMTZRA/o4JRecANu5A3B5uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803524; c=relaxed/simple;
	bh=CdGGbyfj7ywybLuyg5WGmZDfZXewO3rYrSo/FbEYyQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiwzNgQ6kCC9tHxs+Rbhqi5vyrK9pm/bpSD4SQATiuDgsSj47JmFDXQKrVIciqAeUcKJTfQ4gsQBfylHO8oC11U8jMWNBz7JvmhZsY/5aI0BJF5UHCgByCmeYFmDH5Pxeo4V7QUFM4n1irUUREVLr0HlzFMG7DfMEAW9RacBYSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekGhEn2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekGhEn2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2ACC2BBFC;
	Wed, 19 Jun 2024 13:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803524;
	bh=CdGGbyfj7ywybLuyg5WGmZDfZXewO3rYrSo/FbEYyQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekGhEn2KDO66N7oPVpxuoiDn9pRTYyzVQ78sWglZmks2UfxQzYvS/ZyZPnmsB8OUE
	 yJW9naAqUK0fhgnvtx5bDnmFPXmSBx0RacmUayVP9g4kI6nOj0uRKUCil8bEOVzgPP
	 6qMOnFHV9bHoslu79qJ9uE07oL7WAIcNxS7d1Ymo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/217] ipv6: ioam: block BH from ioam6_output()
Date: Wed, 19 Jun 2024 14:54:18 +0200
Message-ID: <20240619125557.228382303@linuxfoundation.org>
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

[ Upstream commit 2fe40483ec257de2a0d819ef88e3e76c7e261319 ]

As explained in commit 1378817486d6 ("tipc: block BH
before using dst_cache"), net/core/dst_cache.c
helpers need to be called with BH disabled.

Disabling preemption in ioam6_output() is not good enough,
because ioam6_output() is called from process context,
lwtunnel_output() only uses rcu_read_lock().

We might be interrupted by a softirq, re-enter ioam6_output()
and corrupt dst_cache data structures.

Fix the race by using local_bh_disable() instead of
preempt_disable().

Fixes: 8cb3bf8bff3c ("ipv6: ioam: Add support for the ip6ip6 encapsulation")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Justin Iurman <justin.iurman@uliege.be>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240531132636.2637995-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ioam6_iptunnel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ioam6_iptunnel.c b/net/ipv6/ioam6_iptunnel.c
index f6f5b83dd954d..a5cfc5b0b206b 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -351,9 +351,9 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 		goto drop;
 
 	if (!ipv6_addr_equal(&orig_daddr, &ipv6_hdr(skb)->daddr)) {
-		preempt_disable();
+		local_bh_disable();
 		dst = dst_cache_get(&ilwt->cache);
-		preempt_enable();
+		local_bh_enable();
 
 		if (unlikely(!dst)) {
 			struct ipv6hdr *hdr = ipv6_hdr(skb);
@@ -373,9 +373,9 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 				goto drop;
 			}
 
-			preempt_disable();
+			local_bh_disable();
 			dst_cache_set_ip6(&ilwt->cache, dst, &fl6.saddr);
-			preempt_enable();
+			local_bh_enable();
 		}
 
 		skb_dst_drop(skb);
-- 
2.43.0



