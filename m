Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB09815AAD9;
	Mon, 29 Jan 2024 17:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548392; cv=none; b=Uh6ylokerjdxFUktRNeV4GJuH3LWsMXQU+kqmp7rYMtIKMbbROwzBXIEef0qxPN7ypjCqtb8PAMKXuVbXy1jy+zwHsCCv14n4SOTT6zLVEL/l24k6oDoCJxxivJaBPNLLK9g7fVhultN+VIchov/MO3DMalnYrJr2MnjJ71GvSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548392; c=relaxed/simple;
	bh=M123H5v1aZRQ0IbUo0vxeEgJRyNJN8i1SwWVxsPLXRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJCFPUMMjfrcXvaPjo47reBxWq11ZhfAxrB+4iO6PWPAGz33EyQhxqChhJKjH3scj9SzaEUQzR0bZLESAGlYtdaOdFWddiikXtU+vmNh5K7Yaecb5LUsxq+o83V0X55U4X3ZcLjSlNOMz1SIpa79Nb1yGTJCKc5UIcaMkAD2Ifc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUAaAnAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUAaAnAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905BBC43390;
	Mon, 29 Jan 2024 17:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548392;
	bh=M123H5v1aZRQ0IbUo0vxeEgJRyNJN8i1SwWVxsPLXRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUAaAnAWdw3Ad4rtV6oVBjGB+bfkLcKX9X5re1BvJIEpS4txb4BdKNc205w5ToKzU
	 g+XzS3MFBRnT1Rp3k/ORoJZsswxTQsWaZF7+1yv4/ub6SfbKgnV+GmlCxGVA1mHzd+
	 GzrKLeORP0uXSfdyI81gNfAzpg1r1uMq9igVPl24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arec Kao <arec.kao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/185] media: ov13b10: Support device probe in non-zero ACPI D state
Date: Mon, 29 Jan 2024 09:05:43 -0800
Message-ID: <20240129170003.182388292@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Arec Kao <arec.kao@intel.com>

[ Upstream commit 1af2f618acc1486e3b46cb54cb4891d47bb80c61 ]

Tell ACPI device PM code that the driver supports the device being in
non-zero ACPI D state when the driver's probe function is entered.

Also do identification on the first access of the device, whether in
probe or when starting streaming.

Signed-off-by: Arec Kao <arec.kao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: 7b0454cfd8ed ("media: ov13b10: Enable runtime PM before registering async sub-device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov13b10.c | 74 +++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 27 deletions(-)

diff --git a/drivers/media/i2c/ov13b10.c b/drivers/media/i2c/ov13b10.c
index 549e5d93e568..722f490f9db4 100644
--- a/drivers/media/i2c/ov13b10.c
+++ b/drivers/media/i2c/ov13b10.c
@@ -589,6 +589,9 @@ struct ov13b10 {
 
 	/* Streaming on/off */
 	bool streaming;
+
+	/* True if the device has been identified */
+	bool identified;
 };
 
 #define to_ov13b10(_sd)	container_of(_sd, struct ov13b10, sd)
@@ -1023,12 +1026,42 @@ ov13b10_set_pad_format(struct v4l2_subdev *sd,
 	return 0;
 }
 
+/* Verify chip ID */
+static int ov13b10_identify_module(struct ov13b10 *ov13b)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&ov13b->sd);
+	int ret;
+	u32 val;
+
+	if (ov13b->identified)
+		return 0;
+
+	ret = ov13b10_read_reg(ov13b, OV13B10_REG_CHIP_ID,
+			       OV13B10_REG_VALUE_24BIT, &val);
+	if (ret)
+		return ret;
+
+	if (val != OV13B10_CHIP_ID) {
+		dev_err(&client->dev, "chip id mismatch: %x!=%x\n",
+			OV13B10_CHIP_ID, val);
+		return -EIO;
+	}
+
+	ov13b->identified = true;
+
+	return 0;
+}
+
 static int ov13b10_start_streaming(struct ov13b10 *ov13b)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&ov13b->sd);
 	const struct ov13b10_reg_list *reg_list;
 	int ret, link_freq_index;
 
+	ret = ov13b10_identify_module(ov13b);
+	if (ret)
+		return ret;
+
 	/* Get out of from software reset */
 	ret = ov13b10_write_reg(ov13b, OV13B10_REG_SOFTWARE_RST,
 				OV13B10_REG_VALUE_08BIT, OV13B10_SOFTWARE_RST);
@@ -1144,27 +1177,6 @@ static int __maybe_unused ov13b10_resume(struct device *dev)
 	return ret;
 }
 
-/* Verify chip ID */
-static int ov13b10_identify_module(struct ov13b10 *ov13b)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(&ov13b->sd);
-	int ret;
-	u32 val;
-
-	ret = ov13b10_read_reg(ov13b, OV13B10_REG_CHIP_ID,
-			       OV13B10_REG_VALUE_24BIT, &val);
-	if (ret)
-		return ret;
-
-	if (val != OV13B10_CHIP_ID) {
-		dev_err(&client->dev, "chip id mismatch: %x!=%x\n",
-			OV13B10_CHIP_ID, val);
-		return -EIO;
-	}
-
-	return 0;
-}
-
 static const struct v4l2_subdev_video_ops ov13b10_video_ops = {
 	.s_stream = ov13b10_set_stream,
 };
@@ -1379,6 +1391,7 @@ static int ov13b10_check_hwcfg(struct device *dev)
 static int ov13b10_probe(struct i2c_client *client)
 {
 	struct ov13b10 *ov13b;
+	bool full_power;
 	int ret;
 
 	/* Check HW config */
@@ -1395,11 +1408,14 @@ static int ov13b10_probe(struct i2c_client *client)
 	/* Initialize subdev */
 	v4l2_i2c_subdev_init(&ov13b->sd, client, &ov13b10_subdev_ops);
 
-	/* Check module identity */
-	ret = ov13b10_identify_module(ov13b);
-	if (ret) {
-		dev_err(&client->dev, "failed to find sensor: %d\n", ret);
-		return ret;
+	full_power = acpi_dev_state_d0(&client->dev);
+	if (full_power) {
+		/* Check module identity */
+		ret = ov13b10_identify_module(ov13b);
+		if (ret) {
+			dev_err(&client->dev, "failed to find sensor: %d\n", ret);
+			return ret;
+		}
 	}
 
 	/* Set default mode to max resolution */
@@ -1431,7 +1447,10 @@ static int ov13b10_probe(struct i2c_client *client)
 	 * Device is already turned on by i2c-core with ACPI domain PM.
 	 * Enable runtime PM and turn off the device.
 	 */
-	pm_runtime_set_active(&client->dev);
+
+	/* Set the device's state to active if it's in D0 state. */
+	if (full_power)
+		pm_runtime_set_active(&client->dev);
 	pm_runtime_enable(&client->dev);
 	pm_runtime_idle(&client->dev);
 
@@ -1480,6 +1499,7 @@ static struct i2c_driver ov13b10_i2c_driver = {
 	},
 	.probe_new = ov13b10_probe,
 	.remove = ov13b10_remove,
+	.flags = I2C_DRV_ACPI_WAIVE_D0_PROBE,
 };
 
 module_i2c_driver(ov13b10_i2c_driver);
-- 
2.43.0



