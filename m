Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B811F1302;
	Tue, 30 Sep 2025 15:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245106; cv=none; b=RgmW2yyMiCKRLe+0Hc73SZVMPfdmA6UwpRutUE11kwin4TsyKq5s/CXBFPf27833q/9MQWYWqpZgRuzEW/IT65RbTa9Vzwoqpl5I1K7wVBWx3jPBHFdFwZRQo7+ZVR/3B38swzTpAcFlzNJ/dwF7Zq8a3nfBOztWC7WgQYqzIlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245106; c=relaxed/simple;
	bh=k8znFv3zxCBpStJWdXunUOlLrTrpZL2YOKeNix52QX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgAOjaWW/6lKcG9pE5GpBLBJCoYI285CX4nko6XISQ8o8UypD8BP37EUC67ycsox/BF9mXwntR5bnnzlCfwN37zwMhy+QisOVIe5QUyY1Am3GkJyql9rOebcm3NcaHAIgwf/gfS6CIYnV7u1KbpnmLf7aOsnFzKVQ7v0MZTPaAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2rO3b/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2rO3b/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A9AC4CEF0;
	Tue, 30 Sep 2025 15:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245106;
	bh=k8znFv3zxCBpStJWdXunUOlLrTrpZL2YOKeNix52QX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2rO3b/g7EEhkAZ3Io6fqjrPKffE7cD1Bdft/zP1rikPbxtiuvQPg+Jfq1Gq3fZ4K
	 SE3aH2jAzHUURnmRfqe95JEgwVxxqbTafdOLqvBG1yjZUOrb3npDkoeIw0YUTyNRmE
	 TlY8qr13IOK7NI6fdSvNEXHogzJavm6IAJDlIQXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <akemnade@kernel.org>,
	Alistair Francis <alistair@alistair23.me>,
	Peng Fan <peng.fan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/151] regulator: sy7636a: fix lifecycle of power good gpio
Date: Tue, 30 Sep 2025 16:46:23 +0200
Message-ID: <20250930143829.718498052@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Kemnade <akemnade@kernel.org>

[ Upstream commit c05d0b32eebadc8be6e53196e99c64cf2bed1d99 ]

Attach the power good gpio to the regulator device devres instead of the
parent device to fix problems if probe is run multiple times
(rmmod/insmod or some deferral).

Fixes: 8c485bedfb785 ("regulator: sy7636a: Initial commit")
Signed-off-by: Andreas Kemnade <akemnade@kernel.org>
Reviewed-by: Alistair Francis <alistair@alistair23.me>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Message-ID: <20250906-sy7636-rsrc-v1-2-e2886a9763a7@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/sy7636a-regulator.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/sy7636a-regulator.c b/drivers/regulator/sy7636a-regulator.c
index 8360b3947eada..e29ea02f65424 100644
--- a/drivers/regulator/sy7636a-regulator.c
+++ b/drivers/regulator/sy7636a-regulator.c
@@ -80,9 +80,11 @@ static int sy7636a_regulator_probe(struct platform_device *pdev)
 	if (!regmap)
 		return -EPROBE_DEFER;
 
-	gdp = devm_gpiod_get(pdev->dev.parent, "epd-pwr-good", GPIOD_IN);
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
+
+	gdp = devm_gpiod_get(&pdev->dev, "epd-pwr-good", GPIOD_IN);
 	if (IS_ERR(gdp)) {
-		dev_err(pdev->dev.parent, "Power good GPIO fault %ld\n", PTR_ERR(gdp));
+		dev_err(&pdev->dev, "Power good GPIO fault %ld\n", PTR_ERR(gdp));
 		return PTR_ERR(gdp);
 	}
 
@@ -102,7 +104,6 @@ static int sy7636a_regulator_probe(struct platform_device *pdev)
 	}
 
 	config.dev = &pdev->dev;
-	config.dev->of_node = pdev->dev.parent->of_node;
 	config.regmap = regmap;
 
 	rdev = devm_regulator_register(&pdev->dev, &desc, &config);
-- 
2.51.0



