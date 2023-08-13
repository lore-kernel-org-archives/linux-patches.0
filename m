Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5948B9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0147C433C7;
	Sun, 13 Aug 2023 21:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963115;
	bh=dN1ZRX4Ii9gxt+8Mw5PGBLZVgMHtWNYpF8xufNmBevM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z00lIIhbRUoTMXF0EzNyY6bARTg6XJutd/ybr/ZirVCPUm/+7451BHNSjbHI6Kpiw
	 xNzocpKumk7n19C6unBYClMlbjIvFG/VLvFfCvmaJdoWvaLeb7I5Ta6rqXqjO82vYW
	 M1lUl9nvUA87xuuN4zLJMCzdVtzOUF3NbIz2Ik14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 22/89] iio: adc: ina2xx: avoid NULL pointer dereference on OF device match
Date: Sun, 13 Aug 2023 23:19:13 +0200
Message-ID: <20230813211711.424238413@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alvin Šipraga <alsi@bang-olufsen.dk>

commit a41e19cc0d6b6a445a4133170b90271e4a2553dc upstream.

The affected lines were resulting in a NULL pointer dereference on our
platform because the device tree contained the following list of
compatible strings:

    power-sensor@40 {
        compatible = "ti,ina232", "ti,ina231";
        ...
    };

Since the driver doesn't declare a compatible string "ti,ina232", the OF
matching succeeds on "ti,ina231". But the I2C device ID info is
populated via the first compatible string, cf. modalias population in
of_i2c_get_board_info(). Since there is no "ina232" entry in the legacy
I2C device ID table either, the struct i2c_device_id *id pointer in the
probe function is NULL.

Fix this by using the already populated type variable instead, which
points to the proper driver data. Since the name is also wanted, add a
generic one to the ina2xx_config table.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Fixes: c43a102e67db ("iio: ina2xx: add support for TI INA2xx Power Monitors")
Link: https://lore.kernel.org/r/20230619141239.2257392-1-alvin@pqrs.dk
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ina2xx-adc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/ina2xx-adc.c
+++ b/drivers/iio/adc/ina2xx-adc.c
@@ -124,6 +124,7 @@ static const struct regmap_config ina2xx
 enum ina2xx_ids { ina219, ina226 };
 
 struct ina2xx_config {
+	const char *name;
 	u16 config_default;
 	int calibration_value;
 	int shunt_voltage_lsb;	/* nV */
@@ -155,6 +156,7 @@ struct ina2xx_chip_info {
 
 static const struct ina2xx_config ina2xx_config[] = {
 	[ina219] = {
+		.name = "ina219",
 		.config_default = INA219_CONFIG_DEFAULT,
 		.calibration_value = 4096,
 		.shunt_voltage_lsb = 10000,
@@ -164,6 +166,7 @@ static const struct ina2xx_config ina2xx
 		.chip_id = ina219,
 	},
 	[ina226] = {
+		.name = "ina226",
 		.config_default = INA226_CONFIG_DEFAULT,
 		.calibration_value = 2048,
 		.shunt_voltage_lsb = 2500,
@@ -999,7 +1002,7 @@ static int ina2xx_probe(struct i2c_clien
 	/* Patch the current config register with default. */
 	val = chip->config->config_default;
 
-	if (id->driver_data == ina226) {
+	if (type == ina226) {
 		ina226_set_average(chip, INA226_DEFAULT_AVG, &val);
 		ina226_set_int_time_vbus(chip, INA226_DEFAULT_IT, &val);
 		ina226_set_int_time_vshunt(chip, INA226_DEFAULT_IT, &val);
@@ -1018,7 +1021,7 @@ static int ina2xx_probe(struct i2c_clien
 	}
 
 	indio_dev->modes = INDIO_DIRECT_MODE;
-	if (id->driver_data == ina226) {
+	if (type == ina226) {
 		indio_dev->channels = ina226_channels;
 		indio_dev->num_channels = ARRAY_SIZE(ina226_channels);
 		indio_dev->info = &ina226_info;
@@ -1027,7 +1030,7 @@ static int ina2xx_probe(struct i2c_clien
 		indio_dev->num_channels = ARRAY_SIZE(ina219_channels);
 		indio_dev->info = &ina219_info;
 	}
-	indio_dev->name = id->name;
+	indio_dev->name = id ? id->name : chip->config->name;
 
 	ret = devm_iio_kfifo_buffer_setup(&client->dev, indio_dev,
 					  INDIO_BUFFER_SOFTWARE,


