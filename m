Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31431DF24B;
	Tue,  8 Oct 2024 13:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394155; cv=none; b=Zk1bRviB6YekCwP/JGILk+UtjKtu7vjOU9M/ONFYDXHcR4yfbZVT75ZlXUavJ6wh2CS23tcvhgZSS7oZIuVdILZl/oJlbKTISIszqPnVxdXqgw4wuA8ZiXb3OizoRt+A+C1Ux4K8Sv25qQKkIbuvcVW774YTAKVWrdZaCSZtgOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394155; c=relaxed/simple;
	bh=hYOXOxzjIULIPOvXWU12v5HeCpBmtEvaRgNSgdv6NTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asG4SV881XX9DRXTjIKLGP0ds9Nl7gdI8zvG9PgNAe0Hry3Zg3EXh8jus16Yg1POBxWu7c6P27QbhpoewHEWlpSbG/YmNHy/ScQbwnGq18u+HqZqdzT7w/qhF8z5yg6XAwnCSr1NJcjcISsapXqYDp0CftfasvBQygz6mHaXdHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUNqt+TK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUNqt+TK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1200EC4CECC;
	Tue,  8 Oct 2024 13:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394155;
	bh=hYOXOxzjIULIPOvXWU12v5HeCpBmtEvaRgNSgdv6NTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUNqt+TKnwoNluZb8BD/dgySfJ4KmK0bvKtv3UEzOphbOgGNi+8sThxlwhVcKlk4c
	 bL5hT+wia1sP9NkULRauJtwFzGD4uMgwUl++HR9pJXA5eYTaNj/b3GHkOxED9/kCxC
	 hrjkJp+N3W11TY8Lf4VJKbZSqHhqZRWro6kL0QIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Piotr Oledzki <ole@ans.pl>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 332/386] i2c: core: Lock address during client device instantiation
Date: Tue,  8 Oct 2024 14:09:37 +0200
Message-ID: <20241008115642.448931636@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
index 9d918a7dfddae..943f0021d6a2c 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -915,6 +915,27 @@ int i2c_dev_irq_from_resources(const struct resource *resources,
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
@@ -962,6 +983,10 @@ i2c_new_client_device(struct i2c_adapter *adap, struct i2c_board_info const *inf
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
@@ -1004,6 +1031,7 @@ i2c_new_client_device(struct i2c_adapter *adap, struct i2c_board_info const *inf
 	dev_err(&adap->dev,
 		"Failed to register i2c client %s at 0x%02x (%d)\n",
 		client->name, client->addr, status);
+	i2c_unlock_addr(adap, client->addr, client->flags);
 out_err_silent:
 	if (need_put)
 		put_device(&client->dev);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 033de64d09bba..a3166100f0cce 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -748,6 +748,9 @@ struct i2c_adapter {
 	struct regulator *bus_regulator;
 
 	struct dentry *debugfs;
+
+	/* 7bit address space */
+	DECLARE_BITMAP(addrs_in_instantiation, 1 << 7);
 };
 #define to_i2c_adapter(d) container_of(d, struct i2c_adapter, dev)
 
-- 
2.43.0



