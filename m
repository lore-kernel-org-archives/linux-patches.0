Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25EE6D6E4;
	Mon,  8 Jan 2024 15:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZD4lpdpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF84C433CB;
	Mon,  8 Jan 2024 15:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726932;
	bh=1UODeR7K3L5cYaRnQut7h7ZSeef8dWTkFycJv7RpGIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZD4lpdpn+53QIOisrjm7HC41+LXXbeYpiGQgjE3NFPEBX01ykphKvBaChBU0dbH1z
	 3bonK7B+o6ha7Se7wchh02WrKNtW7ABMdNtcFCAu4t4U5v06lDWDXqzG5Gzq5/Wlz6
	 y8DE8kCE+6PzDf6yAsA5aaSquk9nhpTulvhmKyTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Huang <hzyitc@outlook.com>,
	Anand Moon <linux.amoon@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 117/124] mmc: meson-mx-sdhc: Fix initialization frozen issue
Date: Mon,  8 Jan 2024 16:09:03 +0100
Message-ID: <20240108150608.351560662@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziyang Huang <hzyitc@outlook.com>

commit 8c124d998ea0c9022e247b11ac51f86ec8afa0e1 upstream.

Commit 4bc31edebde5 ("mmc: core: Set HS clock speed before sending
HS CMD13") set HS clock (52MHz) before switching to HS mode. For this
freq, FCLK_DIV5 will be selected and div value is 10 (reg value is 9).
Then we set rx_clk_phase to 11 or 15 which is out of range and make
hardware frozen. After we send command request, no irq will be
interrupted and the mmc driver will keep to wait for request finished,
even durning rebooting.

So let's set it to Phase 90 which should work in most cases. Then let
meson_mx_sdhc_execute_tuning() to find the accurate value for data
transfer.

If this doesn't work, maybe need to define a factor in dts.

Fixes: e4bf1b0970ef ("mmc: host: meson-mx-sdhc: new driver for the Amlogic Meson SDHC host")
Signed-off-by: Ziyang Huang <hzyitc@outlook.com>
Tested-by: Anand Moon <linux.amoon@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/TYZPR01MB5556A3E71554A2EC08597EA4C9CDA@TYZPR01MB5556.apcprd01.prod.exchangelabs.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-mx-sdhc-mmc.c |   26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

--- a/drivers/mmc/host/meson-mx-sdhc-mmc.c
+++ b/drivers/mmc/host/meson-mx-sdhc-mmc.c
@@ -269,7 +269,7 @@ static int meson_mx_sdhc_enable_clks(str
 static int meson_mx_sdhc_set_clk(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct meson_mx_sdhc_host *host = mmc_priv(mmc);
-	u32 rx_clk_phase;
+	u32 val, rx_clk_phase;
 	int ret;
 
 	meson_mx_sdhc_disable_clks(mmc);
@@ -290,27 +290,11 @@ static int meson_mx_sdhc_set_clk(struct
 		mmc->actual_clock = clk_get_rate(host->sd_clk);
 
 		/*
-		 * according to Amlogic the following latching points are
-		 * selected with empirical values, there is no (known) formula
-		 * to calculate these.
+		 * Phase 90 should work in most cases. For data transmission,
+		 * meson_mx_sdhc_execute_tuning() will find a accurate value
 		 */
-		if (mmc->actual_clock > 100000000) {
-			rx_clk_phase = 1;
-		} else if (mmc->actual_clock > 45000000) {
-			if (ios->signal_voltage == MMC_SIGNAL_VOLTAGE_330)
-				rx_clk_phase = 15;
-			else
-				rx_clk_phase = 11;
-		} else if (mmc->actual_clock >= 25000000) {
-			rx_clk_phase = 15;
-		} else if (mmc->actual_clock > 5000000) {
-			rx_clk_phase = 23;
-		} else if (mmc->actual_clock > 1000000) {
-			rx_clk_phase = 55;
-		} else {
-			rx_clk_phase = 1061;
-		}
-
+		regmap_read(host->regmap, MESON_SDHC_CLKC, &val);
+		rx_clk_phase = FIELD_GET(MESON_SDHC_CLKC_CLK_DIV, val) / 4;
 		regmap_update_bits(host->regmap, MESON_SDHC_CLK2,
 				   MESON_SDHC_CLK2_RX_CLK_PHASE,
 				   FIELD_PREP(MESON_SDHC_CLK2_RX_CLK_PHASE,


