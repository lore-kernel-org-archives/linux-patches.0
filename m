Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BD4403B06;
	Tue, 21 Jul 2026 17:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655326; cv=none; b=keTSPw37bQD+txUN/06FtCyz98Ijr36LRZ+9qhP7c+t1hRDcYSdGmfjo2AKc+G4wvd5/9JlRLkwTvcTgLbXV18w2Thxhbd9evNZfvWKsVCgKDpt5WU2benrwYaXBEYWYERIQ9lPA+6aKGZvkQnk+xWouoJeddal+oZ0HdzRDd0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655326; c=relaxed/simple;
	bh=E0YMCfvd1c0rm0AAP8JE3aL2EYh/r52vVdXQ5RNXKzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jr4mqYP63AgXreFmZAFIX6RMAEhNDMyYDpZceNlkGZzB6pfIZlHzQIa7Tk40E89tVzSLKrW7Ae1DnMF3TcL/QQ80NWuVyBg2f2BOdADFcx2iiOtrcJYpPDXQz/dz/oGeee9qxsxkOn+K7D8kMUlHOe6I3dcwHKaemaHtGjtEzMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVMA/MVX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVMA/MVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAA91F000E9;
	Tue, 21 Jul 2026 17:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655325;
	bh=tOx/ow43buhpbGyrhILrq1wJxyug4g/xQUvmXfd1gCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVMA/MVXec1FTuwMS2nuoqBNDoREYEoVTFsNEUwpf+KktQxL/6jAeeAbgVuO9QUqH
	 w4ck4LQr94A5tlpiMKyZqU/MIqeCxZ6i6TpTD0YoIooEN3DT2sJlatpWXo+4qC1nyj
	 KHYFhiD+8c9L6nF/zZPm+dnzmGDbEvPP/h/bxvhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 2042/2077] mmc: sdhci-esdhc-imx: make non-fatal errors non-blocking in suspend
Date: Tue, 21 Jul 2026 17:28:35 +0200
Message-ID: <20260721152640.862027286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2083,8 +2083,7 @@ static int sdhci_esdhc_suspend(struct de
 	disable_irq(host->irq);
 
 	if (device_may_wakeup(dev)) {
-		ret = sdhci_enable_irq_wakeups(host);
-		if (!ret)
+		if (!sdhci_enable_irq_wakeups(host))
 			dev_warn(dev, "Failed to enable irq wakeup\n");
 	} else {
 		/*
@@ -2095,12 +2094,12 @@ static int sdhci_esdhc_suspend(struct de
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
@@ -2108,7 +2107,7 @@ static int sdhci_esdhc_suspend(struct de
 	 */
 	pm_runtime_force_suspend(dev);
 
-	return ret;
+	return 0;
 }
 
 static int sdhci_esdhc_resume(struct device *dev)


