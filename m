Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7080B5FDD2;
	Tue, 14 May 2024 11:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686874; cv=none; b=VlkCXWYTF6MuI4oeeFsx3NwKXZ5zj5yPs2Ch3bhI49U/xyjFw8J43ItADH50fNH/o5pQ2qiRLtOzZbXJf0tLmcU2xwgUHswmEjaKzhtIhiJ80HSLfkVSeX2zQi9ypeC3grX23/0a2wm85fHdLuk9iY95tcIH7xlBKhhPc2QQ1mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686874; c=relaxed/simple;
	bh=7ToX8QbRouw9PCR7FDs8TgSMEU7E+DJcL7o4/bpj0qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zh1oSv0rdhlWdFw5E7a+Kyge1ypcm3Vj2C+gQJsuY5B06FBYHAPM/41gCbvjkMELODU7JzkYCHrRNtsjLK832CWAM39Hl5yybodTmoCJnu4oaanaCYasDCLtJCz0vei+xyZTCjqa+XFPZXE+DEvFjYHl8hhxu031m/JuyEj0UOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkVT23Ex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkVT23Ex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1BDC2BD10;
	Tue, 14 May 2024 11:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686874;
	bh=7ToX8QbRouw9PCR7FDs8TgSMEU7E+DJcL7o4/bpj0qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkVT23ExSic60dnXTC8RC82pl7YJzqqM4+GqTdHjKO/WgTHS8aaH8DzSIjZd5YRyo
	 Bqlmn8rlrcWNjbcKTCUvWrPGkNiqlX3W9XO/dsW4ai5o3set044RsjPTx9PYClCFmU
	 HXsSKmTYatfLOVizOsQPfzwaUuNNVQ/iLO1DfcQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Paolo Abeni <pabeni@redhat.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/63] net: bridge: fix multicast-to-unicast with fraglist GSO
Date: Tue, 14 May 2024 12:19:41 +0200
Message-ID: <20240514100948.779612200@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 59c878cbcdd80ed39315573b3511d0acfd3501b5 ]

Calling skb_copy on a SKB_GSO_FRAGLIST skb is not valid, since it returns
an invalid linearized skb. This code only needs to change the ethernet
header, so pskb_copy is the right function to call here.

Fixes: 6db6f0eae605 ("bridge: multicast to unicast")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_forward.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index c07a47d65c398..fc2ebd732098f 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -259,7 +259,7 @@ static void maybe_deliver_addr(struct net_bridge_port *p, struct sk_buff *skb,
 	if (skb->dev == p->dev && ether_addr_equal(src, addr))
 		return;
 
-	skb = skb_copy(skb, GFP_ATOMIC);
+	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (!skb) {
 		DEV_STATS_INC(dev, tx_dropped);
 		return;
-- 
2.43.0



