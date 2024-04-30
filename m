Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA0812C46D;
	Tue, 30 Apr 2024 10:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474098; cv=none; b=bTbv5CLUxbuEYaZjVXMdDEaUH0tat6xJtNNRuhp5N81+s6fld87Oy98Pzam7EBdGkWRU6TCNi8MlMzQ1l9uqD/qa21ml5y8zXLhiw1YDGaEaaYsFXeHQ3ZrgjP8HK52+jC75EkpSd+tPq8vdK77jpT8H83jIzJ9Y50vDfjXhCBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474098; c=relaxed/simple;
	bh=yMEyGiC/x+RUPERPO36/JkDbZfUYRUFGe7JcHoTLQtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnb7ZEn6QNqoV2H4fofc+vdg2phdQ1yI4Fqn6/TwkL/VwZieVcrt+Dk5TmRj+m3iPtKP9BEnHdoaqTkKznvT2KbFQ/p3DVruApTca1lvSuY44sQZkwdffvXaovJPby4eZiG6YO4jhCEPjqcefdbaZ5XT0wbKWyytIVStYRS8n6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6b7hq6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6b7hq6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBB4C2BBFC;
	Tue, 30 Apr 2024 10:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474098;
	bh=yMEyGiC/x+RUPERPO36/JkDbZfUYRUFGe7JcHoTLQtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6b7hq6cjOvL7XuuJNglONv13A7C8krIPPxuwOejRZ/UOSvX2pQlBNa2711pL/bqf
	 eh9o02nlCR+NqjWCQgbTyDQPyi7mb8vZiGhIXTy1hblbdjUPF9STIGVuiawXmZriYq
	 0KPhCe+k7UR581qZ7RNxMyWqAnv7Woyvf2ecfyNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Andreas Roeseler <andreas.a.roeseler@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 055/228] icmp: prevent possible NULL dereferences from icmp_build_probe()
Date: Tue, 30 Apr 2024 12:37:13 +0200
Message-ID: <20240430103105.398919888@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index e63a3bf996176..437e782b9663b 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -92,6 +92,7 @@
 #include <net/inet_common.h>
 #include <net/ip_fib.h>
 #include <net/l3mdev.h>
+#include <net/addrconf.h>
 
 /*
  *	Build xmit assembly blocks
@@ -1032,6 +1033,8 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 	struct icmp_ext_hdr *ext_hdr, _ext_hdr;
 	struct icmp_ext_echo_iio *iio, _iio;
 	struct net *net = dev_net(skb->dev);
+	struct inet6_dev *in6_dev;
+	struct in_device *in_dev;
 	struct net_device *dev;
 	char buff[IFNAMSIZ];
 	u16 ident_len;
@@ -1115,10 +1118,15 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
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



