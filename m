Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700FB35CB60;
	Fri,  7 Aug 2026 15:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117054; cv=none; b=iMEf5wJT9yQUdsibX4hM75LyL/Zy7rxfqHh1Wt3w2tlP1rjgcdTl7GocCFfUkjYXcv2h10QRqQIb0LXy55MalLYprP13briPVE5+QT8015ZTiMweo4Ks3UIMjl4DfXSMVWzNvogiaC765acCmUPovTaaQEg5fo5TVpp6x/zySa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117054; c=relaxed/simple;
	bh=HFcsCFfg852v69cIMsl23vZVYyCN+Y2kw4ZGtErby5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D99O1FxuafRak2VtPR8EISxOBUcG9tQ/dw5ztzhhryuZnD4CpxS8P0U8A96nr+gQtolkGCbZQJn83Pn8BmWhJWriUfDf2bS2QXB9PdJ4BEyvi4hkXySU2XbXkYNjPXqckXWp5oiknS6KmEYWla/a2V5gF0PXqn2idWS3v9whvJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cK6EWwd9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cK6EWwd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAECD1F000E9;
	Fri,  7 Aug 2026 15:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117053;
	bh=TmrCfICMaebGle+mNVzXQ5TnrlMIF5/ozolMMoDrBik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cK6EWwd9Dpo+jemW7lRaIZiqYEmwnyGs+z6qZFZ3jlWHWBn2ZoMnc6TcLH7PSbguE
	 mmkgsHI4mV7OMvkd7ajvf18sP71SAitxaR58Lo5KFSs8c0cUEL+17pJkkirmfhQ11I
	 7k2AOXT9okDISItgf1Ajm9fx1MHMx15SzZlhyCI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 184/438] spi: spi-nxp-fspi: add per-SoC SDR/DTR clock rate limits for all supported SoCs
Date: Fri,  7 Aug 2026 16:36:20 +0200
Message-ID: <20260807143431.954584148@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 9c19d60fea9f46ed0c3394653ef4941f1a459968 ]

