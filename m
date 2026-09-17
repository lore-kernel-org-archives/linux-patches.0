Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0755208DB;
	Thu, 17 Sep 2026 17:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665864; cv=none; b=KyqmPXim80AghLdSW/012oqZLKJZP+h43xD6ViaMaHQ3tDV03cFnCYpccPYhm5n4gGTTmtzbkE2QbeQyqErNZ8pjUCMnLuR7flL8XtADwpjCJAqrRbXpbKXN86kuDD+kkLYSBTXW0BUmJuhU71uWuF44Qn9L0XMZKWzoc4CcVfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665864; c=relaxed/simple;
	bh=qqQnLvTip93g/B/9GOWVNRgH4wG/H0TNZfvxKIAqXhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6FPJxLDPKe3F4b9oVG2Vtb5/MCeijw1wbb43+SyH8vM4//Rek3vFZaQ/Ig1/rs947ZvqVz/HY1R0pZW/0Evuq8Mr7aGmkhL+zNlkvtxHF4cvuF68Apnl4ulUU8FZpKqpmjQvNo+xmAhE7k+uFyfrpVEGKgIO+X3poy9sU9xwxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zem/PQfx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zem/PQfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920911F000FF;
	Thu, 17 Sep 2026 17:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665863;
	bh=P7TZOJ6sj1e0a6IbN9RWj6W6JKEq1mhpt5ZQuIlYDsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zem/PQfx/C2EjF5rfwt+eM6lngN9q7vrSxafyJ2L+Wfn8rmfmT8aqbdNBW3aztku2
	 qXqgsM3tEFtSKeEkGue7tzxLbTsW/I9I1gtqdEEdgq5wLFf8k9mTPRbtzuxKJc1LpH
	 0JZBLgchdjEflb1DDJy6SMDW/cgxTp16AxquDpho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0844/1250] hwmon: (sht4x) Rely on subsystem locking
Date: Thu, 17 Sep 2026 16:10:39 +0100
Message-ID: <20260917151614.834392016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 53dfa12299c15f256e6199db1328e8bccd52ffd9 ]

