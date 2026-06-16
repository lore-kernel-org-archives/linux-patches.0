Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4467746AF2E;
	Tue, 16 Jun 2026 16:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627207; cv=none; b=A8si2GedAjSH0M9lbDfLC1ooIl8yxsD5EAurh6QyuQtQzGjNeGuVxtHVQatEM/Kmm4utUeXAE88O1wrN9011QIL9TnP5XqX2e9KSXRZrKQUiuEvc5qlVKgs+j0nFwouF5eLhzzZn9njgRt0kP0Dyu+tuyxf0SSSw1UzSZPKRicE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627207; c=relaxed/simple;
	bh=YmzAG44FQdDaPiG5tDxmHOmA61LKxMqNMBfNJ/tUl/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuKxxF8672K0z1buMGvJxAca7JAbQnZbuj+oldXeK51ammveNblyrEMAeDYpo6cRq8EtjmSaqr97CO1QANri5EKTUuaiTnhxGKI/xOcxXxfYeo3LUEaKYMV4N+NaOJMYlp9ziZvuPkYltQt0NLZEUwH0axFrzl6kV3fMSmISREs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4mAy2KY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4mAy2KY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5373A1F000E9;
	Tue, 16 Jun 2026 16:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627206;
	bh=eQ1huwpOu3o2fMFPSF1GUSoi321Pa3PYJ3chn/SYCMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4mAy2KYIlniuJ2cQWluJhx3oAN53kCywwptI8/UFUSJ4+8mEIlm5efuoDjG0EksO
	 pX0BYjTuFbW3VllzTBe0KVtRyYcF1RN5gDVFYFe+tLKnlueCe1Vxc9jtXHPbatQrAd
	 UK5YsC2TL4/EOBvBFPPW/bTYQE3Mx4znZAdIOtj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Kubiak <michal.kubiak@intel.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/261] net: mvpp2: Add metadata support for xdp mode
Date: Tue, 16 Jun 2026 20:29:02 +0530
Message-ID: <20260616145049.865717419@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 9a45e193c88a55a536d7fd0ebfa29823d588c2cf ]

Set metadata size building the skb from xdp_buff in mvpp2 driver
mvpp2 driver sets xdp headroom to:

MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM

where

MVPP2_MH_SIZE 2
MVPP2_SKB_HEADROOM min(max(XDP_PACKET_HEADROOM, NET_SKB_PAD), 224)

so the headroom is large enough to contain xdp_frame and xdp metadata.
Please note this patch is just compiled tested.

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250318-mvneta-xdp-meta-v2-2-b6075778f61f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 77a6b90ce56b ("net: mvpp2: build skb from XDP-adjusted data on XDP_PASS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d5d2cbe127b0e7..e43d844b14aaef 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3928,13 +3928,13 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 
 	while (rx_done < rx_todo) {
 		struct mvpp2_rx_desc *rx_desc = mvpp2_rxq_next_desc_get(rxq);
+		u32 rx_status, timestamp, metasize = 0;
 		struct mvpp2_bm_pool *bm_pool;
 		struct page_pool *pp = NULL;
 		struct sk_buff *skb;
 		unsigned int frag_size;
 		dma_addr_t dma_addr;
 		phys_addr_t phys_addr;
-		u32 rx_status, timestamp;
 		int pool, rx_bytes, err, ret;
 		struct page *page;
 		void *data;
@@ -3997,7 +3997,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			xdp_init_buff(&xdp, bm_pool->frag_size, xdp_rxq);
 			xdp_prepare_buff(&xdp, data,
 					 MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM,
-					 rx_bytes, false);
+					 rx_bytes, true);
 
 			ret = mvpp2_run_xdp(port, xdp_prog, &xdp, pp, &ps);
 
@@ -4013,6 +4013,8 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 				ps.rx_bytes += rx_bytes;
 				continue;
 			}
+
+			metasize = xdp.data - xdp.data_meta;
 		}
 
 		if (frag_size)
@@ -4052,6 +4054,8 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 
 		skb_reserve(skb, MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM);
 		skb_put(skb, rx_bytes);
+		if (metasize)
+			skb_metadata_set(skb, metasize);
 		skb->ip_summed = mvpp2_rx_csum(port, rx_status);
 		skb->protocol = eth_type_trans(skb, dev);
 
-- 
2.53.0



