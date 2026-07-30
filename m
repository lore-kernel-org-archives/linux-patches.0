Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03FB3A6B7F;
	Thu, 30 Jul 2026 14:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421778; cv=none; b=P/LNTA9vxaDoeFOGePexZFmHeP/uvDAQev7dxVwRwyb1CsX1TZG4jZgCMJwIpCroUI3YI3pkwDJBcsVUHrjA4YO53zKk76yAZIWka/jpEnKgH5WGONugPktWLtcanKzsC7S6ZHN7nQJdaSBEvyOrJSQEsPTHJOD53kiMAZ7GguM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421778; c=relaxed/simple;
	bh=ZjwENxVGHZjxG01AlRwwXuvkNw5vexQrXHI8K/8YBiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qsiImug240aU3/1pkw2Geq197+xaaeii9RBwbxY1cqjteBR5Q39bGclbqV5OHOgJ2+a9cJULyheSwYMqCEEe+FxmFgJWYrLxkgC95wXcdilAghFNWhgyAyF4nfb/AFaUqIyAnaZEZm0fE3ZzI7wiYFi6/RtEA351M0vG5h7K5/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrNgmSds; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrNgmSds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380741F00A3A;
	Thu, 30 Jul 2026 14:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421776;
	bh=3JworLF+O95UB3cycEBxp2pwurDkS78kEzqI0ZCge84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YrNgmSds1TDSccbAp+lDMi9/Yls7wdNvTypTz/JXgMc+W0D9DfOxv9q8qdlwqJ04m
	 zHw2LmNkGzGj3M6LHuXrKr0dMyUOxdM+iml0OJcBUzQR5triF2+tseCju+2Ve7nd99
	 VIsFgINR7/lBNKZT39fNegxKGkWIcNaHsZbiw2jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexis Czezar Torreno <alexisczezar.torreno@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 215/744] hwmon: (pmbus/max34440): add support adpm12250
Date: Thu, 30 Jul 2026 16:08:08 +0200
Message-ID: <20260730141448.854062836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Alexis Czezar Torreno <alexisczezar.torreno@analog.com>

[ Upstream commit 479bfeba2eb62666cd4b981c8e721c61dcf36e7d ]

ADPM12250 is a quarter brick DC/DC Power Module. It is a high power
non-isolated converter capable of delivering regulated 12V with
continuous power level of 2500W. Uses PMBus.

