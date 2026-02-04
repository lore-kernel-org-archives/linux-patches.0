Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9A91C84D0;
	Wed,  4 Feb 2026 15:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218643; cv=none; b=FWHsLfIQeRPob6o77y/wTlubmT2XZ5J5fxjIUQHtvP6z9tXA4G85bxzRA10eGQXnKo51xZC/x8nsIs10mK5FfGBTWWLcKsdD7Z1n+w/oDk6JsBN182tF0ViyecmvPG7WRo9LX92Cj099k+iRH6mfLd4+X+W+w115a0BxU3fFBFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218643; c=relaxed/simple;
	bh=TkXcCn1NYCnGSDZxeuk1/xQDrr/vS1iiUItVmf2Ri94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CySgQXvOO4NOqRVBJi7yRbcmwJlqGyBxgM27b8R9DbwLQD45UK8s/aM8yOfHEBaswXW7dBDTECAdrHsooFyL7/fMWxUB5SM1jM3LE6FyHRQ87Y4ycPOkJ/DHhnbwT16rS2jxSxJ+52zqgthNooM+ysVdlZspgksN98l2VQtLdiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnQlZxEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnQlZxEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DB0C4CEF7;
	Wed,  4 Feb 2026 15:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218643;
	bh=TkXcCn1NYCnGSDZxeuk1/xQDrr/vS1iiUItVmf2Ri94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnQlZxEtWStUbSXQjuI+JSbzxBTwDwS4/DuaCtb1yyF7vOG9vmYXoLFT2v1a5VBTI
	 AGWuw+46LtP1k/jDD2oQsfl3WjDIePs0BpLb42v036SK2zuN/OFttsRf6wzeastKCc
	 q7Je7pb4IXYhAaX+cBXsnyEzDvV4EhaoT/daZwLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot <syzkaller@googlegroups.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 08/87] bonding: annotate data-races around slave->last_rx
Date: Wed,  4 Feb 2026 15:40:06 +0100
Message-ID: <20260204143847.212965150@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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
index b52f5f64e3abb..209cab75ac0a5 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3214,8 +3214,8 @@ static void bond_validate_arp(struct bonding *bond, struct slave *slave, __be32
 			   __func__, &sip);
 		return;
 	}
-	slave->last_rx = jiffies;
-	slave->target_last_arp_rx[i] = jiffies;
+	WRITE_ONCE(slave->last_rx, jiffies);
+	WRITE_ONCE(slave->target_last_arp_rx[i], jiffies);
 }
 
 static int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond,
@@ -3434,8 +3434,8 @@ static void bond_validate_na(struct bonding *bond, struct slave *slave,
 			  __func__, saddr);
 		return;
 	}
-	slave->last_rx = jiffies;
-	slave->target_last_arp_rx[i] = jiffies;
+	WRITE_ONCE(slave->last_rx, jiffies);
+	WRITE_ONCE(slave->target_last_arp_rx[i], jiffies);
 }
 
 static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
@@ -3505,7 +3505,7 @@ int bond_rcv_validate(const struct sk_buff *skb, struct bonding *bond,
 		    (slave_do_arp_validate_only(bond) && is_ipv6) ||
 #endif
 		    !slave_do_arp_validate_only(bond))
-			slave->last_rx = jiffies;
+			WRITE_ONCE(slave->last_rx, jiffies);
 		return RX_HANDLER_ANOTHER;
 	} else if (is_arp) {
 		return bond_arp_rcv(skb, bond, slave);
@@ -3573,7 +3573,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 
 		if (slave->link != BOND_LINK_UP) {
 			if (bond_time_in_interval(bond, last_tx, 1) &&
-			    bond_time_in_interval(bond, slave->last_rx, 1)) {
+			    bond_time_in_interval(bond, READ_ONCE(slave->last_rx), 1)) {
 
 				bond_propose_link_state(slave, BOND_LINK_UP);
 				slave_state_changed = 1;
@@ -3597,8 +3597,10 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
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
index 28c53f1b13826..a37b47b8ea8ed 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1124,7 +1124,7 @@ static void _bond_options_arp_ip_target_set(struct bonding *bond, int slot,
 
 	if (slot >= 0 && slot < BOND_MAX_ARP_TARGETS) {
 		bond_for_each_slave(bond, slave, iter)
-			slave->target_last_arp_rx[slot] = last_rx;
+			WRITE_ONCE(slave->target_last_arp_rx[slot], last_rx);
 		targets[slot] = target;
 	}
 }
@@ -1193,8 +1193,8 @@ static int bond_option_arp_ip_target_rem(struct bonding *bond, __be32 target)
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
@@ -1349,7 +1349,7 @@ static void _bond_options_ns_ip6_target_set(struct bonding *bond, int slot,
 
 	if (slot >= 0 && slot < BOND_MAX_NS_TARGETS) {
 		bond_for_each_slave(bond, slave, iter) {
-			slave->target_last_arp_rx[slot] = last_rx;
+			WRITE_ONCE(slave->target_last_arp_rx[slot], last_rx);
 			slave_set_ns_maddr(bond, slave, target, &targets[slot]);
 		}
 		targets[slot] = *target;
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 95f67b308c19a..9fb40a5920209 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -519,13 +519,14 @@ static inline int bond_is_ip6_target_ok(struct in6_addr *addr)
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
 
@@ -535,7 +536,7 @@ static inline unsigned long slave_last_rx(struct bonding *bond,
 	if (bond->params.arp_all_targets == BOND_ARP_TARGETS_ALL)
 		return slave_oldest_target_arp_rx(bond, slave);
 
-	return slave->last_rx;
+	return READ_ONCE(slave->last_rx);
 }
 
 static inline void slave_update_last_tx(struct slave *slave)
-- 
2.51.0



