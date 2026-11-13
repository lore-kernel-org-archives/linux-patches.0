Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591013;
	b=p6Rcuk/twtjeTAQRQsJoiULIrcoJPEaEze5Mdqxtd002PCL5X0HFPwSsJyWhIEFEflKA
	 tKqSDJfSZ+XeA16HO3Gviei3J3akhKLruXr51hrskiRPBuYwpFMc4aUrqJtZkSGTZU7lq
	 DBReYv3ms5NutR0e45WDoCqx1B9PuQLwf5NS3v+iUHdRaN4sriH40rp5PAHbH0bdTeaZ9
	 PdJuy7Za5dEGzRNBpqLd3wyfmaADYyxFR7yysH2wy6kTkWFbn+Z5exhlLbVNiz9b3gWVl
	 Hu9NhpynlFuyj/zksfn7UXP0uOtoOSEQloiTtPKKu5FIaRn8amj5D4IBOHFkUEvprXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wm2kg828UxSgnnb+BawMJ5EkqXc7fIDac9NprPbOyeI=;
	b=D0PCJL8rWXSkN3Mg5DBq7jr9PGR7fnVdtu5+C3GIH5yrzwid436lGTPHh6Ld06N8iQ/L
	 KjRTx9HFR1w1KQATCj0kAE1yJgNKhuE8kTxgAiQjVGubt9todTJpbNCvP9Us6enLpZlKY
	 BxBxLvtTy3qkrev9cuFetG09W3venfkzn41GlKRExCjMw5ChAsAAzYtYalDluC5RAKo/M
	 a0U5pgDcGURzFYZ2w8+Z/bl18B8zf6ZaL3CZWKPUBOVCbf4Bp6wyXzzFC2/8xatM2JfYl
	 4DiEauffqQJEvoYHnYenM/KU9o8j++Yh7oazbuw5YUfYqVMn+2aYVCXuMfncF1egpxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z3CIgebE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8996070F1A;
	Fri, 13 Nov 2026 17:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z3CIgebE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870E41F000C5;
	Fri, 13 Nov 2026 17:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591013;
	bh=wm2kg828UxSgnnb+BawMJ5EkqXc7fIDac9NprPbOyeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z3CIgebEd4zI+sv2gxcFMzLoBUKDcrML0b7C+swfn67mqyOGo6l8tSqYm3OOpu6gI
	 K1NmffKgR8RPh2mfsqw10cw4sEbcwpqz4n2a2IEdFqgykuxnto7WXD1oOzcWGccPvN
	 7k5/m6CBtNGRAwB/1pvRjagLh0p97gV1Ib3hobG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/670] xfrm: interface: validate the IP header on xmit
Date: Fri, 13 Nov 2026 10:45:46 -0500
Message-ID: <20261113153818.198564486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index be0000448af2d..2ff96577ff722 100644
--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
@@ -532,8 +532,13 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 
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
@@ -549,6 +554,9 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
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



