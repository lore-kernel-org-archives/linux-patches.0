Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862048F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B953C433C8;
	Sun, 16 Jul 2023 20:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539187;
	bh=eBFqGj+klypp+po74V7fpIC1o4JidAJQd3ZYdzuOVZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ji3tvNmWqLu3fL6KMIt4+m8Jk6jgsPVcNMm/lZ7Q5q/jOtgAQRSPxvOWXXHKtxuFF
	 Zs4/8k2K5tUPVeJYlKMusr9/BrGH2ZIE3ZPvblvJmH/++Or0z3DW531TvJ6SGjJu/q
	 LVRRGigYLZUKpINn+V7whbvHY5G4PVImkgYB0KXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 691/800] net: bridge: keep ports without IFF_UNICAST_FLT in BR_PROMISC mode
Date: Sun, 16 Jul 2023 21:49:04 +0200
Message-ID: <20230716195005.173909912@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 6ca3c005d0604e8d2b439366e3923ea58db99641 ]

According to the synchronization rules for .ndo_get_stats() as seen in
Documentation/networking/netdevices.rst, acquiring a plain spin_lock()
should not be illegal, but the bridge driver implementation makes it so.

After running these commands, I am being faced with the following
lockdep splat:

$ ip link add link swp0 name macsec0 type macsec encrypt on && ip link set swp0 up
$ ip link add dev br0 type bridge vlan_filtering 1 && ip link set br0 up
$ ip link set macsec0 master br0 && ip link set macsec0 up

  ========================================================
  WARNING: possible irq lock inversion dependency detected
  6.4.0-04295-g31b577b4bd4a #603 Not tainted
  --------------------------------------------------------
  swapper/1/0 just changed the state of lock:
  ffff6bd348724cd8 (&br->lock){+.-.}-{3:3}, at: br_forward_delay_timer_expired+0x34/0x198
  but this lock took another, SOFTIRQ-unsafe lock in the past:
   (&ocelot->stats_lock){+.+.}-{3:3}

  and interrupts could create inverse lock ordering between them.

  other info that might help us debug this:
  Chain exists of:
    &br->lock --> &br->hash_lock --> &ocelot->stats_lock

   Possible interrupt unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(&ocelot->stats_lock);
                                 local_irq_disable();
                                 lock(&br->lock);
                                 lock(&br->hash_lock);
    <Interrupt>
      lock(&br->lock);

   *** DEADLOCK ***

(details about the 3 locks skipped)

swp0 is instantiated by drivers/net/dsa/ocelot/felix.c, and this
only matters to the extent that its .ndo_get_stats64() method calls
spin_lock(&ocelot->stats_lock).

Documentation/locking/lockdep-design.rst says:

| A lock is irq-safe means it was ever used in an irq context, while a lock
| is irq-unsafe means it was ever acquired with irq enabled.

(...)

| Furthermore, the following usage based lock dependencies are not allowed
| between any two lock-classes::
|
|    <hardirq-safe>   ->  <hardirq-unsafe>
|    <softirq-safe>   ->  <softirq-unsafe>

Lockdep marks br->hash_lock as softirq-safe, because it is sometimes
taken in softirq context (for example br_fdb_update() which runs in
NET_RX softirq), and when it's not in softirq context it blocks softirqs
by using spin_lock_bh().

Lockdep marks ocelot->stats_lock as softirq-unsafe, because it never
blocks softirqs from running, and it is never taken from softirq
context. So it can always be interrupted by softirqs.

There is a call path through which a function that holds br->hash_lock:
fdb_add_hw_addr() will call a function that acquires ocelot->stats_lock:
ocelot_port_get_stats64(). This can be seen below:

