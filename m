Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590632;
	b=oJR8rqoHCjOgLjBngVF8AFpG/CyBvdpknkKA7++DUuFMygcLogJhN3Ts0sS1kd+OAReh
	 A5vkOO66+BAuEDyHkArS9l+3gLsR4plv0ViYfJXUxpdrF6SRb8ipClM+kHUAq1hOAlbM3
	 M0NjjeFe1eTwn4vxMeKVFAnn7r5EjMo8fT98kGDxZdGOy+xztJn7SEuqMu5PVyEJFJ4cb
	 IlDiCI+nXLJsuZFjOYJp/1p/2p2Ez0DBL/tAUBO+ZrxIbI+c3KGgK8kW9MmII6gEA9nvM
	 wi46HLxCpC95Pzhi6bDWlO4nAmKiF1yWLLcLH6oI3QRywSBadAukN4E7aj3Uv1g0Dig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ggYzhxea546pfqsWaxsnwkZooaZ/11PXOmmIm8g2uU=;
	b=pzZEa84GZ4ZqLFXU7kk8/xSiw1supFW0MRq9+Djl4wjz7wji/+ZJhATBbcgf5o2rMluv
	 1bXa5Z2gwIUQPe/haA/wuh+O54F9P1AibABKeiPQ2OW4ZF+qVXwGFfD33TVeWEhjSAPLn
	 5zlEySoU4lH7NO8LZVIzE6UUvFzESA5eeuKskTvGF8FtMjEPa9CPGznuEmyL6zuXzRyuY
	 auuxtEKaNUP+tnZblYL2YfvSVZrnKQCsp+Tsku72uiO+OWiHjIlVKNKbDXNu0LtNuNB4M
	 ehWq7sQBzlChloBFyhXyE7ITNWTUVBV1Py7CiP0D62UBplZFdc7F11B9FqB5KKb5i0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U3bOE8D9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFA560A2639;
	Fri, 13 Nov 2026 17:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U3bOE8D9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DA01F000C4;
	Fri, 13 Nov 2026 17:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590632;
	bh=4ggYzhxea546pfqsWaxsnwkZooaZ/11PXOmmIm8g2uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3bOE8D9nRkuZmZFkbPjf8x9S3ez8MCR7nHe6oS15DN/ELB28w0MV7NrGc6uypS8T
	 xtHT4ltNRIuRh6Z+hpFBLDDbIor4r4CAaLI5guqW3HDQmuNXK6ea1tDAIwRYE3yMh8
	 xtx+WoVgqLv5mJSS0+tkf3pGQUqGmssMB9sc1DX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Verdonck <tom.verdonck@inspiral.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 553/686] hwmon: (tmp108) Fix jiffies wraparound in conversion-ready check
Date: Fri, 13 Nov 2026 10:51:26 -0500
Message-ID: <20261113153840.308486932@linuxfoundation.org>
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
[ sashal: Adjusted struct tmp108 context to account for the missing params field. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp108.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/tmp108.c b/drivers/hwmon/tmp108.c
index a971ff628435b..b298fae9296c6 100644
--- a/drivers/hwmon/tmp108.c
+++ b/drivers/hwmon/tmp108.c
@@ -74,7 +74,7 @@
 struct tmp108 {
 	struct regmap *regmap;
 	u16 orig_config;
-	unsigned long ready_time;
+	u64 ready_time;
 };
 
 /* convert 12-bit TMP108 register value to milliCelsius */
@@ -125,7 +125,7 @@ static int tmp108_read(struct device *dev, enum hwmon_sensor_types type,
 	switch (attr) {
 	case hwmon_temp_input:
 		/* Is it too early to return a conversion ? */
-		if (time_before(jiffies, tmp108->ready_time)) {
+		if (time_before64(get_jiffies_64(), tmp108->ready_time)) {
 			dev_dbg(dev, "%s: Conversion not ready yet..\n",
 				__func__);
 			return -EAGAIN;
@@ -362,7 +362,7 @@ static int tmp108_common_probe(struct device *dev, struct regmap *regmap, char *
 		return err;
 	}
 
-	tmp108->ready_time = jiffies;
+	tmp108->ready_time = get_jiffies_64();
 	if ((tmp108->orig_config & TMP108_CONF_MODE_MASK) ==
 	    TMP108_MODE_SHUTDOWN)
 		tmp108->ready_time +=
@@ -413,7 +413,7 @@ static int tmp108_resume(struct device *dev)
 
 	err = regmap_update_bits(tmp108->regmap, TMP108_REG_CONF,
 				 TMP108_CONF_MODE_MASK, TMP108_MODE_CONTINUOUS);
-	tmp108->ready_time = jiffies +
+	tmp108->ready_time = get_jiffies_64() +
 			     msecs_to_jiffies(TMP108_CONVERSION_TIME_MS);
 	return err;
 }
-- 
2.53.0



