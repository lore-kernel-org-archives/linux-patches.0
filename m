Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1190D37E310;
	Tue, 21 Jul 2026 22:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674005; cv=none; b=L5iF+Mt3giVJGur7MFydcDEo/Bn3n78D3mwZxsVl3GFUo8d2gI38eNHYu9AZvDXeqe+SRiIEjfN9hZbVLdN45TXYbz03NpPnmaRVT4QjpS4WCAST1US2TZdu1okGS7Czxjqs9gYyn31OPA7GhXZSiqZMMQIhT+2rwaaRRSPkPms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674005; c=relaxed/simple;
	bh=xPy0LWOoeT1CdPabA2CnoJ+Jxwb5+K8ifg7dQJCWjBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twU12Jln/jsQ38LhS00fsrN4vf1K2oB2eLDmdY1nmn1SFMij8mBZGSzfM0kIXRV171V88VEF1JN/ROjLDDddSIsacDae7Ldd5K+3aU46UaUGzSbbKdTBRt1RGFIAgBDBysY/35VcCzWJZSZfhAl39WVuM/AURGmT/na11J/KtFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULyHslQ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULyHslQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC9C1F000E9;
	Tue, 21 Jul 2026 22:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674003;
	bh=FBL7qLkfQpfGk8yIG+SjOaGf77GvnirhDpL0L8Jm/Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ULyHslQ8bOMtfCY7Hef81wPXWvGpF4Koez1GWn+/QFy05pJo2DvgDDIkv8DxTgCAt
	 3iBTSAelyj0b7ICMgwCubR1kELLVo7cOTxYj/QjEH0KqZToujAFD5XCK3vGpmz/l2n
	 9iouyK7lYbMKW7I/x/t87XmGxeWDK3xbYvVFUlX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 377/699] hwmon: adm1275: Prevent reading uninitialized stack
Date: Tue, 21 Jul 2026 17:22:16 +0200
Message-ID: <20260721152404.197800164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c0618205758e93..71233e04b3fcb0 100644
--- a/drivers/hwmon/pmbus/adm1275.c
+++ b/drivers/hwmon/pmbus/adm1275.c
@@ -484,7 +484,7 @@ static int adm1275_enable_vout_temp(struct i2c_client *client, int config)
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



