Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046727;
	b=1IoD80QpiDgge7IOgfUPpOpCFx3yYZkwNtIBfwMNAzxHLAQIRVPRfGWPw+qEoYruXgtH
	 I21scuJEgFP9rAWBBWOrAgsqi4SccnEm8xeEVTeV+RXWHhG7DNFwcu96LzUyrNDZC4wy7
	 /ygrGPIxU0YQ4VlDTRFu4D0uvyoEIUWwTEKPaQNsuDK5stSGwjqN23klm25xLKqxYTjJJ
	 WFta+qXigvovFlaPuTmSi+KvF1V2ZswKUH2Q29N1M/98oB4p0g4qybrfkxpJR5dATnqjK
	 nKvEJvW++siJr1T1uDiGsnW3yZpz5n0kM8oiJBuOnlw8DClMh6bNrKasIXE8gELhNwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ekvmz7tchs4nKGrTKqv73kkjHWZWfli4NNBrEiLk7HM=;
	b=A69056yxQia3jRV6S3lzuYOgsypa9QfI3Pn52j4R+cQNo3xONuNXQbotO2GThNuIovHd
	 ZB9pO6hJY+Se7r7N37Mp0fp3p8r2MOAzRQb09Nmjt67f56X+rWrNh3fIeCo23YX7pAjv5
	 xRHGeKUtDVX3MOkqx+ruqf9zCW425ykHuHL47CPpX67kGGbWjUxegd3xoIaEOxmKmn6QE
	 wQSmvJJapyriS8sleOrEo1qA5JG8/K7Ibca/kuCrQLOpBS1IvfBcBVV1oTaC1d45smsb6
	 G/gMPOaPF3rwRLiyn+/v5ZJ1fmWTa1f2y+yvDT6rbgQzlSlRKX/Giv33nKPKvkMx4RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLxomwYy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36FC606A32C;
	Thu, 19 Nov 2026 00:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLxomwYy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7A71F000C5;
	Thu, 19 Nov 2026 00:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046727;
	bh=ekvmz7tchs4nKGrTKqv73kkjHWZWfli4NNBrEiLk7HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLxomwYyy6IcsGX5CqojLp1t7NLjKFcrQWooc2gsIRQyPSDlhdb/vhQyC4WZr1EuB
	 nwq3hKq+InU3EW/uScnhFT4PzaaM3IDo32/4XFIO+zTYPyyC+jfIfcXuB0e20mbXnW
	 SlECReB/kgM1EV78tKjcoF6U34ekN3Nw+6PPxxcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Verdonck <tom.verdonck@inspiral.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1377/2857] hwmon: (tmp102) Fix jiffies wraparound in conversion-ready check
Date: Wed, 18 Nov 2026 15:40:11 +0100
Message-ID: <20261118150250.958419596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Verdonck <tom.verdonck@inspiral.be>

[ Upstream commit 56c1d32323e773b8b927316f8beeae9238576335 ]

tmp102 records a one-shot deadline in ->ready_time at probe (and resume)
and, on every temperature read, refuses the read with -EAGAIN while
time_before(jiffies, ready_time) is true, in order to skip the first
~35 ms conversion.

->ready_time is an unsigned long compared with time_before(), whose
signed difference is only meaningful while the two values are within
LONG_MAX jiffies of each other. Because ->ready_time is set once and
never refreshed, jiffies keeps advancing away from it, and after 2^31
jiffies the difference flips sign. On a 32-bit HZ=100 kernel that
happens ~248.5 days after boot: time_before() then permanently reports
"not ready" and the driver returns -EAGAIN on every read, without ever
touching the sensor, until the next reboot.

Store the deadline as a 64-bit jiffies value and compare it with
get_jiffies_64()/time_before64(), which does not wrap in any practical
uptime.

Fixes: 3d8f7a89a197 ("hwmon: (tmp102) Improve handling of initial read delay")
Cc: stable@vger.kernel.org
Signed-off-by: Tom Verdonck <tom.verdonck@inspiral.be>
Link: https://patch.msgid.link/2952f070f82913aea96eec25d28008d3b9058656.1790358356.git.tom.verdonck@inspiral.be
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ sashal: adjusted context for tmp102_read() instead of tmp102_read_temp() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp102.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
index 2bf496a62206a..4f4028fb6a26e 100644
--- a/drivers/hwmon/tmp102.c
+++ b/drivers/hwmon/tmp102.c
@@ -54,7 +54,7 @@
 struct tmp102 {
 	struct regmap *regmap;
 	u16 config_orig;
-	unsigned long ready_time;
+	u64 ready_time;
 };
 
 /* convert left adjusted 13-bit TMP102 register value to milliCelsius */
@@ -79,7 +79,7 @@ static int tmp102_read(struct device *dev, enum hwmon_sensor_types type,
 	switch (attr) {
 	case hwmon_temp_input:
 		/* Is it too early to return a conversion ? */
-		if (time_before(jiffies, tmp102->ready_time)) {
+		if (time_before64(get_jiffies_64(), tmp102->ready_time)) {
 			dev_dbg(dev, "%s: Conversion not ready yet..\n", __func__);
 			return -EAGAIN;
 		}
@@ -245,7 +245,7 @@ static int tmp102_probe(struct i2c_client *client)
 	 * Mark that we are not ready with data until the first
 	 * conversion is complete
 	 */
-	tmp102->ready_time = jiffies + msecs_to_jiffies(CONVERSION_TIME_MS);
+	tmp102->ready_time = get_jiffies_64() + msecs_to_jiffies(CONVERSION_TIME_MS);
 
 	hwmon_dev = devm_hwmon_device_register_with_info(dev, client->name,
 							 tmp102,
@@ -278,7 +278,7 @@ static int tmp102_resume(struct device *dev)
 	err = regmap_update_bits(tmp102->regmap, TMP102_CONF_REG,
 				 TMP102_CONF_SD, 0);
 
-	tmp102->ready_time = jiffies + msecs_to_jiffies(CONVERSION_TIME_MS);
+	tmp102->ready_time = get_jiffies_64() + msecs_to_jiffies(CONVERSION_TIME_MS);
 
 	return err;
 }
-- 
2.53.0



