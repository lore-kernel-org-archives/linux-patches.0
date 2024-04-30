Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A585E17592;
	Tue, 30 Apr 2024 11:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476425; cv=none; b=NmpwxTRkDVqjS1ARkb/GyEXwopgVhHWEm+yrzYZ+3XE5nMvsNJ+v4LpNcbQSYNHPPsiaj9I6MACHwBTgj3lJUeLDkTdAJKiXnpJPBysm2BlPUrgQHNDSDXvcdf6l6rRHB2rn4tmkjHf4gTfVLZW+vv1b/rTKrrSNoRxwug1FUQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476425; c=relaxed/simple;
	bh=riD0Ipflld+4oOIp/lVUzr8uAmFLwrzJCi7IDY7BWs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDippjn32y4Iak45cYsYZbxz6FabnYuu6Awmpn87DzbqD/C0MOaPZu/GX99Zde70wA65p3r2d+iAFxq31irt0QcH7ZjvNG0GkNJlwuVwqs23aNwXg2ge+8RT/Civ2O00Z+JV9eIQTGzRuFNW7TqT1/IwTxbktR1QEN3EVjYQHCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFcqbV6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFcqbV6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182D7C2BBFC;
	Tue, 30 Apr 2024 11:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476425;
	bh=riD0Ipflld+4oOIp/lVUzr8uAmFLwrzJCi7IDY7BWs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFcqbV6QwHtMtQf8G6TyV2gdF1kc6sbAWFYo4OcB/IT/C/Nqw7gvX0MysjKt/O3rN
	 xHQgKy+oP883HkHfephhMuKcBiXNhWfHbbv4WjtgBU9Ojf0bDBhGZ5DJkDHap4kM7H
	 Vx3MRq03XffFsvYr+K+H87Qh+Kwg2uNm8xQ+5n3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Andreas Roeseler <andreas.a.roeseler@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/110] icmp: prevent possible NULL dereferences from icmp_build_probe()
Date: Tue, 30 Apr 2024 12:39:57 +0200
Message-ID: <20240430103048.399995455@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

[ Upstream commit c58e88d49097bd12dfcfef4f075b43f5d5830941 ]

First problem is a double call to __in_dev_get_rcu(), because
the second one could return NULL.

if (__in_dev_get_rcu(dev) && __in_dev_get_rcu(dev)->ifa_list)

Second problem is a read from dev->ip6_ptr with no NULL check:

if (!list_empty(&rcu_dereference(dev->ip6_ptr)->addr_list))

Use the correct RCU API to fix these.

v2: add missing include <net/addrconf.h>

Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Andreas Roeseler <andreas.a.roeseler@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 2b09ef70752f9..31051b327e53c 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -92,6 +92,7 @@
 #include <net/inet_common.h>
 #include <net/ip_fib.h>
 #include <net/l3mdev.h>
+#include <net/addrconf.h>
 
 /*
  *	Build xmit assembly blocks
@@ -1029,6 +1030,8 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 	struct icmp_ext_hdr *ext_hdr, _ext_hdr;
 	struct icmp_ext_echo_iio *iio, _iio;
 	struct net *net = dev_net(skb->dev);
+	struct inet6_dev *in6_dev;
+	struct in_device *in_dev;
 	struct net_device *dev;
 	char buff[IFNAMSIZ];
 	u16 ident_len;
@@ -1112,10 +1115,15 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 	/* Fill bits in reply message */
 	if (dev->flags & IFF_UP)
 		status |= ICMP_EXT_ECHOREPLY_ACTIVE;
-	if (__in_dev_get_rcu(dev) && __in_dev_get_rcu(dev)->ifa_list)
+
+	in_dev = __in_dev_get_rcu(dev);
+	if (in_dev && rcu_access_pointer(in_dev->ifa_list))
 		status |= ICMP_EXT_ECHOREPLY_IPV4;
-	if (!list_empty(&rcu_dereference(dev->ip6_ptr)->addr_list))
+
+	in6_dev = __in6_dev_get(dev);
+	if (in6_dev && !list_empty(&in6_dev->addr_list))
 		status |= ICMP_EXT_ECHOREPLY_IPV6;
+
 	dev_put(dev);
 	icmphdr->un.echo.sequence |= htons(status);
 	return true;
-- 
2.43.0



