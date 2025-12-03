Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F123659F5;
	Wed,  3 Dec 2025 16:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780317; cv=none; b=RMzw1sswSoGPOEe7SyFCFr+9maIViv1TdBnVLxTryMzQSwdK9BZBY/6VkHSPkoaowPKP4r0ctDzOBMygaI/07AVKjK8BmANCAGXZfGiZe2+sTCUD8eecoGZlz8FMMuCFAM5pYvqVUQFzM1axGPN8P3SdXExxtmKc7BSeXia8ImU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780317; c=relaxed/simple;
	bh=0hE67D3Ccrs05VykXXxxi/X2UnK6sskbCo1EgoJzZBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBpAmDLXMqipeLQdzag8i6ZD/xZNXhLZFXWp1R0ITvsVyzQVTVdNbJLCmYPweWJjGx1EGBAYKJHt1F8N+OH5/8RaZ+HwPqc19h1Rxl92NhCQbHfUMmmzOOGUZL+QajFBK6t4aZ0fTYBn12shsAcrpzSwtpMTgi9hdzPIT0uL1RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYXEvy4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYXEvy4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744F4C4CEF5;
	Wed,  3 Dec 2025 16:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780316;
	bh=0hE67D3Ccrs05VykXXxxi/X2UnK6sskbCo1EgoJzZBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYXEvy4+zdPX3kE4BLnvlOFyodIpKYShGgVi7XY5vfgEV+vSWSNGWfJq7PVGfvuh3
	 47b2t2lZxpgs0ccSTByEgRGs25GfTRwXvoJBbCtn1RIwMU7sViUVwDX9MM92F43ElN
	 z6FQ5ASbi01OUX1yA3s6qRrFPZ2oRCOIRadI5SfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valek Andrej <andrej.v@skyrain.eu>,
	Kessler Markus <markus.kessler@hilti.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 520/568] iio: accel: fix ADXL355 startup race condition
Date: Wed,  3 Dec 2025 16:28:42 +0100
Message-ID: <20251203152459.758173219@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -238,7 +240,12 @@ static void adxl355_fill_3db_frequency_t
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
@@ -267,14 +274,41 @@ static int adxl355_setup(struct adxl355_
 		return -ENODEV;
 	}
 
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


