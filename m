Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621609;
	b=noNKzZE+Yx59/QCe1HbJovWhhRPOqDXfsdswfxqRr7AEpYzHV+sKGp6hMeoS5bvkoiMG
	 CQ4w8PY26GsmBPVXITfySZvXSKxIPDbqbUnEPeHOgE8LtsOPUs6+hfg4ISllNf7ukaJ9j
	 /xUXNsqyvwVwF7Y2AXEbbxvvdUpBIA+zVlDLhTiqtmSNkhMXLjXWUsUBpDugAiSmNLtBc
	 J50mcoh7HVDkjQ7QaYwJl1I5PBNwW1MiZYFjr/WjGnOTqyvKdHZSKgaGDSMDhL7xVrD1q
	 MQMVHPkngYPX9ESLfUHCaxq5OPHLHnZSNbXaNyEqUMCK6zrv2SZX+KEWma7e5LkJZUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gec/UjiXo1YQLzy840t9MkOTsusSKGKUHx5RAOQwzZU=;
	b=OQOmUJtpSZBGy6uJK0+a3VZUo8/36TkVn7m9vR+8FS8ttsEjvpdEFzVNUA7bXHFpqtBb
	 AB+aFpdFIHn7O1k1K5V3oyec1fX687ai4/IR2I2C5h0t1Nsg7t6VNfRFUYOnih7smHCqv
	 PKgEoxzB9K6LROyd58fZqOzu7eHbQXydBcnqYUuctvK50cKlHwnO4caMGd80D5zFQXNl4
	 GjPLPWbzl2sRRZELImv4bdr0zYKf01qwoWiBBebtf7X1fNCgAU+dS8PB1f8uB919E7Vzv
	 t4KPKlTCXSjbyjmy8LCraVs06pg3GJ7EEs/OMDgrb/ZPdH0WSnPUAGinJoQCLqjXYRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KEf9Cwgx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B238D606A685;
	Wed, 25 Nov 2026 15:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KEf9Cwgx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85B51F000D0;
	Wed, 25 Nov 2026 15:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621609;
	bh=Gec/UjiXo1YQLzy840t9MkOTsusSKGKUHx5RAOQwzZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEf9Cwgx85+P5D18k49UXnlarCBBgHrqR+/nkWLVXBt5EdNR55ZybBtG/iO4rPEV5
	 M4UiiCqjqBIfMw4ViaWu7E4+6a/Mj3c/Tzd0hYKBALelklTpipSjJvSLJuD6rvIolj
	 GDgyAyyRL6CaSHs1h2SIR+ufYh4QFn8B8J0I2OMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 280/990] net: bonding: dont recurse on the slaves netdev ops lock
Date: Wed, 25 Nov 2026 15:27:27 +0100
Message-ID: <20261125143828.643760582@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 107b097790e903651385a96dd96f9be158702730 ]

bond_update_speed_duplex() calls __ethtool_get_link_ksettings() on
the slave, which will soon take the slave's ops lock. One of its
callers already holds it and the other three don't, so the function
would either deadlock or run unprotected depending on the path.

Make the helper expect the slave's ops lock held and switch to
netif_get_link_ksettings(). Wrap the three call sites that don't
already hold it:

  * bond_enslave() (rtnl held; core drops the lower's ops lock
    around ->ndo_add_slave).
  * bond_miimon_commit() (rtnl_trylock'd from the mii workqueue).
  * bond_ethtool_get_link_ksettings() (rtnl held via ethtool layer,
    bond device itself is not ops locked).

The call site which does already hold the ops lock is
bond_slave_netdev_event() via NETDEV_UP / NETDEV_CHANGE notifiers,
so it stays as-is.

Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260603012840.2254293-6-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a76ab5e733b4 ("bonding: fix missing down path on speed/duplex failure after FAIL->UP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 7066059ff3e28..4e6a4350a6590 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -789,6 +789,10 @@ int bond_set_carrier(struct bonding *bond)
  * values are invalid, set speed and duplex to -1,
  * and return. Return 1 if speed or duplex settings are
  * UNKNOWN; 0 otherwise.
+ *
+ * Caller must hold the slave's netdev ops lock. The notifier path
+ * (bond_netdev_event NETDEV_CHANGE/UP) reaches us with the slave's ops
+ * lock held; other call sites take it explicitly.
  */
 static int bond_update_speed_duplex(struct slave *slave)
 {
@@ -796,7 +800,7 @@ static int bond_update_speed_duplex(struct slave *slave)
 	struct ethtool_link_ksettings ecmd;
 	int res;
 
-	res = __ethtool_get_link_ksettings(slave_dev, &ecmd);
+	res = netif_get_link_ksettings(slave_dev, &ecmd);
 	if (res < 0)
 		goto speed_duplex_unknown;
 	if (ecmd.base.speed == 0 || ecmd.base.speed == ((__u32)-1))
@@ -2114,8 +2118,10 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	new_slave->delay = 0;
 	new_slave->link_failure_count = 0;
 
-	if (bond_update_speed_duplex(new_slave) &&
-	    bond_needs_speed_duplex(bond))
+	netdev_lock_ops(slave_dev);
+	res = bond_update_speed_duplex(new_slave);
+	netdev_unlock_ops(slave_dev);
+	if (res && bond_needs_speed_duplex(bond))
 		new_slave->link = BOND_LINK_DOWN;
 
 	new_slave->last_rx = jiffies -
@@ -2780,6 +2786,7 @@ static void bond_miimon_commit(struct bonding *bond)
 	struct slave *slave, *primary, *active;
 	bool do_failover = false;
 	struct list_head *iter;
+	int err;
 
 	ASSERT_RTNL();
 
@@ -2798,8 +2805,10 @@ static void bond_miimon_commit(struct bonding *bond)
 			continue;
 
 		case BOND_LINK_UP:
-			if (bond_update_speed_duplex(slave) &&
-			    bond_needs_speed_duplex(bond)) {
+			netdev_lock_ops(slave->dev);
+			err = bond_update_speed_duplex(slave);
+			netdev_unlock_ops(slave->dev);
+			if (err && bond_needs_speed_duplex(bond)) {
 				slave->link = BOND_LINK_DOWN;
 				if (net_ratelimit())
 					slave_warn(bond->dev, slave->dev,
@@ -5857,7 +5866,9 @@ static int bond_ethtool_get_link_ksettings(struct net_device *bond_dev,
 	 */
 	bond_for_each_slave(bond, slave, iter) {
 		if (bond_slave_can_tx(slave)) {
+			netdev_lock_ops(slave->dev);
 			bond_update_speed_duplex(slave);
+			netdev_unlock_ops(slave->dev);
 			if (slave->speed != SPEED_UNKNOWN) {
 				if (BOND_MODE(bond) == BOND_MODE_BROADCAST)
 					speed = bond_mode_bcast_speed(slave,
-- 
2.53.0



