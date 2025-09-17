Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532DA31A80D;
	Wed, 17 Sep 2025 12:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113111; cv=none; b=THFni5yHzO6hlYeGLeGGPT/lT6SWINAhz/uIzlbe9WmwefuGoD6L0vRcl+rCdr753aAtwu/z2iDM58QjKiYeA9uh0EMzKowbJA8f7ZI2uDQhanyacgpRsFUbCPgmoYFa9J10fOFW58ac4GSY94gk0kflb84MqKpfu628glHymZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113111; c=relaxed/simple;
	bh=oAbErMeYVWrXq1Wrp5xd1I4Wd28sfZTHxlwog0mKBCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvAGN4pZHdQOR3gzM8vbdK2UCecBizQM6QDu4yDtS318TGFzzDfMqAeD1wxYr+fZoxbdsvbxl9sNDV1562INIeH2ClEXqnTU2TXzRi1hNvTdf7GUfftRiCnmOwUdxH1g8RKku+BACQ7K4XD00N7XhCHYVu67cs/KBt785S7jsTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yo5eeOo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yo5eeOo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85F2C4CEF0;
	Wed, 17 Sep 2025 12:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113111;
	bh=oAbErMeYVWrXq1Wrp5xd1I4Wd28sfZTHxlwog0mKBCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yo5eeOo18svzYcBcdDyT2yfSY/QZwpV9FFuGwfpNkti51GeLyH6Stgu7kzUVNy0qE
	 vlvgc7Q1pnC9sFSQyfeXI0y+i9iHsoFmaCoOckU6M18vdVMXCWOC2JPCq83GCSfXpa
	 5nPJAnSR1wUrlNGyDydtW1gPlM56yBlo8AZ2B1SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <akemnade@kernel.org>,
	Alistair Francis <alistair@alistair23.me>,
	Peng Fan <peng.fan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 175/189] regulator: sy7636a: fix lifecycle of power good gpio
Date: Wed, 17 Sep 2025 14:34:45 +0200
Message-ID: <20250917123356.158713352@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d1e7ba1fb3e1a..27e3d939b7bb9 100644
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



