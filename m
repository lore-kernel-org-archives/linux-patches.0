Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8501647127B;
	Tue, 21 Jul 2026 18:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657069; cv=none; b=Q2cZksBKaC+KQBy1ZUIp1GdqXQOzVFgBPOQTSIiWhD1oAtD311bI4N2JzW4TWtH9hb/VOTkvC9unS7A0WTjeEYqdhglZDP4FhzXX4s4QRNTmv9bOXGGGPASlbLhyn4A7lOAhMMXqz9GOXySrovJEhgWezEkLfUDiQFh9Ug1/qW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657069; c=relaxed/simple;
	bh=PCGrmi0Cj6QIqiHZGfiXySkn0U+oucXYPt7iSsjljq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDQk2me9Cm3/OeWFF02fxc3qFehMVOLoVLPYx9ffi2Fes6FJx9+P9aZFiHOKhjxO3D0NxrZ5pDpJ3Vx77z5Kot9/Ko/W46JsAOnCcyiRyHc4xPMZPYiUD4pMUrTteg6JBPRj8SVt1/EZUYz4Nx9NsfbIQe+VAcICNB1UdXeZIXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qr4Ox9l3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qr4Ox9l3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1C01F000E9;
	Tue, 21 Jul 2026 18:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657068;
	bh=GNsD3jtBgqvJoErCYt+wwXPSnxd3ojfTvRCg2lgHQn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qr4Ox9l3I7CK/AJVkPlVGnzunS/nhF4ldknjiqHaTKgxHqDEs5SCUnGkOz6jvv+YC
	 qNHgNdqoyLqyNUs7pwAXFrcUaBlHf0BOkx23Hd7P+h5XJ+9JUkESZrmhU73YT6nVda
	 PIgLctfYvtyOKwKyI18Bi3gi8nzoX4nPr7qfuB5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Conte <aldocontelk@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0625/1611] iio: tcs3472: power down chip on probe failure
Date: Tue, 21 Jul 2026 17:12:21 +0200
Message-ID: <20260721152529.447441711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Conte <aldocontelk@gmail.com>

[ Upstream commit b39f3bb9f5580d19bc0c10dea9224d75fed45f1d ]

If tcs3472_probe() fails after enabling the chip (by writing PON | AEN
to the ENABLE register), the error paths return without powering down
the device.

Add an 'error_powerdown' label at the end of the cleanup chain that
calls tcs3472_powerdown() to power down the chip. The existing label
cascade is rerouted to fall through to the new label.

Move tcs3472_powerdown() above tcs3472_probe() so the probe can call
it without a forward declaration.

Found by code inspection while reviewing the probe error paths in
preparation for the devm_ conversion.

Fixes: eb869ade30a6 ("iio: Add tcs3472 color light sensor driver")
Signed-off-by: Aldo Conte <aldocontelk@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/tcs3472.c | 38 +++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/iio/light/tcs3472.c b/drivers/iio/light/tcs3472.c
index 12429a3261b38e..849ca7885d7193 100644
--- a/drivers/iio/light/tcs3472.c
+++ b/drivers/iio/light/tcs3472.c
@@ -440,6 +440,23 @@ static const struct iio_info tcs3472_info = {
 	.attrs = &tcs3472_attribute_group,
 };
 
+static int tcs3472_powerdown(struct tcs3472_data *data)
+{
+	int ret;
+	u8 enable_mask = TCS3472_ENABLE_AEN | TCS3472_ENABLE_PON;
+
+	mutex_lock(&data->lock);
+
+	ret = i2c_smbus_write_byte_data(data->client, TCS3472_ENABLE,
+					data->enable & ~enable_mask);
+	if (!ret)
+		data->enable &= ~enable_mask;
+
+	mutex_unlock(&data->lock);
+
+	return ret;
+}
+
 static int tcs3472_probe(struct i2c_client *client)
 {
 	struct tcs3472_data *data;
@@ -513,7 +530,7 @@ static int tcs3472_probe(struct i2c_client *client)
 	ret = iio_triggered_buffer_setup(indio_dev, NULL,
 		tcs3472_trigger_handler, NULL);
 	if (ret < 0)
-		return ret;
+		goto error_powerdown;
 
 	if (client->irq) {
 		ret = request_threaded_irq(client->irq, NULL,
@@ -536,23 +553,8 @@ static int tcs3472_probe(struct i2c_client *client)
 		free_irq(client->irq, indio_dev);
 buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
-	return ret;
-}
-
-static int tcs3472_powerdown(struct tcs3472_data *data)
-{
-	int ret;
-	u8 enable_mask = TCS3472_ENABLE_AEN | TCS3472_ENABLE_PON;
-
-	mutex_lock(&data->lock);
-
-	ret = i2c_smbus_write_byte_data(data->client, TCS3472_ENABLE,
-		data->enable & ~enable_mask);
-	if (!ret)
-		data->enable &= ~enable_mask;
-
-	mutex_unlock(&data->lock);
-
+error_powerdown:
+	tcs3472_powerdown(data);
 	return ret;
 }
 
-- 
2.53.0



