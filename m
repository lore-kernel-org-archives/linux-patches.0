Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AA42D0C75;
	Sat, 12 Sep 2026 12:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215795; cv=none; b=dg5rix/xSby9I32cfLkBXTpjWCCSSzu9lyR5G+s8FnxmV3JBA3X8atmaB6ad+L9SvyqyIIBSgyar01GImJ/frj+NstUVqsLKyP3nNYNwNEojRgMtju2+4Egn7DYycDbDOrIl1Kh6DRGFeHLd68XSfXv3roMSICx1SGcwrKN4xzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215795; c=relaxed/simple;
	bh=cVL99ZpEMEPquvzGP7abjJdxESmuctO5/I1BTDRLbKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afUZQ4OApXZlPYyqaPZA7kk7zfog1L605ZF+uyv5Qp9tsbuc/UxoiS1Ku+6aUao43ExfOPHstbCe8jRSigkAuWoESIDv+W9eQae8fg+HNZRxE60Ldh+u8cDSotonF+/mrEzaNgv8ETQQ7mOtraEe9DuUqPWzothYYTWRKWccuYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kag9najD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kag9najD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85591F000FF;
	Sat, 12 Sep 2026 12:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215794;
	bh=7csezuxcZSb8+Yd61/ipAWKD7is4wqNHJWQrfOwXXtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kag9najD4oBbrlZRraRPZhnJYnGm1U/KhFv0MSDXi0cV5tM26XXwF3bBmpM5bxgCt
	 wEaQWNP5VCaIeObc32xnbcghJTPDMyr3KZ3k7NlUJV6AMItTO/QOevddL682VlXFaM
	 QJXxPzTcMi1JWWdJsJWlcuSRf6O+HopnRdav3U7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Changhuang Liang <changhuang.liang@starfivetech.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0603/1376] phy: starfive: Fix runtime PM cleanup in JH7110 DPHY TX probe
Date: Sat, 12 Sep 2026 08:50:29 +0200
Message-ID: <20260912065620.973974720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit f40b0241f3a382e99c14de2f28f14a44973407c1 ]

stf_dphy_probe() enables runtime PM before getting the clock and
reset controls, creating the PHY and registering the PHY provider. If
any of those steps fails, probe returns with runtime PM still enabled.

The driver also has no remove callback, so runtime PM is left enabled
on driver unbind after a successful probe.

Use devm_pm_runtime_enable() so runtime PM is disabled automatically
on later probe failures and on driver unbind.

Fixes: d3ab79553308 ("phy: starfive: Add mipi dphy tx support")
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Reviewed-by: Changhuang Liang <changhuang.liang@starfivetech.com>
Link: https://patch.msgid.link/20260718090054.444513-2-pengcan@kylinos.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/starfive/phy-jh7110-dphy-tx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/starfive/phy-jh7110-dphy-tx.c b/drivers/phy/starfive/phy-jh7110-dphy-tx.c
index c64d1c91b1307..181491a938079 100644
--- a/drivers/phy/starfive/phy-jh7110-dphy-tx.c
+++ b/drivers/phy/starfive/phy-jh7110-dphy-tx.c
@@ -392,6 +392,7 @@ static int stf_dphy_probe(struct platform_device *pdev)
 {
 	struct phy_provider *phy_provider;
 	struct stf_dphy *dphy;
+	int ret;
 
 	dphy = devm_kzalloc(&pdev->dev, sizeof(*dphy), GFP_KERNEL);
 	if (!dphy)
@@ -406,7 +407,9 @@ static int stf_dphy_probe(struct platform_device *pdev)
 	if (IS_ERR(dphy->topsys))
 		return PTR_ERR(dphy->topsys);
 
-	pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
 
 	dphy->txesc_clk = devm_clk_get(&pdev->dev, "txesc");
 	if (IS_ERR(dphy->txesc_clk))
-- 
2.53.0



