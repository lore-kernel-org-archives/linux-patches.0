Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E58E1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEBEC433C8;
	Tue, 25 Jul 2023 11:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283905;
	bh=hbXHeikHAZuWwcy9W4FnXgjAc3elHs3kI4luG/yUvBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3YKteuSxldVIBcL/oqUJQBOcUAgDzGjnYthGwp/CKdGgDyuM63OoDQAkbsLx3Z0J
	 0aMSLH3/xJ+QPS5QU6RWWrME3B37/NGKjHPLeJfh9nM8YGzEPDOwg4bRqy6icYKwug
	 kLXeyF89AES6i2yB8N66i4+QMPj4DiffZhs5gbyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/509] clk: si5341: Allow different output VDD_SEL values
Date: Tue, 25 Jul 2023 12:41:44 +0200
Message-ID: <20230725104601.282457547@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit b7bbf6ec4940d1a69811ec354edeeb9751fa8e85 ]

The driver was not previously programming the VDD_SEL values for each
output to indicate what external VDDO voltage was used for each. Add
ability to specify a regulator supplying the VDDO pin for each output of
the device. The voltage of the regulator is used to automatically set the
VDD_SEL value appropriately. If no regulator is specified and the chip is
being reconfigured, assume 2.5V which appears to be the chip default.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20210325192643.2190069-7-robert.hancock@calian.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 2560114c06d7 ("clk: si5341: return error if one synth clock registration fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si5341.c | 136 +++++++++++++++++++++++++++++++--------
 1 file changed, 110 insertions(+), 26 deletions(-)

diff --git a/drivers/clk/clk-si5341.c b/drivers/clk/clk-si5341.c
index 382a0619a0488..64d962c54bba5 100644
--- a/drivers/clk/clk-si5341.c
+++ b/drivers/clk/clk-si5341.c
@@ -19,6 +19,7 @@
 #include <linux/i2c.h>
 #include <linux/module.h>
 #include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <asm/unaligned.h>
 
@@ -59,6 +60,7 @@ struct clk_si5341_synth {
 struct clk_si5341_output {
 	struct clk_hw hw;
 	struct clk_si5341 *data;
+	struct regulator *vddo_reg;
 	u8 index;
 };
 #define to_clk_si5341_output(_hw) \
@@ -84,6 +86,7 @@ struct clk_si5341 {
 struct clk_si5341_output_config {
 	u8 out_format_drv_bits;
 	u8 out_cm_ampl_bits;
+	u8 vdd_sel_bits;
 	bool synth_master;
 	bool always_on;
 };
@@ -136,6 +139,8 @@ struct clk_si5341_output_config {
 #define SI5341_OUT_R_REG(output)	\
 			((output)->data->reg_rdiv_offset[(output)->index])
 
+#define SI5341_OUT_MUX_VDD_SEL_MASK 0x38
+
 /* Synthesize N divider */
 #define SI5341_SYNTH_N_NUM(x)	(0x0302 + ((x) * 11))
 #define SI5341_SYNTH_N_DEN(x)	(0x0308 + ((x) * 11))
@@ -1250,11 +1255,11 @@ static const struct regmap_config si5341_regmap_config = {
 	.volatile_table = &si5341_regmap_volatile,
 };
 
-static int si5341_dt_parse_dt(struct i2c_client *client,
-	struct clk_si5341_output_config *config)
+static int si5341_dt_parse_dt(struct clk_si5341 *data,
+			      struct clk_si5341_output_config *config)
 {
 	struct device_node *child;
-	struct device_node *np = client->dev.of_node;
+	struct device_node *np = data->i2c_client->dev.of_node;
 	u32 num;
 	u32 val;
 
@@ -1263,13 +1268,13 @@ static int si5341_dt_parse_dt(struct i2c_client *client,
 
 	for_each_child_of_node(np, child) {
 		if (of_property_read_u32(child, "reg", &num)) {
-			dev_err(&client->dev, "missing reg property of %s\n",
+			dev_err(&data->i2c_client->dev, "missing reg property of %s\n",
 				child->name);
 			goto put_child;
 		}
 
 		if (num >= SI5341_MAX_NUM_OUTPUTS) {
-			dev_err(&client->dev, "invalid clkout %d\n", num);
+			dev_err(&data->i2c_client->dev, "invalid clkout %d\n", num);
 			goto put_child;
 		}
 
@@ -1288,7 +1293,7 @@ static int si5341_dt_parse_dt(struct i2c_client *client,
 				config[num].out_format_drv_bits |= 0xc0;
 				break;
 			default:
-				dev_err(&client->dev,
+				dev_err(&data->i2c_client->dev,
 					"invalid silabs,format %u for %u\n",
 					val, num);
 				goto put_child;
@@ -1301,7 +1306,7 @@ static int si5341_dt_parse_dt(struct i2c_client *client,
 
 		if (!of_property_read_u32(child, "silabs,common-mode", &val)) {
 			if (val > 0xf) {
-				dev_err(&client->dev,
+				dev_err(&data->i2c_client->dev,
 					"invalid silabs,common-mode %u\n",
 					val);
 				goto put_child;
@@ -1312,7 +1317,7 @@ static int si5341_dt_parse_dt(struct i2c_client *client,
 
 		if (!of_property_read_u32(child, "silabs,amplitude", &val)) {
 			if (val > 0xf) {
-				dev_err(&client->dev,
+				dev_err(&data->i2c_client->dev,
 					"invalid silabs,amplitude %u\n",
 					val);
 				goto put_child;
@@ -1329,6 +1334,34 @@ static int si5341_dt_parse_dt(struct i2c_client *client,
 
 		config[num].always_on =
 			of_property_read_bool(child, "always-on");
+
+		config[num].vdd_sel_bits = 0x08;
+		if (data->clk[num].vddo_reg) {
+			int vdd = regulator_get_voltage(data->clk[num].vddo_reg);
+
+			switch (vdd) {
+			case 3300000:
+				config[num].vdd_sel_bits |= 0 << 4;
+				break;
+			case 1800000:
+				config[num].vdd_sel_bits |= 1 << 4;
+				break;
+			case 2500000:
+				config[num].vdd_sel_bits |= 2 << 4;
+				break;
+			default:
+				dev_err(&data->i2c_client->dev,
+					"unsupported vddo voltage %d for %s\n",
+					vdd, child->name);
+				goto put_child;
+			}
+		} else {
+			/* chip seems to default to 2.5V when not set */
+			dev_warn(&data->i2c_client->dev,
+				"no regulator set, defaulting vdd_sel to 2.5V for %s\n",
+				child->name);
+			config[num].vdd_sel_bits |= 2 << 4;
+		}
 	}
 
 	return 0;
@@ -1454,9 +1487,33 @@ static int si5341_probe(struct i2c_client *client,
 		}
 	}
 
-	err = si5341_dt_parse_dt(client, config);
+	for (i = 0; i < SI5341_MAX_NUM_OUTPUTS; ++i) {
+		char reg_name[10];
+
+		snprintf(reg_name, sizeof(reg_name), "vddo%d", i);
+		data->clk[i].vddo_reg = devm_regulator_get_optional(
+			&client->dev, reg_name);
+		if (IS_ERR(data->clk[i].vddo_reg)) {
+			err = PTR_ERR(data->clk[i].vddo_reg);
+			data->clk[i].vddo_reg = NULL;
+			if (err == -ENODEV)
+				continue;
+			goto cleanup;
+		} else {
+			err = regulator_enable(data->clk[i].vddo_reg);
+			if (err) {
+				dev_err(&client->dev,
+					"failed to enable %s regulator: %d\n",
+					reg_name, err);
+				data->clk[i].vddo_reg = NULL;
+				goto cleanup;
+			}
+		}
+	}
+
+	err = si5341_dt_parse_dt(data, config);
 	if (err)
-		return err;
+		goto cleanup;
 
 	if (of_property_read_string(client->dev.of_node, "clock-output-names",
 			&init.name))
@@ -1464,21 +1521,23 @@ static int si5341_probe(struct i2c_client *client,
 	root_clock_name = init.name;
 
 	data->regmap = devm_regmap_init_i2c(client, &si5341_regmap_config);
-	if (IS_ERR(data->regmap))
-		return PTR_ERR(data->regmap);
+	if (IS_ERR(data->regmap)) {
+		err = PTR_ERR(data->regmap);
+		goto cleanup;
+	}
 
 	i2c_set_clientdata(client, data);
 
 	err = si5341_probe_chip_id(data);
 	if (err < 0)
-		return err;
+		goto cleanup;
 
 	if (of_property_read_bool(client->dev.of_node, "silabs,reprogram")) {
 		initialization_required = true;
 	} else {
 		err = si5341_is_programmed_already(data);
 		if (err < 0)
-			return err;
+			goto cleanup;
 
 		initialization_required = !err;
 	}
@@ -1487,11 +1546,11 @@ static int si5341_probe(struct i2c_client *client,
 		/* Populate the regmap cache in preparation for "cache only" */
 		err = si5341_read_settings(data);
 		if (err < 0)
-			return err;
+			goto cleanup;
 
 		err = si5341_send_preamble(data);
 		if (err < 0)
-			return err;
+			goto cleanup;
 
 		/*
 		 * We intend to send all 'final' register values in a single
@@ -1504,19 +1563,19 @@ static int si5341_probe(struct i2c_client *client,
 		err = si5341_write_multiple(data, si5341_reg_defaults,
 					ARRAY_SIZE(si5341_reg_defaults));
 		if (err < 0)
-			return err;
+			goto cleanup;
 	}
 
 	/* Input must be up and running at this point */
 	err = si5341_clk_select_active_input(data);
 	if (err < 0)
-		return err;
+		goto cleanup;
 
 	if (initialization_required) {
 		/* PLL configuration is required */
 		err = si5341_initialize_pll(data);
 		if (err < 0)
-			return err;
+			goto cleanup;
 	}
 
 	/* Register the PLL */
@@ -1529,7 +1588,7 @@ static int si5341_probe(struct i2c_client *client,
 	err = devm_clk_hw_register(&client->dev, &data->hw);
 	if (err) {
 		dev_err(&client->dev, "clock registration failed\n");
-		return err;
+		goto cleanup;
 	}
 
 	init.num_parents = 1;
@@ -1566,13 +1625,17 @@ static int si5341_probe(struct i2c_client *client,
 			regmap_write(data->regmap,
 				SI5341_OUT_CM(&data->clk[i]),
 				config[i].out_cm_ampl_bits);
+			regmap_update_bits(data->regmap,
+				SI5341_OUT_MUX_SEL(&data->clk[i]),
+				SI5341_OUT_MUX_VDD_SEL_MASK,
+				config[i].vdd_sel_bits);
 		}
 		err = devm_clk_hw_register(&client->dev, &data->clk[i].hw);
 		kfree(init.name); /* clock framework made a copy of the name */
 		if (err) {
 			dev_err(&client->dev,
 				"output %u registration failed\n", i);
-			return err;
+			goto cleanup;
 		}
 		if (config[i].always_on)
 			clk_prepare(data->clk[i].hw.clk);
@@ -1582,7 +1645,7 @@ static int si5341_probe(struct i2c_client *client,
 			data);
 	if (err) {
 		dev_err(&client->dev, "unable to add clk provider\n");
-		return err;
+		goto cleanup;
 	}
 
 	if (initialization_required) {
@@ -1590,11 +1653,11 @@ static int si5341_probe(struct i2c_client *client,
 		regcache_cache_only(data->regmap, false);
 		err = regcache_sync(data->regmap);
 		if (err < 0)
-			return err;
+			goto cleanup;
 
 		err = si5341_finalize_defaults(data);
 		if (err < 0)
-			return err;
+			goto cleanup;
 	}
 
 	/* wait for device to report input clock present and PLL lock */
@@ -1603,14 +1666,14 @@ static int si5341_probe(struct i2c_client *client,
 	       10000, 250000);
 	if (err) {
 		dev_err(&client->dev, "Error waiting for input clock or PLL lock\n");
-		return err;
+		goto cleanup;
 	}
 
 	/* clear sticky alarm bits from initialization */
 	err = regmap_write(data->regmap, SI5341_STATUS_STICKY, 0);
 	if (err) {
 		dev_err(&client->dev, "unable to clear sticky status\n");
-		return err;
+		goto cleanup;
 	}
 
 	/* Free the names, clk framework makes copies */
@@ -1618,6 +1681,26 @@ static int si5341_probe(struct i2c_client *client,
 		 devm_kfree(&client->dev, (void *)synth_clock_names[i]);
 
 	return 0;
+
+cleanup:
+	for (i = 0; i < SI5341_MAX_NUM_OUTPUTS; ++i) {
+		if (data->clk[i].vddo_reg)
+			regulator_disable(data->clk[i].vddo_reg);
+	}
+	return err;
+}
+
+static int si5341_remove(struct i2c_client *client)
+{
+	struct clk_si5341 *data = i2c_get_clientdata(client);
+	int i;
+
+	for (i = 0; i < SI5341_MAX_NUM_OUTPUTS; ++i) {
+		if (data->clk[i].vddo_reg)
+			regulator_disable(data->clk[i].vddo_reg);
+	}
+
+	return 0;
 }
 
 static const struct i2c_device_id si5341_id[] = {
@@ -1646,6 +1729,7 @@ static struct i2c_driver si5341_driver = {
 		.of_match_table = clk_si5341_of_match,
 	},
 	.probe		= si5341_probe,
+	.remove		= si5341_remove,
 	.id_table	= si5341_id,
 };
 module_i2c_driver(si5341_driver);
-- 
2.39.2



