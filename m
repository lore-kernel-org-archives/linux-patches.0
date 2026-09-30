Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBBC514753;
	Wed, 30 Sep 2026 16:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786581; cv=none; b=eo0xl3mWnsrbYxbYm7ruaYoCdx/bw+JOorWk8m4FICjKtivqaGBTCujgSAGD+wk0udznS5ef4RnH2kx8v3B3E/kY6COhachmbmbhwNCUJoKMtGQozcdEXR1JSYtZ7SlsIq61TE7a24oEA+/XUMU2uotkKTrZrVE5zQhO/6o+o+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786581; c=relaxed/simple;
	bh=WE1sLII4z5MeLd17T6UIlL5F1h/iWLjlqwchkI6+jdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwN33UlnGyohUegDbHmXDnVWl46pFTq38kYqz3uDfS5UDtaCGw8uFXpY6Gjh/UKRnCYIybMkZIpx5QisE1d+p98ZIWlwVdwnbr6UZe1DSydkuCboaehPTfNEybm9SZ+lqhtFIMk++cHPCQjZmrll4ABEA6Kobc9c4uTrx8AvI/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGrQCkJj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGrQCkJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF001F00893;
	Wed, 30 Sep 2026 16:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786580;
	bh=0Z3fnbGYY9ddBv9ScrrLKJLZt4tlb3RpJfSp9aZ8EVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGrQCkJjmZlZHOY9BT708MGDScZalRldOQmSxEI3sgzljPbkANfqa3IJN9kG+qFB6
	 OxlKsJXvr1GymGq+XXygK6IvbPOZIdcCZVodR8ykOP6v4VjGy1xaV7u/8hjvmWnk9v
	 8DxY2zGKq8cx19aPWkM129RPoPHC5J0B45gzLP0k=
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
Subject: [PATCH 6.1 911/982] net: ethernet: stmmac: dwmac-rk: fix bulk clock leak when the PHY clock fails
Date: Wed, 30 Sep 2026 17:27:27 +0200
Message-ID: <20260930152436.308693377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 34198d95c68b9..3c2e1548b8c67 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1553,8 +1553,11 @@ static int gmac_clk_enable(struct rk_priv_data *bsp_priv, bool enable)
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



