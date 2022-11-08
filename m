Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5D415CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CC2C433D6;
	Tue,  8 Nov 2022 14:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916749;
	bh=Hk6GmLMI0febJCKgteQEeY4plFUS4Pd7MPf3ifWYoAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYkhF15oMnoIroVG3jSPNXzXdIai81kjm3ME6KBAHMzT8UJ1BCpGQm4RgLVGe/Qgd
	 j+S4PSsrd81/UtlI1CrRxgrbQjRZi6urzpAIOtliJD2dQPYgLE+CW5nkbpFo1Qu9aI
	 wSfhs20+vvMdEDn4Xnm+hYLNMab2fekt59NmHasw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Marek Vasut <marex@denx.de>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 092/197] clk: rs9: Fix I2C accessors
Date: Tue,  8 Nov 2022 14:38:50 +0100
Message-Id: <20221108133359.019552074@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit 2ff4ba9e37024735f5cefc5ea2a73fc66addfe0e ]

Add custom I2C accessors to this driver, since the regular I2C regmap ones
do not generate the exact I2C transfers required by the chip. On I2C write,
it is mandatory to send transfer length first, on read the chip returns the
transfer length in first byte. Instead of always reading back 8 bytes, which
is the default and also the size of the entire register file, set BCP register
to 1 to read out 1 byte which is less wasteful.

Fixes: 892e0ddea1aa ("clk: rs9: Add Renesas 9-series PCIe clock generator driver")
Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20220929195521.284497-1-marex@denx.de
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-renesas-pcie.c | 65 ++++++++++++++++++++++++++++++++--
 1 file changed, 62 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk-renesas-pcie.c b/drivers/clk/clk-renesas-pcie.c
index 4f5df1fc74b4..e6247141d0c0 100644
--- a/drivers/clk/clk-renesas-pcie.c
+++ b/drivers/clk/clk-renesas-pcie.c
@@ -90,13 +90,66 @@ static const struct regmap_access_table rs9_writeable_table = {
 	.n_yes_ranges = ARRAY_SIZE(rs9_writeable_ranges),
 };
 
+static int rs9_regmap_i2c_write(void *context,
+				unsigned int reg, unsigned int val)
+{
+	struct i2c_client *i2c = context;
+	const u8 data[3] = { reg, 1, val };
+	const int count = ARRAY_SIZE(data);
+	int ret;
+
+	ret = i2c_master_send(i2c, data, count);
+	if (ret == count)
+		return 0;
+	else if (ret < 0)
+		return ret;
+	else
+		return -EIO;
+}
+
+static int rs9_regmap_i2c_read(void *context,
+			       unsigned int reg, unsigned int *val)
+{
+	struct i2c_client *i2c = context;
+	struct i2c_msg xfer[2];
+	u8 txdata = reg;
+	u8 rxdata[2];
+	int ret;
+
+	xfer[0].addr = i2c->addr;
+	xfer[0].flags = 0;
+	xfer[0].len = 1;
+	xfer[0].buf = (void *)&txdata;
+
+	xfer[1].addr = i2c->addr;
+	xfer[1].flags = I2C_M_RD;
+	xfer[1].len = 2;
+	xfer[1].buf = (void *)rxdata;
+
+	ret = i2c_transfer(i2c->adapter, xfer, 2);
+	if (ret < 0)
+		return ret;
+	if (ret != 2)
+		return -EIO;
+
+	/*
+	 * Byte 0 is transfer length, which is always 1 due
+	 * to BCP register programming to 1 in rs9_probe(),
+	 * ignore it and use data from Byte 1.
+	 */
+	*val = rxdata[1];
+	return 0;
+}
+
 static const struct regmap_config rs9_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
-	.cache_type = REGCACHE_FLAT,
-	.max_register = 0x8,
+	.cache_type = REGCACHE_NONE,
+	.max_register = RS9_REG_BCP,
 	.rd_table = &rs9_readable_table,
 	.wr_table = &rs9_writeable_table,
+	.reg_write = rs9_regmap_i2c_write,
+	.reg_read = rs9_regmap_i2c_read,
 };
 
 static int rs9_get_output_config(struct rs9_driver_data *rs9, int idx)
@@ -242,11 +295,17 @@ static int rs9_probe(struct i2c_client *client)
 			return ret;
 	}
 
-	rs9->regmap = devm_regmap_init_i2c(client, &rs9_regmap_config);
+	rs9->regmap = devm_regmap_init(&client->dev, NULL,
+				       client, &rs9_regmap_config);
 	if (IS_ERR(rs9->regmap))
 		return dev_err_probe(&client->dev, PTR_ERR(rs9->regmap),
 				     "Failed to allocate register map\n");
 
+	/* Always read back 1 Byte via I2C */
+	ret = regmap_write(rs9->regmap, RS9_REG_BCP, 1);
+	if (ret < 0)
+		return ret;
+
 	/* Register clock */
 	for (i = 0; i < rs9->chip_info->num_clks; i++) {
 		snprintf(name, 5, "DIF%d", i);
-- 
2.35.1



