Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80498F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8A5C433C7;
	Sun, 16 Jul 2023 20:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540742;
	bh=kbDGWP2ZXHuYkKQqkVxxI7pRF3pOIz3fYnqNxAVKJAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEOPji0NiJp4jmWGrgQePM8rsLNtf1M5+OUDEjxusQRczgbJTY2EjyLiWj3TfpPP1
	 0pV+CbxERFPlG61RSjEkTmuszLNVg7ozTqu+pZahElilOPz2eqqT1IqJPbhPoOoPc5
	 yBd6FuG+jK9qwIArtESKns/mWcW2syMk7d15ovwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 472/591] net: add a couple of helpers for iph tot_len
Date: Sun, 16 Jul 2023 21:50:11 +0200
Message-ID: <20230716194936.119371762@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 058a8f7f73aae1cc22b53fcefec031b9e391b54d ]

This patch adds three APIs to replace the iph->tot_len setting
and getting in all places where IPv4 BIG TCP packets may reach,
they will be used in the following patches.

Note that iph_totlen() will be used when iph is not in linear
data of the skb.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b2dc32dcba08 ("net/sched: act_ipt: add sanity checks on skb before calling target")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ip.h  | 21 +++++++++++++++++++++
 include/net/route.h |  3 ---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/linux/ip.h b/include/linux/ip.h
index 3d9c6750af627..d11c25f5030a0 100644
--- a/include/linux/ip.h
+++ b/include/linux/ip.h
@@ -35,4 +35,25 @@ static inline unsigned int ip_transport_len(const struct sk_buff *skb)
 {
 	return ntohs(ip_hdr(skb)->tot_len) - skb_network_header_len(skb);
 }
+
+static inline unsigned int iph_totlen(const struct sk_buff *skb, const struct iphdr *iph)
+{
+	u32 len = ntohs(iph->tot_len);
+
+	return (len || !skb_is_gso(skb) || !skb_is_gso_tcp(skb)) ?
+	       len : skb->len - skb_network_offset(skb);
+}
+
+static inline unsigned int skb_ip_totlen(const struct sk_buff *skb)
+{
+	return iph_totlen(skb, ip_hdr(skb));
+}
+
+/* IPv4 datagram length is stored into 16bit field (tot_len) */
+#define IP_MAX_MTU	0xFFFFU
+
+static inline void iph_set_totlen(struct iphdr *iph, unsigned int len)
+{
+	iph->tot_len = len <= IP_MAX_MTU ? htons(len) : 0;
+}
 #endif	/* _LINUX_IP_H */
diff --git a/include/net/route.h b/include/net/route.h
index 6e92dd5bcd613..fe00b0a2e4759 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -35,9 +35,6 @@
 #include <linux/cache.h>
 #include <linux/security.h>
 
-/* IPv4 datagram length is stored into 16bit field (tot_len) */
-#define IP_MAX_MTU	0xFFFFU
-
 #define RTO_ONLINK	0x01
 
 #define RT_CONN_FLAGS(sk)   (RT_TOS(inet_sk(sk)->tos) | sock_flag(sk, SOCK_LOCALROUTE))
-- 
2.39.2



