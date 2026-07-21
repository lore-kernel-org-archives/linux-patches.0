Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1753246D088;
	Tue, 21 Jul 2026 18:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660262; cv=none; b=eLTyxfmYpX9hXb4ezbrKTEWlmtXed+Q1P4og0Pu2o9jSjKO8jc62eSq2G47rWtNbLMXFzdKs3ugLFHggD6+bpghm/U2Stp5xBJZAhAiq76UnWzpNEX08nA0R57isHXFWaMMS+Xh1DBY7e1C9wB+cw4YOBPfIYPIcttIhkAnQ+6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660262; c=relaxed/simple;
	bh=9W5cXRJIci+uBwH83YXJOhnjhE8VJczmu2AZ2EFbGh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fmi6XLK7XA4/QqaCM3lq0Iixi8QcwMI9O4rvcnQFaYcbglINAu/M0nXMDoD8d1eukrT3WycYLXtYYLQEV4Zz+v7CnfO4LxukZ3yUHsHpH/JLS7SJtTifHkROj82Ec98P8/cgthqIrD5ZAhDcZERSyI0joHr+IJ1FXfsXHTksJr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZThV87iD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZThV87iD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF311F00A3A;
	Tue, 21 Jul 2026 18:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660261;
	bh=UiS3CnLzGG7JfO1pqXHEI4Y5Y/y03/PZVpaKTWEI/Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZThV87iDbX7UaQSbMcnv987+SlPFwtCeVJ8NJz2roIXLI5+RukY6MtdvWQ8j1rxGh
	 PeAdT0Jaw+ZQVUSvzUZ4sut/qdeakgOL7HoqLHPG0wIr0cNs/Ux17A5bViHjK6ttjp
	 iL7lGK2Myh7nigBj+IXZyErTbovmrdJxlI7QS2CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Conte <aldocontelk@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0911/2077] iio: tcs3472: power down chip on probe failure
Date: Tue, 21 Jul 2026 17:09:44 +0200
Message-ID: <20260721152614.305172993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



