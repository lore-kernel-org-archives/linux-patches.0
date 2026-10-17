Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF87C3C09EE;
	Sat, 17 Oct 2026 17:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258137; cv=none; b=mHOan9a1ePgIPjEKMIe9V50t8III8v7tG9m26kdWlGts+P8crXIIyF6Y57yBYm2f5QQH9/qdopdUspWt4dpzU70AB1TNb3wuH2RE7sG4KW+ep/kog9WL+O49MdhWb7hqgZNbficAzoFfVglM0qTKP66K+UrhN8N6P0PUrHfgmtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258137; c=relaxed/simple;
	bh=F1Gu5WL1orhZXbfZodL7fiCYK+OuYJzmPa6rTzzDv4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sp0EJxdP9Tv68gn83v8AJLGbl5J92qrONS3cRaw6P0BWb1d0CUCOHEMGkEUc/fereJ7icLdlIAgVSu4VaA4RlXJ6a0t3jxLfSpdqeSnmeLS6Q9eoKq8BjUnF4AsCHQDk0n2cQ19EGNjQjfSBPqvlfr0xzySuBjMhqu86cVipwaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pkkS/ej; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pkkS/ej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA861F000C4;
	Sat, 17 Oct 2026 17:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258135;
	bh=wLd9lVabK3d08tfNm7nsmZfWxZlVgClddufIfmAXFTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0pkkS/ejlJ1SjvmY6OR1PdnlGoHqPfBINiWP8Q6mpV3zP4c/dsiyql/jPrnlAyLb7
	 2LK9FESekrDWH4UCDgSw2MJpLzsviUBjf7Eh2V90ISA7/wXnU6kLdIHWz1R3+LMIuw
	 TICBibjSwCfq56tX1A0cHT8M6B3eSZJBBzDEVhTM=
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
Subject: [PATCH 6.6 0783/1674] vxlan: Fix NPD when refreshing an FDB entry with a nexthop object
Date: Sat, 17 Oct 2026 17:50:55 +0200
Message-ID: <20261017160451.202623757@linuxfoundation.org>
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
index d810600f232c3..fd7859f72a124 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1475,6 +1475,10 @@ static bool vxlan_snoop(struct net_device *dev,
 	if (likely(f)) {
 		struct vxlan_rdst *rdst = first_remote_rcu(f);
 
+		/* Don't override an fdb with nexthop with a learnt entry */
+		if (rcu_access_pointer(f->nh))
+			return true;
+
 		if (likely(vxlan_addr_equal(&rdst->remote_ip, src_ip) &&
 			   rdst->remote_ifindex == ifindex))
 			return false;
@@ -1483,10 +1487,6 @@ static bool vxlan_snoop(struct net_device *dev,
 		if (f->state & (NUD_PERMANENT | NUD_NOARP))
 			return true;
 
-		/* Don't override an fdb with nexthop with a learnt entry */
-		if (rcu_access_pointer(f->nh))
-			return true;
-
 		if (net_ratelimit())
 			netdev_info(dev,
 				    "%pM migrated from %pIS to %pIS\n",
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index 76a351a997d51..c6279ef98a5c2 100644
--- a/drivers/net/vxlan/vxlan_private.h
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -56,9 +56,7 @@ static inline struct hlist_head *vs_head(struct net *net, __be16 port)
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
2.53.0



