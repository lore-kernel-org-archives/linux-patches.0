Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FD12949E0;
	Tue, 12 Aug 2025 19:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026337; cv=none; b=VaihqgoiRBKoYt6JsYc9iBnyCWCLCWgIBN5PVgmxKBOzZ8wR7jCrU7bikEqgDacVJDqWv+Z4ALuWDaimPat69dhro9nuGCO2Or+WIBfnz3HMm90DVmhiIz7u5K9jSVgyjLY/17deyM8uBulAyUzrLHVlbTwPa14PzGqvtXd96Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026337; c=relaxed/simple;
	bh=purlM8I7DMfysYx0zX7HW8TtBQygl+gVaQvTsVP0YPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jk47whbBEDAH2/gRgY2TR/UnzglqXlOfR1lhTANq31Lv8nKj5lfEUDn4foan22W96rGOZEhZ7kS6RgLKTNMgnDGQsyixNUXdtAGJsVmCtfmDayCMqXFJAUrkQNFKv7jgG0w7XALjUjccb/XUeMsvEVzvXoMk5/6F+p0P0oBhg/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YyWbX0Tk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyWbX0Tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0033CC4CEF0;
	Tue, 12 Aug 2025 19:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026337;
	bh=purlM8I7DMfysYx0zX7HW8TtBQygl+gVaQvTsVP0YPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YyWbX0TkaAr6JRmjGTmW/UCFgDo1qPqg2gNHN1afnY9EW4ZSi7gzRgq01ht1/dAGH
	 yCSnJWef3RKMDnEqCtw4NTgaMET/jwh2mc2SkzCKsSk454r5TldWtT4R7gbUb1kCIm
	 +/1S+Fa0u0yb86IX11Vx8/CbFYdDSKV3RgrX7TEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 308/480] ASoC: fsl_xcvr: get channel status data with firmware exists
Date: Tue, 12 Aug 2025 19:48:36 +0200
Message-ID: <20250812174410.133107575@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 6776ecc9dd587c08a6bb334542f9f8821a091013 ]

For the XCVR module on i.MX95, even though it only supports SPDIF, the
channel status needs to be obtained from RAM space, which is processed
by firmware. Firmware is necessary to trigger the FSL_XCVR_IRQ_NEW_CS
interrupt.

This change also applies for the SPDIF & ARC function on i.MX8MP which
has the firmware.

Fixes: e6a9750a346b ("ASoC: fsl_xcvr: Add suspend and resume support")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20250710030405.3370671-3-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index 5b1e5f377426..f877dcb2570a 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1395,7 +1395,7 @@ static irqreturn_t irq0_isr(int irq, void *devid)
 	if (isr & FSL_XCVR_IRQ_NEW_CS) {
 		dev_dbg(dev, "Received new CS block\n");
 		isr_clr |= FSL_XCVR_IRQ_NEW_CS;
-		if (!xcvr->soc_data->spdif_only) {
+		if (xcvr->soc_data->fw_name) {
 			/* Data RAM is 4KiB, last two pages: 8 and 9. Select page 8. */
 			regmap_update_bits(xcvr->regmap, FSL_XCVR_EXT_CTRL,
 					   FSL_XCVR_EXT_CTRL_PAGE_MASK,
@@ -1517,6 +1517,7 @@ static const struct fsl_xcvr_soc_data fsl_xcvr_imx93_data = {
 };
 
 static const struct fsl_xcvr_soc_data fsl_xcvr_imx95_data = {
+	.fw_name = "imx/xcvr/xcvr-imx95.bin",
 	.spdif_only = true,
 	.use_phy = true,
 	.use_edma = true,
@@ -1806,7 +1807,7 @@ static int fsl_xcvr_runtime_resume(struct device *dev)
 		}
 	}
 
-	if (xcvr->mode == FSL_XCVR_MODE_EARC) {
+	if (xcvr->soc_data->fw_name) {
 		ret = fsl_xcvr_load_firmware(xcvr);
 		if (ret) {
 			dev_err(dev, "failed to load firmware.\n");
-- 
2.39.5



