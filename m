Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279864E0209;
	Thu, 17 Sep 2026 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658910; cv=none; b=hNtSAEDsccXnHd2ilkKqJfVhtDBhI2pxVseNp4q7+o/FeM0GlGDeD235Zq/MD7gPfLvpzSHmxC91ND4jDWTObpdOOw5bxInj8rKBid/d4o0hDWb/6Dza7zHQxpdHT6tUlC3dYljpVy3LpUpqiau2icga9eZ8QRuL1uy7RboF52k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658910; c=relaxed/simple;
	bh=BaSxkqbjEHciE2TT17TaIVEPB7Z3JPx1sk5MDCKRNLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MskMcqHNlUYmPNH822dD8eSNvelzbSNqPQDTwr3PFv8hBtnwVqwdy163e1PDu1vaOp2HXTr9hvlNf1ac3ejD2vq02yNEWzngJTUO5sq24gMdARBcTxHyPBz+/lHhAkqwuLSiOtr4AgthsVSwOH/oUqwnM9gd45urI1E1PyVTZKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6iwe1qL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6iwe1qL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A7F1F00899;
	Thu, 17 Sep 2026 15:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658904;
	bh=ic33Ak/FO6n6YjWhp4zzI+uocl3lffPoy0aEiHzqEdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p6iwe1qLUOGBXsjQY5oqajNkaIxtViuxCS2OvviYqJIXoDbsgDl0hSjyFHim0b957
	 QypmdcejpLP9EVY60xhIjVdBO0d04eQgM5FrQ8xNDIdPCaeVr/fMgWv4Xo1rhdizKX
	 dIQOyW9EqeurNmvx6uLxvQA7CuRApqo9GMq3fz/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 076/733] watchdog: msc313e: Fix NULL pointer dereference in PM callbacks
Date: Thu, 17 Sep 2026 16:06:24 +0100
Message-ID: <20260917151352.770901463@linuxfoundation.org>
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
index d962589e2c55a..f69d66971c41d 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -124,6 +124,7 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 		set_bit(WDOG_HW_RUNNING, &priv->wdev.status);
 
 	watchdog_set_drvdata(&priv->wdev, priv);
+	platform_set_drvdata(pdev, priv);
 
 	watchdog_init_timeout(&priv->wdev, timeout, dev);
 	watchdog_stop_on_reboot(&priv->wdev);
-- 
2.53.0



