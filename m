Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BADB36D9E9
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301442; cv=none; b=Uyud3D+Mm29FnsOJOM/LBqxzWzwpRUA1SJPYsPpN74tMr1dn6TgxqnbAElT4HqO6bdzbMNNyrEgICokB0sHpEazdVnnQrio7C3kXopHBvhuI0YI3tjnOr7y1vA2ApNe4SJowhtuwmLIXn/0jJC3XtgfAx+c7A54DTWfRmTbNewE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301442; c=relaxed/simple;
	bh=JSxcDFknxS5iM5aU8le0mweKjNJSX/1pheTt1QFMtgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dxan0q6gGZyZkrkQ3+FUaV9N8eMLgk6OiKK6FOqFOFKD82OLd2W90CMPQ3/QyvzsVNfVR5LRkJ4faGyDng/TB8QJsCn4wmsezIT2EJAhxN4VRLQeKHHa0BnSptdJgVVAgwUJdMDZlU0HoLoS52P3Hgm1BxpMkhbklRBZLtqzNFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s+Nf5PCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s+Nf5PCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CB2C116D0;
	Sat, 28 Feb 2026 17:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301442;
	bh=JSxcDFknxS5iM5aU8le0mweKjNJSX/1pheTt1QFMtgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+Nf5PCkHLSoFWapX5HtR3IFJbUa3bmsokox3BppWvoMoMbVcfvR2HBZL1C5Unc5t
	 NE1X/F/6kuUeTXJyHvpy/H35eOg19RpLRpFi380NNVlHIx0nukg3rwRABd2wQqJ+Dv
	 PXm0exo9pTS1xh5n6ZOzLEBRjyW9adNsp6+AOANXFDmiEDiKPnsMEu7upwP79PzO0I
	 gcY24uiFSAST1kPK1PbopND5VA4O0NFtvdn+mH3ytk1+pBRf66RwXxtjcgQdzZfXNs
	 Id7wlocPDIkaNK+s+bwZAbD646AdFj/dWWAdG0GD04WHw0rS/kDqpfmFt02nvMFgNk
	 lGefssbeWGJxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotien Hsu <haotienh@nvidia.com>,
	stable <stable@kernel.org>,
	Wayne Chang <waynec@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 628/752] usb: gadget: tegra-xudc: Add handling for BLCG_COREPLL_PWRDN
Date: Sat, 28 Feb 2026 12:45:39 -0500
Message-ID: <20260228174750.1542406-628-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haotien Hsu <haotienh@nvidia.com>

[ Upstream commit 1132e90840abf3e7db11f1d28199e9fbc0b0e69e ]

The COREPLL_PWRDN bit in the BLCG register must be set when the XUSB
device controller is powergated and cleared when it is unpowergated.
If this bit is not explicitly controlled, the core PLL may remain in an
incorrect power state across suspend/resume or ELPG transitions.
Therefore, update the driver to explicitly control this bit during
powergate transitions.

Fixes: 49db427232fe ("usb: gadget: Add UDC driver for tegra XUSB device mode controller")
Cc: stable <stable@kernel.org>
Signed-off-by: Haotien Hsu <haotienh@nvidia.com>
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Link: https://patch.msgid.link/20260123173121.4093902-1-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/udc/tegra-xudc.c b/drivers/usb/gadget/udc/tegra-xudc.c
index 9d2007f448c04..7f7251c10e952 100644
--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -3392,17 +3392,18 @@ static void tegra_xudc_device_params_init(struct tegra_xudc *xudc)
 {
 	u32 val, imod;
 
+	val = xudc_readl(xudc, BLCG);
 	if (xudc->soc->has_ipfs) {
-		val = xudc_readl(xudc, BLCG);
 		val |= BLCG_ALL;
 		val &= ~(BLCG_DFPCI | BLCG_UFPCI | BLCG_FE |
 				BLCG_COREPLL_PWRDN);
 		val |= BLCG_IOPLL_0_PWRDN;
 		val |= BLCG_IOPLL_1_PWRDN;
 		val |= BLCG_IOPLL_2_PWRDN;
-
-		xudc_writel(xudc, val, BLCG);
+	} else {
+		val &= ~BLCG_COREPLL_PWRDN;
 	}
+	xudc_writel(xudc, val, BLCG);
 
 	if (xudc->soc->port_speed_quirk)
 		tegra_xudc_limit_port_speed(xudc);
@@ -3953,6 +3954,7 @@ static void tegra_xudc_remove(struct platform_device *pdev)
 static int __maybe_unused tegra_xudc_powergate(struct tegra_xudc *xudc)
 {
 	unsigned long flags;
+	u32 val;
 
 	dev_dbg(xudc->dev, "entering ELPG\n");
 
@@ -3965,6 +3967,10 @@ static int __maybe_unused tegra_xudc_powergate(struct tegra_xudc *xudc)
 
 	spin_unlock_irqrestore(&xudc->lock, flags);
 
+	val = xudc_readl(xudc, BLCG);
+	val |= BLCG_COREPLL_PWRDN;
+	xudc_writel(xudc, val, BLCG);
+
 	clk_bulk_disable_unprepare(xudc->soc->num_clks, xudc->clks);
 
 	regulator_bulk_disable(xudc->soc->num_supplies, xudc->supplies);
-- 
2.51.0

