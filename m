Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046938;
	b=c31fm1GztTN336tjI6Kk+iieGzlkrjcukwvTG72/j2/SFOSoTaxRsCv3wp2UH5owd18C
	 jDxHz/m8QKmeNTbOceZsdKlngFSGDjkJVDgPLgz+g6kNQNGXYJ/P5C9KWDn4/rrsKvOez
	 4YVyBoicTyvlfqOhTEqDq1OC1R5ONMprBLGyvBjMpQ7ZOKH6nSyJ8SOn8Z28XKByUWFth
	 yfE3NAZxZVZQNPwsn7HPiI0JYB3xVVrh90BLDWG7lnC7F8YFbBiSPxBPH0+1hZc1CpDaW
	 zu66YQ2kOdysYDoDZayKEuNL33nWyomkIeKv4Td0ES9W3IaR5DNz+xvOtC6xzmviw6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=farX2g/iDMLuirItaVsc9p5enDi4UbGGuGC7VdB4SMk=;
	b=StBJv1oGcUdCUTzdU46kpAmVetfL3PocpR1f92g1TSltuOOnKbv8z8Oznh0IBamMyKhD
	 JJBNlnAvTEbYFbq6o+KS3TDf+SSpuYiRE2oFJHOP2QVp5ECnD3N7Orn6HGq1vs3wPab+x
	 me4uenIlQPCohaEH466GCUfT8pKSdLBJ0kg40THBJAgzWAHBxWEUHSs518EM7nFnbd2pe
	 Lenw2PyXRXP+kW/uBc20N7brqdKfcPy5NkQIaakKZThjLuoo3U5oXii7Cm2Likc/JN8VP
	 RKnv6uYqXfpAGhSJ43kUlkWvbKO2xwQ1iGwALXrHmzfdhBfbk/vJ7SpJBwKr34kzQZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vabrsB7D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FC3606A325;
	Thu, 19 Nov 2026 00:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vabrsB7D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E731F000C5;
	Thu, 19 Nov 2026 00:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046938;
	bh=farX2g/iDMLuirItaVsc9p5enDi4UbGGuGC7VdB4SMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vabrsB7DMISZTP7GH9Q4xahnpPACpRMSEXcwCNfgxaVA1/4N3d0Jz+cfg9VU5eCTn
	 by7hlfx83EO2Rqh37LGMkSx9m3Kobis2kWFAEahozeDm8C4Ofp7fOVnkEt91yyVTsr
	 g2bsS0BsWW5rEXQpNw1k9Qz5zBOsU5sNO7pru+Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Verdonck <tom.verdonck@inspiral.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1423/2857] hwmon: (tmp108) Fix jiffies wraparound in conversion-ready check
Date: Wed, 18 Nov 2026 15:40:57 +0100
Message-ID: <20261118150252.558379560@linuxfoundation.org>
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

[ Upstream commit 6b8b1d1d7bc7e579b53fc7c3293b787d68de702a ]

tmp108 records a one-shot deadline in ->ready_time at probe (and resume)
and, on every temperature read, refuses the read with -EAGAIN while
time_before(jiffies, ready_time) is true, in order to skip the initial
conversion.

->ready_time is an unsigned long compared with time_before(), whose
signed difference is only meaningful while the two values are within
LONG_MAX jiffies of each other. Because ->ready_time is set once and
never refreshed, jiffies keeps advancing away from it, and after 2^31
jiffies the difference flips sign. On a 32-bit HZ=100 kernel that
happens ~248.5 days after boot: time_before() then permanently reports
"not ready" and the driver returns -EAGAIN on every read, without ever
touching the sensor, until the next reboot. The continuous-mode path,
which sets ->ready_time to jiffies with no added conversion delay, wraps
the same way.

Store the deadline as a 64-bit jiffies value and compare it with
get_jiffies_64()/time_before64(), which does not wrap in any practical
uptime.

Fixes: 66e1c9171339 ("hwmon: Add Texas Instruments TMP108 temperature sensor driver.")
Cc: stable@vger.kernel.org
Signed-off-by: Tom Verdonck <tom.verdonck@inspiral.be>
Link: https://patch.msgid.link/525fa49d8c50922344fa53e22be5e6133c9bbb62.1790358356.git.tom.verdonck@inspiral.be
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ sashal: adjusted probe context from tmp108_common_probe() to tmp108_probe() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp108.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/tmp108.c b/drivers/hwmon/tmp108.c
index acb4ba750b09c..4807c7e8fe609 100644
--- a/drivers/hwmon/tmp108.c
+++ b/drivers/hwmon/tmp108.c
@@ -73,7 +73,7 @@
 struct tmp108 {
 	struct regmap *regmap;
 	u16 orig_config;
-	unsigned long ready_time;
+	u64 ready_time;
 };
 
 /* convert 12-bit TMP108 register value to milliCelsius */
@@ -124,7 +124,7 @@ static int tmp108_read(struct device *dev, enum hwmon_sensor_types type,
 	switch (attr) {
 	case hwmon_temp_input:
 		/* Is it too early to return a conversion ? */
-		if (time_before(jiffies, tmp108->ready_time)) {
+		if (time_before64(get_jiffies_64(), tmp108->ready_time)) {
 			dev_dbg(dev, "%s: Conversion not ready yet..\n",
 				__func__);
 			return -EAGAIN;
@@ -371,7 +371,7 @@ static int tmp108_probe(struct i2c_client *client)
 		return err;
 	}
 
-	tmp108->ready_time = jiffies;
+	tmp108->ready_time = get_jiffies_64();
 	if ((tmp108->orig_config & TMP108_CONF_MODE_MASK) ==
 	    TMP108_MODE_SHUTDOWN)
 		tmp108->ready_time +=
@@ -405,7 +405,7 @@ static int tmp108_resume(struct device *dev)
 
 	err = regmap_update_bits(tmp108->regmap, TMP108_REG_CONF,
 				 TMP108_CONF_MODE_MASK, TMP108_MODE_CONTINUOUS);
-	tmp108->ready_time = jiffies +
+	tmp108->ready_time = get_jiffies_64() +
 			     msecs_to_jiffies(TMP108_CONVERSION_TIME_MS);
 	return err;
 }
-- 
2.53.0



