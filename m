Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5565434992;
	Wed, 30 Sep 2026 19:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795240; cv=none; b=mUJ9AVq5Mi/PizSzFFA7ydPUD642HHAowWV+nZRo1wzKDXrb6eqpQqOjZ9yXvWQbMetKlfY9Lh43TemW4bdr1Ty1eZdoT5cSAp1TufROwKmaUgwCDNJ6zzDGqRLryJzlXUC6c4iKHAV1ILWdQ+TSbbh8EPrBhu8pk4lQvihJqNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795240; c=relaxed/simple;
	bh=BUWIo5Y98w0hmMQV7NAWR9FWYKmPXJA7Yv4ktZ0HEBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imhKGiT+bXx+EsoqNj7owF5VjHFI7+J4o7dr+k5VVfDPxRK0uX8+6Cy2uxpaXS1bwnDLplf2MgDUR3zX9EwJ3fciXXSxAhJ7y7pytJExx4kDv41BK9cRhijE2iAlKdO9Sciz5vHMC/Zxp96Kl4omafzB1aJIwr67vb+WMcunrKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZOPrOY8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZOPrOY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2D61F000FF;
	Wed, 30 Sep 2026 19:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795239;
	bh=kVx0U+/wKqKgpq212q+V/B9BAlMbRRxoNgsASqcHs9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZOPrOY8OiFMOjWsMQTMK8qGxXRy2Vpjou/M6ZdaZq8IsSMaUJfyko7GdWi5gI+iA
	 04lrJAwtX1uE8TiAA48iib0n8EjzSYhmJokl7neY3sg9xQ2z3dUsVfNSB7GOBpumX8
	 16FcsJS+I/mmPNtVJX6oUvL6G2aXRyap/DiwQ2jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0492/1193] net: bridge: mcast: properly convert mglist to rcu
Date: Wed, 30 Sep 2026 17:19:36 +0200
Message-ID: <20260930152445.082441511@linuxfoundation.org>
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
index 11ac945c6e29b..b563c97cc7090 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1436,16 +1436,17 @@ struct net_bridge_port_group *br_multicast_new_port_group(
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
@@ -1460,11 +1461,11 @@ void br_multicast_del_port_group(struct net_bridge_port_group *p)
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



