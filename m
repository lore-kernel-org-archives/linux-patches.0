Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27D52F548F;
	Tue, 12 Aug 2025 19:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026700; cv=none; b=gCmnQWGLB5ZDyIgpJWM00IOQGh1AYGyFHQMqvIFgD2zl30ePnCUHdLR0hv2h8dH4LKISkp1Jt/sNGlPmRQFARUUubo7fp18Cez2RAkagQZRogSAUq2hENw7hjkVjwGOQ1B6mVKJ76vfq44UHFqMoRztQUXVbjnmckJQf229afjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026700; c=relaxed/simple;
	bh=/jqdJtBPw0b2eugU/NYwsG2FcZAep6yOzQuehLRyTDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCkq/bimTRcuQEgDM2GF0Nnhn3uuLoY0+MpVu2f363GFpF016+5twq6hgfS1czPZOrVgvxfQxz9z40a7ajURJQFaRYlu6OLKJ1+85YKTW4IYOqkUD88Kf77h1VltUEMhG/qrYWEm9ez5fDCkmNZDOB8e3c24OkGfKHI+zZEGZt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+u8IOey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+u8IOey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C12C4CEF0;
	Tue, 12 Aug 2025 19:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026699;
	bh=/jqdJtBPw0b2eugU/NYwsG2FcZAep6yOzQuehLRyTDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+u8IOeyLFVzHA8GqdDhq6Ps0qxEzXX3eYjfO/6OYQQbjv936eYt/e8pAUJ/qyAz4
	 BmofKAiCeo/xK+fY7mGYxs4sThx2tA7kq37pSmGsL5ErEwfZVrKKd/u7x0e0yRgHVo
	 rMDEkeZesQObf5q0bQyx4DhOyP/1ANEvTzrZLuXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 415/480] net: ti: icssg-prueth: Fix skb handling for XDP_PASS
Date: Tue, 12 Aug 2025 19:50:23 +0200
Message-ID: <20250812174414.534201110@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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
index 7ae069e7af92..3579e07be3da 100644
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



