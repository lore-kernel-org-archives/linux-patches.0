Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270C842F71B;
	Mon, 17 Aug 2026 14:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977994; cv=none; b=rINVm4QakHQAUW6esTVO35WdoB+OzBsiJD8PfAMuSU9eCzc2/Ahhas8M5tz1Q1K2R06G6tY1M9jkirYHm5E7crJJ4Rx9vNyM21u1DWUtBWmSNflpOHg/Ixt/qNycUO7ZShQkfDwgiVPu0ztoI8+Oyh+jzxUkQsPvsD6xx+jqF68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977994; c=relaxed/simple;
	bh=uapAlYTO2I6Bg4Le5pUbWIY2QqZy4J8ULbQq9PwBfDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CnfoysbuTa7nrNSUot9HyBlt61FckUCd0K/D6B2fOiFndrerL4jhEgCbJ1/t8T6bDJsviKlv5ND0pttH7xpM1cx3ExoSEaFwS2RqAufvpcCOd/40JqfJtxV4IQTgCJjrnatdpKV885wbOnucm2Gdje8VZMV44wieXfOmzGhQ0pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOA7iGtd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOA7iGtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802F11F000E9;
	Mon, 17 Aug 2026 14:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977993;
	bh=a9FMedJesJYpHje0uarp5zFlXmbocN0ZOfmzKS+r2kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOA7iGtdU9vqcJmoSpUk6g5THpzxI5bcjnb6XC8zkCeMWMjMnewTZAWoVE0dLs4CR
	 TJmtCJFSB9mfhpkuLpkAA7saMsRaLddzzACgQDuNSFKZcczbdYzf/1x3S23uwakzMF
	 ic0UgqvhmY9PzQQHICyEdVzE77PtrV3kkQE0xcWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Nuno Sa <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/181] hwmon: (ltc4282) Avoid overflow in maximum power calculation
Date: Mon, 17 Aug 2026 15:32:38 +0200
Message-ID: <20260817132537.945269645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e1c0d02b564b7..93e08bde29aa9 100644
--- a/drivers/hwmon/ltc4282.c
+++ b/drivers/hwmon/ltc4282.c
@@ -142,7 +142,7 @@ struct ltc4282_state {
 	 */
 	struct ltc4282_cache in0_1_cache[LTC4282_CHAN_VGPIO];
 	u32 vsense_max;
-	long power_max;
+	s64 power_max;
 	u32 rsense;
 	u16 vdd;
 	u16 vfs_out;
@@ -621,13 +621,12 @@ static int ltc4282_read(struct device *dev, enum hwmon_sensor_types type,
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
@@ -637,7 +636,7 @@ static int ltc4282_write_power_byte(const struct ltc4282_state *st, u32 reg,
 }
 
 static int ltc4282_write_power_word(const struct ltc4282_state *st, u32 reg,
-				    long val)
+				    u64 val)
 {
 	u64 temp = int_pow(U16_MAX, 2) * st->rsense, temp_2;
 	__be16 __raw;
@@ -1254,7 +1253,8 @@ static int ltc4282_set_max_limits(struct ltc4282_state *st)
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



