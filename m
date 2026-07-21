Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D188128641E;
	Tue, 21 Jul 2026 19:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663113; cv=none; b=CP6UJWrysLC+9tDN4NQscbROPORkvoMJ92owXv+cLifr5v8YWEWKfHqHFPQYsjI5iJPqyU3z48QhNfgsElwsieSdeBTtD4uXS82oRAVtsT9l9bbhfobx7qP8YbRqyAew6xx3x2O7iiyml9VZftaLFKk9YT6bdrxfGXTPcR1p8Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663113; c=relaxed/simple;
	bh=gKzL4eJ3uEv8SL/Q5e93f/zjxm1uJEe/9tlzItXPM1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=De18Z3rZI5JKny4ca5ooE1nAvADpMdeQGKxHGqcjs5bBd76BYjhIbJxWlnzsUGdaxH7LD7UKwopBPiy28e3U/Q1G9OBZ+HiGbcbifhJDQmiIBwjH+9QTXHOkBOlhGlvse8k6zoAPCBiaX1H96blFMgvUkaNA0g4LGl1WdJHeSFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esFhVc5A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esFhVc5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444911F00A3A;
	Tue, 21 Jul 2026 19:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663112;
	bh=pXlmxHPjpDPP0JNZcOabywRiMwWHHtamBqj0No5l/DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=esFhVc5ACPMcPdsnwKUekAofpbh5xWjMmgjrnSOXb6j52cR2n65LSWYCsLT/dAM3S
	 BbOt8j1khEKsmUrTr6EVX0fiBwKrJ5aAHR3SfaAmVN61rvmc/SAh4YPNzpx31i83mU
	 jUHSlbY9npDl2UvLZFaTur+DbOlhhJJcAwVZgRpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0701/1276] hwmon: adm1275: Prevent reading uninitialized stack
Date: Tue, 21 Jul 2026 17:19:04 +0200
Message-ID: <20260721152501.784468357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 553f9517813912a5ab661af5504485d96824a61c ]

While adding support for the ROHM BD127X0 hot-swap controllers, sashiko
reported an error in device-name comparison, which can lead to reading
uninitialized stack memory.

Quoting Sashiko:

This is a pre-existing issue, but I noticed that just before this block in
adm1275_probe(), there might be an out-of-bounds stack read:

    ret = i2c_smbus_read_block_data(client, PMBUS_MFR_MODEL, block_buffer);
    if (ret < 0) { ... }
    for (mid = adm1275_id; mid->name[0]; mid++) {
            if (!strncasecmp(mid->name, block_buffer, strlen(mid->name)))
                    break;
    }

Since i2c_smbus_read_block_data() reads up to 32 bytes into the
uninitialized stack array block_buffer without appending a null
terminator, strncasecmp() could read past the valid bytes returned in ret.

For example, if the device returns a shorter string like "adm12", checking
it against "adm1275" up to the length of "adm1275" will continue reading
into uninitialized stack bounds.

Prevent reading uninitialized memory by zeroing the stack array.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: 87102808d039 ("hwmon: (pmbus/adm1275) Validate device ID")
Link: https://lore.kernel.org/r/c8ad38e0cdb347261c6245de2b7965e747f28d22.1782458224.git.mazziesaccount@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/adm1275.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/adm1275.c b/drivers/hwmon/pmbus/adm1275.c
index 59ffc08289bdf7..622d0cdde001d8 100644
--- a/drivers/hwmon/pmbus/adm1275.c
+++ b/drivers/hwmon/pmbus/adm1275.c
@@ -509,7 +509,7 @@ static int adm1275_enable_vout_temp(struct adm1275_data *data,
 static int adm1275_probe(struct i2c_client *client)
 {
 	s32 (*config_read_fn)(const struct i2c_client *client, u8 reg);
-	u8 block_buffer[I2C_SMBUS_BLOCK_MAX + 1];
+	u8 block_buffer[I2C_SMBUS_BLOCK_MAX + 1] = {0};
 	int config, device_config;
 	int ret;
 	struct pmbus_driver_info *info;
-- 
2.53.0



