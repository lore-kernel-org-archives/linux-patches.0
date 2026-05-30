Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BBE31F98D;
	Sat, 30 May 2026 18:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164688; cv=none; b=MEHtAhPcvD0PUnMhLO4Jvu2fUgA0fuB4ELZfU8ELlE/KXQKKte86H6BSfSXIyFtVXxxyOsN6OQQ93E/67g1CdAzCcD3+pmJ39YhefVPHu98U9nZEJMbMzayQADQyAG+mrD86OJxNbqBf+BeOinGhI2kyw3O9fJ9i3VhP66Sh5p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164688; c=relaxed/simple;
	bh=5HpAJc18HvtjSLx20uI5j852CToeen/gUenhv3Giyp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYClZvm3QcvnDRsbSo1xmcKGfnoiyU41gdZR5190NKOvOXMmc8Dd8EYZM3uHIBNncrYSIokuQeqAzN9dLHimTJ1hUgDAiq7QakwLx6wYu+GbXcSR98NhBH0s2J95SWYqtUz/tFd2DDsGWm5XuHc16VRp1k1twX2A63uybIlDqe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAr27MTW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAr27MTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311681F00893;
	Sat, 30 May 2026 18:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164687;
	bh=j+EWyifU5ec5JbF2DAiLSSRgzh0U2jygvmG4jc+nFp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XAr27MTWEUEADhgQdb+LZPvk+qhB5dLVVtNhSzyp6G59V49z3TGlJoxlbhs0olXyW
	 7GUrCFAGBxKmy/sXywY+rccqOjRv/ufDbbgm7IrUEgBprtLXORSEvzw2SYbOQ4uzAa
	 bIDlWWJymjxA4Ufx5JQ+qfHRf4DMb1WRrPSKcTBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 630/776] ipv4: remove "proto" argument from udp_tunnel_dst_lookup()
Date: Sat, 30 May 2026 18:05:44 +0200
Message-ID: <20260530160256.252564119@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Beniamino Galvani <b.galvani@gmail.com>

[ Upstream commit 78f3655adcb52412275f282267ee771421731632 ]

The function is now UDP-specific, the protocol is always IPPROTO_UDP.

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: aa6c6d9ee064 ("bareudp: fix NULL pointer dereference in bareudp_fill_metadata_dst()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c      | 4 ++--
 include/net/udp_tunnel.h   | 2 +-
 net/ipv4/udp_tunnel_core.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index a2008cdcff707..21ad3a7bbbf12 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -319,7 +319,7 @@ static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		return -ESHUTDOWN;
 
 	rt = udp_tunnel_dst_lookup(skb, dev, bareudp->net, &saddr, info,
-				   IPPROTO_UDP, use_cache);
+				   use_cache);
 
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
@@ -499,7 +499,7 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
 		__be32 saddr;
 
 		rt = udp_tunnel_dst_lookup(skb, dev, bareudp->net, &saddr,
-					   info, IPPROTO_UDP, use_cache);
+					   info, use_cache);
 		if (IS_ERR(rt))
 			return PTR_ERR(rt);
 
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 81fdcecde24d6..ac9a8f635a5b1 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -165,7 +165,7 @@ struct rtable *udp_tunnel_dst_lookup(struct sk_buff *skb,
 				     struct net_device *dev,
 				     struct net *net, __be32 *saddr,
 				     const struct ip_tunnel_info *info,
-				     u8 protocol, bool use_cache);
+				     bool use_cache);
 
 struct metadata_dst *udp_tun_rx_dst(struct sk_buff *skb, unsigned short family,
 				    __be16 flags, __be64 tunnel_id,
diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index 4b1785a8cf112..ad5e9ae28d190 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -211,7 +211,7 @@ struct rtable *udp_tunnel_dst_lookup(struct sk_buff *skb,
 				     struct net_device *dev,
 				     struct net *net, __be32 *saddr,
 				     const struct ip_tunnel_info *info,
-				     u8 protocol, bool use_cache)
+				     bool use_cache)
 {
 #ifdef CONFIG_DST_CACHE
 	struct dst_cache *dst_cache;
@@ -230,7 +230,7 @@ struct rtable *udp_tunnel_dst_lookup(struct sk_buff *skb,
 #endif
 	memset(&fl4, 0, sizeof(fl4));
 	fl4.flowi4_mark = skb->mark;
-	fl4.flowi4_proto = protocol;
+	fl4.flowi4_proto = IPPROTO_UDP;
 	fl4.daddr = info->key.u.ipv4.dst;
 	fl4.saddr = info->key.u.ipv4.src;
 	tos = info->key.tos;
-- 
2.53.0



