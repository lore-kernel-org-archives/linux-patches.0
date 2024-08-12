Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4268183CD3;
	Mon, 12 Aug 2024 16:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480245; cv=none; b=Ui29h6K6oYRg8Zjca2yeuko7vjMiam3tzBecOSpFwEEsvKuN4ockWRXUcOrYz3c33BaTKOj3KD0vk6JoPuJsVd/jd0/4okLrXRos6zCf2zq11Wq0mviCzYQv9ZhC/a6N9cYe0+876A6PzuWaUTtG0AXUy/ZXuuWfoh8TD+LoNz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480245; c=relaxed/simple;
	bh=75AVoJJ9P49k3VBGF4d1WvYDYJ4gqNekoG1DOseByKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0JGj6tHhOrDp4bpYeFgP9M/gruxKw1CRuiveYlLRVe5kSrUfF+nFaKjDUbr1IXITeule0MVY0a9Mj4m2DPPbXVWXQiXgfTTTn+qSXe+XatjHg6xz94rnXUzZRLNRAAKb1NPnqEhvOpYs827YBi/bJYS657/3MGLqMyLbuov53Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uWTNXIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uWTNXIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02FEC32782;
	Mon, 12 Aug 2024 16:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480244;
	bh=75AVoJJ9P49k3VBGF4d1WvYDYJ4gqNekoG1DOseByKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uWTNXIvmtOiNAgfW8/MGtF5LR2EoBI6avCSQNQK4r+UYgs1nvdDzPYF74MubmwFb
	 4KuVMlRaE0rgNHKowtepKMlu6spRGT4W3Vx9/AjiZovpGDLqEiWOY17x7F3fREuwe+
	 SedCM23dY6cHdv4WBHyHLUTnRzOXTQga/5PmEcPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 138/263] i2c: smbus: Improve handling of stuck alerts
Date: Mon, 12 Aug 2024 18:02:19 +0200
Message-ID: <20240812160151.831587254@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 37c526f00bc1c4f847fc800085f8f009d2e11be6 ]

The following messages were observed while testing alert functionality
on systems with multiple I2C devices on a single bus if alert was active
on more than one chip.

smbus_alert 3-000c: SMBALERT# from dev 0x0c, flag 0
smbus_alert 3-000c: no driver alert()!

and:

smbus_alert 3-000c: SMBALERT# from dev 0x28, flag 0

Once it starts, this message repeats forever at high rate. There is no
device at any of the reported addresses.

Analysis shows that this is seen if multiple devices have the alert pin
active. Apparently some devices do not support SMBus arbitration correctly.
They keep sending address bits after detecting an address collision and
handle the collision not at all or too late.
Specifically, address 0x0c is seen with ADT7461A at address 0x4c and
ADM1021 at address 0x18 if alert is active on both chips. Address 0x28 is
seen with ADT7483 at address 0x2a and ADT7461 at address 0x4c if alert is
active on both chips.

Once the system is in bad state (alert is set by more than one chip),
it often only recovers by power cycling.

To reduce the impact of this problem, abort the endless loop in
smbus_alert() if the same address is read more than once and not
handled by a driver.

Fixes: b5527a7766f0 ("i2c: Add SMBus alert support")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[wsa: it also fixed an interrupt storm in one of my experiments]
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
[wsa: rebased, moved a comment as well, improved the 'invalid' value]
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-smbus.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/i2c-smbus.c b/drivers/i2c/i2c-smbus.c
index 97f338b123b11..1b4057e1bab09 100644
--- a/drivers/i2c/i2c-smbus.c
+++ b/drivers/i2c/i2c-smbus.c
@@ -34,6 +34,7 @@ static int smbus_do_alert(struct device *dev, void *addrp)
 	struct i2c_client *client = i2c_verify_client(dev);
 	struct alert_data *data = addrp;
 	struct i2c_driver *driver;
+	int ret;
 
 	if (!client || client->addr != data->addr)
 		return 0;
@@ -47,16 +48,21 @@ static int smbus_do_alert(struct device *dev, void *addrp)
 	device_lock(dev);
 	if (client->dev.driver) {
 		driver = to_i2c_driver(client->dev.driver);
-		if (driver->alert)
+		if (driver->alert) {
+			/* Stop iterating after we find the device */
 			driver->alert(client, data->type, data->data);
-		else
+			ret = -EBUSY;
+		} else {
 			dev_warn(&client->dev, "no driver alert()!\n");
-	} else
+			ret = -EOPNOTSUPP;
+		}
+	} else {
 		dev_dbg(&client->dev, "alert with no driver\n");
+		ret = -ENODEV;
+	}
 	device_unlock(dev);
 
-	/* Stop iterating after we find the device */
-	return -EBUSY;
+	return ret;
 }
 
 /*
@@ -67,6 +73,7 @@ static irqreturn_t smbus_alert(int irq, void *d)
 {
 	struct i2c_smbus_alert *alert = d;
 	struct i2c_client *ara;
+	unsigned short prev_addr = I2C_CLIENT_END; /* Not a valid address */
 
 	ara = alert->ara;
 
@@ -94,8 +101,19 @@ static irqreturn_t smbus_alert(int irq, void *d)
 			data.addr, data.data);
 
 		/* Notify driver for the device which issued the alert */
-		device_for_each_child(&ara->adapter->dev, &data,
-				      smbus_do_alert);
+		status = device_for_each_child(&ara->adapter->dev, &data,
+					       smbus_do_alert);
+		/*
+		 * If we read the same address more than once, and the alert
+		 * was not handled by a driver, it won't do any good to repeat
+		 * the loop because it will never terminate.
+		 * Bail out in this case.
+		 * Note: This assumes that a driver with alert handler handles
+		 * the alert properly and clears it if necessary.
+		 */
+		if (data.addr == prev_addr && status != -EBUSY)
+			break;
+		prev_addr = data.addr;
 	}
 
 	return IRQ_HANDLED;
-- 
2.43.0



