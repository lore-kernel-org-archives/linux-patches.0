Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24AE1DED4B;
	Tue,  8 Oct 2024 12:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392225; cv=none; b=bWxlkpaoI7sXVj0zW/NA4ARICYtsUpGpIM6CeRcRLbvkJND2rp5Rbdkf9y4BP8/yyR9azbeg/XCT4IVJ4y/gVxrixbNRz+mbguLapwcjcS7JoQ5SymKeBWUhbCiDkmmCHC9Zs5/ft77GihYeu8OaKS+haloWhfEu9vxv9aDz+H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392225; c=relaxed/simple;
	bh=lGtFHa1N9wbVveHsoQ9w/ONEA2FgbNvi5cZaNjJqXoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9Covfdx/3geJ0mnnE+Gm/h416T57xQLya2nIsOiGmtLn27o8IvFeeSBpyiCOiD0cb/nK4hLk6xvlLG8b6WeHQXyo/eTFlW4oAdYS+giIOH4+miqglH3MnSmlny/Y7m4O4wEhV2CHKOCAJHjRDWz24Qku29oAL9267XCMUKdTfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dmdx/JVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dmdx/JVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CB6C4CECC;
	Tue,  8 Oct 2024 12:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392224;
	bh=lGtFHa1N9wbVveHsoQ9w/ONEA2FgbNvi5cZaNjJqXoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dmdx/JVQzVrsUkRAzuCLwZL342d0UyiKgdJDrKeoDV2XD3nsuH+XNb2KchSyPj+zb
	 UzIQ9LV9UTmMn++FDuN5sEnrkBpkfUT0J1nNsjXO2Qjr3IZDq7jj+ZkjvNURTfRbiV
	 edCntOIi1JL3U6tazJTmvO/jb5IE5Er60PvbRD4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Piotr Oledzki <ole@ans.pl>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.11 353/558] i2c: core: Lock address during client device instantiation
Date: Tue,  8 Oct 2024 14:06:23 +0200
Message-ID: <20241008115716.190171964@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 8d3cefaf659265aa82b0373a563fdb9d16a2b947 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |   28 ++++++++++++++++++++++++++++
 include/linux/i2c.h         |    3 +++
 2 files changed, 31 insertions(+)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -915,6 +915,27 @@ int i2c_dev_irq_from_resources(const str
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
@@ -962,6 +983,10 @@ i2c_new_client_device(struct i2c_adapter
 		goto out_err_silent;
 	}
 
+	status = i2c_lock_addr(adap, client->addr, client->flags);
+	if (status)
+		goto out_err_silent;
+
 	/* Check for address business */
 	status = i2c_check_addr_busy(adap, i2c_encode_flags_to_addr(client));
 	if (status)
@@ -993,6 +1018,8 @@ i2c_new_client_device(struct i2c_adapter
 	dev_dbg(&adap->dev, "client [%s] registered with bus id %s\n",
 		client->name, dev_name(&client->dev));
 
+	i2c_unlock_addr(adap, client->addr, client->flags);
+
 	return client;
 
 out_remove_swnode:
@@ -1004,6 +1031,7 @@ out_err:
 	dev_err(&adap->dev,
 		"Failed to register i2c client %s at 0x%02x (%d)\n",
 		client->name, client->addr, status);
+	i2c_unlock_addr(adap, client->addr, client->flags);
 out_err_silent:
 	if (need_put)
 		put_device(&client->dev);
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -761,6 +761,9 @@ struct i2c_adapter {
 	struct regulator *bus_regulator;
 
 	struct dentry *debugfs;
+
+	/* 7bit address space */
+	DECLARE_BITMAP(addrs_in_instantiation, 1 << 7);
 };
 #define to_i2c_adapter(d) container_of(d, struct i2c_adapter, dev)
 


