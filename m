Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518B5173334;
	Wed,  3 Jul 2024 11:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005379; cv=none; b=K1mMXZr24XwOZi9px11pwIcw9h2okJRlor4S7vBz0Tg8lv2DERN37dqqEHNWUpDnKcy7KKi1iYpSn2MzEZEp2b0/ZZTNoy2JNLrxWDEIOVfs6cDSXb06KdJbHDMbakRGrqJZRDU5YsoYwHdQPlkXV6BAUYj+Cdb6I/Nz6qNFJtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005379; c=relaxed/simple;
	bh=dL2EpbHj0IJig4mCzWi9l491oXa/Qymo8FHFSYf7DHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2NFMP6GMM5u2sJok3qEjL2doB3R0I1Lzo7ppZo1+cvlwhFLzL2LwizoHAWDNu+erPeJ/AsXIZot6UFklAZkZ50gxa1MDZkfyQXSurUbOc76Ww3gM34szSZ9ropqFAnu7JPd8pMgm28vSWQ2MEd97GpK8qS7KqvXdTgNtT+dyAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1338VVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1338VVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50CFC2BD10;
	Wed,  3 Jul 2024 11:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005379;
	bh=dL2EpbHj0IJig4mCzWi9l491oXa/Qymo8FHFSYf7DHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1338VVP2F0AYUmY0t+zYhNuEPgNPb19c5/q6CpwQq4wCC6eMbXJmYe0xD7LwULc4
	 guh1FUEUvffqYhykEDoxpk4YWAsFAr5eoOVtHhedkRxnBdHoP/JQhMbSieMrUT1cwd
	 67srfyeQxQTPXR6qBk1vxVIsA2OjU67rStofIJ3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/356] i2c: add fwnode APIs
Date: Wed,  3 Jul 2024 12:36:37 +0200
Message-ID: <20240703102915.403158847@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 373c612d72461ddaea223592df31e62c934aae61 ]

Add fwnode APIs for finding and getting I2C adapters, which will be
used by the SFP code. These are passed the fwnode corresponding to
the adapter, and return the I2C adapter. It is the responsibility of
the caller to find the appropriate fwnode.

