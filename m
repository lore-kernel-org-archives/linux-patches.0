Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CCB4315A;
	Sun,  7 Sep 2025 20:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277771; cv=none; b=DZFnXmK6pyywatyJSl9cw7v7sdgilx6yUJ3MSDXWky6/c90tmZJLDN/03P4x1klnxi/xtU9yyU3+/xk4IRkCECIRSBMYxE/KNtARNBHVSl9I6OUvtYufiauyhGNIOnqT+hfkiYPApVmNUiDoYNshe2aetwG9X3+iTwmLVtZF7Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277771; c=relaxed/simple;
	bh=LCzIG5RfxEenet2JLdD5E711s+LAIoh7QJvZm1DkgWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WErCQNLCSLUKXP9BN6ll6kiq3HR7qc7JO/chm5fdR69eXAAHmOKEGuTgvtwSx0w4lMrHSh17SmbD8fIQqpR//PUjdY+iQZFeywKrPVLkb3CBulNbtRoy3cD/7sGeOXQ3IyF7yJokDCzNH9JgRu3zZEG7l0RAaX/JfpBHcwNnG1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhe/iEZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhe/iEZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A18C4CEF0;
	Sun,  7 Sep 2025 20:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277771;
	bh=LCzIG5RfxEenet2JLdD5E711s+LAIoh7QJvZm1DkgWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dhe/iEZjZMZpJnkHrObrqCPUbANWe7Uh4ji/53IVRy0CHk6YNFzlhlAjoEVZZKwBO
	 n4y1UqN3JHfm3tbXZPu70PtefL85lNS/cfao6Axizzmr9VGGmYnKgyf70C6Q858UOH
	 4DyQd5QFnIK+H8N+95lGavyaHapiESAejoi7dYXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marlin Cremers <mcremers@cloudbear.nl>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 075/183] vxlan: Fix NPD when refreshing an FDB entry with a nexthop object
Date: Sun,  7 Sep 2025 21:58:22 +0200
Message-ID: <20250907195617.578382800@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 6ead38147ebb813f08be6ea8ef547a0e4c09559a ]

VXLAN FDB entries can point to either a remote destination or an FDB
nexthop group. The latter is usually used in EVPN deployments where
learning is disabled.

However, when learning is enabled, an incoming packet might try to
refresh an FDB entry that points to an FDB nexthop group and therefore
does not have a remote. Such packets should be dropped, but they are
only dropped after dereferencing the non-existent remote, resulting in a
NPD [1] which can be reproduced using [2].

Fix by dropping such packets earlier. Remove the misleading comment from
first_remote_rcu().

[1]
BUG: kernel NULL pointer dereference, address: 0000000000000000
[...]
CPU: 13 UID: 0 PID: 361 Comm: mausezahn Not tainted 6.17.0-rc1-virtme-g9f6b606b6b37 #1 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-4.fc41 04/01/2014
RIP: 0010:vxlan_snoop+0x98/0x1e0
[...]
Call Trace:
 <TASK>
 vxlan_encap_bypass+0x209/0x240
 encap_bypass_if_local+0xb1/0x100
 vxlan_xmit_one+0x1375/0x17e0
 vxlan_xmit+0x6b4/0x15f0
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
 ip address add 192.0.2.2/32 dev lo

 ip nexthop add id 1 via 192.0.2.3 fdb
 ip nexthop add id 10 group 1 fdb

 ip link add name vx0 up type vxlan id 10010 local 192.0.2.1 dstport 12345 localbypass
 ip link add name vx1 up type vxlan id 10020 local 192.0.2.2 dstport 54321 learning

 bridge fdb add 00:11:22:33:44:55 dev vx0 self static dst 192.0.2.2 port 54321 vni 10020
 bridge fdb add 00:aa:bb:cc:dd:ee dev vx1 self static nhid 10

 mausezahn vx0 -a 00:aa:bb:cc:dd:ee -b 00:11:22:33:44:55 -c 1 -q

Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
Reported-by: Marlin Cremers <mcremers@cloudbear.nl>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250901065035.159644-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c    | 8 ++++----
 drivers/net/vxlan/vxlan_private.h | 4 +---
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 97792de896b72..cea9dd067b68a 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1445,6 +1445,10 @@ static enum skb_drop_reason vxlan_snoop(struct net_device *dev,
 		if (READ_ONCE(f->updated) != now)
 			WRITE_ONCE(f->updated, now);
 
+		/* Don't override an fdb with nexthop with a learnt entry */
+		if (rcu_access_pointer(f->nh))
+			return SKB_DROP_REASON_VXLAN_ENTRY_EXISTS;
+
 		if (likely(vxlan_addr_equal(&rdst->remote_ip, src_ip) &&
 			   rdst->remote_ifindex == ifindex))
 			return SKB_NOT_DROPPED_YET;
@@ -1453,10 +1457,6 @@ static enum skb_drop_reason vxlan_snoop(struct net_device *dev,
 		if (f->state & (NUD_PERMANENT | NUD_NOARP))
 			return SKB_DROP_REASON_VXLAN_ENTRY_EXISTS;
 
-		/* Don't override an fdb with nexthop with a learnt entry */
-		if (rcu_access_pointer(f->nh))
-			return SKB_DROP_REASON_VXLAN_ENTRY_EXISTS;
-
 		if (net_ratelimit())
 			netdev_info(dev,
 				    "%pM migrated from %pIS to %pIS\n",
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index d328aed9feefd..55b84c0cbd65e 100644
--- a/drivers/net/vxlan/vxlan_private.h
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -61,9 +61,7 @@ static inline struct hlist_head *vs_head(struct net *net, __be16 port)
 	return &vn->sock_list[hash_32(ntohs(port), PORT_HASH_BITS)];
 }
 
-/* First remote destination for a forwarding entry.
- * Guaranteed to be non-NULL because remotes are never deleted.
- */
+/* First remote destination for a forwarding entry. */
 static inline struct vxlan_rdst *first_remote_rcu(struct vxlan_fdb *fdb)
 {
 	if (rcu_access_pointer(fdb->nh))
-- 
2.50.1