The commit f43579ef3500 ("spi: spi-nxp-fspi: limit the clock rate for
different sample clock source selection") introduced a global 166MHz
cap for DTR mode (RXCLKSRC=3), based on the i.MX8MN datasheet timing
specification (Section 3.9.9, page 65).

After reviewing the FlexSPI timing parameters in the datasheets for all
supported SoCs, the following corrections and additions are needed:

1. SDR mode (RXCLKSRC=0) limits vary per SoC:
   - i.MX8MN/MM/MP/95: 66MHz  (IMX8MNCEC §3.9.9, IMX8MMCEC §3.9.10,
                                IMX8MPCEC, IMX95CEC Rev.8 §4.11.7)
   - i.MX8QXP/QM/DXL/ULP: 60MHz (IMX8QXPCEC, IMX8QMCEC, IMX8DXLCEC,
                                   IMX8ULPCEC §7.3.1 ND mode)
   - LX2160A: 100MHz            (LX2160ACEC FlexSPI timing parameters)

2. DTR mode (RXCLKSRC=3) limits vary per SoC:
   - i.MX8MN/MM/MP/ULP: 166MHz
   - i.MX8QXP/QM/DXL: 200MHz   (same FlexSPI IP across this family)
   - i.MX95: 200MHz             (IMX95CEC §4.11.7.3.2.3 Table 106)
   - LX2160A: DTR disabled      (FSPI_QUIRK_DISABLE_DTR)

Update related platform data with correct speed limation according
to datasheet.

Fixes: f43579ef3500 ("spi: spi-nxp-fspi: limit the clock rate for different sample clock source selection")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20260728-fspi-clock-v2-1-dbe786a4a6eb@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 83 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index 1e36ae084dd86..39c1eaaf9e0ae 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -340,6 +340,18 @@ struct nxp_fspi_devtype_data {
 	unsigned int quirks;
 	unsigned int lut_num;
 	bool little_endian;
+	/*
+	 * The max clock rate (Hz) that FlexSPI can output to the device
+	 * in SDR mode (RXCLKSRC=0). Defaults to 66MHz if zero.
+	 * Some SoCs (e.g. LX2160A) support up to 100MHz in SDR mode.
+	 */
+	unsigned long max_sdr_rate;
+	/*
+	 * The max clock rate (Hz) that FlexSPI can output to the device
+	 * in DTR mode (RXCLKSRC=3). Defaults to 166MHz if zero.
+	 * Some SoCs (e.g. i.MX95, i.MX8QM, i.MX8DXL) support up to 200MHz.
+	 */
+	unsigned long max_dtr_rate;
 };
 
 static struct nxp_fspi_devtype_data lx2160a_data = {
@@ -349,6 +361,10 @@ static struct nxp_fspi_devtype_data lx2160a_data = {
 	.quirks = FSPI_QUIRK_DISABLE_DTR,
 	.lut_num = 32,
 	.little_endian = true,  /* little-endian    */
+	/*
+	 * LX2160ACEC: SDR RXCLKSRC=0 max 100MHz, DTR disabled via quirk.
+	 */
+	.max_sdr_rate = 100000000,
 };
 
 static struct nxp_fspi_devtype_data imx8mm_data = {
@@ -358,6 +374,21 @@ static struct nxp_fspi_devtype_data imx8mm_data = {
 	.quirks = 0,
 	.lut_num = 32,
 	.little_endian = true,  /* little-endian    */
+	/* IMX8MMCEC §3.9.10: SDR RXCLKSRC=0 max 66MHz, DDR RXCLKSRC=3 max 166MHz */
+	.max_sdr_rate = 66000000,
+	.max_dtr_rate = 166000000,
+};
+
+static struct nxp_fspi_devtype_data imx8mp_data = {
+	.rxfifo = SZ_512,       /* (64  * 64 bits)  */
+	.txfifo = SZ_1K,        /* (128 * 64 bits)  */
+	.ahb_buf_size = SZ_2K,  /* (256 * 64 bits)  */
+	.quirks = 0,
+	.lut_num = 32,
+	.little_endian = true,  /* little-endian    */
+	/* IMX8MPCEC: SDR RXCLKSRC=0 max 66MHz, DDR RXCLKSRC=3 max 166MHz */
+	.max_sdr_rate = 66000000,
+	.max_dtr_rate = 166000000,
 };
 
 static struct nxp_fspi_devtype_data imx8qxp_data = {
@@ -367,6 +398,12 @@ static struct nxp_fspi_devtype_data imx8qxp_data = {
 	.quirks = 0,
 	.lut_num = 32,
 	.little_endian = true,  /* little-endian    */
+	/*
+	 * IMX8QXPCEC: SDR RXCLKSRC=0 max 60MHz, DDR RXCLKSRC=3 max 200MHz.
+	 * i.MX8QM and i.MX8DXL share the same FlexSPI IP and limits.
+	 */
+	.max_sdr_rate = 60000000,
+	.max_dtr_rate = 200000000,
 };
 
 static struct nxp_fspi_devtype_data imx8dxl_data = {
@@ -376,6 +413,12 @@ static struct nxp_fspi_devtype_data imx8dxl_data = {
 	.quirks = FSPI_QUIRK_USE_IP_ONLY,
 	.lut_num = 32,
 	.little_endian = true,  /* little-endian    */
+	/*
+	 * IMX8DXLCEC (i.MX 8XLite): SDR RXCLKSRC=0 max 60MHz,
+	 * DDR RXCLKSRC=3 max 200MHz.
+	 */
+	.max_sdr_rate = 60000000,
+	.max_dtr_rate = 200000000,
 };
 
 static struct nxp_fspi_devtype_data imx8ulp_data = {
@@ -385,6 +428,29 @@ static struct nxp_fspi_devtype_data imx8ulp_data = {
 	.quirks = 0,
 	.lut_num = 16,
 	.little_endian = true,  /* little-endian    */
+	/*
+	 * IMX8ULPCEC §7.3.1, Normal Drive (ND, 1.0V) mode:
+	 * SDR RXCLKSRC=0 max 60MHz, DDR RXCLKSRC=3 max 166MHz.
+	 * Note: Overdrive (OD, 1.05V) allows up to 180MHz DTR
+	 * but is not the default use case.
+	 */
+	.max_sdr_rate = 60000000,
+	.max_dtr_rate = 166000000,
+};
+
+static struct nxp_fspi_devtype_data imx95_data = {
+	.rxfifo = SZ_512,       /* (64  * 64 bits)  */
+	.txfifo = SZ_1K,        /* (128 * 64 bits)  */
+	.ahb_buf_size = SZ_2K,  /* (256 * 64 bits)  */
+	.quirks = 0,
+	.lut_num = 32,
+	.little_endian = true,  /* little-endian    */
+	/*
+	 * IMX95CEC Rev.8 §4.11.7: SDR RXCLKSRC=0 max 66MHz,
+	 * DDR RXCLKSRC=3 max 200MHz (Nominal/Overdrive mode).
+	 */
+	.max_sdr_rate = 66000000,
+	.max_dtr_rate = 200000000,
 };
 
 struct nxp_fspi {
@@ -691,10 +757,20 @@ static void nxp_fspi_select_rx_sample_clk_source(struct nxp_fspi *f,
 	reg = fspi_readl(f, f->iobase + FSPI_MCR0);
 	if (op_is_dtr) {
 		reg |= FSPI_MCR0_RXCLKSRC(3);
-		f->max_rate = 166000000;
+		/*
+		 * Use the SoC-specific DTR max rate if provided, otherwise
+		 * fall back to 166MHz (limit from IMX8MN datasheet §3.9.9).
+		 */
+		f->max_rate = f->devtype_data->max_dtr_rate ?
+			      f->devtype_data->max_dtr_rate : 166000000;
 	} else {	/*select mode 0 */
 		reg &= ~FSPI_MCR0_RXCLKSRC(3);
-		f->max_rate = 66000000;
+		/*
+		 * Use the SoC-specific SDR max rate if provided, otherwise
+		 * fall back to 66MHz (limit from IMX8MN datasheet §3.9.9).
+		 */
+		f->max_rate = f->devtype_data->max_sdr_rate ?
+			      f->devtype_data->max_sdr_rate : 66000000;
 	}
 	fspi_writel(f, reg, f->iobase + FSPI_MCR0);
 }
@@ -1444,10 +1520,11 @@ static const struct dev_pm_ops nxp_fspi_pm_ops = {
 static const struct of_device_id nxp_fspi_dt_ids[] = {
 	{ .compatible = "nxp,lx2160a-fspi", .data = (void *)&lx2160a_data, },
 	{ .compatible = "nxp,imx8mm-fspi", .data = (void *)&imx8mm_data, },
-	{ .compatible = "nxp,imx8mp-fspi", .data = (void *)&imx8mm_data, },
+	{ .compatible = "nxp,imx8mp-fspi", .data = (void *)&imx8mp_data, },
 	{ .compatible = "nxp,imx8qxp-fspi", .data = (void *)&imx8qxp_data, },
 	{ .compatible = "nxp,imx8dxl-fspi", .data = (void *)&imx8dxl_data, },
 	{ .compatible = "nxp,imx8ulp-fspi", .data = (void *)&imx8ulp_data, },
+	{ .compatible = "nxp,imx95-fspi",   .data = (void *)&imx95_data, },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, nxp_fspi_dt_ids);
-- 
2.53.0



