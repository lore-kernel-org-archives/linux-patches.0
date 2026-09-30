Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF9226ED40;
	Wed, 30 Sep 2026 18:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794363; cv=none; b=NWcXtjnO3hWhVa3pI2CWVDWq5CMwLcFO2lRlwEwRQO/mliflXAX2e+e8UFKk0uBtyeRw2zuRbTq6kaCeUClaZ2XZZwLEXm88TnySEcqNgTYOp66obWnlbE50hETl0WZsTY0me7O5wOVF9426ljd/NHJB5mSiML9YcTzcdq5pArU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794363; c=relaxed/simple;
	bh=Qq8zg47wYN86oUevyUWlMteuU3+g1/77xht/8yFUxy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNkVZOq0hsO28Pa7Qo3kHMwRpBpvbj3f/O117+7jm1kwn3BZ7wJ4uayv3q4VO/jwuChq2edI9Gl2MZbfF43Jlr6h4xzDlGYvZ5raG8QCSDUrmUV5Q5Rxif++ujN49Y0YLJl/emIl+8a1qHnWByRZWAUlMJ1F7xRC3m+S9WP2O3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJJ5N/3/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJJ5N/3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D691F000FF;
	Wed, 30 Sep 2026 18:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794362;
	bh=Tzd0/CRsgn6PXKaZQrQZkDYG0H4OPBgW3JSlX7JNFyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJJ5N/3/zLfjpg4JF4xWosOjTn19g3pxwXBZbNJPQ1reTcaBw4tEHgRHlTi+6fgfv
	 3eNU7ISG8QxLVfrEYLPjki0xIzTjVmCXiwRyrBChn3HKc45468meSdgHdk1kC98qsx
	 yAuJ2mABG2MyTl0ZJxifG3r1AfreAYZz3MSbq/G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0183/1193] hsr: broadcast netlink notifications in the devices net namespace
Date: Wed, 30 Sep 2026 17:14:27 +0200
Message-ID: <20260930152438.260157406@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit a762fabd7ef9a6cc07258684138f9c3f078d0326 ]

The HSR generic netlink family sets .netnsok = true. HSR devices can
live in network namespaces other than init_net.

Two async notifiers broadcast events with genlmsg_multicast(). They
are hsr_nl_ringerror() and hsr_nl_nodedown(). That helper delivers
only on the default genl socket in init_net. So the events always land
in init_net. The network namespace of the device does not matter.

This has two effects. A listener in the device's own namespace never
sees its own ring error and node down events. A privileged listener in
init_net receives events from HSR devices in other namespaces. The
payload carries the peer node MAC (HSR_A_NODE_ADDR) and the slave port
ifindex (HSR_A_IFINDEX).

Switch both callers to genlmsg_multicast_netns(). Other families with
.netnsok = true already do this. Examples are gtp, ovpn, team,
batman-adv, netdev-genl, ethtool and handshake.

hsr_nl_ringerror() already has the slave port. It uses
dev_net(port->dev). hsr_nl_nodedown() takes the namespace from the
master port via hsr_port_get_hsr().

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/20260604054949.2999304-1-maoyixie.tju@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_netlink.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 898f18c6da53e..72aad6f845319 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -233,7 +233,8 @@ void hsr_nl_ringerror(struct hsr_priv *hsr, unsigned char addr[ETH_ALEN],
 		goto nla_put_failure;
 
 	genlmsg_end(skb, msg_head);
-	genlmsg_multicast(&hsr_genl_family, skb, 0, 0, GFP_ATOMIC);
+	genlmsg_multicast_netns(&hsr_genl_family, dev_net(port->dev),
+				skb, 0, 0, GFP_ATOMIC);
 
 	return;
 
@@ -269,8 +270,12 @@ void hsr_nl_nodedown(struct hsr_priv *hsr, unsigned char addr[ETH_ALEN])
 	if (res < 0)
 		goto nla_put_failure;
 
+	rcu_read_lock();
+	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 	genlmsg_end(skb, msg_head);
-	genlmsg_multicast(&hsr_genl_family, skb, 0, 0, GFP_ATOMIC);
+	genlmsg_multicast_netns(&hsr_genl_family, dev_net(master->dev),
+				skb, 0, 0, GFP_ATOMIC);
+	rcu_read_unlock();
 
 	return;
 
-- 
2.53.0



