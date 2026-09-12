Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB58D43BDDE;
	Sat, 12 Sep 2026 11:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213556; cv=none; b=S8HhXRDDiMcnwPAUX8rWTtZ65M61xkQPgc7y/+vYvO3CJEXklOR5ZYbev8RJiRJcGqzN7KFuzjnEW3YJbZfj/H5pm25STqbyWvFS2d3Nly4pyPCoa8pZZSyimWbJW8JnMg7NWvlsYgGJRkTSA5L4Qs9s8PS9HgPDzBzTefOjEZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213556; c=relaxed/simple;
	bh=cUtIwyip7TLtbvQyBKYAykXKbjF6NWdtuJgvQPGwxVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJS1sfmYgVHwf4sVTxeI3aT9yvwZtCLWRdz/FiVNSwQvZXFytEQ9q+W1gas9O55F7EWa6teVPLnJMJ7+hHiS4v26kG5B4ph0mnmG/enu/W6PMRUaeVoq174pxML/ztWDAHbJx1W97iOxkDytG1VNAE1Aiki8UmVme0okbcoMHQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sy0x/FsX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sy0x/FsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854841F000FF;
	Sat, 12 Sep 2026 11:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213555;
	bh=cZ7p0Y71qtXroDQcBXa/YDy/2XQjZ5pNK+jk168zxt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sy0x/FsXFJh3Nl1IoAgdqnDVDvmE7bneE9gVc5KIxHbwzkkJOaHkFS8iWBoZLFkU7
	 7dtKc0NN3tcuUeESCgxUgzTbgIiuSYe9YGfULW4NwTXHFoSssoeCR19mA/k4dL4DD7
	 W0zwjr8a4bR6Tb6NYXF2vEV29/wDB011FDhsqAks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rupesh Majhi <zoone.rupert@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 0147/1376] iio: pressure: dps310: fix NULL pointer dereference on ACPI probe
Date: Sat, 12 Sep 2026 08:42:53 +0200
Message-ID: <20260912065610.829107150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -845,7 +845,6 @@ static const struct iio_info dps310_info
 
 static int dps310_probe(struct i2c_client *client)
 {
-	const struct i2c_device_id *id = i2c_client_get_device_id(client);
 	struct dps310_data *data;
 	struct iio_dev *iio;
 	int rc;
@@ -858,7 +857,7 @@ static int dps310_probe(struct i2c_clien
 	data->client = client;
 	mutex_init(&data->lock);
 
-	iio->name = id->name;
+	iio->name = DPS310_DEV_NAME;
 	iio->channels = dps310_channels;
 	iio->num_channels = ARRAY_SIZE(dps310_channels);
 	iio->info = &dps310_info;


