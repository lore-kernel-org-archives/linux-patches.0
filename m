Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053758;
	b=yM9QxkgQSXJBRseazHk7rUJCypta2rBrtzDIrkPo9ZmPJl3lW29S3aPXZEr+afahWyrX
	 YZufQvAgqbdkCMtqd2348cBpup1T5gavjwWVyF246/wtUjGnr6vf3BUaWnls7U4Ha4AsU
	 U9P3QAuB8VxK+TAG//y9sgqR/pq3CUKJbo22OFcmQsw3ndqJenaTmFz/OXaxN57erlnE0
	 SNtSG8QtgFN1m1l3/3Sfxnmr8TadJPu5UkV/d6Vt8xbbrYunFIcgCuOJ5mjb4cL9uMFa8
	 T4MbCbu8Jac5SAvlXpo63RJAvdV0E9Jc/pjQTtzS8vw4nVxJajWh0oLzA0iqdas4Ydg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s1ASvTsenA7HM6lfK3mmfm1HeokhQuBPuLAh9xP9LHE=;
	b=koeY1Lik569XLElWuj94JODl6AFDeVsQ9+DqUA0QYy1X9ToxOLms8DNBtkEA8KsUOjam
	 /sXYZejDANLLRFE5CNfiZ9Up+hyHVv+VQhyg+3yrDWjMpvYWyO3mOeyBqYgWoIp0TRiSl
	 XzSAhgQ2oUMNMfuRSskW3VheqldYIWigsVBYAsqyd0g4e82OoI+UV4ibj+Tncn0dwklQA
	 vEveaGBiU/+ua9nX3xh2NyQERoHJX0zEtqjDejV6i9N0C30EZiKlMd6NQWaRGUZhD/IWS
	 sj3JPIXDmLJUnj1Dj2TacKojcfI2puUj3SHz1oNNA1/Fj6Cxfs+iNvflwQJK+oeit5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPc25Uq2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAF2606A31C;
	Thu, 19 Nov 2026 02:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPc25Uq2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D126A1F000C4;
	Thu, 19 Nov 2026 02:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053758;
	bh=s1ASvTsenA7HM6lfK3mmfm1HeokhQuBPuLAh9xP9LHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aPc25Uq2KOPg5UmOOX7Jl/etN2TlTz/OBezWwQjXXRoGff3lisICoDEdewiClLgZL
	 CVHSeHQ5YssJd1ogbB5bQzQK12WHIczMIxw7lBoB8hU6bazI/qxu9+7gakRFLtw13j
	 Y3n49CSo5oU0esfw4caZvdmP2cCBwT6PMc9wZVnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Verdonck <tom.verdonck@inspiral.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1033/2214] hwmon: (tmp108) Fix jiffies wraparound in conversion-ready check
Date: Wed, 18 Nov 2026 15:45:09 +0100
Message-ID: <20261118150053.667065639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted probe changes to tmp108_probe() instead of tmp108_common_probe() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp108.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/tmp108.c b/drivers/hwmon/tmp108.c
index 5435664c3f6e5..4420774e6bff6 100644
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
@@ -405,7 +405,7 @@ static int __maybe_unused tmp108_resume(struct device *dev)
 
 	err = regmap_update_bits(tmp108->regmap, TMP108_REG_CONF,
 				 TMP108_CONF_MODE_MASK, TMP108_MODE_CONTINUOUS);
-	tmp108->ready_time = jiffies +
+	tmp108->ready_time = get_jiffies_64() +
 			     msecs_to_jiffies(TMP108_CONVERSION_TIME_MS);
 	return err;
 }
-- 
2.53.0



