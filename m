Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050280;
	b=VX8v/KMxVUBWMukrXhz3ejreV5d6uA/Vjsr1ZDZUuqYd4/0gXa7kMC+Z8+cgdJuypFbp
	 weejy7iJcvHcKJHzXD2wY+uV9qKw9JF9hoDYBofrcOn5xnMKqpcM66ES4L25uYJ/xwkF7
	 9WoveTMfVwdacp+HrlkqJ+vQdl/9e2sebDE7Fa4ul7th8g1ozi62/GX4zAulfrX05IV3O
	 zL0+EN41yKZdNGLxhrw2Sti5K64LzITF+89m7RqUeBTyd5oURxXUp1/KeF1ZglvWh2qT9
	 ZN2XFEAu8ZyCipF4pTjOR58Axy1pUgBmTyFNsNSKOYccqlu0YN3Nr8lnSUgjxTOcpSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CyOXv13GDrZLv8ep9nihNKTc0KbKP60vrkN2gCY/GVI=;
	b=dMyegy8XMOZmmLMJO2b+c6FnaPa+I303Y6vsE7It3jNM0xkC7MzZI8FHGkPxPEr/Btp7
	 z0VKMicQ2jqhdYf9Y1ZE6m+OH9sV4rOaPu/qRxAlTPNxAjS+x3anQidtwnUvsUPvkgdbN
	 nqjx5kHyv9uM+C2LKSCUX2oPa5YzfQM28xS73zQCSWav7wS1wa7jsFdVBDk0ZdNdVOwNp
	 CCH9NH70TEOXisqHo+ygbzzIpNHz/nQZ8KAIRZdEH6uBHCUG3NJGgLPn54FhYg8OYV6l1
	 KxrCR1VhOuHRwK+0mo/jD892RSWRkYRxuy+e4FZOR1Wphyp1k9e9urAeBK4FtgMdZZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YQDySEB8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF5A606A32A;
	Thu, 19 Nov 2026 01:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YQDySEB8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051721F000C5;
	Thu, 19 Nov 2026 01:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050280;
	bh=CyOXv13GDrZLv8ep9nihNKTc0KbKP60vrkN2gCY/GVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YQDySEB8RPzyjXDR8zMNLohF0o6mqxNOtgSzQKll/54cLvAH6cAFWiqCktJitILvV
	 nVZmWDv6VRwDKFwTwyTezVEE3cF8x8+Uc9KxtZSg8tcAqOvPZ8i62LN53v61OODS2Q
	 UB+ZPm3cdzMF9o0/ZffUfFVymuBA7XI1u9yPFymw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangfeng He <huangya90@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2625/2857] netfilter: flowtable: use the vlan id, not the full tci, in the tuple key
Date: Wed, 18 Nov 2026 16:00:59 +0100
Message-ID: <20261118150336.084585983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cd744ac065cd0..92c7ef1f0052b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -145,14 +145,14 @@ static void nf_flow_tuple_encap(struct sk_buff *skb,
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