ocelot_port_get_stats64+0x3c/0x1e0
felix_get_stats64+0x20/0x38
dsa_slave_get_stats64+0x3c/0x60
dev_get_stats+0x74/0x2c8
rtnl_fill_stats+0x4c/0x150
rtnl_fill_ifinfo+0x5cc/0x7b8
rtmsg_ifinfo_build_skb+0xe4/0x150
rtmsg_ifinfo+0x5c/0xb0
__dev_notify_flags+0x58/0x200
__dev_set_promiscuity+0xa0/0x1f8
dev_set_promiscuity+0x30/0x70
macsec_dev_change_rx_flags+0x68/0x88
__dev_set_promiscuity+0x1a8/0x1f8
__dev_set_rx_mode+0x74/0xa8
dev_uc_add+0x74/0xa0
fdb_add_hw_addr+0x68/0xd8
fdb_add_local+0xc4/0x110
br_fdb_add_local+0x54/0x88
br_add_if+0x338/0x4a0
br_add_slave+0x20/0x38
do_setlink+0x3a4/0xcb8
rtnl_newlink+0x758/0x9d0
rtnetlink_rcv_msg+0x2f0/0x550
netlink_rcv_skb+0x128/0x148
rtnetlink_rcv+0x24/0x38

the plain English explanation for it is:

The macsec0 bridge port is created without p->flags & BR_PROMISC,
because it is what br_manage_promisc() decides for a VLAN filtering
bridge with a single auto port.

As part of the br_add_if() procedure, br_fdb_add_local() is called for
the MAC address of the device, and this results in a call to
dev_uc_add() for macsec0 while the softirq-safe br->hash_lock is taken.

Because macsec0 does not have IFF_UNICAST_FLT, dev_uc_add() ends up
calling __dev_set_promiscuity() for macsec0, which is propagated by its
implementation, macsec_dev_change_rx_flags(), to the lower device: swp0.
This triggers the call path:

dev_set_promiscuity(swp0)
-> rtmsg_ifinfo()
   -> dev_get_stats()
      -> ocelot_port_get_stats64()

with a calling context that lockdep doesn't like (br->hash_lock held).

Normally we don't see this, because even though many drivers that can be
bridge ports don't support IFF_UNICAST_FLT, we need a driver that

(a) doesn't support IFF_UNICAST_FLT, *and*
(b) it forwards the IFF_PROMISC flag to another driver, and
(c) *that* driver implements ndo_get_stats64() using a softirq-unsafe
    spinlock.

Condition (b) is necessary because the first __dev_set_rx_mode() calls
__dev_set_promiscuity() with "bool notify=false", and thus, the
rtmsg_ifinfo() code path won't be entered.

The same criteria also hold true for DSA switches which don't report
IFF_UNICAST_FLT. When the DSA master uses a spin_lock() in its
ndo_get_stats64() method, the same lockdep splat can be seen.

I think the deadlock possibility is real, even though I didn't reproduce
it, and I'm thinking of the following situation to support that claim:

fdb_add_hw_addr() runs on a CPU A, in a context with softirqs locally
disabled and br->hash_lock held, and may end up attempting to acquire
ocelot->stats_lock.

In parallel, ocelot->stats_lock is currently held by a thread B (say,
ocelot_check_stats_work()), which is interrupted while holding it by a
softirq which attempts to lock br->hash_lock.

Thread B cannot make progress because br->hash_lock is held by A. Whereas
thread A cannot make progress because ocelot->stats_lock is held by B.

When taking the issue at face value, the bridge can avoid that problem
by simply making the ports promiscuous from a code path with a saner
calling context (br->hash_lock not held). A bridge port without
IFF_UNICAST_FLT is going to become promiscuous as soon as we call
dev_uc_add() on it (which we do unconditionally), so why not be
preemptive and make it promiscuous right from the beginning, so as to
not be taken by surprise.

With this, we've broken the links between code that holds br->hash_lock
or br->lock and code that calls into the ndo_change_rx_flags() or
ndo_get_stats64() ops of the bridge port.

Fixes: 2796d0c648c9 ("bridge: Automatically manage port promiscuous mode.")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_if.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 3f04b40f60568..2450690f98cfa 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -166,8 +166,9 @@ void br_manage_promisc(struct net_bridge *br)
 			 * This lets us disable promiscuous mode and write
 			 * this config to hw.
 			 */
-			if (br->auto_cnt == 0 ||
-			    (br->auto_cnt == 1 && br_auto_port(p)))
+			if ((p->dev->priv_flags & IFF_UNICAST_FLT) &&
+			    (br->auto_cnt == 0 ||
+			     (br->auto_cnt == 1 && br_auto_port(p))))
 				br_port_clear_promisc(p);
 			else
 				br_port_set_promisc(p);
-- 
2.39.2



