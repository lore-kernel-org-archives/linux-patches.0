Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F946511E96;
	Wed, 30 Sep 2026 15:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782622; cv=none; b=Rf66uwkU6UmjrOIe38yyn3DTN2CkB0rMf3TATZB4MLX7oU7EBlCa2XdrT9hmzGZf3spRs/XDNYWq614oqWweH/I6NdrNNsGjHHgHy2mwy8+opmNBFuRU64tlrZtBPtdYa0++fxJfBGVg0uLaUUSkrHb2J8TVwLziI7Q+gz+IUMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782622; c=relaxed/simple;
	bh=UyMCnKvuRsV0Qi2FQfLQme6ROm4TLTltK6ZAvj5Z5Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrAuQPqh7jwPNiDvXczcgkuwZhaR0e/2Yra9mQZQbngQ9yyDyjbf50J43qOoRdrUiYr2rZFsqwiOoUn2VHFBYKSuh3UPCO4E0ipe74hc3nnavC776e5mZ/cUrfwb9oUC8o/oAQXflTtWFNVn73lKKf4wwyQgwoj6Zn523HbmnbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7GEnj24; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7GEnj24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE361F00898;
	Wed, 30 Sep 2026 15:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782609;
	bh=b+FQUZO2kOPr8DSEuU4XT6zJOJbWvcQtXbz1t3PmS7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H7GEnj24TayIoDf9GB4+8B7i7+Lb3EdtiKx+/bW/4U6AZ1n7OFlAcskfkjDrIIfOT
	 iJrNtOLDtaozNU/YYRYKVsF9QM0496QqrEt6QWarlRU3KlWraadvFVOhlXIpUSvJDv
	 IagcKDupJUMWX33IGcuQzu9PHVFI0Jmagn67RB6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/595] hsr: broadcast netlink notifications in the devices net namespace
Date: Wed, 30 Sep 2026 17:19:58 +0200
Message-ID: <20260930152349.997892127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f3c8f91dbe2c1..8cd712727c498 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -209,7 +209,8 @@ void hsr_nl_ringerror(struct hsr_priv *hsr, unsigned char addr[ETH_ALEN],
 		goto nla_put_failure;
 
 	genlmsg_end(skb, msg_head);
-	genlmsg_multicast(&hsr_genl_family, skb, 0, 0, GFP_ATOMIC);
+	genlmsg_multicast_netns(&hsr_genl_family, dev_net(port->dev),
+				skb, 0, 0, GFP_ATOMIC);
 
 	return;
 
@@ -245,8 +246,12 @@ void hsr_nl_nodedown(struct hsr_priv *hsr, unsigned char addr[ETH_ALEN])
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



