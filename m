Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442011FB9
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DFAC433EF;
	Fri,  3 Feb 2023 10:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675420056;
	bh=DTDbU4njEa8cVmUSV2f19Qh4e5R96knZqgdrgah3aKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFenw6eumJ2jSrGbwLnXQ5plb/+mCByZwGvCpgZZwS4v/FO0tntcvzGwGCF27//jK
	 TTcfL5yM4Lc+whA+lPZUnATae4xu0rl/yfJYiS2eb9/HJPEWFKiPrrxN2PbPh0C4xY
	 1Qe49odVYSKu7PThX9M9m7jVJ04Q3ew4AtXpn49c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/134] mmc: sdhci-esdhc-imx: disable the CMD CRC check for standard tuning
Date: Fri,  3 Feb 2023 11:12:51 +0100
Message-Id: <20230203101026.841481866@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 16e40e5b1e3c6646fd90d0c3186703d209216f03 ]

In current code, we add 1ms dealy after each tuning command for standard
tuning method. Adding this 1ms dealy is because USDHC default check the
CMD CRC and DATA line. If detect the CMD CRC, USDHC standard tuning
IC logic do not wait for the tuning data sending out by the card, trigger
the buffer read ready interrupt immediately, and step to next cycle. So
when next time the new tuning command send out by USDHC, card may still
not send out the tuning data of the upper command，then some eMMC cards
may stuck, can't response to any command, block the whole tuning procedure.

If do not check the CMD CRC for tuning, then do not has this issue. USDHC
will wait for the tuning data of each tuning command and check them. If the
tuning data pass the check, it also means the CMD line also okay for tuning.

So this patch disable the CMD CRC check for tuning, save some time for the
whole tuning procedure.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://lore.kernel.org/r/1590488522-9292-2-git-send-email-haibo.chen@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 1e336aa0c025 ("mmc: sdhci-esdhc-imx: correct the tuning start tap and step setting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 22bb5499f515..453ac2b6910c 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -89,6 +89,7 @@
 /* NOTE: the minimum valid tuning start tap for mx6sl is 1 */
 #define ESDHC_TUNING_START_TAP_DEFAULT	0x1
 #define ESDHC_TUNING_START_TAP_MASK	0x7f
+#define ESDHC_TUNING_CMD_CRC_CHECK_DISABLE	(1 << 7)
 #define ESDHC_TUNING_STEP_MASK		0x00070000
 #define ESDHC_TUNING_STEP_SHIFT		16
 
@@ -1246,6 +1247,18 @@ static void sdhci_esdhc_imx_hwinit(struct sdhci_host *host)
 				tmp |= imx_data->boarddata.tuning_step
 					<< ESDHC_TUNING_STEP_SHIFT;
 			}
+
+			/* Disable the CMD CRC check for tuning, if not, need to
+			 * add some delay after every tuning command, because
+			 * hardware standard tuning logic will directly go to next
+			 * step once it detect the CMD CRC error, will not wait for
+			 * the card side to finally send out the tuning data, trigger
+			 * the buffer read ready interrupt immediately. If usdhc send
+			 * the next tuning command some eMMC card will stuck, can't
+			 * response, block the tuning procedure or the first command
+			 * after the whole tuning procedure always can't get any response.
+			 */
+			 tmp |= ESDHC_TUNING_CMD_CRC_CHECK_DISABLE;
 			writel(tmp, host->ioaddr + ESDHC_TUNING_CTRL);
 		} else if (imx_data->socdata->flags & ESDHC_FLAG_MAN_TUNING) {
 			/*
@@ -1587,8 +1600,6 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	if (err)
 		goto disable_ahb_clk;
 
-	host->tuning_delay = 1;
-
 	sdhci_esdhc_imx_hwinit(host);
 
 	err = sdhci_add_host(host);
-- 
2.39.0



