Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021026;
	b=beKoQWH4ur06BblovOLteQXEhMwjgkbraHS03KiOTYrebi/oVjMCmuvpTgUtGuhPu1gg
	 pSTDqu3fWzjTpkURf/x6rcsVjK68KYWCRHfZ3qw7Dsx2ttXQkjRVU/7WxoBNyyB9HQT4A
	 GCa6v5Qu3LUWsZZBpqsz0Tofhtm9DwWkuRJzxBDUOa7+DFlS92G11XxmRwYHLuswfq2Dj
	 74N/i3+BOGPHeJfjm5PuEXB6gNw2k0Jo4PISRNo0xns8q015x/tB2hCrMUVUAGqn7X9Xs
	 Beh/32GzNOQjAryALxbqyDjGCsgyFyV05Gt/Q8tykm1SyVwbfW6zFslV/42KLaKWQlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aeilLKuOVV6y/lXjApm97YJM+S/j/H1yCqbMpXssSCs=;
	b=KP4zE0B60667xsPJgvskrQbbUpjNL3Sd4JUtA1LXxvFktntY8NnCzGZocbxEMIMz+Skv
	 P5o52KQpiuLpncw5bfn8BVhhl9tk7Pp82zS1nHxWD7+I3UBrJiHtGUUU0iBd/ouowWR+K
	 6Bmh5+xCeVlW+XENwkdZyU1CHg5U0InIC2J/l4tq8AG2b/ZfTKPRndC0X6reFbXepF6Rs
	 5WmoNxy0DJCR8tsPUy83UHzfZDv28X2JdhvRUDF9Ezn81RI14SKaWOl0/cwxn/Z1G9W+f
	 yM03fg/CVTviojvqNrVT2INhIdsb/xyYx9dTa6y1tIiDmnqgDZQIY75uG4M1zjaJTbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i0q9MEKI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D39606A33F;
	Wed, 18 Nov 2026 16:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i0q9MEKI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4851F000CB;
	Wed, 18 Nov 2026 16:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021026;
	bh=aeilLKuOVV6y/lXjApm97YJM+S/j/H1yCqbMpXssSCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i0q9MEKIIIhHHyOnhJu3Q78Idp1iw6CEwngF4MyJqzqr02+mZdSDaMsSCeFXKRp2J
	 klo3t9dRG+stbzooNNfTd1I/BXZh5kOytOfkZSnThEgLqPF4M1fYrYzfR27vgfLYwu
	 jghZ4SqB1Mm0LUKnMr6frg1vlLzhPw9pEXQvZqvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangfeng He <huangya90@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2161/2651] netfilter: flowtable: use the vlan id, not the full tci, in the tuple key
Date: Wed, 18 Nov 2026 15:56:41 +0100
Message-ID: <20261118150403.602390274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c8c29a9a16844..2dec15d402ca1 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -170,14 +170,14 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
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
 		offset += VLAN_HLEN;
 		break;
-- 
2.53.0



