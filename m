Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03397E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB21C433D6;
	Wed,  2 Nov 2022 02:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356934;
	bh=NXrLfcjVYLnYM3bEbiybgYzcXA/qKxy50MSqeFZmTZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jt7FbjwWw4NoHC3aDzCO51V1MaMQEJLRrBPnX1SZa6351A2j3yQnuR6PRR2UiEEN8
	 GzA0kC4JjhDHDhu2dmWK8MNLUDen1N6i2XhukoTrJEdO/9xxBmNdyR0MvaJi5IgMfC
	 /mFoYudCK/7leSPqJhAq2Ys4JnG5gFKnRQvVl1+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Haibo Chen <haibo.chen@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.0 084/240] mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on 8bit bus
Date: Wed,  2 Nov 2022 03:30:59 +0100
Message-Id: <20221102022113.299921649@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 1ed5c3b22fc78735c539e4767832aea58db6761c upstream.

The core issues the warning "drop HS400 support since no 8-bit bus" when
one of the ESDHC_FLAG_HS400* flags is set on a non 8bit capable host. To
avoid this warning set these flags only on hosts that actually can do
8bit, i.e. have bus-width = <8> set in the device tree.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Fixes: 029e2476f9e6 ("mmc: sdhci-esdhc-imx: add HS400_ES support for i.MX8QXP")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221013093248.2220802-1-s.hauer@pengutronix.de
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1660,6 +1660,10 @@ static int sdhci_esdhc_imx_probe(struct
 		host->mmc_host_ops.execute_tuning = usdhc_execute_tuning;
 	}
 
+	err = sdhci_esdhc_imx_probe_dt(pdev, host, imx_data);
+	if (err)
+		goto disable_ahb_clk;
+
 	if (imx_data->socdata->flags & ESDHC_FLAG_MAN_TUNING)
 		sdhci_esdhc_ops.platform_execute_tuning =
 					esdhc_executing_tuning;
@@ -1667,13 +1671,15 @@ static int sdhci_esdhc_imx_probe(struct
 	if (imx_data->socdata->flags & ESDHC_FLAG_ERR004536)
 		host->quirks |= SDHCI_QUIRK_BROKEN_ADMA;
 
-	if (imx_data->socdata->flags & ESDHC_FLAG_HS400)
+	if (host->caps & MMC_CAP_8_BIT_DATA &&
+	    imx_data->socdata->flags & ESDHC_FLAG_HS400)
 		host->mmc->caps2 |= MMC_CAP2_HS400;
 
 	if (imx_data->socdata->flags & ESDHC_FLAG_BROKEN_AUTO_CMD23)
 		host->quirks2 |= SDHCI_QUIRK2_ACMD23_BROKEN;
 
-	if (imx_data->socdata->flags & ESDHC_FLAG_HS400_ES) {
+	if (host->caps & MMC_CAP_8_BIT_DATA &&
+	    imx_data->socdata->flags & ESDHC_FLAG_HS400_ES) {
 		host->mmc->caps2 |= MMC_CAP2_HS400_ES;
 		host->mmc_host_ops.hs400_enhanced_strobe =
 					esdhc_hs400_enhanced_strobe;
@@ -1695,10 +1701,6 @@ static int sdhci_esdhc_imx_probe(struct
 			goto disable_ahb_clk;
 	}
 
-	err = sdhci_esdhc_imx_probe_dt(pdev, host, imx_data);
-	if (err)
-		goto disable_ahb_clk;
-
 	sdhci_esdhc_imx_hwinit(host);
 
 	err = sdhci_add_host(host);


