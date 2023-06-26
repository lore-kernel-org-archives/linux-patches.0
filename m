Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71AC11CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45406C433C0;
	Mon, 26 Jun 2023 18:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687805146;
	bh=OM6a/IlQykWJ/Mcfc6wtWyvyuVoTz1e/0DbcrUGWN04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vH+Xwb6l46KNl4jlNirSWQWE5F/E1vz8RXgxk1one7lvQbwEAo2bZBGfdhMicxL8G
	 pwe+jJ+K4MsRt92H//1bAMGCAcJjkJyAogGDWfDxhIV7umGCqKe34EiuDWaV4/UHtZ
	 T+SpBv4a16ZWYQh/sXgF17yTq1LsGO3tJo5O0xd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Benedict Wong <benedictwong@google.com>,
	Yan Yan <evitayan@google.com>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Simon Horman <simon.horman@corigine.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/81] xfrm: fix inbound ipv4/udp/esp packets to UDPv6 dualstack sockets
Date: Mon, 26 Jun 2023 20:12:19 +0200
Message-ID: <20230626180745.979497158@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180744.453069285@linuxfoundation.org>
References: <20230626180744.453069285@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maciej Żenczykowski <maze@google.com>

[ Upstream commit 1166a530a84758bb9e6b448fc8c195ed413f5ded ]

Before Linux v5.8 an AF_INET6 SOCK_DGRAM (udp/udplite) socket
with SOL_UDP, UDP_ENCAP, UDP_ENCAP_ESPINUDP{,_NON_IKE} enabled
would just unconditionally use xfrm4_udp_encap_rcv(), afterwards
such a socket would use the newly added xfrm6_udp_encap_rcv()
which only handles IPv6 packets.

Cc: Sabrina Dubroca <sd@queasysnail.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Benedict Wong <benedictwong@google.com>
Cc: Yan Yan <evitayan@google.com>
Fixes: 0146dca70b87 ("xfrm: add support for UDPv6 encapsulation of ESP")
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/xfrm4_input.c | 1 +
 net/ipv6/xfrm6_input.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/xfrm4_input.c b/net/ipv4/xfrm4_input.c
index ad2afeef4f106..eac206a290d05 100644
--- a/net/ipv4/xfrm4_input.c
+++ b/net/ipv4/xfrm4_input.c
@@ -164,6 +164,7 @@ int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
 	kfree_skb(skb);
 	return 0;
 }
+EXPORT_SYMBOL(xfrm4_udp_encap_rcv);
 
 int xfrm4_rcv(struct sk_buff *skb)
 {
diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
index 04cbeefd89828..4907ab241d6be 100644
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -86,6 +86,9 @@ int xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
 	__be32 *udpdata32;
 	__u16 encap_type = up->encap_type;
 
+	if (skb->protocol == htons(ETH_P_IP))
+		return xfrm4_udp_encap_rcv(sk, skb);
+
 	/* if this is not encapsulated socket, then just return now */
 	if (!encap_type)
 		return 1;
-- 
2.39.2



