Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D250341D23A;
	Sat, 12 Sep 2026 10:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207750; cv=none; b=BF5NtUQ9y6f32c1/YB5l5erqesM6DX0zgzlEPBGIhs3a/NB3urrKhuGBkzXQ+6BJ1zszD1ZbFVA52+IsWr6jrxfl1xQ/96ge+PAy2JHNVvUcfPKlkyjplTglY2NbmMQ02FiOvAGB2CZxUsepnkfx39QRy8j+xBoR8k0iiPvxAtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207750; c=relaxed/simple;
	bh=ZPNssF8wg5w7wyt3P7BsrJBtimvbdgbMp7NNwZ5EU0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSCoKYWslhBJ59vczhzVhJ1vvFaZjoiOmYmZTfxoiN+v6OcyizpW83CXyVT1SRUwDuj6BSHzeQ88LX0Rcwlp69w7NfL5kPtZiWGuwQdpm5d2GWkEZOzTjYdYE4H1MHV0OV7ExO26TzWHLSSiW4RpqUzr5lWtW6T2liJwWyINkNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2v+KjeBb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2v+KjeBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8011F000FF;
	Sat, 12 Sep 2026 10:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207747;
	bh=LgCji30GaIZ8zDBtuBdcynT943KGX1iWWOgWj/hVAL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2v+KjeBbRLIsaulFS81Ptsqq4oLbf42dzymYzdj/2KRTi7w/f/qyy7s2CvVsCKzpa
	 V43g8c3E0fhdN90Qe6uEJQphaY5R3DTZ1fxvPNs5XqTkBNGE2rCf0vJXFpMQ9dfz+S
	 9kJLB++Ap5uzitegOWul+6RKmx5MW311MN2ghlrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Changhuang Liang <changhuang.liang@starfivetech.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0477/1518] phy: starfive: Fix runtime PM cleanup in JH7110 DPHY TX probe
Date: Sat, 12 Sep 2026 08:44:06 +0200
Message-ID: <20260912065634.237649550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



