Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F1051993C;
	Wed, 30 Sep 2026 17:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789347; cv=none; b=O2Y84TZCjye4GHgZDERIrbXJ+pZ1uYpnjSrhtk73YGtLaX1RnqnCEQhufHaWkE9iqNtvbvGwTOlSoVkEjAX+wbIoW7szSDopYa60t8XDCZ+xnppJCxrog8Wx/XiCl/zX+QOsvjOdbggVnfb7QntrxZXZJduS4owAXbogop4B+RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789347; c=relaxed/simple;
	bh=PvLltSzIyFlDjewlNkPO0y486CIB+uuGnVX+wbVbB3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOAMMHZHTvOH0645E15Ae3znpb64cuWl18yhUb58qvDTYfC2sl7IxqGziAlADihCAW5Oy9aKQu+0l/j/UT3jSlFvoDZE72m61IObfKsiPiN6a7jjtRFicuDOGUNf1ttY63MDlyk/2nsTCxl5826UOxh/uPqbOy3Cx+nnmh+DCmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HF1A4o7+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HF1A4o7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840001F000FF;
	Wed, 30 Sep 2026 17:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789346;
	bh=S34KPzWuAo8u72tX0N24gna05J0dJksjsiXkSG+sw4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HF1A4o7+kNXY6Fgn39aflm3qt0ryaYu2UqPYlS0T7A7Jk6ZHamMly/aMXfYnKBVzl
	 xZp2DKOPXARnWNFXY++VbP+0H2psFvNQlHEfRWmGj6rwbgfvZdpt7dmxViJIhmNaf4
	 FnJ4u+tGexlzPB9PPVNgfgwvbOmGlZ3KG7I4PJAk=
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
Subject: [PATCH 6.12 443/877] net: ethernet: stmmac: dwmac-rk: fix bulk clock leak when the PHY clock fails
Date: Wed, 30 Sep 2026 17:22:34 +0200
Message-ID: <20260930152424.241789856@linuxfoundation.org>
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
index d152afa48d5c2..e093bf4cd56a8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1709,8 +1709,11 @@ static int gmac_clk_enable(struct rk_priv_data *bsp_priv, bool enable)
 				return ret;
 
 			ret = clk_prepare_enable(bsp_priv->clk_phy);
-			if (ret)
+			if (ret) {
+				clk_bulk_disable_unprepare(bsp_priv->num_clks,
+							   bsp_priv->clks);
 				return ret;
+			}
 
 			if (bsp_priv->ops && bsp_priv->ops->set_clock_selection)
 				bsp_priv->ops->set_clock_selection(bsp_priv,
-- 
2.53.0



