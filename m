Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1559518127;
	Thu, 17 Sep 2026 17:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665710; cv=none; b=UWEJ+qbUex5cGQNPaEXv1/wb9Hg6L6b0e9gEHqwMKJ+KSUQW7Dy5nF7lvg73k1ziWHFGeJg13uOE3d5RRbEG4U5aPpOxwObvvVxsuH73bBNYe+43DQ7H3TsOmx36uevqqR6YCD+W+DYjDAgkDv2IyVBB9+BKFztjR+ycHWC9RJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665710; c=relaxed/simple;
	bh=ojI9+c2+7N6g11+RXK9cwozxKw9XxJF+9jeDYxAOqEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hpz1HVo7egeTE3McQQd2QCyIqxfoC/+933KQVJp5MlRok59V+LM/dE/6caOvIGgWiyqFnkAoTFMp8f7frrKgBJTRJMi2X6oNAu7k018CtQKzjHF4SuaQmvNFSj7lSLwDu623/HHuJVcJ/Hd07z6e6htcVqemG6G2W0wiu2MKlSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJf0vlZ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJf0vlZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1D61F000FF;
	Thu, 17 Sep 2026 17:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665708;
	bh=s0Unn6G1qUPXThpoXbLvh+jMMDNU2iCj4rfVaI2I4rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJf0vlZ/wfC+IKVlrvH1MH/roS2XRIVBtCx6OOTOTV4hbn96/ZFEkqUNYim3FcSCE
	 Tp4Fjrj7x7kF7Z3M/9xNl12sQc5smQyYogBZz7Im5aJOgnYVXO/ISQ6AbHGzt/zms+
	 REI8pQByiXviRirOWqdmd3mSGvLe4iJeAw5fr2s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0794/1250] net: bridge: mcast: properly convert mglist to rcu
Date: Thu, 17 Sep 2026 16:09:49 +0100
Message-ID: <20260917151613.419096146@linuxfoundation.org>
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 4b772869a1e5f9da5cef5b9c722ec0aa424ee0a0 ]

Sashiko reported a bug [1] that br_multicast_del_port_group unlists the
port group not using proper rcu helper that preserves the next pointer and
after that immediately frees the port group without waiting for rcu grace
period. The only rcu walker of mglist is br_multicast_list_adjacent() and
it turns out that function has always been buggy because mglist was never
properly converted to RCU. Fix it by converting it to rcu and moving its
initialization after eth_addr's. Initializing p->next can use
RCU_INIT_POINTER because we have a barrier from the hlist_add_head_rcu call
later, besides we're initializing an unpublished structure anyway.

[1] https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260826014200.362304-1-littleddfu%40gmail.com

Fixes: 07f8ac4a1e26 ("bridge: add export of multicast database adjacent to net_dev")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260903093851.1494297-1-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_multicast.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 9de9db5fa731c..fda1f89ee22ae 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1437,16 +1437,17 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 		goto free_out;
 	}
 
-	rcu_assign_pointer(p->next, next);
 	timer_setup(&p->timer, br_multicast_port_group_expired, 0);
 	timer_setup(&p->rexmit_timer, br_multicast_port_group_rexmit, 0);
-	hlist_add_head(&p->mglist, &port->mglist);
 
 	if (src)
 		memcpy(p->eth_addr, src, ETH_ALEN);
 	else
 		eth_broadcast_addr(p->eth_addr);
 
+	RCU_INIT_POINTER(p->next, next);
+	hlist_add_head_rcu(&p->mglist, &port->mglist);
+
 	return p;
 
 free_out:
@@ -1461,11 +1462,11 @@ void br_multicast_del_port_group(struct net_bridge_port_group *p)
 	struct net_bridge_port *port = p->key.port;
 	__u16 vid = p->key.addr.vid;
 
-	hlist_del_init(&p->mglist);
+	hlist_del_init_rcu(&p->mglist);
 	if (!br_multicast_is_star_g(&p->key.addr))
 		rhashtable_remove_fast(&port->br->sg_port_tbl, &p->rhnode,
 				       br_sg_port_rht_params);
-	kfree(p);
+	kfree_rcu(p, rcu);
 	br_multicast_port_ngroups_dec(port, vid);
 }
 
-- 
2.53.0



