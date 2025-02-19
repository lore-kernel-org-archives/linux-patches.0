Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F263E1CAA7D;
	Wed, 19 Feb 2025 08:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953963; cv=none; b=cVPiREeTcxEXDVEP+nuTl9qv4cN4XfYG0rD/lYuq5yjKBUWnxSreLb3v1Os5I+5EAk1GwBr9DbJUURu7TmrT3wpUlRCwVx0N/wOL25p2X3i1GigPbt9mRKPFYfMtg6LCwTqvAFfJojYKwSzgqf4dOYb2lDAhqbPYeRqfGXf7X4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953963; c=relaxed/simple;
	bh=ea0mwmA47dyuzNDULzHLDJGvulEVJd52RxnGI6X0diw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=No/YpLnO2RPiB6On9ZN+5auL+H4QlHAEwTDpXy5c7Bv+w0RrHBXVWfF9POggNZIpAiNcTaVUqhI4S9gR2tR6AHlurxXgRfOKoRFW/PGc5tt7EeIhUvDY63qKcnGgGBjUyU0+7V+TPBWg5kKY65TBgvsX0L/KqRwxiX+//4bVpA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2oFLnvPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2oFLnvPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B253C4CEE9;
	Wed, 19 Feb 2025 08:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953962;
	bh=ea0mwmA47dyuzNDULzHLDJGvulEVJd52RxnGI6X0diw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2oFLnvPP8AoEwe7HjDWuQO6iYkNvHu91FvYXNE73Bn5ol0i+TUbF1DLZnliusRhvY
	 nBVWYqYbUYa+QbIn3sRX9yf6HnastS7S/bg+v26Q98eUji+5Fr1Omf4c+gh+7IHmMK
	 aclfqThZd69zCMjEaUSKyYPRguuz2FqQb2WzTtpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 035/274] net: ethernet: ti: am65_cpsw: fix tx_cleanup for XDP case
Date: Wed, 19 Feb 2025 09:24:49 +0100
Message-ID: <20250219082610.904262115@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Roger Quadros <rogerq@kernel.org>

[ Upstream commit 4542536f664f752db5feba2c5998b165933c34f2 ]

For XDP transmit case, swdata doesn't contain SKB but the
XDP Frame. Infer the correct swdata based on buffer type
and return the XDP Frame for XDP transmit case.

Signed-off-by: Roger Quadros <rogerq@kernel.org>
Fixes: 8acacc40f733 ("net: ethernet: ti: am65-cpsw: Add minimal XDP support")
Link: https://patch.msgid.link/20250210-am65-cpsw-xdp-fixes-v1-3-ec6b1f7f1aca@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 43a3f36f0d220..f4ddacff08469 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -684,16 +684,24 @@ static void am65_cpsw_nuss_xmit_free(struct am65_cpsw_tx_chn *tx_chn,
 static void am65_cpsw_nuss_tx_cleanup(void *data, dma_addr_t desc_dma)
 {
 	struct am65_cpsw_tx_chn *tx_chn = data;
+	enum am65_cpsw_tx_buf_type buf_type;
 	struct cppi5_host_desc_t *desc_tx;
+	struct xdp_frame *xdpf;
 	struct sk_buff *skb;
 	void **swdata;
 
 	desc_tx = k3_cppi_desc_pool_dma2virt(tx_chn->desc_pool, desc_dma);
 	swdata = cppi5_hdesc_get_swdata(desc_tx);
-	skb = *(swdata);
-	am65_cpsw_nuss_xmit_free(tx_chn, desc_tx);
+	buf_type = am65_cpsw_nuss_buf_type(tx_chn, desc_dma);
+	if (buf_type == AM65_CPSW_TX_BUF_TYPE_SKB) {
+		skb = *(swdata);
+		dev_kfree_skb_any(skb);
+	} else {
+		xdpf = *(swdata);
+		xdp_return_frame(xdpf);
+	}
 
-	dev_kfree_skb_any(skb);
+	am65_cpsw_nuss_xmit_free(tx_chn, desc_tx);
 }
 
 static struct sk_buff *am65_cpsw_build_skb(void *page_addr,
-- 
2.39.5



