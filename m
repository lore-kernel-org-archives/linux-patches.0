Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF2640EBAE;
	Mon, 17 Aug 2026 13:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974188; cv=none; b=ShGyIGR6q9Rjj69hQ3neq8w2P1LOmczXc6XtMVqeDaEYXIOnGUs2rGOgQu9FOvWrSXdmizLVioCriFgAeTdILxIXXbBLR5fhrJYK2nWIpUbZzClGBFADL7KFOGHd9rlUdJOzEs7faV9TDS+H5FZXZoz3oh4JclqTijjENfCtHYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974188; c=relaxed/simple;
	bh=9HNkmcKrzOFK3SJ9xk551Xl9nLO6o4bd3JpUtVW2WQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hnCXf8q6VQPZWv+zNmpou3rAKS8qSX/mAVk4u+mq02zYmmcQ8fPcv2iIc2vQ0YvC4JHImCh3m+E5mQfsQfdhqM+OIHdUwb3m2Vgf0PIeTJFwRhUprgw7Zp1Zp6gnmD5espvSxDeKY2dTXBRWAXs/fHKHXVL3h5baTMGHmhpFo4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwMWJ1Kx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwMWJ1Kx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC191F000E9;
	Mon, 17 Aug 2026 13:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974186;
	bh=CnaxELv5WYMFIGFPai7q0b+DUlfviD5MBjVvWOGiQ68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uwMWJ1Kx2mOMuBkx1AuYIZ/OYvt7NHSFxTbqxLA8I8eh6XnS718ZiOM3oKkXDZva/
	 gBVhIHEuo9mhp9zs6c9b4XF5o55MkSG6cL3Fbyzb1Iq2TzwmQpMHoup4bP9JV+3iI7
	 j5Vj1DnY4N8sX3yGtajIDX58fuIIg1NXog5IP2zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Nuno Sa <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 118/271] hwmon: (ltc4282) Avoid overflow in maximum power calculation
Date: Mon, 17 Aug 2026 15:30:43 +0200
Message-ID: <20260817132541.729411799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit edd11a94335747423569500a194c6eaa915f2963 ]

During device initialization in ltc4282_set_max_limits(), the calculation
of the maximum power limit can suffer from a 32-bit integer overflow.

static int ltc4282_set_max_limits(struct ltc4282_state *st)
{
    ...
    st->power_max = DIV_ROUND_CLOSEST(st->vsense_max * DECA * MILLI,
                                      st->rsense) * st->vfs_out;
    ...
}

The result of DIV_ROUND_CLOSEST() evaluates to a 32-bit unsigned integer
on 32-bit architectures. This result is then multiplied by st->vfs_out,
which is a 16-bit unsigned integer. According to C promotion rules, since
both operands are 32-bit or smaller, the multiplication is performed in
32-bit precision.

If the device is configured with a low sense resistor value via the device
tree (for example, 100 nano-ohms, resulting in st->rsense = 1) and the
voltage is high, the division result can reach 343,750,000 and st->vfs_out
can be 33,280. The product of these values is approximately 11.44 trillion,
which exceeds the maximum capacity of a 32-bit integer and overflows
before being stored in st->power_max.

This overflow causes a truncated value to be assigned to st->power_max and
written to the hardware limit register. An incorrect maximum power limit
can trigger spurious power-bad faults or alarms, which may lead to the
shutdown of the monitored power rail.

Avoid the problem by calculating and storing the maximum power using 64-bit
variables.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: cbc29538dbf7d ("hwmon: Add driver for LTC4282")
Cc: Nuno Sa <nuno.sa@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc4282.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/ltc4282.c b/drivers/hwmon/ltc4282.c
index bdbf370233d71..9ccad99f42e7f 100644
--- a/drivers/hwmon/ltc4282.c
+++ b/drivers/hwmon/ltc4282.c
@@ -138,7 +138,7 @@ struct ltc4282_state {
 	 */
 	struct ltc4282_cache in0_1_cache[LTC4282_CHAN_VGPIO];
 	u32 vsense_max;
-	long power_max;
+	s64 power_max;
 	u32 rsense;
 	u16 vdd;
 	u16 vfs_out;
@@ -614,13 +614,12 @@ static int ltc4282_read(struct device *dev, enum hwmon_sensor_types type,
 }
 
 static int ltc4282_write_power_byte(const struct ltc4282_state *st, u32 reg,
-				    long val)
+				    s64 val)
 {
 	u32 power;
 	u64 temp;
 
-	if (val > st->power_max)
-		val = st->power_max;
+	val = clamp(val, 0, st->power_max);
 
 	temp = val * int_pow(U8_MAX, 2) * st->rsense;
 	power = DIV64_U64_ROUND_CLOSEST(temp,
@@ -630,7 +629,7 @@ static int ltc4282_write_power_byte(const struct ltc4282_state *st, u32 reg,
 }
 
 static int ltc4282_write_power_word(const struct ltc4282_state *st, u32 reg,
-				    long val)
+				    u64 val)
 {
 	u64 temp = int_pow(U16_MAX, 2) * st->rsense, temp_2;
 	__be16 __raw;
@@ -1223,7 +1222,8 @@ static int ltc4282_set_max_limits(struct ltc4282_state *st)
 		return ret;
 
 	/* Power is given by ISENSE * Vout. */
-	st->power_max = DIV_ROUND_CLOSEST(st->vsense_max * DECA * MILLI, st->rsense) * st->vfs_out;
+	st->power_max = DIV_ROUND_CLOSEST_ULL((u64)st->vsense_max * DECA * MILLI,
+					      st->rsense) * st->vfs_out;
 	ret = ltc4282_write_power_byte(st, LTC4282_POWER_MAX, st->power_max);
 	if (ret)
 		return ret;
-- 
2.53.0



