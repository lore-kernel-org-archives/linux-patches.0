Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8E351B178;
	Wed, 30 Sep 2026 16:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784977; cv=none; b=iGzL46Oi3fCFk2cdMpw/7TdTaWA0C4PNczMfTS7xWFdFSOdaOehgnoCCZU3hikzW2wGWnv/f0i1A+atNVXVq6l7W0W+oA/fl+qN17ajm1cUYcfj93UN5yrvclzPmTlgaaBZmr5+etLy/zTd7ynBue8eMMtW9y1sNGD6Yzt6Ffwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784977; c=relaxed/simple;
	bh=FlrDTBCNJbenwPWOgu2CuGdZ+4oSq4aoO5vXteJML3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUbg5qQhJHeL3kYypYS4Ie/byIXX0+Z1B0lrTEdIWaiuRlMr/ioD8yaaZVCNSlkHvX5Wq3nw/OuRxUwYOr1W8U71DlPV/YLvJZe4XExWb8UKA7mpJKASBRz4IWtldHcOnkDNatKPMG2OkCuN30c69VWwYLwuCdeuwbprpMBi68w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=espYCLIg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="espYCLIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3BC1F0089A;
	Wed, 30 Sep 2026 16:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784971;
	bh=kKOvOlwaLO7s7H5uKY+Z2pTYavqJoNbyC6MIaOgpdk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=espYCLIg1VXzoluM76lY/HqB40hFRzj/aVnDnsKbhMglSo0v6Siyzd4iauiSoU6GP
	 jZqmKnPpJnYiPVUY1qRfgd5YtTBFdrbCxgGMTmbCZtR6uXU1XXSN9VEuXYYySt0lJp
	 niJr5A7ZVTxb7YrLGT+EFagBHYTaSAewT2MWAnzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 342/982] watchdog: msc313e: Fix NULL pointer dereference in PM callbacks
Date: Wed, 30 Sep 2026 17:17:58 +0200
Message-ID: <20260930152424.163029582@linuxfoundation.org>
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



