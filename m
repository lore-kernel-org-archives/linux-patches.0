Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209296;
	b=fEWH2mOLcQliT3a+Ws6sAiqNgRTFEgyOkC8DpnDtKVvQaaNg79Z6pcsexbD/7ACGwve/
	 /WGGm9BPolWi1IWf94j1M4vcZCjtf6w9N3R52A6QSfDzPH4kqo8U1rcM8VWAZcRYjyj7i
	 fiZ95g+BEHduyX8k0/dNpDTpu+EHYY5xRX8H4uZWran+kyfVvNGHIdBVgOV/JR3Gk1Kxf
	 TjHEC0fjRpME0yiI+URoB9TqvhikjifRNNENqWlTR5zVedenxhBx2RIM/Qo9u+borl6z2
	 8KnOn+J5CWwFx0/a9cK6YzKKfU/VzPdJnombE7UqiAjgpU4tD/kDQMWlTyc1oaM35Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CnquhOlD1XIgjMtpUrp1W9o7GDtQK4qeIOGXeJyHEtY=;
	b=S8xkbB+c4a2HCnf4tP9rjvNSLTub1amdo86oVD2awxWwgHKuZidnsRrlK1YVCdJogjCH
	 jAWHkAYC1yvyeys16SYCOYzYjGB8IKy54Xb2cwBueLkt9gC48KESTBBaQeAuLfRaSrTz2
	 10HGs7Td452ABtJqaeh9ZgtKDMgLW6Gp9CPJo71BHK8PEufO53UCQ1c0kU6EDE/ddw+9j
	 6C/ocgU76r9ff8JVYN3zVuijYHlXN38FujhJERSIxot2EdQ8flbII+W1ecoh2rY31zUuj
	 j2Mafyz5hZ8ksIXBtbaxITTCzSAYtb4rM0pKQEYIMWwSyGVO/fUGxfCZ9v4erIwPXJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OFN2VOcc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC00606A31A;
	Wed, 28 Oct 2026 17:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OFN2VOcc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1196E1F01825;
	Wed, 28 Oct 2026 17:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209295;
	bh=CnquhOlD1XIgjMtpUrp1W9o7GDtQK4qeIOGXeJyHEtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OFN2VOccwentyH+ZmvuCXoEH8yey+79t/v7i34aGjJHTXGd2shCwGXg8WBtUH9QWq
	 lGG3fjA8qnAUp4RRkVa4YhfUteD8C02O/z5ZoIKZdymsp4O4z51xmYfJ8SJxteUv0K
	 QDIg+tGBSjObwMSz9Ifo++1DjDXdFoUUZRAFasB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zixuan Chai <petalzu987@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 378/516] net: bridge: avoid recursive multicast port cleanup
Date: Wed, 28 Oct 2026 17:58:50 +0100
Message-ID: <20261028170012.437766709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zixuan Chai <petalzu987@gmail.com>

[ Upstream commit 5158353121bae4f552cb677ce8c5c3ef52f93a0d ]

br_multicast_sg_del_exclude_ports() removes automatically added STAR_EXCL
port groups by calling br_multicast_del_pg(). For S,G entries, that
deletion calls back into br_multicast_sg_del_exclude_ports(), so a large
number of STAR_EXCL ports consumes one kernel stack frame per port and can
hit the stack guard page.

Keep the complete port-group deletion path for cleanup, but suppress the
S,G exclude-port cleanup while that helper is already walking the same
entry. Normal deletion callers retain the existing behavior.

Fixes: 8266a0491e92 ("net: bridge: mcast: handle port group filter modes")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Zixuan Chai <petalzu987@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ sashal: Adjusted context for the __br_multicast_del_pg() declaration because neighboring upstream forward declarations are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_multicast.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 5cc65f51b3785..53dd2d56c37ef 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -76,6 +76,10 @@ __br_multicast_add_group(struct net_bridge *br,
 			 bool blocked);
 static void br_multicast_find_del_pg(struct net_bridge *br,
 				     struct net_bridge_port_group *pg);
+static void __br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
+				  struct net_bridge_port_group *pg,
+				  struct net_bridge_port_group __rcu **pp,
+				  bool sg_del_exclude_ports);
 
 static struct net_bridge_port_group *
 br_sg_port_find(struct net_bridge *br,
@@ -361,7 +365,7 @@ static void br_multicast_sg_del_exclude_ports(struct net_bridge_mdb_entry *sgmp)
 	for (pp = &sgmp->ports;
 	     (p = mlock_dereference(*pp, sgmp->br)) != NULL;) {
 		if (!(p->flags & MDB_PG_FLAGS_PERMANENT))
-			br_multicast_del_pg(sgmp, p, pp);
+			__br_multicast_del_pg(sgmp, p, pp, false);
 		else
 			pp = &p->next;
 	}
@@ -582,9 +586,10 @@ static void br_multicast_destroy_port_group(struct net_bridge_mcast_gc *gc)
 	kfree_rcu(pg, rcu);
 }
 
-void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
-			 struct net_bridge_port_group *pg,
-			 struct net_bridge_port_group __rcu **pp)
+static void __br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
+				  struct net_bridge_port_group *pg,
+				  struct net_bridge_port_group __rcu **pp,
+				  bool sg_del_exclude_ports)
 {
 	struct net_bridge *br = pg->key.port->br;
 	struct net_bridge_group_src *ent;
@@ -598,7 +603,8 @@ void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 	if (!br_multicast_is_star_g(&mp->addr)) {
 		rhashtable_remove_fast(&br->sg_port_tbl, &pg->rhnode,
 				       br_sg_port_rht_params);
-		br_multicast_sg_del_exclude_ports(mp);
+		if (sg_del_exclude_ports)
+			br_multicast_sg_del_exclude_ports(mp);
 	} else {
 		br_multicast_star_g_handle_mode(pg, MCAST_INCLUDE);
 	}
@@ -609,6 +615,13 @@ void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 		mod_timer(&mp->timer, jiffies);
 }
 
+void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
+			 struct net_bridge_port_group *pg,
+			 struct net_bridge_port_group __rcu **pp)
+{
+	__br_multicast_del_pg(mp, pg, pp, true);
+}
+
 static void br_multicast_find_del_pg(struct net_bridge *br,
 				     struct net_bridge_port_group *pg)
 {
-- 
2.53.0



