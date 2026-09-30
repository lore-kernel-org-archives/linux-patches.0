Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB213FE359;
	Wed, 30 Sep 2026 19:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795184; cv=none; b=e9GXwZhtEiKuV1Z6Vdj0soLVM0nUVqtSa0a4fHw9vvU0ozsTVKHbr3Ac/Q1NVeBTS/gXg3va5oCYs8u40l2LORrMwo16JcAb+XDhLyg+B9I9QQBRhfCMAGchDYyudcWYXsRQ053CWzNo4Epdi8RHFrKZLR/UoGrGLv4dJVLH+G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795184; c=relaxed/simple;
	bh=MSrZeKYol6bXkCGpHca7j9U32kSebs54rqek/b6OxTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=py9Wv0GIT6qzay6k1CmEz6Ca1Ab6z5Cn8h+XkNuwaJhQ4yMkJG74PzxMVmOP/N7A2owe3SbhgQMbAYFNn2cbevRLA3XF+gMrSmuQoz+N+0SbZPSpTLQKRwPNfNCXcLEtvDGSr2AFl+taRcUWYWa3pXwDeMJ9CNB0q8dcdOx3n+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6Wya8EL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6Wya8EL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACE61F0089A;
	Wed, 30 Sep 2026 19:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795182;
	bh=EnB9pa/wb059ERZCSl/eDQsN3m4X8ClWGlj3RNvJW1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6Wya8EL5svLDWOQmXkplfSuh3bLAkjZ5EiofqbVXLIpS6USshFYQD02JS2xfm8bY
	 4HHTKNcc119uFIAbewX3F9A9c0x88RQ2IR0oAUWcMsm3VGaCZ+Wd1hlSvPkmd4JKfw
	 i+clwyi361OntXlpB/SukULvvtAk2Er/rmbN1jf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0427/1193] ip6_gre: check tunnel info before xmit in ip6gre_tunnel_xmit
Date: Wed, 30 Sep 2026 17:18:31 +0200
Message-ID: <20260930152443.685855150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 97cc84dad1d7f68a36b71b69b361d88482707673 ]

Shuangpeng Bai reported a KASAN slab-use-after-free in
ip6gre_tunnel_xmit().

The precise KASAN bug was caused by ip6_tnl_xmit() consuming the
skb during headroom expansion and returning an error, while
ip6gre_tunnel_xmit() still held the stale pointer and called
skb_tunnel_info_txcheck(skb) at tx_err. That specific bug was fixed by
commit 87f21b59ddc6 ("ip6_tunnel: use skb_cow_head() in ip6_tnl_xmit()").

However, calling skb_tunnel_info_txcheck(skb) at the tx_err label
after the transmission attempt remains problematic:

Downstream helpers like ip6_tnl_xmit() call skb_scrub_packet(),
which drops the skb's metadata_dst before transmission. If an error
occurs later during transmit, inspecting skb at tx_err sees a scrubbed
dst and misclassifies tx_errors vs tx_dropped.

Commit e5f7e211b6aa ("ip6gre: avoid tx_error when sending MLD/DAD on
external tunnels") already handled this correctly in
ip6erspan_tunnel_xmit() by checking and caching tun_info before
transmit.

Align ip6gre_tunnel_xmit() with ip6erspan_tunnel_xmit() by caching
tun_info before xmit and checking it at tx_err.

Fixes: e5f7e211b6aa ("ip6gre: avoid tx_error when sending MLD/DAD on external tunnels")
Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Closes: https://lore.kernel.org/netdev/20260819062224.3197349-1-shuangpeng.kernel@gmail.com/
Cc: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260828103731.1951815-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index ef94bce1d2d55..54fd270edc810 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -897,6 +897,7 @@ static int ip6gre_xmit_other(struct sk_buff *skb, struct net_device *dev)
 static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 	struct net_device *dev)
 {
+	struct ip_tunnel_info *tun_info = NULL;
 	struct ip6_tnl *t = netdev_priv(dev);
 	__be16 payload_protocol;
 	int ret;
@@ -907,6 +908,9 @@ static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 	if (!ip6_tnl_xmit_ctl(t, &t->parms.laddr, &t->parms.raddr))
 		goto tx_err;
 
+	if (t->parms.collect_md)
+		tun_info = skb_tunnel_info_txcheck(skb);
+
 	payload_protocol = skb_protocol(skb, true);
 	switch (payload_protocol) {
 	case htons(ETH_P_IP):
@@ -926,7 +930,7 @@ static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
 tx_err:
-	if (!t->parms.collect_md || !IS_ERR(skb_tunnel_info_txcheck(skb)))
+	if (!IS_ERR(tun_info))
 		DEV_STATS_INC(dev, tx_errors);
 	DEV_STATS_INC(dev, tx_dropped);
 	kfree_skb(skb);
-- 
2.53.0



