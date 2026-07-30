Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF443430CC8;
	Thu, 30 Jul 2026 14:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421781; cv=none; b=Kurd7EYkvBtIdYHxw9pvjeh4rDONtV7gDma8dWioQIMxzSW+6Pi5YZytlEXESU7knML3/Xo9KHp3pEa8aOZpVlo79nIPsWjyWgps2jv7F11fCC8mlpHEMdElLgNBifJjmClUY4l6jCeFzE5ZtvW8nqp02Fhs07q3ZyxK8AswNX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421781; c=relaxed/simple;
	bh=CVnnoneqins4nntbYRs3V2DbYNpa6WMAU+EN3MZz6Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XH88XFKV87eQVYhMFVyUtNTizvFoxrz2L3K+HyB6nyFnzaOZghrCLXNc2epAMnkWviaIZvksyRWgo8OI05AitMZBzQXiXjilttyaFByYcNDeHSgyNZDdPoCGQbTQuhj5qTKI6CsLaI7n7/HK6AWSXqA3W1JHsXzFUGLKBWkZs+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMqWRcoF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMqWRcoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AA01F00A3A;
	Thu, 30 Jul 2026 14:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421779;
	bh=Dmzg1BmIjjFGSXCnC62jiIpi8EbZ7LPVw5iE1K2RZJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMqWRcoFGLuuNjGLqtdDOqc8FxHgDlB00OJkBZi79Y3vfvuWkNN2MYOexLze11T0X
	 MP/ImeD7A23vneacbE8ZU2h3/axh5NDEjEeILON0xC+rHGTUQ9pWk+fGZO37sv5BxJ
	 wsWc2bMsC4xQwW19040/KN3fBeOtGAMtdeu7QtDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexis Czezar Torreno <alexisczezar.torreno@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 216/744] hwmon: (pmbus/max34440) block unsupported VIN and IIN limit registers
Date: Thu, 30 Jul 2026 16:08:09 +0200
Message-ID: <20260730141448.875778038@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Czezar Torreno <alexisczezar.torreno@analog.com>

[ Upstream commit af01dab0c39a7aefc47a109201e4134ea6bd3005 ]

MAX34451 and ADPM chips do not support standard PMBus VIN/IIN limit
registers, manufacturer specific min/max registers, or undercurrent
or undertemperature fault limits. STATUS_BYTE and STATUS_OTHER are also
not available. Accessing these non-existent registers during driver
initialization triggers a CML error and asserts ALERT. Handled by
blocking these functions during read/write.

Fixes: 7a001dbab4ad ("hwmon: (pmbus/max34440) Add support for MAX34451.")
Fixes: 629cf8f6c23a ("hwmon: (pmbus/max34440) Add support for ADPM12160")
Fixes: 2e0b52f1ae88 ("hwmon: (pmbus/max34440): add support adpm12200")
Fixes: 479bfeba2eb6 ("hwmon: (pmbus/max34440): add support adpm12250")
Signed-off-by: Alexis Czezar Torreno <alexisczezar.torreno@analog.com>
Link: https://lore.kernel.org/r/20260716-max34451_fixes-v1-1-a941b27eaecb@analog.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/max34440.c | 80 ++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/drivers/hwmon/pmbus/max34440.c b/drivers/hwmon/pmbus/max34440.c
index 74876d2207fbe4..e56057e9273c16 100644
--- a/drivers/hwmon/pmbus/max34440.c
+++ b/drivers/hwmon/pmbus/max34440.c
@@ -88,6 +88,33 @@ static int max34440_read_word_data(struct i2c_client *client, int page,
 		ret = pmbus_read_word_data(client, page, phase,
 					   data->iout_oc_warn_limit);
 		break;
+	case PMBUS_VIN_OV_FAULT_LIMIT:
+	case PMBUS_VIN_OV_WARN_LIMIT:
+	case PMBUS_VIN_UV_WARN_LIMIT:
+	case PMBUS_VIN_UV_FAULT_LIMIT:
+	case PMBUS_MFR_VIN_MIN:
+	case PMBUS_MFR_VIN_MAX:
+	case PMBUS_IIN_OC_WARN_LIMIT:
+	case PMBUS_IIN_OC_FAULT_LIMIT:
+	case PMBUS_MFR_IIN_MAX:
+	case PMBUS_MFR_VOUT_MIN:
+	case PMBUS_MFR_VOUT_MAX:
+	case PMBUS_IOUT_UC_FAULT_LIMIT:
+	case PMBUS_MFR_IOUT_MAX:
+	case PMBUS_UT_WARN_LIMIT:
+	case PMBUS_UT_FAULT_LIMIT:
+	case PMBUS_MFR_MAX_TEMP_1:
+		/*
+		 * MAX34451/ADPM family do not support VIN/IIN limit registers,
+		 * manufacturer-specific min/max registers, or undercurrent/
+		 * undertemperature fault limits. Accessing these triggers CML
+		 * error and asserts ALERT.
+		 */
+		if (data->id == max34451 || data->id == adpm12160 ||
+		    data->id == adpm12200 || data->id == adpm12250)
+			return -ENXIO;
+		ret = -ENODATA;
+		break;
 	case PMBUS_VIRT_READ_VOUT_MIN:
 		ret = pmbus_read_word_data(client, page, phase,
 					   MAX34440_MFR_VOUT_MIN);
@@ -244,6 +271,51 @@ static int max34440_read_byte_data(struct i2c_client *client, int page, int reg)
 	return ret;
 }
 
