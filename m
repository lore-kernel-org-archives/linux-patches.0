Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B2046C4DA;
	Tue, 21 Jul 2026 18:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657967; cv=none; b=LZRyzmrzXHzH3HGx1R1RlRqF8hS4F9hcgCWjrkdwLDG3wpOQeSviLMgOu+qjaX90Hrvua8UIdjUj4sV9xjF5A0mKXS2A5qfW1qv6jqIFfsSO+aln4Nim+7OPvY7K+7p4hDKS19woPd3BD4kKiay7blh7AcxqegBA3y/c024p/io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657967; c=relaxed/simple;
	bh=dWXcEK7BIVhNW072ghhP6l+DaIvYfq5Z5Dx4yskxqjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XL1MmugnrKf5mAXEXHc5pQ/2QBW4SMxEtWMjxnQCDP0vwZXCaW0qhhmtO4hyzp2hD2BrPGtQ/ixWCmEvs9edTuNJD4AkvV86/5HW0/cL3dr9V/7csS6g0+GXSbkFcFlV88QlNwQvS8ILxLOahOaDMxvEmfZZC7feC3f8zAirhzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndtwuJ05; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndtwuJ05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA411F000E9;
	Tue, 21 Jul 2026 18:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657965;
	bh=qW9WXsa4afZXKqLZRN0CbUIc0IqlKDOmzMNksubRk7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ndtwuJ05b0Mtb1wMIE7bxTFkKQjPROuQBamPOry8qlWdrZzIxvPt9vHxQDCqrDWc9
	 BGBrx1Y3vw4dkSzAKNZUz6wSRzseuJMbOEtzobGaTIziguaXO5gNs0yGCyN1ZLq6Nc
	 k+1CPXGvRkx/RgDyI4c1o05ieF6ugl1p+G4vawT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0964/1611] hwmon: adm1275: Prevent reading uninitialized stack
Date: Tue, 21 Jul 2026 17:18:00 +0200
Message-ID: <20260721152537.079103779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bc2a6a07dc3e2e..43baa5ded35e50 100644
--- a/drivers/hwmon/pmbus/adm1275.c
+++ b/drivers/hwmon/pmbus/adm1275.c
@@ -512,7 +512,7 @@ static int adm1275_enable_vout_temp(struct adm1275_data *data,
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



