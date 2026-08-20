Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D57A46D091;
	Thu, 20 Aug 2026 16:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243881; cv=none; b=kR3zZ3/G0rSaHEEGgAyHSqk2JMCc8yFy3qSU81njyLJQENSTi7keELF1VoBgvNiZJOl4zmmtuyroV4WWMgNKcj+zga5oDvg8Bban8RTJpo1dIvLNTwZ5Ew41lBs/c2Urp6w6DXuWiDfzNOSh3uDScaLCRym+E1IGv3PNKx/I5gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243881; c=relaxed/simple;
	bh=dSNvnEXz+Q3FH16EYEFIiBT124KBd3EZ4b8YrSyM3Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOe+Yew1GSX3N1A8RQhcrS2IoWmqhJ2x8NvR/TdOmGRdYBHDJnyi2PnPmXJ4srZt9JlfOJroBlHFxMTENTwQrNXvAu+YdNEX8yYnPL/fIHcXx0OnmHbynrDYmEwX2krlLGMKx0ergWNcAevTOfG6YtZov/Anfr1YYA7Cp2Mwn+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yY3vCAh9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yY3vCAh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EBC1F000E9;
	Thu, 20 Aug 2026 16:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243880;
	bh=t0NamajZAUFb7wAR0GwzTGu6Tqy9+qdn5pvMHCteOrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yY3vCAh9CcGR8rdXc54HtN87SFpFWnG5tq/9I5b4clyuSEqxZR8LDtYnYxoQY6nOM
	 lvzom1uXBrNOntuj8awtFwD0puTt7uOHddtMK8pfuulsgsltXMUamUqot2MtOL0gsa
	 bnE1a755YRm6/KAWg7nNTPdMm3oSK9zdYmheXDSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 249/272] net: add a couple of helpers for iph tot_len
Date: Thu, 20 Aug 2026 16:57:13 +0200
Message-ID: <20260820145239.093993051@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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
Stable-dep-of: 8a7ed561671a ("net/sched: act_ct: fix sk_buff leak when the header checks reject a packet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ip.h  |   21 +++++++++++++++++++++
 include/net/route.h |    3 ---
 2 files changed, 21 insertions(+), 3 deletions(-)

--- a/include/linux/ip.h
+++ b/include/linux/ip.h
@@ -35,4 +35,25 @@ static inline unsigned int ip_transport_
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


