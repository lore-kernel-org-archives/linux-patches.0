Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07303101A7;
	Tue, 16 Jun 2026 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631659; cv=none; b=tJ06MUnDdfoMliojjhF05wG7v1kP342z+a+bOloP1fBZZFyfnexFzuwXk0nqwalEqpZdrL0QeB1wgHYxPRpCua4lezaq0Mo4dv/myBCB05khPcocyu1NrZnutjy25yhLThwKILgZnlGSQ5TKN6jeDXNsAuYNS3CrnbuoHgt/6RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631659; c=relaxed/simple;
	bh=J+a0kVoT8cwSBR0vWPF63gMgENc+uk6tZDx1tuezCKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaGpHmHgfUuDRvwp0WM/LJ5rbIkAhxDxdtiY6g6tMdxpdLtvFEBYz/b+7N2FueRzt9r4vYLU/cwGc7Hkqf6JIBkaoYxTJY/V6x288ss7BWJo6zPVzmRsFVUnhmIBJ5Vn+bOdPDhapRNELO6qcF+b8EOUQ6OWhCD/K4dUUyihgMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0q3aKYzG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0q3aKYzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15601F000E9;
	Tue, 16 Jun 2026 17:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631658;
	bh=lsllaLAGqciFjez1d9kuXITow6/fZV9NUN6F9ReD++8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0q3aKYzGoM6mIE7RrrGo9Q0Tcl2Xqe6n1mH5kt77we5iga+RWLjExKjISf+RGkFdD
	 cu0CgB0w25A5W4FCHbU9cF1PS3av1CSFOlqUpkq1dfujMDkALq4dH8mN/c9/8QoA81
	 EvgO8eFUUUs27Cg+JLLsQMYOwlUGgwmxNEKnWp0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Kubiak <michal.kubiak@intel.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 262/522] net: mvpp2: Add metadata support for xdp mode
Date: Tue, 16 Jun 2026 20:26:49 +0530
Message-ID: <20260616145138.199448516@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8403fc4e9e7176..4c299d8bb2392c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3915,13 +3915,13 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 
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
@@ -3984,7 +3984,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			xdp_init_buff(&xdp, bm_pool->frag_size, xdp_rxq);
 			xdp_prepare_buff(&xdp, data,
 					 MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM,
-					 rx_bytes, false);
+					 rx_bytes, true);
 
 			ret = mvpp2_run_xdp(port, xdp_prog, &xdp, pp, &ps);
 
@@ -4000,6 +4000,8 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 				ps.rx_bytes += rx_bytes;
 				continue;
 			}
+
+			metasize = xdp.data - xdp.data_meta;
 		}
 
 		skb = build_skb(data, frag_size);
@@ -4036,6 +4038,8 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 
 		skb_reserve(skb, MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM);
 		skb_put(skb, rx_bytes);
+		if (metasize)
+			skb_metadata_set(skb, metasize);
 		skb->ip_summed = mvpp2_rx_csum(port, rx_status);
 		skb->protocol = eth_type_trans(skb, dev);
 
-- 
2.53.0



