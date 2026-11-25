Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621613;
	b=se8KzZsBCnBR3SdpziF01ZkGYaq6sBPEzAE6qcJ8SLSmcHTJdF0XueWWf3eDMzDzdQlx
	 l3YqPVS01h7s2V+O+dOzQz3fd/BqOTH//5vxuLXtyAZE+mqIG5WyO31kQgNImofVJEz7q
	 ZI+LSpRbrtGGtP1JPvjl7f/zFdA+hpR9dw6iAAJlhM4a6VxbvCfxxIOOMXTlUZm9Eeu9n
	 si/spn287H8XAStJuoQ9lpT23vfRA2ff//9PlMMr5yphU15sQNLMa2BOPnm7VTWPSXPYr
	 om6Bb+X+RNdwwi/HIF+HfAbyWotjzHqaEJiznlNoG0cvgZupwIXyrm6vesbfuX81Dag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K86Ax1QAfyNscmGTeDOD2NOVAjmWdzTLAS7Dx1ySYu4=;
	b=11BOafYwfhswWy2tnEEf/vJJEuebuZ8ohBhsfDZMqBqT7n6RtyP1JYbePjXblr/iwV7d
	 csFxLRWeb+84VcRVhB0xDDRDgG3pAwY3nac/To3vFd1H3yTZIs1WETjm3vTouTXG8tIB3
	 dL6v8GGIEGfWKZsKeCYvcrBva4qBtcjN44g44aMo8n/gmR+TerVbNDX006YALyp16s7t6
	 VIXhixCtNGsCE3r02bmc9rfs5uF3AarwN41alyy3TvrLiufKGAss5TW5XDpYuoe2zG3RE
	 OhijPJwubvp127VuYl5IX+4i2fdSTQSHM1OukskubIfR5x0gdve+aAoCzjpjzPuyr4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPHUy+7h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28499606A337;
	Wed, 25 Nov 2026 15:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPHUy+7h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464DD1F000E6;
	Wed, 25 Nov 2026 15:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621612;
	bh=K86Ax1QAfyNscmGTeDOD2NOVAjmWdzTLAS7Dx1ySYu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPHUy+7hHlbwku88ck1VkqMf7K6T7rMXuJjIdcq5zdBi+lFCbvJqsWzxSAe2TLc0d
	 HK9jrNCQJgRSWSuaYw2f5i7m7vbu1cmcade0+gjiAtsMx6pAU5TKthiEysgUyVJ0KA
	 MRMh1oIRs65BLOsbrSu40BkSRqStrnCHvARhNsNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Stukan <timur.stukan.linux@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 281/990] bonding: fix missing down path on speed/duplex failure after FAIL->UP
Date: Wed, 25 Nov 2026 15:27:28 +0100
Message-ID: <20261125143828.666194322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Stukan <timur.stukan.linux@gmail.com>

[ Upstream commit a76ab5e733b41dede6f238a691eefb4374f99f79 ]

In bond_miimon_commit(), when a slave is proposed as BOND_LINK_UP but
bond_update_speed_duplex() fails in bonding mode that needs speed/duplex
(802.3ad, tlb, alb), the slave is set to BOND_LINK_DOWN directly. This
bypasses bond_set_slave_link_state(), bond_miimon_link_change() and
failover.

This is fine for slave that coming from BOND_LINK_BACK, which was never
brought up and is not in use. But since commit 1899bb325149 ("bonding:
fix state transition issue in link monitoring") the commit phase also
handles BOND_LINK_FAIL -> BOND_LINK_UP which means a slave that is still
in use and may be curr_active_slave.

If the link recovers within downdelay and goes down again before the
commit phase reads speed/duplex, the slave is silently marked down while
remaining the active slave in worst cases. In alb/tlb the bond MAC stays
on the dead port, no failover happens and TLB/RLB state is not cleaned,
so the bond stops passing traffic until that link comes back even though
other slaves are up. A non-active slave is affected too, in alb, RLB
clients assigned to it are not reassigned and become unreachable.

Reproduced in tlb and alb mode with miimon=100 and downdelay=10000 by
flapping a slave within downdelay and dropping it again before commit
(a longer delay was added between inspect and commit to make window
wider and easier to test):
  bond0: (slave enp0s3): link status down for interface, disabling it in 10000 ms
  bond0: (slave enp0s3): link status up again after 3400 ms
  bond0: (slave enp0s3): failed to get link speed/duplex

procfs then shows the active slave with "MII Status: down" and "Link
Failure Count: 0", and all traffic is lost.

Fix this by dropping the loop in bond_mii_monitor() that applied all
proposed link states before bond_miimon_commit(). bond_miimon_commit()
now applies each state itself: UP after the speed/duplex check, as it
already did, DOWN in the down path, and FAIL/BACK directly. So when the
speed/duplex check runs, slave->link still holds the previous state. If
the check fails for a slave that is FAIL or UP, take it through the
regular down path, including failover. DOWN and BACK slaves were
never brought up and are still just reverted to DOWN. The down path is
moved into bond_miimon_slave_down() so both callers share it.

After the fix:
  bond0: (slave enp0s3): failed to get link speed/duplex
  bond0: (slave enp0s3): link status definitely down, disabling slave
  bond0: (slave enp0s4): making interface the new active one

Fixes: 1899bb325149 ("bonding: fix state transition issue in link monitoring")
Signed-off-by: Timur Stukan <timur.stukan.linux@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20261101150240.66292-1-timur.stukan.linux@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 63 +++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 26 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 4e6a4350a6590..ca2ea493c81a3 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2781,6 +2781,27 @@ static void bond_miimon_link_change(struct bonding *bond,
 	}
 }
 
