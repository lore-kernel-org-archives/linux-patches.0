Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C302D51CF51;
	Wed, 30 Sep 2026 17:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788380; cv=none; b=ll17Snd2A9vMn/JTtPeyDGiUJB7Pf8i9xs/LBsSQawl23GiUnJlrdqAVJhIqmucdGE+skxCHaN2XCdsUyVx+d33Hjk2uHEMT6UyPGRd1GKTzaSEOYwSD+MgdLTKWmzv8HJK6pcjJ/YRrP7BaEgVS6h1KlGquVa8ySZUhFFtw7iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788380; c=relaxed/simple;
	bh=kdvWwu9QTOw6S9Hc0ybwyd6gbnbog7a5v7lkiTM7AII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H69EerhvJNxHWNV/oYkV39wQhDqfIMpMTbG8RH8R5xaB62n3IRUPnDKAeXo0ZDc5fpT/TRLzJQLi2w1MHq7ibOwZqTb6WVEH0Ioq4aLgIxAbADgYpNVoiz/2mGgHPU6mrf9Lhmrjv89fS53NNuSSI94gNiCncMIv5DSmByAB7Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZ844+eq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZ844+eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A951F00898;
	Wed, 30 Sep 2026 17:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788379;
	bh=ADTbj5eS9RnMyMu7wFaYSIC2JiZpJY+YnQmm8Kkz5Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZ844+eqtnYBR8aJ0pMie+Zy8hsAaLWBNm9ksyFb226ES+1BaO3lWv/6Twbo7Df/e
	 xgtQJYBU56fZ2d6QMfQPMqlNAhzKM3KPdRDoFqfeFifPLnCFgaB06Fk/8a73eSgJWr
	 xuUj8jAtCw7tL/MlWdOhCKFUiPAhIuu1FW/eVY0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/877] phy: mediatek: phy-mtk-hdmi-mt8195: Fix PLL calc divisor overflow
Date: Wed, 30 Sep 2026 17:16:53 +0200
Message-ID: <20260930152416.941040863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit de7f29a1fe1dc2864d8a47f8c39d508442cae167 ]

When trying to calculate a PLL rate for target display resolutions
above 2560x1440, 24bpp, 30Hz, the pixel clock value will be more
than 32-bits long but the division to finally calculate the digital
clock divider is being done with div_u64(), which expects a 32bit
unsigned divisor.

Fix the overflow by using div64_u64() instead.

Fixes: 9d9ff3d2a4a5 ("phy: mediatek: hdmi: mt8195: fix wrong pll calculus")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260911074015.9994-2-angelogioacchino.delregno@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c b/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c
index bbfe11d6a69d7..80600b2b6b38d 100644
--- a/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c
+++ b/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c
@@ -288,7 +288,7 @@ static int mtk_hdmi_pll_calc(struct mtk_hdmi_phy *hdmi_phy, struct clk_hw *hw,
 	posdiv2 = 1;
 
 	/* Digital clk divider, max /32 */
-	digital_div = div_u64(ns_hdmipll_ck, posdiv1 * posdiv2 * pixel_clk);
+	digital_div = div64_u64(ns_hdmipll_ck, posdiv1 * posdiv2 * pixel_clk);
 	if (!(digital_div <= 32 && digital_div >= 1))
 		return -EINVAL;
 
-- 
2.53.0



