Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037457;
	b=XfkbFzhm2xmiXf/UkP+0V5adlZaA2AEdZFF0oLvl4Xqk1HsO2Lj5m1+VntjMP8S4bjLt
	 VWPT1aMPnsbZKld1Eg4k2LLiJAkB2YTNoXh0xlgvXWDP0w0QnzEps+MjxPojNSiuaFYka
	 Tbjocbisceirueu6zuTWp1kG/YmXDpMpVzrA665bcBRBbtWEOSMgb7sviVBEXyAhCiScJ
	 DKwBFjzHvecrkKjwoAvx9NkxkfpgBfkyqRwI3dS5n0HxcNpkyqME1aH4eXkjJwYX8dB8T
	 6JwJqqm8iH5nnQIJGDbjLiZXC88ZAWrqJzadLTXbGu5v87xwbUMyPJGPypZzyd/64JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kxFkQz4qRHRKYFArIIWPD0UFNIoOqCno1lVozna1NrU=;
	b=Q10/1MghvbKNasslljX93sJXYYbrcNW88IiRdVBMb0kvUpxE0q5WMKPHLUfSowX/GCot
	 sejEECerWLr4ysALXTJOaN4exe2tZ7OEXX+27ia0svk5rjiOvhvZSl7X0PTVuJ40+oI28
	 4bEffDqwKaovnp6B7uUPPU56pnIpTEDU/9fxPIRgafPDC+Fa1lUGIRK+SPe+ltQhcip3G
	 wAGpY11ePCIURGoBt+JpNLgppmoxtU9Gw07WR7mPS3UIpjOigPa79BYRJxfAdwsQrabfL
	 MejHfP2Yp0hjbwmxNtsVGtSIolZ7FCCHFrXzsqUSYVkZbz2qKN2sJSKSxS/jZLCPq+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ihoAz/Hp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD8A606A320;
	Wed, 18 Nov 2026 21:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ihoAz/Hp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374BF1F000C4;
	Wed, 18 Nov 2026 21:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037456;
	bh=kxFkQz4qRHRKYFArIIWPD0UFNIoOqCno1lVozna1NrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihoAz/HpISYRmEewHk2ZAPPNqDMWcEjpOHHMMmFelcrQ1heQ7VrKUdlWJaVTkNkfs
	 NjodZ1ZmxCfi8/SjIGIY/w6D/940F3zovCFomK+mbEXEqUm6XRdE97SbJibJYJ524m
	 nAdPfoxI5V1GEeBHdULsx24wNveW3FERG5NSiWkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1405/3318] xfrm: interface: validate the IP header on xmit
Date: Wed, 18 Nov 2026 15:33:47 +0100
Message-ID: <20261118150402.777913532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 77a58f2626931..0802568c8be31 100644
--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
@@ -533,8 +533,13 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	memset(&fl, 0, sizeof(fl));
 
+	if (!pskb_inet_may_pull(skb))
+		goto tx_err;
+
 	switch (skb->protocol) {
 	case htons(ETH_P_IPV6):
+		if (ipv6_hdr(skb)->version != 6)
+			goto tx_err;
 		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 		xfrm_decode_session(skb, &fl, AF_INET6);
 		if (!dst) {
@@ -550,6 +555,9 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 		break;
 	case htons(ETH_P_IP):
+		if (ip_hdr(skb)->version != 4 || ip_hdr(skb)->ihl < 5 ||
+		    !pskb_network_may_pull(skb, ip_hdr(skb)->ihl * 4))
+			goto tx_err;
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 		xfrm_decode_session(skb, &fl, AF_INET);
 		if (!dst) {
-- 
2.53.0



