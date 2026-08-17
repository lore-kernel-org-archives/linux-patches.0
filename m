Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9F73E49E0;
	Mon, 17 Aug 2026 14:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976038; cv=none; b=AXKuZYM56uvRBnFRw5OkaIOtl/LMXbKqeR4GrFwRHK0qRuXhRPIvIvENROa68AHBvkuA0YfUO9A7QNuK1WNR/M+h6aNvRuwdWU2ZMtMmgGP6jbSP9IBSEal3WRyq+bDpuzsXIoRzyGuUa7dDCE0pULehdp9aC5leQ5llfS/8Wt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976038; c=relaxed/simple;
	bh=/44XFX3EGcInO8CU9UNkJTkzc0QVZh94sTeqveh/eV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGi7G5Yph3KRVSFI7tBroGHpp3ALH0zsgZsVr1OAjnefD9lGmVH/uAhX2/SDIaRTnEY1EFGRgGRq3o7u1ZydRa0OZlJmeQBlHgB0AyGva7h29FLrGo+8ijrgPKhpdv+Ia18zK8Cs9Fg8Y0TesrkdGo8wj5xFwKjfCEDCpk7Q38Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FHWj2F/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FHWj2F/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A569A1F000E9;
	Mon, 17 Aug 2026 14:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976037;
	bh=+0VUlychecJqIN+KgfE5JAXpd5qbA7njD78So12/oMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FHWj2F/yXNlSAvwiOYKiQtaudqO68HTM6U864/1Piz/vqNIRgixWIpZ9sIWmS6BU
	 Se9VFyi74sjLz+odDEkuKfwvlIpcV4Xi77+qIdIC5uAswpdelg8jFzt+WGqp0UoDxH
	 HuW7QgkTkCTfTrWHxcKE7vRgND1jh6k4EzVMcHnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 233/389] net: sxgbe: check descriptor ring allocation failures
Date: Mon, 17 Aug 2026 15:31:12 +0200
Message-ID: <20260817132548.352170781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 22405744b2a36..c2333b8224c61 100644
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



