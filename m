Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8593414A2A;
	Fri,  4 Sep 2026 06:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502651; cv=none; b=Vfb3mkDcKaxYrQL/uOK0CLn81Wxt1yx8yAixNiJ42N/+rhlT80JqiAGlhCCBfbTnrseNto8ZPPZv8YdnDZBtH+91IxmM0SD/vO2yxln0k+TqsoAYCcKvykfQz9/F89FbNA0cizVys8H24bJBtecWQYj9sCZu89//+rD9mX8I+ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502651; c=relaxed/simple;
	bh=LhvqP+rpV1IF4T/LBlyLprEVFh3WksTJ9jTzqdH8jmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEfCBx49X59VMd0ootPoXH7HcbJB1tQrM1yjryv1loTCMlXj7L2DdEtMR2wYNvMZIL8QYiQTt/Rnmc9yPf8focuzqu7zGq6BjFQGIYQziHybeimr8csd1G/Nl0ksKqND3E/pFl/cG65oJChVNZNgXYE3Dzw0w0U4Mrn0KViacuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGBGJvo4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGBGJvo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DF31F00A3D;
	Fri,  4 Sep 2026 06:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502650;
	bh=HhmoCcOfgFiVK3jLpSrPyrrLfSISSwZ6e2UTLE758Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JGBGJvo4Q8DPPmX9KmuHQJKGZkbkV1LrqWTJMXZxk7V7JlrMXDxD0b56vYyt8O2l7
	 Xy7A7RWct3HAEDuQZjGNVTd7l9FGHBAwcirez7BSrYW40K/6IzaLXQZj7JVFfNmMBm
	 kDwrC5DNkhNPCZw2TVOKjhjmjmQqm/87I//T1cVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 283/403] power: supply: max17040: drop incorrect I2C functionality check
Date: Fri,  4 Sep 2026 07:01:26 +0200
Message-ID: <20260904045741.292720708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianing Li <m13940358460@163.com>

commit 4e4b9f5ce9dfb8ed4b8d1262a504b8043ac09d87 upstream.

max17040_probe() rejects adapters that do not advertise
I2C_FUNC_SMBUS_BYTE. The driver does not issue SMBus byte transactions,
however. Its regmap has 8-bit registers and 16-bit big-endian values, for
which regmap-i2c supports either raw I2C transfers or SMBus word-data
transactions.

Consequently, an adapter providing raw I2C transfers or SMBus word data
but not SMBus byte transactions is rejected even though regmap can access
the device. Conversely, the current check can pass an adapter that regmap
cannot use.

Drop the stale check and let devm_regmap_init_i2c() validate and select
the supported transfer method.

Fixes: 6455a8a84bdfd ("power: supply: max17040: Use regmap i2c")
Cc: stable@vger.kernel.org
Signed-off-by: Jianing Li <m13940358460@163.com>
Link: https://patch.msgid.link/20260731084259.916-1-m13940358460@163.com
[Fixed Fixes tag, so that it points to the regmap introduction instead of the initial driver addition]
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max17040_battery.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -474,16 +474,12 @@ static const struct power_supply_desc ma
 static int max17040_probe(struct i2c_client *client)
 {
 	const struct i2c_device_id *id = i2c_client_get_device_id(client);
-	struct i2c_adapter *adapter = client->adapter;
 	struct power_supply_config psy_cfg = {};
 	struct max17040_chip *chip;
 	enum chip_id chip_id;
 	bool enable_irq = false;
 	int ret;
 
-	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE))
-		return -EIO;
-
 	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;


