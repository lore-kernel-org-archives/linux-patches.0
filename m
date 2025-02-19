Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2701CAA6F;
	Wed, 19 Feb 2025 08:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954870; cv=none; b=h5+GB7CcyD/IticRMh+dSoyC5YlGnGVXPBuu40I2/1fSpV2eSuP2EYwLJQXe4RVrpxBBbvs2JD2+qxGLO8PYAK1g8OvstJmVB97+UFkzmdFOVoKrqh6faMn1YVhF4GptXIvK9VHBRfnSNiZZKdb3K9+JivekTwM1LlDMYaHp3NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954870; c=relaxed/simple;
	bh=PniVTAYu6RvF+7NNSiznkLHx1Rzm9PGMi3uz/PyEwEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRKbygYr6WzBe3lU6MgR1Xzben4kbbFT/W7KXAiXhBK1do5LZEZwjkP2oeN7keeZl8mxNFH9vVArF3yhKo2QTv9lth1OXXuiisaHAsxy3v9Myws7TY6X8NqxBqKgwipe6IjbLeZefnVhOk7MYsihqfMEtOQs181bPvH98KK6ak8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsJBahSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsJBahSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF83C4CED1;
	Wed, 19 Feb 2025 08:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954870;
	bh=PniVTAYu6RvF+7NNSiznkLHx1Rzm9PGMi3uz/PyEwEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsJBahSmpMtRJBGjaRanUwVjOUtmGUa3pOIACU5kYjAW3HJb9apxGuZGGqyKsdY4M
	 jVr5NbQ0fTCD8DXAlKkVUzEm03tsQo/++xKExuAaSkbApQzi1lKonrg7PXqnMc5sAM
	 g3VNsugqmkwf7PbdjOAshSfuTGYXyX60+A8XkFFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/230] net: ethernet: ti: am65_cpsw: fix tx_cleanup for XDP case
Date: Wed, 19 Feb 2025 09:25:47 +0100
Message-ID: <20250219082602.886016845@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 14df3c0141679..3e090f87f97eb 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -585,16 +585,24 @@ static void am65_cpsw_nuss_xmit_free(struct am65_cpsw_tx_chn *tx_chn,
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



