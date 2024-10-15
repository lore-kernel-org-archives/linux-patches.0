Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FEE1D4154;
	Tue, 15 Oct 2024 12:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994027; cv=none; b=mZwcLtIR/vmFO3ppk0AoCXQzgGqlwbPtqLsuyyXXLnocO57IDXgQToT1T2+zScwtxdpS05vv9o3r36PHWCZCW6zZtUtzq+rpJKB7wybq4LZ8SPTmbzR3TdVWDSWPambKsslUP0vJIXiRdrLFjngwUs6mwHiq2yk5ffadkXNJ360=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994027; c=relaxed/simple;
	bh=CwC/7A4B6WcKnlQwQccX5da0P6ra6w098vS/VnYE3iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaJH8uzM9sTbF0R0swyRkHRPkcDXy8MVuvj6BKxgE74DAAL/vkMuf10KYoiQmBCQXpt/2Gzp17MdTyGHb8OjWnZgnRK06dzYU4yACs6dKTJaAaamPCo355Gxk/fXFISYXYyE6nz87gxZS6vAgEp1405v7cyvTaRkw9mboadUVK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8YZ+MjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8YZ+MjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2EEC4CEC6;
	Tue, 15 Oct 2024 12:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994027;
	bh=CwC/7A4B6WcKnlQwQccX5da0P6ra6w098vS/VnYE3iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S8YZ+MjWNJzKK/36+VDcmd/HhdX08dsd5xTB2/y/tATZh6Z0DSZ4MWgdwbJmxozbm
	 iLlBWbzyMIByCiokfQB17+d3KIIZXqDt4/LHS7Rcg2xc8hmX1eXYwEfjfI1/mzjI8d
	 oDGXCnEZj3Bek6VWh4S5Ls5Hg1U0txAWXJ+Fpp54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Piotr Oledzki <ole@ans.pl>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 554/691] i2c: core: Lock address during client device instantiation
Date: Tue, 15 Oct 2024 13:28:22 +0200
Message-ID: <20241015112502.328173243@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 8d3cefaf659265aa82b0373a563fdb9d16a2b947 ]

Krzysztof reported an issue [0] which is caused by parallel attempts to
instantiate the same I2C client device. This can happen if driver
supports auto-detection, but certain devices are also instantiated
explicitly.
The original change isn't actually wrong, it just revealed that I2C core
isn't prepared yet to handle this scenario.
Calls to i2c_new_client_device() can be nested, therefore we can't use a
simple mutex here. Parallel instantiation of devices at different addresses
is ok, so we just have to prevent parallel instantiation at the same address.
We can use a bitmap with one bit per 7-bit I2C client address, and atomic
bit operations to set/check/clear bits.
Now a parallel attempt to instantiate a device at the same address will
result in -EBUSY being returned, avoiding the "sysfs: cannot create duplicate
filename" splash.

Note: This patch version includes small cosmetic changes to the Tested-by
      version, only functional change is that address locking is supported
      for slave addresses too.

[0] https://lore.kernel.org/linux-i2c/9479fe4e-eb0c-407e-84c0-bd60c15baf74@ans.pl/T/#m12706546e8e2414d8f1a0dc61c53393f731685cc

Fixes: caba40ec3531 ("eeprom: at24: Probe for DDR3 thermal sensor in the SPD case")
Cc: stable@vger.kernel.org
Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-base.c | 28 ++++++++++++++++++++++++++++
 include/linux/i2c.h         |  3 +++
 2 files changed, 31 insertions(+)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 76d70de2d317d..265b7f7f38c6e 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -917,6 +917,27 @@ int i2c_dev_irq_from_resources(const struct resource *resources,
 	return 0;
 }
 
+/*
+ * Serialize device instantiation in case it can be instantiated explicitly
+ * and by auto-detection
+ */
+static int i2c_lock_addr(struct i2c_adapter *adap, unsigned short addr,
+			 unsigned short flags)
+{
+	if (!(flags & I2C_CLIENT_TEN) &&
+	    test_and_set_bit(addr, adap->addrs_in_instantiation))
+		return -EBUSY;
+
+	return 0;
+}
+
+static void i2c_unlock_addr(struct i2c_adapter *adap, unsigned short addr,
+			    unsigned short flags)
+{
+	if (!(flags & I2C_CLIENT_TEN))
+		clear_bit(addr, adap->addrs_in_instantiation);
+}
+
 /**
  * i2c_new_client_device - instantiate an i2c device
  * @adap: the adapter managing the device
@@ -963,6 +984,10 @@ i2c_new_client_device(struct i2c_adapter *adap, struct i2c_board_info const *inf
 		goto out_err_silent;
 	}
 
+	status = i2c_lock_addr(adap, client->addr, client->flags);
+	if (status)
+		goto out_err_silent;
+
 	/* Check for address business */
 	status = i2c_check_addr_busy(adap, i2c_encode_flags_to_addr(client));
 	if (status)
@@ -993,6 +1018,8 @@ i2c_new_client_device(struct i2c_adapter *adap, struct i2c_board_info const *inf
 	dev_dbg(&adap->dev, "client [%s] registered with bus id %s\n",
 		client->name, dev_name(&client->dev));
 
+	i2c_unlock_addr(adap, client->addr, client->flags);
+
 	return client;
 
 out_remove_swnode:
@@ -1003,6 +1030,7 @@ i2c_new_client_device(struct i2c_adapter *adap, struct i2c_board_info const *inf
 	dev_err(&adap->dev,
 		"Failed to register i2c client %s at 0x%02x (%d)\n",
 		client->name, client->addr, status);
+	i2c_unlock_addr(adap, client->addr, client->flags);
 out_err_silent:
 	kfree(client);
 	return ERR_PTR(status);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 7c2ff4d7c360a..996886f187a1e 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -742,6 +742,9 @@ struct i2c_adapter {
 	struct regulator *bus_regulator;
 
 	struct dentry *debugfs;
+
+	/* 7bit address space */
+	DECLARE_BITMAP(addrs_in_instantiation, 1 << 7);
 };
 #define to_i2c_adapter(d) container_of(d, struct i2c_adapter, dev)
 
-- 
2.43.0



