Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8267D2D3A69;
	Sun,  7 Jun 2026 10:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828518; cv=none; b=aHV0n2HLdKsFbZnozXjJvDNcARGbIwp3nOFyqhH8iZsnYIU5TASviN9ap8mQxp5JoIZAqbVmSra0fFAhjWiiKCniyiy8RhQS+mg98JPFGcxWKdIJtc04tjtqz87TK9bxkogP4murJJrpjtReBhUN5KQZeHs+PgAe9syDHWjEO8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828518; c=relaxed/simple;
	bh=522kzVyNjfgKqD+m0cEH4rSj5ZpgDThuRS7RQx1ti7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NX4TIfVJghGBFSHvj/j+xnYeyhpwbabScAXI//e7MlCuzLRb/GjU4w2Ed/rtlBnv/wY4wAFp6CnzYW/WouZQicKDlAEfgoiRpoyaWfxKshFlZ2lOP3N2+rpFR4Y1JdVWkTbeWTB6wj+pDWVfbYdGJWkAauhfnhdF+w8SewonDTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZs1ETPj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZs1ETPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897C61F00893;
	Sun,  7 Jun 2026 10:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828517;
	bh=mGiyaAT95SJcP25RPIMREUfVGPX0P6jbsrf9GI6k93g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZs1ETPjkp48LSnmAjGK4MM04mofmE0ShjMzEGvbSAaJfZPTA6AFDAbH7JMKwwxed
	 if46/IjA63VYyBnQ/VcLqMGUZOEX45w9ApnILnGST9RYh/qmyPbWQ0QIAxmQXRO1V+
	 BqgV+IHFeOTVWuIPBEfOfBid1UcCL+ePwoi2nk7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Felix Gu <ustc.gu@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 169/315] iio: light: veml6070: Fix resource leak in probe error path
Date: Sun,  7 Jun 2026 11:59:16 +0200
Message-ID: <20260607095733.799660400@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

commit b66f922f6a4fa92840f662fbcfeb4f8a0f774bcc upstream.

The driver calls i2c_new_dummy_device() to create a dummy device,
then calls i2c_smbus_write_byte(). If i2c_smbus_write_byte() fails and
returns, the cleanup via devm_add_action_or_reset() was never registered,
so the dummy device leaks.

Switch to devm_i2c_new_dummy_device() which registers cleanup atomically
with device creation, eliminating the error-path window.

Fixes: 7501bff87c3e ("iio: light: veml6070: add action for i2c_unregister_device")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/veml6070.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/drivers/iio/light/veml6070.c
+++ b/drivers/iio/light/veml6070.c
@@ -245,13 +245,6 @@ static const struct iio_info veml6070_in
 	.write_raw = veml6070_write_raw,
 };
 
-static void veml6070_i2c_unreg(void *p)
-{
-	struct veml6070_data *data = p;
-
-	i2c_unregister_device(data->client2);
-}
-
 static int veml6070_probe(struct i2c_client *client)
 {
 	struct veml6070_data *data;
@@ -281,7 +274,8 @@ static int veml6070_probe(struct i2c_cli
 	if (ret < 0)
 		return ret;
 
-	data->client2 = i2c_new_dummy_device(client->adapter, VEML6070_ADDR_DATA_LSB);
+	data->client2 = devm_i2c_new_dummy_device(&client->dev, client->adapter,
+						  VEML6070_ADDR_DATA_LSB);
 	if (IS_ERR(data->client2))
 		return dev_err_probe(&client->dev, PTR_ERR(data->client2),
 				     "i2c device for second chip address failed\n");
@@ -292,10 +286,6 @@ static int veml6070_probe(struct i2c_cli
 	if (ret < 0)
 		return ret;
 
-	ret = devm_add_action_or_reset(&client->dev, veml6070_i2c_unreg, data);
-	if (ret < 0)
-		return ret;
-
 	return devm_iio_device_register(&client->dev, indio_dev);
 }
 


