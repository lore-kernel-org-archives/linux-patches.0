Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9ED280A3B;
	Wed,  4 Feb 2026 14:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216241; cv=none; b=W5pEU/T30Dw2EM4ake1nTjc5bqlPqS2dyJzR/U+LmJgqNXbksrVoMm9vFu2x7zDYm6rs2up6sYm9r+MEFuk1l4qrayMF9jyY8+6Xg5AY2PQ6hc4JYUPO3dzqymVOputtuKJJaQGzDAx7AZfZHfmhGtkAqZZttHdvMQfcfpuzatY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216241; c=relaxed/simple;
	bh=n4Act0LanljibOQaJa70HEfjdiwzF+oE1wibn9tPl3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmgDQstgBpthS2g9N2ZspMHtUIZTbfK35eeW4pXVpj/qUEqu5kgzUblbzw83vPKS/SUgz9ud75CN8W4/XURhAr+5EIO2KA15QY/OPf7ZHD1SwYKSbOeB0Y5B2jqA/HxQCkIJklV0ZEI3dQDvc5FdOLLMurYS+4trutgIaHYaJDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yf4jrpaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yf4jrpaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2359C4CEF7;
	Wed,  4 Feb 2026 14:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216240;
	bh=n4Act0LanljibOQaJa70HEfjdiwzF+oE1wibn9tPl3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yf4jrpawd3bDy1sDicEo7kewFY2E1RrJvivA5NFM63klTZYJ1wayxN0BDm1Uda2VD
	 NVFGpVCLQ05NJ0BNK/DCjORznn2J61K2AR5aIPNDHbcGo1Bs3sR+hkl0o7MMt0TdbB
	 POI70RDdO9v8nV3YJXxZtpS3lA/1S4PqpaPxt5pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7182fbe91e58602ec1fe@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/161] macvlan: fix possible UAF in macvlan_forward_source()
Date: Wed,  4 Feb 2026 15:37:51 +0100
Message-ID: <20260204143852.064217608@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7470a7a63dc162f07c26dbf960e41ee1e248d80e ]

Add RCU protection on (struct macvlan_source_entry)->vlan.

Whenever macvlan_hash_del_source() is called, we must clear
entry->vlan pointer before RCU grace period starts.

This allows macvlan_forward_source() to skip over
entries queued for freeing.

Note that macvlan_dev are already RCU protected, as they
are embedded in a standard netdev (netdev_priv(ndev)).

Fixes: 79cf79abce71 ("macvlan: add source mode")
Reported-by: syzbot+7182fbe91e58602ec1fe@syzkaller.appspotmail.com
https: //lore.kernel.org/netdev/695fb1e8.050a0220.1c677c.039f.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260108133651.1130486-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index a0d5d0c41b611..ed02451051aee 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -55,7 +55,7 @@ struct macvlan_port {
 
 struct macvlan_source_entry {
 	struct hlist_node	hlist;
-	struct macvlan_dev	*vlan;
+	struct macvlan_dev __rcu *vlan;
 	unsigned char		addr[6+2] __aligned(sizeof(u16));
 	struct rcu_head		rcu;
 };
@@ -141,7 +141,7 @@ static struct macvlan_source_entry *macvlan_hash_lookup_source(
 
 	hlist_for_each_entry_rcu(entry, h, hlist, lockdep_rtnl_is_held()) {
 		if (ether_addr_equal_64bits(entry->addr, addr) &&
-		    entry->vlan == vlan)
+		    rcu_access_pointer(entry->vlan) == vlan)
 			return entry;
 	}
 	return NULL;
@@ -163,7 +163,7 @@ static int macvlan_hash_add_source(struct macvlan_dev *vlan,
 		return -ENOMEM;
 
 	ether_addr_copy(entry->addr, addr);
-	entry->vlan = vlan;
+	RCU_INIT_POINTER(entry->vlan, vlan);
 	h = &port->vlan_source_hash[macvlan_eth_hash(addr)];
 	hlist_add_head_rcu(&entry->hlist, h);
 	vlan->macaddr_count++;
@@ -182,6 +182,7 @@ static void macvlan_hash_add(struct macvlan_dev *vlan)
 
 static void macvlan_hash_del_source(struct macvlan_source_entry *entry)
 {
+	RCU_INIT_POINTER(entry->vlan, NULL);
 	hlist_del_rcu(&entry->hlist);
 	kfree_rcu(entry, rcu);
 }
@@ -380,7 +381,7 @@ static void macvlan_flush_sources(struct macvlan_port *port,
 	int i;
 
 	hash_for_each_safe(port->vlan_source_hash, i, next, entry, hlist)
-		if (entry->vlan == vlan)
+		if (rcu_access_pointer(entry->vlan) == vlan)
 			macvlan_hash_del_source(entry);
 
 	vlan->macaddr_count = 0;
@@ -423,9 +424,14 @@ static bool macvlan_forward_source(struct sk_buff *skb,
 
 	hlist_for_each_entry_rcu(entry, h, hlist) {
 		if (ether_addr_equal_64bits(entry->addr, addr)) {
-			if (entry->vlan->flags & MACVLAN_FLAG_NODST)
+			struct macvlan_dev *vlan = rcu_dereference(entry->vlan);
+
+			if (!vlan)
+				continue;
+
+			if (vlan->flags & MACVLAN_FLAG_NODST)
 				consume = true;
-			macvlan_forward_source_one(skb, entry->vlan);
+			macvlan_forward_source_one(skb, vlan);
 		}
 	}
 
@@ -1615,7 +1621,7 @@ static int macvlan_fill_info_macaddr(struct sk_buff *skb,
 	struct macvlan_source_entry *entry;
 
 	hlist_for_each_entry_rcu(entry, h, hlist, lockdep_rtnl_is_held()) {
-		if (entry->vlan != vlan)
+		if (rcu_access_pointer(entry->vlan) != vlan)
 			continue;
 		if (nla_put(skb, IFLA_MACVLAN_MACADDR, ETH_ALEN, entry->addr))
 			return 1;
-- 
2.51.0



