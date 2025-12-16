Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3A13A1CED;
	Tue, 16 Dec 2025 12:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888278; cv=none; b=bqCNlkZ1/rm17KS6kJQINx42nkVVHgYCQYdOtVCJ8aKi0OxDO8z2C+r/BjNXggts930zHA4bXDOdB9axPISB3Bxy7oWIp7e7NPvDXxFndyujBpluJxprcRZo4W2jEVQLxoOiGhqAkhi3TYDbPalNT8jwzt0uwb8lVZ+TMjwt8/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888278; c=relaxed/simple;
	bh=ydFGeRDlZCBLb5ngHgVCxz1BXN0TtT4c2J04xswMW9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYdDKCh4qYukTSeUNCiAXt2Kq16qu7WGj8L0GenoOpOi/U3ANx+DdAHC9jP4vMaIFenLXzuHMLlWG/g6MjR0OSzpW9EIdjBHZ+4GztT+g4cr7DZOBi+zBubo6r8rU4B3SU2o1wJe07TVtpO9cZvkXsr3nDu1x+sTxB3B7Z8GBEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBqQ5y1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBqQ5y1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17054C4CEF5;
	Tue, 16 Dec 2025 12:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888278;
	bh=ydFGeRDlZCBLb5ngHgVCxz1BXN0TtT4c2J04xswMW9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBqQ5y1wtR81+t1yEgyZeScglkfknhbJpv4h8wi8rYoh/VZH5CiU1RmYtf02/r09N
	 jQ1x6xi7JeZ4VfZLJamzaquIJuD7a/Bhq5H469sgMSv6FpHN4D81odzqJCHI/4lz+z
	 D0M4gk0ZuryDius0E1eVZP6rOmotOqiYZqrJs/6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Li <liali@redhat.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 485/614] net: vxlan: prevent NULL deref in vxlan_xmit_one
Date: Tue, 16 Dec 2025 12:14:12 +0100
Message-ID: <20251216111418.943713812@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 1f73a56f986005f0bc64ed23873930e2ee4f5911 ]

Neither sock4 nor sock6 pointers are guaranteed to be non-NULL in
vxlan_xmit_one, e.g. if the iface is brought down. This can lead to the
following NULL dereference:

  BUG: kernel NULL pointer dereference, address: 0000000000000010
  Oops: Oops: 0000 [#1] SMP NOPTI
  RIP: 0010:vxlan_xmit_one+0xbb3/0x1580
  Call Trace:
   vxlan_xmit+0x429/0x610
   dev_hard_start_xmit+0x55/0xa0
   __dev_queue_xmit+0x6d0/0x7f0
   ip_finish_output2+0x24b/0x590
   ip_output+0x63/0x110

Mentioned commits changed the code path in vxlan_xmit_one and as a side
effect the sock4/6 pointer validity checks in vxlan(6)_get_route were
lost. Fix this by adding back checks.

Since both commits being fixed were released in the same version (v6.7)
and are strongly related, bundle the fixes in a single commit.

Reported-by: Liang Li <liali@redhat.com>
Fixes: 6f19b2c136d9 ("vxlan: use generic function for tunnel IPv4 route lookup")
Fixes: 2aceb896ee18 ("vxlan: use generic function for tunnel IPv6 route lookup")
Cc: Beniamino Galvani <b.galvani@gmail.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20251126102627.74223-1-atenart@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index a5c55e7e4d795..e957aa12a8a44 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2349,7 +2349,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	int addr_family;
 	__u8 tos, ttl;
 	int ifindex;
-	int err;
+	int err = 0;
 	u32 flags = vxlan->cfg.flags;
 	bool use_cache;
 	bool udp_sum = false;
@@ -2454,12 +2454,18 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 
 	rcu_read_lock();
 	if (addr_family == AF_INET) {
-		struct vxlan_sock *sock4 = rcu_dereference(vxlan->vn4_sock);
+		struct vxlan_sock *sock4;
 		u16 ipcb_flags = 0;
 		struct rtable *rt;
 		__be16 df = 0;
 		__be32 saddr;
 
+		sock4 = rcu_dereference(vxlan->vn4_sock);
+		if (unlikely(!sock4)) {
+			reason = SKB_DROP_REASON_DEV_READY;
+			goto tx_error;
+		}
+
 		if (!ifindex)
 			ifindex = sock4->sock->sk->sk_bound_dev_if;
 
@@ -2534,10 +2540,16 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 				    ipcb_flags);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
-		struct vxlan_sock *sock6 = rcu_dereference(vxlan->vn6_sock);
+		struct vxlan_sock *sock6;
 		struct in6_addr saddr;
 		u16 ip6cb_flags = 0;
 
+		sock6 = rcu_dereference(vxlan->vn6_sock);
+		if (unlikely(!sock6)) {
+			reason = SKB_DROP_REASON_DEV_READY;
+			goto tx_error;
+		}
+
 		if (!ifindex)
 			ifindex = sock6->sock->sk->sk_bound_dev_if;
 
-- 
2.51.0



