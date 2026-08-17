Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478B6446BEA;
	Mon, 17 Aug 2026 15:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980315; cv=none; b=MgnHrnISvUwoHlkhTXp7usw3BrjRReo5mCdoVXeZn1RS57BU5yAbQvlzQH4ICcJA6akSvXXiqooqUiDhMMKjOMBNc9b1LZ0ZTNyH49ehht90xWP9axomlrHReQHX8sd7KDkcZFCD7fVVUQDv52okhsb7kdhP6sipbTDVslbp3vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980315; c=relaxed/simple;
	bh=wYGGdqzZWmYARQ0iJobqJXJRtTKOguWEzIJld4qYrhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NF8YEdh/bRXiggEFfyHG1gtpmuNFrzXSC6YZltrQZi70F7sM7J18wbbZe/TkOSwVd8nJFFsXfZhtp04GNT6fn3HnoAPm+30vVOCdAAq5P936xg2Un8em4bd2vHLfz95XDy1P2fIXlY6Te7aR6FRo1pAmn7rHUilJsNMza4CLsPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxRjdwg4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxRjdwg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35C41F000E9;
	Mon, 17 Aug 2026 15:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980314;
	bh=DC/lJEWHTI36SEwByzI4l2Q/MR3a38mq7lJW60Q1+eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gxRjdwg41nZrxvaGtMzq48Kv5CNYKfs2ztGRuZugyEdNwVd+djpJOAgbAsBVRvTRd
	 HiEOypFRNukqYVXy0Nkb+QIWkCqt3LzBW0M6dJxMIHqhTLpa35kal+gnuu5yb5t8B7
	 0mJshPOit9frcHSE86ABi+6z+3vrLibOGHY1KBaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 491/609] bonding: alb: re-check primary_is_promisc under RTNL in bond_alb_monitor
Date: Mon, 17 Aug 2026 15:33:07 +0200
Message-ID: <20260817132600.346223226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

[ Upstream commit 683c6ba6e58e6ed1037831ea97dd58d9c0e76b8d ]

bond_alb_monitor() reads primary_is_promisc under RCU, then drops RCU and
takes RTNL via rtnl_trylock() before undoing the promiscuity it set on the
active slave. In that window the active slave can change under RTNL
(RTM_DELLINK -> __bond_release_one() -> bond_alb_handle_active_change()),
which already drops the promiscuity and clears primary_is_promisc. The
monitor still acts on the stale decision: if the slave was removed with no
failover, curr_active_slave is now NULL and the deref faults; if it failed
over, the stale dev_set_promiscuity(-1) underflows the new slave's
promiscuity counter and pins it in IFF_PROMISC.

  Oops: general protection fault, probably for non-canonical address ...
  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  Workqueue: b42 bond_alb_monitor
  RIP: 0010:bond_alb_monitor (drivers/net/bonding/bond_alb.c:1600)
   process_one_work (kernel/workqueue.c:3322)
   worker_thread (kernel/workqueue.c:3486)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
  Kernel panic - not syncing: Fatal exception

Re-check primary_is_promisc (and curr_active_slave) after taking RTNL so
the monitor only undoes an increment it still owns. The other bonding
monitors already re-read state under RTNL in their commit phase
(bond_miimon_commit/bond_ab_arp_commit); bond_alb_monitor() was the only
one acting on the pre-trylock decision.

Fixes: d0e81b7e2246 ("bonding: Acquire correct locks in alb for promisc change")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20260725233930.2957317-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_alb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 9c4c2c7d90ef5..c44a9358f8b27 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1535,8 +1535,8 @@ void bond_alb_monitor(struct work_struct *work)
 	struct bonding *bond = container_of(work, struct bonding,
 					    alb_work.work);
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
+	struct slave *slave, *curr;
 	struct list_head *iter;
-	struct slave *slave;
 
 	if (!bond_has_slaves(bond)) {
 		atomic_set(&bond_info->tx_rebalance_counter, 0);
@@ -1598,9 +1598,11 @@ void bond_alb_monitor(struct work_struct *work)
 			 * because a slave was disabled then
 			 * it can now leave promiscuous mode.
 			 */
-			dev_set_promiscuity(rtnl_dereference(bond->curr_active_slave)->dev,
-					    -1);
-			bond_info->primary_is_promisc = 0;
+			curr = rtnl_dereference(bond->curr_active_slave);
+			if (bond_info->primary_is_promisc && curr) {
+				dev_set_promiscuity(curr->dev, -1);
+				bond_info->primary_is_promisc = 0;
+			}
 
 			rtnl_unlock();
 			rcu_read_lock();
-- 
2.53.0



