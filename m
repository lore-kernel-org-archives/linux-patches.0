Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9578E372ED0;
	Sat, 12 Sep 2026 18:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239115; cv=none; b=PSHddBAleIl8miYP8hwdn7zIrOlAeQGnTz4DiG+2P6ySaESZEf1G4DN3J40moGcZwWmqZov5ta1vCA9NknbJzDjMHOmN1uuwaT6yM2K16suL6X41Xtlxl9csYUQ9dfmLmvjTS3aDBRWw9lLyNIJruA607A2Bt5ROpL+ScIZg4MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239115; c=relaxed/simple;
	bh=CJLK6CywlkkD34Dho/BFXs5pENW7JjEJmm51hT23Rug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCARdnF+R4xgvQbsAVf4PPB6U+Fy9fVwW5fSaqs7VKVfWyyjPBY3vbb8HSlabkkfMU0cMCMnDPP0VgqrqcgvMzgkhEM8Hokp8hT8bqaConcVF4R0+xBUnTxHGJteoWg4G5Nd1miFoSnFYqdLBQ29q+wR0/D6DDO7iFuUHkFxhak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ml5mVIIM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ml5mVIIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35381F000FF;
	Sat, 12 Sep 2026 18:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239114;
	bh=xp4IfAYehGX3fYN2IyitO9EFixTrwN/M1eGzQ5B04FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ml5mVIIM82Cqe9fzMbb2zt0CZF0F0vE0+GB/XitBJMSgDC6K/idwpcaLyyFUxC0wV
	 sclHI28nr4d4C3Ix+sFwpYJlEExQRZV2R0nuWvE3A5Lknx+rjxDCxD/bEpm8OGvpCe
	 QZUIAnlPRIlbM05P1S1enmSKc+18D9h7e5y/8cfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 600/935] power: supply: sbs-battery: Use a per-device serial number buffer
Date: Sat, 12 Sep 2026 09:00:30 +0200
Message-ID: <20260912065540.602203562@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Babanpreet Singh <bbnpreetsingh@gmail.com>

[ Upstream commit 6027892925b8d19d2245c2d077e2ae35b49cc2b1 ]

sbs_get_battery_serial_number() formats the battery serial number into
sbs_serial[], a single file-scope buffer shared by every sbs-battery
instance, and points val->strval at it.

Nothing restricts this driver to one instance. It binds per I2C client,
and sbs-manager registers one muxed I2C channel per supported battery
specifically so that the smart battery driver can be bound to each of
them, so several sbs-battery instances on one system is a supported
configuration.

The power supply core reads strval after the driver's get_property()
callback has returned: power_supply_show_property() fills a local
union power_supply_propval, then formats it with sysfs_emit(). Two
concurrent POWER_SUPPLY_PROP_SERIAL_NUMBER reads on different batteries
therefore race for the shared buffer - battery B's sprintf() can land
between battery A filling the buffer and the core reading it, and
battery A then reports battery B's serial number.

Move the buffer into struct sbs_info so that each battery formats into
its own storage. It is deliberately not added to the chip->strings[]
array: those entries hold the cached constant strings that
sbs_invalidate_cached_props() clears on presence changes, whereas the
serial number is re-read from its word register on every access.

Fixes: d3ab61ecbab2 ("bq20z75: Add support for more power supply properties")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Babanpreet Singh <bbnpreetsingh@gmail.com>
Link: https://patch.msgid.link/20260726072206.7-2-bbnpreetsingh@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/sbs-battery.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/sbs-battery.c b/drivers/power/supply/sbs-battery.c
index a633130a768df..18f20a6b4a166 100644
--- a/drivers/power/supply/sbs-battery.c
+++ b/drivers/power/supply/sbs-battery.c
@@ -216,6 +216,7 @@ struct sbs_info {
 	u32				flags;
 	int				technology;
 	char				strings[NR_STRING_BUFFERS][I2C_SMBUS_BLOCK_MAX + 1];
+	char				serial[5];
 };
 
 static char *sbs_get_string_buf(struct sbs_info *chip,
@@ -820,18 +821,18 @@ static int sbs_get_battery_capacity(struct i2c_client *client,
 	return 0;
 }
 
-static char sbs_serial[5];
 static int sbs_get_battery_serial_number(struct i2c_client *client,
 	union power_supply_propval *val)
 {
+	struct sbs_info *chip = i2c_get_clientdata(client);
 	int ret;
 
 	ret = sbs_read_word_data(client, sbs_data[REG_SERIAL_NUMBER].addr);
 	if (ret < 0)
 		return ret;
 
-	sprintf(sbs_serial, "%04x", ret);
-	val->strval = sbs_serial;
+	sprintf(chip->serial, "%04x", ret);
+	val->strval = chip->serial;
 
 	return 0;
 }
-- 
2.53.0