Attribute access is now serialized in the hardware monitoring core,
so locking in the driver code is no longer necessary. Drop it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 70c33e211b2b ("hwmon: (sht4x) Fix return value from heater_enable_store()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht4x.c | 40 +++++++++++-----------------------------
 1 file changed, 11 insertions(+), 29 deletions(-)

diff --git a/drivers/hwmon/sht4x.c b/drivers/hwmon/sht4x.c
index 6c9b776237c23..5abe1227e109e 100644
--- a/drivers/hwmon/sht4x.c
+++ b/drivers/hwmon/sht4x.c
@@ -55,7 +55,6 @@ DECLARE_CRC8_TABLE(sht4x_crc8_table);
 /**
  * struct sht4x_data - All the data required to operate an SHT4X chip
  * @client: the i2c client associated with the SHT4X
- * @lock: a mutex that is used to prevent parallel access to the i2c client
  * @heating_complete: the time that the last heating finished
  * @data_pending: true if and only if there are measurements to retrieve after heating
  * @heater_power: the power at which the heater will be started
@@ -68,7 +67,6 @@ DECLARE_CRC8_TABLE(sht4x_crc8_table);
  */
 struct sht4x_data {
 	struct i2c_client	*client;
-	struct mutex		lock;	/* atomic read data updates */
 	unsigned long		heating_complete;	/* in jiffies */
 	bool			data_pending;
 	u32			heater_power;	/* in milli-watts */
@@ -87,7 +85,7 @@ struct sht4x_data {
  */
 static int sht4x_read_values(struct sht4x_data *data)
 {
-	int ret = 0;
+	int ret;
 	u16 t_ticks, rh_ticks;
 	unsigned long next_update;
 	struct i2c_client *client = data->client;
@@ -96,8 +94,6 @@ static int sht4x_read_values(struct sht4x_data *data)
 	u8 raw_data[SHT4X_RESPONSE_LENGTH];
 	unsigned long curr_jiffies;
 
-	mutex_lock(&data->lock);
-
 	curr_jiffies = jiffies;
 	if (time_before(curr_jiffies, data->heating_complete))
 		msleep(jiffies_to_msecs(data->heating_complete - curr_jiffies));
@@ -110,11 +106,11 @@ static int sht4x_read_values(struct sht4x_data *data)
 			msecs_to_jiffies(data->update_interval);
 
 		if (data->valid && time_before_eq(jiffies, next_update))
-			goto unlock;
+			return 0;
 
 		ret = i2c_master_send(client, cmd, SHT4X_CMD_LEN);
 		if (ret < 0)
-			goto unlock;
+			return ret;
 
 		usleep_range(SHT4X_MEAS_DELAY_HPM, SHT4X_MEAS_DELAY_HPM + SHT4X_DELAY_EXTRA);
 	}
@@ -123,7 +119,7 @@ static int sht4x_read_values(struct sht4x_data *data)
 	if (ret != SHT4X_RESPONSE_LENGTH) {
 		if (ret >= 0)
 			ret = -ENODATA;
-		goto unlock;
+		return ret;
 	}
 
 	t_ticks = raw_data[0] << 8 | raw_data[1];
@@ -132,26 +128,20 @@ static int sht4x_read_values(struct sht4x_data *data)
 	crc = crc8(sht4x_crc8_table, &raw_data[0], SHT4X_WORD_LEN, CRC8_INIT_VALUE);
 	if (crc != raw_data[2]) {
 		dev_err(&client->dev, "data integrity check failed\n");
-		ret = -EIO;
-		goto unlock;
+		return -EIO;
 	}
 
 	crc = crc8(sht4x_crc8_table, &raw_data[3], SHT4X_WORD_LEN, CRC8_INIT_VALUE);
 	if (crc != raw_data[5]) {
 		dev_err(&client->dev, "data integrity check failed\n");
-		ret = -EIO;
-		goto unlock;
+		return -EIO;
 	}
 
 	data->temperature = ((21875 * (int32_t)t_ticks) >> 13) - 45000;
 	data->humidity = ((15625 * (int32_t)rh_ticks) >> 13) - 6000;
 	data->last_updated = jiffies;
 	data->valid = true;
-	ret = 0;
-
-unlock:
-	mutex_unlock(&data->lock);
-	return ret;
+	return 0;
 }
 
 static ssize_t sht4x_interval_write(struct sht4x_data *data, long val)
@@ -287,22 +277,16 @@ static ssize_t heater_enable_store(struct device *dev,
 		heating_time_bound = 1100;
 	}
 
-	mutex_lock(&data->lock);
-
-	if (time_before(jiffies, data->heating_complete)) {
-		ret = -EBUSY;
-		goto unlock;
-	}
+	if (time_before(jiffies, data->heating_complete))
+		return -EBUSY;
 
 	ret = i2c_master_send(data->client, &cmd, SHT4X_CMD_LEN);
 	if (ret < 0)
-		goto unlock;
+		return ret;
 
 	data->heating_complete = jiffies + msecs_to_jiffies(heating_time_bound);
 	data->data_pending = true;
-unlock:
-	mutex_unlock(&data->lock);
-	return ret;
+	return 0;
 }
 
 static ssize_t heater_power_show(struct device *dev,
@@ -422,8 +406,6 @@ static int sht4x_probe(struct i2c_client *client)
 	data->heater_time = 1000;
 	data->heating_complete = jiffies;
 
-	mutex_init(&data->lock);
-
 	crc8_populate_msb(sht4x_crc8_table, SHT4X_CRC8_POLYNOMIAL);
 
 	ret = i2c_master_send(client, cmd, SHT4X_CMD_LEN);
-- 
2.53.0



