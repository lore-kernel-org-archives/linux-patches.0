Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C90D27A131;
	Tue, 27 May 2025 17:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368037; cv=none; b=VNKhHqy6zVMoKjaWSyuF0l+o1jpMj99hnCktgdU/3tO6jEGYDjn+4aWiid9Trk0/lydzZemcJhqPZIdUnrh7JTGytdckfzguHOLyMYvmor6b1AMwPyFZUD+PGFdxmeXaETTV7Fupvg4FaD2YgG3LCsXCcqv0Q1wa+M6CY9I3pkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368037; c=relaxed/simple;
	bh=VtEhrLY2bZUyi+CyphBmIm8LR++G9puzyz1JQJAdUMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPUz8QgEWY4bkUPaLTmWXepV5HwUC/pypMg2OKcus7ezCy70jTuWl5t2Sga0x4RvZAu2KXkmz6eqKD0lkuUZbeCg6ZRhPjnm5f25CuHY8OWf5JEoFtB3erWG/DRNexYuAgoto++83L7SoJ9CHEm7RwOhMpe7RsQgIrox9LvRgAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YS5kKC+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YS5kKC+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D732BC4CEE9;
	Tue, 27 May 2025 17:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368037;
	bh=VtEhrLY2bZUyi+CyphBmIm8LR++G9puzyz1JQJAdUMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YS5kKC+JKAS8EsHvvE25zr92TvD/zvCM8LajQD2EBWPIDJrHcf+37lDqy9ZjNMeqA
	 e1RV2VSGB19dwbsF2ZXTM6SrRF97Qhf2W8V2OVFOr96cngrrtosDsIPBET3nSsplz4
	 /nvciQTYq08E6LLIpxdiCMgBIRX1Y77fbUWV0nmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Angelo Dureghello <adureghello@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 548/783] iio: dac: adi-axi-dac: add bus mode setup
Date: Tue, 27 May 2025 18:25:45 +0200
Message-ID: <20250527162535.472569526@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Angelo Dureghello <adureghello@baylibre.com>

[ Upstream commit 8ab67b37b81dfaa00a25e95a5f5a020f374848bb ]

The ad354xr requires DSPI mode (2 data lanes) to work in buffering
mode, so, depending on the DAC type, target TRANSFER_REGISTER
"MULTI_IO_MODE" bitfield can be set between:
    SPI  (configuration, entire ad35xxr family),
    DSPI (ad354xr),
    QSPI (ad355xr).
Also bus IO_MODE must be set accordingly.

About removal of AXI_DAC_CUSTOM_CTRL_SYNCED_TRANSFER, according to
the HDL history the flag has never been used. So looks like the driver
was including it by mistake or in anticipation for something that was
never implemented on HDL side.

Current HDL updated documentation confirm it is actually not in use
anymore and replaced by the IO_MODE bits.

Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Signed-off-by: Angelo Dureghello <adureghello@baylibre.com>
Link: https://patch.msgid.link/20250114-wip-bl-ad3552r-axi-v0-iio-testing-carlos-v4-4-979402e33545@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad3552r-hs.h  |  8 ++++++++
 drivers/iio/dac/adi-axi-dac.c | 22 +++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad3552r-hs.h b/drivers/iio/dac/ad3552r-hs.h
index 724261d38dea3..4a9e352341244 100644
--- a/drivers/iio/dac/ad3552r-hs.h
+++ b/drivers/iio/dac/ad3552r-hs.h
@@ -8,11 +8,19 @@
 
 struct iio_backend;
 
+enum ad3552r_io_mode {
+	AD3552R_IO_MODE_SPI,
+	AD3552R_IO_MODE_DSPI,
+	AD3552R_IO_MODE_QSPI,
+};
+
 struct ad3552r_hs_platform_data {
 	int (*bus_reg_read)(struct iio_backend *back, u32 reg, u32 *val,
 			    size_t data_size);
 	int (*bus_reg_write)(struct iio_backend *back, u32 reg, u32 val,
 			     size_t data_size);
+	int (*bus_set_io_mode)(struct iio_backend *back,
+			       enum ad3552r_io_mode mode);
 	u32 bus_sample_data_clock_hz;
 };
 
diff --git a/drivers/iio/dac/adi-axi-dac.c b/drivers/iio/dac/adi-axi-dac.c
index ac871deb8063c..bcaf365feef42 100644
--- a/drivers/iio/dac/adi-axi-dac.c
+++ b/drivers/iio/dac/adi-axi-dac.c
@@ -64,7 +64,7 @@
 #define   AXI_DAC_UI_STATUS_IF_BUSY		BIT(4)
 #define AXI_DAC_CUSTOM_CTRL_REG			0x008C
 #define   AXI_DAC_CUSTOM_CTRL_ADDRESS		GENMASK(31, 24)
-#define   AXI_DAC_CUSTOM_CTRL_SYNCED_TRANSFER	BIT(2)
+#define   AXI_DAC_CUSTOM_CTRL_MULTI_IO_MODE	GENMASK(3, 2)
 #define   AXI_DAC_CUSTOM_CTRL_STREAM		BIT(1)
 #define   AXI_DAC_CUSTOM_CTRL_TRANSFER_DATA	BIT(0)
 
@@ -722,6 +722,25 @@ static int axi_dac_bus_reg_read(struct iio_backend *back, u32 reg, u32 *val,
 	return regmap_read(st->regmap, AXI_DAC_CUSTOM_RD_REG, val);
 }
 
+static int axi_dac_bus_set_io_mode(struct iio_backend *back,
+				   enum ad3552r_io_mode mode)
+{
+	struct axi_dac_state *st = iio_backend_get_priv(back);
+	int ival, ret;
+
+	guard(mutex)(&st->lock);
+
+	ret = regmap_update_bits(st->regmap, AXI_DAC_CUSTOM_CTRL_REG,
+			AXI_DAC_CUSTOM_CTRL_MULTI_IO_MODE,
+			FIELD_PREP(AXI_DAC_CUSTOM_CTRL_MULTI_IO_MODE, mode));
+	if (ret)
+		return ret;
+
+	return regmap_read_poll_timeout(st->regmap, AXI_DAC_UI_STATUS_REG, ival,
+			FIELD_GET(AXI_DAC_UI_STATUS_IF_BUSY, ival) == 0, 10,
+			100 * KILO);
+}
+
 static void axi_dac_child_remove(void *data)
 {
 	platform_device_unregister(data);
@@ -733,6 +752,7 @@ static int axi_dac_create_platform_device(struct axi_dac_state *st,
 	struct ad3552r_hs_platform_data pdata = {
 		.bus_reg_read = axi_dac_bus_reg_read,
 		.bus_reg_write = axi_dac_bus_reg_write,
+		.bus_set_io_mode = axi_dac_bus_set_io_mode,
 		.bus_sample_data_clock_hz = st->dac_clk_rate,
 	};
 	struct platform_device_info pi = {
-- 
2.39.5



