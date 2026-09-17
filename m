Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6AB3B3BE7;
	Thu, 17 Sep 2026 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665385; cv=none; b=geEweGTOqD23V7MgYC9OGlkGhtpp4hEAyVM1LpTeIkLTW6pjWPd3pYbEjOc4jApa0VwhAfhjvCZbNucrbd7HsOt54w1HMehSUoKlmxAz5Iv1kb7zPpKUbOufMgeAxgoZw9vU5zRbHQfA9kdn6M0sYN9JSlxBPm/1i0whw+Hr6Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665385; c=relaxed/simple;
	bh=VbFoZQb1rpw+66Zc+vyR0VrUPC1/v3Y8xJkbrh1MmX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcDSjpu/1hiRFKql/p2V1Uz5ISBQVtj3FaUU8Hjgu8we49h1//kzgE0uc6K8+P4onizj9H7Ks8X90QVbKoILGIn+wYONNDvlxZ22tnumaejxCtzUWR/uhkt0Vw0XrkmvzcR5gFvgCE2NFLp3Jx9w/Khxrefa05i9pNMUECXIWcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbKD34Hm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbKD34Hm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E241F000FF;
	Thu, 17 Sep 2026 17:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665383;
	bh=ZsIZWOyfQF2+FpZJ7mk6ltHGDm1e2RU4LHJfHNBOaO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbKD34HmMLAq1lMi/UCLrMy+ydZHkFNf2NrgJb710JeRe8tRMFovCFMPNuDIwzBBi
	 aFmhy3a8ghzOrCdTSNN9FoXV8xO+BSQXVw+glMz32oJsr91cVPBnJZgTbBBM0hNubO
	 dwieUJPCyOkzqa+/WJQM0feyvDRIByJRLqjanslY=
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
Subject: [PATCH 6.18 0686/1250] ip6_gre: check tunnel info before xmit in ip6gre_tunnel_xmit
Date: Thu, 17 Sep 2026 16:08:01 +0100
Message-ID: <20260917151610.483089810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c848319e17d61..81792c940d296 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -877,6 +877,7 @@ static int ip6gre_xmit_other(struct sk_buff *skb, struct net_device *dev)
 static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 	struct net_device *dev)
 {
+	struct ip_tunnel_info *tun_info = NULL;
 	struct ip6_tnl *t = netdev_priv(dev);
 	__be16 payload_protocol;
 	int ret;
@@ -887,6 +888,9 @@ static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 	if (!ip6_tnl_xmit_ctl(t, &t->parms.laddr, &t->parms.raddr))
 		goto tx_err;
 
+	if (t->parms.collect_md)
+		tun_info = skb_tunnel_info_txcheck(skb);
+
 	payload_protocol = skb_protocol(skb, true);
 	switch (payload_protocol) {
 	case htons(ETH_P_IP):
@@ -906,7 +910,7 @@ static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
 tx_err:
-	if (!t->parms.collect_md || !IS_ERR(skb_tunnel_info_txcheck(skb)))
+	if (!IS_ERR(tun_info))
 		DEV_STATS_INC(dev, tx_errors);
 	DEV_STATS_INC(dev, tx_dropped);
 	kfree_skb(skb);
-- 
2.53.0



