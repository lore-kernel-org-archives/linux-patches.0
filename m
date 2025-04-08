Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5268224F6;
	Tue,  8 Apr 2025 11:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110983; cv=none; b=bpawmqG8Lf11rI8tWfZtTx/8f7aSTA5itCalndh3FkroRPwoOrLiHd6MyuW7/s5rwhjDQ/W0socuS9NUPZCzaphsWC5nRrHAO+Pb4DichHuaG5EOyhTu3CAy1WtF5uVtKJh3c2p+luKKxtusyKGfaXolvfD9Bb5TyldRHWsl1r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110983; c=relaxed/simple;
	bh=74Y/SBMDBAPa8VMTw7Fk0RsX54Nrtrgf56/DOHeuIMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uV7tS0FvQE/kNWinqp369EkRdqmjjspdHs3D6RnunTdtpqv/m85ZQa6L4LDNqiqjCFyUEBRN5Kl1cc/+WCNUX0ESNFl8DWx9pa+EotUk0lfWrLWV39Ekb89NLC/rkafwgTA4GUjzPTa+3rz1GtTF80kPH3PlMuAo0BX/+UGmw3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+07Alkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+07Alkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0284EC4CEEA;
	Tue,  8 Apr 2025 11:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110983;
	bh=74Y/SBMDBAPa8VMTw7Fk0RsX54Nrtrgf56/DOHeuIMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+07AlkjSjeiP9hOGrYzw4dl2Hj9Z0bZBPZLA11pQUTQrLfWA3is0pKJ3GFIhRl7v
	 d+7DaZQx1GEFdzz0qu3YJI7B7gkrW/b2mGLJe9+AMtDP9QTF+3vk6fHyWXMD1U/uDl
	 Og8pzbF7jBuB/eYk6sEKmnGDi28cw3HX8DEpmADs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 267/731] drm/ssd130x: Set SPI .id_table to prevent an SPI core warning
Date: Tue,  8 Apr 2025 12:42:44 +0200
Message-ID: <20250408104920.490566677@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 08334be386946..7c935870f7d2a 100644
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



