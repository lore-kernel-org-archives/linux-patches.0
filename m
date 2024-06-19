Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C157214388C;
	Wed, 19 Jun 2024 12:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801939; cv=none; b=f8Zt7le2PmSzECSR2jXLChcNQ7K3wshB3yY3UsKHfvAljlwmqzaawiwnLljfpYmPdb9ONnKPBDHmSt9wUP25QaNAJN4tIyPD86w3YP8Sc+da2gSwjKtuzSWjKC6Z4IAxVx0ErYJIGzc6nr/STbTRWlM1q53LMkim9caO0x73cnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801939; c=relaxed/simple;
	bh=mRZ55QTw4vvJrYH/im8ItzVw11KEN26UwQlt4wUFsBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmujKfXJmhk6ZDXtxFxq8KAiEfGTrfOnxxox6kB+mLg5TQ9QrZXBtgRVvRjkaGJVBAT14+3KVcT/L/tNMsHR8PlHxnwSZ2xduDnWLvby037C2o9XZAq4olITzzv80S5EHtHG7RsbVIlS3g7JEQnDhXTYyns5LcHsdjuq765xX44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvtDRdEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvtDRdEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC3BC2BBFC;
	Wed, 19 Jun 2024 12:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801939;
	bh=mRZ55QTw4vvJrYH/im8ItzVw11KEN26UwQlt4wUFsBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvtDRdEAMFsIlaYMdzcaZEqO4YNLIWwgpcg17Zel9xTt+3GGhJQV487ogGIYNGffl
	 tNrB6Gum3vNmuf3UwvF4EYz6hTF4Ag7yiYILjm2b36ApPhEOdD1HhJTilhQ/PP5oWb
	 6Lclpd6JjwFDSdHZOceZEw+9PXoarxG5SIJB3QxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/267] ipv6: ioam: block BH from ioam6_output()
Date: Wed, 19 Jun 2024 14:52:59 +0200
Message-ID: <20240619125607.445063970@linuxfoundation.org>
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



