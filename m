Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CBB4DDB2B;
	Thu, 17 Sep 2026 15:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659118; cv=none; b=iYoEZocwZ/0K+pXmKeHSuAsDlK3Rs9y1qBRqjvtlJvc8ZaZWk+jsOs2WjfbYpXmG1FDMhrwKFLfTcpdIu9fzkjVSvmTgkSD0rNjTykTZ+heQoME07I0LuymaCjpD3b5p7M8rCIoyv3fNkhMdxlmC1TjIq2vvuq1U+q0nhtx5u9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659118; c=relaxed/simple;
	bh=PqHjkZycz3RHvBLhGk/W1WTr44VLXYjJWcWcvKo7Ofk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=de4h7degMPGatCW9BTJRFbRzSG1vmX/ZWd0Y0lQpHUiBwD7tyBxpOLi6fBiSZda06qZ3Zm8tsH2+mly1E+NoolrTTfnry5EnhMwaGchENBLXGhXPCuVvz75GIicYfKr7zxM7oIlIOO385LWqlaIiSZoQ6l8arNIdoYIeQ0P5FcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luhRsXq/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luhRsXq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC1D1F00898;
	Thu, 17 Sep 2026 15:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659105;
	bh=VnC/lyHD5PGwVqrlh5dIVUOqKE1hrKw9hPr604FiyNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=luhRsXq/twrurYqX+XwxXQhB1ehYJEflqsZqPT2Ddd/n7C3KetQxoRjOCK6ITyql2
	 UIRI2QB7wkMbYDtjNa+PQ/JjNfJ82+DhCIY+I/5SkCk9ZaRBqkXPSC83hH7i/0qZox
	 U/WoNrYp2HPdrcBbb98yFotMwX4WBV347RrEFjqM=
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
Subject: [PATCH 7.2 145/733] ip6_gre: check tunnel info before xmit in ip6gre_tunnel_xmit
Date: Thu, 17 Sep 2026 16:07:33 +0100
Message-ID: <20260917151354.659686189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 200d0ba1a40e7..678678fcb5da3 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -878,6 +878,7 @@ static int ip6gre_xmit_other(struct sk_buff *skb, struct net_device *dev)
 static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 	struct net_device *dev)
 {
+	struct ip_tunnel_info *tun_info = NULL;
 	struct ip6_tnl *t = netdev_priv(dev);
 	__be16 payload_protocol;
 	int ret;
@@ -888,6 +889,9 @@ static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 	if (!ip6_tnl_xmit_ctl(t, &t->parms.laddr, &t->parms.raddr))
 		goto tx_err;
 
+	if (t->parms.collect_md)
+		tun_info = skb_tunnel_info_txcheck(skb);
+
 	payload_protocol = skb_protocol(skb, true);
 	switch (payload_protocol) {
 	case htons(ETH_P_IP):
@@ -907,7 +911,7 @@ static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
 tx_err:
-	if (!t->parms.collect_md || !IS_ERR(skb_tunnel_info_txcheck(skb)))
+	if (!IS_ERR(tun_info))
 		DEV_STATS_INC(dev, tx_errors);
 	DEV_STATS_INC(dev, tx_dropped);
 	kfree_skb(skb);
-- 
2.53.0



