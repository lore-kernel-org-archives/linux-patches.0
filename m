Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3EE1F94B
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D212BC433C7;
	Fri, 21 Jul 2023 18:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965973;
	bh=Zzo5s1DtmZHbxvr46nB1pAS3A2hZO+KEbeElB69G4WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayKsjWf5eeQ+/wGkHfHfs7t1PcP1c2arQ463h8cvsq+6B4taZxdqCRdckmzkQ42G8
	 1betNVoUWknG4tFAYfFqL9hkQx8t8oQW9pHZoZ0IaVO/B4E86Zw3Gbawh/Ec+EQgSU
	 NXCtPkt9aj2ROdCBUdlCm7S/2c2JhUrAbeZioVW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/532] hwmon: (pmbus/adm1275) Fix problems with temperature monitoring on ADM1272
Date: Fri, 21 Jul 2023 18:01:06 +0200
Message-ID: <20230721160623.193945730@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit b153a0bb4199566abd337119207f82b59a8cd1ca ]

The PMON_CONFIG register on ADM1272 is a 16 bit register. Writing a 8 bit
value into it clears the upper 8 bits of the register, resulting in
unexpected side effects. Fix by writing the 16 bit register value.

Also, it has been reported that temperature readings are sometimes widely
inaccurate, to the point where readings may result in device shutdown due
to errant overtemperature faults. Improve by enabling temperature sampling.

While at it, move the common code for ADM1272 and ADM1278 into a separate
function, and clarify in the error message that an attempt was made to
enable both VOUT and temperature monitoring.

Last but not least, return the error code reported by the underlying I2C
controller and not -ENODEV if updating the PMON_CONFIG register fails.
After all, this does not indicate that the chip is not present, but an
error in the communication with the chip.

Fixes: 4ff0ce227a1e ("hwmon: (pmbus/adm1275) Add support for ADM1272")
Fixes: 9da9c2dc57b2 ("hwmon: (adm1275) enable adm1272 temperature reporting")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230602213447.3557346-1-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/adm1275.c | 52 +++++++++++++++++------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/hwmon/pmbus/adm1275.c b/drivers/hwmon/pmbus/adm1275.c
index 3b07bfb43e937..b8543c06d022a 100644
--- a/drivers/hwmon/pmbus/adm1275.c
+++ b/drivers/hwmon/pmbus/adm1275.c
@@ -37,10 +37,13 @@ enum chips { adm1075, adm1272, adm1275, adm1276, adm1278, adm1293, adm1294 };
 
 #define ADM1272_IRANGE			BIT(0)
 
+#define ADM1278_TSFILT			BIT(15)
 #define ADM1278_TEMP1_EN		BIT(3)
 #define ADM1278_VIN_EN			BIT(2)
 #define ADM1278_VOUT_EN			BIT(1)
 
+#define ADM1278_PMON_DEFCONFIG		(ADM1278_VOUT_EN | ADM1278_TEMP1_EN | ADM1278_TSFILT)
+
 #define ADM1293_IRANGE_25		0
 #define ADM1293_IRANGE_50		BIT(6)
 #define ADM1293_IRANGE_100		BIT(7)
@@ -462,6 +465,22 @@ static const struct i2c_device_id adm1275_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, adm1275_id);
 
+/* Enable VOUT & TEMP1 if not enabled (disabled by default) */
+static int adm1275_enable_vout_temp(struct i2c_client *client, int config)
+{
+	int ret;
+
+	if ((config & ADM1278_PMON_DEFCONFIG) != ADM1278_PMON_DEFCONFIG) {
+		config |= ADM1278_PMON_DEFCONFIG;
+		ret = i2c_smbus_write_word_data(client, ADM1275_PMON_CONFIG, config);
+		if (ret < 0) {
+			dev_err(&client->dev, "Failed to enable VOUT/TEMP1 monitoring\n");
+			return ret;
+		}
+	}
+	return 0;
+}
+
 static int adm1275_probe(struct i2c_client *client)
 {
 	s32 (*config_read_fn)(const struct i2c_client *client, u8 reg);
@@ -615,19 +634,10 @@ static int adm1275_probe(struct i2c_client *client)
 			PMBUS_HAVE_VOUT | PMBUS_HAVE_STATUS_VOUT |
 			PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP;
 
-		/* Enable VOUT & TEMP1 if not enabled (disabled by default) */
-		if ((config & (ADM1278_VOUT_EN | ADM1278_TEMP1_EN)) !=
-		    (ADM1278_VOUT_EN | ADM1278_TEMP1_EN)) {
-			config |= ADM1278_VOUT_EN | ADM1278_TEMP1_EN;
-			ret = i2c_smbus_write_byte_data(client,
-							ADM1275_PMON_CONFIG,
-							config);
-			if (ret < 0) {
-				dev_err(&client->dev,
-					"Failed to enable VOUT monitoring\n");
-				return -ENODEV;
-			}
-		}
+		ret = adm1275_enable_vout_temp(client, config);
+		if (ret)
+			return ret;
+
 		if (config & ADM1278_VIN_EN)
 			info->func[0] |= PMBUS_HAVE_VIN;
 		break;
@@ -684,19 +694,9 @@ static int adm1275_probe(struct i2c_client *client)
 			PMBUS_HAVE_VOUT | PMBUS_HAVE_STATUS_VOUT |
 			PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP;
 
-		/* Enable VOUT & TEMP1 if not enabled (disabled by default) */
-		if ((config & (ADM1278_VOUT_EN | ADM1278_TEMP1_EN)) !=
-		    (ADM1278_VOUT_EN | ADM1278_TEMP1_EN)) {
-			config |= ADM1278_VOUT_EN | ADM1278_TEMP1_EN;
-			ret = i2c_smbus_write_word_data(client,
-							ADM1275_PMON_CONFIG,
-							config);
-			if (ret < 0) {
-				dev_err(&client->dev,
-					"Failed to enable VOUT monitoring\n");
-				return -ENODEV;
-			}
-		}
+		ret = adm1275_enable_vout_temp(client, config);
+		if (ret)
+			return ret;
 
 		if (config & ADM1278_VIN_EN)
 			info->func[0] |= PMBUS_HAVE_VIN;
-- 
2.39.2



