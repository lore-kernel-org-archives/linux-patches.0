Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DDE423161;
	Wed,  4 Feb 2026 15:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218034; cv=none; b=UfvR94d4WPJxuGPALYE1sI7sdsns6ur8YtxJERFdV73vy+uOBIBjl5luW5SWK1Hv2QYU7gwPJ7ZxtXGXoY88AYSy90F6HKx1DVzx70bEx4q1d1S1koC6o/Yzov3odfs5NPLgIFMQwluCz4AhX73itN+L4V6u80JR9MvKw5cXtis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218034; c=relaxed/simple;
	bh=eY8Jg8oAtbRedj33wXXd3UslBKg9or4elCkURKWEY7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sw845cNhW2G9sbZchtcvkrNKM9SOU5LQUqh9yTm3elHCsoK8B9cUyNFeBOm7swqRJArvSbiH3HJQLGEoE0mU21VEW0M5MEvjpzrCSfLKY0dd7bt0DFA8Xs+NNTsZNkRYYTkNFPu6i35gFb5LssC4wSNIk94o8RPdX0cUHFM/0V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiTmIMiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiTmIMiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A28C4CEF7;
	Wed,  4 Feb 2026 15:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218034;
	bh=eY8Jg8oAtbRedj33wXXd3UslBKg9or4elCkURKWEY7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiTmIMiwJG5r62W6EabisSObyFN6NIxQ87oPB68WfrbImDBA0wqJU1/4r+QCmo939
	 UKvb0D1HjjcwuIJiGGRnLmdClazc7s05CbWGpflFWAROJtebhGcPz0c0ASWs0RwmDy
	 M8zvpndOkWJuG4gJuw/5B2tG75iIN+1Dx1BTwHNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot <syzkaller@googlegroups.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/280] bonding: annotate data-races around slave->last_rx
Date: Wed,  4 Feb 2026 15:39:25 +0100
Message-ID: <20260204143916.483275422@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f6c3665b6dc53c3ab7d31b585446a953a74340ef ]

slave->last_rx and slave->target_last_arp_rx[...] can be read and written
locklessly. Add READ_ONCE() and WRITE_ONCE() annotations.

syzbot reported:

BUG: KCSAN: data-race in bond_rcv_validate / bond_rcv_validate

write to 0xffff888149f0d428 of 8 bytes by interrupt on cpu 1:
  bond_rcv_validate+0x202/0x7a0 drivers/net/bonding/bond_main.c:3335
  bond_handle_frame+0xde/0x5e0 drivers/net/bonding/bond_main.c:1533
  __netif_receive_skb_core+0x5b1/0x1950 net/core/dev.c:6039
  __netif_receive_skb_one_core net/core/dev.c:6150 [inline]
  __netif_receive_skb+0x59/0x270 net/core/dev.c:6265
  netif_receive_skb_internal net/core/dev.c:6351 [inline]
  netif_receive_skb+0x4b/0x2d0 net/core/dev.c:6410
...

write to 0xffff888149f0d428 of 8 bytes by interrupt on cpu 0:
  bond_rcv_validate+0x202/0x7a0 drivers/net/bonding/bond_main.c:3335
  bond_handle_frame+0xde/0x5e0 drivers/net/bonding/bond_main.c:1533
  __netif_receive_skb_core+0x5b1/0x1950 net/core/dev.c:6039
  __netif_receive_skb_one_core net/core/dev.c:6150 [inline]
  __netif_receive_skb+0x59/0x270 net/core/dev.c:6265
  netif_receive_skb_internal net/core/dev.c:6351 [inline]
  netif_receive_skb+0x4b/0x2d0 net/core/dev.c:6410
  br_netif_receive_skb net/bridge/br_input.c:30 [inline]
  NF_HOOK include/linux/netfilter.h:318 [inline]
...

value changed: 0x0000000100005365 -> 0x0000000100005366

Fixes: f5b2b966f032 ("[PATCH] bonding: Validate probe replies in ARP monitor")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://patch.msgid.link/20260122162914.2299312-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c    | 18 ++++++++++--------
 drivers/net/bonding/bond_options.c |  8 ++++----
 include/net/bonding.h              | 13 +++++++------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b0bc811aaab91..71912ddfa7149 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3082,8 +3082,8 @@ static void bond_validate_arp(struct bonding *bond, struct slave *slave, __be32
 			   __func__, &sip);
 		return;
 	}
-	slave->last_rx = jiffies;
-	slave->target_last_arp_rx[i] = jiffies;
+	WRITE_ONCE(slave->last_rx, jiffies);
+	WRITE_ONCE(slave->target_last_arp_rx[i], jiffies);
 }
 
 static int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond,
@@ -3302,8 +3302,8 @@ static void bond_validate_na(struct bonding *bond, struct slave *slave,
 			  __func__, saddr);
 		return;
 	}
-	slave->last_rx = jiffies;
-	slave->target_last_arp_rx[i] = jiffies;
+	WRITE_ONCE(slave->last_rx, jiffies);
+	WRITE_ONCE(slave->target_last_arp_rx[i], jiffies);
 }
 
 static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
