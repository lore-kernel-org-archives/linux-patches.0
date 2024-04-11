Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C64145350;
	Thu, 11 Apr 2024 10:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830608; cv=none; b=UkWuQ/8A57czn4c/tppzFS3DbzSO79Wd1NsOxcDaPZ2GCKm8Oyg44wwuHo5x8UC3GTt4VxM7e5detlpTGYyLrqv8wqKckOWC4+y7sEmScRUt4auuXWfLu/q7jT1vfx2ldOaH3nuPrzB9wpMk6/dqo47CwRwZ5bd8+utnhTzMM/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830608; c=relaxed/simple;
	bh=Rlx0xDft9M4koD3y+F8L25WtTc2el8YBs6DytlZ6yd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhFutUYX8vCRhoS8qHNoKRBVVzAMnMAwKgyXTWqSub5WyhX15/BLaaQWmpk1k4OsLMIK6Cth6a3nN4rMyIGUWU92cCvZtq8oLeKxzQfWHuy6oOJI6WcLyL3gw8Pq4E9XG6wn5nxD84nm+dV6lAcMd7j6fZrKmLV6d89r68bTk6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eOYAZGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eOYAZGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4731C433F1;
	Thu, 11 Apr 2024 10:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830608;
	bh=Rlx0xDft9M4koD3y+F8L25WtTc2el8YBs6DytlZ6yd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eOYAZGsmJQbLiuqNA+s3Nv+ApaQoMm8q6v+hMTU/1WSjTUcU9Ryso7HSBGWI5KqN
	 3eJrFfcp9nxdOFF1XJjXXIppD7RzgZWE6vPl/FWHWn3ZgQgf5FaEOAqcDvGtQadWva
	 P9/wOAiNVrV4Itl+EyCG6tIsAVrgZ7xAWiyNkYwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Carlo Caione <ccaione@baylibre.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/215] firmware: meson_sm: Rework driver as a proper platform driver
Date: Thu, 11 Apr 2024 11:54:25 +0200
Message-ID: <20240411095426.577481884@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlo Caione <ccaione@baylibre.com>

[ Upstream commit 8cde3c2153e8f57be884c0e73f18bc4de150e870 ]

The secure monitor driver is currently a frankenstein driver which is
registered as a platform driver but its functionality goes through a
global struct accessed by the consumer drivers using exported helper
functions.

Try to tidy up the driver moving the firmware struct into the driver
data and make the consumer drivers referencing the secure-monitor using
a new property in the DT.

