Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1590032D7F8;
	Sat, 12 Sep 2026 14:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221627; cv=none; b=BVtQweQC+o7DuEJ46LIvIEaUfS+J7rY2xDxG1o5DCKfgA9kk64gwGgyCeIxKfNsVQ+4ROC/PhSd44Bmq3nx4KrGUcGJMPZBPmIJgZ/79el+07OcU3guIi2tbGxsuMknOXWoR6rucnbuhplU+b6NWTuYkDFu3iYr8hKN/Z6Pj+M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221627; c=relaxed/simple;
	bh=ZB4qwuiCTgCTdYhPcPE1cKwBdSk06e6jJrhHgBYBHUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnsKi3hI8ySIiskpipG/TnYb5fbl4Y8QnIkiRc2qRS0twmklFhI6FLVoYBYXiAr0xB02bwmxSCRHiCVwyxjZmNGFQl8qmokWgA1lCGEh/HSDkjnjWnjk6e0in5k6KLZEF7Q7KwDvNH8Jq94vxrYYEM8a7u1o7vRhuRbL8VkZYnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Axzwocva; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Axzwocva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ED41F000FF;
	Sat, 12 Sep 2026 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221624;
	bh=/g9dD5dy39PE+JQrp+uKWlK6pD6RWuRPuh4mpUYs4po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Axzwocva5iGf14CBbf59dYwMee1Fjq+yz8OliO+tLiZZclvBbLhoLGY16sfaiQr8i
	 v+CYiEFfqRcoa5iJlDuhT0WY4wyB2A2lzz0Fu4OYgy7lb2FWJ6duu3zKvncm1l6PVS
	 JbFounv8hS/x8BkZtT7telZ7JrNZSEocHMErM+70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rupesh Majhi <zoone.rupert@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0420/1424] iio: pressure: dps310: fix NULL pointer dereference on ACPI probe
Date: Sat, 12 Sep 2026 08:47:32 +0200
Message-ID: <20260912065616.688308505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Rupesh Majhi <zoone.rupert@gmail.com>

commit 26e9213898fc949923188ef0aeea31fc87708836 upstream.

When the device is enumerated through its ACPI HID (IFX3100),
i2c_client_get_device_id() returns NULL: the ACPI-derived client name
does not match the driver's i2c_device_id table. dps310_probe() then
dereferences that NULL pointer in "iio->name = id->name" and crashes the
kernel during probe.

The IIO device name is always "dps310", so set it directly and drop the
now-unused device-id lookup.

Fixes: 72ff282819d0 ("iio: pressure: dps310: Add ACPI HID table")
Cc: stable@vger.kernel.org
Signed-off-by: Rupesh Majhi <zoone.rupert@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/dps310.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/pressure/dps310.c
+++ b/drivers/iio/pressure/dps310.c
@@ -830,7 +830,6 @@ static const struct iio_info dps310_info
 
 static int dps310_probe(struct i2c_client *client)
 {
-	const struct i2c_device_id *id = i2c_client_get_device_id(client);
 	struct dps310_data *data;
 	struct iio_dev *iio;
 	int rc;
@@ -843,7 +842,7 @@ static int dps310_probe(struct i2c_clien
 	data->client = client;
 	mutex_init(&data->lock);
 
-	iio->name = id->name;
+	iio->name = DPS310_DEV_NAME;
 	iio->channels = dps310_channels;
 	iio->num_channels = ARRAY_SIZE(dps310_channels);
 	iio->info = &dps310_info;


