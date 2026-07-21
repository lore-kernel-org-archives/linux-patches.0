Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80692DF3EA;
	Tue, 21 Jul 2026 18:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659410; cv=none; b=jyV6ZgditfKXg+YWzPUonj8c0fsSlrdExo+gq+KO8f/vyAxp9PTUHjNoJXse1AA8n7v+hNjZCq3estMIOkSJucJPQW8S9E9pD6VtxyYbSUNBGDN32eCPeRm+rJT/yS6GTGNhR07XldqKLlxg867H0JRvnwuxjHmEvQYpK+v44bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659410; c=relaxed/simple;
	bh=6MQEcUtBW0hCfE+wyC9mhxSnsFI2Y9MeF+dhTMp0mG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgWv8UEBaMONy2Z6fFYudqSH0l8xyH10YiMQdQ9f6A+xcV0RtgWx78jDyvFxrv60M+khM9UbHNgX818Sa8EPDhlmLvTJt9C62YcTwnRoL6HhrwgVocFxyd1kMWEO5VIhtIoWkEv1ajv4bZtbc1ex9J9smSwX8Yitv+EY0QJyRRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pda7gFIF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pda7gFIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351B71F000E9;
	Tue, 21 Jul 2026 18:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659409;
	bh=+0o/crtzENms4MiE9iR4auksm8iDR+oS6O89fr1jcB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pda7gFIFGJhS5/4XgIag6m1dhVekdTcEhKgvvCQFfSspQRy/e5tmYTlZ/kOWofUVk
	 a6eSKmY/Njl1kzmt152b5lB7N1/4vIlceqqEd+J7+0oZM7E+0JK1jnJ/jOe+Eb22y2
	 iHp6MGp/ekWQqFynpFlY19FCIpRqgsy/jWUs7A4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 1510/1611] mmc: sdhci-esdhc-imx: fix esdhc_change_pinstate() to allow default state restore
Date: Tue, 21 Jul 2026 17:27:06 +0200
Message-ID: <20260721152549.405588722@linuxfoundation.org>
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

commit 5adc14cd4b905629d5b9163b3a416dcab24c7ce2 upstream.

esdhc_change_pinstate() checks for pins_100mhz and pins_200mhz at the
top of the function and returns -EINVAL if either is not defined. This
prevents the default case from ever being reached, which means devices
with a sleep pinctrl state but without high-speed pin states (100mhz/
200mhz) can never restore their default pin configuration.

Move the IS_ERR checks for pins_100mhz and pins_200mhz into their
respective switch cases.

Fixes: 676a83855614 ("mmc: host: sdhci-esdhc-imx: refactor the system PM logic")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1315,19 +1315,21 @@ static int esdhc_change_pinstate(struct
 
 	dev_dbg(mmc_dev(host->mmc), "change pinctrl state for uhs %d\n", uhs);
 
-	if (IS_ERR(imx_data->pinctrl) ||
-		IS_ERR(imx_data->pins_100mhz) ||
-		IS_ERR(imx_data->pins_200mhz))
+	if (IS_ERR(imx_data->pinctrl))
 		return -EINVAL;
 
 	switch (uhs) {
 	case MMC_TIMING_UHS_SDR50:
 	case MMC_TIMING_UHS_DDR50:
+		if (IS_ERR(imx_data->pins_100mhz))
+			return -EINVAL;
 		pinctrl = imx_data->pins_100mhz;
 		break;
 	case MMC_TIMING_UHS_SDR104:
 	case MMC_TIMING_MMC_HS200:
 	case MMC_TIMING_MMC_HS400:
+		if (IS_ERR(imx_data->pins_200mhz))
+			return -EINVAL;
 		pinctrl = imx_data->pins_200mhz;
 		break;
 	default:


