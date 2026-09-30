Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8390B5187CA;
	Wed, 30 Sep 2026 16:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787329; cv=none; b=NcgXAWtQOo3Be8A7/vE8iHvNdSfi58jjv3JHoKjX5/oxIPknEQLj+hohJPoupboeKHTTNcWKq/4F2VkDVfK4qIRlWgDqy9P/lPgBozXkb6kaKBBRy5Oib8sEJqNpYUjf88uK4jIcCqLI2sI7Of6yd/P3K5PLf/G4tyVInlu6xiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787329; c=relaxed/simple;
	bh=RvrOTA20DSeQd5d6XXLLteZaOpxnhEefYrflN9wQBbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDyVfoXzNbTilQM1fm0pFok0U0xEBFDz4+kjRkK9ZN+MjrCsbZeXwapMxOwY03cPlUYuNYK3BYLaQkWD8NqosxYWZFeUFwlFuXgVODNDYyevKiyDNamY8G3kTjka4FvHguQWzaEizP49HBOMzdNUCsWJHn2UHbzhnPFM5PiVP/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1bbIB6A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1bbIB6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9B81F000FF;
	Wed, 30 Sep 2026 16:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787328;
	bh=ILV1NisR5T8XpQvo0/69Su76QTxPJCGrK5qKmGCdLmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r1bbIB6AsvdLrthOHw0wJgZL2iloSBlqaqJdDRJ0qqhTCgl/GrF1unzHz3RuYztpw
	 OMSVgcgnL1+gCjIKOVmXgdj5KUerEVgndBpY+r9OOJI2/p4iKuQG/YFbgoKAd9etOo
	 44kBuKYkIhREYG7P2IaZLRhADEieXIMQi+PyxJyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 191/457] net: stmmac: clear stale buf->page after recycling on skb build failure
Date: Wed, 30 Sep 2026 17:24:56 +0200
Message-ID: <20260930152350.175568408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 0a7822e34a0bfde31b194ac3da3253e5032b44cc ]

In stmmac_rx(), when napi_build_skb() fails the descriptor page is
recycled back to the page pool with page_pool_recycle_direct(), but
buf->page is left pointing at the recycled page, unlike every other
consumption site in the function which clears the pointer after handing
the page away.

With the stale pointer stmmac_rx_refill() skips the replacement
allocation and programs the already-recycled page back into the RX
descriptor.

Clear buf->page on the napi_build_skb() failure path to keep the buffer
lifecycle consistent with the other consumption sites.

Fixes: df542f669307 ("net: stmmac: Switch to zero-copy in non-XDP RX path")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260921-stmmac-fix-napi-build-skb-error-v1-1-3d54bf6d9bb6@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 9c4d92a19f2c0..29025eb416987 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5885,6 +5885,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			if (!skb) {
 				page_pool_recycle_direct(rx_q->page_pool,
 							 buf->page);
+				buf->page = NULL;
 				rx_dropped++;
 				count++;
 				goto drain_data;
-- 
2.53.0



