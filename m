Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD39DF59;
	Wed,  5 Feb 2025 15:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768360; cv=none; b=PYqlle8U7VSqIXPj/7O2iBg/1qCDSyimoPKVhluLBF85+PCPazQUj5+bHgtFfRpMxDNX+rRIWYGQi5qQDSzONPopCwTpLJhwgSXWCsImMfmZT4pSIZKSJHWLFfhUepDMGEkdsxmNGFL/TZBg1FT7TMdbjblyiIDLd94pfSlHpIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768360; c=relaxed/simple;
	bh=NqQIHx58ywKLISQfEF2KZGGtvuWcbMtfAlqbxg7Kokg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1Xtlbs/vyN6jw1iZQglascN9j9tKW547LfutoSKP7ovkrAAs2KZ0lp0j1TbJoOLkqgIE/fF4Poj4DHsAO87wefU7D9Bnwxx6yBwQANX2icp52wGLCqNApNh5ySBlf1RXxs9sjhhncBP0+v0RlafpspkS1IcPguS9+xAMCN0VxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nh3rf3U9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nh3rf3U9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595B3C4CED1;
	Wed,  5 Feb 2025 15:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768359;
	bh=NqQIHx58ywKLISQfEF2KZGGtvuWcbMtfAlqbxg7Kokg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nh3rf3U94naxu3aSCpTK4yt157V3BUw74HsTDltxXt6IkJDUY8m7X0inasxRrVRrQ
	 hf2yHwGpAMWr6PmYr5nk+4lDLL89y9vYnFDgpwykzqnZMcY2hhLQbEJXfRF6FXY03x
	 7vkW4tFYRRyBuc12p25KPP3CDiZHej2oB5Tkn9O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 535/623] net: stmmac: Limit the number of MTL queues to hardware capability
Date: Wed,  5 Feb 2025 14:44:37 +0100
Message-ID: <20250205134516.691763141@linuxfoundation.org>
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

[ Upstream commit f5fb35a3d6b36d378b2e2ecbfb9caa337d5428e6 ]

The number of MTL queues to use is specified by the parameter
"snps,{tx,rx}-queues-to-use" from stmmac_platform layer.

However, the maximum numbers of queues are constrained by upper limits
determined by the capability of each hardware feature. It's appropriate
to limit the values not to exceed the upper limit values and display
a warning message.

This only works if the hardware capability has the upper limit values.

Fixes: d976a525c371 ("net: stmmac: multiple queues dt configuration")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Reviewed-by: Yanteng Si <si.yanteng@linux.dev>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c81ea8cdfe6eb..17a5be4f57c8d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7175,6 +7175,21 @@ static int stmmac_hw_init(struct stmmac_priv *priv)
 	if (priv->dma_cap.tsoen)
 		dev_info(priv->device, "TSO supported\n");
 
+	if (priv->dma_cap.number_rx_queues &&
+	    priv->plat->rx_queues_to_use > priv->dma_cap.number_rx_queues) {
+		dev_warn(priv->device,
+			 "Number of Rx queues (%u) exceeds dma capability\n",
+			 priv->plat->rx_queues_to_use);
+		priv->plat->rx_queues_to_use = priv->dma_cap.number_rx_queues;
+	}
+	if (priv->dma_cap.number_tx_queues &&
+	    priv->plat->tx_queues_to_use > priv->dma_cap.number_tx_queues) {
+		dev_warn(priv->device,
+			 "Number of Tx queues (%u) exceeds dma capability\n",
+			 priv->plat->tx_queues_to_use);
+		priv->plat->tx_queues_to_use = priv->dma_cap.number_tx_queues;
+	}
+
 	priv->hw->vlan_fail_q_en =
 		(priv->plat->flags & STMMAC_FLAG_VLAN_FAIL_Q_EN);
 	priv->hw->vlan_fail_q = priv->plat->vlan_fail_q;
-- 
2.39.5



