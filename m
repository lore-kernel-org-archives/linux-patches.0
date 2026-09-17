Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631D24D17A5;
	Thu, 17 Sep 2026 17:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666010; cv=none; b=U+j8lW2VaKdEMkvf8+FtzotqhziY9IdhJ4oxIlSYdkS9pOdz94NnAXW3kHKT/sycRuYRewEj8x12yvS1NvvpHWLCP1HMy55/295NmsJ9N/EXmmF55OWzcwTG3QKrJYzVgC/+ESNfZ49e3CZIuR6xV8JLRmDAE29NEDaxtYzzV2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666010; c=relaxed/simple;
	bh=i7rkxBN11HG+nRZNXsKmp4mrTGbPEV8Uk3ACBVgGv7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m14TDoUnjXZmr4AwlS+Gg5BVAJU00xjvm+AmV8/K0pPyhsqJFdg6WyeSNnmGeNIBqOt4geMviGqL1+YUZ0vKNur/6ScM997GYd7VNr9qcbW4XRAHw0et+SXuUkAWgW0b0dqviEiDwW8ZpKD3sjWOW1dkW749hcQ4+aJ3uuCVhDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idijCePc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idijCePc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556C31F000FF;
	Thu, 17 Sep 2026 17:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666009;
	bh=8SL0XbktW4MROWDIOwzR61Y+fNBwdko2EmKmuHyAxZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idijCePcWwx2z0Sy3boE+fwhT9/SU1AKPE5W2WabRmfuDdej//cBL9g3h3HiAJ/Dd
	 fVu0V8e2e8rCovlV3G1tBYlpUJy3NQG0gjjSVmCU6KoziwrznBxy8ZNlXo6Do4y0K/
	 gm0o4A+B9OByQILOAxafb+leKXjOoQu0JQ3bsFU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0893/1250] watchdog: msc313e: Fix clock leak and spurious timer in settimeout()
Date: Thu, 17 Sep 2026 16:11:28 +0100
Message-ID: <20260917151616.192240286@linuxfoundation.org>
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

[ Upstream commit 3db30f315935c2fb0d95f46b7a593b5b4d3ec3d0 ]

msc313e_wdt_settimeout() unconditionally calls msc313e_wdt_start() which
introduces two severe bugs:

1. If the watchdog is already active, calling start() again will
   increase the reference count of the clock again.  However stop() is
   only called once, the reference count is unbalance.
2. If the watchdog is stopped, calling settimeout() will start
   the hardware timer accidentally.

Factor out the register-writing logic into a helper function.  Only call
it in settimeout() if the watchdog is running.  Otherwise, simply update
`wdev->timeout`.

Fixes: e9800b799464 ("watchdog: Add Mstar MSC313e WDT driver")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260828161348.13212-4-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/msc313e_wdt.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/watchdog/msc313e_wdt.c b/drivers/watchdog/msc313e_wdt.c
index 072bfcea85c24..5dc5e3ab7001e 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -32,20 +32,26 @@ struct msc313e_wdt_priv {
 	struct clk *clk;
 };
 
+static void msc313e_wdt_set_hw_timeout(struct msc313e_wdt_priv *priv,
+				       unsigned int timeout)
+{
+	u32 t = timeout * clk_get_rate(priv->clk);
+
+	writew(t & 0xffff, priv->base + REG_WDT_MAX_PRD_L);
+	writew((t >> 16) & 0xffff, priv->base + REG_WDT_MAX_PRD_H);
+	writew(1, priv->base + REG_WDT_CLR);
+}
+
 static int msc313e_wdt_start(struct watchdog_device *wdev)
 {
 	struct msc313e_wdt_priv *priv = watchdog_get_drvdata(wdev);
-	u32 timeout;
 	int err;
 
 	err = clk_prepare_enable(priv->clk);
 	if (err)
 		return err;
 
-	timeout = wdev->timeout * clk_get_rate(priv->clk);
-	writew(timeout & 0xffff, priv->base + REG_WDT_MAX_PRD_L);
-	writew((timeout >> 16) & 0xffff, priv->base + REG_WDT_MAX_PRD_H);
-	writew(1, priv->base + REG_WDT_CLR);
+	msc313e_wdt_set_hw_timeout(priv, wdev->timeout);
 	return 0;
 }
 
@@ -70,9 +76,13 @@ static int msc313e_wdt_stop(struct watchdog_device *wdev)
 
 static int msc313e_wdt_settimeout(struct watchdog_device *wdev, unsigned int new_time)
 {
+	struct msc313e_wdt_priv *priv = watchdog_get_drvdata(wdev);
+
 	wdev->timeout = new_time;
 
-	return msc313e_wdt_start(wdev);
+	if (watchdog_hw_running(wdev) || watchdog_active(wdev))
+		msc313e_wdt_set_hw_timeout(priv, wdev->timeout);
+	return 0;
 }
 
 static const struct watchdog_info msc313e_wdt_ident = {
-- 
2.53.0



