Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDBD26B2BF;
	Tue,  8 Apr 2025 12:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116235; cv=none; b=RT5uWNwF3dij3GTDOlpCjqaX0HnZiP0XmBUKlh3HZX/Au61HUOwXY/RSrhNgqZXmNBMTTemMzjvIDRKTs2VmFYonX6zMMsOrYPcF7n5fFp/J8luQyAgr+6uRxRuAjt6BZPwDjJoYPHu9Olwtwq0SYLsZro21oozVQrYKmi1rGAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116235; c=relaxed/simple;
	bh=a+BnMcb+yv+AeL2WVtVYGpwUd1g/QORskkUgKZfIKkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJrB6jgI1GimMRv53aDAJTQFCmCFNLg3y8A4xiWyjLgBObdqx3/hVbO9E8Ad/THotLhwLkxCFXFHpD/Krg4OrtPT26ki69DaMXXo1EaGc5pEE5wKg8OwygZAB6XPF27KWbyxqwqDk6f4xtsVQgvXV1uFW4dpk94Exina1cVD/PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEcX4UZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEcX4UZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0DCC4CEE5;
	Tue,  8 Apr 2025 12:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116235;
	bh=a+BnMcb+yv+AeL2WVtVYGpwUd1g/QORskkUgKZfIKkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEcX4UZoUt2Yexj7icw1NcebOrvvgQSb81W2aJ9h1IQ6Ff7VTs296/hlALLwDBUZy
	 ZygNF9EaZ3swOVCD6Eur1OZq1Jbs/4OrkGWNXDmSiS0xJfM2LvU2kw6LYkDq/dpzHK
	 uk7QiMMncgXf+JVAdFX90HV0zozzuH/Y5IjHeTbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/423] drm/ssd130x: Set SPI .id_table to prevent an SPI core warning
Date: Tue,  8 Apr 2025 12:46:14 +0200
Message-ID: <20250408104846.868624594@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit 5d40d4fae6f2fb789f48207a9d4772bbee970b5c ]

The only reason for the ssd130x-spi driver to have an spi_device_id table
is that the SPI core always reports an "spi:" MODALIAS, even when the SPI
device has been registered via a Device Tree Blob.

Without spi_device_id table information in the module's metadata, module
autoloading would not work because there won't be an alias that matches
the MODALIAS reported by the SPI core.

This spi_device_id table is not needed for device matching though, since
the of_device_id table is always used in this case. For this reason, the
struct spi_driver .id_table member is currently not set in the SPI driver.

Because the spi_device_id table is always required for module autoloading,
the SPI core checks during driver registration that both an of_device_id
table and a spi_device_id table are present and that they contain the same
entries for all the SPI devices.

Not setting the .id_table member in the driver then confuses the core and
leads to the following warning when the ssd130x-spi driver is registered:

  [   41.091198] SPI driver ssd130x-spi has no spi_device_id for sinowealth,sh1106
  [   41.098614] SPI driver ssd130x-spi has no spi_device_id for solomon,ssd1305
  [   41.105862] SPI driver ssd130x-spi has no spi_device_id for solomon,ssd1306
  [   41.113062] SPI driver ssd130x-spi has no spi_device_id for solomon,ssd1307
  [   41.120247] SPI driver ssd130x-spi has no spi_device_id for solomon,ssd1309
  [   41.127449] SPI driver ssd130x-spi has no spi_device_id for solomon,ssd1322
  [   41.134627] SPI driver ssd130x-spi has no spi_device_id for solomon,ssd1325
  [   41.141784] SPI driver ssd130x-spi has no spi_device_id for solomon,ssd1327
  [   41.149021] SPI driver ssd130x-spi has no spi_device_id for solomon,ssd1331

To prevent the warning, set the .id_table even though it's not necessary.

Since the check is done even for built-in drivers, drop the condition to
only define the ID table when the driver is built as a module. Finally,
rename the variable to use the "_spi_id" convention used for ID tables.

Fixes: 74373977d2ca ("drm/solomon: Add SSD130x OLED displays SPI support")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241231114516.2063201-1-javierm@redhat.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x-spi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x-spi.c b/drivers/gpu/drm/solomon/ssd130x-spi.c
index 84bfde31d1724..fd1b858dcb788 100644
--- a/drivers/gpu/drm/solomon/ssd130x-spi.c
+++ b/drivers/gpu/drm/solomon/ssd130x-spi.c
@@ -151,7 +151,6 @@ static const struct of_device_id ssd130x_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ssd130x_of_match);
 
-#if IS_MODULE(CONFIG_DRM_SSD130X_SPI)
 /*
  * The SPI core always reports a MODALIAS uevent of the form "spi:<dev>", even
  * if the device was registered via OF. This means that the module will not be
@@ -160,7 +159,7 @@ MODULE_DEVICE_TABLE(of, ssd130x_of_match);
  * To workaround this issue, add a SPI device ID table. Even when this should
  * not be needed for this driver to match the registered SPI devices.
  */
-static const struct spi_device_id ssd130x_spi_table[] = {
+static const struct spi_device_id ssd130x_spi_id[] = {
 	/* ssd130x family */
 	{ "sh1106",  SH1106_ID },
 	{ "ssd1305", SSD1305_ID },
@@ -175,14 +174,14 @@ static const struct spi_device_id ssd130x_spi_table[] = {
 	{ "ssd1331", SSD1331_ID },
 	{ /* sentinel */ }
 };
-MODULE_DEVICE_TABLE(spi, ssd130x_spi_table);
-#endif
+MODULE_DEVICE_TABLE(spi, ssd130x_spi_id);
 
 static struct spi_driver ssd130x_spi_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.of_match_table = ssd130x_of_match,
 	},
+	.id_table = ssd130x_spi_id,
 	.probe = ssd130x_spi_probe,
 	.remove = ssd130x_spi_remove,
 	.shutdown = ssd130x_spi_shutdown,
-- 
2.39.5



