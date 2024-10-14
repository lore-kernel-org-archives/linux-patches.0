Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E811ABEDF;
	Mon, 14 Oct 2024 15:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919485; cv=none; b=FBLCf2w9+lPppnSht/V+88id/zx6O0PYj4w3YWHkF3jAuL4uPP0Lm4w2qwKofRJqODSYVALgtnn8goH0lg8MjyH+mzVMoop3C71HKXQexyMO7CycssIAyUijxOvugXJYw+kxmeEZoqULAQl025oxBZJyuE4Vyt6vdvOsCM+vg3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919485; c=relaxed/simple;
	bh=kSTh9KaI1RKAdE4Qc7pjsdsRMqgbucqNq3cIQD3xOkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHjf7rmiDBWoHbz39cO1aweNDB900mMfFCv727Au0b+KNQImDpxc0RD1MGoGx49EzjmOjmpLBmU7iJlR1/GAZq5cB2bv0aqxILjkIstKrcXa92pDZLtwjjqsHN9kG+d+xJSdtfOIpAHvNz7viYnhhhLsEWwNAhl492RvkoDJf0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYFHuy7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYFHuy7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE1CC4CEC7;
	Mon, 14 Oct 2024 15:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919485;
	bh=kSTh9KaI1RKAdE4Qc7pjsdsRMqgbucqNq3cIQD3xOkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYFHuy7O3Vwot9Bxnv+bKEsbgtpZr/LYV3A5c9QGFnLgS9WPZ6b/9ZQlG5zFPrGKx
	 syXMbowZRDvwqt/tsjS1iu9MZM4Szmf9LT2CCmFl78xEY/+CCSCR4y9uilWrvGGXhR
	 CLZH+UfMKrlahSBPxzq9ICieVPgcSeI65NOYxplE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Piotr Oledzki <ole@ans.pl>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 619/798] i2c: core: Lock address during client device instantiation
Date: Mon, 14 Oct 2024 16:19:33 +0200
Message-ID: <20241014141242.358272051@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 4417b2656f875..f7e3fc0b3a1da 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -919,6 +919,27 @@ int i2c_dev_irq_from_resources(const struct resource *resources,
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
@@ -966,6 +987,10 @@ i2c_new_client_device(struct i2c_adapter *adap, struct i2c_board_info const *inf
 		goto out_err_silent;
 	}
 
+	status = i2c_lock_addr(adap, client->addr, client->flags);
+	if (status)
+		goto out_err_silent;
+
 	/* Check for address business */
 	status = i2c_check_addr_busy(adap, i2c_encode_flags_to_addr(client));
 	if (status)
@@ -997,6 +1022,8 @@ i2c_new_client_device(struct i2c_adapter *adap, struct i2c_board_info const *inf
 	dev_dbg(&adap->dev, "client [%s] registered with bus id %s\n",
 		client->name, dev_name(&client->dev));
 
+	i2c_unlock_addr(adap, client->addr, client->flags);
+
 	return client;
 
 out_remove_swnode:
@@ -1008,6 +1035,7 @@ i2c_new_client_device(struct i2c_adapter *adap, struct i2c_board_info const *inf
 	dev_err(&adap->dev,
 		"Failed to register i2c client %s at 0x%02x (%d)\n",
 		client->name, client->addr, status);
+	i2c_unlock_addr(adap, client->addr, client->flags);
 out_err_silent:
 	if (need_put)
 		put_device(&client->dev);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 96432b0a05d4d..87b403a6d7e41 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -752,6 +752,9 @@ struct i2c_adapter {
 	struct regulator *bus_regulator;
 
 	struct dentry *debugfs;
+
+	/* 7bit address space */
+	DECLARE_BITMAP(addrs_in_instantiation, 1 << 7);
 };
 #define to_i2c_adapter(d) container_of(d, struct i2c_adapter, dev)
 
-- 
2.43.0



