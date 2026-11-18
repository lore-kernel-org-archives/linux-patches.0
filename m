Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059383;
	b=5pw5+Syf15d9sc83Nv9OuWYKtegvNzCzfgY0ORPdPSPe7zNsUwvxKcT9MLwGKPh1j7m8
	 2zjsnYO4jZ09Fcmf0Wi+vC517IDPW7Anlm0Ho32mSw60+j8SOENEjpqlp94+A3duX0ec8
	 +yW/GwVvykY+occdMwuwlPr1yu6Oj8JKc5NPdknQgeoW1qH8tjzZq3fiezGPNlEMvMjPs
	 zpWV/s4i9/Xlg+0tgTOLXHI1or/cKf3RMVEnLhl7a51snmq0glVZrNsuMc/tjUPNvv29x
	 2rLnv2voy+iPSXJIWsqERISkozBKgYh7DF6gF1qSZz3tTvGyFORoqkyVvF9KAiBC0WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LakhNtMeKbhi7jCbql4OJko00NpwO1WHVO+LwYNukEQ=;
	b=D+VqCmGgRiL/N0lTLtq6qUyw9icN8d3jQ8ue3v/O3Jo087unqQEecxhAsCLd+u1juuxM
	 QalapdgKMeC+GmQ53R92NjnS8Rs5AOJlSbOPHdeAe0xvM2SLPPFBAxJUlpUbes/GAC2qK
	 ekxXeiZWkyS1FYC59zzOrSzMEyCf7veu+EfokUACDt9E/9Vz1yo/uS4cJ7QEuZJpZLH1D
	 0zoFMCwd1BQZFU5mUpsFLfSzXimBopVIqne/JtkiTpNsiXijhNKphVxy99JhefskMftHZ
	 DUEWNGBz4pi2Pc97jIRk5mRF5+/lO6exOS0+5IxTdk/GAJ85WZxM1j7sIf1T7eXOw3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KxKYlzmF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCA9606A31C;
	Thu, 19 Nov 2026 03:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KxKYlzmF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4B61F000C5;
	Thu, 19 Nov 2026 03:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059383;
	bh=LakhNtMeKbhi7jCbql4OJko00NpwO1WHVO+LwYNukEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KxKYlzmFietKuiBNJIqKGIo6GMmj2zQi564Vx8YP4i1L+Ya20Nk8qJ8jpIzC3f+XC
	 RzxEMjFipCjSlW2Bpp7lxds0c/fIGeFTJNhex+66CJim1QylVeO0ZGB/wXO+gJmsG0
	 MH4Yu+X2neLvsxrJnoDsiAkMX2+U1MvWwF1Zi+ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Verdonck <tom.verdonck@inspiral.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0822/1848] hwmon: (tmp102) Fix jiffies wraparound in conversion-ready check
Date: Wed, 18 Nov 2026 15:47:40 +0100
Message-ID: <20261118145951.047338315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for the temperature check in tmp102_read() instead of tmp102_read_temp() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp102.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
index e867a0c2e5399..181373cc1289a 100644
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
@@ -279,7 +279,7 @@ static int tmp102_resume(struct device *dev)
 	err = regmap_update_bits(tmp102->regmap, TMP102_CONF_REG,
 				 TMP102_CONF_SD, 0);
 
-	tmp102->ready_time = jiffies + msecs_to_jiffies(CONVERSION_TIME_MS);
+	tmp102->ready_time = get_jiffies_64() + msecs_to_jiffies(CONVERSION_TIME_MS);
 
 	return err;
 }
-- 
2.53.0