Signed-off-by: Alexis Czezar Torreno <alexisczezar.torreno@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20260610-dev-adpm12250-v1-1-422760bb80da@analog.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: af01dab0c39a ("hwmon: (pmbus/max34440) block unsupported VIN and IIN limit registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/max34440.rst | 27 ++++++++++++-------
 drivers/hwmon/pmbus/max34440.c   | 45 +++++++++++++++++++++++++++++---
 2 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/Documentation/hwmon/max34440.rst b/Documentation/hwmon/max34440.rst
index d6d4fbc863d96c..e7421f4dbf38fc 100644
--- a/Documentation/hwmon/max34440.rst
+++ b/Documentation/hwmon/max34440.rst
@@ -19,6 +19,14 @@ Supported chips:
 
     Datasheet: -
 
+  * ADI ADPM12250
+
+    Prefixes: 'adpm12250'
+
+    Addresses scanned: -
+
+    Datasheet: -
+
   * Maxim MAX34440
 
     Prefixes: 'max34440'
@@ -87,11 +95,11 @@ This driver supports multiple devices: hardware monitoring for Maxim MAX34440
 PMBus 6-Channel Power-Supply Manager, MAX34441 PMBus 5-Channel Power-Supply
 Manager and Intelligent Fan Controller, and MAX34446 PMBus Power-Supply Data
 Logger; PMBus Voltage Monitor and Sequencers for MAX34451, MAX34460, and
-MAX34461; PMBus DC/DC Power Module ADPM12160, and ADPM12200. The MAX34451
-supports monitoring voltage or current of 12 channels based on GIN pins. The
-MAX34460 supports 12 voltage channels, and the MAX34461 supports 16 voltage
-channels. The ADPM12160, and ADPM12200 also monitors both input and output
-of voltage and current.
+MAX34461; PMBus DC/DC Power Module ADPM12160, ADPM12200, and ADPM12250. The
+MAX34451 supports monitoring voltage or current of 12 channels based on GIN
+pins. The MAX34460 supports 12 voltage channels, and the MAX34461 supports 16
+voltage channels. The ADPM12160, ADPM12200, and ADPM12250 also monitors both
+input and output of voltage and current.
 
 The driver is a client driver to the core PMBus driver. Please see
 Documentation/hwmon/pmbus.rst for details on PMBus client drivers.
@@ -149,7 +157,7 @@ in[1-6]_reset_history	Write any value to reset history.
 .. note::
 
     - MAX34446 only supports in[1-4].
-    - ADPM12160, and ADPM12200 only supports in[1-2]. Label is "vin1"
+    - ADPM12160, ADPM12200, and ADPM12250 only supports in[1-2]. Label is "vin1"
       and "vout1" respectively.
 
 Curr
@@ -172,8 +180,9 @@ curr[1-6]_reset_history	Write any value to reset history.
 
     - in6 and curr6 attributes only exist for MAX34440.
     - MAX34446 only supports curr[1-4].
-    - For ADPM12160, and ADPM12200, curr[1] is "iin1" and curr[2-6]
-      are "iout[1-5]".
+    - For ADPM12160, ADPM12200, and ADPM12250, curr[1] is "iin1"
+    - For ADPM12160, and ADPM12200 curr[2-6] are "iout[1-5]".
+    - For ADPM12250, curr[2-4] are "iout[1-3]".
 
 Power
 ~~~~~
@@ -209,7 +218,7 @@ temp[1-8]_reset_history	Write any value to reset history.
 .. note::
    - temp7 and temp8 attributes only exist for MAX34440.
    - MAX34446 only supports temp[1-3].
-   - ADPM12160, and ADPM12200 only supports temp[1].
+   - ADPM12160, ADPM12200, and ADPM12250 only supports temp[1].
 
 
 .. note::
diff --git a/drivers/hwmon/pmbus/max34440.c b/drivers/hwmon/pmbus/max34440.c
index 4525b9fc562674..74876d2207fbe4 100644
--- a/drivers/hwmon/pmbus/max34440.c
+++ b/drivers/hwmon/pmbus/max34440.c
@@ -18,6 +18,7 @@
 enum chips {
 	adpm12160,
 	adpm12200,
+	adpm12250,
 	max34440,
 	max34441,
 	max34446,
@@ -97,7 +98,8 @@ static int max34440_read_word_data(struct i2c_client *client, int page,
 		break;
 	case PMBUS_VIRT_READ_IOUT_AVG:
 		if (data->id != max34446 && data->id != max34451 &&
-		    data->id != adpm12160 && data->id != adpm12200)
+		    data->id != adpm12160 && data->id != adpm12200 &&
+		    data->id != adpm12250)
 			return -ENXIO;
 		ret = pmbus_read_word_data(client, page, phase,
 					   MAX34446_MFR_IOUT_AVG);
@@ -182,7 +184,8 @@ static int max34440_write_word_data(struct i2c_client *client, int page,
 		ret = pmbus_write_word_data(client, page,
 					    MAX34440_MFR_IOUT_PEAK, 0);
 		if (!ret && (data->id == max34446 || data->id == max34451 ||
-			     data->id == adpm12160 || data->id == adpm12200))
+			     data->id == adpm12160 || data->id == adpm12200 ||
+			     data->id == adpm12250))
 			ret = pmbus_write_word_data(client, page,
 					MAX34446_MFR_IOUT_AVG, 0);
 
@@ -399,6 +402,40 @@ static struct pmbus_driver_info max34440_info[] = {
 		.read_word_data = max34440_read_word_data,
 		.write_word_data = max34440_write_word_data,
 	},
+	[adpm12250] = {
+		.pages = 19,
+		.format[PSC_VOLTAGE_IN] = direct,
+		.format[PSC_VOLTAGE_OUT] = direct,
+		.format[PSC_CURRENT_IN] = direct,
+		.format[PSC_CURRENT_OUT] = direct,
+		.format[PSC_TEMPERATURE] = direct,
+		.m[PSC_VOLTAGE_IN] = 125,
+		.b[PSC_VOLTAGE_IN] = 0,
+		.R[PSC_VOLTAGE_IN] = 0,
+		.m[PSC_VOLTAGE_OUT] = 125,
+		.b[PSC_VOLTAGE_OUT] = 0,
+		.R[PSC_VOLTAGE_OUT] = 0,
+		.m[PSC_CURRENT_IN] = 250,
+		.b[PSC_CURRENT_IN] = 0,
+		.R[PSC_CURRENT_IN] = -1,
+		.m[PSC_CURRENT_OUT] = 250,
+		.b[PSC_CURRENT_OUT] = 0,
+		.R[PSC_CURRENT_OUT] = -1,
+		.m[PSC_TEMPERATURE] = 1,
+		.b[PSC_TEMPERATURE] = 0,
+		.R[PSC_TEMPERATURE] = 2,
+		/* absent func below [18] are not for monitoring */
+		.func[2] = PMBUS_HAVE_VOUT | PMBUS_HAVE_STATUS_VOUT,
+		.func[4] = PMBUS_HAVE_STATUS_IOUT,
+		.func[5] = PMBUS_HAVE_IOUT | PMBUS_HAVE_STATUS_IOUT,
+		.func[6] = PMBUS_HAVE_IOUT | PMBUS_HAVE_STATUS_IOUT,
+		.func[9] = PMBUS_HAVE_VIN | PMBUS_HAVE_STATUS_INPUT,
+		.func[10] = PMBUS_HAVE_IIN | PMBUS_HAVE_STATUS_INPUT,
+		.func[14] = PMBUS_HAVE_IOUT,
+		.func[18] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
+		.read_word_data = max34440_read_word_data,
+		.write_word_data = max34440_write_word_data,
+	},
 	[max34440] = {
 		.pages = 14,
 		.format[PSC_VOLTAGE_IN] = direct,
@@ -635,7 +672,8 @@ static int max34440_probe(struct i2c_client *client)
 		rv = max34451_set_supported_funcs(client, data);
 		if (rv)
 			return rv;
-	} else if (data->id == adpm12160 || data->id == adpm12200) {
+	} else if (data->id == adpm12160 || data->id == adpm12200 ||
+		   data->id == adpm12250) {
 		data->iout_oc_fault_limit = PMBUS_IOUT_OC_FAULT_LIMIT;
 		data->iout_oc_warn_limit = PMBUS_IOUT_OC_WARN_LIMIT;
 	}
@@ -646,6 +684,7 @@ static int max34440_probe(struct i2c_client *client)
 static const struct i2c_device_id max34440_id[] = {
 	{ .name = "adpm12160", .driver_data = adpm12160 },
 	{ .name = "adpm12200", .driver_data = adpm12200 },
+	{ .name = "adpm12250", .driver_data = adpm12250 },
 	{ .name = "max34440", .driver_data = max34440 },
 	{ .name = "max34441", .driver_data = max34441 },
 	{ .name = "max34446", .driver_data = max34446 },
-- 
2.53.0



