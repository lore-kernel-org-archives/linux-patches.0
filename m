Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206794E4C5E;
	Thu, 17 Sep 2026 15:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659846; cv=none; b=bADwfebdHMBI6x/AmW2BaoP+g9nZEzFyWGYmS90mEOn/YfqNBGGm8nPAtWewOS5PEbfmZYTROqgYlLCih0OiuO/YJDmNfDs6HzwN/PJgI6x6QZso0HYIFN7YZKPJnIThClBvVGehdVm96r4GGDF5n4xOkMddyK1x23sEwZfkb8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659846; c=relaxed/simple;
	bh=9ya2RlUJmcHf5v2soYh83wDAUKFt2zy72YwlHPVtsQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EANQZtxZvDWGjuno6mwZ748isiMufTNz5CuVBOjXrY1e9LFRCPajo9e5wz+n3SLBM5l0l2zClw0UWV1e8MLG8CNAS7LVjd73gW7qsdzLiD/wRxtuGaPOxMY1ne5724ZzNELiJIfBboNPDDhgnY/ZKBP3K3uRC9EhUe0jsAnJZtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypgQjnYW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypgQjnYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4260F1F000FF;
	Thu, 17 Sep 2026 15:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659838;
	bh=wX5iCFVgp94OnMvoFv1hS0cQFBwWJL61LoWOkgH8WNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypgQjnYWhKVRWkCzke01xH9KSAyiA5AoP8e+Po51QYeaJaL0k/YMKjDAdtNuBiq6T
	 Boj32cxnkcvr3eE1HgicdeE5dkCBfA+RjYw6sV35NqtskBMV/iGUk0gJC6lqAvA75B
	 +MzndUfpNKvSRHr94Q/I9uT4V08h4/JC1G84iwLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 391/733] watchdog: msc313e: Avoid division by zero
Date: Thu, 17 Sep 2026 16:11:39 +0100
Message-ID: <20260917151401.449879755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index f69d66971c41d..c3018b9701641 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -97,6 +97,7 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct msc313e_wdt_priv *priv;
+	unsigned long rate;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -116,7 +117,10 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
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



