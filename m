Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45689322744;
	Mon, 18 Aug 2025 13:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525550; cv=none; b=n867CaKfteZkGUrV97cmsdTdvfKuVv/7g/7akspueO2fmVl0MNe5wCzdMMY7kegGWriEM2zZjtKENBt0DsCgeHUiU3G+xSZBvFLjkpbIkLWXn63g9YQYUIJShxHMcEacN6llr2ON443ZsUVJ8xV3JLEsfX1axkHbhDzPfMyBQpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525550; c=relaxed/simple;
	bh=bB6svuVDeRaTIkoOsZg1DYBxXbl11hp9iJIveRwSI3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBmr5F1dgR1mJOX0cQ8pvzoE1TmtQYsXGzv40SBxADqH4IqKi3hwgC8y+rdOA9JSBdRvAwLdBPzDfkPpT6Vr7fU/S75tKpLczDfF9PcLrCcriKajGwq0XUkrL1YrNsW/wMHE9iJ8DyI5rBP4uQBb/vVITxHgxah5YouJbs3pESU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7d7GSuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7d7GSuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA71BC113D0;
	Mon, 18 Aug 2025 13:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525550;
	bh=bB6svuVDeRaTIkoOsZg1DYBxXbl11hp9iJIveRwSI3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7d7GSuSA1CPfrimMYAyNYcDF+kuxTSunbWAJp3wzkRUnPKzAQOz7umZM7JkPDd6g
	 74X2gdBONhZ95wbSrAtp9mhki1YlzvOG/fdd+hNiLzt431YzWdL0pfAGL6ENqet8d4
	 62Yrpt2EIHNl0GtCNDrDKwlL5e+4R1u7tThMjdgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 296/570] eth: bnxt: take page size into account for page pool recycling rings
Date: Mon, 18 Aug 2025 14:44:43 +0200
Message-ID: <20250818124517.252748940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f7dbedba63124256feb9d9fcf36e8a2e43858d1e ]

The Rx rings are filled with Rx buffers. Which are supposed to fit
packet headers (or MTU if HW-GRO is disabled). The aggregation buffers
are filled with "device pages". Adjust the sizes of the page pool
recycling ring appropriately, based on ratio of the size of the
buffer on given ring vs system page size. Otherwise on a system
with 64kB pages we end up with >700MB of memory sitting in every
single page pool cache.

Correct the size calculation for the head_pool. Since the buffers
there are always small I'm pretty sure I meant to cap the size
at 1k, rather than make it the lowest possible size. With 64k pages
1k cache with a 1k ring is 64x larger than we need.

Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250626165441.4125047-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e165490af6ac..25681c2343fb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3809,12 +3809,14 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 				   struct bnxt_rx_ring_info *rxr,
 				   int numa_node)
 {
+	const unsigned int agg_size_fac = PAGE_SIZE / BNXT_RX_PAGE_SIZE;
+	const unsigned int rx_size_fac = PAGE_SIZE / SZ_4K;
 	struct page_pool_params pp = { 0 };
 	struct page_pool *pool;
 
-	pp.pool_size = bp->rx_agg_ring_size;
+	pp.pool_size = bp->rx_agg_ring_size / agg_size_fac;
 	if (BNXT_RX_PAGE_MODE(bp))
-		pp.pool_size += bp->rx_ring_size;
+		pp.pool_size += bp->rx_ring_size / rx_size_fac;
 	pp.nid = numa_node;
 	pp.netdev = bp->dev;
 	pp.dev = &bp->pdev->dev;
@@ -3831,7 +3833,7 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 
 	rxr->need_head_pool = page_pool_is_unreadable(pool);
 	if (bnxt_separate_head_pool(rxr)) {
-		pp.pool_size = max(bp->rx_ring_size, 1024);
+		pp.pool_size = min(bp->rx_ring_size / rx_size_fac, 1024);
 		pp.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
 		pool = page_pool_create(&pp);
 		if (IS_ERR(pool))
-- 
2.39.5



