Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85504345CC0;
	Wed, 21 Jan 2026 18:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020131; cv=none; b=aXNNrjtlMMCnD5G0aBhAX0eF6q5A/qaPv3l8KRgb7Ng6TERGm2tXAMDFKUsxTRkE6ITP+5Wgxkhwr4XmZfvXnD6mSReWWVB7j4ykxr2ym/ov07OYYl9axKrWalqKsh+hopboSyLRsCYZ0DkRqPeB77mNcpjXl8/tYJBSw15TTeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020131; c=relaxed/simple;
	bh=Z19gAiuKBKztb+vT5sS6dAWHyiZfN6F3uXj+afYVWJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNItN6TdDRyyfTrobDDSV5aCBkF+iIq8WOcWjZcDSiCaJiXM8EcevM/THzj1IOfe+djmX1HZ+7cTkwL3NhbgGAQZUb4ZG9mW40p6oWcxYyg54uiPMJSo9AMtagVaztGLYuBJByE7gWoOLaLELbouRgOOSu0I4mDTeN8S4UDuOIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+rW6SMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+rW6SMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3A1C16AAE;
	Wed, 21 Jan 2026 18:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020131;
	bh=Z19gAiuKBKztb+vT5sS6dAWHyiZfN6F3uXj+afYVWJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+rW6SMYIsiLoQC1GsQYKlN3pVcxj/ZQMN1zepUkdP+Z7NKg4op1L8+FikIep2nt4
	 xn5Ydl3WSqpzUmVgkqq2KKutFvJQ4/2WCvFZlrgzEoM6IjlGDbOBhyhMnsI3RZ248Y
	 bH2zkPEm6RwkwtBJr699gd0NG311GX1rqKzcIgWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7182fbe91e58602ec1fe@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/198] macvlan: fix possible UAF in macvlan_forward_source()
Date: Wed, 21 Jan 2026 19:14:23 +0100
Message-ID: <20260121181419.814581003@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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
index 7966545512cfe..b4df7e184791d 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -59,7 +59,7 @@ struct macvlan_port {
 
 struct macvlan_source_entry {
 	struct hlist_node	hlist;
-	struct macvlan_dev	*vlan;
+	struct macvlan_dev __rcu *vlan;
 	unsigned char		addr[6+2] __aligned(sizeof(u16));
 	struct rcu_head		rcu;
 };
@@ -146,7 +146,7 @@ static struct macvlan_source_entry *macvlan_hash_lookup_source(
 
 	hlist_for_each_entry_rcu(entry, h, hlist, lockdep_rtnl_is_held()) {
 		if (ether_addr_equal_64bits(entry->addr, addr) &&
-		    entry->vlan == vlan)
+		    rcu_access_pointer(entry->vlan) == vlan)
 			return entry;
 	}
 	return NULL;
@@ -168,7 +168,7 @@ static int macvlan_hash_add_source(struct macvlan_dev *vlan,
 		return -ENOMEM;
 
 	ether_addr_copy(entry->addr, addr);
-	entry->vlan = vlan;
+	RCU_INIT_POINTER(entry->vlan, vlan);
 	h = &port->vlan_source_hash[macvlan_eth_hash(addr)];
 	hlist_add_head_rcu(&entry->hlist, h);
 	vlan->macaddr_count++;
@@ -187,6 +187,7 @@ static void macvlan_hash_add(struct macvlan_dev *vlan)
 
 static void macvlan_hash_del_source(struct macvlan_source_entry *entry)
 {
+	RCU_INIT_POINTER(entry->vlan, NULL);
 	hlist_del_rcu(&entry->hlist);
 	kfree_rcu(entry, rcu);
 }
@@ -390,7 +391,7 @@ static void macvlan_flush_sources(struct macvlan_port *port,
 	int i;
 
 	hash_for_each_safe(port->vlan_source_hash, i, next, entry, hlist)
-		if (entry->vlan == vlan)
+		if (rcu_access_pointer(entry->vlan) == vlan)
 			macvlan_hash_del_source(entry);
 
 	vlan->macaddr_count = 0;
@@ -433,9 +434,14 @@ static bool macvlan_forward_source(struct sk_buff *skb,
 
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
 
@@ -1680,7 +1686,7 @@ static int macvlan_fill_info_macaddr(struct sk_buff *skb,
 	struct macvlan_source_entry *entry;
 
 	hlist_for_each_entry_rcu(entry, h, hlist, lockdep_rtnl_is_held()) {
-		if (entry->vlan != vlan)
+		if (rcu_access_pointer(entry->vlan) != vlan)
 			continue;
 		if (nla_put(skb, IFLA_MACVLAN_MACADDR, ETH_ALEN, entry->addr))
 			return 1;
-- 
2.51.0



