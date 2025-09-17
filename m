Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDFA15C158;
	Wed, 17 Sep 2025 13:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114174; cv=none; b=nb0bzm8Z74Q2addSy1W1MMJA3eZkzxzuRNQ3UMuVk3FHJHyKiEAk798MvDZHil6+9zdWg7y636CFGe+QhQ+veDgSDp4CKDzdkcc96A1Keh1jVqBan4C2slqtsd0VwasidzErp2ExsL9ne/SNmSzrgiAC9yjH94XSNcBRMYm17yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114174; c=relaxed/simple;
	bh=jfsZtaBjSS7RSZDHsg+QwzNyXR+FX+21+8LzLvSjN1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYJQviBnDrfDYQw7ELwfVD1ehvpSHmyo4XR7T+Wwyuy2g/zQfAPrnAUBDYDsZrtNDfjXPWmrVEha5rYv7x+GVq8VXK0FeY/gmRTzqXVqH6Fl2kmUY665yNs97oc7J7AoGeUez+BYqH7SwvBmXnC8fFwGln3aMVq1DjYYEPYQF5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6l6yrBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6l6yrBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844EFC4CEF7;
	Wed, 17 Sep 2025 13:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114172;
	bh=jfsZtaBjSS7RSZDHsg+QwzNyXR+FX+21+8LzLvSjN1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6l6yrBL7z6iYrpGc3rACxIzbBMZwHOrY/iXkWVrZ+Sv8Xsr4IuS2lFPgYmYNYCDA
	 i7PbHmXPEtxYDyOIInaTN9W+o4/CbLvFIdUTIJ7XlUjKsDh2QDSyFwYb7WiYsZw4WU
	 3iWjb9cYeimaqKKxCFZZLKvaF2/i/TbZVkB4ET4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <akemnade@kernel.org>,
	Alistair Francis <alistair@alistair23.me>,
	Peng Fan <peng.fan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 66/78] regulator: sy7636a: fix lifecycle of power good gpio
Date: Wed, 17 Sep 2025 14:35:27 +0200
Message-ID: <20250917123331.187005494@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
User-Agent: quilt/0.68
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
index 29fc27c2cda0b..dd3b0137d902c 100644
--- a/drivers/regulator/sy7636a-regulator.c
+++ b/drivers/regulator/sy7636a-regulator.c
@@ -83,9 +83,11 @@ static int sy7636a_regulator_probe(struct platform_device *pdev)
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
 
@@ -105,7 +107,6 @@ static int sy7636a_regulator_probe(struct platform_device *pdev)
 	}
 
 	config.dev = &pdev->dev;
-	config.dev->of_node = pdev->dev.parent->of_node;
 	config.regmap = regmap;
 
 	rdev = devm_regulator_register(&pdev->dev, &desc, &config);
-- 
2.51.0



