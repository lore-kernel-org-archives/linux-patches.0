Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE434E01FA;
	Wed, 30 Sep 2026 18:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793230; cv=none; b=Hut41xGGYJzmzWy4Qt9Z+8rniard6fgMznERq7xaM3zCqkQQyWfjdVoBgxrDlU0n+IscQP8gP/6aYtypLwvs2Bb67hMbhuddgpJWv3TQYD5UOsFLoIomE2aMz2wGvh250hWYN9mKq0+RmAHBT3m7/x8Fh972EGymt7xBZxKNJc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793230; c=relaxed/simple;
	bh=8ppe1emJin/wWEKQ++sJkHFIDIk/QKuI9zvc/UjQYpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiSfqB1I2ygA1N5NU1IFfeOGJGTWJYgLDqZF/ZJ2gGNYoTd42uGq7FQVEeMDGChgrqSYj6IIfwxJbvAAULmu/cTMrhtJQ6Ld3g9aCg7j3TD5F645TdvmWZeuKnp4Ibt0CtHKNGk/zrJWcXCH7SF6AZ+VH+zDlBwJvv8YqwXPPXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eygr7C84; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eygr7C84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB41C1F000FF;
	Wed, 30 Sep 2026 18:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793229;
	bh=a7WIihrynbVzCU4jYx7Q3bb1LU5ciJmas3zVu8FbgH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eygr7C84fU2UNwmsprpOQvVfjf/4L2AwIwzYv2QYIDlJXu9xdn7nQqkGHQQp6gmkG
	 Gw4zPiRL2ZkV16f+rSuvBrIuoutua84CqHlYRLJVZdmIHIdT7YcuxyIqLxox63BNfp
	 Mf4yMYcCaFQYEobRKjOtcitJIcIS/CLv76pL3ibw=
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
Subject: [PATCH 6.18 182/395] net: ethernet: stmmac: dwmac-rk: fix bulk clock leak when the PHY clock fails
Date: Wed, 30 Sep 2026 17:27:24 +0200
Message-ID: <20260930152344.600505476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 643578266dfca..8580175a5f926 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1434,8 +1434,11 @@ static int gmac_clk_enable(struct rk_priv_data *bsp_priv, bool enable)
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



