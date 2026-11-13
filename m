Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590183;
	b=YGj/k11eCe4EGG0FafjHe3uyF9fzxqO7hRo+ivCoG3KLnNeTxF7iJ9glKAGUPrePj7QL
	 n+Wx+2HSYeyhJRutKEtmJ5RKU6ww89tziFE72BJF5W+AfpbngfkEKXhDMs+36R2nGDo35
	 etQic1GR1Us0PhD9qd604guZm892xO8TqnwsCYZ49rrAL30cK9AvsovyBLZteBXZkxbim
	 yTJXSF5XokdMCmmE1zAb0BS50/l3OLc5ed1uhg1WAyzlvcPei89d5ZTlji8FOYztUsBJt
	 Ghq6FXXdE4Vb6IfO3c1wVFOKjwVt44Ieh0fKsjy/WXEbjpn90EPBHRHxKTxTwV5dsWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uKjM8+Vawy5qYnzmzE7U0DqD0Mt6EwBSwCYgrlwPlAE=;
	b=HNE8RoKxH2f6x+cl248kpcM27AlNGaR/+SNldpf2otZm/Z1xoGJwLR27R/EOQoZ2HdQp
	 QXYmKBvFhzdyoHYpTcbmLbiJL9B7kd/Ks2HxvZTKz0zyDsZ/Kr4fObNADRGFHeeBootWD
	 aDhYBhTioer02BKjCDx1gsMuVj4fYdyiwqnQmPmog1LnmJR2gaH2lkJWk9d5/mr1V+7T4
	 t6lDXjrTEz0gUqKJSwULCZhN6LhCn9bp9NWa2sgPerVMhMCdPDGw3zYRjuAtW7Jl1BP84
	 gyChSrbRsne0fR8Cu3KaDrsaVe06i8nyfU2GhNhG+bRhVHaGyBsexmpmz7GaC9GW2yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OaplyF6I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F55606B351;
	Fri, 13 Nov 2026 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OaplyF6I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F901F000C6;
	Fri, 13 Nov 2026 17:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590183;
	bh=uKjM8+Vawy5qYnzmzE7U0DqD0Mt6EwBSwCYgrlwPlAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OaplyF6IdYw3LUM5v9+tJd/PynoizGYzDJBzj/ygQz4zFS/nwaANXAauUon20++zh
	 c/zNvzT9l95vdYOVlK98SHZW1Jm+sk82ebFUgoZFFv4ArIDiLdKRtSY89Cz3S29wi8
	 JAVWSAuK3saYdq/zTTqgPoD+fkPyYZmYg6oZO8sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 193/686] xfrm: interface: validate the IP header on xmit
Date: Fri, 13 Nov 2026 10:45:26 -0500
Message-ID: <20261113153827.585359226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qihang <q.h.hack.winter@gmail.com>

[ Upstream commit 86de3a1118a16dbbbe5fabe9aa20ffb93c072ed5 ]

Packets injected into an xfrm interface (e.g. AF_PACKET on an xfrmi
device) reach the xfrm output path without IP header validation, but
xfrm4_transport_output() uses iph->ihl for __skb_pull() and memmove()
and expects the header to be valid.

vti_tunnel_xmit() already calls pskb_inet_may_pull() before handing
packets to the xfrm output path.  Do the same in xfrmi_xmit() and
perform the header checks ip_rcv_core()/ip6_rcv_core() do on entry
to the IP stack: reject wrong IP versions and malformed IPv4 header
lengths.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_interface_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/xfrm/xfrm_interface_core.c b/net/xfrm/xfrm_interface_core.c
index 688306bf62c5a..9835fbe63ccb8 100644
--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
@@ -531,8 +531,13 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	memset(&fl, 0, sizeof(fl));
 
+	if (!pskb_inet_may_pull(skb))
+		goto tx_err;
+
 	switch (skb->protocol) {
 	case htons(ETH_P_IPV6):
+		if (ipv6_hdr(skb)->version != 6)
+			goto tx_err;
 		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 		xfrm_decode_session(dev_net(dev), skb, &fl, AF_INET6);
 		if (!dst) {
@@ -548,6 +553,9 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 		break;
 	case htons(ETH_P_IP):
+		if (ip_hdr(skb)->version != 4 || ip_hdr(skb)->ihl < 5 ||
+		    !pskb_network_may_pull(skb, ip_hdr(skb)->ihl * 4))
+			goto tx_err;
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 		xfrm_decode_session(dev_net(dev), skb, &fl, AF_INET);
 		if (!dst) {
-- 
2.53.0