@@ -3373,7 +3373,7 @@ int bond_rcv_validate(const struct sk_buff *skb, struct bonding *bond,
 		    (slave_do_arp_validate_only(bond) && is_ipv6) ||
 #endif
 		    !slave_do_arp_validate_only(bond))
-			slave->last_rx = jiffies;
+			WRITE_ONCE(slave->last_rx, jiffies);
 		return RX_HANDLER_ANOTHER;
 	} else if (is_arp) {
 		return bond_arp_rcv(skb, bond, slave);
@@ -3441,7 +3441,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 
 		if (slave->link != BOND_LINK_UP) {
 			if (bond_time_in_interval(bond, last_tx, 1) &&
-			    bond_time_in_interval(bond, slave->last_rx, 1)) {
+			    bond_time_in_interval(bond, READ_ONCE(slave->last_rx), 1)) {
 
 				bond_propose_link_state(slave, BOND_LINK_UP);
 				slave_state_changed = 1;
@@ -3465,8 +3465,10 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 			 * when the source ip is 0, so don't take the link down
 			 * if we don't know our ip yet
 			 */
-			if (!bond_time_in_interval(bond, last_tx, bond->params.missed_max) ||
-			    !bond_time_in_interval(bond, slave->last_rx, bond->params.missed_max)) {
+			if (!bond_time_in_interval(bond, last_tx,
+						   bond->params.missed_max) ||
+			    !bond_time_in_interval(bond, READ_ONCE(slave->last_rx),
+						   bond->params.missed_max)) {
 
 				bond_propose_link_state(slave, BOND_LINK_DOWN);
 				slave_state_changed = 1;
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 1235878d87159..9473e76c6dc9d 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1133,7 +1133,7 @@ static void _bond_options_arp_ip_target_set(struct bonding *bond, int slot,
 
 	if (slot >= 0 && slot < BOND_MAX_ARP_TARGETS) {
 		bond_for_each_slave(bond, slave, iter)
-			slave->target_last_arp_rx[slot] = last_rx;
+			WRITE_ONCE(slave->target_last_arp_rx[slot], last_rx);
 		targets[slot] = target;
 	}
 }
@@ -1202,8 +1202,8 @@ static int bond_option_arp_ip_target_rem(struct bonding *bond, __be32 target)
 	bond_for_each_slave(bond, slave, iter) {
 		targets_rx = slave->target_last_arp_rx;
 		for (i = ind; (i < BOND_MAX_ARP_TARGETS-1) && targets[i+1]; i++)
-			targets_rx[i] = targets_rx[i+1];
-		targets_rx[i] = 0;
+			WRITE_ONCE(targets_rx[i], READ_ONCE(targets_rx[i+1]));
+		WRITE_ONCE(targets_rx[i], 0);
 	}
 	for (i = ind; (i < BOND_MAX_ARP_TARGETS-1) && targets[i+1]; i++)
 		targets[i] = targets[i+1];
@@ -1358,7 +1358,7 @@ static void _bond_options_ns_ip6_target_set(struct bonding *bond, int slot,
 
 	if (slot >= 0 && slot < BOND_MAX_NS_TARGETS) {
 		bond_for_each_slave(bond, slave, iter) {
-			slave->target_last_arp_rx[slot] = last_rx;
+			WRITE_ONCE(slave->target_last_arp_rx[slot], last_rx);
 			slave_set_ns_maddr(bond, slave, target, &targets[slot]);
 		}
 		targets[slot] = *target;
diff --git a/include/net/bonding.h b/include/net/bonding.h
index bfd3e4e58f861..bdfbe77c18420 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -525,13 +525,14 @@ static inline int bond_is_ip6_target_ok(struct in6_addr *addr)
 static inline unsigned long slave_oldest_target_arp_rx(struct bonding *bond,
 						       struct slave *slave)
 {
+	unsigned long tmp, ret = READ_ONCE(slave->target_last_arp_rx[0]);
 	int i = 1;
-	unsigned long ret = slave->target_last_arp_rx[0];
-
-	for (; (i < BOND_MAX_ARP_TARGETS) && bond->params.arp_targets[i]; i++)
-		if (time_before(slave->target_last_arp_rx[i], ret))
-			ret = slave->target_last_arp_rx[i];
 
+	for (; (i < BOND_MAX_ARP_TARGETS) && bond->params.arp_targets[i]; i++) {
+		tmp = READ_ONCE(slave->target_last_arp_rx[i]);
+		if (time_before(tmp, ret))
+			ret = tmp;
+	}
 	return ret;
 }
 
@@ -541,7 +542,7 @@ static inline unsigned long slave_last_rx(struct bonding *bond,
 	if (bond->params.arp_all_targets == BOND_ARP_TARGETS_ALL)
 		return slave_oldest_target_arp_rx(bond, slave);
 
-	return slave->last_rx;
+	return READ_ONCE(slave->last_rx);
 }
 
 static inline void slave_update_last_tx(struct slave *slave)
-- 
2.51.0



