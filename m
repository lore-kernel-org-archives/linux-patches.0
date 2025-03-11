Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4B025EF86;
	Tue, 11 Mar 2025 15:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705405; cv=none; b=XU2kebHMZTxfgxjEPXEb7nn8hL/WOJg6qBAkBLnY92TRHG6JXX3BrOIw8eQEt0U7567hKa16VvQI3mk+wFcNOHEEn84mlX0C6Z3dbHW1aJE4LBrRMLsFsz3I2s2zSlXwJx0B1f9VwGWAlQN4JU1NJsesK1dzZV1of4NfCggu28s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705405; c=relaxed/simple;
	bh=biVhzaU+Jlp21TpLIE0khQnQ11eX6k7DBU7mavC3tn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBsK/ZhHP2S/l/GMKKvoTu7FlGWO9y+iZTP4oNWmpcOyYiq4Ns9n/i1GrMcTlVcdmWDcn1j1gSzMl4f07VWLyBaBzbfRdLMIxAaNI34lEtH4tdJ4Mmj8UlccX3f02oWSqyB34qeOFtJzeeZcDNBvCgukUy0dyFWiXQZqjh8cETE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTswwZHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTswwZHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03B3C4CEE9;
	Tue, 11 Mar 2025 15:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705405;
	bh=biVhzaU+Jlp21TpLIE0khQnQ11eX6k7DBU7mavC3tn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTswwZHOIlVDie82einNOhZFq8tQAC6WVL/QXM3/AfFG8FxexmD0xgGBvltR6Cci0
	 nn+YvpX4h4h0fsVj4dVYjA+JZwmU8NpvciMVGArNYesbH9ywNWGPg4AMuLCe+5//Cm
	 +J957elmBWIED1EqvF+ZGo8M+2z1xock0K2xMDgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3c47b5843403a45aef57@syzkaller.appspotmail.com,
	Octavian Purdila <tavip@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/328] team: prevent adding a device which is already a team device lower
Date: Tue, 11 Mar 2025 15:56:34 +0100
Message-ID: <20250311145715.850010105@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Octavian Purdila <tavip@google.com>

[ Upstream commit 3fff5da4ca2164bb4d0f1e6cd33f6eb8a0e73e50 ]

Prevent adding a device which is already a team device lower,
e.g. adding veth0 if vlan1 was already added and veth0 is a lower of
vlan1.

This is not useful in practice and can lead to recursive locking:

$ ip link add veth0 type veth peer name veth1
$ ip link set veth0 up
$ ip link set veth1 up
$ ip link add link veth0 name veth0.1 type vlan protocol 802.1Q id 1
$ ip link add team0 type team
$ ip link set veth0.1 down
$ ip link set veth0.1 master team0
team0: Port device veth0.1 added
$ ip link set veth0 down
$ ip link set veth0 master team0

============================================
WARNING: possible recursive locking detected
6.13.0-rc2-virtme-00441-ga14a429069bb #46 Not tainted
--------------------------------------------
ip/7684 is trying to acquire lock:
ffff888016848e00 (team->team_lock_key){+.+.}-{4:4}, at: team_device_event (drivers/net/team/team_core.c:2928 drivers/net/team/team_core.c:2951 drivers/net/team/team_core.c:2973)

but task is already holding lock:
ffff888016848e00 (team->team_lock_key){+.+.}-{4:4}, at: team_add_slave (drivers/net/team/team_core.c:1147 drivers/net/team/team_core.c:1977)

other info that might help us debug this:
Possible unsafe locking scenario:

CPU0
----
lock(team->team_lock_key);
lock(team->team_lock_key);

*** DEADLOCK ***

May be due to missing lock nesting notation

2 locks held by ip/7684:

stack backtrace:
CPU: 3 UID: 0 PID: 7684 Comm: ip Not tainted 6.13.0-rc2-virtme-00441-ga14a429069bb #46
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
<TASK>
dump_stack_lvl (lib/dump_stack.c:122)
print_deadlock_bug.cold (kernel/locking/lockdep.c:3040)
__lock_acquire (kernel/locking/lockdep.c:3893 kernel/locking/lockdep.c:5226)
? netlink_broadcast_filtered (net/netlink/af_netlink.c:1548)
lock_acquire.part.0 (kernel/locking/lockdep.c:467 kernel/locking/lockdep.c:5851)
? team_device_event (drivers/net/team/team_core.c:2928 drivers/net/team/team_core.c:2951 drivers/net/team/team_core.c:2973)
? trace_lock_acquire (./include/trace/events/lock.h:24 (discriminator 2))
? team_device_event (drivers/net/team/team_core.c:2928 drivers/net/team/team_core.c:2951 drivers/net/team/team_core.c:2973)
? lock_acquire (kernel/locking/lockdep.c:5822)
? team_device_event (drivers/net/team/team_core.c:2928 drivers/net/team/team_core.c:2951 drivers/net/team/team_core.c:2973)
__mutex_lock (kernel/locking/mutex.c:587 kernel/locking/mutex.c:735)
? team_device_event (drivers/net/team/team_core.c:2928 drivers/net/team/team_core.c:2951 drivers/net/team/team_core.c:2973)
? team_device_event (drivers/net/team/team_core.c:2928 drivers/net/team/team_core.c:2951 drivers/net/team/team_core.c:2973)
? fib_sync_up (net/ipv4/fib_semantics.c:2167)
? team_device_event (drivers/net/team/team_core.c:2928 drivers/net/team/team_core.c:2951 drivers/net/team/team_core.c:2973)
team_device_event (drivers/net/team/team_core.c:2928 drivers/net/team/team_core.c:2951 drivers/net/team/team_core.c:2973)
notifier_call_chain (kernel/notifier.c:85)
call_netdevice_notifiers_info (net/core/dev.c:1996)
__dev_notify_flags (net/core/dev.c:8993)
? __dev_change_flags (net/core/dev.c:8975)
dev_change_flags (net/core/dev.c:9027)
vlan_device_event (net/8021q/vlan.c:85 net/8021q/vlan.c:470)
? br_device_event (net/bridge/br.c:143)
notifier_call_chain (kernel/notifier.c:85)
call_netdevice_notifiers_info (net/core/dev.c:1996)
dev_open (net/core/dev.c:1519 net/core/dev.c:1505)
team_add_slave (drivers/net/team/team_core.c:1219 drivers/net/team/team_core.c:1977)
? __pfx_team_add_slave (drivers/net/team/team_core.c:1972)
do_set_master (net/core/rtnetlink.c:2917)
do_setlink.isra.0 (net/core/rtnetlink.c:3117)

Reported-by: syzbot+3c47b5843403a45aef57@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3c47b5843403a45aef57
Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Signed-off-by: Octavian Purdila <tavip@google.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 56caff2d01c45..b0a9dd33a0196 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1165,6 +1165,13 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		return -EBUSY;
 	}
 
+	if (netdev_has_upper_dev(port_dev, dev)) {
+		NL_SET_ERR_MSG(extack, "Device is already a lower device of the team interface");
+		netdev_err(dev, "Device %s is already a lower device of the team interface\n",
+			   portname);
+		return -EBUSY;
+	}
+
 	if (port_dev->features & NETIF_F_VLAN_CHALLENGED &&
 	    vlan_uses_dev(dev)) {
 		NL_SET_ERR_MSG(extack, "Device is VLAN challenged and team device has VLAN set up");
-- 
2.39.5



