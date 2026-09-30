Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDA4371049;
	Wed, 30 Sep 2026 19:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796905; cv=none; b=kS/xsSVO8ABTsrr0ihp9WzXTuhylRR3MqHYJ/CpvPQspx1yx8g2/yFOsXQBOf0psTzcEUAQ9ixak6MGOvRADGVQqDir4+0syFM+VFa/Jmj1SE5FDp199IGh7JHFBPOsBKdzhdSJSEYQz1hlmSvviwCXS0dSdUI8TLayi/5IBgCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796905; c=relaxed/simple;
	bh=4KxO/cUhHwq8FXv3W3jpk3zw2HwHRQibEeFyA0Ta5IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3D22iNlMG9bNePOUVr88YKTUuUXjnmB49XUL8DDPAwJNUJc5mHsPsv8l9AQ/b+mdMA32tHr5rUcnpuhS3laKaINFxn/L/RlbDFyHrtVJ0vcmSITWXkZMnbSNMmaE4W1c2Py03B1ILWm1LS/Rak1vmaMpo87AA4pPVWq8hx6F/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbMkALUv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbMkALUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FBC1F00898;
	Wed, 30 Sep 2026 19:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796904;
	bh=PnrbIw06kD4ccxgRCqeCGCtnE5Lx3NnYw4B80cWB31s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbMkALUvQhGbA64ca8/2G/IZNCUvJUK0mexxUydsyIW+bhLSPwdHFINeBRFn5Zi8q
	 Zn6YjkJ2TlC+8g8My3I8A8xoDj2aMzJeXnVEYuLDlz44LrztZsleE6zoAMU/Kqi/Xy
	 pQ3Z0RQNuHVGuld6NK0GpBAjrCF0ayKfXgTkWlxs=
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
Subject: [PATCH 6.6 1077/1193] net: ethernet: stmmac: dwmac-rk: fix bulk clock leak when the PHY clock fails
Date: Wed, 30 Sep 2026 17:29:21 +0200
Message-ID: <20260930152458.156019873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bab315517bad9..e5a6b46fdbb27 100644
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



