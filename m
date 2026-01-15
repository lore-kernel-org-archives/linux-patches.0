Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69171280327;
	Thu, 15 Jan 2026 17:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497464; cv=none; b=hnD1nDEAXCyLGwaeccogyyjwWVNO0AkNaj0mW9mfNrYuatT9H4oaaP3tC8KFJ6z4ZQc1EyE6XCLoslATILEC8Rmz1KaeSXw397gHEIUvP1gLI95vFKhIxobvAKCPpv7Qhgv7jFnp6YCKHFJ74i3zaDB83hHALjBirnKVDYP4PZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497464; c=relaxed/simple;
	bh=Ew34uqBjtipa/sAzcqoyh0J76FIkbR+f0p9fc4U/DrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HA5iMJoNEBwVoqLCM+sABQ+N1KHWfkaBT9FejZInxnFraFXLi1Ded9SC3/JW+tPf6RqohXUp4TGnbYNSnpEQWNbJceGP8Zo4DKCMsYLOJrXvL+suvE7iiS5EqTckImktOnQWdCdxtmWjrSX/hCWdScmr7280upSzBUZp7m3v584=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZWa/uY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZWa/uY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C12C116D0;
	Thu, 15 Jan 2026 17:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497464;
	bh=Ew34uqBjtipa/sAzcqoyh0J76FIkbR+f0p9fc4U/DrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZWa/uY7mOFVyE6GlCTAUQBpi3SIeLB1Nx94BkZEH+PXb9/sCCGeXcoS+8IEBVfIx
	 wyy/xr6b0Zp7U0nK1qO683CMIOgXg3pKtZwn2v6c3fr0o5Knv5uYFSjEBmxxxdeYST
	 HhisSo7Nr+4TuySbSdIgrwp6c4PIP+/pjvDqE1yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/554] i3c: support dynamically added i2c devices
Date: Thu, 15 Jan 2026 17:42:09 +0100
Message-ID: <20260115164248.525124331@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Jamie Iles <quic_jiles@quicinc.com>

[ Upstream commit 72a4501b5d089772671360a6ec74d5350acf8c2e ]

I2C devices can be added to the system dynamically through several
sources other than static board info including device tree overlays and
sysfs i2c new_device.

Add an I2C bus notifier to attach the clients at runtime if they were
not defined in the board info.  For DT devices find the LVR in the reg
property, for user-space new_device additions we synthesize a
conservative setting of no spike filters and fast mode only.

Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Jamie Iles <quic_jiles@quicinc.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220117174816.1963463-3-quic_jiles@quicinc.com
Stable-dep-of: 9d4f219807d5 ("i3c: fix refcount inconsistency in i3c_master_register")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 128 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 127 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index d4e9299472679..ae60eb7b27601 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2170,11 +2170,122 @@ static u32 i3c_master_i2c_funcs(struct i2c_adapter *adapter)
 	return I2C_FUNC_SMBUS_EMUL | I2C_FUNC_I2C;
 }
 
