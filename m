Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE61D335BCB;
	Mon, 18 Aug 2025 13:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525164; cv=none; b=lZlBgMWJuJCqGH9idybaH2xejy+7ZZhLE6CkxsPa0gx8dPTlPBBFwB+WCCijaK3J4ljBnCI0PNvw/J0qJ1tf7lm3ATVlPUP6a0SKaCT2ZY4rO8PRpdwuDlrMW8LnZ6kVRDVxVzJ8Lq7VrjQPHHa7DMxFJwMD7tcRYAGqcPwklsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525164; c=relaxed/simple;
	bh=ki7BGhoOgsT1gC/iokOtKkJMCCa3liFvU8HvthpY5Ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agioXc8YEYxnAqAlYcjWRIwKmau4BJ7+DJSx2ZfIgNRz8QejImW3xdBJz7jGCiUnd7dT25KB4nfbgxZOilUd9v0Yt7PmCDzKU4u8RAceG3N2CiPzjnudznuGv0UrY9MQRbS/iy/UySdALaQbFxHqLquAc+aO/4Ut1emGWIFrVfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqjJHRnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqjJHRnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250A4C4CEEB;
	Mon, 18 Aug 2025 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525164;
	bh=ki7BGhoOgsT1gC/iokOtKkJMCCa3liFvU8HvthpY5Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GqjJHRnMIIGxgcWGedp44HfRWMgE1g/hd3MthiLhOYiamWenoEd1LAoblCgeZ1yKd
	 /SEpGE0+O5dNgpLJesmxWl+/lXOufPijIH9JdJeadNagNRPqmpVM+Q86Z9fnHfsyBM
	 /xEhUuFbdmcDaZQhiKcZIasNqQK2O1KEIlKunjGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 179/570] mmc: sdhci-esdhc-imx: Dont change pinctrl in suspend if wakeup source
Date: Mon, 18 Aug 2025 14:42:46 +0200
Message-ID: <20250818124512.693542542@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 031d9e30d569ca15ca32f64357c83eee6488e09d ]

The pinctrl sleep state may config the pin mux to certain function to save
power in system suspend. Unfortunately this doesn't work if usdhc is used
as a wakeup source, like waking up on SDIO irqs or card-detect irqs. In
these cases, we need pin mux to be configured to usdhc function pad.

The issue is found on imx93-11x11-evk board, where WiFI over SDIO with
in-band irqs fails to wakeup the system, because the DATA[1] pin has been
set to GPIO function.

To fix the problem, don't change the pinctrl state in suspend if there is a
system wakeup enabled.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Link: https://lore.kernel.org/r/20250521033134.112671-1-ziniu.wang_1@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index ac187a8798b7..05dd2b563c02 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -2039,12 +2039,20 @@ static int sdhci_esdhc_suspend(struct device *dev)
 		ret = sdhci_enable_irq_wakeups(host);
 		if (!ret)
 			dev_warn(dev, "Failed to enable irq wakeup\n");
+	} else {
+		/*
+		 * For the device which works as wakeup source, no need
+		 * to change the pinctrl to sleep state.
+		 * e.g. For SDIO device, the interrupt share with data pin,
+		 * but the pinctrl sleep state may config the data pin to
+		 * other function like GPIO function to save power in PM,
+		 * which finally block the SDIO wakeup function.
+		 */
+		ret = pinctrl_pm_select_sleep_state(dev);
+		if (ret)
+			return ret;
 	}
 
-	ret = pinctrl_pm_select_sleep_state(dev);
-	if (ret)
-		return ret;
-
 	ret = mmc_gpio_set_cd_wake(host->mmc, true);
 
 	/*
-- 
2.39.5



