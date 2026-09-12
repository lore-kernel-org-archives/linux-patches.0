Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B960379C38;
	Sat, 12 Sep 2026 10:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207653; cv=none; b=W8xRLBsck6Z62cCCxL0devYXXvieQT6TQfgLyzJXNVoGMoJ1EbasjC+LATc94nVUttcjYh0RD7fHPCxLDOTSBbCW1JBJShL/3AoOe8S2bvP73QJkogVCBnYHqEUjAd7Mj/rrWvz3o2c5X3TiNj69K2pnVEruVf+BX2VD60SH/do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207653; c=relaxed/simple;
	bh=sp2S3GDJksvU4X0Tu1wj1oK3BIyQBmlwSicdCf0SRYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZpjvuFx5dt6+PpTMKxt81CuGaC18lqjiWVYNityZ39ne5xylBiZQ1N9IYSwrNwDNNUU2qzWquI34A5CE9JQ5FJQ2dqRW0gZGKZhVZxN+wAf5uVUztA/80f955TdBr5FclsIeodyRFLLdjrDs0UX1g+r2c/c+/v/YrVq2BAbYbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTPTUjOx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTPTUjOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5411F000FF;
	Sat, 12 Sep 2026 10:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207650;
	bh=Al13dL67XN/mbk4bD39kIvN+KnMUd6zSMp8rBzBfxrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xTPTUjOxDDI4C9qQLNCpbshmN/llIDs2pMDBIa35iLFzzJuMKmEQsMuW+w/lR/nHL
	 AtwzyQYLL5mpOEpW+/YKrk8x+uctwX++gsh03YdrmRt1t/cq/tNzoGG7aBpnNhCD8z
	 gof5GKULIoPC2Y93Pp7RBXPPN6qKhyAALBSX1TyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0454/1518] misc: ad525x_dpot: use driver core groups for sysfs files
Date: Sat, 12 Sep 2026 08:43:43 +0200
Message-ID: <20260912065633.720152152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit e3a8557e88eb26278eda60bf64f2ef33ce7de8bf ]

ad_dpot_probe() creates per-RDAC sysfs files manually and then
optionally creates the command sysfs group. This leaves probe responsible
for rolling back partial sysfs state and makes remove responsible for
matching every file that probe created.

Move the device attributes into driver core dev_groups for the I2C and
SPI drivers and use an is_visible() callback to expose only the
attributes supported by the probed device. With this shape, the driver
core creates the sysfs files only after probe succeeds and removes them
before the remove callback frees the driver data.

Fixes: 4eb174bee6f8 ("ad525x_dpot: new driver for AD525x digital potentiometers")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260623015643.36508-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ad525x_dpot-i2c.c |   1 +
 drivers/misc/ad525x_dpot-spi.c |   1 +
 drivers/misc/ad525x_dpot.c     | 177 ++++++++++++++++++++-------------
 drivers/misc/ad525x_dpot.h     |   3 +
 4 files changed, 112 insertions(+), 70 deletions(-)

