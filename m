Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CC5395D99;
	Tue, 21 Jul 2026 20:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666302; cv=none; b=E/5cS89TiSQij3oM2B9OH46Bb4yndU7tKS4l4jNSs/Mu341yiGcq0wwwB+eeoEOUn4lkAQZnCPpJYO/9XL0ufFmiyJRbVid0U82RExUeliCgk+uqHGAvlxyZxTif1ZhjBlkYJ42Jc5bpUdVXg8wdOkUJfwuZJNKxqjTkUmTzxMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666302; c=relaxed/simple;
	bh=Nzag/j0gCWZBgtqSAJxEEsyh7I7Vm9RFQg0yuSHyBEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgcN/YAugqagkxkiO9Z6s5A07jImwp3CwI4MG4te6LOn4omcbJOn4d9VMfGqMC1/4IalgBuwk+qQasbq9d9hFn7zAMqIg+w3d/wOfRtvyMiIquS7FTUifWdqUzCXgpD898O9y5cQ2q00Je0EKdVA6sLY1EzQdC43ts9Tst3jLkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eeQUpC5Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eeQUpC5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773A81F000E9;
	Tue, 21 Jul 2026 20:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666295;
	bh=pIDRZK1gC6LYyPWl+kFYaTO6cqqVEIpIW0nsY6xEc50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eeQUpC5YHzHFj5WsdEXfT7cJvKuBneBTMhlIab9fIIowExXxX8mZUJKj9we8C0/Tu
	 yxsJp5x1ifNXcMbaIVa/WyhPFzysy3PkuHyLygwrA1lErFShqGZRQ4gt5DAvgK6Gqo
	 MXZVRfWGnIZpqEu+mnRpXCQk2nPq+3WMaR4dTF3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Conte <aldocontelk@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0628/1266] iio: tcs3472: power down chip on probe failure
Date: Tue, 21 Jul 2026 17:17:45 +0200
Message-ID: <20260721152455.913126323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 75fcf2c93717b6..ab8478c9b04549 100644
--- a/drivers/iio/light/tcs3472.c
+++ b/drivers/iio/light/tcs3472.c
@@ -442,6 +442,23 @@ static const struct iio_info tcs3472_info = {
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
@@ -515,7 +532,7 @@ static int tcs3472_probe(struct i2c_client *client)
 	ret = iio_triggered_buffer_setup(indio_dev, NULL,
 		tcs3472_trigger_handler, NULL);
 	if (ret < 0)
-		return ret;
+		goto error_powerdown;
 
 	if (client->irq) {
 		ret = request_threaded_irq(client->irq, NULL,
@@ -538,23 +555,8 @@ static int tcs3472_probe(struct i2c_client *client)
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



