Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591342;
	b=G6mtkwyk7hPMZiWn8DaH9LRE0U0AUwwr12vlOkkCAQeWjfv41drzvz259dkzxc7CQW7O
	 lm7YUb1xgJoBDCOseIrpU356TYR30jkobiDz4td9YqAAY2kQ4eilQ8khFzQYoTBlgc7vx
	 l8NtIfZpC23OIQ70+BpsZgfJZbzPMoWSGAAJeAb1kV5BqBRrFpHOfr4pYxZ10j6kIGoUp
	 lyuBO4133uF6gXqdq3gaqXLz+ligyquadoTO3WdMi479M05GyOO5EtqObosRVb7WKmulv
	 IbOXP8gw+tX0H2TH1oiqUuvy5Vte+3p+NOmDEneeK5cOhyOZY74M71Gc+q4W+xIlziQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VzOA2N9fwhGi5Ia3pZAkHre7I5O36NQy29betOKL/q8=;
	b=YhED7z/JdUaYYmNddf5E9mVVT00n0CIbMfFzRIs7NGbMF9hWjRw8jBY+3OyazU/WneCb
	 iXMlx92ovvWpKPOPulIlQ7FmO85PDAlk5eqfNAEJ7ng9C42ZvIJ2mdVR1LTYn+YlsNCSt
	 kNgHPqkNwgEV4qbtbwjRtwA0sd3AxYRbZwUOjP4HgQM4hYJT59hmRsH8jLKMu/GQMFMiX
	 kHUkTGpy+6hYberdcjTQ3x5FXRzBsCNC3AVip9oaQ1R/D5vb379P8+eUi9ChMzIRhwX1K
	 Sxd4YLhxViisyoHV8YTv+TqwdE+iIrhIlirsfU/CKOMgJ07zVHW2Kh+phkhvtxGIAKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F6gHh+fH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEED606CED8;
	Fri, 13 Nov 2026 17:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F6gHh+fH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FFB1F000C4;
	Fri, 13 Nov 2026 17:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591342;
	bh=VzOA2N9fwhGi5Ia3pZAkHre7I5O36NQy29betOKL/q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6gHh+fHDjwCXlkMvcSAe+Dqp/oXgbmc6pPlnXCPenUQ2dM/vpBqTO6DNjIgemwEZ
	 fi9Xc25kywLaBuvcNip3QqawF+GukUlW+gOAQnPAsgepzexM3J0BTt5aT6XTuGyjeo
	 0fI0PoC7mZ+KSUvpE79v2R+DM23uaC/Vvcyr6244=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Verdonck <tom.verdonck@inspiral.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 451/670] hwmon: (tmp102) Fix jiffies wraparound in conversion-ready check
Date: Fri, 13 Nov 2026 10:50:15 -0500
Message-ID: <20261113153827.197134046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context because the conversion-ready check is in tmp102_read() rather than tmp102_read_temp() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp102.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
index 8af44a33055f3..967d2e7e8ccf3 100644
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



