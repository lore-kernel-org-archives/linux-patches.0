Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590596;
	b=FG94NrQQfYyzM5/eaWQY9YUXDBq6zK5EoqMhreAT8RqGvxXGp2y930ZciVMp0t5t6lD5
	 QtyFgcJgpED9A4OMVf3o//o5JK/oc5A1sSx+LCpFT1Pd7dVK52j/eyBK9T4qmiFtAe0hr
	 E7WhwS+sxpBAFGTckEzNkJ59SniqG60rpoecabUjx2SYO5kBnFEuxdCsVbA/8BXyra6va
	 /ZTBHM1zqnkQiPguRyu3TKfYfiPVd2UXZpk4n1X9NjjwCA6nI1RDGun8IjK0evhkoQnbU
	 oq7YYB88ODAJMYqIQ7ya9vOncxEQi3744twh/WYEV9l7UqoQpUwmZRqxuKVcflv2z+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YeETzSGPxn14ShkNoCo0G+RwzCVBzaTX2YR3Ehuxi2s=;
	b=rUVaMj5OzdO/aFFzbRhRKEMUBEFpNhmiYjt1Yb0Kps9nUgbbysij0vql5pFDg9pwfBt3
	 6imA7Sgb8eFoRSaCFCH0QcOWvlyBVOo0GbBj8IRJ/atbq6czyNHEeVmkW/ncRhloAj5RS
	 ns+Vehz9sh3MoZibwou9/EibxVqtquhiZDzcuJjSZN28DbPHnNZKRaKOA6qrXIjU4nHl9
	 AwpsSxun9cFqMH+kvGgwX3nwhuwi+YaUYg3A2jgExpq0uhSFUiBIdrND3zphipMjhDomN
	 IayVdr3oqBqU0S4Z1qfaMIg6CocO0YXLYpuqEpVv10mp5FDx+oQIKuVoEdUuC0pdddg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pA4T39xL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A1A606A323;
	Fri, 13 Nov 2026 17:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pA4T39xL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E291F000C7;
	Fri, 13 Nov 2026 17:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590596;
	bh=YeETzSGPxn14ShkNoCo0G+RwzCVBzaTX2YR3Ehuxi2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pA4T39xLSRA5iRX1VJkl9iFKY4hsjR3hrz/lrF1EfmlKN8K1AR2ZL5qy5Jzg6ZWMm
	 pT23qNGzaWkXSrFLA69bK7Cxu44zpgR0XnBSb40E+aBB7ZpgsDeb733HAXjx9gC0gK
	 wTeKz1Ylzl/yCCm7ikfhxaPtABmwhJPHkBuJUTk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Verdonck <tom.verdonck@inspiral.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 509/686] hwmon: (tmp102) Fix jiffies wraparound in conversion-ready check
Date: Fri, 13 Nov 2026 10:50:42 -0500
Message-ID: <20261113153838.143629758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted struct tmp102 context to account for the missing sample_time field. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp102.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
index 376e0eac8cc1c..62a7bee9e4b95 100644
--- a/drivers/hwmon/tmp102.c
+++ b/drivers/hwmon/tmp102.c
@@ -56,7 +56,7 @@ struct tmp102 {
 	const char *label;
 	struct regmap *regmap;
 	u16 config_orig;
-	unsigned long ready_time;
+	u64 ready_time;
 };
 
 /* convert left adjusted 13-bit TMP102 register value to milliCelsius */
@@ -91,7 +91,7 @@ static int tmp102_read(struct device *dev, enum hwmon_sensor_types type,
 	switch (attr) {
 	case hwmon_temp_input:
 		/* Is it too early to return a conversion ? */
-		if (time_before(jiffies, tmp102->ready_time)) {
+		if (time_before64(get_jiffies_64(), tmp102->ready_time)) {
 			dev_dbg(dev, "%s: Conversion not ready yet..\n", __func__);
 			return -EAGAIN;
 		}
@@ -270,7 +270,7 @@ static int tmp102_probe(struct i2c_client *client)
 	 * Mark that we are not ready with data until the first
 	 * conversion is complete
 	 */
-	tmp102->ready_time = jiffies + msecs_to_jiffies(CONVERSION_TIME_MS);
+	tmp102->ready_time = get_jiffies_64() + msecs_to_jiffies(CONVERSION_TIME_MS);
 
 	hwmon_dev = devm_hwmon_device_register_with_info(dev, client->name,
 							 tmp102,
@@ -303,7 +303,7 @@ static int tmp102_resume(struct device *dev)
 	err = regmap_update_bits(tmp102->regmap, TMP102_CONF_REG,
 				 TMP102_CONF_SD, 0);
 
-	tmp102->ready_time = jiffies + msecs_to_jiffies(CONVERSION_TIME_MS);
+	tmp102->ready_time = get_jiffies_64() + msecs_to_jiffies(CONVERSION_TIME_MS);
 
 	return err;
 }
-- 
2.53.0



