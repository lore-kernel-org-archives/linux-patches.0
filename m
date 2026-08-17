Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB50144239A;
	Mon, 17 Aug 2026 13:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974951; cv=none; b=kqVogkbKePkyHEII+0lAunrgHdpNCDyokmC78KGRg3UmYVAlECYMJKpqwzRI+14txXgT3l2MGWcDNuEgtiW9Foc1swwBuD2TcejmDE1DAT8CN7fxi0VmgvlvhieLeSMjYVx1pXVca5CAx1mX8pAV+PYqdUqEhFZy+OjUnOfTwew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974951; c=relaxed/simple;
	bh=aVKZ9gI3b8RJo+36EDctX6IrbIO0aIaPgNMQrfmwcYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A7q9s0QnetQoJXKg+EcnH/gRJKKozgrAbmM+WzUl9eD9otGCqLF3TCtVQ5ea0vHhqwzwAQwJyoKwBQZm8cZsLv0pKcpYYsC1FfH13TY2H1sXo1+3/ozpsYYmyLFD8wc9egdXC5owlk+3XwlQH8arHQkdHBK+vNDtyw5glnmP0Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hlldOPT9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hlldOPT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F0C1F00A3A;
	Mon, 17 Aug 2026 13:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974944;
	bh=8nomYCuqIZBRZEcKX63FHE+WKuFrvfHPg1+UKYj/P34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hlldOPT9Ah8k24A+/SKctp/R2mKu4hMDL5V+EHVc5PhiKWaY7MgnnFPM9ZIpQmfMh
	 PCxX9+6xXUXiNdtZFU8XSqPUupc+FDXL+KZ6RDwCCd+WR/Ewc8fTuAAFyzlRz4SF5j
	 zKIVvIlgoq9EX+z4zsn+EzlTHZNmhMpmCdf498qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Nuno Sa <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/250] hwmon: (ltc4282) Avoid overflow in maximum power calculation
Date: Mon, 17 Aug 2026 15:31:08 +0200
Message-ID: <20260817132540.910534543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4000bcbc7353d..e5ea1db83da47 100644
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
@@ -623,13 +623,12 @@ static int ltc4282_read(struct device *dev, enum hwmon_sensor_types type,
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
@@ -639,7 +638,7 @@ static int ltc4282_write_power_byte(const struct ltc4282_state *st, u32 reg,
 }
 
 static int ltc4282_write_power_word(const struct ltc4282_state *st, u32 reg,
-				    long val)
+				    u64 val)
 {
 	u64 temp = int_pow(U16_MAX, 2) * st->rsense, temp_2;
 	__be16 __raw;
@@ -1256,7 +1255,8 @@ static int ltc4282_set_max_limits(struct ltc4282_state *st)
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