+static int max34451_read_byte_data(struct i2c_client *client, int page, int reg)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	const struct max34440_data *data = to_max34440_data(info);
+
+	switch (reg) {
+	case PMBUS_STATUS_BYTE:
+	case PMBUS_STATUS_OTHER:
+		/*
+		 * MAX34451/ADPM family do not support STATUS_BYTE or
+		 * STATUS_OTHER registers. Accessing them triggers CML
+		 * error and asserts ALERT.
+		 */
+		if (data->id == max34451 || data->id == adpm12160 ||
+		    data->id == adpm12200 || data->id == adpm12250)
+			return -ENXIO;
+		return -ENODATA;
+	default:
+		return -ENODATA;
+	}
+}
+
+static int max34451_write_byte_data(struct i2c_client *client, int page,
+				    int reg, u8 byte)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	const struct max34440_data *data = to_max34440_data(info);
+
+	switch (reg) {
+	case PMBUS_STATUS_BYTE:
+	case PMBUS_STATUS_OTHER:
+		/*
+		 * MAX34451/ADPM family do not support STATUS_BYTE or
+		 * STATUS_OTHER registers. Writing to them triggers CML
+		 * error and asserts ALERT.
+		 */
+		if (data->id == max34451 || data->id == adpm12160 ||
+		    data->id == adpm12200 || data->id == adpm12250)
+			return -ENXIO;
+		return -ENODATA;
+	default:
+		return -ENODATA;
+	}
+}
+
 static int max34451_set_supported_funcs(struct i2c_client *client,
 					 struct max34440_data *data)
 {
@@ -363,7 +435,9 @@ static struct pmbus_driver_info max34440_info[] = {
 		.func[9] = PMBUS_HAVE_VIN | PMBUS_HAVE_STATUS_INPUT,
 		.func[10] = PMBUS_HAVE_IIN | PMBUS_HAVE_STATUS_INPUT,
 		.func[18] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
+		.read_byte_data = max34451_read_byte_data,
 		.read_word_data = max34440_read_word_data,
+		.write_byte_data = max34451_write_byte_data,
 		.write_word_data = max34440_write_word_data,
 	},
 	[adpm12200] = {
@@ -399,7 +473,9 @@ static struct pmbus_driver_info max34440_info[] = {
 		.func[10] = PMBUS_HAVE_IIN | PMBUS_HAVE_STATUS_INPUT,
 		.func[14] = PMBUS_HAVE_IOUT,
 		.func[18] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
+		.read_byte_data = max34451_read_byte_data,
 		.read_word_data = max34440_read_word_data,
+		.write_byte_data = max34451_write_byte_data,
 		.write_word_data = max34440_write_word_data,
 	},
 	[adpm12250] = {
@@ -433,7 +509,9 @@ static struct pmbus_driver_info max34440_info[] = {
 		.func[10] = PMBUS_HAVE_IIN | PMBUS_HAVE_STATUS_INPUT,
 		.func[14] = PMBUS_HAVE_IOUT,
 		.func[18] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
+		.read_byte_data = max34451_read_byte_data,
 		.read_word_data = max34440_read_word_data,
+		.write_byte_data = max34451_write_byte_data,
 		.write_word_data = max34440_write_word_data,
 	},
 	[max34440] = {
@@ -581,7 +659,9 @@ static struct pmbus_driver_info max34440_info[] = {
 		.func[18] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
 		.func[19] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
 		.func[20] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
+		.read_byte_data = max34451_read_byte_data,
 		.read_word_data = max34440_read_word_data,
+		.write_byte_data = max34451_write_byte_data,
 		.write_word_data = max34440_write_word_data,
 		.page_change_delay = MAX34440_PAGE_CHANGE_DELAY,
 	},
-- 
2.53.0



