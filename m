Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2B414B07B;
	Wed, 19 Jun 2024 13:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802747; cv=none; b=sxrGhTedMntFRmGf12uDOlLcCfUcMSD6F3nMPfpd9X1KCWhJZTXQT0bwFb0Ie2dQxICUIPZXXCFJNYyu3hFo7C+Xs5m2w3eDI6MbnkR7dyPtSS3EnQb5wrQfHLz4D/Yupo8S+l8OZ4q7/xY6MXLWuDflwUoADqGSSna9oGeVpsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802747; c=relaxed/simple;
	bh=mJUEcxYQY98cw+jUQ9kWXKuAbiIL2EEu4lBZB6E6fKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNx97W7it6Ev6l7tF6mv3xexqw6hose15v+zpbwjsBgEzkvvtTGO4ugiL3ZMncyFSo7w1HKUUPpSIw1bwX2j92JPbHCd3+0Acmvho5oH2eckybsU8hvwL47vJKLpXizW9scgHqlhfLj73lZ8dWE4psyR66JB1bnXEm9C9vL4ZXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0u03CoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0u03CoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EECBC2BBFC;
	Wed, 19 Jun 2024 13:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802747;
	bh=mJUEcxYQY98cw+jUQ9kWXKuAbiIL2EEu4lBZB6E6fKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0u03CoFMiZ+QKpC1aGlGSXyljx2KdTbx4iBjw08s60ZoMGBaRtNHVtgRPzsgQUc/
	 zsycOw+jMn9InEZ5r4Z6nQb9iDLcD/IiFJ8mSSLG+QoQhT2b7tHIOyl2EZgLsCQ7vY
	 0W0q+CHUpQbaX7eeUjHulxATCyyyx/jwv1lQ7CFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Lebrun <dlebrun@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 033/281] ipv6: sr: block BH in seg6_output_core() and seg6_input_core()
Date: Wed, 19 Jun 2024 14:53:12 +0200
Message-ID: <20240619125611.124197926@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



