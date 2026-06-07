Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8434071DA;
	Sun,  7 Jun 2026 10:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827528; cv=none; b=FDAoDgm5Of3erOO0BASWNK35+gkuG/QhqJhY/+bkpm5O4KQ8IpZWdfebVMsSD80J0sXw0F2gsQPifF7CDFPpRseDSFLF+ETSqTfElLA6/hgKVWzWvcFvbm8zAw/CAWehwVGJjtPGbz7DS2HHSU48icmkaKtO+OkKiaxBGEjP0zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827528; c=relaxed/simple;
	bh=VrWTW2jTaZCxULMLrDmijtR/+JSTr+hAVjsdFm5E/xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QN5/EllQQbZf6oqnbd/iozmhk4e5BY+/fANemTC2mDEq3kAD4QvRGx/NFRDRs6UubO+2lWopCESxWZJGjPwJxVDU5tYgWszHZLMYp52EfHPFy4+nRHPxr8IuQtFaM4U+atGZXbmJZ6XWn13UBe8yQg1MF6cM9XwKiyOZXGzqFzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPn9VXWL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPn9VXWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274771F00893;
	Sun,  7 Jun 2026 10:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827526;
	bh=abgeNCwB39yumgdUBeGdRN8UgAsVW7NKkx+O3NWuKn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vPn9VXWLf8VMm7Sw5u1/sbRUuWB0BTje8sf2GsBJfXHFQU/qzKT8rXqiNSQaP/DzP
	 s9e9DfxWnhJ6tEdSwONyjoLf/B0PYjqWYZTPYQtPxW5X+4pPCPUBA22FqCm5WfuLVd
	 dpzxbumS4EL8/icw7YJW7Vbrr6jhb56Bc4M3SyoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damiano Melotti <melotti@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/307] tunnels: do not assume transport header in iptunnel_pmtud_check_icmp()
Date: Sun,  7 Jun 2026 11:57:39 +0200
Message-ID: <20260607095730.025830137@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 509323077ef79a26ba0c60bb556e45c12c398b2d ]

In some cases, iptunnel_pmtud_check_icmp() can be called while
skb transport header is not set.

This triggers an out-of-bound access, because
(typeof(skb->transport_header))~0U is 65535.

Access the icmp header based on IPv4 network header,
after making sure icmp->type is present in skb linear part.

Note that iptunnel_pmtud_check_icmpv6()) is fine.

Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
Reported-by: Damiano Melotti <melotti@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260522115512.1519110-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel_core.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index cf496644d3df6c..d0ceb86e1687a7 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -278,7 +278,6 @@ static int iptunnel_pmtud_build_icmp(struct sk_buff *skb, int mtu)
  */
 static int iptunnel_pmtud_check_icmp(struct sk_buff *skb, int mtu)
 {
-	const struct icmphdr *icmph = icmp_hdr(skb);
 	const struct iphdr *iph = ip_hdr(skb);
 
 	if (mtu < 576 || iph->frag_off != htons(IP_DF))
@@ -289,9 +288,17 @@ static int iptunnel_pmtud_check_icmp(struct sk_buff *skb, int mtu)
 	    ipv4_is_lbcast(iph->saddr)  || ipv4_is_multicast(iph->saddr))
 		return 0;
 
-	if (iph->protocol == IPPROTO_ICMP && icmp_is_err(icmph->type))
-		return 0;
+	if (iph->protocol == IPPROTO_ICMP) {
+		const struct icmphdr *icmph;
 
+		if (!pskb_network_may_pull(skb, iph->ihl * 4 +
+						offsetofend(struct icmphdr, type)))
+			return 0;
+		iph = ip_hdr(skb);
+		icmph = (void *)iph + iph->ihl * 4;
+		if (icmp_is_err(icmph->type))
+			return 0;
+	}
 	return iptunnel_pmtud_build_icmp(skb, mtu);
 }
 
-- 
2.53.0



