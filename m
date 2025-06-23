Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4251E5B71;
	Mon, 23 Jun 2025 21:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714199; cv=none; b=iHVDyxks+UHIQzRMV/Ab7XvCDKyKvDa44183iQ5wt2us3exhMA3Ue6Bxtwm1NicXzSUulpJGom4s2iM0BcSR4XtmXJgm0uqfRzLXVrzt/TTD4PyeHzyGAvHucqL4kzGPbmikutPtcHT4/B7xP1AJ6PklQ3Nk3pcXBp5iOae8VVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714199; c=relaxed/simple;
	bh=hdmhUxNwkGtZ/lWyj/yzCSNbeGaZg5Sw4n4DFpsB/x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gl/4zpG5hbmoCOlFMKGYz0H3CUo5vxQUemf9jevhfDifwHwx76cizRgN6xXla/FzLXwUizbCLJWHc86VJgHkgHbahb0L3qyYnFrq7pb6kya62fY6yy+PIi1fugyN+8Mu7X7Ftb6c3hKvBfFF/EnXkW/X2iUizh90vCM+XKW7XiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9Ja/A4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9Ja/A4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67B0C4CEEA;
	Mon, 23 Jun 2025 21:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714199;
	bh=hdmhUxNwkGtZ/lWyj/yzCSNbeGaZg5Sw4n4DFpsB/x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9Ja/A4EYRvnYkBoAi8mvewWZvk+DClWVUCawI02XAPq3FsvNLI6kg7EFRgK6Hu9n
	 GgFNaEQhV1wq4NsXjkQG63jea2oL6aJcutIsv6H5R1KIxvrm6pqPPDbuoQ2+6bxmyp
	 Hu12Q4VSQVk0zws2PlWGTZhpTW3Zq3L1qEFsZXAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 396/592] vxlan: Add RCU read-side critical sections in the Tx path
Date: Mon, 23 Jun 2025 15:05:54 +0200
Message-ID: <20250623130709.862324530@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index e83197fac1e0f..edbf1088c7d74 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1916,12 +1916,15 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
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
@@ -2648,14 +2651,10 @@ static void vxlan_xmit_nh(struct sk_buff *skb, struct net_device *dev,
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
@@ -2782,6 +2781,7 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	eth = eth_hdr(skb);
+	rcu_read_lock();
 	f = vxlan_find_mac(vxlan, eth->h_dest, vni);
 	did_rsc = false;
 
@@ -2804,7 +2804,7 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_TX_DROPS, 0);
 			kfree_skb_reason(skb, SKB_DROP_REASON_NO_TX_TARGET);
-			return NETDEV_TX_OK;
+			goto out;
 		}
 	}
 
@@ -2829,6 +2829,8 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 			kfree_skb_reason(skb, SKB_DROP_REASON_NO_TX_TARGET);
 	}
 
+out:
+	rcu_read_unlock();
 	return NETDEV_TX_OK;
 }
 
-- 
2.39.5



