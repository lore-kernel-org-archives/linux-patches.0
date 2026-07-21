Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C98E2DECDF;
	Tue, 21 Jul 2026 18:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659421; cv=none; b=GnhpAGxNtA12GKyspNc2ftsO13P6V9MNlpFk0Z3w8Zu6lREx9pg8b+6lMbC2R6yAoOEH7xsxp8R4SsWknBIyN2cK09VKp3cAwIIfVwRpxo6L7XHeeOjp2JVI8kIcVKH6v2eioZxEOfubA1zgwF91L8y5Qdm5wxLZKLDXvv0yMGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659421; c=relaxed/simple;
	bh=sG15dYVEsZMW5/Xl1cSn0Ndt7gz/WlKvZu7+pDWpE6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4gAGUQdLcvHnq/8invLDZxEgEqVOe2K1X1gbILYYWzyHDU3N55lbUPJzBs/HQeHNLVEBdxIFSGnqn+qC9HvcVG6PHsJED7F0gncUaWA+U7aKE/JW9CB5Fh0q6pnwzTX0GCg3vFvomXWYaWNsGHSvx0Taj62CuR7NKYHq0poPNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smedV7B/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smedV7B/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30B21F000E9;
	Tue, 21 Jul 2026 18:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659420;
	bh=1QHeWqcyOhRoSaEl2TdldyzFrGKarTm8T0paQyzrrGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=smedV7B/ft6IzurvZacAcY26vti66rKY6t1uIXe1+UJOj5pSNA0RcWsrhUmNoxaoi
	 fe+sfubfq/cKteq/XakhKa1CzoSsBboEWbXnOXZd8o7k3KI1vbDbjsADjpFf9XyJgf
	 BDs12tgKZ4OzX6g2rhq7wYGHfSUwWSzExs62Vv9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 1513/1611] mmc: sdhci-esdhc-imx: make non-fatal errors non-blocking in suspend
Date: Tue, 21 Jul 2026 17:27:09 +0200
Message-ID: <20260721152549.474182360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Luke Wang <ziniu.wang_1@nxp.com>

commit 6aa00a43bbd3d994558a55586351757cebbff236 upstream.

Make pinctrl_pm_select_sleep_state() and mmc_gpio_set_cd_wake() failures
non-fatal in the suspend path. These failures only mean slightly higher
power consumption or missing CD wakeup capability, but should not block
system suspend.

Also change the function to always return 0 on the success path instead
of propagating non-fatal warning return values.

Fixes: 676a83855614 ("mmc: host: sdhci-esdhc-imx: refactor the system PM logic")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -2060,8 +2060,7 @@ static int sdhci_esdhc_suspend(struct de
 	disable_irq(host->irq);
 
 	if (device_may_wakeup(dev)) {
-		ret = sdhci_enable_irq_wakeups(host);
-		if (!ret)
+		if (!sdhci_enable_irq_wakeups(host))
 			dev_warn(dev, "Failed to enable irq wakeup\n");
 	} else {
 		/*
@@ -2072,12 +2071,12 @@ static int sdhci_esdhc_suspend(struct de
 		 * other function like GPIO function to save power in PM,
 		 * which finally block the SDIO wakeup function.
 		 */
-		ret = pinctrl_pm_select_sleep_state(dev);
-		if (ret)
-			return ret;
+		if (pinctrl_pm_select_sleep_state(dev))
+			dev_warn(dev, "Failed to select sleep pinctrl state\n");
 	}
 
-	ret = mmc_gpio_set_cd_wake(host->mmc, true);
+	if (mmc_gpio_set_cd_wake(host->mmc, true))
+		dev_warn(dev, "Failed to enable cd wake\n");
 
 	/*
 	 * Make sure invoke runtime_suspend to gate off clock.
@@ -2085,7 +2084,7 @@ static int sdhci_esdhc_suspend(struct de
 	 */
 	pm_runtime_force_suspend(dev);
 
-	return ret;
+	return 0;
 }
 
 static int sdhci_esdhc_resume(struct device *dev)


