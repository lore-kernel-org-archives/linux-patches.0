Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9DE5221C1;
	Wed, 30 Sep 2026 18:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791285; cv=none; b=bZJtn1x7cKtzb0EeuAojXkRvdLWHI9eVTSTTmnrh9m1tybif2cGOvdX98XnlunDwVkLgC/Wr0oGZz1cu+Rf+50o3wFT0zCGfYYc8mjgkgNa+inBfIT9LVLt1zFSnwizVMNd2h4mLPTDWWRq3ZnfwqDzZUeCk+YfJ0hj2f5mlXsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791285; c=relaxed/simple;
	bh=d+ZGC1po0GVSVFo6/+GfB2Q0aNzbXG85OoEXB+OQS5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCNa0FilkkKFko10la7p04pNknRz8OrvgCf2ROFrUvb3JoDB30oUPJoRwpTR5m1XUcvzPYIudQ3gENlUfd6zzLjA+LwF2FkW4A3JgIBBegby6LBFFKONbunOW8XlRnl6GKPzCv+N/hqeVtKcNWEzHkexHzBrf1P+U6F1XSPEphY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqpX/0cB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqpX/0cB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EFB1F000FF;
	Wed, 30 Sep 2026 18:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791283;
	bh=xy+iGAo9yr9yiDKKjkq2tP0R9aCySuoG02EIhfCxVyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RqpX/0cB8WbK/c/UE8PzgHeNn3+m2uuERlWGO4Lmv1MPepPyvhydBk9bcDj5xttNK
	 +Qa07eapra2JxZ5XQfT/+LTEKvZ4QsBRX3LprtI0sz+Gx9bnQzQxIlwWVEgWr0bVXz
	 nxKPZlQPLRjXHFmLvyzL+p7MciBTFzzKCyfD/Qek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 248/752] watchdog: msc313e: Fix NULL pointer dereference in PM callbacks
Date: Wed, 30 Sep 2026 17:21:58 +0200
Message-ID: <20260930152403.642936320@linuxfoundation.org>
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

[ Upstream commit e3eceb76515910746e6268c4e4ac1c07516ebd7b ]

msc313e_wdt_probe() doesn't set the driver data for the platform device.
As a result, dev_get_drvdata() in msc313e_wdt_suspend() and
msc313e_wdt_resume() will return NULL, leading to a NULL pointer
dereference afterward.

Set the platform device driver data in msc313e_wdt_probe().

Fixes: e9800b799464 ("watchdog: Add Mstar MSC313e WDT driver")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260827044700.554333-2-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/msc313e_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/msc313e_wdt.c b/drivers/watchdog/msc313e_wdt.c
index 0d497aa0fb7d9..3bc7fceffa0bd 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -121,6 +121,7 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 	priv->wdev.timeout = MSC313E_WDT_DEFAULT_TIMEOUT;
 
 	watchdog_set_drvdata(&priv->wdev, priv);
+	platform_set_drvdata(pdev, priv);
 
 	watchdog_init_timeout(&priv->wdev, timeout, dev);
 	watchdog_stop_on_reboot(&priv->wdev);
-- 
2.53.0



