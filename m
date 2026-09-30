Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035A050EC11;
	Wed, 30 Sep 2026 16:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787398; cv=none; b=a36HFyJbXe/zH2dExilBvmBf3VdUf/ieL5dUxF0OeUjHPJEdxvkzLiMYCdFsT+rYcVHamvEONxAfCWPGNR3oJHXSr6aOhMq0uFtoxWchcJNoWDFMj0yZi5luVvQqLvTPsCsNlYcPtiNwkEWUGrgwTVMAT0m0U5s/4IAdcZNXT8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787398; c=relaxed/simple;
	bh=hasTa6G5zfHq+cGAbVFrTm10j/vJOebIEczb5hNs+7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUzhkhyZjQAQ2DaxxdJCHxX2klLekG24UViXspg1UgBccHmi9F4nTtUEnVkyeyXc+edQH5cnhbPzNz9yUOxqt1kk/q4JARrlfBpJjXvzOvk8dwn1SoNuZDJ12s1j7m8mIreRiHGCTwlLpf2QM58x1mwPQU/aP34MJqThM24jEIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2qzaW8e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2qzaW8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2271F000FF;
	Wed, 30 Sep 2026 16:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787396;
	bh=ftjdw+nEvAr9imwsLBnmAvsCiQK7TU/5ZiinErmeO/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2qzaW8euPctiyCbkrtuwdoFh+0EeSmAeTvXwI9Ra1k8QTmdnp2gq7TXypIa6FwDP
	 RyCsaAMVWsWAmV73AmtVg8fKRdslZEpUyI8QX2D1WyYJduBdPAJbtc/KAgvd3l3VS4
	 ubstiepa7uzWLsXVOVBycdhlkITrU743hLPjzDGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Coia Prant <coiaprant@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 217/457] net: ethernet: stmmac: dwmac-rk: fix bulk clock leak when the PHY clock fails
Date: Wed, 30 Sep 2026 17:25:22 +0200
Message-ID: <20260930152350.735623516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Coia Prant <coiaprant@gmail.com>

[ Upstream commit 8db67bb6a1fffa4df68fbbc22e39943aeeff9178 ]

gmac_clk_enable() enables the bulk clocks first and then the optional
PHY clock. If clk_prepare_enable() on the PHY clock fails, the function
returns without rolling back the bulk clocks, and bsp_priv->clk_enabled
stays false, so the later gmac_clk_enable(bsp_priv, false) becomes a
no-op and the bulk clock references are leaked.

Add the missing clk_bulk_disable_unprepare() on that failure path.

Fixes: ea449f7fa0bf ("net: ethernet: stmmac: dwmac-rk: rework optional clock handling")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Coia Prant <coiaprant@gmail.com>
Link: https://patch.msgid.link/20260923123713.3137146-1-coiaprant@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 8d7042e689261..72bdbcb5e863a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1162,8 +1162,11 @@ static int gmac_clk_enable(struct rk_priv_data *bsp_priv, bool enable)
 				return ret;
 
 			ret = clk_prepare_enable(bsp_priv->clk_phy);
-			if (ret)
+			if (ret) {
+				clk_bulk_disable_unprepare(bsp_priv->num_clks,
+							   bsp_priv->clks);
 				return ret;
+			}
 
 			rk_configure_io_clksel(bsp_priv);
 			rk_ungate_rmii_clock(bsp_priv);
-- 
2.53.0



