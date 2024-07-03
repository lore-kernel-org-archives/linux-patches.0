Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B80A17C201;
	Wed,  3 Jul 2024 10:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003358; cv=none; b=Ll32qm3tv7XCHLwJEpGS0qenLFt+FcFyFn8xzFQUqA940PGEuitzUIxZarjObf/LmhxK0x8dAPSNA/sPHo3EyNwJJ8f8GT/eHGj1uB9VgwpU0MHOfMhHvyZ9l2iQIUnfFRU2GdEhCHKLsNJNt2U7zprXZrE6ZcceQsaY7jr6jpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003358; c=relaxed/simple;
	bh=SUiTNn00z382zLUtfgSGh0lCwQ+10baIpjq8Rz45Lt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHcjkseceSr8WSaRKuFojGecPhr34NbovSaMZpwcKK8F7zSA1492MHCcrdlGcwn1c8Gey6rYreqRZP3DvVi3Q2UoPo8zxKMWii8ocmhYdUXwCAQnx22gELK1daSp7Sm4tC1St0TNEE4neagOyqKUecda2rYdxbgYorgQzTll3vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCY9KjSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCY9KjSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D0AC2BD10;
	Wed,  3 Jul 2024 10:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003358;
	bh=SUiTNn00z382zLUtfgSGh0lCwQ+10baIpjq8Rz45Lt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCY9KjSUborEzvUiyH7MtuITsIGzLZo3VV056hzlwPZ7lRpeAfTs0SoLjoFp6XU/b
	 zYPKTxJKbGeanSpVwq61azkyyHKc7pUypdiRFLCxdte48dmd9ALmSjPYmrSik/zoJM
	 4BJUm222T0sJ0rtzBxC4GPD/vkLUNCmg0G9xK1Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Lebrun <dlebrun@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 005/139] ipv6: sr: block BH in seg6_output_core() and seg6_input_core()
Date: Wed,  3 Jul 2024 12:38:22 +0200
Message-ID: <20240703102830.639731318@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2e90672852c86..7dc447e08a486 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -313,9 +313,8 @@ static int seg6_input(struct sk_buff *skb)
 
 	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
 
-	preempt_disable();
+	local_bh_disable();
 	dst = dst_cache_get(&slwt->cache);
-	preempt_enable();
 
 	skb_dst_drop(skb);
 
@@ -323,14 +322,13 @@ static int seg6_input(struct sk_buff *skb)
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
@@ -352,9 +350,9 @@ static int seg6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 
 	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
 
-	preempt_disable();
+	local_bh_disable();
 	dst = dst_cache_get(&slwt->cache);
-	preempt_enable();
+	local_bh_enable();
 
 	if (unlikely(!dst)) {
 		struct ipv6hdr *hdr = ipv6_hdr(skb);
@@ -374,9 +372,9 @@ static int seg6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
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