+static u8 i3c_master_i2c_get_lvr(struct i2c_client *client)
+{
+	/* Fall back to no spike filters and FM bus mode. */
+	u8 lvr = I3C_LVR_I2C_INDEX(2) | I3C_LVR_I2C_FM_MODE;
+
+	if (client->dev.of_node) {
+		u32 reg[3];
+
+		if (!of_property_read_u32_array(client->dev.of_node, "reg",
+						reg, ARRAY_SIZE(reg)))
+			lvr = reg[2];
+	}
+
+	return lvr;
+}
+
+static int i3c_master_i2c_attach(struct i2c_adapter *adap, struct i2c_client *client)
+{
+	struct i3c_master_controller *master = i2c_adapter_to_i3c_master(adap);
+	enum i3c_addr_slot_status status;
+	struct i2c_dev_desc *i2cdev;
+	int ret;
+
+	/* Already added by board info? */
+	if (i3c_master_find_i2c_dev_by_addr(master, client->addr))
+		return 0;
+
+	status = i3c_bus_get_addr_slot_status(&master->bus, client->addr);
+	if (status != I3C_ADDR_SLOT_FREE)
+		return -EBUSY;
+
+	i3c_bus_set_addr_slot_status(&master->bus, client->addr,
+				     I3C_ADDR_SLOT_I2C_DEV);
+
+	i2cdev = i3c_master_alloc_i2c_dev(master, client->addr,
+					  i3c_master_i2c_get_lvr(client));
+	if (IS_ERR(i2cdev)) {
+		ret = PTR_ERR(i2cdev);
+		goto out_clear_status;
+	}
+
+	ret = i3c_master_attach_i2c_dev(master, i2cdev);
+	if (ret)
+		goto out_free_dev;
+
+	return 0;
+
+out_free_dev:
+	i3c_master_free_i2c_dev(i2cdev);
+out_clear_status:
+	i3c_bus_set_addr_slot_status(&master->bus, client->addr,
+				     I3C_ADDR_SLOT_FREE);
+
+	return ret;
+}
+
+static int i3c_master_i2c_detach(struct i2c_adapter *adap, struct i2c_client *client)
+{
+	struct i3c_master_controller *master = i2c_adapter_to_i3c_master(adap);
+	struct i2c_dev_desc *dev;
+
+	dev = i3c_master_find_i2c_dev_by_addr(master, client->addr);
+	if (!dev)
+		return -ENODEV;
+
+	i3c_master_detach_i2c_dev(dev);
+	i3c_bus_set_addr_slot_status(&master->bus, dev->addr,
+				     I3C_ADDR_SLOT_FREE);
+	i3c_master_free_i2c_dev(dev);
+
+	return 0;
+}
+
 static const struct i2c_algorithm i3c_master_i2c_algo = {
 	.master_xfer = i3c_master_i2c_adapter_xfer,
 	.functionality = i3c_master_i2c_funcs,
 };
 
+static int i3c_i2c_notifier_call(struct notifier_block *nb, unsigned long action,
+				 void *data)
+{
+	struct i2c_adapter *adap;
+	struct i2c_client *client;
+	struct device *dev = data;
+	struct i3c_master_controller *master;
+	int ret;
+
+	if (dev->type != &i2c_client_type)
+		return 0;
+
+	client = to_i2c_client(dev);
+	adap = client->adapter;
+
+	if (adap->algo != &i3c_master_i2c_algo)
+		return 0;
+
+	master = i2c_adapter_to_i3c_master(adap);
+
+	i3c_bus_maintenance_lock(&master->bus);
+	switch (action) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		ret = i3c_master_i2c_attach(adap, client);
+		break;
+	case BUS_NOTIFY_DEL_DEVICE:
+		ret = i3c_master_i2c_detach(adap, client);
+		break;
+	}
+	i3c_bus_maintenance_unlock(&master->bus);
+
+	return ret;
+}
+
+static struct notifier_block i2cdev_notifier = {
+	.notifier_call = i3c_i2c_notifier_call,
+};
+
 static int i3c_master_i2c_adapter_init(struct i3c_master_controller *master)
 {
 	struct i2c_adapter *adap = i3c_master_to_i2c_adapter(master);
@@ -2705,12 +2816,27 @@ void i3c_dev_free_ibi_locked(struct i3c_dev_desc *dev)
 
 static int __init i3c_init(void)
 {
-	return bus_register(&i3c_bus_type);
+	int res = bus_register_notifier(&i2c_bus_type, &i2cdev_notifier);
+
+	if (res)
+		return res;
+
+	res = bus_register(&i3c_bus_type);
+	if (res)
+		goto out_unreg_notifier;
+
+	return 0;
+
+out_unreg_notifier:
+	bus_unregister_notifier(&i2c_bus_type, &i2cdev_notifier);
+
+	return res;
 }
 subsys_initcall(i3c_init);
 
 static void __exit i3c_exit(void)
 {
+	bus_unregister_notifier(&i2c_bus_type, &i2cdev_notifier);
 	idr_destroy(&i3c_bus_idr);
 	bus_unregister(&i3c_bus_type);
 }
-- 
2.51.0



