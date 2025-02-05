Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF7A16EB42;
	Wed,  5 Feb 2025 15:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768367; cv=none; b=qW1+ucwzorLVk1QmSgCRPDwBwV3dnbWWvQOzaze/Zqv/62nI4nN2FDz2p16sNak13tYxzimOU+7pMROQBWWcD4rgZ8XycWTz/KCT4fSnR59AXRGl6Z4ka2BEwFANugERCTA7qYoBBbQwX9MEihGNchD8naMthRITZ8N0tMto3DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768367; c=relaxed/simple;
	bh=FQczMoDCk5yZjYBJKdYiG4YLY7ldWxmIREp36DVeegg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rC42rjKHiO2ch+PpUivYeCH6ZuTJ76GuVQKUEpYjnZO3OZqsh33eH46ru5PkFT4zbn9m7MbVf4txBliLq4Jjp8XNFQ+54rz8lXxspa4nSQfuKkJVwSIdVK8zhg7ouPD3VSJEoXwSeYiMBul9RGGsgjn+hAz1FkIhjZqa9COGKeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ajo7zJTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ajo7zJTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A084C4CED6;
	Wed,  5 Feb 2025 15:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768366;
	bh=FQczMoDCk5yZjYBJKdYiG4YLY7ldWxmIREp36DVeegg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ajo7zJTKtDpIO+NShmMrvB91qrvHlkoK/+HSpjmaWpkp4qT1V83UtvSdQAVgxBGJq
	 P7pq2T9XAoTorzjfQcxfOFTlhQXiOQzM2m0c9rP6V24cphpfNrO/8ltaydsd2o5fwf
	 Ii3xCtC5fTm04NUtGacvmuDiHDTIUkRsm15PRwmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 536/623] net: stmmac: Limit FIFO size by hardware capability
Date: Wed,  5 Feb 2025 14:44:38 +0100
Message-ID: <20250205134516.729977655@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 044f2fbaa2725696ecbf1f02ba7ab0a8ccb7e1ae ]

Tx/Rx FIFO size is specified by the parameter "{tx,rx}-fifo-depth" from
stmmac_platform layer.

However, these values are constrained by upper limits determined by the
capabilities of each hardware feature. There is a risk that the upper
bits will be truncated due to the calculation, so it's appropriate to
limit them to the upper limit values and display a warning message.

This only works if the hardware capability has the upper limit values.

Fixes: e7877f52fd4a ("stmmac: Read tx-fifo-depth and rx-fifo-depth from the devicetree")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Reviewed-by: Yanteng Si <si.yanteng@linux.dev>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 17a5be4f57c8d..1bed3e7629faa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7190,6 +7190,21 @@ static int stmmac_hw_init(struct stmmac_priv *priv)
 		priv->plat->tx_queues_to_use = priv->dma_cap.number_tx_queues;
 	}
 
+	if (priv->dma_cap.rx_fifo_size &&
+	    priv->plat->rx_fifo_size > priv->dma_cap.rx_fifo_size) {
+		dev_warn(priv->device,
+			 "Rx FIFO size (%u) exceeds dma capability\n",
+			 priv->plat->rx_fifo_size);
+		priv->plat->rx_fifo_size = priv->dma_cap.rx_fifo_size;
+	}
+	if (priv->dma_cap.tx_fifo_size &&
+	    priv->plat->tx_fifo_size > priv->dma_cap.tx_fifo_size) {
+		dev_warn(priv->device,
+			 "Tx FIFO size (%u) exceeds dma capability\n",
+			 priv->plat->tx_fifo_size);
+		priv->plat->tx_fifo_size = priv->dma_cap.tx_fifo_size;
+	}
+
 	priv->hw->vlan_fail_q_en =
 		(priv->plat->flags & STMMAC_FLAG_VLAN_FAIL_Q_EN);
 	priv->hw->vlan_fail_q = priv->plat->vlan_fail_q;
-- 
2.39.5



