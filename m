Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D0D28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63A4C433D2;
	Mon, 12 Dec 2022 13:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853271;
	bh=8QM0V+sylQ9NgxPfN44XcTwySq/1QPCNsEkUz4w1/To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xYLUMWsyYJS1J2hgKfOYVs6ghGd/SAA/la7iWKCfFpO2QizU9y0DYJ0exiEd6u6F
	 y9f5/COhA23mmHzDiUFX6LV37XvT+zpo3rqRn3Z7JsMPB/pTt7ZoHjpBe7AvcT97O1
	 L4BcA8DHI4uiecWxkQn+WkzT1dTBqtpFOTCVQNxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.9 10/31] mmc: sdhci: use FIELD_GET for preset value bit masks
Date: Mon, 12 Dec 2022 14:19:28 +0100
Message-Id: <20221212130910.510466202@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
References: <20221212130909.943483205@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit fa0910107a9fea170b817f31da2a65463e00e80e upstream.

Use the FIELD_GET macro to get access to the register fields.
Delete the shift macros.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Link: https://lore.kernel.org/r/20200312110050.21732-1-yamada.masahiro@socionext.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |   10 +++++-----
 drivers/mmc/host/sdhci.h |   10 ++++------
 2 files changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -13,6 +13,7 @@
  *     - JMicron (hardware and technical support)
  */
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
@@ -1266,10 +1267,9 @@ u16 sdhci_calc_clk(struct sdhci_host *ho
 
 			clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
 			pre_val = sdhci_get_preset_value(host);
-			div = (pre_val & SDHCI_PRESET_SDCLK_FREQ_MASK)
-				>> SDHCI_PRESET_SDCLK_FREQ_SHIFT;
+			div = FIELD_GET(SDHCI_PRESET_SDCLK_FREQ_MASK, pre_val);
 			if (host->clk_mul &&
-				(pre_val & SDHCI_PRESET_CLKGEN_SEL_MASK)) {
+				(pre_val & SDHCI_PRESET_CLKGEN_SEL)) {
 				clk = SDHCI_PROG_CLOCK_MODE;
 				real_div = div + 1;
 				clk_mul = host->clk_mul;
@@ -1720,8 +1720,8 @@ static void sdhci_set_ios(struct mmc_hos
 
 			sdhci_enable_preset_value(host, true);
 			preset = sdhci_get_preset_value(host);
-			ios->drv_type = (preset & SDHCI_PRESET_DRV_MASK)
-				>> SDHCI_PRESET_DRV_SHIFT;
+			ios->drv_type = FIELD_GET(SDHCI_PRESET_DRV_MASK,
+						  preset);
 		}
 
 		/* Re-enable SD Clock */
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -13,6 +13,7 @@
 #ifndef __SDHCI_HW_H
 #define __SDHCI_HW_H
 
+#include <linux/bits.h>
 #include <linux/scatterlist.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
@@ -244,12 +245,9 @@
 #define SDHCI_PRESET_FOR_SDR104        0x6C
 #define SDHCI_PRESET_FOR_DDR50 0x6E
 #define SDHCI_PRESET_FOR_HS400 0x74 /* Non-standard */
-#define SDHCI_PRESET_DRV_MASK  0xC000
-#define SDHCI_PRESET_DRV_SHIFT  14
-#define SDHCI_PRESET_CLKGEN_SEL_MASK   0x400
-#define SDHCI_PRESET_CLKGEN_SEL_SHIFT	10
-#define SDHCI_PRESET_SDCLK_FREQ_MASK   0x3FF
-#define SDHCI_PRESET_SDCLK_FREQ_SHIFT	0
+#define SDHCI_PRESET_DRV_MASK		GENMASK(15, 14)
+#define SDHCI_PRESET_CLKGEN_SEL		BIT(10)
+#define SDHCI_PRESET_SDCLK_FREQ_MASK	GENMASK(9, 0)
 
 #define SDHCI_SLOT_INT_STATUS	0xFC
 


