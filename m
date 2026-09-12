Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407401BD9C9;
	Sat, 12 Sep 2026 07:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199210; cv=none; b=RIi8ebgyoUNWo0kmvXsXMRjUGjs28Xi7gt2hMSs4G/maQojtWPY9zMC/zZgzknwTvmHS1pKpfTLzGayAzEIjEpAqFYLCL3CPYzW4AInVZ2FdHDizC/0PCmk6vSarqCkeiSnZMIldollcUF8kq5kTIYQDxqHwj0+X3SWmldKbEaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199210; c=relaxed/simple;
	bh=IVpthxzn7sqRYnPBygV7aWjZqKWbhtl5qpeTBn+wxKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnFI7+XdRYF6Jj15G0KKNPpXcJYKM75eA8nNMsrsHrJezoxj+B0lGm7UOgIoUAoVKzGemRZmIFPWIEqGc6BcHkLjiG5S0VlG2OdQ59zRZN36uz14AZgoT7ZHKUpzm2U3EyOiJKAbJM/A6ihE4ERNBsHsYqIxAIm5O3t3+sWFoSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAOEXeyZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAOEXeyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06581F000FF;
	Sat, 12 Sep 2026 07:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199208;
	bh=4UeU0uLXsat4a5ClYv7wqpLwX5iEEXC5cgtTsSmYtpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jAOEXeyZ+/Lg09vupnNVMNLUJooKP92YhD1Q9//fVKS0g30N1D8ipitpT0cIVQMMe
	 H9dVEpYlBf7C6wHb9zJpeNOBiVBZmeKvXbYqnOz545CPApljTpVizQp1c4+6kAcLrU
	 rNEbAklVN4GsI6ZZ7TGAaOa3cFmUHbfS9WNCrWD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Changhuang Liang <changhuang.liang@starfivetech.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0537/1815] phy: starfive: Fix runtime PM cleanup in JH7110 DPHY RX probe
Date: Sat, 12 Sep 2026 08:38:07 +0200
Message-ID: <20260912065701.486801989@linuxfoundation.org>
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

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit 97bed336f6a25c9d1115ca95e3aa00e05c3bc271 ]

stf_dphy_probe() enables runtime PM before registering the PHY provider.
If devm_of_phy_provider_register() fails, probe returns with runtime PM
still enabled.

The driver also has no remove callback, so runtime PM is left enabled
on driver unbind after a successful probe.

Use devm_pm_runtime_enable() so runtime PM is disabled automatically
on later probe failures and on driver unbind.

Fixes: f8aa660841bc ("phy: starfive: Add mipi dphy rx support")
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Reviewed-by: Changhuang Liang <changhuang.liang@starfivetech.com>
Link: https://patch.msgid.link/20260718090054.444513-3-pengcan@kylinos.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/starfive/phy-jh7110-dphy-rx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/starfive/phy-jh7110-dphy-rx.c b/drivers/phy/starfive/phy-jh7110-dphy-rx.c
index 0b039e1f71c55..d06f21ad63325 100644
--- a/drivers/phy/starfive/phy-jh7110-dphy-rx.c
+++ b/drivers/phy/starfive/phy-jh7110-dphy-rx.c
@@ -150,6 +150,7 @@ static int stf_dphy_probe(struct platform_device *pdev)
 {
 	struct phy_provider *phy_provider;
 	struct stf_dphy *dphy;
+	int ret;
 
 	dphy = devm_kzalloc(&pdev->dev, sizeof(*dphy), GFP_KERNEL);
 	if (!dphy)
@@ -190,7 +191,9 @@ static int stf_dphy_probe(struct platform_device *pdev)
 		return PTR_ERR(dphy->phy);
 	}
 
-	pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
 
 	phy_set_drvdata(dphy->phy, dphy);
 	phy_provider = devm_of_phy_provider_register(&pdev->dev,
-- 
2.53.0



