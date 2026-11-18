Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032434;
	b=iTeSIgwvLafBYUjKaMbcdpUhs0/EVFb9bkudkyLRU478+WZq9vUcXrwwT4iPAbBg6djN
	 nZ2GoSFZIhZslzomA41Zw0dpnBOOitwqC5xD3djO3jpW3xStSHFlJwnqrYzMR3oMEyyRa
	 5tXqfu3B93UEnkZAHZeVof84HNHAFxY5vXgJ+oXIGAZA0vbJB4qtxUxbRxsFy1TqEqz5W
	 YE7CwCZ0cC/Hsi4RmbjElzzpnDdhO9uR8UusZzSix4w8O7YL7TYW/hDp+0854TM7azyTV
	 SM0eEGWVAJtHcPJpzHdTDITdQxBk2+ZIuFVLwh/SgYxlfOrVoU7wuri6hgcgxFnyJXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8DYX227rAl0S2jAEtD9QAzY3TC/CU5xFwsMMmuU4jOM=;
	b=TCmuAw80+ZKzKea/47RI+AvzM6ar7D4tdcydbxXOwjwY8IOC4My+PAfQvh5wJXn9Ph9E
	 5DU7nY5t5rK2e7m9NHQhaElOmRQXEcJIDPBreD79iDnwCseGTmiaRJZO6QATjyPjVdp82
	 a/0O67uAcfhbarqzXS4Mw69iCjXtLI32v7o494rSVdJxYRkBhlQ8bQiK7VCPJLTQTaKUW
	 cTvrOiX62u1s+rKgZMpnWu0XdyBNJUOIdgHBGBNU3b4nDtYF2fj8KuuzBEVIyiirk8xDw
	 dDZNYA2Xtm8pTTFgwPJs6vuS3YmOYYuZ7OdHSDnF/un+AP1FxE5+eitBwF1nx0nxg/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XHr/Uwnv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAB6606CB1D;
	Wed, 18 Nov 2026 20:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XHr/Uwnv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86C71F000C4;
	Wed, 18 Nov 2026 20:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032434;
	bh=8DYX227rAl0S2jAEtD9QAzY3TC/CU5xFwsMMmuU4jOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XHr/UwnvhioeWeHIkeZoGbuhrUZVWLtECND7tQXYkLFIrB09L5oGQ9LkxDbIXmBGf
	 gruC5K0ovx3YAS4+EOH67Rlx8VayIRVVZ3Hu9Wrb3fB1W4ZLZ2AdCVxdsDMb/g8IT0
	 82CBrFmQlDMfBlL0nqrRb77OE5HndNClg+peGE2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangfeng He <huangya90@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1409/1756] netfilter: flowtable: use the vlan id, not the full tci, in the tuple key
Date: Wed, 18 Nov 2026 15:58:56 +0100
Message-ID: <20261118150105.300764406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 617f3cb81af11..1855ee828421f 100644
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



