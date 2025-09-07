Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA8515C158;
	Sun,  7 Sep 2025 20:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277042; cv=none; b=sx9tYFHaHVAhRVIxcrY41YtkNH+NatSBmD4qiVqrpWW7ql6YxnDFTik9sxgb+UoECP9x/Q1paluMzSs1OpGlBYJJ1S9dnKTjAdwgux5ycsDVwCnRjktzBJXCneB16soSqfmm/Nrl1mDXbwlxQJqBAyBLYwNokhIv++Vyh4BgL8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277042; c=relaxed/simple;
	bh=+PYN3QyNLYXuxCIt3NLE6vIN65lk5sE3OJGwsrVNA/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2PvuCIVg3fXCJip+Rk18Ey+TY3C/K1kyc/Cjc4V0J17JlHC4qrssT8MUiZlxrgAGPCuWtN09fOPnfaTVpJQYMZQgDqUriZo2nuqvUNSzDs6S8mj3WS9E/OifnzYMkw8S9VnhaTZ4UWBiN1nncwhqblXqg8s7qM1ttHpvX9uN8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=taltiNxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="taltiNxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D15C4CEF0;
	Sun,  7 Sep 2025 20:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277041;
	bh=+PYN3QyNLYXuxCIt3NLE6vIN65lk5sE3OJGwsrVNA/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=taltiNxSNIjuCNWzWYqe0mo/4JeDvRcqRW5xaI/NZ0YSS8t+t/kiddx2Bt1/9ZYnj
	 VcX9fmNMYp73498eiDDdJ1yTMkUFN5vm8JoHbSBm9cSbMql0CDTAhyVaT1gSOJ/vBs
	 DBqq9cTwGcndmwtdyeztj99FhIgFp/yHra9IJ2CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/175] net: vxlan: make vxlan_snoop() return drop reasons
Date: Sun,  7 Sep 2025 21:57:41 +0200
Message-ID: <20250907195616.398456905@linuxfoundation.org>
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

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit 289fd4e75219a96f77c5d679166035cd5118d139 ]

Change the return type of vxlan_snoop() from bool to enum
skb_drop_reason. In this commit, two drop reasons are introduced:

  SKB_DROP_REASON_MAC_INVALID_SOURCE
  SKB_DROP_REASON_VXLAN_ENTRY_EXISTS

Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6ead38147ebb ("vxlan: Fix NPD when refreshing an FDB entry with a nexthop object")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 17 +++++++++--------
 include/net/dropreason-core.h  |  9 +++++++++
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index efd5e99808935..c4ce577eb0908 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1437,9 +1437,10 @@ static int vxlan_fdb_get(struct sk_buff *skb,
  * and Tunnel endpoint.
  * Return true if packet is bogus and should be dropped.
  */
-static bool vxlan_snoop(struct net_device *dev,
-			union vxlan_addr *src_ip, const u8 *src_mac,
-			u32 src_ifindex, __be32 vni)
+static enum skb_drop_reason vxlan_snoop(struct net_device *dev,
+					union vxlan_addr *src_ip,
+					const u8 *src_mac, u32 src_ifindex,
+					__be32 vni)
 {
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	struct vxlan_fdb *f;
@@ -1447,7 +1448,7 @@ static bool vxlan_snoop(struct net_device *dev,
 
 	/* Ignore packets from invalid src-address */
 	if (!is_valid_ether_addr(src_mac))
-		return true;
+		return SKB_DROP_REASON_MAC_INVALID_SOURCE;
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (src_ip->sa.sa_family == AF_INET6 &&
@@ -1461,15 +1462,15 @@ static bool vxlan_snoop(struct net_device *dev,
 
 		if (likely(vxlan_addr_equal(&rdst->remote_ip, src_ip) &&
 			   rdst->remote_ifindex == ifindex))
-			return false;
+			return SKB_NOT_DROPPED_YET;
 
 		/* Don't migrate static entries, drop packets */
 		if (f->state & (NUD_PERMANENT | NUD_NOARP))
-			return true;
+			return SKB_DROP_REASON_VXLAN_ENTRY_EXISTS;
 
 		/* Don't override an fdb with nexthop with a learnt entry */
 		if (rcu_access_pointer(f->nh))
-			return true;
+			return SKB_DROP_REASON_VXLAN_ENTRY_EXISTS;
 
 		if (net_ratelimit())
 			netdev_info(dev,
@@ -1497,7 +1498,7 @@ static bool vxlan_snoop(struct net_device *dev,
 		spin_unlock(&vxlan->hash_lock[hash_index]);
 	}
 
-	return false;
+	return SKB_NOT_DROPPED_YET;
 }
 
 static bool __vxlan_sock_release_prep(struct vxlan_sock *vs)
diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index 98259d2b3e926..1cb8d7c953beb 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -94,6 +94,8 @@
 	FN(TC_RECLASSIFY_LOOP)		\
 	FN(VXLAN_INVALID_HDR)		\
 	FN(VXLAN_VNI_NOT_FOUND)		\
+	FN(MAC_INVALID_SOURCE)		\
+	FN(VXLAN_ENTRY_EXISTS)		\
 	FN(IP_TUNNEL_ECN)		\
 	FNe(MAX)
 
@@ -429,6 +431,13 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_VXLAN_INVALID_HDR,
 	/** @SKB_DROP_REASON_VXLAN_VNI_NOT_FOUND: no VXLAN device found for VNI */
 	SKB_DROP_REASON_VXLAN_VNI_NOT_FOUND,
+	/** @SKB_DROP_REASON_MAC_INVALID_SOURCE: source mac is invalid */
+	SKB_DROP_REASON_MAC_INVALID_SOURCE,
+	/**
+	 * @SKB_DROP_REASON_VXLAN_ENTRY_EXISTS: trying to migrate a static
+	 * entry or an entry pointing to a nexthop.
+	 */
+	SKB_DROP_REASON_VXLAN_ENTRY_EXISTS,
 	/**
 	 * @SKB_DROP_REASON_IP_TUNNEL_ECN: skb is dropped according to
 	 * RFC 6040 4.2, see __INET_ECN_decapsulate() for detail.
-- 
2.50.1



