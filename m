Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D4B7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372B1C433D2;
	Mon, 24 Apr 2023 13:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342927;
	bh=Gadg1iat9VLmHYn+h68EtNB4y+3sLXhHCqc0ifXDo94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6fax0ECqrdRxonD8CLjBKlb2lRr2jNKZx4D8T+VtPkbPM9T66i95qhKEFrbPbQoN
	 NeGi/fvdFjRHp/dFnYwnNRcpo0KANaejDsOBzzTbsFRLtL3arnkcHhskldELHaCrMz
	 ePlxtXTqwmx3ogxD3/hnQL3qRw6GWvuuVBkWGjfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	Farid BENAMROUCHE <fariouche@yahoo.fr>
Subject: [PATCH 6.2 012/110] netfilter: br_netfilter: fix recent physdev match breakage
Date: Mon, 24 Apr 2023 15:16:34 +0200
Message-Id: <20230424131136.584412315@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 94623f579ce338b5fa61b5acaa5beb8aa657fb9e ]

Recent attempt to ensure PREROUTING hook is executed again when a
decrypted ipsec packet received on a bridge passes through the network
stack a second time broke the physdev match in INPUT hook.

We can't discard the nf_bridge info strct from sabotage_in hook, as
this is needed by the physdev match.

Keep the struct around and handle this with another conditional instead.

Fixes: 2b272bb558f1 ("netfilter: br_netfilter: disable sabotage_in hook after first suppression")
Reported-and-tested-by: Farid BENAMROUCHE <fariouche@yahoo.fr>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h          |  1 +
 net/bridge/br_netfilter_hooks.c | 17 +++++++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4c8492401a101..c75cb13bb1b13 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -291,6 +291,7 @@ struct nf_bridge_info {
 	u8			pkt_otherhost:1;
 	u8			in_prerouting:1;
 	u8			bridged_dnat:1;
+	u8			sabotage_in_done:1;
 	__u16			frag_max_size;
 	struct net_device	*physindev;
 
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 9554abcfd5b4e..812bd7e1750b6 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -868,12 +868,17 @@ static unsigned int ip_sabotage_in(void *priv,
 {
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 
-	if (nf_bridge && !nf_bridge->in_prerouting &&
-	    !netif_is_l3_master(skb->dev) &&
-	    !netif_is_l3_slave(skb->dev)) {
-		nf_bridge_info_free(skb);
-		state->okfn(state->net, state->sk, skb);
-		return NF_STOLEN;
+	if (nf_bridge) {
+		if (nf_bridge->sabotage_in_done)
+			return NF_ACCEPT;
+
+		if (!nf_bridge->in_prerouting &&
+		    !netif_is_l3_master(skb->dev) &&
+		    !netif_is_l3_slave(skb->dev)) {
+			nf_bridge->sabotage_in_done = 1;
+			state->okfn(state->net, state->sk, skb);
+			return NF_STOLEN;
+		}
 	}
 
 	return NF_ACCEPT;
-- 
2.39.2



