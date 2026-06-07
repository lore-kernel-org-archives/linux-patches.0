Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A166E1E98E3;
	Sun,  7 Jun 2026 11:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830202; cv=none; b=R7r1ghTZfCUjRmAf4JD166Fh3uh8+Up2vqokqn5tNXTros315J9LXCVFsTxhzZYQipXUncxyePJpASD7fkQ9/q6DuA/tUp4PuSOXgHS6bDvVsziYJ9LUn0ZGhtnHGe2ce2kHSUp6JxjX0Gn00j5NM7+pZitVNmeMci4wixT7ZQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830202; c=relaxed/simple;
	bh=lksUyPrTm5ShDsv8682KG7RHiD5TBazsFva6/Od1bgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awb4ZZf75wiCdr4PJmEqHnWBpUQL0dfZaYKnDn34oDBIBYJkIUVvWocuLz/2uTSOjoZdJZyiAPiyw3+UCg4RSGsvrihRNhe7KBYlnRXmEARDJ4kOTCPHj7JcsmEfLe6FQi1wKUWJvojl0TjWFE792VFWze3478S7wcq1kmbgPO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYCv6+Hy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYCv6+Hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF5C1F00893;
	Sun,  7 Jun 2026 11:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830201;
	bh=8TgwUUbDjvcfzNla/Btr7IsqTJyyTXj+ieBW58/+urE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYCv6+Hy2tZ+QzOs5FLxKIVRe82TkTxfnCOqOZYYwlgSTwmxWfe5OGFpqrVu7YQI+
	 EfXfq0UQqMr+xK+A7uP8EarpS5p1VZrM512kP8K5irOwF/50p8Rv2L8HNbp+YJgNQh
	 rubanYRUTLJ3PrltyuTr0w2gvF/lss4Q/8eA0kwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 304/307] hwmon: (pmbus/adm1266) serialize GPIO PMBus accesses with pmbus_lock
Date: Sun,  7 Jun 2026 12:01:41 +0200
Message-ID: <20260607095738.921860568@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

[ Upstream commit bab8c6fb5af8df7e753d196c1262cb78e92ca872 ]

adm1266_gpio_get(), adm1266_gpio_get_multiple(), and
adm1266_gpio_dbg_show() all issue PMBus reads against the device but
none of them take pmbus_lock.  The pmbus_core framework holds
pmbus_lock around its own multi-transaction sequences (notably the
"set PAGE, then read paged register" pattern used by hwmon
attributes), so an unlocked GPIO accessor can land between a PAGE
write and the subsequent paged read in another thread and corrupt
either side's view of the device state machine.

Take pmbus_lock at the top of each of the three accessors via the
scope-based guard().  The lock is uncontended in the common case and
adds only a single mutex round-trip per call.

Fixes: d98dfad35c38 ("hwmon: (pmbus/adm1266) Add support for GPIOs")
Cc: stable@vger.kernel.org
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260518-adm1266-gpio-fixes-v3-6-e425e4f88139@nexthop.ai
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ open-coded each `guard(pmbus_lock)(data->client)` as explicit `pmbus_lock_interruptible()`/`pmbus_unlock()` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/adm1266.c |   40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -173,7 +173,12 @@ static int adm1266_gpio_get(struct gpio_
 	else
 		pmbus_cmd = ADM1266_PDIO_STATUS;
 
+	ret = pmbus_lock_interruptible(data->client);
+	if (ret)
+		return ret;
+
 	ret = i2c_smbus_read_block_data(data->client, pmbus_cmd, read_buf);
+	pmbus_unlock(data->client);
 	if (ret < 0)
 		return ret;
 	if (ret < 2)
@@ -195,11 +200,19 @@ static int adm1266_gpio_get_multiple(str
 	unsigned int gpio_nr;
 	int ret;
 
+	ret = pmbus_lock_interruptible(data->client);
+	if (ret)
+		return ret;
+
 	ret = i2c_smbus_read_block_data(data->client, ADM1266_GPIO_STATUS, read_buf);
-	if (ret < 0)
+	if (ret < 0) {
+		pmbus_unlock(data->client);
 		return ret;
-	if (ret < 2)
+	}
+	if (ret < 2) {
+		pmbus_unlock(data->client);
 		return -EIO;
+	}
 
 	status = read_buf[0] + (read_buf[1] << 8);
 
@@ -210,10 +223,14 @@ static int adm1266_gpio_get_multiple(str
 	}
 
 	ret = i2c_smbus_read_block_data(data->client, ADM1266_PDIO_STATUS, read_buf);
-	if (ret < 0)
+	if (ret < 0) {
+		pmbus_unlock(data->client);
 		return ret;
-	if (ret < 2)
+	}
+	if (ret < 2) {
+		pmbus_unlock(data->client);
 		return -EIO;
+	}
 
 	status = read_buf[0] + (read_buf[1] << 8);
 
@@ -222,6 +239,8 @@ static int adm1266_gpio_get_multiple(str
 			set_bit(gpio_nr, bits);
 	}
 
+	pmbus_unlock(data->client);
+
 	return 0;
 }
 
@@ -236,11 +255,16 @@ static void adm1266_gpio_dbg_show(struct
 	int ret;
 	int i;
 
+	if (pmbus_lock_interruptible(data->client))
+		return;
+
 	for (i = 0; i < ADM1266_GPIO_NR; i++) {
 		write_cmd = adm1266_gpio_mapping[i][1];
 		ret = adm1266_pmbus_block_xfer(data, ADM1266_GPIO_CONFIG, 1, &write_cmd, read_buf);
-		if (ret != 2)
+		if (ret != 2) {
+			pmbus_unlock(data->client);
 			return;
+		}
 
 		gpio_config = read_buf[0];
 		seq_puts(s, adm1266_names[i]);
@@ -262,8 +286,10 @@ static void adm1266_gpio_dbg_show(struct
 
 	write_cmd = 0xFF;
 	ret = adm1266_pmbus_block_xfer(data, ADM1266_PDIO_CONFIG, 1, &write_cmd, read_buf);
-	if (ret != 32)
+	if (ret != 32) {
+		pmbus_unlock(data->client);
 		return;
+	}
 
 	for (i = 0; i < ADM1266_PDIO_NR; i++) {
 		seq_puts(s, adm1266_names[ADM1266_GPIO_NR + i]);
@@ -286,6 +312,8 @@ static void adm1266_gpio_dbg_show(struct
 
 		seq_puts(s, ")\n");
 	}
+
+	pmbus_unlock(data->client);
 }
 
 static int adm1266_config_gpio(struct adm1266_data *data)


