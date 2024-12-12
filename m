Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C2C6F2FE;
	Thu, 12 Dec 2024 15:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017850; cv=none; b=pND8nayPxuqiX/W/imBjtmVMtCTu78/XIVKDJdSgqfNatngDiLNwQbjPxBfLxmi7XP6CImHyKiBokjQnpAoQMk3pQwTsT3Yy0nL0HHIVes2zGg7+ulDLf0d1MN3RZVuLWy7k96nGUJv2ZGE157H7tz0yhmtoWid/okFRFlpDhcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017850; c=relaxed/simple;
	bh=xVN9IJ7uIdT/29KFG1B4sygXXIgPBPDyXQoa/4L2kH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIY4LDnfNs+q1SxXrCu6STAf8ox6LYflQe4oUqjIYEnCw9SLuyR2iSaLFwCVK15e4ej2+xeT2vb6hwyX3oukMs1EJLax1hT5f40yjkPLaMpk8pd0epKuz0G7PN94sHfXLXjLj9swul2+ObtM3UlExLKv8hjOj+FBGq/hTXgI3AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gg52GIZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gg52GIZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636A9C4CECE;
	Thu, 12 Dec 2024 15:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017849;
	bh=xVN9IJ7uIdT/29KFG1B4sygXXIgPBPDyXQoa/4L2kH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gg52GIZGuBfHbl8Xgu+xIZoZyegjKb68XxFv1uVMhOIy6WojF/PktZIyoBthlJSq7
	 kGkQlS0kryCcDMDKsK9BypNcr1iAG9kNFxsI4zN4+81POsC+LgrPHGO82mSvPrywGU
	 6G7cefQGBgJMEfhkAKzkGhld2AD1Lr48MY/c5olc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/356] i3c: master: add enable(disable) hot join in sys entry
Date: Thu, 12 Dec 2024 15:56:57 +0100
Message-ID: <20241212144248.490683506@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 317bacf960a4879af22d12175f47d284930b3273 ]

Add hotjoin entry in sys file system allow user enable/disable hotjoin
feature.

Add (*enable(disable)_hotjoin)() to i3c_master_controller_ops.
Add api i3c_master_enable(disable)_hotjoin();

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231201222532.2431484-2-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 25bc99be5fe5 ("i3c: master: svc: Modify enabled_events bit 7:0 to act as IBI enable counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c       | 83 ++++++++++++++++++++++++++++++++++++++
 include/linux/i3c/master.h |  5 +++
 2 files changed, 88 insertions(+)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 70d120dfb0908..bbd5dc89be229 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -526,6 +526,88 @@ static ssize_t i2c_scl_frequency_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(i2c_scl_frequency);
 
+static int i3c_set_hotjoin(struct i3c_master_controller *master, bool enable)
+{
+	int ret;
+
+	if (!master || !master->ops)
+		return -EINVAL;
+
+	if (!master->ops->enable_hotjoin || !master->ops->disable_hotjoin)
+		return -EINVAL;
+
+	i3c_bus_normaluse_lock(&master->bus);
+
+	if (enable)
+		ret = master->ops->enable_hotjoin(master);
+	else
+		ret = master->ops->disable_hotjoin(master);
+
+	master->hotjoin = enable;
+
+	i3c_bus_normaluse_unlock(&master->bus);
+
+	return ret;
+}
+
+static ssize_t hotjoin_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct i3c_bus *i3cbus = dev_to_i3cbus(dev);
+	int ret;
+	bool res;
+
+	if (!i3cbus->cur_master)
+		return -EINVAL;
+
+	if (kstrtobool(buf, &res))
+		return -EINVAL;
+
+	ret = i3c_set_hotjoin(i3cbus->cur_master->common.master, res);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+/*
+ * i3c_master_enable_hotjoin - Enable hotjoin
+ * @master: I3C master object
+ *
+ * Return: a 0 in case of success, an negative error code otherwise.
+ */
+int i3c_master_enable_hotjoin(struct i3c_master_controller *master)
+{
+	return i3c_set_hotjoin(master, true);
+}
+EXPORT_SYMBOL_GPL(i3c_master_enable_hotjoin);
+
+/*
+ * i3c_master_disable_hotjoin - Disable hotjoin
+ * @master: I3C master object
+ *
+ * Return: a 0 in case of success, an negative error code otherwise.
+ */
+int i3c_master_disable_hotjoin(struct i3c_master_controller *master)
+{
+	return i3c_set_hotjoin(master, false);
+}
+EXPORT_SYMBOL_GPL(i3c_master_disable_hotjoin);
+
+static ssize_t hotjoin_show(struct device *dev, struct device_attribute *da, char *buf)
+{
+	struct i3c_bus *i3cbus = dev_to_i3cbus(dev);
+	ssize_t ret;
+
+	i3c_bus_normaluse_lock(i3cbus);
+	ret = sysfs_emit(buf, "%d\n", i3cbus->cur_master->common.master->hotjoin);
+	i3c_bus_normaluse_unlock(i3cbus);
+
+	return ret;
+}
+
+static DEVICE_ATTR_RW(hotjoin);
+
 static struct attribute *i3c_masterdev_attrs[] = {
 	&dev_attr_mode.attr,
 	&dev_attr_current_master.attr,
@@ -536,6 +618,7 @@ static struct attribute *i3c_masterdev_attrs[] = {
 	&dev_attr_pid.attr,
 	&dev_attr_dynamic_address.attr,
 	&dev_attr_hdrcap.attr,
+	&dev_attr_hotjoin.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(i3c_masterdev);
diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index 0b52da4f23467..65b8965968af2 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -452,6 +452,8 @@ struct i3c_master_controller_ops {
 	int (*disable_ibi)(struct i3c_dev_desc *dev);
 	void (*recycle_ibi_slot)(struct i3c_dev_desc *dev,
 				 struct i3c_ibi_slot *slot);
+	int (*enable_hotjoin)(struct i3c_master_controller *master);
+	int (*disable_hotjoin)(struct i3c_master_controller *master);
 };
 
 /**
@@ -487,6 +489,7 @@ struct i3c_master_controller {
 	const struct i3c_master_controller_ops *ops;
 	unsigned int secondary : 1;
 	unsigned int init_done : 1;
+	unsigned int hotjoin: 1;
 	struct {
 		struct list_head i3c;
 		struct list_head i2c;
@@ -543,6 +546,8 @@ int i3c_master_register(struct i3c_master_controller *master,
 			const struct i3c_master_controller_ops *ops,
 			bool secondary);
 void i3c_master_unregister(struct i3c_master_controller *master);
+int i3c_master_enable_hotjoin(struct i3c_master_controller *master);
+int i3c_master_disable_hotjoin(struct i3c_master_controller *master);
 
 /**
  * i3c_dev_get_master_data() - get master private data attached to an I3C
-- 
2.43.0



