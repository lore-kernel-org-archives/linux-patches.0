Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6737B18454D;
	Mon, 12 Aug 2024 16:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479572; cv=none; b=Vi8E7V4u2hsILQfqVPsJwKSPV+WOWsmTQdh2Nuw2JsVF/vhdsf8SX7knXOd0I1vddDZB6SumrjZTZeL+y9GAChsmXijkkCVfWhmAwGwKfJxoHWmsdQ2inMdVVf5jmNUElk5mSk/o+JKh0Opay9od5Y5921dHcHmOYCcwTYCKfjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479572; c=relaxed/simple;
	bh=fbYBg7R3omYjYY0Ix2FMnKlwubquW1gbQ3kT8fI+zG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGgEZc/gImKk2MfRKOGdqtbUeq/Q0kYWEcbnr1gJmTFB+SjT3sRQabtZikOCBA9ejHLQseqSTMkfQBkLwM1+pWZL26XdUtvp+M3ShTlwJxbTgR0qEIU3WzCDW3zD8D61zkRzkqYri2EwssAR+3MhO42f1gyKlHYtytOxG+jfSsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgEfeofP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgEfeofP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C1BC32782;
	Mon, 12 Aug 2024 16:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479572;
	bh=fbYBg7R3omYjYY0Ix2FMnKlwubquW1gbQ3kT8fI+zG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgEfeofPJDnUT+iJvs9WOzqSRdCbAXaoGdAhxmPbA1TbBIapNyb+Zhw0IiKq05SgA
	 JSZGrQwYLF6Ih5k7ZzKRzZqWMpIUOd8kNPsR5MooDT1oQo8XjRrusuiDKB4AbSndBA
	 VA8Ey3+4fmtPynjX4Y8rM16P8adjWzn/F6dhaW4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/189] i2c: smbus: Send alert notifications to all devices if source not found
Date: Mon, 12 Aug 2024 18:02:33 +0200
Message-ID: <20240812160135.877399836@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit f6c29f710c1ff2590109f83be3e212b86c01e0f3 ]

If a SMBus alert is received and the originating device is not found,
the reason may be that the address reported on the SMBus alert address
is corrupted, for example because multiple devices asserted alert and
do not correctly implement SMBus arbitration.

If this happens, call alert handlers on all devices connected to the
given I2C bus, in the hope that this cleans up the situation.

This change reliably fixed the problem on a system with multiple devices
on a single bus. Example log where the device on address 0x18 (ADM1021)
and on address 0x4c (ADT7461A) both had the alert line asserted:

smbus_alert 3-000c: SMBALERT# from dev 0x0c, flag 0
smbus_alert 3-000c: no driver alert()!
smbus_alert 3-000c: SMBALERT# from dev 0x0c, flag 0
smbus_alert 3-000c: no driver alert()!
lm90 3-0018: temp1 out of range, please check!
lm90 3-0018: Disabling ALERT#
lm90 3-0029: Everything OK
lm90 3-002a: Everything OK
lm90 3-004c: temp1 out of range, please check!
lm90 3-004c: temp2 out of range, please check!
lm90 3-004c: Disabling ALERT#

Fixes: b5527a7766f0 ("i2c: Add SMBus alert support")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[wsa: fixed a typo in the commit message]
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-smbus.c | 38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/i2c-smbus.c b/drivers/i2c/i2c-smbus.c
index 6097fa6b5b4b3..6520e09743912 100644
--- a/drivers/i2c/i2c-smbus.c
+++ b/drivers/i2c/i2c-smbus.c
@@ -65,6 +65,32 @@ static int smbus_do_alert(struct device *dev, void *addrp)
 	return ret;
 }
 
+/* Same as above, but call back all drivers with alert handler */
+
+static int smbus_do_alert_force(struct device *dev, void *addrp)
+{
+	struct i2c_client *client = i2c_verify_client(dev);
+	struct alert_data *data = addrp;
+	struct i2c_driver *driver;
+
+	if (!client || (client->flags & I2C_CLIENT_TEN))
+		return 0;
+
+	/*
+	 * Drivers should either disable alerts, or provide at least
+	 * a minimal handler. Lock so the driver won't change.
+	 */
+	device_lock(dev);
+	if (client->dev.driver) {
+		driver = to_i2c_driver(client->dev.driver);
+		if (driver->alert)
+			driver->alert(client, data->type, data->data);
+	}
+	device_unlock(dev);
+
+	return 0;
+}
+
 /*
  * The alert IRQ handler needs to hand work off to a task which can issue
  * SMBus calls, because those sleeping calls can't be made in IRQ context.
@@ -106,13 +132,19 @@ static irqreturn_t smbus_alert(int irq, void *d)
 		/*
 		 * If we read the same address more than once, and the alert
 		 * was not handled by a driver, it won't do any good to repeat
-		 * the loop because it will never terminate.
-		 * Bail out in this case.
+		 * the loop because it will never terminate. Try again, this
+		 * time calling the alert handlers of all devices connected to
+		 * the bus, and abort the loop afterwards. If this helps, we
+		 * are all set. If it doesn't, there is nothing else we can do,
+		 * so we might as well abort the loop.
 		 * Note: This assumes that a driver with alert handler handles
 		 * the alert properly and clears it if necessary.
 		 */
-		if (data.addr == prev_addr && status != -EBUSY)
+		if (data.addr == prev_addr && status != -EBUSY) {
+			device_for_each_child(&ara->adapter->dev, &data,
+					      smbus_do_alert_force);
 			break;
+		}
 		prev_addr = data.addr;
 	}
 
-- 
2.43.0



