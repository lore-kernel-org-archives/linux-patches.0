Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBD036921B;
	Wed, 30 Sep 2026 16:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785314; cv=none; b=Hld4M5+7HX6dqoaxA0R2/hdQ5J+XnwDx+s48CmyOKs3ciLLmoPuZ+efuQdqXDClVAD90j4LqKHl2PbGiBSlsGxoffW0nrhY2EZfaF12BK4NH5vpDUFk5dZXJQsuhWL7NfGrwk8u7rAQMf7bpnMZCaEBf5hrzUr4kfCtUTHswAtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785314; c=relaxed/simple;
	bh=zMxDDfCBRq2Khgpprgna9xsy6UBQkGGHt9hU3Jegl1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDbecRF7cLtMn/XwKTFZ04v9P0kLT5deSi+U5GZX/A/5ZCJC6B4pvKxD8Mw5l7NT+Qq0IgsOJ7TWmqhYru4R2bdGj1g5bYeQ6e6w2MU4Mv/eP6h+LWTESXiZdfjU4OfpCG7smbkukDAn63YS827Neanu+5OzCrxNW9w7dySUIBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrn8lUAi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrn8lUAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E331F00898;
	Wed, 30 Sep 2026 16:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785302;
	bh=ZYkFLfZFGoCpMgQmgMqzhz7yXh/b/O4a9lvAzRwrgSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jrn8lUAiWz3iyvNxwzW3pYZHCSbIJrhrIfthTALh5HA2/S/aIbx2NYCL/y/pqHGxf
	 dinw1waUno/pz/sCZEmWrQFToTjWbrE5/ar3Rik9g7fq1xyewlkBgs4rlwdnGaCSfA
	 hvFH2mW+P4U0amjyGkQZgKp+9jDzEscK/7II7RrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 462/982] watchdog: msc313e: Avoid division by zero
Date: Wed, 30 Sep 2026 17:19:58 +0200
Message-ID: <20260930152426.709804102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



