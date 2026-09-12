Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD05134752E;
	Sat, 12 Sep 2026 09:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205364; cv=none; b=CXJiKMUuij/8uci/j3Vr1a1x8Lc7omL3MU2ylFLg+s8GrPR9jTee0m6/TZn8SWB1wc+wwjtfL88Bq3TfOlpXQNwzsOcRlS+Wwylql/XMn1TkURnJJuRoSWNzVVv9s/nemMWdRTL+QrhUkTbKG18cVPhQKIhIvGB1pg6qyjIiOLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205364; c=relaxed/simple;
	bh=Rw9/C9zC6naZ4t/ZLtY2BsLQLNrs4sKHIEoZ9pIvW74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJzeAAxRoBZBtlH4En/qZKRtgr124Zfon1fnm9d0ACvxIfxv0sYndi6dal8P0jQb3m9oGVlj46pckxlEbq7p+BTLbQwVgqeSPRBCxOWOWldxQ0nWGw+0xS3u1nIBRQjtGY9Lg8N1qrdQRk4KtJAhR0pARFNuCK06nQ0v4mOHC6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtRnK3Yr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtRnK3Yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3481F000FF;
	Sat, 12 Sep 2026 09:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205362;
	bh=EhQ8fEDJluPENzxHqxA02L9qjwSQMi6JfKYMUhdhY34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DtRnK3Yr+2DQGb/J2QlHJbb0UY7AANNepGkGAQsYef2dKBHn4n2AdC/WboM4oQpDh
	 VjlioBquUu6u4ZKyEAQI4I7lyZ84Lwi4DUfQdXtWXOn8kSs4v5vLnsPtQRogS4WFfd
	 eDwqkogiitUZDRuu6YZ9zJyIKARxdExg1pqpfS9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1802/1815] net: stmmac: selftests: Dont test flow control for small rx fifos
Date: Sat, 12 Sep 2026 08:59:12 +0200
Message-ID: <20260912065731.339804402@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 96e8cb5527ce50c024a8e2d22d2bfedeccaf97d0 ]

On dwmac1000, dwmac4 and dwxgmac, we only emit pause frames if there's
at least 4096 bytes in each queue's fifo.

The phylink mac capabilities are still MAC_ASYM_PAUSE | MAC_SYM_PAUSE as
otherwise we won't be able to negotiate 'rx on' pause. ASYM only will
prevent negotiating 'rx off tx on', while SYM only doesn't really
matche the reality (not symmetric if we can only do RX pause).

Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260826140500.616466-7-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/stmicro/stmmac/stmmac_selftests.c   | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 5e99d8ca773d8..f97f32369e903 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -759,12 +759,24 @@ static int stmmac_test_flowctrl(struct stmmac_priv *priv)
 	struct phy_device *phydev = priv->dev->phydev;
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
 	struct stmmac_test_priv *tpriv;
+	unsigned int rx_fifo_size;
 	unsigned int pkt_count;
 	int i, ret = 0;
 
 	if (!phydev || (!phydev->pause && !phydev->asym_pause))
 		return -EOPNOTSUPP;
 
+	rx_fifo_size = priv->plat->rx_fifo_size;
+	if (!rx_fifo_size)
+		rx_fifo_size = priv->dma_cap.rx_fifo_size;
+
+	/* No pause frame is emitted if we don't have at least 4096 bytes per
+	 * queue, except on dwmac100.
+	 */
+	if (priv->plat->core_type != DWMAC_CORE_MAC100 &&
+	    rx_fifo_size / priv->plat->rx_queues_to_use < 4096)
+		return -EOPNOTSUPP;
+
 	tpriv = kzalloc_obj(*tpriv);
 	if (!tpriv)
 		return -ENOMEM;
@@ -778,9 +790,7 @@ static int stmmac_test_flowctrl(struct stmmac_priv *priv)
 	dev_add_pack(&tpriv->pt);
 
 	/* Compute minimum number of packets to make FIFO full */
-	pkt_count = priv->plat->rx_fifo_size;
-	if (!pkt_count)
-		pkt_count = priv->dma_cap.rx_fifo_size;
+	pkt_count = rx_fifo_size;
 	pkt_count /= 1400;
 	pkt_count *= 2;
 
-- 
2.53.0