Currently only the nvmem driver is using this API so we can fix it in
the same commit.

Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Carlo Caione <ccaione@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Stable-dep-of: cbd38332c140 ("nvmem: meson-efuse: fix function pointer type mismatch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/meson/meson_sm.c       | 94 +++++++++++++++++--------
 drivers/nvmem/meson-efuse.c             | 24 ++++++-
 include/linux/firmware/meson/meson_sm.h | 15 ++--
 3 files changed, 94 insertions(+), 39 deletions(-)

diff --git a/drivers/firmware/meson/meson_sm.c b/drivers/firmware/meson/meson_sm.c
index 8d908a8e0d20f..7608704512054 100644
--- a/drivers/firmware/meson/meson_sm.c
+++ b/drivers/firmware/meson/meson_sm.c
@@ -54,8 +54,6 @@ struct meson_sm_firmware {
 	void __iomem *sm_shmem_out_base;
 };
 
-static struct meson_sm_firmware fw;
-
 static u32 meson_sm_get_cmd(const struct meson_sm_chip *chip,
 			    unsigned int cmd_index)
 {
@@ -90,6 +88,7 @@ static void __iomem *meson_sm_map_shmem(u32 cmd_shmem, unsigned int size)
 /**
  * meson_sm_call - generic SMC32 call to the secure-monitor
  *
+ * @fw:		Pointer to secure-monitor firmware
  * @cmd_index:	Index of the SMC32 function ID
  * @ret:	Returned value
  * @arg0:	SMC32 Argument 0
@@ -100,15 +99,15 @@ static void __iomem *meson_sm_map_shmem(u32 cmd_shmem, unsigned int size)
  *
  * Return:	0 on success, a negative value on error
  */
-int meson_sm_call(unsigned int cmd_index, u32 *ret, u32 arg0,
-		  u32 arg1, u32 arg2, u32 arg3, u32 arg4)
+int meson_sm_call(struct meson_sm_firmware *fw, unsigned int cmd_index,
+		  u32 *ret, u32 arg0, u32 arg1, u32 arg2, u32 arg3, u32 arg4)
 {
 	u32 cmd, lret;
 
-	if (!fw.chip)
+	if (!fw->chip)
 		return -ENOENT;
 
-	cmd = meson_sm_get_cmd(fw.chip, cmd_index);
+	cmd = meson_sm_get_cmd(fw->chip, cmd_index);
 	if (!cmd)
 		return -EINVAL;
 
@@ -124,6 +123,7 @@ EXPORT_SYMBOL(meson_sm_call);
 /**
  * meson_sm_call_read - retrieve data from secure-monitor
  *
+ * @fw:		Pointer to secure-monitor firmware
  * @buffer:	Buffer to store the retrieved data
  * @bsize:	Size of the buffer
  * @cmd_index:	Index of the SMC32 function ID
@@ -137,22 +137,23 @@ EXPORT_SYMBOL(meson_sm_call);
  *		When 0 is returned there is no guarantee about the amount of
  *		data read and bsize bytes are copied in buffer.
  */
-int meson_sm_call_read(void *buffer, unsigned int bsize, unsigned int cmd_index,
-		       u32 arg0, u32 arg1, u32 arg2, u32 arg3, u32 arg4)
+int meson_sm_call_read(struct meson_sm_firmware *fw, void *buffer,
+		       unsigned int bsize, unsigned int cmd_index, u32 arg0,
+		       u32 arg1, u32 arg2, u32 arg3, u32 arg4)
 {
 	u32 size;
 	int ret;
 
-	if (!fw.chip)
+	if (!fw->chip)
 		return -ENOENT;
 
-	if (!fw.chip->cmd_shmem_out_base)
+	if (!fw->chip->cmd_shmem_out_base)
 		return -EINVAL;
 
-	if (bsize > fw.chip->shmem_size)
+	if (bsize > fw->chip->shmem_size)
 		return -EINVAL;
 
-	if (meson_sm_call(cmd_index, &size, arg0, arg1, arg2, arg3, arg4) < 0)
+	if (meson_sm_call(fw, cmd_index, &size, arg0, arg1, arg2, arg3, arg4) < 0)
 		return -EINVAL;
 
 	if (size > bsize)
@@ -164,7 +165,7 @@ int meson_sm_call_read(void *buffer, unsigned int bsize, unsigned int cmd_index,
 		size = bsize;
 
 	if (buffer)
-		memcpy(buffer, fw.sm_shmem_out_base, size);
+		memcpy(buffer, fw->sm_shmem_out_base, size);
 
 	return ret;
 }
@@ -173,6 +174,7 @@ EXPORT_SYMBOL(meson_sm_call_read);
 /**
  * meson_sm_call_write - send data to secure-monitor
  *
+ * @fw:		Pointer to secure-monitor firmware
  * @buffer:	Buffer containing data to send
  * @size:	Size of the data to send
  * @cmd_index:	Index of the SMC32 function ID
@@ -184,23 +186,24 @@ EXPORT_SYMBOL(meson_sm_call_read);
  *
  * Return:	size of sent data on success, a negative value on error
  */
-int meson_sm_call_write(void *buffer, unsigned int size, unsigned int cmd_index,
-			u32 arg0, u32 arg1, u32 arg2, u32 arg3, u32 arg4)
+int meson_sm_call_write(struct meson_sm_firmware *fw, void *buffer,
+			unsigned int size, unsigned int cmd_index, u32 arg0,
+			u32 arg1, u32 arg2, u32 arg3, u32 arg4)
 {
 	u32 written;
 
-	if (!fw.chip)
+	if (!fw->chip)
 		return -ENOENT;
 
-	if (size > fw.chip->shmem_size)
+	if (size > fw->chip->shmem_size)
 		return -EINVAL;
 
-	if (!fw.chip->cmd_shmem_in_base)
+	if (!fw->chip->cmd_shmem_in_base)
 		return -EINVAL;
 
-	memcpy(fw.sm_shmem_in_base, buffer, size);
+	memcpy(fw->sm_shmem_in_base, buffer, size);
 
-	if (meson_sm_call(cmd_index, &written, arg0, arg1, arg2, arg3, arg4) < 0)
+	if (meson_sm_call(fw, cmd_index, &written, arg0, arg1, arg2, arg3, arg4) < 0)
 		return -EINVAL;
 
 	if (!written)
@@ -210,6 +213,24 @@ int meson_sm_call_write(void *buffer, unsigned int size, unsigned int cmd_index,
 }
 EXPORT_SYMBOL(meson_sm_call_write);
 
+/**
+ * meson_sm_get - get pointer to meson_sm_firmware structure.
+ *
+ * @sm_node:		Pointer to the secure-monitor Device Tree node.
+ *
+ * Return:		NULL is the secure-monitor device is not ready.
+ */
+struct meson_sm_firmware *meson_sm_get(struct device_node *sm_node)
+{
+	struct platform_device *pdev = of_find_device_by_node(sm_node);
+
+	if (!pdev)
+		return NULL;
+
+	return platform_get_drvdata(pdev);
+}
+EXPORT_SYMBOL_GPL(meson_sm_get);
+
 #define SM_CHIP_ID_LENGTH	119
 #define SM_CHIP_ID_OFFSET	4
 #define SM_CHIP_ID_SIZE		12
@@ -217,14 +238,18 @@ EXPORT_SYMBOL(meson_sm_call_write);
 static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
+	struct platform_device *pdev = to_platform_device(dev);
+	struct meson_sm_firmware *fw;
 	uint8_t *id_buf;
 	int ret;
 
+	fw = platform_get_drvdata(pdev);
+
 	id_buf = kmalloc(SM_CHIP_ID_LENGTH, GFP_KERNEL);
 	if (!id_buf)
 		return -ENOMEM;
 
-	ret = meson_sm_call_read(id_buf, SM_CHIP_ID_LENGTH, SM_GET_CHIP_ID,
+	ret = meson_sm_call_read(fw, id_buf, SM_CHIP_ID_LENGTH, SM_GET_CHIP_ID,
 				 0, 0, 0, 0, 0);
 	if (ret < 0) {
 		kfree(id_buf);
@@ -268,25 +293,34 @@ static const struct of_device_id meson_sm_ids[] = {
 
 static int __init meson_sm_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	const struct meson_sm_chip *chip;
+	struct meson_sm_firmware *fw;
+
+	fw = devm_kzalloc(dev, sizeof(*fw), GFP_KERNEL);
+	if (!fw)
+		return -ENOMEM;
 
-	chip = of_match_device(meson_sm_ids, &pdev->dev)->data;
+	chip = of_match_device(meson_sm_ids, dev)->data;
 
 	if (chip->cmd_shmem_in_base) {
-		fw.sm_shmem_in_base = meson_sm_map_shmem(chip->cmd_shmem_in_base,
-							 chip->shmem_size);
-		if (WARN_ON(!fw.sm_shmem_in_base))
+		fw->sm_shmem_in_base = meson_sm_map_shmem(chip->cmd_shmem_in_base,
+							  chip->shmem_size);
+		if (WARN_ON(!fw->sm_shmem_in_base))
 			goto out;
 	}
 
 	if (chip->cmd_shmem_out_base) {
-		fw.sm_shmem_out_base = meson_sm_map_shmem(chip->cmd_shmem_out_base,
-							  chip->shmem_size);
-		if (WARN_ON(!fw.sm_shmem_out_base))
+		fw->sm_shmem_out_base = meson_sm_map_shmem(chip->cmd_shmem_out_base,
+							   chip->shmem_size);
+		if (WARN_ON(!fw->sm_shmem_out_base))
 			goto out_in_base;
 	}
 
-	fw.chip = chip;
+	fw->chip = chip;
+
+	platform_set_drvdata(pdev, fw);
+
 	pr_info("secure-monitor enabled\n");
 
 	if (sysfs_create_group(&pdev->dev.kobj, &meson_sm_sysfs_attr_group))
@@ -295,7 +329,7 @@ static int __init meson_sm_probe(struct platform_device *pdev)
 	return 0;
 
 out_in_base:
-	iounmap(fw.sm_shmem_in_base);
+	iounmap(fw->sm_shmem_in_base);
 out:
 	return -EINVAL;
 }
diff --git a/drivers/nvmem/meson-efuse.c b/drivers/nvmem/meson-efuse.c
index 39bd76306033f..d6b533497ce1a 100644
--- a/drivers/nvmem/meson-efuse.c
+++ b/drivers/nvmem/meson-efuse.c
@@ -17,14 +17,18 @@
 static int meson_efuse_read(void *context, unsigned int offset,
 			    void *val, size_t bytes)
 {
-	return meson_sm_call_read((u8 *)val, bytes, SM_EFUSE_READ, offset,
+	struct meson_sm_firmware *fw = context;
+
+	return meson_sm_call_read(fw, (u8 *)val, bytes, SM_EFUSE_READ, offset,
 				  bytes, 0, 0, 0);
 }
 
 static int meson_efuse_write(void *context, unsigned int offset,
 			     void *val, size_t bytes)
 {
-	return meson_sm_call_write((u8 *)val, bytes, SM_EFUSE_WRITE, offset,
+	struct meson_sm_firmware *fw = context;
+
+	return meson_sm_call_write(fw, (u8 *)val, bytes, SM_EFUSE_WRITE, offset,
 				   bytes, 0, 0, 0);
 }
 
@@ -37,12 +41,25 @@ MODULE_DEVICE_TABLE(of, meson_efuse_match);
 static int meson_efuse_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	struct meson_sm_firmware *fw;
+	struct device_node *sm_np;
 	struct nvmem_device *nvmem;
 	struct nvmem_config *econfig;
 	struct clk *clk;
 	unsigned int size;
 	int ret;
 
+	sm_np = of_parse_phandle(pdev->dev.of_node, "secure-monitor", 0);
+	if (!sm_np) {
+		dev_err(&pdev->dev, "no secure-monitor node\n");
+		return -ENODEV;
+	}
+
+	fw = meson_sm_get(sm_np);
+	of_node_put(sm_np);
+	if (!fw)
+		return -EPROBE_DEFER;
+
 	clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(clk)) {
 		ret = PTR_ERR(clk);
@@ -65,7 +82,7 @@ static int meson_efuse_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	if (meson_sm_call(SM_EFUSE_USER_MAX, &size, 0, 0, 0, 0, 0) < 0) {
+	if (meson_sm_call(fw, SM_EFUSE_USER_MAX, &size, 0, 0, 0, 0, 0) < 0) {
 		dev_err(dev, "failed to get max user");
 		return -EINVAL;
 	}
@@ -81,6 +98,7 @@ static int meson_efuse_probe(struct platform_device *pdev)
 	econfig->reg_read = meson_efuse_read;
 	econfig->reg_write = meson_efuse_write;
 	econfig->size = size;
+	econfig->priv = fw;
 
 	nvmem = devm_nvmem_register(&pdev->dev, econfig);
 
diff --git a/include/linux/firmware/meson/meson_sm.h b/include/linux/firmware/meson/meson_sm.h
index 7613bf7c94428..6669e2a1d5fdc 100644
--- a/include/linux/firmware/meson/meson_sm.h
+++ b/include/linux/firmware/meson/meson_sm.h
@@ -16,11 +16,14 @@ enum {
 
 struct meson_sm_firmware;
 
-int meson_sm_call(unsigned int cmd_index, u32 *ret, u32 arg0, u32 arg1,
-		  u32 arg2, u32 arg3, u32 arg4);
-int meson_sm_call_write(void *buffer, unsigned int b_size, unsigned int cmd_index,
-			u32 arg0, u32 arg1, u32 arg2, u32 arg3, u32 arg4);
-int meson_sm_call_read(void *buffer, unsigned int bsize, unsigned int cmd_index,
-		       u32 arg0, u32 arg1, u32 arg2, u32 arg3, u32 arg4);
+int meson_sm_call(struct meson_sm_firmware *fw, unsigned int cmd_index,
+		  u32 *ret, u32 arg0, u32 arg1, u32 arg2, u32 arg3, u32 arg4);
+int meson_sm_call_write(struct meson_sm_firmware *fw, void *buffer,
+			unsigned int b_size, unsigned int cmd_index, u32 arg0,
+			u32 arg1, u32 arg2, u32 arg3, u32 arg4);
+int meson_sm_call_read(struct meson_sm_firmware *fw, void *buffer,
+		       unsigned int bsize, unsigned int cmd_index, u32 arg0,
+		       u32 arg1, u32 arg2, u32 arg3, u32 arg4);
+struct meson_sm_firmware *meson_sm_get(struct device_node *firmware_node);
 
 #endif /* _MESON_SM_FW_H_ */
-- 
2.43.0



