Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B1D2153DF;
	Thu, 12 Dec 2024 15:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017696; cv=none; b=Lt90b6YcsmyhrF/6e4e5cOZvJfh/Rwr0ZPx8wPKG/sdGs2O7AHjm1PRzW8tOUXuJCJn8e7bJWaN6csMM+ff7ER4eriyknfCAzZ6SD/ZDq5Ad4C/y7hs7IqPzBh0YxaOGgNweS1u+Ea2+m5yTj/Nsh7cxjFDA5awy65OY9OQIXb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017696; c=relaxed/simple;
	bh=/rAOENTSbDEXg358n0LiqQgL/v86ln6WkwS2xHCzj6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBYej3zy/zPSqyqL++LcWlnkQY0KJSrF2DvM8dUzY6MAWUqw0TMrjEF9SIF4RD5/uFbUG2LX4xb+d9BeF/FdV4hQjFSuiELBm4HAXsa0oB+Y7b049A981TvWjz8SPzr2zXiLUAs9A5r8FC+LgloXpHGb9wixV8/ShBGcaOCBqIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+gQP999; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+gQP999"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99730C4CECE;
	Thu, 12 Dec 2024 15:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017696;
	bh=/rAOENTSbDEXg358n0LiqQgL/v86ln6WkwS2xHCzj6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+gQP9992hVEp2EOtSoiFH+JUpzacDtbi0qlpkSo0LoKJiNsH6HCSVCtfEWlLSOr3
	 CxuoyL21b8kGSWOu3PAsqFKrlfOU6Ke6LZSZ4DTTdWUEnJnxx3pbjc8lrMwmDq/jIs
	 +hKT2R57F4XBS4vWi3WEqM7alrHMEnY4d+27HBE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/356] mmc: mtk-sd: fix devm_clk_get_optional usage
Date: Thu, 12 Dec 2024 15:56:44 +0100
Message-ID: <20241212144247.981607539@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit ed299eda8fbb37cb0e05c7001ab6a6b2627ec087 ]

This already returns NULL when not found. However, it can return
EPROBE_DEFER and should thus return here.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://lore.kernel.org/r/20240930224919.355359-4-rosenp@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 2508925fb346 ("mmc: mtk-sd: Fix MMC_CAP2_CRYPTO flag setting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index a97034388cdff..c5e96a2c079e5 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2711,9 +2711,8 @@ static int msdc_drv_probe(struct platform_device *pdev)
 	if (!(mmc->caps2 & MMC_CAP2_NO_MMC)) {
 		host->crypto_clk = devm_clk_get_optional(&pdev->dev, "crypto");
 		if (IS_ERR(host->crypto_clk))
-			host->crypto_clk = NULL;
-		else
-			mmc->caps2 |= MMC_CAP2_CRYPTO;
+			return PTR_ERR(host->crypto_clk);
+		mmc->caps2 |= MMC_CAP2_CRYPTO;
 	}
 
 	host->irq = platform_get_irq(pdev, 0);
-- 
2.43.0



