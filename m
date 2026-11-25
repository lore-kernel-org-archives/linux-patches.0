Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624251;
	b=IxX7dzNrsE0h00gn8j3dy9JPuy28ZA9bfRDskKhfhorf5hH+Lellt3XXXW4K/emExdJn
	 dwspdYX/G9UKaOGsQPwRmLCmDTwEz7G9sxmuEBlo+rEkecU71/9TaeEkTu+OSq/JI0Q0p
	 VC9GmljKXA0ho5WQVsfJIrXWj0XUzwtiOjJaFyqCPW7wdlNu7+LoZlUWAvfaOGNkQNNEI
	 NfSmfwSvee/z8+dFwOuZ55iqg5prO/+ICNWMpHOi4L47/rjFDiDmGGCTiXhgOm2vGiMWZ
	 asyrnNKSxzd7UHZgZo62Sl/rA7o4ILkElbiidxZnEGFgwfJVTf27u1wA6cTOonvvvHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nH28SsTyuaQUaw7YFoVOToNvzy3G13MkB1hx8itxsSk=;
	b=N8Jp0p3tpMujjbxdA6F3KTmiUTOfcHTBaNnUTVDIxZXZc55Qf03LAGsMTZt+eVgLnHer
	 NFweS67dmhuMjYYKP6qaB0gBMxDVjLrHoBwlQHkIVqpy0YqxzD3vnff1bs78Jllc6g23z
	 GIw4hxIAx0hmq2F+OW2mkCxD6atLt0PmGXeQP2g4RyHKjijiuh/3ZQ3eiGQmo29ug3oxo
	 IUqx7+2gPWM1ni39GSQ6TZpRzRhJ9UEqz63yhY/6BnEBbuaA7mWTn+Z2jpbmOv9INQm/l
	 JM644MZvDBZ6l4a2uNQ96MXVcb1/QanbzwU2F5H19JK6bjV55hnvzeuG2x5eWyTCyUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h1mtsiz0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F447606A330;
	Wed, 25 Nov 2026 16:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h1mtsiz0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A071F000C6;
	Wed, 25 Nov 2026 16:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624251;
	bh=nH28SsTyuaQUaw7YFoVOToNvzy3G13MkB1hx8itxsSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h1mtsiz0myuMhAcQyhqDpI4oUJSMh93dZTrzUp/KCDNsn/gFjArgASAUIWmlDyuC/
	 VfeuF9LUokTca8QrvBALZYnlc1Kj0f6G0UUZLiURHRA3dm0C64eLMpDvJpFIdbku6m
	 Aeij9FeQvigTZRocltf9o8IuJH8bPHegoUPmGG+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/816] netfilter: nft_fwd_netdev: add device and headroom validate with neigh forwarding
Date: Wed, 25 Nov 2026 15:27:15 +0100
Message-ID: <20261125143851.235498963@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 0a0b35f0bf10b4c2be607465f5c9c12c8681305b ]

The ttl field has been decremented already and evaluation of this rule
would proceed, just drop this packet instead if there is no destination
device to forwards this packet. This is exactly what nf_dup already does
in this case.

Moreover, check for headroom and call skb_expand_head() like in the IP
output path to ensure there is sufficient headroom when forwarding this
via neigh_xmit().

Fixes: d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: d6c18cadfc6c ("netfilter: nft_reject: prevent unbounded recursion in output hooks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_fwd_netdev.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 4bce36c3a6a07..8468bed3e87d2 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -101,6 +101,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	unsigned int verdict = NF_STOLEN;
 	struct sk_buff *skb = pkt->skb;
 	struct net_device *dev;
+	unsigned int hh_len;
 	int neigh_table;
 
 	switch (priv->nfproto) {
@@ -152,8 +153,19 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	}
 
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
-	if (dev == NULL)
-		return;
+	if (dev == NULL) {
+		verdict = NF_DROP;
+		goto out;
+	}
+
+	hh_len = LL_RESERVED_SPACE(dev);
+	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
+		skb = skb_expand_head(skb, hh_len);
+		if (!skb) {
+			verdict = NF_STOLEN;
+			goto out;
+		}
+	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-- 
2.53.0



