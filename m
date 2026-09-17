Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DD84B7A35;
	Thu, 17 Sep 2026 18:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670482; cv=none; b=gERfYQIkK8BhxufmeXlKPW7zMpk79YTArGdg2PxoTTiLGIJBU4jznoHRdIdKZU5SuLFOr55W0ejzinQKqQNmoO8INJ+k4BofTb/YXsBRyvZ8ZCi6rccr0iEJ/KFCka0xiIeKBZTJ4n2VffUgEb1MgM8GVKnIFqASTTbwsflye80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670482; c=relaxed/simple;
	bh=I+5MshXc06TPWHe19lfxnz0MjkoSbTx1UNuPblqFltM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWul7OjbGJbY1fbRY427N0Av4ac6z85cnU8HjjJ5L4Z9xgTEnTcG1TQzvVq5H2AEbjuZAhuShEfhTbUVfwtmke2XCGW/5WFPCDnHxmxuWVPGIVMz9FeyUn7r5y6DM+qVfz9an7H98DNCaqcp6duIHScfjRbao6jSQXGDrAgVIrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSlwTCM7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSlwTCM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D5E1F000FF;
	Thu, 17 Sep 2026 18:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670481;
	bh=1MbRO8oZtpKyRwRQXR+nDy1e88kB6m/EJ2tDxDcu18I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZSlwTCM7gj3pTLEHbuJ1n1KGYQpRVj1H3o+9MV0BkQ3L9xabA/zK5H2rheumEVrQ8
	 faKzLG3Hf2ILl/8mtVCcAFKDxOe5FT3WpeaNVWVTusUzErgLfNm2WYpONYnAgi0Rpw
	 M8aDE3boMzDwncBwh6VA2LCuWNPuQw/juOSLpTb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0674/1102] net: bridge: mcast: properly convert mglist to rcu
Date: Thu, 17 Sep 2026 16:10:17 +0100
Message-ID: <20260917151557.151729744@linuxfoundation.org>
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
index 988014b143643..d8b1d66de9a64 100644
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



