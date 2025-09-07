Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F1715C158;
	Sun,  7 Sep 2025 20:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277048; cv=none; b=JFAxKhNxd7nxSPiJTKCDhoIna/erq4PkeqhtGPFyqpcewUug98I4HbqtYfvtYFJ3+iLriJCIN3uGS9m5ZKvuUIysNBFHYz2gpHiAf36YEsYMZN3h96U6ZsqIBO7SeYr5IVGaMuUsomFAt28PCRM72rLUEHD/p52dYA9Iq932T1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277048; c=relaxed/simple;
	bh=/SzOusGzzTof5H22YrgPmRncnZaAqXfDyksb+dwaNgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7W70G9k/fVG/qL8ioRuMJVXb0aRVTYmaueTSu1PQzhLP0VxGJBxB/P/rWPOWaRams56ECkzMLz1jtEEivlXf+AhPBFtnKO/Xx/+1pZNOmYYpwcbqOymj70C4lisukYeg5ha3e/WY3ptCQnGlSrYtO3uRs76DPlEzhfyVGEShYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BH2T1H3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BH2T1H3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0818C4CEF0;
	Sun,  7 Sep 2025 20:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277048;
	bh=/SzOusGzzTof5H22YrgPmRncnZaAqXfDyksb+dwaNgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BH2T1H3AkBAGm2xKLo07nbMqXAvQjKiJNcb+OxteUvougV1d1SS8ZkPRcGEMsOhGf
	 Sj95S+sqei71LGQFYsSBt7eLl9V8O7VQl32p43U6bX5C76tUd1iroyq4hzyMLO7Val
	 AcL7PsE2Vrctmp/VjMH9KjJB7N/zhnWjPb2Y6+M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/175] net: vxlan: make vxlan_set_mac() return drop reasons
Date: Sun,  7 Sep 2025 21:57:43 +0200
Message-ID: <20250907195616.446034399@linuxfoundation.org>
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

[ Upstream commit d209706f562ee4fa81bdf24cf6b679c3222aa06c ]

Change the return type of vxlan_set_mac() from bool to enum
skb_drop_reason. In this commit, the drop reason
"SKB_DROP_REASON_LOCAL_MAC" is introduced for the case that the source
mac of the packet is a local mac.

Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 1f5d2fd1ca04 ("vxlan: Fix NPD in {arp,neigh}_reduce() when using nexthop objects")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 19 ++++++++++---------
 include/net/dropreason-core.h  |  6 ++++++
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 58590ddbc6a15..d9077698c5a89 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1605,9 +1605,9 @@ static void vxlan_parse_gbp_hdr(struct vxlanhdr *unparsed,
 	unparsed->vx_flags &= ~VXLAN_GBP_USED_BITS;
 }
 
-static bool vxlan_set_mac(struct vxlan_dev *vxlan,
-			  struct vxlan_sock *vs,
-			  struct sk_buff *skb, __be32 vni)
+static enum skb_drop_reason vxlan_set_mac(struct vxlan_dev *vxlan,
+					  struct vxlan_sock *vs,
+					  struct sk_buff *skb, __be32 vni)
 {
 	union vxlan_addr saddr;
 	u32 ifindex = skb->dev->ifindex;
@@ -1618,7 +1618,7 @@ static bool vxlan_set_mac(struct vxlan_dev *vxlan,
 
 	/* Ignore packet loops (and multicast echo) */
 	if (ether_addr_equal(eth_hdr(skb)->h_source, vxlan->dev->dev_addr))
-		return false;
+		return SKB_DROP_REASON_LOCAL_MAC;
 
 	/* Get address from the outer IP header */
 	if (vxlan_get_sk_family(vs) == AF_INET) {
@@ -1631,11 +1631,11 @@ static bool vxlan_set_mac(struct vxlan_dev *vxlan,
 #endif
 	}
 
-	if ((vxlan->cfg.flags & VXLAN_F_LEARN) &&
-	    vxlan_snoop(skb->dev, &saddr, eth_hdr(skb)->h_source, ifindex, vni))
-		return false;
+	if (!(vxlan->cfg.flags & VXLAN_F_LEARN))
+		return SKB_NOT_DROPPED_YET;
 
-	return true;
+	return vxlan_snoop(skb->dev, &saddr, eth_hdr(skb)->h_source,
+			   ifindex, vni);
 }
 
 static bool vxlan_ecn_decapsulate(struct vxlan_sock *vs, void *oiph,
@@ -1768,7 +1768,8 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 	}
 
 	if (!raw_proto) {
-		if (!vxlan_set_mac(vxlan, vs, skb, vni))
+		reason = vxlan_set_mac(vxlan, vs, skb, vni);
+		if (reason)
 			goto drop;
 	} else {
 		skb_reset_mac_header(skb);
diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index 1cb8d7c953beb..fbf92d442c1b2 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -97,6 +97,7 @@
 	FN(MAC_INVALID_SOURCE)		\
 	FN(VXLAN_ENTRY_EXISTS)		\
 	FN(IP_TUNNEL_ECN)		\
+	FN(LOCAL_MAC)			\
 	FNe(MAX)
 
 /**
@@ -443,6 +444,11 @@ enum skb_drop_reason {
 	 * RFC 6040 4.2, see __INET_ECN_decapsulate() for detail.
 	 */
 	SKB_DROP_REASON_IP_TUNNEL_ECN,
+	/**
+	 * @SKB_DROP_REASON_LOCAL_MAC: the source MAC address is equal to
+	 * the MAC address of the local netdev.
+	 */
+	SKB_DROP_REASON_LOCAL_MAC,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of core drop reasons, which
 	 * shouldn't be used as a real 'reason' - only for tracing code gen
-- 
2.50.1



