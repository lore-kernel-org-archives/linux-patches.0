Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472D5478E26;
	Tue, 16 Jun 2026 17:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630695; cv=none; b=VGLk5qADZLmJ9UJCHky9o3BEcj7rp/bFn06KL8VW/Qv9FR4HOCWCjfl8dpiMCCa5L40SVRKEx8qw5xZzKy5dSIGjh7ur964oVn5Bt3EBUpEaK4fKo1e32StHAiD1bMh8vMXGQ38fXRCD1FYEUFES9sligQp3V9ljkuGQ+EhNup0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630695; c=relaxed/simple;
	bh=5s5rmDqHtQctYXutChym6TtORD44VK5+E+m+3pYvIcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msiQdJCk6e+vZWKnj6KH9pIKaxJrPj+HynWauxpRx7b2ktB6qusu6G3ZwvkGYVgDTydjcRAgin7JDNwTOflnelUjBL3gNBzocOT90HJ5TVqsrZJi2QQcBU+UytFRtD2/2AnQVnVxnxF0KZ6VcjazOhSH9Q+fSnC57cxwO7Xrm50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfRLNVKY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfRLNVKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D913B1F000E9;
	Tue, 16 Jun 2026 17:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630693;
	bh=dwAxphpB3FDocCZ705KVppL50WIpNjId63bdHlrLLXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YfRLNVKYgD9RLER0Yyqx2UCHUDoImznT9i/2Zv/kS3OPgkwhreIxxlCxQRRBiDeaG
	 CMwILLI0vah5eGlZJZfgMF1AipgFRfYSOEkrHt2ToQqANlBFniHHFNS6zPmaQ45x35
	 H0ueRBbiym3ryDT6Y0nwlD1lXiuYwAAbeRXYsRMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/522] hwmon: (pmbus/adm1266) serialize GPIO PMBus accesses with pmbus_lock
Date: Tue, 16 Jun 2026 20:23:46 +0530
Message-ID: <20260616145129.554319876@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/hwmon/pmbus/adm1266.c | 40 +++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/pmbus/adm1266.c b/drivers/hwmon/pmbus/adm1266.c
index a616439cecbf51..51e76e4413519e 100644
--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -173,7 +173,12 @@ static int adm1266_gpio_get(struct gpio_chip *chip, unsigned int offset)
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
@@ -195,11 +200,19 @@ static int adm1266_gpio_get_multiple(struct gpio_chip *chip, unsigned long *mask
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
 
@@ -210,10 +223,14 @@ static int adm1266_gpio_get_multiple(struct gpio_chip *chip, unsigned long *mask
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
 
@@ -222,6 +239,8 @@ static int adm1266_gpio_get_multiple(struct gpio_chip *chip, unsigned long *mask
 			set_bit(gpio_nr, bits);
 	}
 
+	pmbus_unlock(data->client);
+
 	return 0;
 }
 
@@ -236,11 +255,16 @@ static void adm1266_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
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
@@ -262,8 +286,10 @@ static void adm1266_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 
 	write_cmd = 0xFF;
 	ret = adm1266_pmbus_block_xfer(data, ADM1266_PDIO_CONFIG, 1, &write_cmd, read_buf);
-	if (ret != 32)
+	if (ret != 32) {
+		pmbus_unlock(data->client);
 		return;
+	}
 
 	for (i = 0; i < ADM1266_PDIO_NR; i++) {
 		seq_puts(s, adm1266_names[ADM1266_GPIO_NR + i]);
@@ -286,6 +312,8 @@ static void adm1266_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 
 		seq_puts(s, ")\n");
 	}
+
+	pmbus_unlock(data->client);
 }
 
 static int adm1266_config_gpio(struct adm1266_data *data)
-- 
2.53.0



