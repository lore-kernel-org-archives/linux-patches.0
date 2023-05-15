Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84176FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABF4C4339B;
	Mon, 15 May 2023 16:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169126;
	bh=mu54pJhOjKOJ7r4NOIwIpjAK16d13l+HAmwmvzPDDmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKB8wYH1nsgkQh10wYCwOpxs3idOx/XDYTqrgZ9czTaGLbULa7gLsMCDR+dj+hgQD
	 Xvd/kzps2206x8mHSLMXaMk41rzqAq6H1LBiP2KR4TGn333/uOt8DkPpCVdTKXXwZ0
	 CCvGtyV19qacJsEbUFqwQ99j0r/LNSwD3TGUU9bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palash Oswal <oswalpalash@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Cong Wang <cong.wang@bytedance.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 149/191] sit: update dev->needed_headroom in ipip6_tunnel_bind_dev()
Date: Mon, 15 May 2023 18:26:26 +0200
Message-Id: <20230515161712.833010788@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit c88f8d5cd95fd039cff95d682b8e71100c001df0 ]

When a tunnel device is bound with the underlying device, its
dev->needed_headroom needs to be updated properly. IPv4 tunnels
already do the same in ip_tunnel_bind_dev(). Otherwise we may
not have enough header room for skb, especially after commit
b17f709a2401 ("gue: TX support for using remote checksum offload option").

Fixes: 32b8a8e59c9c ("sit: add IPv4 over IPv4 support")
Reported-by: Palash Oswal <oswalpalash@gmail.com>
Link: https://lore.kernel.org/netdev/CAGyP=7fDcSPKu6nttbGwt7RXzE3uyYxLjCSE97J64pRxJP8jPA@mail.gmail.com/
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/sit.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index df734fe64d10a..ec1de1e6b8e3c 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1053,12 +1053,13 @@ static netdev_tx_t sit_tunnel_xmit(struct sk_buff *skb,
 
 static void ipip6_tunnel_bind_dev(struct net_device *dev)
 {
+	struct ip_tunnel *tunnel = netdev_priv(dev);
+	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 	struct net_device *tdev = NULL;
-	struct ip_tunnel *tunnel;
+	int hlen = LL_MAX_HEADER;
 	const struct iphdr *iph;
 	struct flowi4 fl4;
 
-	tunnel = netdev_priv(dev);
 	iph = &tunnel->parms.iph;
 
 	if (iph->daddr) {
@@ -1081,14 +1082,15 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
 		tdev = __dev_get_by_index(tunnel->net, tunnel->parms.link);
 
 	if (tdev && !netif_is_l3_master(tdev)) {
-		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 		int mtu;
 
 		mtu = tdev->mtu - t_hlen;
 		if (mtu < IPV6_MIN_MTU)
 			mtu = IPV6_MIN_MTU;
 		WRITE_ONCE(dev->mtu, mtu);
+		hlen = tdev->hard_header_len + tdev->needed_headroom;
 	}
+	dev->needed_headroom = t_hlen + hlen;
 }
 
 static void ipip6_tunnel_update(struct ip_tunnel *t, struct ip_tunnel_parm *p,
-- 
2.39.2



