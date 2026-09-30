Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2B0518128;
	Wed, 30 Sep 2026 16:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784460; cv=none; b=b0QouTa7FTDsNuEB96j915hY5FmWdTSYtJ3sfaGAblL50qpaxtJ49PVHfaID/z3YNOiMs3fj6/R0Phv3N/BhZH6O9GgxX18je2t0j31vgDMmNlK8s+DIkK3rtFWxPvIW/9I/eC///LKzRaxegeg6yfBQrY52oTcd0hAaMQ29UJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784460; c=relaxed/simple;
	bh=oA+uVcLmeTwMSKGuLqKR+CMsLIWxajAIurGtCFlvouM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3NH0rXKLHzMSvtafZyjqng6RKvtjFoPvRqsuNibX8XmuZALFP5XDCMARHR8cXP+Y5qq7M3581EQJK/QpauzHCpFFBKV/iuOsZKnmIbihj2kweUfu2s3wfoiRM/pLKEeYAEBAEL7NW2TD9O6gZsg+cPIZ96sOMDUIUB3fHVH/oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSjbOEMt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSjbOEMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE9A1F000FF;
	Wed, 30 Sep 2026 16:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784453;
	bh=HmP9TFqbO9a87pKsofsyqJqkFfHp6SrwgxuboAWGdQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSjbOEMt6G0mtnSav6RNidflquDGDWY/8pbjWuZlD+cTswbpYadal2WrKtBi/7jq0
	 qMWTzjAaxq9ydVU7JjRe5OLU50maXJqSB3w6S6xmO0krGJuDmhCqUApR3qlAuKHFBY
	 7SDnY7LLBgIix0lSZ8OjMZnS6yCDuYIjsVba9ExY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/982] hsr: broadcast netlink notifications in the devices net namespace
Date: Wed, 30 Sep 2026 17:14:55 +0200
Message-ID: <20260930152420.224951409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



