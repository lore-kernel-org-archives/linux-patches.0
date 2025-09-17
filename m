Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7EC3195FD;
	Wed, 17 Sep 2025 12:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113892; cv=none; b=qItEVzzN/Vt/LmHGe2wBY9iwAnxDOyjzU0UwFUdZKpyOPu2WoqS6kTyWz3NZsQC449CmgzXhIOoin+/lyfxKQw2BF9pI2qBopqNeoq7pCUxwPpa+zFwFErN2ShFowJ/yqJwhKmjqygR1T+x+qUNd08/ODL07AuuR6o3aQHULJI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113892; c=relaxed/simple;
	bh=GhQChOUaSbeDmXV79prQ1zCBgKt5FQUoZ3ciGVPYdWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHzFU8ZAV5GQkw0blowG7Y1MwJHGTFpxlamveU2bDAcjzhKj6z6sE/syuQkIUk9Znf6dL4eSLWZR+o0GtgOfWwqPXTB7qDHjEBRwyd4lSHt6UDxjTB8x08G7qAF8zClbpqpF2DKBFEre0V7ntQMJk4Jb7kBqRi6DPLCIwJtB83U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MC8TfH81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MC8TfH81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBE8C4CEF0;
	Wed, 17 Sep 2025 12:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113892;
	bh=GhQChOUaSbeDmXV79prQ1zCBgKt5FQUoZ3ciGVPYdWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MC8TfH81+5v0lU0P6NC6uqcqi3wqXqIbFk+jOpp9hlwkOX2/QBnKYMI3q6d+NF+Bh
	 ZdFEvYNsJoy2DxCLrfASHajklr3CLNOGWgPEn3Dy0qPr/AbEvxKF5uel2jFQ6g8xmu
	 2T2VhDlJl3gv3GOTK9FZyeNvRUFJbrzfawGW00fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <akemnade@kernel.org>,
	Alistair Francis <alistair@alistair23.me>,
	Peng Fan <peng.fan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/101] regulator: sy7636a: fix lifecycle of power good gpio
Date: Wed, 17 Sep 2025 14:35:08 +0200
Message-ID: <20250917123338.894146162@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



