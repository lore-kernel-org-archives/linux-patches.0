Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896AE3F8F4;
	Mon,  1 Apr 2024 16:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987629; cv=none; b=vCpFsuB1frV0Pd1i9ffUFvBzukzR7zEP22LHDZb3C+OxX3iIXwoH1gIklteHCMlW1wK+UB2LaqrehhjZJcuKKeOVAeHjlYRRZMYj7kt1z94AN7f7jeQNiBIhExSi9s3PQMBbpdzIGX9JlY+E5eCHw1+5RzrrWYQtv+tUSAHlKPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987629; c=relaxed/simple;
	bh=bUpQniQY+WCqj99SNow5l6ro2pf766d4bRlKyOwPxxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYL2bk1NvrZTz7EPVqZoq09ghXGYSyDM22J0pD6mhMQ3qgMoaCoQWCVchLfqAHIQSe7BnNljJE5qfDRZAJnrXIUkvpIgm8AGjggEgclf92r9jvyh2zLsxZujRgFkcybwiDT7o0KkOsqk8k2JCTKrcnnAuLP4bmmIk/g28DeJHng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Du0jWQmu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Du0jWQmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26D2C433F1;
	Mon,  1 Apr 2024 16:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987629;
	bh=bUpQniQY+WCqj99SNow5l6ro2pf766d4bRlKyOwPxxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Du0jWQmu+bkfaSBiq2D6YPvKiB1EF0SUJ0OZIqQ0ngp+4nDMOavvxEU8Sbtf9iC1i
	 fea3zO/CEOPT9KKYqU7ZBuKCY96E8ANWg6ZUn/F4SzGMvG4s6xaaqJAbuGH3NZEtcH
	 z3J7UpVBtRAgqobU44dX+uzDzwXqE6jmQme7Q+Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yongzhi Liu <hyperlyzcs@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.8 344/399] usb: misc: ljca: Fix double free in error handling path
Date: Mon,  1 Apr 2024 17:45:10 +0200
Message-ID: <20240401152559.440464997@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/usb/misc/usb-ljca.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/drivers/usb/misc/usb-ljca.c
+++ b/drivers/usb/misc/usb-ljca.c
@@ -518,8 +518,10 @@ static int ljca_new_client_device(struct
 	int ret;
 
 	client = kzalloc(sizeof *client, GFP_KERNEL);
-	if (!client)
+	if (!client) {
+		kfree(data);
 		return -ENOMEM;
+	}
 
 	client->type = type;
 	client->id = id;
@@ -535,8 +537,10 @@ static int ljca_new_client_device(struct
 	auxdev->dev.release = ljca_auxdev_release;
 
 	ret = auxiliary_device_init(auxdev);
-	if (ret)
+	if (ret) {
+		kfree(data);
 		goto err_free;
+	}
 
 	ljca_auxdev_acpi_bind(adap, auxdev, adr, id);
 
@@ -590,12 +594,8 @@ static int ljca_enumerate_gpio(struct lj
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
@@ -629,10 +629,8 @@ static int ljca_enumerate_i2c(struct ljc
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
@@ -669,10 +667,8 @@ static int ljca_enumerate_spi(struct ljc
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


