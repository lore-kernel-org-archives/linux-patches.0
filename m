Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1224B418A44;
	Thu, 30 Jul 2026 15:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425656; cv=none; b=oSpPqgh+co+LJZoLV3xBeltIMdqpeU+u0E9aqm6HuUV4t1w6kUqOL1Hs15WUUid4ElSN18w3Eitea5P6rc62ZB2/dXzqlW9PfwadXPAMkkwjcVPo0xOEE13CkNpy6dapEYFKH1kVMEx+xqwT7JFboSvL3pd/Q1TXHGodOqwYQWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425656; c=relaxed/simple;
	bh=L1b5lkIcePGqZ7g43l/DHPYcXzAj/mL9cQUXGa8HxUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzIxuHxeADuRAaMaZ0r4eVqZYm3Ga55s7iREkhEe8W35Neoeh2EsFWw3AW0y3R3ubRbnKT7FO3GcORTbzpgT5hNQ2xu0Z0UAKLl7XdiMcIg70jTK8epsNLQGiZCEawJ9y7q+GRGXDKDFPsHSri+98/a2TQCMieBlpahkjD9iULI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4HH3hHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4HH3hHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F891F000E9;
	Thu, 30 Jul 2026 15:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425655;
	bh=03KbpMwXycGD2QR2DRVnvGwIXTY6B47iRYM5H5CXL6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4HH3hHKKCy4+/03GasXz492y7mIXSnQrRQuWk3jclZJ1Ozk40WFrMcw2xcmYRWzG
	 IoeFaJE3hYz+hPQVxo7+69oZeM3qSBmFz+O+An/urC16njTGQ7EzcxTaCsQwOWcEKt
	 BF9pdtU+lb9bdWSu71ytbds8sfccF09A9uAi1BX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/602] hwmon: (gigabyte_waterforce) Stop device IO before calling hid_hw_stop
Date: Thu, 30 Jul 2026 16:08:50 +0200
Message-ID: <20260730141438.880467558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit ff0c5c53d08274e200b48a4d53aa078265e873cb ]

Calling hid_hw_stop() does not stop the device IO.
This results in a race condition between hid_input_report() and the point
immediately following the execution of hid_device_io_start() within
the driver probe function. If the probe operation fails after "io start"
has been initiated, this race condition will result in a UAF vulnerability.

Fix the problem by calling hid_device_io_stop() before calling
hid_hw_stop().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 42ac68e3d4ba0 ("hwmon: Add driver for Gigabyte AORUS Waterforce AIO coolers")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gigabyte_waterforce.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/gigabyte_waterforce.c b/drivers/hwmon/gigabyte_waterforce.c
index 27487e215bddff..4eea05f8b569c2 100644
--- a/drivers/hwmon/gigabyte_waterforce.c
+++ b/drivers/hwmon/gigabyte_waterforce.c
@@ -371,13 +371,15 @@ static int waterforce_probe(struct hid_device *hdev, const struct hid_device_id
 	if (IS_ERR(priv->hwmon_dev)) {
 		ret = PTR_ERR(priv->hwmon_dev);
 		hid_err(hdev, "hwmon registration failed with %d\n", ret);
-		goto fail_and_close;
+		goto fail_and_io_stop;
 	}
 
 	waterforce_debugfs_init(priv);
 
 	return 0;
 
+fail_and_io_stop:
+	hid_device_io_stop(hdev);
 fail_and_close:
 	hid_hw_close(hdev);
 fail_and_stop:
-- 
2.53.0



