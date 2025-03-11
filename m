Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1870A255E37;
	Tue, 11 Mar 2025 15:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707366; cv=none; b=g9vyXQBcMfO33Vkgmc5jC0Rn6fDTYBApqSl8oyD5a5TPMQBolROYaIfvxUZhFiEJYDMgpqdzjqUz1rUA/+g2t/ee7yJm6dnBr3KEg8Plmoqi6me6hbov48OIJ9SqgTqsosqrjH63dPWuQP6UcFoZ5ArJK4ktGds3m3R/UVEGA64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707366; c=relaxed/simple;
	bh=tyh4ycTO/Tb2yG2DtgBQU791ttybsIVukaBJzKrD0nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QB3lRE+s5rGHw12zFIYQhyzvcdorvdauzxNCPZvEdV2MdSeUcsk3uwQP0oBDh/fnORqlN2sehMvr7ei/goQhD+ZJRas3CbJrUC7m8DuWxkwdc4BhqrUfM9ztZWSW/B0s+ihcN1ktWO52dzG2jwhyzPlPBAKzmtBCTCaIpgd93GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MA0ag+1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MA0ag+1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F59C4CEED;
	Tue, 11 Mar 2025 15:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707366;
	bh=tyh4ycTO/Tb2yG2DtgBQU791ttybsIVukaBJzKrD0nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MA0ag+1CJTwZ5u7fMEmWwEBpip7nRMZDD1QU2lNMIesMwHRe968Mzm8SMdrc3LqcF
	 yQxWYhIVWkrnKX1rRP7N3umzL1Xd9Pbr6acwZdMw+1IpvTYOPyjG8OZe5X103gnPv7
	 PsEK1O4RONREYqeBh9QazjQFvuuU+KwUHnvTrZ3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Vazquez <brianvv@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 364/462] net: use indirect call helpers for dst_output
Date: Tue, 11 Mar 2025 16:00:30 +0100
Message-ID: <20250311145812.731372741@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Vazquez <brianvv@google.com>

[ Upstream commit 6585d7dc491d9d5e323ed52ee32ad071e04c9dfa ]

This patch avoids the indirect call for the common case:
ip6_output and ip_output

Signed-off-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 13e55fbaec17 ("net: ipv6: fix dst ref loop on input in rpl lwt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst.h     | 8 +++++++-
 net/ipv4/ip_output.c  | 1 +
 net/ipv6/ip6_output.c | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 907b4b5893a67..af57a6284444c 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -431,10 +431,16 @@ static inline void dst_set_expires(struct dst_entry *dst, int timeout)
 		dst->expires = expires;
 }
 
+INDIRECT_CALLABLE_DECLARE(int ip6_output(struct net *, struct sock *,
+					 struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(int ip_output(struct net *, struct sock *,
+					 struct sk_buff *));
 /* Output packet to network from transport.  */
 static inline int dst_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	return skb_dst(skb)->output(net, sk, skb);
+	return INDIRECT_CALL_INET(skb_dst(skb)->output,
+				  ip6_output, ip_output,
+				  net, sk, skb);
 }
 
 INDIRECT_CALLABLE_DECLARE(int ip6_input(struct sk_buff *));
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 12ee857d6cfe4..1e430e135aa60 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -441,6 +441,7 @@ int ip_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 			    ip_finish_output,
 			    !(IPCB(skb)->flags & IPSKB_REROUTED));
 }
+EXPORT_SYMBOL(ip_output);
 
 /*
  * copy saddr and daddr, possibly using 64bit load/stores
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 4da3238836b73..5003c5a23fa70 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -236,6 +236,7 @@ int ip6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 			    ip6_finish_output,
 			    !(IP6CB(skb)->flags & IP6SKB_REROUTED));
 }
+EXPORT_SYMBOL(ip6_output);
 
 bool ip6_autoflowlabel(struct net *net, const struct ipv6_pinfo *np)
 {
-- 
2.39.5



