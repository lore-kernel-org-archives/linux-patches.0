Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D971313546;
	Wed, 25 Feb 2026 06:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002711; cv=none; b=NTlz4kf40R21VKd1v7l7JBLniyPHTuxLwFl/JPu1SEa90RIpO7c/+PphVqT2E6oqfPJmin6pkVpRdMNb79gaAjskBQX8BKHN8Zf9fSea3oGBJSkjNCP0NkRmC6HkMwlibuzHY/35tCYFzPBS9IpxHgcTf/T3nLPXpbCJyh5+H8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002711; c=relaxed/simple;
	bh=yrxJ0v7alxbEcgu7ogk17v6QzaCaCKRwOZln7MENP9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8GnhtcBa/nygXWaRXrlXO1W2bnAQ249jxSl6RrmMqwyd3ap5lCDFaWDRAG5pk2loa0RdWrMldvMkGxKsB8Dkz040lfNhff/S/47kAdpAu1Mb+mLh016utPorwB6MKmCrHIeQ5m+D/NU9h76BP8KqP7q1J84qs6HWLKbcK8Nc0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M92qaek3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M92qaek3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146A4C116D0;
	Wed, 25 Feb 2026 06:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002711;
	bh=yrxJ0v7alxbEcgu7ogk17v6QzaCaCKRwOZln7MENP9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M92qaek3U1yEcFP7aufZOPNVI1Q6nJMHY5vAgxIRR5OZl1OqeOZpzWJuC9zGIzqEp
	 DpxYTYR754KmWmr//deed89nKwW7/QjHdOXFE2r1mPRVIsZSikAoH3kIbpN2Zw2y5m
	 JQVKo9DoJrvNLmCASItGuiq1fXODwxxCfrmLKlj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kery Qi <qikeyu2017@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 472/641] watchdog: starfive-wdt: Fix PM reference leak in probe error path
Date: Tue, 24 Feb 2026 17:23:18 -0800
Message-ID: <20260225012359.952331031@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Kery Qi <qikeyu2017@gmail.com>

[ Upstream commit 3f2d8d79cceb05a8b8dd200fa81c0dffc59ec46f ]

The PM reference count is not expected to be incremented on return in
functions starfive_wdt_probe.

However, pm_runtime_get_sync will increment pm usage counter
even failed. Forgetting to putting operation will result in a
reference leak here.

Replace it with pm_runtime_resume_and_get to keep usage
counter balanced.

Fixes: db728ea9c7be ("drivers: watchdog: Add StarFive Watchdog driver")
Signed-off-by: Kery Qi <qikeyu2017@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/starfive-wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/starfive-wdt.c b/drivers/watchdog/starfive-wdt.c
index ed71d3960a0f2..af55adc4a3c69 100644
--- a/drivers/watchdog/starfive-wdt.c
+++ b/drivers/watchdog/starfive-wdt.c
@@ -446,7 +446,7 @@ static int starfive_wdt_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, wdt);
 	pm_runtime_enable(&pdev->dev);
 	if (pm_runtime_enabled(&pdev->dev)) {
-		ret = pm_runtime_get_sync(&pdev->dev);
+		ret = pm_runtime_resume_and_get(&pdev->dev);
 		if (ret < 0)
 			return ret;
 	} else {
-- 
2.51.0



