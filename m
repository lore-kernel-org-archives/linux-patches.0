Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FFD143C4E;
	Wed, 19 Jun 2024 13:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802744; cv=none; b=riYOoPlvOYiwHhRj6OS6t3Vdhvofa8hD4tXfHOJU349LyU+lA5K1TS2HQDlxQejHwddEFxNxNl0jm4Peh4wscha3CwbLivKs6Xyn+tH2UiLuiPaPmrKQ5c+JlQAKXmtK+QmWDi/vzSLDrwgKU92y3xFt+C3Nl1AyWDTmwsx06RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802744; c=relaxed/simple;
	bh=oEy1tkuNHey93gLe0FVsoXPKSPLb8qMxhmR5K4r9Caw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAmW7+gijpPzbDDD0sBQkfuHliDou0CKxK3t7ia+BGNiieA9JvitZ8RmnFGwmapnwTuRXnMrivt5XbGZFryjB3hcFUJSWpruNL8tOm8QWrKfdjg6/YcLQgq2C/3fVis8haq0PQbDFQj34ms70AAWg0W/Zn9zm2Ul9Fqzjff97JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qZSougL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qZSougL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEDFC2BBFC;
	Wed, 19 Jun 2024 13:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802744;
	bh=oEy1tkuNHey93gLe0FVsoXPKSPLb8qMxhmR5K4r9Caw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1qZSougLqmmVHGqRZIZYWLSEK8PWkr6Sq/hzsXBXlcyB/JQeheR0P/HaiKun92HWk
	 ebV1nBzyAd0IfnF4SP5CNPvelQxjT1CEuYkW3kMtU40pp6JC/MhJ+kwJGoNl+5iwAh
	 mdH+LGutaEw0SFZxwTa91+ExvUZyzg+dOtkp12WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 032/281] ipv6: ioam: block BH from ioam6_output()
Date: Wed, 19 Jun 2024 14:53:11 +0200
Message-ID: <20240619125611.085638824@linuxfoundation.org>
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
index 7563f8c6aa87c..bf7120ecea1eb 100644
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



