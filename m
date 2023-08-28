Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDC1611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D17C433C7;
	Mon, 28 Aug 2023 10:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219334;
	bh=ia8JMGiktv1f2yyBJMELz9JDYTyb5VLP/y1FSzMN20k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fk8EDRf/DzaITFQkHjoLS31WOLsE+JYbGCeJ1YgO9lKTXAJSfX6nnVtdyqZYmphOL
	 JXrClfl8pT4XXBQ+UJX182PhglAb66mviy9E4v5fzAA/pFDGCxhKrT6lfB4wBdblhw
	 dLnKa6b6vPwmLB4Lf06EGxOBqCM8Ck1JwHkCtK0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	susan.zheng@veritas.com,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/158] bonding: fix macvlan over alb bond support
Date: Mon, 28 Aug 2023 12:13:46 +0200
Message-ID: <20230828101201.778131129@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit e74216b8def3803e98ae536de78733e9d7f3b109 ]

The commit 14af9963ba1e ("bonding: Support macvlans on top of tlb/rlb mode
bonds") aims to enable the use of macvlans on top of rlb bond mode. However,
the current rlb bond mode only handles ARP packets to update remote neighbor
entries. This causes an issue when a macvlan is on top of the bond, and
remote devices send packets to the macvlan using the bond's MAC address
as the destination. After delivering the packets to the macvlan, the macvlan
will rejects them as the MAC address is incorrect. Consequently, this commit
makes macvlan over bond non-functional.

To address this problem, one potential solution is to check for the presence
of a macvlan port on the bond device using netif_is_macvlan_port(bond->dev)
and return NULL in the rlb_arp_xmit() function. However, this approach
doesn't fully resolve the situation when a VLAN exists between the bond and
macvlan.

So let's just do a partial revert for commit 14af9963ba1e in rlb_arp_xmit().
As the comment said, Don't modify or load balance ARPs that do not originate
locally.

Fixes: 14af9963ba1e ("bonding: Support macvlans on top of tlb/rlb mode bonds")
Reported-by: susan.zheng@veritas.com
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2117816
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_alb.c |  6 +++---
 include/net/bonding.h          | 11 +----------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 20114e1dde77e..6df78a36bafde 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -656,10 +656,10 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 		return NULL;
 	arp = (struct arp_pkt *)skb_network_header(skb);
 
-	/* Don't modify or load balance ARPs that do not originate locally
-	 * (e.g.,arrive via a bridge).
+	/* Don't modify or load balance ARPs that do not originate
+	 * from the bond itself or a VLAN directly above the bond.
 	 */
-	if (!bond_slave_has_mac_rx(bond, arp->mac_src))
+	if (!bond_slave_has_mac_rcu(bond, arp->mac_src))
 		return NULL;
 
 	if (arp->op_code == htons(ARPOP_REPLY)) {
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 4e1e589aae057..9e9ccbade3b54 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -686,23 +686,14 @@ static inline struct slave *bond_slave_has_mac(struct bonding *bond,
 }
 
 /* Caller must hold rcu_read_lock() for read */
-static inline bool bond_slave_has_mac_rx(struct bonding *bond, const u8 *mac)
+static inline bool bond_slave_has_mac_rcu(struct bonding *bond, const u8 *mac)
 {
 	struct list_head *iter;
 	struct slave *tmp;
-	struct netdev_hw_addr *ha;
 
 	bond_for_each_slave_rcu(bond, tmp, iter)
 		if (ether_addr_equal_64bits(mac, tmp->dev->dev_addr))
 			return true;
-
-	if (netdev_uc_empty(bond->dev))
-		return false;
-
-	netdev_for_each_uc_addr(ha, bond->dev)
-		if (ether_addr_equal_64bits(mac, ha->addr))
-			return true;
-
 	return false;
 }
 
-- 
2.40.1



