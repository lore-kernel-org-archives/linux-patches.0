Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED3239B949
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302575; cv=none; b=j9MILXOd7WvENYuuBLxYWafHlnc7PHW9leq61XMwRKQGc4MbNBEUctbNRPC12R8OsU5xQ+XSFlTiMWUmhT0zUW71mlKJNIGwcfsOmGirfNucFMvdSuv0tBbdXjcGVGLuC5fyGjl1FGEVq0/3bnWl2ssm58b7KRVOgPTqMB6MNlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302575; c=relaxed/simple;
	bh=hRSacRjksaJrm0RAaFhoDgjdgdZwh4RmZztuBidt2bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgBMEupQoavUy97E9K31P9hiXOThozyHnHsHV+lImnpile0xFJmiHjixo6SykaFJp8DinPDkhUytEEREmDtoAezv0mwhs4FzU5SLwbbTtFxt/UP2m1W/J/4LEO1vBwCycVpevPCRasbFx0dpxfc/7yYPwi9j1aDOpqvPJD5j5Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pPWkXcI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pPWkXcI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6E2C116D0;
	Sat, 28 Feb 2026 18:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302575;
	bh=hRSacRjksaJrm0RAaFhoDgjdgdZwh4RmZztuBidt2bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPWkXcI0nDHPH0DaIqMezt/1G4gZCGzg1lE4MG6nmTkqiwNF0eCh3MaAeI+K2SIBJ
	 R7bL529H5nKLV456AfgAziCzd5cBT8gyaaPKliMRNRXfZdPFYr7r33gW+JbddshAhc
	 tgN59MJjYAdrWf9oq+bJLyMZ73tRIP4SDrAx+TVap7ckAHeqneelhLjue5acJS84aH
	 btmhAw0+qyloqAuG5biIedvlNEDDMX20Zmo3GkiWE2BILecK5Z5uAjyWUYavHI5snH
	 L7d3VgFYR0ciE+paIBvbHSedYMuJg7XfgVMz19pqIOwYlylQrM9WOH5K/GvuRYJsgh
	 4AAz122DcKxGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hao Chen <chenhao288@hisilicon.com>,
	Guangbin Huang <huangguangbin2@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/164] net: hns3: fix ethtool tx copybreak buf size indicating not aligned issue
Date: Sat, 28 Feb 2026 13:13:42 -0500
Message-ID: <20260228181505.1600663-83-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hao Chen <chenhao288@hisilicon.com>

[ Upstream commit 8778372118023e2258612c03573c47efef41d755 ]

When use ethtoool set tx copybreak buf size to a large value
which causes order exceeding 10 or memory is not enough,
it causes allocating tx copybreak buffer failed and print
"the active tx spare buf is 0, not enabled tx spare buffer",
however, use --get-tunable parameter query tx copybreak buf
size and it indicates setting value not 0.

So, it's necessary to change the print value from setting
value to 0.

Set kinfo.tx_spare_buf_size to 0 when set tx copybreak buf size failed.

Fixes: e445f08af2b1 ("net: hns3: add support to set/get tx copybreak buf size via ethtool for hns3 driver")
Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6d2f142b1e4b ("net: hns3: fix double free issue for tx spare buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 20 +++++++++++--------
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  3 ++-
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 5d410eacce081..b907d693631c2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1034,13 +1034,12 @@ static bool hns3_can_use_tx_sgl(struct hns3_enet_ring *ring,
 
 static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 {
+	u32 alloc_size = ring->tqp->handle->kinfo.tx_spare_buf_size;
 	struct hns3_tx_spare *tx_spare;
 	struct page *page;
-	u32 alloc_size;
 	dma_addr_t dma;
 	int order;
 
-	alloc_size = ring->tqp->handle->kinfo.tx_spare_buf_size;
 	if (!alloc_size)
 		return;
 
@@ -1050,30 +1049,35 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 	if (!tx_spare) {
 		/* The driver still work without the tx spare buffer */
 		dev_warn(ring_to_dev(ring), "failed to allocate hns3_tx_spare\n");
-		return;
+		goto devm_kzalloc_error;
 	}
 
 	page = alloc_pages_node(dev_to_node(ring_to_dev(ring)),
 				GFP_KERNEL, order);
 	if (!page) {
 		dev_warn(ring_to_dev(ring), "failed to allocate tx spare pages\n");
-		devm_kfree(ring_to_dev(ring), tx_spare);
-		return;
+		goto alloc_pages_error;
 	}
 
 	dma = dma_map_page(ring_to_dev(ring), page, 0,
 			   PAGE_SIZE << order, DMA_TO_DEVICE);
 	if (dma_mapping_error(ring_to_dev(ring), dma)) {
 		dev_warn(ring_to_dev(ring), "failed to map pages for tx spare\n");
-		put_page(page);
-		devm_kfree(ring_to_dev(ring), tx_spare);
-		return;
+		goto dma_mapping_error;
 	}
 
 	tx_spare->dma = dma;
 	tx_spare->buf = page_address(page);
 	tx_spare->len = PAGE_SIZE << order;
 	ring->tx_spare = tx_spare;
+	return;
+
+dma_mapping_error:
+	put_page(page);
+alloc_pages_error:
+	devm_kfree(ring_to_dev(ring), tx_spare);
+devm_kzalloc_error:
+	ring->tqp->handle->kinfo.tx_spare_buf_size = 0;
 }
 
 /* Use hns3_tx_spare_space() to make sure there is enough buffer
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 53f6cb3b43664..4c8f4ff66f0ec 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1807,7 +1807,8 @@ static int hns3_set_tunable(struct net_device *netdev,
 		old_tx_spare_buf_size = h->kinfo.tx_spare_buf_size;
 		new_tx_spare_buf_size = *(u32 *)data;
 		ret = hns3_set_tx_spare_buf_size(netdev, new_tx_spare_buf_size);
-		if (ret) {
+		if (ret ||
+		    (!priv->ring->tx_spare && new_tx_spare_buf_size != 0)) {
 			int ret1;
 
 			netdev_warn(netdev,
-- 
2.51.0

