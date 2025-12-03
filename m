Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED14A32E6B7;
	Wed,  3 Dec 2025 15:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777045; cv=none; b=ihWtz+yDbTSEu+AQdLqJBwkxTj7brdLR8Wrv/2TYuGzZZPVO34R7fYvq3Y+hZHsQ79S03z2YjD33J/5NhuZS+pbyAvXPffeoNs6rexaN4vJ3cwohQk9+HLGs67QBMvFweu5aHzj6fi8lG7e5TzhWwNNlvZQvman6AU0MsV41t68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777045; c=relaxed/simple;
	bh=eSdAtt/WIIiI41iDRaRV+fCINE3T7/QCb43lzjf1HXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEn6lbvyUL+uReAZJCsfbIqc1Mo8A5TjKsDnOI8y8xrBt87UuaWTScswrztskoLy6B2C4BZkvGPDtX5mJhJMDwt+lwwm3MfeM31tOWLid6CY2wICvTyks0F8OAjFGuByVBZVwYC/YGgOVmxfrTXOroxfj3ABlb+UddgYZ1Pp0aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnsvOsaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnsvOsaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED50C4CEF5;
	Wed,  3 Dec 2025 15:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777044;
	bh=eSdAtt/WIIiI41iDRaRV+fCINE3T7/QCb43lzjf1HXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnsvOsaj0JcXDdiyP2delobTNqLs8dGttg7ht5P9Lxy9XXWmAnfRNvidehoMsrotb
	 5ItuW72htCVKi/Eo/rxf+KXEGtxLbrg4ooyXXnm2xPCTrCCGHpfZVO44kZ0GJxQZ+l
	 9nQ4EOefOC4wKIilLGeBm0Ox4EPih3LfGFce1iEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valek Andrej <andrej.v@skyrain.eu>,
	Kessler Markus <markus.kessler@hilti.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 064/146] iio: accel: fix ADXL355 startup race condition
Date: Wed,  3 Dec 2025 16:27:22 +0100
Message-ID: <20251203152348.810257310@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valek Andrej <andrej.v@skyrain.eu>

commit c92c1bc408e9e11ae3c7011b062fdd74c09283a3 upstream.

There is an race-condition where device is not full working after SW reset.
Therefore it's necessary to wait some time after reset and verify shadow
registers values by reading and comparing the values before/after reset.
This mechanism is described in datasheet at least from revision D.

Fixes: 12ed27863ea3 ("iio: accel: Add driver support for ADXL355")
Signed-off-by: Valek Andrej <andrej.v@skyrain.eu>
Signed-off-by: Kessler Markus <markus.kessler@hilti.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/adxl355_core.c |   44 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

--- a/drivers/iio/accel/adxl355_core.c
+++ b/drivers/iio/accel/adxl355_core.c
@@ -56,6 +56,8 @@
 #define  ADXL355_POWER_CTL_DRDY_MSK	BIT(2)
 #define ADXL355_SELF_TEST_REG		0x2E
 #define ADXL355_RESET_REG		0x2F
+#define ADXL355_BASE_ADDR_SHADOW_REG	0x50
+#define ADXL355_SHADOW_REG_COUNT	5
 
 #define ADXL355_DEVID_AD_VAL		0xAD
 #define ADXL355_DEVID_MST_VAL		0x1D
@@ -294,7 +296,12 @@ static void adxl355_fill_3db_frequency_t
 static int adxl355_setup(struct adxl355_data *data)
 {
 	unsigned int regval;
+	int retries = 5; /* the number is chosen based on empirical reasons */
 	int ret;
+	u8 *shadow_regs __free(kfree) = kzalloc(ADXL355_SHADOW_REG_COUNT, GFP_KERNEL);
+
+	if (!shadow_regs)
+		return -ENOMEM;
 
 	ret = regmap_read(data->regmap, ADXL355_DEVID_AD_REG, &regval);
 	if (ret)
@@ -321,14 +328,41 @@ static int adxl355_setup(struct adxl355_
 	if (regval != ADXL355_PARTID_VAL)
 		dev_warn(data->dev, "Invalid DEV ID 0x%02x\n", regval);
 
-	/*
-	 * Perform a software reset to make sure the device is in a consistent
-	 * state after start-up.
-	 */
-	ret = regmap_write(data->regmap, ADXL355_RESET_REG, ADXL355_RESET_CODE);
+	/* Read shadow registers to be compared after reset */
+	ret = regmap_bulk_read(data->regmap,
+			       ADXL355_BASE_ADDR_SHADOW_REG,
+			       shadow_regs, ADXL355_SHADOW_REG_COUNT);
 	if (ret)
 		return ret;
 
+	do {
+		if (--retries == 0) {
+			dev_err(data->dev, "Shadow registers mismatch\n");
+			return -EIO;
+		}
+
+		/*
+		 * Perform a software reset to make sure the device is in a consistent
+		 * state after start-up.
+		 */
+		ret = regmap_write(data->regmap, ADXL355_RESET_REG,
+				   ADXL355_RESET_CODE);
+		if (ret)
+			return ret;
+
+		/* Wait at least 5ms after software reset */
+		usleep_range(5000, 10000);
+
+		/* Read shadow registers for comparison */
+		ret = regmap_bulk_read(data->regmap,
+				       ADXL355_BASE_ADDR_SHADOW_REG,
+				       data->buffer.buf,
+				       ADXL355_SHADOW_REG_COUNT);
+		if (ret)
+			return ret;
+	} while (memcmp(shadow_regs, data->buffer.buf,
+			ADXL355_SHADOW_REG_COUNT));
+
 	ret = regmap_update_bits(data->regmap, ADXL355_POWER_CTL_REG,
 				 ADXL355_POWER_CTL_DRDY_MSK,
 				 FIELD_PREP(ADXL355_POWER_CTL_DRDY_MSK, 1));


