Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CDC2FABFC;
	Tue, 12 Aug 2025 18:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025051; cv=none; b=FBEvS6mlra9wuMUwS5vmktzrpVLnH/ofEkN+MZ/xn+r+mnYU4Wm5Ca58LawlM95wmZU7TkT5J8gSD2oDELuKNL1tlqWCMVpRMMas6ejoSmnYY/7nS3U0sS1KXtvLvrB+LOg+CYzM2Dy2fM0LkTTo2IHxKEU5u0oDvn++GizsLo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025051; c=relaxed/simple;
	bh=ZDMJdX4XlEsc0TJUxzfKDLO/QkXEve8kcCriNjhw58U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6lJx5E8VhqH2TIgobhHQxS1y/y8BAnDi14AM7HYivpFo8bODa7tikR60b2WJMt6Y8xrBiJ9yKh17Ltzsdu1wayKQdqtChe2OLFAtikMqzB+XCLesmBStjWDht3iU8UgiQR+R4umk8xRcYG3HzKkmln7pFVaOBKvx9E4Wvz42MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mK6VUoCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mK6VUoCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E71C4CEF0;
	Tue, 12 Aug 2025 18:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025050;
	bh=ZDMJdX4XlEsc0TJUxzfKDLO/QkXEve8kcCriNjhw58U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mK6VUoCuc4dxc1m70na1aQ6RZTEuopPjXQ+dGoj5YeCvR2amMszGjO8Iz0DfKj0vq
	 xffyirNFsTqO9AHyu9Bp6e+1HEWVxg7kaSExXVpIuIxg0HfqUbwp7XBCMk1P3qUnyE
	 YyWJqbHwCNWIXhAFne+CF7hTmLLQJ7BJskgSOl5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 554/627] net: ti: icssg-prueth: Fix skb handling for XDP_PASS
Date: Tue, 12 Aug 2025 19:34:09 +0200
Message-ID: <20250812173452.975255138@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit d942fe13f72bec92f6c689fbd74c5ec38228c16a ]

emac_rx_packet() is a common function for handling traffic
for both xdp and non-xdp use cases. Use common logic for
handling skb with or without xdp to prevent any incorrect
packet processing. This patch fixes ping working with
XDP_PASS for icssg driver.

Fixes: 62aa3246f4623 ("net: ti: icssg-prueth: Add XDP support")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250803180216.3569139-1-m-malladi@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_common.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_common.c b/drivers/net/ethernet/ti/icssg/icssg_common.c
index 12f25cec6255..57e5f1c88f50 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_common.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_common.c
@@ -706,9 +706,9 @@ static int emac_rx_packet(struct prueth_emac *emac, u32 flow_id, u32 *xdp_state)
 	struct page_pool *pool;
 	struct sk_buff *skb;
 	struct xdp_buff xdp;
+	int headroom, ret;
 	u32 *psdata;
 	void *pa;
-	int ret;
 
 	*xdp_state = 0;
 	pool = rx_chn->pg_pool;
@@ -757,22 +757,23 @@ static int emac_rx_packet(struct prueth_emac *emac, u32 flow_id, u32 *xdp_state)
 		xdp_prepare_buff(&xdp, pa, PRUETH_HEADROOM, pkt_len, false);
 
 		*xdp_state = emac_run_xdp(emac, &xdp, page, &pkt_len);
-		if (*xdp_state == ICSSG_XDP_PASS)
-			skb = xdp_build_skb_from_buff(&xdp);
-		else
+		if (*xdp_state != ICSSG_XDP_PASS)
 			goto requeue;
+		headroom = xdp.data - xdp.data_hard_start;
+		pkt_len = xdp.data_end - xdp.data;
 	} else {
-		/* prepare skb and send to n/w stack */
-		skb = napi_build_skb(pa, PAGE_SIZE);
+		headroom = PRUETH_HEADROOM;
 	}
 
+	/* prepare skb and send to n/w stack */
+	skb = napi_build_skb(pa, PAGE_SIZE);
 	if (!skb) {
 		ndev->stats.rx_dropped++;
 		page_pool_recycle_direct(pool, page);
 		goto requeue;
 	}
 
-	skb_reserve(skb, PRUETH_HEADROOM);
+	skb_reserve(skb, headroom);
 	skb_put(skb, pkt_len);
 	skb->dev = ndev;
 
-- 
2.39.5



