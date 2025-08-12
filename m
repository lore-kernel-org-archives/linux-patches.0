Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6556E247287;
	Tue, 12 Aug 2025 18:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024714; cv=none; b=ZvQndTY2/lgNgDMJsAzm9cbIr+OoQGf2w7TYT+Z6xs4ppZtdvCYisUkrJG8F33tZD3zpNhRiExxpK/LEYMWmyksyJSQEGIy2tzjG0MsX62bFvIOEjOC4NOIQL5XoKvRm+zFZueLfZD5y7KgvEivtIZiSSnuGe4PSw4DfEuTFFF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024714; c=relaxed/simple;
	bh=a84R/K6aOkQIkqqObRdl1sSP+uMZIZKL+izzwR1cyMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmnUH/WmLw4PVTbO5tEEbzVq/XwSLwNysW/3ZmdjfUTm4pnpXjgh7sQMqy906EcB/kdnJ/R21nS/rUVmb5X1XcMo8qkw7lKD+jFQky7DpDWZlQwx7RkKDSGdRqr1Sr+Se//ZYvpB3QcWDeKYNOmUUe9zDZGReR1YiCvXSe82ulM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUq7ZNCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUq7ZNCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EFAC4CEF0;
	Tue, 12 Aug 2025 18:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024714;
	bh=a84R/K6aOkQIkqqObRdl1sSP+uMZIZKL+izzwR1cyMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUq7ZNCRFTmQ6OaFMYqbSTTMmsgQNhXalrq1w+LH5IFF0HQ7ssAO+2tpZV0Iu3Ibm
	 APezc5Ixk4QUHbIhU0hlH6vflBSwWncSJrskXoAlfBEZMy2tc1yNXsRy1jh2O8yWPc
	 6mzJ4abapFhq8na0Zt6YWUDuzJpe+KZobnvNFxxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 422/627] ASoC: fsl_xcvr: get channel status data with firmware exists
Date: Tue, 12 Aug 2025 19:31:57 +0200
Message-ID: <20250812173435.328633016@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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
index 405433144515..5d804860f7d8 100644
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



