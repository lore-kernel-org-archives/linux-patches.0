Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CC8200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324A1C433CD;
	Fri, 21 Jul 2023 18:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965941;
	bh=Li6IzjYs3OlBoX2i7n8xUimNZ0sG9kwRPlooSkmT+mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GuNbx/+Vi+wh6D5MxmSuu5y360dUFnJUPb0fmaHFijneeovzI1KUR8w/uK+rZ++SX
	 amCIc/fLyzs4eqfLcEe/ivbPD6wr3i8xWy7mnX0znWjhYFKLu79G7noMNqfeMrzAW2
	 Rr4s6mBA2/uKHrAhy7RR3daIk2w+J8eQBlIc34AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Potin Lai <potin.lai@quantatw.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/532] hwmon: (adm1275) Allow setting sample averaging
Date: Fri, 21 Jul 2023 18:01:05 +0200
Message-ID: <20230721160623.141881035@linuxfoundation.org>
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

From: Potin Lai <potin.lai@quantatw.com>

[ Upstream commit a3cd66d7cbadcc0c29884f25b754fd22699c719c ]

Current driver assume PWR_AVG and VI_AVG as 1 by default, and user needs
to set sample averaging via sysfs manually.

This patch parses the properties "adi,power-sample-average" and
"adi,volt-curr-sample-average" from device tree, and setting sample
averaging during probe. Input value must be one of value in the
list [1, 2, 4, 8, 16, 32, 64, 128].

Signed-off-by: Potin Lai <potin.lai@quantatw.com>
Link: https://lore.kernel.org/r/20220302123817.27025-2-potin.lai@quantatw.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: b153a0bb4199 ("hwmon: (pmbus/adm1275) Fix problems with temperature monitoring on ADM1272")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/adm1275.c | 40 ++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/adm1275.c b/drivers/hwmon/pmbus/adm1275.c
index d311e0557401c..3b07bfb43e937 100644
--- a/drivers/hwmon/pmbus/adm1275.c
+++ b/drivers/hwmon/pmbus/adm1275.c
@@ -475,6 +475,7 @@ static int adm1275_probe(struct i2c_client *client)
 	int vindex = -1, voindex = -1, cindex = -1, pindex = -1;
 	int tindex = -1;
 	u32 shunt;
+	u32 avg;
 
 	if (!i2c_check_functionality(client->adapter,
 				     I2C_FUNC_SMBUS_READ_BYTE_DATA
@@ -687,7 +688,7 @@ static int adm1275_probe(struct i2c_client *client)
 		if ((config & (ADM1278_VOUT_EN | ADM1278_TEMP1_EN)) !=
 		    (ADM1278_VOUT_EN | ADM1278_TEMP1_EN)) {
 			config |= ADM1278_VOUT_EN | ADM1278_TEMP1_EN;
-			ret = i2c_smbus_write_byte_data(client,
+			ret = i2c_smbus_write_word_data(client,
 							ADM1275_PMON_CONFIG,
 							config);
 			if (ret < 0) {
@@ -756,6 +757,43 @@ static int adm1275_probe(struct i2c_client *client)
 		return -ENODEV;
 	}
 
+	if (data->have_power_sampling &&
+	    of_property_read_u32(client->dev.of_node,
+				 "adi,power-sample-average", &avg) == 0) {
+		if (!avg || avg > ADM1275_SAMPLES_AVG_MAX ||
+		    BIT(__fls(avg)) != avg) {
+			dev_err(&client->dev,
+				"Invalid number of power samples");
+			return -EINVAL;
+		}
+		ret = adm1275_write_pmon_config(data, client, true,
+						ilog2(avg));
+		if (ret < 0) {
+			dev_err(&client->dev,
+				"Setting power sample averaging failed with error %d",
+				ret);
+			return ret;
+		}
+	}
+
+	if (of_property_read_u32(client->dev.of_node,
+				"adi,volt-curr-sample-average", &avg) == 0) {
+		if (!avg || avg > ADM1275_SAMPLES_AVG_MAX ||
+		    BIT(__fls(avg)) != avg) {
+			dev_err(&client->dev,
+				"Invalid number of voltage/current samples");
+			return -EINVAL;
+		}
+		ret = adm1275_write_pmon_config(data, client, false,
+						ilog2(avg));
+		if (ret < 0) {
+			dev_err(&client->dev,
+				"Setting voltage and current sample averaging failed with error %d",
+				ret);
+			return ret;
+		}
+	}
+
 	if (voindex < 0)
 		voindex = vindex;
 	if (vindex >= 0) {
-- 
2.39.2



