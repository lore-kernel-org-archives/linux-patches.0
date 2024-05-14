Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC37212FF67;
	Tue, 14 May 2024 11:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686082; cv=none; b=iE76eXMc3yQRjE/ThO7w+l/FAUfNJm9DwQXKEQEaY7XV6srX/qyl7J41zDNtrpY3qVEvv3zhNOQl9PWkGb1Gp+7bRDcFdwia/mZ4D0751cArX3UjEH06FLsV8dXcPXqooZc7rvvao+Wy1s17NvpysjKTbgEBjV608JoaBnZ4teM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686082; c=relaxed/simple;
	bh=m/Whxq+ILTbtqt9sH716iTWR9UmW5+1+qldQslUGmAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b73xmzttcp4/lh4EnHmCFY6m11rAxUZ2kIbeNba8Z5Dv8olw7R5Og8wa252d8TieNuwm5CFQP5P2gwInZ8OKhFXQxOHqT7bxpE0koFuoTj02SeIe9TSB2UgBN3GoXSpiuTT2SRc03BaP5xHWSn3t8Dzg/lf2V3lBzrEtE+XewsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFYK6pcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFYK6pcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C47C2BD10;
	Tue, 14 May 2024 11:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686081;
	bh=m/Whxq+ILTbtqt9sH716iTWR9UmW5+1+qldQslUGmAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RFYK6pcwTU75ECPYkGjN0f/RYj77lVvjJtrAH45RqEn7Glu3ksZRf7KC/A0/Hc3Rf
	 Oo5RbbbeGEAcehc4R9y0UEwMPqSszTxFirG+FzKbpiuXfm3WXAWx3EvVMgao2BmNmw
	 HTxZW5aaxSXJ/TOTyiyRRf12Lqdc3xv0SkokuGTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/236] eeprom: at24: Probe for DDR3 thermal sensor in the SPD case
Date: Tue, 14 May 2024 12:16:08 +0200
Message-ID: <20240514101020.570416419@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5aae2f9bdd51c..dc30fe137b40f 100644
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



