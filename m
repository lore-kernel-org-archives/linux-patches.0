Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1CA18DF89;
	Sun,  7 Sep 2025 20:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277051; cv=none; b=NFAosVZLtqGmxz9yO1CmfyetzWLlYjkeC9fKcSkLbvh+agiDpNgVWq1AEWozybM9G3ztE+fkaXWQeql9Z5DD3ml5p1c2CinpPL86G9+cQCPaQvI8Jr5GK+xeNKthtipXRA/ywO3npEOwiqYV5ayfzOlMURUZ0XCCfyz5U5UBT0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277051; c=relaxed/simple;
	bh=OOyqdf+KtD1fcpVuqQCyfxMlNz129YS2PyzN/Q49TX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqWSHn16tVkhSxxubBnGNZ9AqVVq8m0UfpoRfThkaj5lnvl7a/6VGV7cVMoYbc6CmxuD0XsocutKWdLDzSI9i6wZaoytgrJ4BNiK94KbQhQ67JaGYbbMWr0neijUIaqRc5hZOudOYusTIBebb+rRel2KVZoj7b3uKdPIoE7JJrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpNm0WFc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpNm0WFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43D7C4CEF0;
	Sun,  7 Sep 2025 20:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277051;
	bh=OOyqdf+KtD1fcpVuqQCyfxMlNz129YS2PyzN/Q49TX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpNm0WFcU4xeFMp4L6NAqd/flQoHlZ/MXWq//Mmgf1vC4u3tSSkwLkEk087Z8bo6d
	 4KfCQV5TP3Pu0nTXqshG3JE3kmafggH3SrZ5xbE7Ij6LQl7goe7c6cJqm9XGYL1P+i
	 xeXmrtlZ5espY2d7Wi3FkvLX5lg00QQ0ApGd4T/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/175] net: vxlan: use kfree_skb_reason() in vxlan_xmit()
Date: Sun,  7 Sep 2025 21:57:44 +0200
Message-ID: <20250907195616.469344664@linuxfoundation.org>
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

[ Upstream commit b71a576e452b800efeac49ecca116d954601d911 ]

Replace kfree_skb() with kfree_skb_reason() in vxlan_xmit(). Following
new skb drop reasons are introduced for vxlan:

/* no remote found for xmit */
SKB_DROP_REASON_VXLAN_NO_REMOTE
/* packet without necessary metadata reached a device which is
 * in "external" mode
 */
SKB_DROP_REASON_TUNNEL_TXINFO

Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 1f5d2fd1ca04 ("vxlan: Fix NPD in {arp,neigh}_reduce() when using nexthop objects")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 6 +++---
 include/net/dropreason-core.h  | 9 +++++++++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index d9077698c5a89..40f01a6aaed38 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2724,7 +2724,7 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 			if (info && info->mode & IP_TUNNEL_INFO_TX)
 				vxlan_xmit_one(skb, dev, vni, NULL, false);
 			else
-				kfree_skb(skb);
+				kfree_skb_reason(skb, SKB_DROP_REASON_TUNNEL_TXINFO);
 			return NETDEV_TX_OK;
 		}
 	}
@@ -2787,7 +2787,7 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 			dev_core_stats_tx_dropped_inc(dev);
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_TX_DROPS, 0);
-			kfree_skb(skb);
+			kfree_skb_reason(skb, SKB_DROP_REASON_VXLAN_NO_REMOTE);
 			return NETDEV_TX_OK;
 		}
 	}
@@ -2810,7 +2810,7 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (fdst)
 			vxlan_xmit_one(skb, dev, vni, fdst, did_rsc);
 		else
-			kfree_skb(skb);
+			kfree_skb_reason(skb, SKB_DROP_REASON_VXLAN_NO_REMOTE);
 	}
 
 	return NETDEV_TX_OK;
diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index fbf92d442c1b2..d59bb96c5a02c 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -96,7 +96,9 @@
 	FN(VXLAN_VNI_NOT_FOUND)		\
 	FN(MAC_INVALID_SOURCE)		\
 	FN(VXLAN_ENTRY_EXISTS)		\
+	FN(VXLAN_NO_REMOTE)		\
 	FN(IP_TUNNEL_ECN)		\
+	FN(TUNNEL_TXINFO)		\
 	FN(LOCAL_MAC)			\
 	FNe(MAX)
 
@@ -439,11 +441,18 @@ enum skb_drop_reason {
 	 * entry or an entry pointing to a nexthop.
 	 */
 	SKB_DROP_REASON_VXLAN_ENTRY_EXISTS,
+	/** @SKB_DROP_REASON_VXLAN_NO_REMOTE: no remote found for xmit */
+	SKB_DROP_REASON_VXLAN_NO_REMOTE,
 	/**
 	 * @SKB_DROP_REASON_IP_TUNNEL_ECN: skb is dropped according to
 	 * RFC 6040 4.2, see __INET_ECN_decapsulate() for detail.
 	 */
 	SKB_DROP_REASON_IP_TUNNEL_ECN,
+	/**
+	 * @SKB_DROP_REASON_TUNNEL_TXINFO: packet without necessary metadata
+	 * reached a device which is in "external" mode.
+	 */
+	SKB_DROP_REASON_TUNNEL_TXINFO,
 	/**
 	 * @SKB_DROP_REASON_LOCAL_MAC: the source MAC address is equal to
 	 * the MAC address of the local netdev.
-- 
2.50.1



