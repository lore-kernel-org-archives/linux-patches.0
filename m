Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CE7256C67;
	Thu, 17 Apr 2025 18:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915016; cv=none; b=j5wlcSiPoHk+0WCkAV/QhrmueWFBfJdu+8X5Lap47nuypYlRid8Q8uxVJjFn5qNUpKkshFe9XQq94AuGx5UiRp1rsr6lHT5i5tWEJM3uezw5ixbeXQ16qUknFYOXbsi1Oi1S6kE6rUIrTsPZTOXmRNUJOa4GZWvsGq1yPDhA/GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915016; c=relaxed/simple;
	bh=2uC33N6dAELiBawe27/r/xTv7TTRwvqwvdgAyCYtNeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4wgJ6UtoJjv+hDSG8I28rOG/wyGDHUVTwEyPoxuQ7vFgwgwqiJ/r+Ga5QtWnzaYxc3n9EQb+U0jqXspD37ts4ct4UhJ0Un1UOMxM95wLic2EVMHHGaqiJH4mwWDmMnSvUWYldh4BdvRGFM4ZkI35KcOx/3eEDJbIsjHVamKAKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss1gsgc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss1gsgc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041FEC4CEE4;
	Thu, 17 Apr 2025 18:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915016;
	bh=2uC33N6dAELiBawe27/r/xTv7TTRwvqwvdgAyCYtNeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ss1gsgc4F8Og/+OX29CMhayBu9AJ5l9ssR6s++7hhID5SAED0rPbi9TC6EFy1Dkrx
	 CEWgBDPrqsSCW4SmmXdeTT7ldoTQmb6OcfbgLBrxCYuvQu3dlqyJCmwBgVTkANNpFf
	 fkIsl2mtoEHq7cdUMW67dyFw2AsoseK6KjT3nFL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 377/414] net: mana: Switch to page pool for jumbo frames
Date: Thu, 17 Apr 2025 19:52:15 +0200
Message-ID: <20250417175126.622161285@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haiyang Zhang <haiyangz@microsoft.com>

commit fa37a8849634db2dd3545116873da8cf4b1e67c6 upstream.

Frag allocators, such as netdev_alloc_frag(), were not designed to
work for fragsz > PAGE_SIZE.

So, switch to page pool for jumbo frames instead of using page frag
allocators. This driver is using page pool for smaller MTUs already.

Cc: stable@vger.kernel.org
Fixes: 80f6215b450e ("net: mana: Add support for jumbo frame")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Reviewed-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Link: https://patch.msgid.link/1742920357-27263-1-git-send-email-haiyangz@microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c |   46 +++++---------------------
 1 file changed, 9 insertions(+), 37 deletions(-)

--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -652,30 +652,16 @@ int mana_pre_alloc_rxbufs(struct mana_po
 	mpc->rxbpre_total = 0;
 
 	for (i = 0; i < num_rxb; i++) {
-		if (mpc->rxbpre_alloc_size > PAGE_SIZE) {
-			va = netdev_alloc_frag(mpc->rxbpre_alloc_size);
-			if (!va)
-				goto error;
-
-			page = virt_to_head_page(va);
-			/* Check if the frag falls back to single page */
-			if (compound_order(page) <
-			    get_order(mpc->rxbpre_alloc_size)) {
-				put_page(page);
-				goto error;
-			}
-		} else {
-			page = dev_alloc_page();
-			if (!page)
-				goto error;
+		page = dev_alloc_pages(get_order(mpc->rxbpre_alloc_size));
+		if (!page)
+			goto error;
 
-			va = page_to_virt(page);
-		}
+		va = page_to_virt(page);
 
 		da = dma_map_single(dev, va + mpc->rxbpre_headroom,
 				    mpc->rxbpre_datasize, DMA_FROM_DEVICE);
 		if (dma_mapping_error(dev, da)) {
-			put_page(virt_to_head_page(va));
+			put_page(page);
 			goto error;
 		}
 
@@ -1660,7 +1646,7 @@ drop:
 }
 
 static void *mana_get_rxfrag(struct mana_rxq *rxq, struct device *dev,
-			     dma_addr_t *da, bool *from_pool, bool is_napi)
+			     dma_addr_t *da, bool *from_pool)
 {
 	struct page *page;
 	void *va;
@@ -1671,21 +1657,6 @@ static void *mana_get_rxfrag(struct mana
 	if (rxq->xdp_save_va) {
 		va = rxq->xdp_save_va;
 		rxq->xdp_save_va = NULL;
-	} else if (rxq->alloc_size > PAGE_SIZE) {
-		if (is_napi)
-			va = napi_alloc_frag(rxq->alloc_size);
-		else
-			va = netdev_alloc_frag(rxq->alloc_size);
-
-		if (!va)
-			return NULL;
-
-		page = virt_to_head_page(va);
-		/* Check if the frag falls back to single page */
-		if (compound_order(page) < get_order(rxq->alloc_size)) {
-			put_page(page);
-			return NULL;
-		}
 	} else {
 		page = page_pool_dev_alloc_pages(rxq->page_pool);
 		if (!page)
@@ -1718,7 +1689,7 @@ static void mana_refill_rx_oob(struct de
 	dma_addr_t da;
 	void *va;
 
-	va = mana_get_rxfrag(rxq, dev, &da, &from_pool, true);
+	va = mana_get_rxfrag(rxq, dev, &da, &from_pool);
 	if (!va)
 		return;
 
@@ -2158,7 +2129,7 @@ static int mana_fill_rx_oob(struct mana_
 	if (mpc->rxbufs_pre)
 		va = mana_get_rxbuf_pre(rxq, &da);
 	else
-		va = mana_get_rxfrag(rxq, dev, &da, &from_pool, false);
+		va = mana_get_rxfrag(rxq, dev, &da, &from_pool);
 
 	if (!va)
 		return -ENOMEM;
@@ -2244,6 +2215,7 @@ static int mana_create_page_pool(struct
 	pprm.nid = gc->numa_node;
 	pprm.napi = &rxq->rx_cq.napi;
 	pprm.netdev = rxq->ndev;
+	pprm.order = get_order(rxq->alloc_size);
 
 	rxq->page_pool = page_pool_create(&pprm);
 


