Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEE41A6192;
	Tue, 30 Jul 2024 17:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359185; cv=none; b=YjbGwBtX7fDp6T48VeiCzfMIREkEyijOBGCuHdj41/h9alginM6cfAoZWlwndf2tKa6ea8oKrvrJqHRyb9BMP4dj9s4VggGbgbsGVtBHghrUw2VnTJtS7fHJyThbjNaWy4RK20dxfipbl7ZjdBYPyr48MYXadQQAwJxegK5NZYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359185; c=relaxed/simple;
	bh=+96flJv0J44mLervH6cz0kMzOMYqLOE3nptgu1oa+Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=trMuZudS+yOpTTIaR9WmOOJmFvikxqGqmqfzP63sGtFqYwbGa6FrptvYeZkqEegGGJPnMpsLhZ54NE6pcAxG7LqDVqhkg4uqI9ZWa5BvnSZ15xqhV5ItEXdZWiKgxjnuEeNoQBKUefPVCGnlhoo41bRkKrIkrD4qjWV8QgNAVDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiTOioP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiTOioP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A62C32782;
	Tue, 30 Jul 2024 17:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359184;
	bh=+96flJv0J44mLervH6cz0kMzOMYqLOE3nptgu1oa+Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiTOioP2qRyJFs34/zF3os85L+tnYJXh8QInBOrqly7yTUlTglJB4igVmIL0VWYNj
	 g5BbiOf9EqydOxfVpVfpSRowdgbbXDwqP0CpuJwqo555/DvIGARQgve0PbZvgFQsYB
	 R7/SHbRdP4TOjsGnHKHBCMAff8GDnwqiL7gPTZVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 439/809] eeprom: ee1004: Call i2c_new_scanned_device to instantiate thermal sensor
Date: Tue, 30 Jul 2024 17:45:15 +0200
Message-ID: <20240730151742.041311907@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 249b4deaff71cfc6ac9a8e436af876be6d84052b ]

Instantiating a device by calling i2c_new_client_device() assumes that the
device is not already instantiated. If that is not the case, it will return
an error and generate a misleading kernel log message.

i2c i2c-0: Failed to register i2c client jc42 at 0x18 (-16)

This can be reproduced by unloading the ee1004 driver and loading it again.

Avoid this by calling i2c_new_scanned_device() instead, which returns
silently if a device is already instantiated or does not exist.

Fixes: 393bd1000f81 ("eeprom: ee1004: add support for temperature sensor")
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20240629173716.20389-1-linux@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/ee1004.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/eeprom/ee1004.c b/drivers/misc/eeprom/ee1004.c
index 21feebc3044c3..71ca66d1df82c 100644
--- a/drivers/misc/eeprom/ee1004.c
+++ b/drivers/misc/eeprom/ee1004.c
@@ -185,6 +185,8 @@ BIN_ATTRIBUTE_GROUPS(ee1004);
 static void ee1004_probe_temp_sensor(struct i2c_client *client)
 {
 	struct i2c_board_info info = { .type = "jc42" };
+	unsigned short addr = 0x18 | (client->addr & 7);
+	unsigned short addr_list[] = { addr, I2C_CLIENT_END };
 	u8 byte14;
 	int ret;
 
@@ -193,9 +195,7 @@ static void ee1004_probe_temp_sensor(struct i2c_client *client)
 	if (ret != 1 || !(byte14 & BIT(7)))
 		return;
 
-	info.addr = 0x18 | (client->addr & 7);
-
-	i2c_new_client_device(client->adapter, &info);
+	i2c_new_scanned_device(client->adapter, &info, addr_list, NULL);
 }
 
 static void ee1004_cleanup(int idx, struct ee1004_bus_data *bd)
-- 
2.43.0



