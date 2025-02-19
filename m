Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D10D1E0E01;
	Wed, 19 Feb 2025 08:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955186; cv=none; b=JKRXS7r/4kSHYYVnlBZ0B/ZZKy37R103QBG5hPeXyoFE9bd8EFRyl+64lK8IBksxw+gsCuYFDiHWqjIGBtIjB8t2KvlbanGEDF1RQ4ja9e6L5ff3PDnZHLvjJueu7e2/DVJtJ1QEcs9S4Hf9dfY3GH1fNwQHUTAdLfCcHe8E9Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955186; c=relaxed/simple;
	bh=8upv19+DPACD3eQxCnHktLcj2d/dPxbNVCuKEmXBZ4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebV/C/waTGcBnzR4TeEJIQ53NAXv6ibqw+FkOR27niYb+IQawgmSWKxobES3XQ5ifEm+GFaNGBk7ju22635ylUIXYlWj4bZuUIhETNZ9oM9Q0Tz/viJBIE8qAnqUzWFjAyC0u/RBcGxZfpgR9fmLLOuintEmrIfPSVT8gm/leJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZrP/BWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZrP/BWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3909C4CED1;
	Wed, 19 Feb 2025 08:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955186;
	bh=8upv19+DPACD3eQxCnHktLcj2d/dPxbNVCuKEmXBZ4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZrP/BWbgYOF+cvMX29NjHfibsBClUsWyy1l/sA5G+9I/BhitQrWWPJ79KdgnWQ3Y
	 IwEAH7qTM+dUUXwRqzFsmdS9DvqlZb4bIqUVK9LJYYewpfLXxJV4XV1SaRPqvC/Vm3
	 mx/6NEr2oGCDJ3P/rcbhBqmQNEUzfMUhlzlvcY8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy-ld Lu <andy-ld.lu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 158/230] mmc: mtk-sd: Fix register settings for hs400(es) mode
Date: Wed, 19 Feb 2025 09:27:55 +0100
Message-ID: <20250219082607.875287234@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy-ld Lu <andy-ld.lu@mediatek.com>

commit 3e68abf2b9cebe76c6cd4b1aca8e95cd671035a3 upstream.

For hs400(es) mode, the 'hs400-ds-delay' is typically configured in the
dts. However, some projects may only define 'mediatek,hs400-ds-dly3',
which can lead to initialization failures in hs400es mode. CMD13 reported
response crc error in the mmc_switch_status() just after switching to
hs400es mode.

[    1.914038][   T82] mmc0: mmc_select_hs400es failed, error -84
[    1.914954][   T82] mmc0: error -84 whilst initialising MMC card

Currently, the hs400_ds_dly3 value is set within the tuning function. This
means that the PAD_DS_DLY3 field is not configured before tuning process,
which is the reason for the above-mentioned CMD13 response crc error.

Move the PAD_DS_DLY3 field configuration into msdc_prepare_hs400_tuning(),
and add a value check of hs400_ds_delay to prevent overwriting by zero when
the 'hs400-ds-delay' is not set in the dts. In addition, since hs400(es)
only tune the PAD_DS_DLY1, the PAD_DS_DLY2_SEL bit should be cleared to
bypass it.

Fixes: c4ac38c6539b ("mmc: mtk-sd: Add HS400 online tuning support")
Signed-off-by: Andy-ld Lu <andy-ld.lu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250123092644.7359-1-andy-ld.lu@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -263,6 +263,7 @@
 #define MSDC_PAD_TUNE_CMD2_SEL	  BIT(21)   /* RW */
 
 #define PAD_DS_TUNE_DLY_SEL       BIT(0)	  /* RW */
+#define PAD_DS_TUNE_DLY2_SEL      BIT(1)	  /* RW */
 #define PAD_DS_TUNE_DLY1	  GENMASK(6, 2)   /* RW */
 #define PAD_DS_TUNE_DLY2	  GENMASK(11, 7)  /* RW */
 #define PAD_DS_TUNE_DLY3	  GENMASK(16, 12) /* RW */
@@ -308,6 +309,7 @@
 
 /* EMMC50_PAD_DS_TUNE mask */
 #define PAD_DS_DLY_SEL		BIT(16)	/* RW */
+#define PAD_DS_DLY2_SEL		BIT(15)	/* RW */
 #define PAD_DS_DLY1		GENMASK(14, 10)	/* RW */
 #define PAD_DS_DLY3		GENMASK(4, 0)	/* RW */
 
@@ -2361,13 +2363,23 @@ tune_done:
 static int msdc_prepare_hs400_tuning(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct msdc_host *host = mmc_priv(mmc);
+
 	host->hs400_mode = true;
 
-	if (host->top_base)
-		writel(host->hs400_ds_delay,
-		       host->top_base + EMMC50_PAD_DS_TUNE);
-	else
-		writel(host->hs400_ds_delay, host->base + PAD_DS_TUNE);
+	if (host->top_base) {
+		if (host->hs400_ds_dly3)
+			sdr_set_field(host->top_base + EMMC50_PAD_DS_TUNE,
+				      PAD_DS_DLY3, host->hs400_ds_dly3);
+		if (host->hs400_ds_delay)
+			writel(host->hs400_ds_delay,
+			       host->top_base + EMMC50_PAD_DS_TUNE);
+	} else {
+		if (host->hs400_ds_dly3)
+			sdr_set_field(host->base + PAD_DS_TUNE,
+				      PAD_DS_TUNE_DLY3, host->hs400_ds_dly3);
+		if (host->hs400_ds_delay)
+			writel(host->hs400_ds_delay, host->base + PAD_DS_TUNE);
+	}
 	/* hs400 mode must set it to 0 */
 	sdr_clr_bits(host->base + MSDC_PATCH_BIT2, MSDC_PATCH_BIT2_CFGCRCSTS);
 	/* to improve read performance, set outstanding to 2 */
@@ -2387,14 +2399,11 @@ static int msdc_execute_hs400_tuning(str
 	if (host->top_base) {
 		sdr_set_bits(host->top_base + EMMC50_PAD_DS_TUNE,
 			     PAD_DS_DLY_SEL);
-		if (host->hs400_ds_dly3)
-			sdr_set_field(host->top_base + EMMC50_PAD_DS_TUNE,
-				      PAD_DS_DLY3, host->hs400_ds_dly3);
+		sdr_clr_bits(host->top_base + EMMC50_PAD_DS_TUNE,
+			     PAD_DS_DLY2_SEL);
 	} else {
 		sdr_set_bits(host->base + PAD_DS_TUNE, PAD_DS_TUNE_DLY_SEL);
-		if (host->hs400_ds_dly3)
-			sdr_set_field(host->base + PAD_DS_TUNE,
-				      PAD_DS_TUNE_DLY3, host->hs400_ds_dly3);
+		sdr_clr_bits(host->base + PAD_DS_TUNE, PAD_DS_TUNE_DLY2_SEL);
 	}
 
 	host->hs400_tuning = true;


