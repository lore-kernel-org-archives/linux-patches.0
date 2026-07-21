Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1EB43CEC8;
	Tue, 21 Jul 2026 21:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671178; cv=none; b=TtIbQbtLxHPC4OJZGKGinOMUCXbpJEHtCC6+PAHU68xjd4Mm1gY9Vlx+WvOExCkxV7KHBY8FilBQD9PoB6aCTCmiRVP5SWxe7npogkmiKufgCs4wYf6LWjuYCoz7hJGaCQOW0I/TJzxspQQfcifi7AGkAXR1Zi4v+fot9/t7flw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671178; c=relaxed/simple;
	bh=/ZuhthzIH3v/SCsx4s4eqkMWyuucn/I9i7gZ2Tyfuhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXU5Uj9q5hwOltevIXV4Gz3uDc7E4d3mN1JrPzE4xC+nNyE5ifXD8IQk+iWT/ZLmd5zznvmP4z+uAOlai+QhMqFhvir2njJVzqJ71r+FWWn9PFF4FJ5jqf53dO0U6Quzy/smaXFBATsq/cbHuK94RgbWxsvQd6QU5ZHcBxlSZrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAdybTgV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAdybTgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF471F000E9;
	Tue, 21 Jul 2026 21:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671177;
	bh=de5j18IRfdA25+/ga+0/m0WPXt6Jl/cO/rbB/a52m7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAdybTgVNHoGx7J094FWe37NoMr1MrWvLp2Z+/JtD5Jp+ML5QNlvzwY6Sh4dgnAzt
	 oqoY59Zt1o5j51J9jbQpBMi81IaDqUg0kP7KJ754AndRpW+zfZlY+NHQ6PSwnzuOxJ
	 4gGzUyY2u/V4gG0R4RvflyewqTHsVvHygdkmV5W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 148/843] USB: ulpi: fix memory leak on registration failure
Date: Tue, 21 Jul 2026 17:16:23 +0200
Message-ID: <20260721152409.341458811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 8af6812795869a66e9b26044f455b13deecdb69c upstream.

The allocated device name is never freed on early ULPI device
registration failures.

Fix this by initialising the device structure earlier and releasing the
initial reference whenever registration fails.

Fixes: 289fcff4bcdb ("usb: add bus type for USB ULPI")
Cc: stable <stable@kernel.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260608145803.69360-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -239,28 +239,24 @@ static int ulpi_register(struct device *
 	ulpi->dev.parent = dev; /* needed early for ops */
 	ulpi->dev.bus = &ulpi_bus;
 	ulpi->dev.type = &ulpi_dev_type;
+
+	device_initialize(&ulpi->dev);
+
 	dev_set_name(&ulpi->dev, "%s.ulpi", dev_name(dev));
 
 	ACPI_COMPANION_SET(&ulpi->dev, ACPI_COMPANION(dev));
 
 	ret = ulpi_of_register(ulpi);
-	if (ret) {
-		kfree(ulpi);
+	if (ret)
 		return ret;
-	}
 
 	ret = ulpi_read_id(ulpi);
-	if (ret) {
-		of_node_put(ulpi->dev.of_node);
-		kfree(ulpi);
+	if (ret)
 		return ret;
-	}
 
-	ret = device_register(&ulpi->dev);
-	if (ret) {
-		put_device(&ulpi->dev);
+	ret = device_add(&ulpi->dev);
+	if (ret)
 		return ret;
-	}
 
 	dev_dbg(&ulpi->dev, "registered ULPI PHY: vendor %04x, product %04x\n",
 		ulpi->id.vendor, ulpi->id.product);
@@ -289,9 +285,10 @@ struct ulpi *ulpi_register_interface(str
 	ulpi->ops = ops;
 
 	ret = ulpi_register(dev, ulpi);
-	if (ret)
+	if (ret) {
+		put_device(&ulpi->dev);
 		return ERR_PTR(ret);
-
+	}
 
 	return ulpi;
 }


