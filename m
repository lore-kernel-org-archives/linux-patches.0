Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73A83F5BFC;
	Wed, 30 Sep 2026 18:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791555; cv=none; b=rZOp9djgARwYEWqlQ9jMlYN4FM5g5F2lPFqSxnII6MEz8hNs4hLaJZZxYcp9Q67lGx9UhxUtQG/NSPt7JBszedqI/v6klGoABQVqY9zoG21AHoyQkxc3czPhlhOmxl/jDBLt2Ebe4yH5is2BBAZ3vNSgT6wNk0LTcGi7ke7zjLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791555; c=relaxed/simple;
	bh=uqF3vU/+Ylt26s/jNVoUTwidQMCpo7KQkJK61Ix1gQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovg8eAv5ttOjPf7Cgqlqd+hHtma5nTmZOGuSr+vBkmjuIZwiTBNcBmQiTrzhTV0OD8Eh/vgIm4BKTcIFPqjp4rZpwILn2VN3qzApxxvgBoDe11tnbhlPZeJPv0fiiIKYFgAxMtY4TpgZDeJvLE12N1ijnpILR3YloYgJStEceEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFoQSCtO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFoQSCtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBB01F000FF;
	Wed, 30 Sep 2026 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791553;
	bh=XxNj7Jn6CqMidwiQBXPM/o/gEjP3kpf+BEdeuxeGLYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zFoQSCtO8/3jI6WUW4Ap1I41Bsi9kNf6gtd13w08NciG7wk7c0rJL1SmSoAbSqXyI
	 rKTUFcCAncXBO6rUEMlpJqOVY92VNmwAhA2Gno7PON3qtoMk6Fgyu4oBDYp4ty03N+
	 9aMyxzdzsBruChmqLhqKD6hW0WvCI0l4HkPsTRpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 343/752] watchdog: msc313e: Avoid division by zero
Date: Wed, 30 Sep 2026 17:23:33 +0200
Message-ID: <20260930152405.714409428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 3bc7fceffa0bd..5dcf3f85ba842 100644
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
 
 	watchdog_set_drvdata(&priv->wdev, priv);
-- 
2.53.0



