Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07923AFB07;
	Sat, 17 Oct 2026 17:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258134; cv=none; b=INnzoj4DQd7u1v+TUVLGC7OaIfDTwxb7KWSSEICs05hb7/HjRq4Vslbv4bo34+fynYxRHxfA+ymjxm48QraoiavhkK2XccMAnGIpekL6GPXsPdkEih8Ew7hjX3zORcAA7beNM0kvvYbL+XyOspJXW4wLGGRpxGPdKCkQx5BQ2rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258134; c=relaxed/simple;
	bh=s6pnxD2nrDvIgGQioemGUbKZhDl9VsbQqmBq2r5TEUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdGPrdV6bw7ulWwoeDE8Xr7bLPeCeAPaDgEnQxdSXdqT01KOfHZ7SsIL8E6NjRb/kmb2U5BgmGDcMvdTGBgvSoNf4PUlYJH8HClphtWAwAcie2ScA2qbGXCZRa1D6wkpOsT3CJRM/3r2kXzrKtDAKcGrhWG2xqebLA9CYaD7Ng0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=juuFVu7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="juuFVu7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348D71F000C5;
	Sat, 17 Oct 2026 17:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258132;
	bh=SPq+9UeriFhBstbKn5i5JhQYvu2nSTF673dmCqMP+7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=juuFVu7QWK80WfQr9jJAXAJhBe5BhhVFZstiVuRcKO+I1kyzAYWqZy9Xdm/LIzmx1
	 J0gAs6D2doBkDVgprtGzMx2LF2fiNDg4r4KFlNpYuXqLLWxsIgxWaOF8vEnQviMQcd
	 /tfyJl8DUDtdMxUx7jCJlmooAdU9qYqEq24HJPBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0782/1674] vxlan: Fix NPD in {arp,neigh}_reduce() when using nexthop objects
Date: Sat, 17 Oct 2026 17:50:54 +0200
Message-ID: <20261017160451.176993386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 1f5d2fd1ca04a23c18b1bde9a43ce2fa2ffa1bce ]

When the "proxy" option is enabled on a VXLAN device, the device will
suppress ARP requests and IPv6 Neighbor Solicitation messages if it is
able to reply on behalf of the remote host. That is, if a matching and
valid neighbor entry is configured on the VXLAN device whose MAC address
is not behind the "any" remote (0.0.0.0 / ::).

The code currently assumes that the FDB entry for the neighbor's MAC
address points to a valid remote destination, but this is incorrect if
the entry is associated with an FDB nexthop group. This can result in a
NPD [1][3] which can be reproduced using [2][4].

Fix by checking that the remote destination exists before dereferencing
it.

[1]
BUG: kernel NULL pointer dereference, address: 0000000000000000
[...]
CPU: 4 UID: 0 PID: 365 Comm: arping Not tainted 6.17.0-rc2-virtme-g2a89cb21162c #2 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-4.fc41 04/01/2014
RIP: 0010:vxlan_xmit+0xb58/0x15f0
[...]
Call Trace:
 <TASK>
 dev_hard_start_xmit+0x5d/0x1c0
 __dev_queue_xmit+0x246/0xfd0
 packet_sendmsg+0x113a/0x1850
 __sock_sendmsg+0x38/0x70
 __sys_sendto+0x126/0x180
 __x64_sys_sendto+0x24/0x30
 do_syscall_64+0xa4/0x260
 entry_SYSCALL_64_after_hwframe+0x4b/0x53

[2]
 #!/bin/bash

 ip address add 192.0.2.1/32 dev lo

 ip nexthop add id 1 via 192.0.2.2 fdb
 ip nexthop add id 10 group 1 fdb

 ip link add name vx0 up type vxlan id 10010 local 192.0.2.1 dstport 4789 proxy

 ip neigh add 192.0.2.3 lladdr 00:11:22:33:44:55 nud perm dev vx0

 bridge fdb add 00:11:22:33:44:55 dev vx0 self static nhid 10

 arping -b -c 1 -s 192.0.2.1 -I vx0 192.0.2.3

[3]
BUG: kernel NULL pointer dereference, address: 0000000000000000
[...]
CPU: 13 UID: 0 PID: 372 Comm: ndisc6 Not tainted 6.17.0-rc2-virtmne-g6ee90cb26014 #3 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1v996), BIOS 1.17.0-4.fc41 04/01/2x014
RIP: 0010:vxlan_xmit+0x803/0x1600
[...]
Call Trace:
 <TASK>
 dev_hard_start_xmit+0x5d/0x1c0
 __dev_queue_xmit+0x246/0xfd0
 ip6_finish_output2+0x210/0x6c0
 ip6_finish_output+0x1af/0x2b0
 ip6_mr_output+0x92/0x3e0
 ip6_send_skb+0x30/0x90
 rawv6_sendmsg+0xe6e/0x12e0
 __sock_sendmsg+0x38/0x70
 __sys_sendto+0x126/0x180
 __x64_sys_sendto+0x24/0x30
 do_syscall_64+0xa4/0x260
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7f383422ec77

[4]
 #!/bin/bash

 ip address add 2001:db8:1::1/128 dev lo

 ip nexthop add id 1 via 2001:db8:1::1 fdb
 ip nexthop add id 10 group 1 fdb

 ip link add name vx0 up type vxlan id 10010 local 2001:db8:1::1 dstport 4789 proxy

 ip neigh add 2001:db8:1::3 lladdr 00:11:22:33:44:55 nud perm dev vx0

 bridge fdb add 00:11:22:33:44:55 dev vx0 self static nhid 10

 ndisc6 -r 1 -s 2001:db8:1::1 -w 1 2001:db8:1::3 vx0

Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250901065035.159644-3-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 04847f0c6c142..d810600f232c3 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1898,6 +1898,7 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 	n = neigh_lookup(&arp_tbl, &tip, dev);
 
 	if (n) {
+		struct vxlan_rdst *rdst = NULL;
 		struct vxlan_fdb *f;
 		struct sk_buff	*reply;
 
@@ -1907,7 +1908,9 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		}
 
 		f = vxlan_find_mac(vxlan, n->ha, vni);
-		if (f && vxlan_addr_any(&(first_remote_rcu(f)->remote_ip))) {
+		if (f)
+			rdst = first_remote_rcu(f);
+		if (rdst && vxlan_addr_any(&rdst->remote_ip)) {
 			/* bridge-local neighbor */
 			neigh_release(n);
 			goto out;
@@ -2066,6 +2069,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 	n = neigh_lookup(ipv6_stub->nd_tbl, &msg->target, dev);
 
 	if (n) {
+		struct vxlan_rdst *rdst = NULL;
 		struct vxlan_fdb *f;
 		struct sk_buff *reply;
 
@@ -2075,7 +2079,9 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		}
 
 		f = vxlan_find_mac(vxlan, n->ha, vni);
-		if (f && vxlan_addr_any(&(first_remote_rcu(f)->remote_ip))) {
+		if (f)
+			rdst = first_remote_rcu(f);
+		if (rdst && vxlan_addr_any(&rdst->remote_ip)) {
 			/* bridge-local neighbor */
 			neigh_release(n);
 			goto out;
-- 
2.53.0



