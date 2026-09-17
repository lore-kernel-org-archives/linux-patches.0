Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E99751DDF4;
	Thu, 17 Sep 2026 17:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665241; cv=none; b=bW7487lvonCHf0woHnmRYHlP3KMgjjO14VYryjnLTLil+nM3R0PyGSmIa86lOlmrE4NL+csZwKNvCs6ijwj40rMGUya4lGP4zG1Osiu7J9LWBKm2IGXHwv9/5HdHcdGw2tOqp4vG9/D1mneBB5lnpgaYkdnc6gki5nmRPWz8pC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665241; c=relaxed/simple;
	bh=Sgsz2WsANNm3eCW40xt1npi12Mvo1mE5IV9C7qL0EXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqbFDMejL/DzQyn1QvdXyEleYXOVKpfpaUAayM0fPvUON2nJnTwUMBj6FXG48JPr2m8a0K/YqCg/NVirGe58JY0BG7uxfytyQRJLCr4TQ1eiKgkyKgmd+zE27BdAmBSdKxPGetwXbocHaLHI9Hr0UwUEKcjjMmovCOqKh+fBs78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8xpIYDr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8xpIYDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A591F000FF;
	Thu, 17 Sep 2026 17:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665239;
	bh=9Agy6jbQROqkTQNDfbiCcBzzWcByLQ92eEX1fi9Qu6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8xpIYDrmW4i4I/7lb5oDbLbnxn4LbmQFG+UNz/Wyw4x08/NHCQzAe8KJ5aQP2PSS
	 ENTk7BnbkauZDEHkRCczQiVxZ67iwc5nDwHug9oKdgDM1f8dYaQhWUSFFIsoDGBAaR
	 YdrLnROv0ajTLZNoFjluN7l3ujFqm1xZ12fhpVNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0638/1250] watchdog: msc313e: Fix NULL pointer dereference in PM callbacks
Date: Thu, 17 Sep 2026 16:07:13 +0100
Message-ID: <20260917151609.182627401@linuxfoundation.org>
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
index 90171431fc594..3b62650375628 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -125,6 +125,7 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 		set_bit(WDOG_HW_RUNNING, &priv->wdev.status);
 
 	watchdog_set_drvdata(&priv->wdev, priv);
+	platform_set_drvdata(pdev, priv);
 
 	watchdog_init_timeout(&priv->wdev, timeout, dev);
 	watchdog_stop_on_reboot(&priv->wdev);
-- 
2.53.0



