Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042086;
	b=BRgexgZ+6K7bMCzWqX26tKx5gYoS+6+iz2Mp+YkhZL5V6jPQJhaODl5bmkMtLJsAD4Mv
	 QQ6gZGb1eoOvew7yQWelUxnhZjXBzk6YiwIkvjQbd8PaNhinSUUl2PqBuwiA3xVNTfC8I
	 YtnNKY0oT2eTuEVJmtRyEA6RsYvM9wNFtMR6F3M9SkT/xRUsqgdHy7F1Lbvf/1yOLMWy5
	 h28MEL3adWwQ1dy/veJmfvFnnYlG4FO2xUZhBf9cfpqJy+pvaCAxh2fo7b7v/dnoOHHrn
	 bCUPNOkRVrZ2FVLxR7+gDVm6nqUR+e04v/kAh6RrF2Zdl9uaFTVh3Jpj7xqGY7xkmsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CNMqdxIv+SdlgO/3441AxtVZOUsL0AWGhViq0NdDXbg=;
	b=b7He/7LXWynDkcwqlW2we4p9c9iNJYbUI4IzS7d9TWDGwr4BAX9a/230u6/KGZ17zD7S
	 SSaBzoeEfZCPunKRSZ19yQTMOBV3Fvh0y3F1cDXgpzmLplGeWliietyBBRfXZU1c/lbQM
	 qUYmfqVV0UF9MkmtuCDNNl0O6K2nXv9+Wc3NWHpoVweI6wzJIvFz5ymXxCYvMbX1AmcUB
	 MQ2Bg0/8d++6quVe5/b++8DlAByevLN+emPPQGqtca02LBk9tj/9ZwM2sn4vBYHpVf4Pu
	 zqybn5WYiU9/Nq3J/ffoXoPigUYr/T+D7eeZT7ghOiAB3FQP/AOBJ4AlZBAplCH445w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KX4hXZ5F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265DB606A325;
	Wed, 18 Nov 2026 22:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KX4hXZ5F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DDD1F000C7;
	Wed, 18 Nov 2026 22:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042086;
	bh=CNMqdxIv+SdlgO/3441AxtVZOUsL0AWGhViq0NdDXbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KX4hXZ5F7UW8EI8neXdkt7Dm6JsO5pDE9f/vu9DvLo8ipZn1adEeU1ZmG+l6yduW5
	 n5BM8eCLlyYJ+d7OJ+4IdhtAiY664D4oFiC/M/9LQdpKlnMzFAP2AFYMhMjno5iTAB
	 25tf+SaRym2xgsg0XXB9HvEt94muElU5slnBel1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangfeng He <huangya90@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3045/3318] netfilter: flowtable: use the vlan id, not the full tci, in the tuple key
Date: Wed, 18 Nov 2026 16:01:07 +0100
Message-ID: <20261118150451.508736467@linuxfoundation.org>
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

From: Shuangfeng He <huangya90@gmail.com>

[ Upstream commit c203ecf905745d979de5df28fa657121f2e9342d ]

nf_flow_tuple_encap() stores the skb vlan tag in the encap tuple id
using skb_vlan_tag_get(), which returns the unmasked TCI including
the 3 PCP priority bits. The flowtable entry, however, is programmed
by nf_dev_path_info() with vlan_dev_vlan_id(), a plain 12-bit VID.

When a NIC delivers RX vlan offload skbs with a non-zero priority
(an RTL9617C EPON ONU was observed handing over vid 818 skbs with
tci 0x6332, PCP 3), the runtime lookup key never matches the
programmed entry, so every packet misses the flow table and
software flow offload is silently defeated.

Mask both parse sites to the 12-bit VID so the lookup key matches
for any priority. The in-header variant has the same problem for
frames received with PCP != 0 on a non-offload path.

The egress side is unaffected: nf_flow_encap_push() restores tags
from the programmed tuple id, which never carried priority bits.

Measured on an RTL9617C ONU (PPPoE over VLAN 818 WAN, NATed 6-flow
download over a 1G EPON line), before -> after:

  download throughput      377 Mbps -> 936 Mbps
  CPU0 %soft at that rate    91.5%  ->  70.9%

Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Signed-off-by: Shuangfeng He <huangya90@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 24f1e6917d4ac..9ca4c96b30d0e 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -146,14 +146,14 @@ static void nf_flow_tuple_encap(struct sk_buff *skb,
 	int i = 0;
 
 	if (skb_vlan_tag_present(skb)) {
-		tuple->encap[i].id = skb_vlan_tag_get(skb);
+		tuple->encap[i].id = skb_vlan_tag_get_id(skb);
 		tuple->encap[i].proto = skb->vlan_proto;
 		i++;
 	}
 	switch (skb->protocol) {
 	case htons(ETH_P_8021Q):
 		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
-		tuple->encap[i].id = ntohs(veth->h_vlan_TCI);
+		tuple->encap[i].id = ntohs(veth->h_vlan_TCI) & VLAN_VID_MASK;
 		tuple->encap[i].proto = skb->protocol;
 		break;
 	case htons(ETH_P_PPP_SES):
-- 
2.53.0



