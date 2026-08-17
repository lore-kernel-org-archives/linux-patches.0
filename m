Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB5743E06B;
	Mon, 17 Aug 2026 14:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977308; cv=none; b=tlltAStB3t5Ji7ijkD4dLo38q6X255pelFCnnRvdy9MNnRDwLD5eZ7ShecB0UjNxNPxpw87G5UBx6MrX2sJIHM46PXhZVSCXBI6Q0hPzwFx1uMPxQoBlIl0Y82xbBmxofnTVHUDfF5Y/GQ8zODEhrjafjhXHni70obraGPBS7Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977308; c=relaxed/simple;
	bh=LcLcXGuZ6dv/AyMvb4SyN/AYb3Pg4HxlUxVSyAhfQa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+4bs28r7/yv5SciVp7rUHtSah0Gl5AX5drPAjZ/xNXZmPQwmBc7+Sc4LBUDNSQo5dgidEXfiaiI7PmYWy3sck2HmyNH4jErvFH4dKn+WEBMrFcEDTJ1KHj6hwJj2NxSVWenbX+5DcLAgUa4PSsrRGuR/vvQWqQGYNUa7RPJvuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSr4ab7W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSr4ab7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2FF1F000E9;
	Mon, 17 Aug 2026 14:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977307;
	bh=dGzUD2WZxNntD5quVuuyqYv9fuRcNgThpLmULAqOrVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OSr4ab7W5OVI/QdF0poMAT4uy08iomqxm9lhei2X2TsG/vPAgLtaHjmxKtixiuBb+
	 SIpng0o99wUFER/IiwYbMarbV1z/oP1xEuNGr0AEjYEQYrQHKqw3aHQ0kR07oGgDGr
	 RvIpKhNf/AQB4kv4P7cYWuHQmWCYURFAt/HAGPgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 285/456] net: sxgbe: check descriptor ring allocation failures
Date: Mon, 17 Aug 2026 15:31:15 +0200
Message-ID: <20260817132551.058069482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 51b093a7ba27476e1f639455f005e8d2e75390e4 ]

sxgbe_open() ignores the return value of init_dma_desc_rings() and
continues to program DMA with invalid ring addresses when allocation
fails. Check the return value and disconnect the PHY on failure.

Fixes: 1edb9ca69e8a ("net: sxgbe: add basic framework for Samsung 10Gb ethernet driver")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 8c3aad051c2e5..f453c546478a0 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1077,7 +1077,9 @@ static int sxgbe_open(struct net_device *dev)
 	priv->dma_buf_sz = SXGBE_ALIGN(DMA_BUFFER_SIZE);
 	priv->tx_tc = TC_DEFAULT;
 	priv->rx_tc = TC_DEFAULT;
-	init_dma_desc_rings(dev);
+	ret = init_dma_desc_rings(dev);
+	if (ret)
+		goto init_phy_error;
 
 	/* DMA initialization and SW reset */
 	ret = sxgbe_init_dma_engine(priv);
@@ -1186,6 +1188,7 @@ static int sxgbe_open(struct net_device *dev)
 
 init_error:
 	free_dma_desc_resources(priv);
+init_phy_error:
 	if (dev->phydev)
 		phy_disconnect(dev->phydev);
 phy_error:
-- 
2.53.0



