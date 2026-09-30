Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A607511E9B;
	Wed, 30 Sep 2026 16:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786476; cv=none; b=awY+hE0TOQItWG0UGmdX6s8mSjxnIIBUwYGSnoAtdUCHBVfbHdcxziTnvV4OH/HSDtfE9uD9lEldDz7uFQsKsduIT24GNV2Rvg3IePseRCduP61hFloKjlGf9XnBb5amgCq+xNm8OSKMSUF93f8Usm5w0WKlU9uJJTxkP+2FIAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786476; c=relaxed/simple;
	bh=egZ2EmrJ+KowUHlptcsIPKX1k3PUIQO9uUqgEM7cFfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USbsNcLbMkqQgDCsFyQ80lmVcZQYseNFUVo2DWy8a5eZQrFfLrxbXtUl3GgXCZkT097GPpNrhbg8cjuSusTjNT+ZVQnd5P8ABxN+mtSyHddDSL/H5xUn4fJhj6O692SkGcYG8GAg6HBtupAx9jBrbUSm+OHftPGwYZo077o7du8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crA4l8GI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crA4l8GI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0BC1F000FF;
	Wed, 30 Sep 2026 16:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786475;
	bh=Ybl8dhHGohArxEO8ufFv/B9bHHQCTptmflqMHqAXEwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=crA4l8GIRXQZCbqucD/YGgQfE54PIfrKGlVilXNAPH1fcY0RwKEClEL9ZuMm82A6H
	 5qIDocdzPAPMB+YTG1iCJyYly1wSnUThaMK/oHDqHBkf6v997Q1UqHIlIdjoHogtUH
	 ktFQsNDYq38Q9UaefYfP0TusMkpdJ6BaqzVHM8tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 873/982] net: stmmac: dwmac4: Use the correct bufzise when the len is exactly 8K
Date: Wed, 30 Sep 2026 17:26:49 +0200
Message-ID: <20260930152435.504173328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit b42e7012773a0e81e97a2dda6ef907f5147a6658 ]

DMA bufsize selection isn't made on the MTU but the actual frame length,
so including the L2 header. On DWMAC4, if the len is exactly BUF_SIZE_8KiB,
the next larger size is incorrectly selected.

Lets fix the comparison and while at it, rename the parameter from len
to mtu.

Fixes: c3efed5ad1b0 ("net: stmmac: Enable dwmac4 jumbo frame more than 8KiB").
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260917215339.2022523-6-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/hwif.h         | 2 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index 89a14084c6117..db47c8f6093c6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -477,11 +477,11 @@ static void dwmac4_set_sarc(struct dma_desc *p, u32 sarc_type)
 	p->des3 |= cpu_to_le32(sarc_type & TDES3_SA_INSERT_CTRL_MASK);
 }
 
-static int set_16kib_bfsize(int mtu)
+static int set_16kib_bfsize(int len)
 {
 	int ret = 0;
 
-	if (unlikely(mtu >= BUF_SIZE_8KiB))
+	if (unlikely(len > BUF_SIZE_8KiB))
 		ret = BUF_SIZE_16KiB;
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 19424af936d2b..c4fe5c3f3de39 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -565,7 +565,7 @@ struct stmmac_mode_ops {
 	unsigned int (*is_jumbo_frm) (int len, int ehn_desc);
 	int (*jumbo_frm)(struct stmmac_tx_queue *tx_q, struct sk_buff *skb,
 			 int csum);
-	int (*set_16kib_bfsize)(int mtu);
+	int (*set_16kib_bfsize)(int len);
 	void (*init_desc3)(struct dma_desc *p);
 	void (*refill_desc3)(struct stmmac_rx_queue *rx_q, struct dma_desc *p);
 	void (*clean_desc3)(struct stmmac_tx_queue *tx_q, struct dma_desc *p);
diff --git a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
index 45c14c1bb0eaa..88a8d22812f5d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
+++ b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
@@ -128,10 +128,10 @@ static void clean_desc3(struct stmmac_tx_queue *tx_q, struct dma_desc *p)
 		p->des3 = 0;
 }
 
-static int set_16kib_bfsize(int mtu)
+static int set_16kib_bfsize(int len)
 {
 	int ret = 0;
-	if (unlikely(mtu > BUF_SIZE_8KiB))
+	if (unlikely(len > BUF_SIZE_8KiB))
 		ret = BUF_SIZE_16KiB;
 	return ret;
 }
-- 
2.53.0



