Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557EF37E5F3;
	Sat, 12 Sep 2026 08:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203217; cv=none; b=n3sjTE4OYGqYTr9AgcSbY1zPM/IfvGZSAbQenkTAu275fsExCVpM5LifM6i+z7DVqxu/9yKNEWIjaiTztNGUU0xa6Jlf6FNx650gB8GS8bm6wNNzKDx35XxsWS5NdmxKFgBtE1/E+5LyH/fVHY+7rM03KLlX0d6qkMlQKSO7YZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203217; c=relaxed/simple;
	bh=R3EWBHzaTPCSOEWYB5azE25Yq+WmWFt3qOi4zMM1RiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9hwQJ/+SRIjXEIPxHlWcaYgQnp3N1oBwTrMmZn370HBeEwiYoJ75COXwvTXX/I7B+JT24TlGBY7k5lZe9F7kZSgf5APhagRai5yK3fjQyR+ruuT+z+aS1tD/2bdipcOxOZraZCrQ2FTv88+kSaivI168PB7XOx+AzpCCCX5Yx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ke2LtaZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ke2LtaZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EAE1F000FF;
	Sat, 12 Sep 2026 08:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203216;
	bh=8GO63EURfoirSbBuuZZjLJyR8C1ZvlKzhqsrVRc04uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ke2LtaZ9+t3PV4iZz6V1E8SrUPvr4ZeO1UI2TddaU1Gw3ZV+P15je2JaGD37y/Dph
	 TLjubN8T8RCjCX5HNgc0bYcx/zagCtIbNazx7j2uQemuiozjQm4y0zs/6aqnzE7RnC
	 DW9ytCk/9dmAYZwa/f++VQKCxE4aTlP2JiVSAt9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1362/1815] phy: rockchip: samsung-hdptx: Guard against clk rate integer underflow
Date: Sat, 12 Sep 2026 08:51:52 +0200
Message-ID: <20260912065721.002720633@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 229788526ff24e0607726e93b74dd2ef157a99cd ]

The 'fout' subtraction in rk_hdptx_phy_clk_calc_rate_from_pll_cfg()
could result in an integer underflow, if the hardware registers are
misconfigured or contain uninitialized values, such that the computed
sigma-delta modulator offset sdm exceeds the base frequency fout.

This might lead to an absurdly high clock rate being returned to the
Common Clock Framework, with unpredictable effects on downstream clk
consumers.

Provide the necessary sanitization to avoid trusting the hardware state.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260611235702.0E9691F000E9@smtp.kernel.org/
Fixes: 3481fc04d969 ("phy: rockchip: samsung-hdptx: Compute clk rate from PLL config")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20260811-hdptx-clk-fixes-v6-3-75bca0ee5753@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
index d67ced2bf7b2c..3a65c26f3efab 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -2285,10 +2285,20 @@ static u64 rk_hdptx_phy_clk_calc_rate_from_pll_cfg(struct rk_hdptx_phy *hdptx)
 		sdm = div_u64(PLL_REF_CLK * ropll_hw.sdc_deno *
 			      ropll_hw.pms_mdiv * ropll_hw.sdm_num, val);
 
-		if (ropll_hw.sdm_num_sign)
+		if (ropll_hw.sdm_num_sign) {
+			if (sdm > fout) {
+				/*
+				 * Similarly to the case above, it is expected
+				 * the next .set_rate() will help with recovery.
+				 */
+				dev_dbg(hdptx->dev, "Invalid ROPLL hw state: sdm > fout\n");
+				return 0;
+			}
+
 			fout = fout - sdm;
-		else
+		} else {
 			fout = fout + sdm;
+		}
 	}
 
 	return DIV_ROUND_CLOSEST_ULL(fout * 2 * 8, ropll_hw.pms_sdiv * 10 * bpc);
-- 
2.53.0



