Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0682129E6E;
	Mon,  4 Aug 2025 00:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267196; cv=none; b=NsX0pFogo9zy5/niPqwj6URJVLZhqteW6KP9ffIAaP5Ey/VsKb4JS9U70zHXQKMdXLRSZeoO+aLWrMttEvp5JyN9lSAN/bdu7XbKGdzqCavUVOf/1IbWhKizhQ9ez6ErEHOIqNURCNq87xEueCKd4iEYkl/9IrvdmcfKW4pwmZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267196; c=relaxed/simple;
	bh=Ai7ovGIQerXkAsNVRPPimO6sukyYoDbm6mm8ZOgM/W0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QjrZqP6fRz1UMs8tlhI6AxelTxyBaF8Lmj0E4UcoSyX4u7kbj3iipZ5Tkwcd/rhiBNVEkgSz3ZicOX8T3urLfyQATKR/zsrIGECQG52fEW/iaeZ0hMvQLFdLbxlq92305B3Ou4gQCBfUWwlN9CM68kCHnHjQgCDlvnb9EK/nsH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHD45dBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHD45dBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE53AC4CEEB;
	Mon,  4 Aug 2025 00:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267195;
	bh=Ai7ovGIQerXkAsNVRPPimO6sukyYoDbm6mm8ZOgM/W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHD45dBKJLgQ6lyZqW2gNYhZ5/A6DBoietAwwAleoZr3SlU7VNMzz+ztVb4UfvAEA
	 pfzqncVFv1GwkCJSczJ44Hl8Y4xjemp9jPdn+bXS4PRqiTgX1xB2yNnSX/FT2+i/RV
	 jTfZqq2qn/U9GOYPgAnZpymc43VhufBKHnZ+GK3lOxLPNIqpC8HcMaYI/cNiheUsfc
	 RJXn2OfIWb0lucshH30oLsWckPryhOGA/jvX/1lstkQYuKq+DUJCmT1mPh0+OfdiQy
	 uauZn082j5WR0rTDtVQEl40r60msO64T1jIx/gKfwG8CzfcPA73u7hFwmhF9dWJstB
	 WucbDAagp4MgA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haibo Chen <haibo.chen@nxp.com>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	adrian.hunter@intel.com,
	shawnguo@kernel.org,
	linux-mmc@vger.kernel.org,
	imx@lists.linux.dev,
	s32@nxp.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.16 58/85] mmc: sdhci-esdhc-imx: Don't change pinctrl in suspend if wakeup source
Date: Sun,  3 Aug 2025 20:23:07 -0400
Message-Id: <20250804002335.3613254-58-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real user-impacting bug**: The commit fixes a regression
   where SDIO WiFi devices fail to wake up the system from suspend. This
   is a functional regression that directly impacts users' ability to
   use WiFi wake-on-WLAN functionality on i.MX platforms.

2. **Small and contained fix**: The change is minimal - it simply moves
   the `pinctrl_pm_select_sleep_state()` call inside the else block of
   the wakeup check. The logic change is:
   - Before: Always switch to sleep pinctrl state during suspend
   - After: Only switch to sleep pinctrl state if the device is NOT a
     wakeup source

3. **Low risk of regression**: The fix is conservative and only affects
   the suspend path when the device is configured as a wakeup source.
   The normal suspend behavior (non-wakeup case) remains unchanged.

4. **Fixes a specific regression**: The bug was introduced when wakeup
   support was added in commit f62f7bcc827f ("mmc: sdhci-esdhc-imx:
   Enable support for system wakeup for SDIO") in v5.14. The original
   implementation didn't account for the conflict between pinctrl sleep
   states and wakeup functionality.

5. **Clear problem description**: The commit message clearly explains
   that on imx93-11x11-evk board, the DATA[1] pin being reconfigured to
   GPIO function during suspend prevents SDIO interrupts from waking the
   system.

6. **Subsystem-specific fix**: The change is confined to the i.MX-
   specific SDHCI driver and doesn't touch core MMC/SDHCI code,
   minimizing the risk of broader impacts.

The fix addresses a fundamental incompatibility between power-saving
pinctrl configurations and wakeup functionality - a common issue in
embedded systems that needs to be properly handled. This makes it a
strong candidate for stable backporting to ensure SDIO wakeup
functionality works correctly on affected i.MX platforms.

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

