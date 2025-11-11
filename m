Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E102857F0;
	Tue, 11 Nov 2025 01:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824003; cv=none; b=ZaDrGToiQ/zUoRKWoemDJDCtC0pUcYunrCrYIMK+hilUoZj55BnOWwtyRulFJzCwL74me10XiW1eh8rri4Hm4QXRCt2IC1TMlVWwzK/vLoiduLGFhcRpnHffkdhDR7Ea39pjqSWfgOSyqYiCcnJvbX30dvfEQ5RK0kvO8PttOnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824003; c=relaxed/simple;
	bh=6lM/pguu8u4rBcYzOI83pZ0roSQydo650M0kV/E/9PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBbcDvwc36FAGYt8ZddZ15VQFPjBTOX7D/6EuBDQUEo3B60WPhp5XWSNTDXJLjhR7dMbwNn2vzlWVugAseg9jOUYfp9E0ktFgyznEnh7VACVHGPPcJVSGJsYdVLt8G0L8I2BYnkKs4wb4gnaEP2or3fNj7MQE/DOU5Gymch7ha8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVAx2thM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVAx2thM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4F1C113D0;
	Tue, 11 Nov 2025 01:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824003;
	bh=6lM/pguu8u4rBcYzOI83pZ0roSQydo650M0kV/E/9PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVAx2thMakUZQy75dC2c8rmajxyz7lX1r68/1BHq7poRaiTqtg/c1csx3RxWp3ICB
	 xhwIXpahpqw70SsjbMHU6nkhecMCaeXgse7mzGjguurTfMEySwOc20lT8DaUncIAQJ
	 +xQrH71xrZh9jZEjdinOUhAhD1wlWM8IlJJtBAA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 418/849] drm/msm/dsi/phy: Toggle back buffer resync after preparing PLL
Date: Tue, 11 Nov 2025 09:39:48 +0900
Message-ID: <20251111004546.546514527@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 8c98f91a5930c..6b765f3fd529a 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
@@ -491,6 +491,10 @@ static int dsi_pll_7nm_vco_prepare(struct clk_hw *hw)
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



