Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD314D17A5;
	Thu, 17 Sep 2026 17:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666007; cv=none; b=qRCNdM1MA3CtHVAZeBlvB84fogwr1UhQYuqsO7r1sxDdOf8xz+o2xGdRGq7xGBkxVxjBNm/zRDRCzSX89LEMIERgY7uPckbHO/ZINCvUyMsfooU2Hf9LPFVfBPtxwcmj1oSs0Yt82u0DFo1ZtoIrbnqGCalTYB0QGOaqMJYH5LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666007; c=relaxed/simple;
	bh=Xopl5PZg5uaZEoayUn111s/phQppL4Nm3xluZrTtJrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nv3Kb80yoBdj5y0cMDwaoCOv9aXil7cQ3WIO0Ku0wP2jg3bqVB1AUyAPTQC6zxMLYdWWjUCf3b31L21DKV2rnxu3gWBTM1/EQiGJemHES10oAuSkUlMm2UGjv8HrdQNu8ERRJ+P8i82edccxJqwrgFdAdUVtubnTT3amRGy0oRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwH77tCr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwH77tCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C5B1F000FF;
	Thu, 17 Sep 2026 17:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666005;
	bh=vx4hbLAQO45fYV6274aUE5bocgAeeasGFnyG38Q34gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iwH77tCrlG+h33Wi8cAnApiyLSEL4zEALUbfIpoYfVW0FJ/MS7tgL1ycScuc+RNMw
	 Q3FeGzgfgFcCRhMBMtiMHxFH3EIS5wl/8uXyGeLUQXV/7qoeFuqIZ3nbHzDRSugoYA
	 bsXaAFiIFxArNge9KcIdxiaHjaad2s+Gez6f2baY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0892/1250] watchdog: msc313e: Avoid division by zero
Date: Thu, 17 Sep 2026 16:11:27 +0100
Message-ID: <20260917151616.163114584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 3c73a37f5e40972ce26d8eeb98e8b938d719b069 ]

clk_get_rate() could return 0.  Avoid a division by zero panic.

Fixes: e9800b799464 ("watchdog: Add Mstar MSC313e WDT driver")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260828161348.13212-3-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/msc313e_wdt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/msc313e_wdt.c b/drivers/watchdog/msc313e_wdt.c
index 3b62650375628..072bfcea85c24 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -98,6 +98,7 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct msc313e_wdt_priv *priv;
+	unsigned long rate;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -117,7 +118,10 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 	priv->wdev.ops = &msc313e_wdt_ops,
 	priv->wdev.parent = dev;
 	priv->wdev.min_timeout = MSC313E_WDT_MIN_TIMEOUT;
-	priv->wdev.max_timeout = U32_MAX / clk_get_rate(priv->clk);
+	rate = clk_get_rate(priv->clk);
+	if (!rate)
+		return -EINVAL;
+	priv->wdev.max_timeout = U32_MAX / rate;
 	priv->wdev.timeout = MSC313E_WDT_DEFAULT_TIMEOUT;
 
 	/* If the period is non-zero the WDT is running */
-- 
2.53.0



