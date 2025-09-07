Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2CC18DF89;
	Sun,  7 Sep 2025 20:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277070; cv=none; b=gg1pgBBUQAldv7V6Q/J7GtM7tbmNxqeKP9RnZVCRQCxGl21KEwoOF6+Mp8/66NKuG6nRObZrIpbDq7FcHEI8i+38eKzkOrDvJMEyF7mGyb6XhznztiEABfkOgMytpIEMcdmuVmyGxc36RyqLhpIls75O2w2HTevC0VnpMPPoqg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277070; c=relaxed/simple;
	bh=RPpxG5pONvbMhQoj4Aq1KIQlVpKp23kuWy61ZjN9cNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+DO5gaqHoDbEDZpi08j2jQ/QKZSq9UjRuE8Z+M4vZF5DbDZX7DYp7bpoj28XfA0gwTUrlr+9p9cdGYRo2DMK0jMEttUVPFipWJ/NCzoweJ+6vVXmO9kTQECNXXmcCB8L5dAGewSOjdRkvgoUBRzCPGzIgL1EKUwnyui102XULU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5NWoYo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5NWoYo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59DCC4CEF0;
	Sun,  7 Sep 2025 20:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277070;
	bh=RPpxG5pONvbMhQoj4Aq1KIQlVpKp23kuWy61ZjN9cNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5NWoYo4m+9w1odo2x5HXO+z6KGPEvLgo70d5MxsjQi+ouWi8b6Y/7hNnBwWoyfQk
	 MQeV4qIE5nIAzHhVcUDP1T3AaTtN5/yc1e36Fc9Sehom5tolLVJ7AlkDAPdAY05glW
	 v0jGOj1mxF817fC02W7VC5a1m4JF+qJ7xUFDxyP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/175] vxlan: Add RCU read-side critical sections in the Tx path
Date: Sun,  7 Sep 2025 21:57:49 +0200
Message-ID: <20250907195616.583684050@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 804b09be09f8af4eda5346a72361459ba21fcf1b ]

The Tx path does not run from an RCU read-side critical section which
makes the current lockless accesses to FDB entries invalid. As far as I
am aware, this has not been a problem in practice, but traces will be
generated once we transition the FDB lookup to rhashtable_lookup().

Add rcu_read_{lock,unlock}() around the handling of FDB entries in the
Tx path. Remove the RCU read-side critical section from vxlan_xmit_nh()
as now the function is always called from an RCU read-side critical
section.

Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250415121143.345227-2-idosch@nvidia.com
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 1f5d2fd1ca04 ("vxlan: Fix NPD in {arp,neigh}_reduce() when using nexthop objects")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 8853fcb7eb7f2..1d431e3fc71ea 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1909,12 +1909,15 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 			goto out;
 		}
 
+		rcu_read_lock();
 		f = vxlan_find_mac(vxlan, n->ha, vni);
 		if (f && vxlan_addr_any(&(first_remote_rcu(f)->remote_ip))) {
 			/* bridge-local neighbor */
 			neigh_release(n);
+			rcu_read_unlock();
 			goto out;
 		}
+		rcu_read_unlock();
 
 		reply = arp_create(ARPOP_REPLY, ETH_P_ARP, sip, dev, tip, sha,
 				n->ha, sha);
@@ -2632,14 +2635,10 @@ static void vxlan_xmit_nh(struct sk_buff *skb, struct net_device *dev,
 	memset(&nh_rdst, 0, sizeof(struct vxlan_rdst));
 	hash = skb_get_hash(skb);
 
-	rcu_read_lock();
 	nh = rcu_dereference(f->nh);
-	if (!nh) {
-		rcu_read_unlock();
+	if (!nh)
 		goto drop;
-	}
 	do_xmit = vxlan_fdb_nh_path_select(nh, hash, &nh_rdst);
-	rcu_read_unlock();
 
 	if (likely(do_xmit))
 		vxlan_xmit_one(skb, dev, vni, &nh_rdst, did_rsc);
@@ -2766,6 +2765,7 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	eth = eth_hdr(skb);
+	rcu_read_lock();
 	f = vxlan_find_mac(vxlan, eth->h_dest, vni);
 	did_rsc = false;
 
@@ -2788,7 +2788,7 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_TX_DROPS, 0);
 			kfree_skb_reason(skb, SKB_DROP_REASON_NO_TX_TARGET);
-			return NETDEV_TX_OK;
+			goto out;
 		}
 	}
 
@@ -2813,6 +2813,8 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 			kfree_skb_reason(skb, SKB_DROP_REASON_NO_TX_TARGET);
 	}
 
+out:
+	rcu_read_unlock();
 	return NETDEV_TX_OK;
 }
 
-- 
2.50.1



