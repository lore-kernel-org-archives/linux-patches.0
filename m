Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A871C0DE7;
	Mon,  1 Apr 2024 16:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989162; cv=none; b=VbIf94MVmdV+NqZUDbFpwUnWXxA9bNdvrDLK2gAjpcqsAqvjNS7mDI2//wxlDU92bolhLICsgjZqJ6qTAWlGN7zRXlmVM7gDwvnxEsQ1aXuYqPYkpM3y2trHS9N0mUBghaOOmsAYrd07HAyXeeAuOGomfuUs4fCbJT4qRaRugO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989162; c=relaxed/simple;
	bh=Y5IWac73Ru1akYpVu+Ls7wIx7GVHilQFWgY43zcSOKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrfcIDEZqYHvfULDgD9KRxYhtnTcfoB8gIePc7RiOXW4DOwUn+DvUGsEEfM0yXUqxxbFnwMO1I6MBEdbyo8/IjNWlDV8WVKHSsdzVRCTxHGqQNJWVPX8rTXmWPqLxP01d5SmivFA+mqxQBJFcokxwSlO/F5ufNqeTQkdaFKe18I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVdhLc/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVdhLc/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58447C433C7;
	Mon,  1 Apr 2024 16:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989161;
	bh=Y5IWac73Ru1akYpVu+Ls7wIx7GVHilQFWgY43zcSOKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVdhLc/yZxqACzDjQ9faMMKSErex0KXrimemcYHoXPI2AYVVa/tx8LdaGUUrlXljc
	 Dah8Bd4ndKdN/+klaRmyqmB3+FnRyaRcqB73+fKmJI9owSVKeStGhV0t/leREIbWaN
	 Z6dNxN/nm4RokdEwQ8RGJQX3e/uzq4yKZDIeTYl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yongzhi Liu <hyperlyzcs@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.7 382/432] usb: misc: ljca: Fix double free in error handling path
Date: Mon,  1 Apr 2024 17:46:09 +0200
Message-ID: <20240401152604.692690072@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongzhi Liu <hyperlyzcs@gmail.com>

commit 7c9631969287a5366bc8e39cd5abff154b35fb80 upstream.

When auxiliary_device_add() returns error and then calls
auxiliary_device_uninit(), callback function ljca_auxdev_release
calls kfree(auxdev->dev.platform_data) to free the parameter data
of the function ljca_new_client_device. The callers of
ljca_new_client_device shouldn't call kfree() again
in the error handling path to free the platform data.

Fix this by cleaning up the redundant kfree() in all callers and
adding kfree() the passed in platform_data on errors which happen
before auxiliary_device_init() succeeds .

Fixes: acd6199f195d ("usb: Add support for Intel LJCA device")
Cc: stable <stable@kernel.org>
Signed-off-by: Yongzhi Liu <hyperlyzcs@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240311125748.28198-1-hyperlyzcs@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/usb-ljca.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/misc/usb-ljca.c b/drivers/usb/misc/usb-ljca.c
index 35770e608c64..2d30fc1be306 100644
--- a/drivers/usb/misc/usb-ljca.c
+++ b/drivers/usb/misc/usb-ljca.c
@@ -518,8 +518,10 @@ static int ljca_new_client_device(struct ljca_adapter *adap, u8 type, u8 id,
 	int ret;
 
 	client = kzalloc(sizeof *client, GFP_KERNEL);
-	if (!client)
+	if (!client) {
+		kfree(data);
 		return -ENOMEM;
+	}
 
 	client->type = type;
 	client->id = id;
@@ -535,8 +537,10 @@ static int ljca_new_client_device(struct ljca_adapter *adap, u8 type, u8 id,
 	auxdev->dev.release = ljca_auxdev_release;
 
 	ret = auxiliary_device_init(auxdev);
-	if (ret)
+	if (ret) {
+		kfree(data);
 		goto err_free;
+	}
 
 	ljca_auxdev_acpi_bind(adap, auxdev, adr, id);
 
@@ -590,12 +594,8 @@ static int ljca_enumerate_gpio(struct ljca_adapter *adap)
 		valid_pin[i] = get_unaligned_le32(&desc->bank_desc[i].valid_pins);
 	bitmap_from_arr32(gpio_info->valid_pin_map, valid_pin, gpio_num);
 
-	ret = ljca_new_client_device(adap, LJCA_CLIENT_GPIO, 0, "ljca-gpio",
+	return ljca_new_client_device(adap, LJCA_CLIENT_GPIO, 0, "ljca-gpio",
 				     gpio_info, LJCA_GPIO_ACPI_ADR);
-	if (ret)
-		kfree(gpio_info);
-
-	return ret;
 }
 
 static int ljca_enumerate_i2c(struct ljca_adapter *adap)
@@ -629,10 +629,8 @@ static int ljca_enumerate_i2c(struct ljca_adapter *adap)
 		ret = ljca_new_client_device(adap, LJCA_CLIENT_I2C, i,
 					     "ljca-i2c", i2c_info,
 					     LJCA_I2C1_ACPI_ADR + i);
-		if (ret) {
-			kfree(i2c_info);
+		if (ret)
 			return ret;
-		}
 	}
 
 	return 0;
@@ -669,10 +667,8 @@ static int ljca_enumerate_spi(struct ljca_adapter *adap)
 		ret = ljca_new_client_device(adap, LJCA_CLIENT_SPI, i,
 					     "ljca-spi", spi_info,
 					     LJCA_SPI1_ACPI_ADR + i);
-		if (ret) {
-			kfree(spi_info);
+		if (ret)
 			return ret;
-		}
 	}
 
 	return 0;
-- 
2.44.0