+static bool bond_miimon_slave_down(struct bonding *bond,
+				   struct slave *slave)
+{
+	if (slave->link_failure_count < UINT_MAX)
+		slave->link_failure_count++;
+
+	bond_set_slave_link_state(slave, BOND_LINK_DOWN,
+				  BOND_SLAVE_NOTIFY_NOW);
+
+	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP ||
+	    BOND_MODE(bond) == BOND_MODE_8023AD)
+		bond_set_slave_inactive_flags(slave,
+					      BOND_SLAVE_NOTIFY_NOW);
+
+	slave_info(bond->dev, slave->dev, "link status definitely down, disabling slave\n");
+
+	bond_miimon_link_change(bond, slave, BOND_LINK_DOWN);
+
+	return slave == rcu_access_pointer(bond->curr_active_slave);
+}
+
 static void bond_miimon_commit(struct bonding *bond)
 {
 	struct slave *slave, *primary, *active;
@@ -2809,10 +2830,22 @@ static void bond_miimon_commit(struct bonding *bond)
 			err = bond_update_speed_duplex(slave);
 			netdev_unlock_ops(slave->dev);
 			if (err && bond_needs_speed_duplex(bond)) {
-				slave->link = BOND_LINK_DOWN;
 				if (net_ratelimit())
 					slave_warn(bond->dev, slave->dev,
 						   "failed to get link speed/duplex\n");
+				/* Coming from FAIL/UP, the slave may still be
+				 * in use and may be curr_active_slave, so take
+				 * it through the full down path. Coming from
+				 * DOWN/BACK, it was never brought up, so just
+				 * revert it to DOWN.
+				 */
+				if (slave->link == BOND_LINK_FAIL ||
+				    slave->link == BOND_LINK_UP) {
+					if (bond_miimon_slave_down(bond, slave))
+						do_failover = true;
+					continue;
+				}
+				slave->link = BOND_LINK_DOWN;
 				continue;
 			}
 			bond_set_slave_link_state(slave, BOND_LINK_UP,
@@ -2841,28 +2874,13 @@ static void bond_miimon_commit(struct bonding *bond)
 			continue;
 
 		case BOND_LINK_DOWN:
-			if (slave->link_failure_count < UINT_MAX)
-				slave->link_failure_count++;
-
-			bond_set_slave_link_state(slave, BOND_LINK_DOWN,
-						  BOND_SLAVE_NOTIFY_NOW);
-
-			if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP ||
-			    BOND_MODE(bond) == BOND_MODE_8023AD)
-				bond_set_slave_inactive_flags(slave,
-							      BOND_SLAVE_NOTIFY_NOW);
-
-			slave_info(bond->dev, slave->dev, "link status definitely down, disabling slave\n");
-
-			bond_miimon_link_change(bond, slave, BOND_LINK_DOWN);
-
-			if (slave == rcu_access_pointer(bond->curr_active_slave))
+			if (bond_miimon_slave_down(bond, slave))
 				do_failover = true;
-
 			continue;
 
 		case BOND_LINK_FAIL:
 		case BOND_LINK_BACK:
+			bond_commit_link_state(slave, BOND_SLAVE_NOTIFY_LATER);
 			slave_dbg(bond->dev, slave->dev, "link_new_state %d on slave\n",
 				  slave->link_new_state);
 			continue;
@@ -2896,8 +2914,6 @@ static void bond_mii_monitor(struct work_struct *work)
 {
 	struct bonding *bond = container_of(work, struct bonding,
 					    mii_work.work);
-	struct list_head *iter;
-	struct slave *slave;
 	unsigned long delay;
 	bool commit;
 
@@ -2919,13 +2935,8 @@ static void bond_mii_monitor(struct work_struct *work)
 			goto re_arm;
 		}
 
-		if (commit) {
-			bond_for_each_slave(bond, slave, iter) {
-				bond_commit_link_state(slave,
-						       BOND_SLAVE_NOTIFY_LATER);
-			}
+		if (commit)
 			bond_miimon_commit(bond);
-		}
 
 		if (bond->send_peer_notif)
 			bond_peer_notify_may_events(bond, true);
-- 
2.53.0



