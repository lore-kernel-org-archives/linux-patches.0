Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CCF8635E;
	Mon,  6 Jan 2025 15:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176785; cv=none; b=ksfZZT8quINXj6nTsG5hu+1LPVeSHH9xu5O90I9gDMQ2bYIqcUPOWCtB+/pV3H+U1ZrqVnkcBtbrU/A3uy9VtZVgWS3audBzUrjaScHeB7io8kSNtTon0mKrN3hGG8EFD0qyGIUAMWxSIZnVdWeMMTHzgL5qJH9DBYWtPMwSWiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176785; c=relaxed/simple;
	bh=XF0S5/XrB/2qXjb7jWFmWiAd2dH+DU/H9Mdyoxm+bGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ke5Z7vEXlkD+9fuwGMbdExxJha1VhzV+bs1O3QDTx2IYepoyY/TlWI4ofPS/Xi2/kkf5rUTBDcIMjkFzAafw1PYBFarq8iSRsyPXYGQcpD0YN5BkZDqUCM8ZfasTC7ZlDkkK1+oadIMDAYkvEjlQcYIZI84pWBEsHw2m5kuNLeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0c5snfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0c5snfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3343C4CED6;
	Mon,  6 Jan 2025 15:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176785;
	bh=XF0S5/XrB/2qXjb7jWFmWiAd2dH+DU/H9Mdyoxm+bGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0c5snfsmotZsLcjTN0N0AGVz4jbd8ZNvNMfZoo0wVRRteFU6KsgLfi/ARtaI9O34
	 ZjO/yJM16rnRTF9nGjQK7zpg0pt84aBK8c19wM4zpWj010f29iAxXSKDhh82CEs/Ez
	 Jv7LQJaswYiyOIwDa10yDCJ47yhweapqNwzGEmfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 31/81] ip_tunnel: annotate data-races around t->parms.link
Date: Mon,  6 Jan 2025 16:16:03 +0100
Message-ID: <20250106151130.613622589@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f694eee9e1c00d6ca06c5e59c04e3b6ff7d64aa9 ]

t->parms.link is read locklessly, annotate these reads
and opposite writes accordingly.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: b5a7b661a073 ("net: Fix netns for ip_tunnel_init_flow()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index d56cfb6c3da4..196fe734ad38 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -102,10 +102,9 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 		if (!ip_tunnel_key_match(&t->parms, flags, key))
 			continue;
 
-		if (t->parms.link == link)
+		if (READ_ONCE(t->parms.link) == link)
 			return t;
-		else
-			cand = t;
+		cand = t;
 	}
 
 	hlist_for_each_entry_rcu(t, head, hash_node) {
@@ -117,9 +116,9 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 		if (!ip_tunnel_key_match(&t->parms, flags, key))
 			continue;
 
-		if (t->parms.link == link)
+		if (READ_ONCE(t->parms.link) == link)
 			return t;
-		else if (!cand)
+		if (!cand)
 			cand = t;
 	}
 
@@ -137,9 +136,9 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 		if (!ip_tunnel_key_match(&t->parms, flags, key))
 			continue;
 
-		if (t->parms.link == link)
+		if (READ_ONCE(t->parms.link) == link)
 			return t;
-		else if (!cand)
+		if (!cand)
 			cand = t;
 	}
 
@@ -150,9 +149,9 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 		    !(t->dev->flags & IFF_UP))
 			continue;
 
-		if (t->parms.link == link)
+		if (READ_ONCE(t->parms.link) == link)
 			return t;
-		else if (!cand)
+		if (!cand)
 			cand = t;
 	}
 
@@ -221,7 +220,7 @@ static struct ip_tunnel *ip_tunnel_find(struct ip_tunnel_net *itn,
 	hlist_for_each_entry_rcu(t, head, hash_node) {
 		if (local == t->parms.iph.saddr &&
 		    remote == t->parms.iph.daddr &&
-		    link == t->parms.link &&
+		    link == READ_ONCE(t->parms.link) &&
 		    type == t->dev->type &&
 		    ip_tunnel_key_match(&t->parms, flags, key))
 			break;
@@ -774,7 +773,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 
 	ip_tunnel_init_flow(&fl4, protocol, dst, tnl_params->saddr,
 			    tunnel->parms.o_key, RT_TOS(tos),
-			    dev_net(dev), tunnel->parms.link,
+			    dev_net(dev), READ_ONCE(tunnel->parms.link),
 			    tunnel->fwmark, skb_get_hash(skb), 0);
 
 	if (ip_tunnel_encap(skb, &tunnel->encap, &protocol, &fl4) < 0)
@@ -894,7 +893,7 @@ static void ip_tunnel_update(struct ip_tunnel_net *itn,
 	if (t->parms.link != p->link || t->fwmark != fwmark) {
 		int mtu;
 
-		t->parms.link = p->link;
+		WRITE_ONCE(t->parms.link, p->link);
 		t->fwmark = fwmark;
 		mtu = ip_tunnel_bind_dev(dev);
 		if (set_mtu)
@@ -1084,9 +1083,9 @@ EXPORT_SYMBOL(ip_tunnel_get_link_net);
 
 int ip_tunnel_get_iflink(const struct net_device *dev)
 {
-	struct ip_tunnel *tunnel = netdev_priv(dev);
+	const struct ip_tunnel *tunnel = netdev_priv(dev);
 
-	return tunnel->parms.link;
+	return READ_ONCE(tunnel->parms.link);
 }
 EXPORT_SYMBOL(ip_tunnel_get_iflink);
 
-- 
2.39.5