We keep the DT and ACPI interfaces, but where appropriate, recode them
to use the fwnode interfaces internally.

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 3f858bbf04db ("i2c: acpi: Unbind mux adapters before delete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-acpi.c | 13 +----
 drivers/i2c/i2c-core-base.c | 98 +++++++++++++++++++++++++++++++++++++
 drivers/i2c/i2c-core-of.c   | 66 -------------------------
 include/linux/i2c.h         | 24 +++++++--
 4 files changed, 120 insertions(+), 81 deletions(-)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index 546cc935e035a..29a482abf1eed 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -421,18 +421,7 @@ EXPORT_SYMBOL_GPL(i2c_acpi_find_adapter_by_handle);
 
 static struct i2c_client *i2c_acpi_find_client_by_adev(struct acpi_device *adev)
 {
-	struct device *dev;
-	struct i2c_client *client;
-
-	dev = bus_find_device_by_acpi_dev(&i2c_bus_type, adev);
-	if (!dev)
-		return NULL;
-
-	client = i2c_verify_client(dev);
-	if (!client)
-		put_device(dev);
-
-	return client;
+	return i2c_find_device_by_fwnode(acpi_fwnode_handle(adev));
 }
 
 static int i2c_acpi_notify(struct notifier_block *nb, unsigned long value,
diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 1810a994c07ca..505eebbc98a09 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1009,6 +1009,35 @@ void i2c_unregister_device(struct i2c_client *client)
 }
 EXPORT_SYMBOL_GPL(i2c_unregister_device);
 
+/**
+ * i2c_find_device_by_fwnode() - find an i2c_client for the fwnode
+ * @fwnode: &struct fwnode_handle corresponding to the &struct i2c_client
+ *
+ * Look up and return the &struct i2c_client corresponding to the @fwnode.
+ * If no client can be found, or @fwnode is NULL, this returns NULL.
+ *
+ * The user must call put_device(&client->dev) once done with the i2c client.
+ */
+struct i2c_client *i2c_find_device_by_fwnode(struct fwnode_handle *fwnode)
+{
+	struct i2c_client *client;
+	struct device *dev;
+
+	if (!fwnode)
+		return NULL;
+
+	dev = bus_find_device_by_fwnode(&i2c_bus_type, fwnode);
+	if (!dev)
+		return NULL;
+
+	client = i2c_verify_client(dev);
+	if (!client)
+		put_device(dev);
+
+	return client;
+}
+EXPORT_SYMBOL(i2c_find_device_by_fwnode);
+
 
 static const struct i2c_device_id dummy_id[] = {
 	{ "dummy", 0 },
@@ -1764,6 +1793,75 @@ int devm_i2c_add_adapter(struct device *dev, struct i2c_adapter *adapter)
 }
 EXPORT_SYMBOL_GPL(devm_i2c_add_adapter);
 
+static int i2c_dev_or_parent_fwnode_match(struct device *dev, const void *data)
+{
+	if (dev_fwnode(dev) == data)
+		return 1;
+
+	if (dev->parent && dev_fwnode(dev->parent) == data)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * i2c_find_adapter_by_fwnode() - find an i2c_adapter for the fwnode
+ * @fwnode: &struct fwnode_handle corresponding to the &struct i2c_adapter
+ *
+ * Look up and return the &struct i2c_adapter corresponding to the @fwnode.
+ * If no adapter can be found, or @fwnode is NULL, this returns NULL.
+ *
+ * The user must call put_device(&adapter->dev) once done with the i2c adapter.
+ */
+struct i2c_adapter *i2c_find_adapter_by_fwnode(struct fwnode_handle *fwnode)
+{
+	struct i2c_adapter *adapter;
+	struct device *dev;
+
+	if (!fwnode)
+		return NULL;
+
+	dev = bus_find_device(&i2c_bus_type, NULL, fwnode,
+			      i2c_dev_or_parent_fwnode_match);
+	if (!dev)
+		return NULL;
+
+	adapter = i2c_verify_adapter(dev);
+	if (!adapter)
+		put_device(dev);
+
+	return adapter;
+}
+EXPORT_SYMBOL(i2c_find_adapter_by_fwnode);
+
+/**
+ * i2c_get_adapter_by_fwnode() - find an i2c_adapter for the fwnode
+ * @fwnode: &struct fwnode_handle corresponding to the &struct i2c_adapter
+ *
+ * Look up and return the &struct i2c_adapter corresponding to the @fwnode,
+ * and increment the adapter module's use count. If no adapter can be found,
+ * or @fwnode is NULL, this returns NULL.
+ *
+ * The user must call i2c_put_adapter(adapter) once done with the i2c adapter.
+ * Note that this is different from i2c_find_adapter_by_node().
+ */
+struct i2c_adapter *i2c_get_adapter_by_fwnode(struct fwnode_handle *fwnode)
+{
+	struct i2c_adapter *adapter;
+
+	adapter = i2c_find_adapter_by_fwnode(fwnode);
+	if (!adapter)
+		return NULL;
+
+	if (!try_module_get(adapter->owner)) {
+		put_device(&adapter->dev);
+		adapter = NULL;
+	}
+
+	return adapter;
+}
+EXPORT_SYMBOL(i2c_get_adapter_by_fwnode);
+
 static void i2c_parse_timing(struct device *dev, char *prop_name, u32 *cur_val_p,
 			    u32 def_val, bool use_def)
 {
diff --git a/drivers/i2c/i2c-core-of.c b/drivers/i2c/i2c-core-of.c
index 3ed74aa4b44bb..bce6b796e04c2 100644
--- a/drivers/i2c/i2c-core-of.c
+++ b/drivers/i2c/i2c-core-of.c
@@ -113,72 +113,6 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
 	of_node_put(bus);
 }
 
-static int of_dev_or_parent_node_match(struct device *dev, const void *data)
-{
-	if (dev->of_node == data)
-		return 1;
-
-	if (dev->parent)
-		return dev->parent->of_node == data;
-
-	return 0;
-}
-
-/* must call put_device() when done with returned i2c_client device */
-struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
-{
-	struct device *dev;
-	struct i2c_client *client;
-
-	dev = bus_find_device_by_of_node(&i2c_bus_type, node);
-	if (!dev)
-		return NULL;
-
-	client = i2c_verify_client(dev);
-	if (!client)
-		put_device(dev);
-
-	return client;
-}
-EXPORT_SYMBOL(of_find_i2c_device_by_node);
-
-/* must call put_device() when done with returned i2c_adapter device */
-struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
-{
-	struct device *dev;
-	struct i2c_adapter *adapter;
-
-	dev = bus_find_device(&i2c_bus_type, NULL, node,
-			      of_dev_or_parent_node_match);
-	if (!dev)
-		return NULL;
-
-	adapter = i2c_verify_adapter(dev);
-	if (!adapter)
-		put_device(dev);
-
-	return adapter;
-}
-EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
-
-/* must call i2c_put_adapter() when done with returned i2c_adapter device */
-struct i2c_adapter *of_get_i2c_adapter_by_node(struct device_node *node)
-{
-	struct i2c_adapter *adapter;
-
-	adapter = of_find_i2c_adapter_by_node(node);
-	if (!adapter)
-		return NULL;
-
-	if (!try_module_get(adapter->owner)) {
-		put_device(&adapter->dev);
-		adapter = NULL;
-	}
-
-	return adapter;
-}
-EXPORT_SYMBOL(of_get_i2c_adapter_by_node);
-
 static const struct of_device_id*
 i2c_of_match_device_sysfs(const struct of_device_id *matches,
 				  struct i2c_client *client)
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 2ce3efbe9198a..f071a121ed914 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -954,15 +954,33 @@ int i2c_handle_smbus_host_notify(struct i2c_adapter *adap, unsigned short addr);
 
 #endif /* I2C */
 
+/* must call put_device() when done with returned i2c_client device */
+struct i2c_client *i2c_find_device_by_fwnode(struct fwnode_handle *fwnode);
+
+/* must call put_device() when done with returned i2c_adapter device */
+struct i2c_adapter *i2c_find_adapter_by_fwnode(struct fwnode_handle *fwnode);
+
+/* must call i2c_put_adapter() when done with returned i2c_adapter device */
+struct i2c_adapter *i2c_get_adapter_by_fwnode(struct fwnode_handle *fwnode);
+
 #if IS_ENABLED(CONFIG_OF)
 /* must call put_device() when done with returned i2c_client device */
-struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
+static inline struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
+{
+	return i2c_find_device_by_fwnode(of_fwnode_handle(node));
+}
 
 /* must call put_device() when done with returned i2c_adapter device */
-struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node);
+static inline struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
+{
+	return i2c_find_adapter_by_fwnode(of_fwnode_handle(node));
+}
 
 /* must call i2c_put_adapter() when done with returned i2c_adapter device */
-struct i2c_adapter *of_get_i2c_adapter_by_node(struct device_node *node);
+static inline struct i2c_adapter *of_get_i2c_adapter_by_node(struct device_node *node)
+{
+	return i2c_get_adapter_by_fwnode(of_fwnode_handle(node));
+}
 
 const struct of_device_id
 *i2c_of_match_device(const struct of_device_id *matches,
-- 
2.43.0



