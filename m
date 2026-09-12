Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6D647A87A;
	Sat, 12 Sep 2026 12:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216235; cv=none; b=BOBoW9iF+tsCnUVe7gRjgqh6v9arIvfT2UrRzk1BunYRBpg0yobGDTukSM4AZ6+kywp2fa6vv1xv3pOK4RM5BT22dNirnO7m223L+5SZWtyyrpXzUK/J2XcWnYEV53vGzpDERraKtMXicwmXraNdgI9/KMEuTomGeJaU3Ygjpkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216235; c=relaxed/simple;
	bh=rw9NCM7NktNuqJVZBNgtNE1v63qO7HtVRE4wDCWBen0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYIIfYefEpRQIojT6AFvvWUBsgMuWzz/toC9ySichdHEXbuuSxwzCnb+vs4s9KGzOq5qBxh1WLEXmVDI7DBFx2/7afXjbjJWpzJ+rewrEtEG2kpCRIhfMlYmeF29LuIMY34TRS/pjgOuFfx6wqLFPzyKpMMxeaMtDyBSAu/IGRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXrZpK7w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXrZpK7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689291F000FF;
	Sat, 12 Sep 2026 12:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216233;
	bh=lLOvWS0L/2p+sYjpPSMFuCfIe0W4oJnSwVc++UuYN/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXrZpK7wVNyTt3N0MfWVRB1AxpoDXJ74UAxqVQIkcLFOR6zriPHNoufH+KNvTxMaw
	 h4m4mkxsSuxz1l8w8khoa68wHlyVd2Q+ATnToc1ef/0L2JPN+3P8+y2d+ulhPphypI
	 YxBZtIpHsqrqXACoJ0xp0DY6wvrh7xWah2MY2yoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0693/1376] power: supply: sbs-battery: Use a per-device serial number buffer
Date: Sat, 12 Sep 2026 08:51:59 +0200
Message-ID: <20260912065622.991422140@linuxfoundation.org>
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
index f80edceafc3cf..4e2b8e252d5e9 100644
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



