Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3871BCA4B;
	Tue, 17 Jun 2025 16:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179539; cv=none; b=GcmGPjn8CCl/4TSqSULrJVwYBEsRaxxFg+xEQW8AE46R62ZsE4+lLYHUCcXZD9APRGvHLaapT8JcWxwVNGh6IQ09yxVUnB4gEvvu+z3bBIZw8j/gxSnGvXERIaEo4WV6oTAmzTVEMpbL1EnQFuQSfymbPsYLEfr51WqfqpBJPRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179539; c=relaxed/simple;
	bh=zf2G9YreUnqGS8NHdy3HGBrOB6VBioSSbkrEWcQiMP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnZS7k71EgNG2qBCixbV9YD5RM9xnp6G5bWj0XLC/09QYJGX5LXWwK0ReKTbUW8mdJgnruBp0lUQpQb0K8KH5tsUdHgigHFVK3RToWR79bcBm1LM8dwTeVIBZSkph2yZzGDNt0/i0aB2pKJJ4x8ROSJjTglSd1DXxyAxYdWODVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsuZIDxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsuZIDxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AED8C4CEE3;
	Tue, 17 Jun 2025 16:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179539;
	bh=zf2G9YreUnqGS8NHdy3HGBrOB6VBioSSbkrEWcQiMP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsuZIDxxULChsw3xvUGOmtX/zLh3+68BydQ6v+2iodMd2lf8/SZLWgKqbaxm0MHML
	 gMNEQobGVI6oLt/wy/2OfOF0nIT91ey9fqyWEvUajFG8fgTZRvBdN5ztP+mteV4iTJ
	 YuH/94z3zBh2Jl6fnSZYeZA6fkLv+Z8IBD71EeKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.15 777/780] usb: misc: onboard_usb_dev: fix build warning for CONFIG_USB_ONBOARD_DEV_USB5744=n
Date: Tue, 17 Jun 2025 17:28:05 +0200
Message-ID: <20250617152523.150202935@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 662a9ece32add94469138ae66999ee16cb37a531 upstream.

When the USB5744 option is disabled, the onboard_usb driver warns about
unused functions:

drivers/usb/misc/onboard_usb_dev.c:358:12: error: 'onboard_dev_5744_i2c_write_byte' defined but not used [-Werror=unused-function]
  358 | static int onboard_dev_5744_i2c_write_byte(struct i2c_client *client, u16 addr, u8 data)
      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/usb/misc/onboard_usb_dev.c:313:12: error: 'onboard_dev_5744_i2c_read_byte' defined but not used [-Werror=unused-function]
  313 | static int onboard_dev_5744_i2c_read_byte(struct i2c_client *client, u16 addr, u8 *data)
      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Extend the #ifdef block a little further to cover all of these functions.
Ideally we'd use use if(IS_ENABLED()) instead, but that doesn't currently
work because the i2c_transfer() and i2c_smbus_write_word_data() function
declarations are hidden  when CONFIG_I2C is disabled.

Fixes: 1143d41922c0 ("usb: misc: onboard_usb_dev: Fix usb5744 initialization sequence")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20250523120947.2170302-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/onboard_usb_dev.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/onboard_usb_dev.c
+++ b/drivers/usb/misc/onboard_usb_dev.c
@@ -310,6 +310,7 @@ static void onboard_dev_attach_usb_drive
 		pr_err("Failed to attach USB driver: %pe\n", ERR_PTR(err));
 }
 
+#if IS_ENABLED(CONFIG_USB_ONBOARD_DEV_USB5744)
 static int onboard_dev_5744_i2c_read_byte(struct i2c_client *client, u16 addr, u8 *data)
 {
 	struct i2c_msg msg[2];
@@ -388,7 +389,6 @@ static int onboard_dev_5744_i2c_write_by
 
 static int onboard_dev_5744_i2c_init(struct i2c_client *client)
 {
-#if IS_ENABLED(CONFIG_USB_ONBOARD_DEV_USB5744)
 	struct device *dev = &client->dev;
 	int ret;
 	u8 reg;
@@ -417,10 +417,13 @@ static int onboard_dev_5744_i2c_init(str
 		return dev_err_probe(dev, ret, "USB Attach with SMBus command failed\n");
 
 	return ret;
+}
 #else
+static int onboard_dev_5744_i2c_init(struct i2c_client *client)
+{
 	return -ENODEV;
-#endif
 }
+#endif
 
 static int onboard_dev_probe(struct platform_device *pdev)
 {


