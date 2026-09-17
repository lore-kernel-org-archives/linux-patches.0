Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B984D17BD;
	Thu, 17 Sep 2026 18:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668902; cv=none; b=qRRztsMU8Xkj9Au94xmq9lJnWnHoiKfEKmD4KfZH+Ii2Ce6dAXIG72P7tLYJPuiVygR/q0vY85ZA478xeLYQST16OojbnkZVsfswYPMvQ4xlFDwQqNSP6sEvHVmMncX8op4Syx/oyI5aVhM//H3StEzRjcEGpZMLnG1xzOeE3xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668902; c=relaxed/simple;
	bh=36mOSAcL7dg7dmp9Fc4pBuiROyLdzbY3b4fDSWKyK9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OocWRHntEc1HkBcrIKv7hPX9O0XInevy730l1sIFsHyIruRw6WkqPHHHMS0f1+JecTz+2qu8gRxEqDSYVRhZVIqkDB2aeV9+Mc6jSENu4IikAfgXP+b3R+oZ+xFIIpvub5/XPsSzlBTF/B5k80BuWGwkczq6klKhSvyQqbEgEi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qm3Gppg4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qm3Gppg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22C01F000FF;
	Thu, 17 Sep 2026 18:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668901;
	bh=ON8Q7putVtMUYswE7YesM08EfnU9S3Wd1grLWgMIY3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qm3Gppg4RUttTbegFsXNeZ0FStxgMX1VD+LQpk6jF4kPQxQ+zB5g1HcGsZmx1D05E
	 2FpiIt47Se8HK4bhBzA42u7o+ASUbKUOuezFFTjMLZoapNys7ocY/5Gxl9hZHzl7Rr
	 Aik6+5NM6jP8GZr79TSmU2jEMkxC16lex/FDu+Wo=
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
Subject: [PATCH 6.12 0578/1102] ip6_gre: check tunnel info before xmit in ip6gre_tunnel_xmit
Date: Thu, 17 Sep 2026 16:08:41 +0100
Message-ID: <20260917151554.452167449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 316898748a4ab..ae1c731b3be42 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -906,6 +906,7 @@ static int ip6gre_xmit_other(struct sk_buff *skb, struct net_device *dev)
 static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 	struct net_device *dev)
 {
+	struct ip_tunnel_info *tun_info = NULL;
 	struct ip6_tnl *t = netdev_priv(dev);
 	__be16 payload_protocol;
 	int ret;
@@ -916,6 +917,9 @@ static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 	if (!ip6_tnl_xmit_ctl(t, &t->parms.laddr, &t->parms.raddr))
 		goto tx_err;
 
+	if (t->parms.collect_md)
+		tun_info = skb_tunnel_info_txcheck(skb);
+
 	payload_protocol = skb_protocol(skb, true);
 	switch (payload_protocol) {
 	case htons(ETH_P_IP):
@@ -935,7 +939,7 @@ static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
 tx_err:
-	if (!t->parms.collect_md || !IS_ERR(skb_tunnel_info_txcheck(skb)))
+	if (!IS_ERR(tun_info))
 		DEV_STATS_INC(dev, tx_errors);
 	DEV_STATS_INC(dev, tx_dropped);
 	kfree_skb(skb);
-- 
2.53.0



