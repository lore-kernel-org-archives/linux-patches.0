Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268214D37B0;
	Wed, 30 Sep 2026 16:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785320; cv=none; b=Q/fJvg1/pudOONLLfZ8JCmb8dvbu4UpbnwYSwb1ThJBOdLGvcJYzE85IRAK36La1dAkGGoddCHRQu0xHEYvq7XFAKqOflipWlFJylJt9MytozUN7QvlTYLAvKZcWTw/lGz5uSi7dc0VowlgTqyTtEakhEmWMip+ayPYgmIfS98U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785320; c=relaxed/simple;
	bh=c19Mk3afUcOVB9FCzJXzejtRzk0GMaxFl7HA3nvDp8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yx6JJsYwDSEWNCfd+vCUE0YXw+1vZ+6zjFE9v+mKmnFazp2eVQod5Z4C5FMTBlY7sUqZXXm6WJK5bg6Q7ztNRYXalcAU5q/xzLVSo0OQT5NYfimBjxkYIjNTTADq9RzTeyKOLU4LWPeUr2l2/xwGMfjVSdJx4ztIl6EXyBvPBrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=btK9XZik; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="btK9XZik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0909B1F00899;
	Wed, 30 Sep 2026 16:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785313;
	bh=akqRD5ASZOH4W12hFgpkfzR48SsCc8sGNvEPGxbMjFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=btK9XZikONNOKVCAmQzfEkTRTJm3pf7UQk7VUJ50dPKRUSW3Z3wsY9Y+c4vpN1nKY
	 xN+IiDCVloTck0vAmx1oGVtLlNl1ol986huJlzjXrSKK7u66hUd21ZguaUvlHeydKj
	 QDjmcZC+EJdRCFBIzjWkuUPnj3KSVp/XTp8NRSYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 465/982] watchdog: msc313e: Fix spurious reset on suspend
Date: Wed, 30 Sep 2026 17:20:01 +0200
Message-ID: <20260930152426.774438228@linuxfoundation.org>
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

[ Upstream commit 4f6817c9eff4aa1078e16652d82e4b7ef4ffae3e ]

If the hardware watchdog was started by the bootloader and the device is
suspended before userspace opens it, the ping worker (from watchdog
core) is frozen and the active hardware timer continues running.  This
leads to a spurious system reset.

Check both watchdog_active() and watchdog_hw_running() when deciding
whether to start or stop the watchdog during suspend and resume.

Additionally, call watchdog_stop_ping_on_suspend() to ensure the ping
worker be correctly paused and restarted during suspend and resume.

Fixes: ffd264bd152c ("watchdog: msc313e: Check if the WDT was running at boot")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260828161348.13212-6-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/msc313e_wdt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/msc313e_wdt.c b/drivers/watchdog/msc313e_wdt.c
index 86e72aea96855..9cfe059fd31a7 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -157,6 +157,7 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 	watchdog_init_timeout(&priv->wdev, timeout, dev);
 	watchdog_stop_on_reboot(&priv->wdev);
 	watchdog_stop_on_unregister(&priv->wdev);
+	watchdog_stop_ping_on_suspend(&priv->wdev);
 
 	ret = devm_watchdog_register_device(dev, &priv->wdev);
 
@@ -171,7 +172,7 @@ static int __maybe_unused msc313e_wdt_suspend(struct device *dev)
 {
 	struct msc313e_wdt_priv *priv = dev_get_drvdata(dev);
 
-	if (watchdog_active(&priv->wdev))
+	if (watchdog_active(&priv->wdev) || watchdog_hw_running(&priv->wdev))
 		msc313e_wdt_stop(&priv->wdev);
 
 	return 0;
@@ -181,7 +182,7 @@ static int __maybe_unused msc313e_wdt_resume(struct device *dev)
 {
 	struct msc313e_wdt_priv *priv = dev_get_drvdata(dev);
 
-	if (watchdog_active(&priv->wdev))
+	if (watchdog_active(&priv->wdev) || watchdog_hw_running(&priv->wdev))
 		msc313e_wdt_start(&priv->wdev);
 
 	return 0;
-- 
2.53.0



