Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C9635CB78;
	Wed,  3 Dec 2025 16:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779202; cv=none; b=F26fL3i6yiK3sTzGO9LBQPTSch1JhidUWw8KncedeEUB2J3U+hvBD/5k9TtAuialLo3Sqsxmc6FtX+3PdoAQ3Mvrx/0G6PEwuwKC4cYeaBWFh06VirJ+esW2TJkfH7MTgEOxsUuMLQtlhG1rJ0AswVfxLgC7t4GlMxrKjRwyAWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779202; c=relaxed/simple;
	bh=8fXt2rgsW1IxFju5F5qJ52YXNVwe6wxFBVyyV8ZvJtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxIFDVOVZ+dZKftn9zjnTWx1G5a+FXvzwvsXheRkX6QqB+AEC7ywlpK+ztiwOShaBA//4/vV7wTwM/vV95Q+bn7yi4A+fNtZHoZ1cHvbJ+cqObtHz5fw0/7Isf3/voBxIuGP1YcTCbhLtuq/JsT44g/6a9Ntl8hzFPoWZlOveK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBB05fvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBB05fvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECF5C4CEF5;
	Wed,  3 Dec 2025 16:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779202;
	bh=8fXt2rgsW1IxFju5F5qJ52YXNVwe6wxFBVyyV8ZvJtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBB05fvfE+Wq28cSZ5j3iZfrladQfiRJikfcRzp13EM44raU9/6rhlMX5GrVgd11j
	 4Y8euJmOeki8D/IUBCVyxc4SAE8IDoG326gOwhuqoGdoo9uiFnp7S3+TArOLE5qFiK
	 zgertDvQpQBdv+38UXZslt2YMjNzJ8vFd/X4OU2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 186/568] drm/msm/dsi/phy: Toggle back buffer resync after preparing PLL
Date: Wed,  3 Dec 2025 16:23:08 +0100
Message-ID: <20251203152447.538856583@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit b63f008f395ca5f6bc89123db97440bdc19981c4 ]

According to Hardware Programming Guide for DSI PHY, the retime buffer
resync should be done after PLL clock users (byte_clk and intf_byte_clk)
are enabled.  Downstream also does it as part of configuring the PLL.

Driver was only turning off the resync FIFO buffer, but never bringing it
on again.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/657823/
Link: https://lore.kernel.org/r/20250610-b4-sm8750-display-v6-6-ee633e3ddbff@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
index 9e7fa7d88ead2..9f2806b9e1740 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
@@ -400,6 +400,10 @@ static int dsi_pll_7nm_vco_prepare(struct clk_hw *hw)
 	if (pll_7nm->slave)
 		dsi_pll_enable_global_clk(pll_7nm->slave);
 
+	writel(0x1, pll_7nm->phy->base + REG_DSI_7nm_PHY_CMN_RBUF_CTRL);
+	if (pll_7nm->slave)
+		writel(0x1, pll_7nm->slave->phy->base + REG_DSI_7nm_PHY_CMN_RBUF_CTRL);
+
 error:
 	return rc;
 }
-- 
2.51.0



