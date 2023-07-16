Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197488F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91961C433C8;
	Sun, 16 Jul 2023 20:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537781;
	bh=UpH7KtfEf8kS9CKfrFr0FbLTlw4g3WbDvJBKyWt7d54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tceWHhY0lW9Svu2x8F4ultNoDje0JQ6nW8h+rBPkmwGbhkxsr4XU8zAKTa6xP8jHA
	 psuFv5Jb4L1ijyDGjKXAxZC9kYLPCu2/P2Nie1MlynstbuF+oek5FuKoCpxYDo/aW3
	 Rriwj1usqM/9n4w4offaGLA+dC4IJcqUWCCo/T0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cambda Zhu <cambda@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 219/800] ipvlan: Fix return value of ipvlan_queue_xmit()
Date: Sun, 16 Jul 2023 21:41:12 +0200
Message-ID: <20230716194954.180980779@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cambda Zhu <cambda@linux.alibaba.com>

[ Upstream commit 8a9922e7be6d042fa00f894c376473b17a162b66 ]

ipvlan_queue_xmit() should return NET_XMIT_XXX, but
ipvlan_xmit_mode_l2/l3() returns rx_handler_result_t or NET_RX_XXX
in some cases. ipvlan_rcv_frame() will only return RX_HANDLER_CONSUMED
in ipvlan_xmit_mode_l2/l3() because 'local' is true. It's equal to
NET_XMIT_SUCCESS. But dev_forward_skb() can return NET_RX_SUCCESS or
NET_RX_DROP, and returning NET_RX_DROP(NET_XMIT_DROP) will increase
both ipvlan and ipvlan->phy_dev drops counter.

The skb to forward can be treated as xmitted successfully. This patch
makes ipvlan_queue_xmit() return NET_XMIT_SUCCESS for forward skb.

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230626093347.7492-1-cambda@linux.alibaba.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index ab5133eb1d517..e45817caaee8d 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -585,7 +585,8 @@ static int ipvlan_xmit_mode_l3(struct sk_buff *skb, struct net_device *dev)
 				consume_skb(skb);
 				return NET_XMIT_DROP;
 			}
-			return ipvlan_rcv_frame(addr, &skb, true);
+			ipvlan_rcv_frame(addr, &skb, true);
+			return NET_XMIT_SUCCESS;
 		}
 	}
 out:
@@ -611,7 +612,8 @@ static int ipvlan_xmit_mode_l2(struct sk_buff *skb, struct net_device *dev)
 					consume_skb(skb);
 					return NET_XMIT_DROP;
 				}
-				return ipvlan_rcv_frame(addr, &skb, true);
+				ipvlan_rcv_frame(addr, &skb, true);
+				return NET_XMIT_SUCCESS;
 			}
 		}
 		skb = skb_share_check(skb, GFP_ATOMIC);
@@ -623,7 +625,8 @@ static int ipvlan_xmit_mode_l2(struct sk_buff *skb, struct net_device *dev)
 		 * the skb for the main-dev. At the RX side we just return
 		 * RX_PASS for it to be processed further on the stack.
 		 */
-		return dev_forward_skb(ipvlan->phy_dev, skb);
+		dev_forward_skb(ipvlan->phy_dev, skb);
+		return NET_XMIT_SUCCESS;
 
 	} else if (is_multicast_ether_addr(eth->h_dest)) {
 		skb_reset_mac_header(skb);
-- 
2.39.2