diff --git a/drivers/misc/ad525x_dpot-i2c.c b/drivers/misc/ad525x_dpot-i2c.c
index 469478f7a1d33..896ad61bb9e17 100644
--- a/drivers/misc/ad525x_dpot-i2c.c
+++ b/drivers/misc/ad525x_dpot-i2c.c
@@ -105,6 +105,7 @@ MODULE_DEVICE_TABLE(i2c, ad_dpot_id);
 static struct i2c_driver ad_dpot_i2c_driver = {
 	.driver = {
 		.name	= "ad_dpot",
+		.dev_groups = ad_dpot_groups,
 	},
 	.probe		= ad_dpot_i2c_probe,
 	.remove		= ad_dpot_i2c_remove,
diff --git a/drivers/misc/ad525x_dpot-spi.c b/drivers/misc/ad525x_dpot-spi.c
index 263055bda48b7..1ebe629715a84 100644
--- a/drivers/misc/ad525x_dpot-spi.c
+++ b/drivers/misc/ad525x_dpot-spi.c
@@ -131,6 +131,7 @@ MODULE_DEVICE_TABLE(spi, ad_dpot_spi_id);
 static struct spi_driver ad_dpot_spi_driver = {
 	.driver = {
 		.name	= "ad_dpot",
+		.dev_groups = ad_dpot_groups,
 	},
 	.probe		= ad_dpot_spi_probe,
 	.remove		= ad_dpot_spi_remove,
diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index 04683b981e54c..3b55b3f6c7f49 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -630,66 +630,132 @@ static struct attribute *ad525x_attributes_commands[] = {
 	NULL
 };
 
-static const struct attribute_group ad525x_group_commands = {
-	.attrs = ad525x_attributes_commands,
+static struct attribute *ad525x_attributes[] = {
+	&dev_attr_rdac0.attr,
+	&dev_attr_rdac1.attr,
+	&dev_attr_rdac2.attr,
+	&dev_attr_rdac3.attr,
+	&dev_attr_rdac4.attr,
+	&dev_attr_rdac5.attr,
+	&dev_attr_eeprom0.attr,
+	&dev_attr_eeprom1.attr,
+	&dev_attr_eeprom2.attr,
+	&dev_attr_eeprom3.attr,
+	&dev_attr_eeprom4.attr,
+	&dev_attr_eeprom5.attr,
+	&dev_attr_tolerance0.attr,
+	&dev_attr_tolerance1.attr,
+	&dev_attr_tolerance2.attr,
+	&dev_attr_tolerance3.attr,
+	&dev_attr_tolerance4.attr,
+	&dev_attr_tolerance5.attr,
+	&dev_attr_otp0.attr,
+	&dev_attr_otp1.attr,
+	&dev_attr_otp2.attr,
+	&dev_attr_otp3.attr,
+	&dev_attr_otp4.attr,
+	&dev_attr_otp5.attr,
+	&dev_attr_otp0en.attr,
+	&dev_attr_otp1en.attr,
+	&dev_attr_otp2en.attr,
+	&dev_attr_otp3en.attr,
+	&dev_attr_otp4en.attr,
+	&dev_attr_otp5en.attr,
+	&dev_attr_inc_all.attr,
+	&dev_attr_dec_all.attr,
+	&dev_attr_inc_all_6db.attr,
+	&dev_attr_dec_all_6db.attr,
+	NULL
 };
 
-static int ad_dpot_add_files(struct device *dev,
-		unsigned int features, unsigned int rdac)
+static int ad525x_attr_index(struct attribute *attr,
+			     const struct attribute * const *attrs)
 {
-	int err = sysfs_create_file(&dev->kobj,
-		dpot_attrib_wipers[rdac]);
-	if (features & F_CMD_EEP)
-		err |= sysfs_create_file(&dev->kobj,
-			dpot_attrib_eeprom[rdac]);
-	if (features & F_CMD_TOL)
-		err |= sysfs_create_file(&dev->kobj,
-			dpot_attrib_tolerance[rdac]);
-	if (features & F_CMD_OTP) {
-		err |= sysfs_create_file(&dev->kobj,
-			dpot_attrib_otp_en[rdac]);
-		err |= sysfs_create_file(&dev->kobj,
-			dpot_attrib_otp[rdac]);
-	}
+	int i;
 
-	if (err)
-		dev_err(dev, "failed to register sysfs hooks for RDAC%d\n",
-			rdac);
+	for (i = 0; attrs[i]; i++)
+		if (attr == attrs[i])
+			return i;
 
-	return err;
+	return -ENOENT;
 }
 
-static inline void ad_dpot_remove_files(struct device *dev,
-		unsigned int features, unsigned int rdac)
+static bool ad525x_is_command_attr(struct attribute *attr)
 {
-	sysfs_remove_file(&dev->kobj,
-		dpot_attrib_wipers[rdac]);
-	if (features & F_CMD_EEP)
-		sysfs_remove_file(&dev->kobj,
-			dpot_attrib_eeprom[rdac]);
-	if (features & F_CMD_TOL)
-		sysfs_remove_file(&dev->kobj,
-			dpot_attrib_tolerance[rdac]);
-	if (features & F_CMD_OTP) {
-		sysfs_remove_file(&dev->kobj,
-			dpot_attrib_otp_en[rdac]);
-		sysfs_remove_file(&dev->kobj,
-			dpot_attrib_otp[rdac]);
+	int i;
+
+	for (i = 0; ad525x_attributes_commands[i]; i++) {
+		if (attr == ad525x_attributes_commands[i])
+			return true;
 	}
+
+	return false;
+}
+
+static umode_t ad525x_is_visible(struct kobject *kobj, struct attribute *attr,
+				 int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct dpot_data *data = dev_get_drvdata(dev);
+	int rdac;
+
+	if (!data)
+		return 0;
+
+	rdac = ad525x_attr_index(attr, dpot_attrib_wipers);
+	if (rdac >= 0)
+		return data->wipers & BIT(rdac) ? attr->mode : 0;
+
+	rdac = ad525x_attr_index(attr, dpot_attrib_eeprom);
+	if (rdac >= 0)
+		return (data->wipers & BIT(rdac)) && (data->feat & F_CMD_EEP) ?
+			attr->mode : 0;
+
+	rdac = ad525x_attr_index(attr, dpot_attrib_tolerance);
+	if (rdac >= 0)
+		return (data->wipers & BIT(rdac)) && (data->feat & F_CMD_TOL) ?
+			attr->mode : 0;
+
+	rdac = ad525x_attr_index(attr, dpot_attrib_otp);
+	if (rdac >= 0)
+		return (data->wipers & BIT(rdac)) && (data->feat & F_CMD_OTP) ?
+			attr->mode : 0;
+
+	rdac = ad525x_attr_index(attr, dpot_attrib_otp_en);
+	if (rdac >= 0)
+		return (data->wipers & BIT(rdac)) && (data->feat & F_CMD_OTP) ?
+			attr->mode : 0;
+
+	if (ad525x_is_command_attr(attr))
+		return data->feat & F_CMD_INC ? attr->mode : 0;
+
+	return attr->mode;
 }
 
+static const struct attribute_group ad525x_group = {
+	.attrs = ad525x_attributes,
+	.is_visible = ad525x_is_visible,
+};
+
+const struct attribute_group *ad_dpot_groups[] = {
+	&ad525x_group,
+	NULL
+};
+EXPORT_SYMBOL(ad_dpot_groups);
+
 int ad_dpot_probe(struct device *dev,
 		struct ad_dpot_bus_data *bdata, unsigned long devid,
 			    const char *name)
 {
 
 	struct dpot_data *data;
-	int i, err = 0;
+	int i;
 
 	data = kzalloc(sizeof(struct dpot_data), GFP_KERNEL);
 	if (!data) {
-		err = -ENOMEM;
-		goto exit;
+		dev_err(dev, "failed to create client for %s ID 0x%lX\n",
+			name, devid);
+		return -ENOMEM;
 	}
 
 	dev_set_drvdata(dev, data);
@@ -705,51 +771,22 @@ int ad_dpot_probe(struct device *dev,
 	data->wipers = DPOT_WIPERS(devid);
 
 	for (i = DPOT_RDAC0; i < MAX_RDACS; i++)
-		if (data->wipers & (1 << i)) {
-			err = ad_dpot_add_files(dev, data->feat, i);
-			if (err)
-				goto exit_remove_files;
+		if (data->wipers & BIT(i)) {
 			/* power-up midscale */
 			if (data->feat & F_RDACS_WONLY)
 				data->rdac_cache[i] = data->max_pos / 2;
 		}
 
-	if (data->feat & F_CMD_INC)
-		err = sysfs_create_group(&dev->kobj, &ad525x_group_commands);
-
-	if (err) {
-		dev_err(dev, "failed to register sysfs hooks\n");
-		goto exit_free;
-	}
-
 	dev_info(dev, "%s %d-Position Digital Potentiometer registered\n",
 		 name, data->max_pos);
 
 	return 0;
-
-exit_remove_files:
-	for (i = DPOT_RDAC0; i < MAX_RDACS; i++)
-		if (data->wipers & (1 << i))
-			ad_dpot_remove_files(dev, data->feat, i);
-
-exit_free:
-	kfree(data);
-	dev_set_drvdata(dev, NULL);
-exit:
-	dev_err(dev, "failed to create client for %s ID 0x%lX\n",
-		name, devid);
-	return err;
 }
 EXPORT_SYMBOL(ad_dpot_probe);
 
 void ad_dpot_remove(struct device *dev)
 {
 	struct dpot_data *data = dev_get_drvdata(dev);
-	int i;
-
-	for (i = DPOT_RDAC0; i < MAX_RDACS; i++)
-		if (data->wipers & (1 << i))
-			ad_dpot_remove_files(dev, data->feat, i);
 
 	kfree(data);
 }
diff --git a/drivers/misc/ad525x_dpot.h b/drivers/misc/ad525x_dpot.h
index 72a9d6801937c..2e877c89523b5 100644
--- a/drivers/misc/ad525x_dpot.h
+++ b/drivers/misc/ad525x_dpot.h
@@ -10,6 +10,8 @@
 
 #include <linux/types.h>
 
+struct attribute_group;
+
 #define DPOT_CONF(features, wipers, max_pos, uid) \
 		(((features) << 18) | (((wipers) & 0xFF) << 10) | \
 		((max_pos & 0xF) << 6) | (uid & 0x3F))
@@ -210,5 +212,6 @@ struct ad_dpot_bus_data {
 int ad_dpot_probe(struct device *dev, struct ad_dpot_bus_data *bdata,
 		  unsigned long devid, const char *name);
 void ad_dpot_remove(struct device *dev);
+extern const struct attribute_group *ad_dpot_groups[];
 
 #endif
-- 
2.53.0



