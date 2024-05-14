Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABADB134CDC;
	Tue, 14 May 2024 10:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684368; cv=none; b=r32PWdej+50YdkaZJcyz5Rt5jWurkDKgbSktRH2Ri77hP5TBEK61I0U671OvWPFy4nkwwKnm0DEIygb+ip7PWiUgLjwL13KPcplq2oeEBoMFvpeZ3wfc2Q/EYr8wcwlIyNyuw8n3DxMHKVSYbQwwVrxMufhUcIr5oW+eht0OSXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684368; c=relaxed/simple;
	bh=YaAcgaFLiZGwaOqdJ+Dw8e8vrMncJuOAZCYSFu/RwlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I81Q8/XrliCZRpcJdHoRqJOCsg+9ITGoJli2En+SpVomqNK/RnvD0WYbQgcbZ6Jh4HX0OHPqAuPnBTwNRnTI3aaG6WHUg8ZcpVa+Uu6vZ4oiCIFkz8tHxG5bgyKjQZm5hOVE6SzD2hNJgyLPDSUB/9oyhv5uCHpacnUPBb5qxM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIqEeXuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIqEeXuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF813C4AF0A;
	Tue, 14 May 2024 10:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684368;
	bh=YaAcgaFLiZGwaOqdJ+Dw8e8vrMncJuOAZCYSFu/RwlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIqEeXuyW8lOxH4GhYFkDYm9fSFoTWkAJmJs6nve8xgFgShtZpwZ85F98o5oMIyWQ
	 xHBRio2+BV8EsyYL9o7LN3ODgQmM7bnzKEEUtzSPmxJTaNSsGqFKQrJJ4VdcVGBF9h
	 HSMzkVGX0yg9ADXlLZtwJ14ESRe1Ptn9g2no/Tbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/301] eeprom: at24: Probe for DDR3 thermal sensor in the SPD case
Date: Tue, 14 May 2024 12:14:40 +0200
Message-ID: <20240514101032.584452781@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dbbf7db4ff2f4..e6d688817b106 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -581,6 +581,31 @@ static unsigned int at24_get_offset_adj(u8 flags, unsigned int byte_len)
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
@@ -780,6 +805,10 @@ static int at24_probe(struct i2c_client *client)
 		}
 	}
 
+	/* If this a SPD EEPROM, probe for DDR3 thermal sensor */
+	if (cdata == &at24_data_spd)
+		at24_probe_temp_sensor(client);
+
 	pm_runtime_idle(dev);
 
 	if (writable)
-- 
2.43.0



