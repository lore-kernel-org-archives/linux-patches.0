Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9D41CFB2;
	Tue, 14 May 2024 11:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687558; cv=none; b=qM1YJpKIgdWkjRP2mqgOSamcnR0U1ZZOH2i+2Ulz0YWzG01icJ09VWnKZ9SfEOSJ90y7tFHoTitEysy33DnwdWCV/AWtrH4D/bc+F2DpmdY9W57grcWgF7UY+338VsuzhRwluRdKR3x8aw66uhlrdAAgiUxgnJpV5DTQdgWIPf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687558; c=relaxed/simple;
	bh=1F/suXyLQMAhd+XoCV7imzXnSCdRqmcvI0lwg9QoCBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3SLxjmWfUDzk6cGGz3fieX2Y8ezCZcgFydWD4yCxSktyn4pdsfDUgeWmZycBI4jZJPPad2j0qblDbQiFovuoOrOI5KaCRskCtnnG8U1i18V8dCBTYYh6x2yV3DA5wZrj23S8Ng8D6C78V5zbWR1Dbh8qtjTdyWwnBdiGpaUg9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fbtd+wE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fbtd+wE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74212C2BD10;
	Tue, 14 May 2024 11:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687557;
	bh=1F/suXyLQMAhd+XoCV7imzXnSCdRqmcvI0lwg9QoCBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fbtd+wE6nmxZjIfOSh/XhQP0W2inM9uYQPnvMHeYpWYVFApAVs7D37KRH5x+zuV3W
	 JvBfpN0MJtLJdnqQCksG+x1A8B2nHoJhX42JKuY1kXgo67QFkPUZL3JCwc8nUWr4v2
	 CpZBdFc9Ow8z/ufzYI8Zl7UMOgopI2aRLVqMZSAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/168] eeprom: at24: Probe for DDR3 thermal sensor in the SPD case
Date: Tue, 14 May 2024 12:18:26 +0200
Message-ID: <20240514101007.000292685@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit caba40ec3531b0849f44502a03117796e8c9f4a1 ]

The DDR3 SPD data structure advertises the presence of a thermal
sensor on a DDR3 module in byte 32, bit 7. Let's use this information
to explicitly instantiate the thermal sensor I2C client instead of
having to rely on class-based I2C probing.

The temp sensor i2c address can be derived from the SPD i2c address,
so we can directly instantiate the device and don't have to probe
for it. If the temp sensor has been instantiated already by other
means (e.g. class-based auto-detection), then the busy-check in
i2c_new_client_device will detect this.

Note: Thermal sensors on DDR4 DIMM's are instantiated from the
      ee1004 driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/68113672-3724-44d5-9ff8-313dd6628f8c@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f42c97027fb7 ("eeprom: at24: fix memory corruption race condition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/at24.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index b100bbc888668..65a7517c031a7 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -585,6 +585,31 @@ static unsigned int at24_get_offset_adj(u8 flags, unsigned int byte_len)
 	}
 }
 
+static void at24_probe_temp_sensor(struct i2c_client *client)
+{
+	struct at24_data *at24 = i2c_get_clientdata(client);
+	struct i2c_board_info info = { .type = "jc42" };
+	int ret;
+	u8 val;
+
+	/*
+	 * Byte 2 has value 11 for DDR3, earlier versions don't
+	 * support the thermal sensor present flag
+	 */
+	ret = at24_read(at24, 2, &val, 1);
+	if (ret || val != 11)
+		return;
+
+	/* Byte 32, bit 7 is set if temp sensor is present */
+	ret = at24_read(at24, 32, &val, 1);
+	if (ret || !(val & BIT(7)))
+		return;
+
+	info.addr = 0x18 | (client->addr & 7);
+
+	i2c_new_client_device(client->adapter, &info);
+}
+
 static int at24_probe(struct i2c_client *client)
 {
 	struct regmap_config regmap_config = { };
@@ -778,6 +803,10 @@ static int at24_probe(struct i2c_client *client)
 		return -ENODEV;
 	}
 
+	/* If this a SPD EEPROM, probe for DDR3 thermal sensor */
+	if (cdata == &at24_data_spd)
+		at24_probe_temp_sensor(client);
+
 	pm_runtime_idle(dev);
 
 	if (writable)
-- 
2.43.0



