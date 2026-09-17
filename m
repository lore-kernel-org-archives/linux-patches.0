Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2A929BD9A;
	Thu, 17 Sep 2026 18:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668773; cv=none; b=SJUCkPFIRMdQcHEUSdsg1zw9RzN8Ka0KwUgNMlxm0HDKcLpKoQWCyZQKB2SQ40ckuyu7Cd0x5HAJ/DwS9hfdsJMXIk9CCb4fsx1iYJH5H2mrTEl3vamzAJWPum6VxKwapLNF3KGAhnyBjIUtNA4ZE5xv5XDLKMrtLDeTQU0COhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668773; c=relaxed/simple;
	bh=svzOy7zjwil9rWq5g7nSqvNxWOEb9VV4n9N86sy17bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hF/brdkHg4MRM8Y8fUgu8j44ePxge5zY6WpHadOEid3I3gxKGJlrM9AOguyuguML9SLMjly948Wn8jrgBFEqfxcLMdHOktg+mlhGcZXCklYGBfM8AhIoS8OATKljVjT5y/Yv7QeNSGCNUJSrYzDvcpNwm1A3/7f9ZhQ534VKsSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVHCeiCi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVHCeiCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277751F000FF;
	Thu, 17 Sep 2026 18:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668771;
	bh=Wml1d/UzKtBMTXTVo0Y5Q0nSbCIdXaVynXViR66gua4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVHCeiCi9EQbQzDP9TCbWVMSM7LXm7cHthszwE2FOyXMt2tO3blVadaLTdC1ABggY
	 6QIk7LAdT5QRK+Psm1zyIYIFi/506esFhIVMYKZFX+q0ZIzmJAo7ivzGEdLcscHo7H
	 3c2EoaEo34xafOHUqUNA74c0PH6nP0UEJENpaFRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0536/1102] watchdog: msc313e: Fix NULL pointer dereference in PM callbacks
Date: Thu, 17 Sep 2026 16:07:59 +0100
Message-ID: <20260917151553.267342304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



