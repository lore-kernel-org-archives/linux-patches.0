Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F85E43B3FA;
	Tue, 21 Jul 2026 21:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670980; cv=none; b=HvGQY92bf7hzbf/Ufk+BINXS3PGvJKw5m2TRrCpNgBRxGTiz66/JppCyK/bXKo7wfV4PVmfDIMTiHowd5qPcvOMWUWe5ckaWCKpKzyqrZDvFKq0kfnlwzQC37JDHttwbk77t6qM36Sw48aOfGkOCi9CkbU4mrdHpOpiXylyjD1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670980; c=relaxed/simple;
	bh=GnVVbSPlFOzpumg2JuC7NBCLgq35qKOz7VbTF0a/sKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moXIrn5MH9FCr2cQHwA9KSmxLNk44KS3tL9q4hhZW2vNhZTtX4sxDkRw5RThCo5xA0hrnpUwFH9xV6RHfiOj31T4j8fSXLOqLjvCfsbLtmrLp7Fd5wiITvnt3RP+b3/iDXi7iynNZoPZ8ohO4EmUhV3sRUno0ZIIq4nzN9Vq+PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwEQdK/9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwEQdK/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56FE1F000E9;
	Tue, 21 Jul 2026 21:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670979;
	bh=Pj9CuET7q7lJfIeL6Mj212X9x3+t/W0NAOEj6xKjvH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwEQdK/9jmnapl5HZdcwyGIPsBFyyW8yPZc6+5O4Li6NQFDqrfXF5s4kJMgVCZ4K2
	 fC7QDkQJDzE2V2ifgHMf8JmJ4cueM3KaonhrY2LfzmqS/79XkZCHN2rWzSpHkO2g6Y
	 kFr8rtID8mDvsht5gNKNKVGT4+U2VteKMJEx1Q9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Reid <preid@electromag.com.au>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/843] i2c: core: fix hang on adapter registration failure
Date: Tue, 21 Jul 2026 17:14:31 +0200
Message-ID: <20260721152406.785622101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 3c7e164344e5bcf6f274bbf59a3274f5caad9bc1 ]

Clients may be registered from bus notifier callbacks when the adapter
is registered. On a subsequent error during registration, the adapter
references taken by such clients prevent the wait for the references to
be released from ever completing.

Fix this by refactoring client deregistration and deregistering also on
late adapter registration failures.

Fixes: f8756c67b3de ("i2c: core: call of_i2c_setup_smbus_alert in i2c_register_adapter")
Cc: stable@vger.kernel.org	# 4.15
Cc: Phil Reid <preid@electromag.com.au>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Stable-dep-of: ba14d7cf2fe7 ("i2c: core: fix adapter registration race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |   49 ++++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -62,6 +62,7 @@
 static DEFINE_MUTEX(core_lock);
 static DEFINE_IDR(i2c_adapter_idr);
 
+static void i2c_deregister_clients(struct i2c_adapter *adap);
 static int i2c_detect(struct i2c_adapter *adapter, struct i2c_driver *driver);
 
 static DEFINE_STATIC_KEY_FALSE(i2c_trace_msg_key);
@@ -1597,6 +1598,7 @@ static int i2c_register_adapter(struct i
 	return 0;
 
 out_reg:
+	i2c_deregister_clients(adap);
 	debugfs_remove_recursive(adap->debugfs);
 	init_completion(&adap->dev_released);
 	device_unregister(&adap->dev);
@@ -1740,29 +1742,10 @@ static int __process_removed_adapter(str
 	return 0;
 }
 
-/**
- * i2c_del_adapter - unregister I2C adapter
- * @adap: the adapter being unregistered
- * Context: can sleep
- *
- * This unregisters an I2C adapter which was previously registered
- * by @i2c_add_adapter or @i2c_add_numbered_adapter.
- */
-void i2c_del_adapter(struct i2c_adapter *adap)
+static void i2c_deregister_clients(struct i2c_adapter *adap)
 {
-	struct i2c_adapter *found;
 	struct i2c_client *client, *next;
 
-	/* First make sure that this adapter was ever added */
-	mutex_lock(&core_lock);
-	found = idr_find(&i2c_adapter_idr, adap->nr);
-	mutex_unlock(&core_lock);
-	if (found != adap) {
-		pr_debug("attempting to delete unregistered adapter [%s]\n", adap->name);
-		return;
-	}
-
-	i2c_acpi_remove_space_handler(adap);
 	/* Tell drivers about this removal */
 	mutex_lock(&core_lock);
 	bus_for_each_drv(&i2c_bus_type, NULL, adap,
@@ -1788,6 +1771,32 @@ void i2c_del_adapter(struct i2c_adapter
 	 * them up properly, so we give them a chance to do that first. */
 	device_for_each_child(&adap->dev, NULL, __unregister_client);
 	device_for_each_child(&adap->dev, NULL, __unregister_dummy);
+}
+
+/**
+ * i2c_del_adapter - unregister I2C adapter
+ * @adap: the adapter being unregistered
+ * Context: can sleep
+ *
+ * This unregisters an I2C adapter which was previously registered
+ * by @i2c_add_adapter or @i2c_add_numbered_adapter.
+ */
+void i2c_del_adapter(struct i2c_adapter *adap)
+{
+	struct i2c_adapter *found;
+
+	/* First make sure that this adapter was ever added */
+	mutex_lock(&core_lock);
+	found = idr_find(&i2c_adapter_idr, adap->nr);
+	mutex_unlock(&core_lock);
+	if (found != adap) {
+		pr_debug("attempting to delete unregistered adapter [%s]\n", adap->name);
+		return;
+	}
+
+	i2c_acpi_remove_space_handler(adap);
+
+	i2c_deregister_clients(adap);
 
 #ifdef CONFIG_I2C_COMPAT
 	class_compat_remove_link(i2c_adapter_compat_class, &adap->dev,


