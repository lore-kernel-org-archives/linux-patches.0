Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B041DF736;
	Wed,  6 Nov 2024 12:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895983; cv=none; b=ZhfIs2RDPlSYqdSKQZgHuovhDPDXRrmAIRji2PTBvO4I+syNbHJX5FJ4UjUbHgR4DWFVzhvWhSIQw3LAPyMa8Q+WtMrQ0CNFVen+273KAxz7XT/cqu1SDSSbtcVoUTLKHrsYSoMErxfDQ71xPZEcNN+ED2MtRRSum2mwiQqNyOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895983; c=relaxed/simple;
	bh=+hPWS5KaV7wyFKV3CRc8n866FeZd0goqdsnpSiRLMjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqPdBhVRL/hzCZO/r6VrDouDTWTWsXX3Dma2+T3QUUXUQDPxG32dSQ8cInnrU8r24qKBJYcotUQwMUnVXA4gszuYAn/gb92M174p40wJUvsYafNaavozU1/Cc2/cRZ7LQ4ERXu0rGdCrZ/VbocY/Jf2Hd8x3kD+ftcGu8SUXz9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flZtMdF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flZtMdF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0776EC4CECD;
	Wed,  6 Nov 2024 12:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895983;
	bh=+hPWS5KaV7wyFKV3CRc8n866FeZd0goqdsnpSiRLMjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flZtMdF9lg4XP0a4DGngZunfnpVPOgEM7vihQhpYgi8jkPqO+MY92KnT0BQHg9V1f
	 DKwVt2e+iwqc80Yts2oG9ESu3AATwmx4y9IOEVByOZqE9ajQDPcocjj/GpiNfnVSDB
	 vkadSGSP02Hb7bqYNacf7chzLP6Co4JDs4sZaxeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@resnulli.us>,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 051/245] mlxsw: pci: Sync Rx buffers for CPU
Date: Wed,  6 Nov 2024 13:01:44 +0100
Message-ID: <20241106120320.477596438@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit 15f73e601a9c67aa83bde92b2d940a6532d8614d ]

When Rx packet is received, drivers should sync the pages for CPU, to
ensure the CPU reads the data written by the device and not stale
data from its cache.

Add the missing sync call in Rx path, sync the actual length of data for
each fragment.

Cc: Jiri Pirko <jiri@resnulli.us>
Fixes: b5b60bb491b2 ("mlxsw: pci: Use page pool for Rx buffers allocation")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/461486fac91755ca4e04c2068c102250026dcd0b.1729866134.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 060e5b9392114..2320a5f323b45 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -389,15 +389,27 @@ static void mlxsw_pci_wqe_frag_unmap(struct mlxsw_pci *mlxsw_pci, char *wqe,
 	dma_unmap_single(&pdev->dev, mapaddr, frag_len, direction);
 }
 
-static struct sk_buff *mlxsw_pci_rdq_build_skb(struct page *pages[],
+static struct sk_buff *mlxsw_pci_rdq_build_skb(struct mlxsw_pci_queue *q,
+					       struct page *pages[],
 					       u16 byte_count)
 {
+	struct mlxsw_pci_queue *cq = q->u.rdq.cq;
 	unsigned int linear_data_size;
+	struct page_pool *page_pool;
 	struct sk_buff *skb;
 	int page_index = 0;
 	bool linear_only;
 	void *data;
 
+	linear_only = byte_count + MLXSW_PCI_RX_BUF_SW_OVERHEAD <= PAGE_SIZE;
+	linear_data_size = linear_only ? byte_count :
+					 PAGE_SIZE -
+					 MLXSW_PCI_RX_BUF_SW_OVERHEAD;
+
+	page_pool = cq->u.cq.page_pool;
+	page_pool_dma_sync_for_cpu(page_pool, pages[page_index],
+				   MLXSW_PCI_SKB_HEADROOM, linear_data_size);
+
 	data = page_address(pages[page_index]);
 	net_prefetch(data);
 
@@ -405,11 +417,6 @@ static struct sk_buff *mlxsw_pci_rdq_build_skb(struct page *pages[],
 	if (unlikely(!skb))
 		return ERR_PTR(-ENOMEM);
 
-	linear_only = byte_count + MLXSW_PCI_RX_BUF_SW_OVERHEAD <= PAGE_SIZE;
-	linear_data_size = linear_only ? byte_count :
-					 PAGE_SIZE -
-					 MLXSW_PCI_RX_BUF_SW_OVERHEAD;
-
 	skb_reserve(skb, MLXSW_PCI_SKB_HEADROOM);
 	skb_put(skb, linear_data_size);
 
@@ -425,6 +432,7 @@ static struct sk_buff *mlxsw_pci_rdq_build_skb(struct page *pages[],
 
 		page = pages[page_index];
 		frag_size = min(byte_count, PAGE_SIZE);
+		page_pool_dma_sync_for_cpu(page_pool, page, 0, frag_size);
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 				page, 0, frag_size, PAGE_SIZE);
 		byte_count -= frag_size;
@@ -760,7 +768,7 @@ static void mlxsw_pci_cqe_rdq_handle(struct mlxsw_pci *mlxsw_pci,
 	if (err)
 		goto out;
 
-	skb = mlxsw_pci_rdq_build_skb(pages, byte_count);
+	skb = mlxsw_pci_rdq_build_skb(q, pages, byte_count);
 	if (IS_ERR(skb)) {
 		dev_err_ratelimited(&pdev->dev, "Failed to build skb for RDQ\n");
 		mlxsw_pci_rdq_pages_recycle(q, pages, num_sg_entries);
-- 
2.43.0



