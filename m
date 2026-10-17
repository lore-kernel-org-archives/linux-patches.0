Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2CB394785;
	Sat, 17 Oct 2026 16:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253550; cv=none; b=NQ2z1RTcXQQGDw2mYuU3pKMyAGyCwAfdxkbw9yLknZzcKq+QWKiG7FLhdHHw3RCPp9gkd+XW2oXZ2J8qCNZhtBobXOYx3UnuwykUtDe/JpL7eImbI92Y0Uiyu1QI5ceGm1nir0kB7aJxD+tSasTYV/v96CpTciKYDh5Aqmo71+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253550; c=relaxed/simple;
	bh=M7TiBrp4wttUJjBasb6fnaOqdJFg0Z7gUm6zEFDSUVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdfNx3XI7eVJ3ueWtYMam1ssvgCO/D+zO8iy+WQK3mAgpimzhDqdkJfjwOOBivUXg9Mi9+2O1BIoxd/xwqUm03x/HMwjmus8B6FHF2rMwtIZ7mqSmEoF37yFg4uxVpw5dG2CAtNWoVKjDcJ9ahokoRbaAJN3eAL4d4wt52DChgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enxOioqL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enxOioqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8C01F000C4;
	Sat, 17 Oct 2026 16:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253549;
	bh=8FjwvMQFWpDb5EqfdOrD1pL+rY9XP+6BsBjPWtaj2tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=enxOioqLkW5Iqg9COb8cM1NlflEmC4DZT+f6aN2pR8G4C1bbwFCFcbjnW33L7iUpT
	 Qq36yVYL21GQRd28+mHDtvgcDGiWwYhL8YHS3k13uvTZ3iazk3WNTAEMGbctkNJc2c
	 GCUn4b6skm9Hvlqt4EBOA/04zct6qDL3r02hN1yQ=
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
Subject: [PATCH 6.12 153/869] net: vxlan: prevent NULL deref in vxlan_xmit_one
Date: Sat, 17 Oct 2026 17:49:54 +0200
Message-ID: <20261017160040.963274912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 drivers/net/vxlan/vxlan_core.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index f612def46c3c4..567793aea4a21 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2402,7 +2402,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	int addr_family;
 	__u8 tos, ttl;
 	int ifindex;
-	int err;
+	int err = 0;
 	u32 flags = vxlan->cfg.flags;
 	bool use_cache;
 	bool udp_sum = false;
@@ -2504,11 +2504,16 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 
 	rcu_read_lock();
 	if (addr_family == AF_INET) {
-		struct vxlan_sock *sock4 = rcu_dereference(vxlan->vn4_sock);
+		struct vxlan_sock *sock4;
 		struct rtable *rt;
 		__be16 df = 0;
 		__be32 saddr;
 
+		sock4 = rcu_dereference(vxlan->vn4_sock);
+		if (unlikely(!sock4)) {
+			goto tx_error;
+		}
+
 		if (!ifindex)
 			ifindex = sock4->sock->sk->sk_bound_dev_if;
 
@@ -2576,9 +2581,14 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 				    src_port, dst_port, xnet, !udp_sum);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
-		struct vxlan_sock *sock6 = rcu_dereference(vxlan->vn6_sock);
+		struct vxlan_sock *sock6;
 		struct in6_addr saddr;
 
+		sock6 = rcu_dereference(vxlan->vn6_sock);
+		if (unlikely(!sock6)) {
+			goto tx_error;
+		}
+
 		if (!ifindex)
 			ifindex = sock6->sock->sk->sk_bound_dev_if;
 
-- 
2.53.0



